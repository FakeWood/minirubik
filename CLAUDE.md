# AI usage policy for this repository (read before every task)

This repo is my Computer Architecture (Fall 2026) Homework 1 (minirubik → RV32I on Ripes).
It is governed by:

- Course AI guidelines: https://hackmd.io/@sysprog/arch2026-ai-guidelines
- HW1 spec: https://hackmd.io/@sysprog/2026-arch-homework1

HW1 is **AI-assisted**. Disclosure is required (Guidelines §4.1).

## Parts that are mine alone (never generate these)

The HW1 spec says these "must be your own and not generated":

1. The choice of state representation (cube encoding, ranking, packing)
2. The search design and its admissibility argument (heuristics, pattern databases, IDA* structure, pruning choices)
3. Every measurement I report (host-bytes-per-guest-byte, instructions per second, `--iret` counts, code size, table sizes, wall-clock time)
4. The optimization reasoning (what to change and why, branch vs. branchless, packing trade-offs)
5. The RV32I assembly (any `.s`/`.S` file, or assembly snippets meant for submission)
6. The analysis in my HackMD note

Also prohibited by the guidelines:

- Any image input: never read, fetch or ask for screenshots, photos or diagrams
- Writing my reflection, my disclosure, or the "what I decided" parts of the log (that risks misrepresenting my contribution, §3.2)
- Rewriting git history or dates, or staging commits to look incremental (§3.2)

## What Claude may do

- Explain concepts in general terms: RISC-V and RV32I semantics, Ripes usage, group theory background, how IDA* or pattern databases work *in general* (not designed for this cube)
- Help me debug code I wrote: point out where and why it is wrong. For assembly, describe the bug in words; I write the fix.
- Build tooling and checking code outside the protected parts, once I've confirmed a task is outside them (e.g. build scripts, Makefile targets, test harness plumbing)
- Generate test inputs (e.g. scrambles) when I ask
- Fix grammar and clarity in English text I already wrote, without changing the technical content
- Format and organize: Markdown structure, citations, outlines of headings
- Find sources (the papers and manuals in the spec's reference list)

## Grey areas: stop and ask

Ask before acting if a task touches any of these:

- C code that implements the search, heuristic tables, representation or move logic. Even "just translating my idea into C" can count as the search design or representation.
- Host-side gate checkers (H1–H4) whose output I will report
- Suggesting an optimization, rather than explaining one I named
- Anything I'd struggle to explain in the mock interview (§5)

## Stop-and-report protocol

If a requested action would break a rule above, **do not do it, and don't do part of it either**. Reply in this form and wait:

```
⚠️ AI-policy stop
Action:   <what you were about to do>
Rule:     <which item above / which guideline section>
Instead:  <what I should do myself, or what you can do that is allowed>
```

If a hook in `.claude/hooks/ai-policy-guard.js` blocks a tool call, report it the same way. Never route around a hook with another tool or a shell command.

## Use log

After any **material** help (anything that changes the substance of my work), add a row to `AI_USAGE.md`: date, task, the portion of work it touched, and what you produced. Leave the "Outcome / my decision" column as `TODO (Wood)`. I fill that in myself. Don't log trivial things like typo fixes.

## Commits

Don't commit unless I ask. If I ask, add the `Co-Authored-By` trailer, so the history honestly shows the AI involvement.
