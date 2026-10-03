#!/usr/bin/env node
// PreToolUse guard for the Computer Architecture (Fall 2026) AI guidelines
// and the HW1 AI-assisted regime. Blocks the clear-cut violations
// deterministically; judgment calls are covered by CLAUDE.md.
//
// deny -> the tool call is refused and the reason is shown to Claude,
//         which must then stop and tell the user.
// ask  -> the user is prompted to approve or reject.

let raw = "";
process.stdin.on("data", (c) => (raw += c));
process.stdin.on("end", () => {
  let input;
  try {
    input = JSON.parse(raw);
  } catch {
    process.exit(0);
  }
  const tool = input.tool_name || "";
  const ti = input.tool_input || {};
  const verdict = check(tool, ti);
  if (verdict) {
    process.stdout.write(
      JSON.stringify({
        hookSpecificOutput: {
          hookEventName: "PreToolUse",
          permissionDecision: verdict.decision,
          permissionDecisionReason:
            `[AI POLICY] ${verdict.reason} ` +
            "Do not try to work around this. Stop and tell the user which rule applies, and leave the action to them.",
        },
      })
    );
  }
  process.exit(0);
});

const ASM = /\.(s|S|asm)$/;
const ASM_IN_CMD = /\.(s|S|asm)\b/;
const IMAGE = /\.(png|jpe?g|gif|bmp|webp|heic|heif|tiff?|ico)(\?.*)?$/i;
const WRITE_OPS =
  /(>|\btee\b|sed\s+-i|perl\s+-[a-z]*i|\bcp\b|\bmv\b|\bdd\b|\btruncate\b|Set-Content|Add-Content|Out-File|Copy-Item|Move-Item|New-Item|WriteAllText)/;

// Drop heredoc bodies and quoted strings so that text merely mentioned
// (e.g. in a commit message) is not mistaken for a command being run.
function stripLiterals(cmd) {
  return cmd
    .replace(/<<-?\s*(['"]?)(\w+)\1[^\n]*\n[\s\S]*?\n\s*\2[ \t]*(?=\n|$)/g, "<<HEREDOC")
    .replace(/@'[\s\S]*?'@|@"[\s\S]*?"@/g, "''")
    .replace(/'([^']*)'|"((?:[^"\\]|\\.)*)"/g, (m, a, b) => {
      // Keep a single-line quoted path (e.g. "C:\Program Files\Ripes\Ripes.exe")
      // as one token so the invoked program is still recognised.
      const s = a !== undefined ? a : b;
      return /[\\/]/.test(s) && !/\n/.test(s) ? s.replace(/\s/g, "_") : "''";
    });
}

// True if any command segment invokes a program whose basename matches re.
function invokes(cmd, re) {
  return cmd.split(/&&|\|\||[;|\n&]/).some((seg) => {
    const tokens = seg.trim().split(/\s+/).filter((t) => !/^\w+=/.test(t));
    const prog = (tokens[0] || "").split(/[\\/]/).pop();
    return re.test(prog);
  });
}

function check(tool, ti) {
  // 1. RV32I assembly must be hand-written (HW1 AI regime).
  if (["Write", "Edit", "MultiEdit", "NotebookEdit"].includes(tool)) {
    const p = ti.file_path || ti.notebook_path || "";
    if (ASM.test(p)) {
      return {
        decision: "deny",
        reason: `Writing or editing assembly (${p}) is prohibited: HW1 requires "the RV32I assembly" to be the student's own work.`,
      };
    }
  }

  // 2. No image input to AI tools (Guidelines §1, Prohibited).
  if (tool === "Read" && IMAGE.test(ti.file_path || "")) {
    return {
      decision: "deny",
      reason: `Reading an image (${ti.file_path}) is prohibited: the guidelines forbid submitting screenshots, photos, or any image input to an AI tool.`,
    };
  }
  if (tool === "WebFetch" && IMAGE.test(ti.url || "")) {
    return {
      decision: "deny",
      reason: `Fetching an image (${ti.url}) is prohibited: no image input to AI tools.`,
    };
  }

  if (tool === "Bash" || tool === "PowerShell") {
    const cmd = stripLiterals(ti.command || "");

    // 3. Assembly written through the shell instead of Edit/Write.
    if (ASM_IN_CMD.test(cmd) && WRITE_OPS.test(cmd)) {
      return {
        decision: "deny",
        reason: "This command appears to create or modify an assembly file; the RV32I assembly must be hand-written by the student.",
      };
    }

    // 4. Falsifying process evidence (Guidelines §3.2).
    if (
      /GIT_(AUTHOR|COMMITTER)_DATE|--date[= ]|commit\s+.*--amend|\brebase\b|filter-branch|filter-repo|push\s+.*(--force|-f\b)|reset\s+--hard/.test(cmd)
    ) {
      return {
        decision: "deny",
        reason: "Rewriting git history or commit dates is prohibited: it can count as falsifying process evidence (Guidelines §3.2).",
      };
    }

    // 5. Reported measurements must be the student's own (HW1 AI regime).
    if (invokes(cmd, /^ripes(\.exe|\.appimage)?$/i) || /(^|\s)--iret\b/.test(cmd)) {
      return {
        decision: "deny",
        reason: 'Running Ripes or collecting --iret counts is prohibited for Claude: HW1 requires "every measurement you report" to be the student\'s own.',
      };
    }

    // 6. Commits are process evidence; the student decides what goes in.
    if (/\bgit\s+(commit|push)\b/.test(cmd)) {
      return {
        decision: "ask",
        reason: "Commits are process evidence under Guidelines §4.2. Confirm you want Claude to make this commit; AI-assisted content should be disclosed.",
      };
    }
  }
  return null;
}
