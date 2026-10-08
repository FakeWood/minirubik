#!/bin/sh
# Cost per call of each search-core function on Ripes. Run in WSL from the
# minirubik folder:  sh bench.sh
#
# For each BENCH in bench.c: compile to RV32I assembly, clean it up for Ripes,
# run it on RV32_ISS, and read "instructions retired". Cost per call is
# (retired - retired of BENCH=0) / N.
set -e

RV_CC=${RV_CC:-riscv64-unknown-elf-gcc}
RIPES=${RIPES:-../Ripes-v2.2.6-106-g5b8a616-win-x86_64/Ripes.exe}
PROC=${PROC:-RV32_ISS}
N=1024 # must match N in bench.c
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

retired() {
    "$RV_CC" -march=rv32i -mabi=ilp32 -O2 -std=c99 -ffreestanding \
        -msmall-data-limit=0 -mno-explicit-relocs -DBENCH="$1" \
        -S bench.c -o "$TMP/gcc.s"
    python3 gcc2ripes.py "$TMP/gcc.s" > "$TMP/bench.s"
    # Ripes is a Windows program: give it a Windows path, and pipe its
    # output, which it does not write to the terminal directly.
    "$RIPES" --mode cli --src "$(wslpath -w "$TMP/bench.s")" -t asm \
        --proc "$PROC" --iret --timeout 600000 | tail -1 | tr -d '\r'
}

base=$(retired 0)
printf '%-12s %10s %10s\n' function retired per-call
printf '%-12s %10s %10s\n' baseline "$base" -
for b in 1 2 3 4 5; do
    case $b in
    1) name=apply_move ;;
    2) name=rank_orient ;;
    3) name=rank_perm ;;
    4) name=rank_r_face ;;
    5) name=heuristic ;;
    esac
    r=$(retired $b)
    awk -v n="$name" -v r="$r" -v b="$base" -v N="$N" \
        'BEGIN { printf "%-12s %10d %10.1f\n", n, r, (r - b) / N }'
done
