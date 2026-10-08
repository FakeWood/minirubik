"""Turn riscv64-unknown-elf-gcc -S output into a file the Ripes assembler takes.

Usage: python gcc2ripes.py in.s > out.s

Ripes accepts only .text/.data sections, labels, instructions and a few data
directives. This script:
  - prepends a start stub (call main, then the exit ecall), because Ripes
    starts executing at the first instruction of .text;
  - maps every code section to .text and every data section to .data;
  - rewrites .ascii/.string as .byte, since GCC packs byte tables as strings;
  - renames local labels .Lxxx to L_xxx, since Ripes takes a leading "."
    in an operand (such as a jump table's .word .L19) for a directive;
  - turns section anchors (.set .LANCHORn,. + 0) into plain labels;
  - replaces .align in .data by explicit .zero padding;
  - drops directives Ripes does not know (.file, .type, .size, ...).
"""
import re
import sys

DROP = {".file", ".option", ".attribute", ".ident", ".type", ".size",
        ".globl", ".local", ".comm", ".p2align"}
ESCAPES = {"n": 10, "t": 9, "r": 13, "b": 8, "f": 12, "\\": 92, '"': 34}


def string_bytes(literal):
    """Bytes of a GAS string literal body, escapes decoded."""
    out, i = [], 0
    while i < len(literal):
        c = literal[i]
        if c != "\\":
            out.append(ord(c))
            i += 1
            continue
        nxt = literal[i + 1]
        if nxt in "01234567":
            j = i + 1
            while j < len(literal) and j < i + 4 and literal[j] in "01234567":
                j += 1
            out.append(int(literal[i + 1:j], 8))
            i = j
        else:
            out.append(ESCAPES[nxt])
            i += 2
    return out


def main(path):
    lines = open(path, encoding="utf-8").read().splitlines()
    out = [".text", "_start:", "    call main", "    li a7, 10", "    ecall"]
    data, text = [], []
    section = text
    offset = 0  # bytes emitted to .data so far, for .align
    for raw in lines:
        line = raw.strip()
        # Ripes reads any token starting with "." as a directive, so a local
        # label used as an operand (.word .L19 in a switch jump table) fails.
        # Rename GCC's .Lxxx labels; string bodies are left alone.
        if not re.match(r"\.(ascii|string)\b", line):
            line = re.sub(r"(?<![\w.])\.L(\w+)", r"L_\1", line)
        if not line:
            continue
        word = line.split()[0]
        if word in (".text",) or line.startswith(".section\t.text"):
            section = text
            continue
        if word in (".data", ".bss") or line.startswith(".section"):
            section = data
            continue
        if word in DROP:
            continue
        m = re.match(r"\.set\s+(\S+),\s*\.\s*\+\s*0$", line)
        if m:
            section.append(m.group(1) + ":")
            continue
        if word == ".align":
            if section is data:
                size = 1 << int(line.split()[1])
                pad = -offset % size
                if pad:
                    data.append(f"    .zero {pad}")
                    offset += pad
            continue
        if word in (".ascii", ".string"):
            body = re.match(r'\.\w+\s+"(.*)"$', line).group(1)
            values = string_bytes(body) + ([0] if word == ".string" else [])
            for k in range(0, len(values), 16):
                chunk = ", ".join(map(str, values[k:k + 16]))
                section.append(f"    .byte {chunk}")
            offset += len(values) if section is data else 0
            continue
        if section is data:
            if word == ".zero":
                offset += int(line.split()[1])
            elif word == ".byte":
                offset += line.count(",") + 1
            elif word in (".half", ".2byte"):
                offset += 2 * (line.count(",") + 1)
            elif word in (".word", ".4byte"):
                offset += 4 * (line.count(",") + 1)
        # Pseudo-instructions GAS knows but Ripes does not: rd = rs > rt is
        # rd = rt < rs with the operands swapped.
        m = re.match(r"(sgtu?)\s+(\w+),\s*(\w+),\s*(\w+)$", line)
        if m:
            op = "sltu" if m.group(1) == "sgtu" else "slt"
            line = f"{op}\t{m.group(2)},{m.group(4)},{m.group(3)}"
        # lla (always PC-relative) is la in Ripes, which has no PIC.
        line = re.sub(r"^lla(?=\s)", "la", line)
        section.append(line if line.endswith(":") else "    " + line)
    out += text + [".data"] + data
    print("\n".join(out))


if __name__ == "__main__":
    main(sys.argv[1])
