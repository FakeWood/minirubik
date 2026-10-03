# AI Use Log — HW1

Required by Guidelines §4.1 for material AI assistance: task, portion of work affected, and what happened to the output.
Claude fills in the first four columns. The last column is written by me only.

| Date | Tool | Task | Portion of work affected | What the AI produced | Outcome / my decision (accepted, rejected, modified, and why) |
|------|------|------|--------------------------|----------------------|---------------------------------------------------------------|
| 2026-10-03 | Claude Code | Set up AI-policy guardrails | `CLAUDE.md`, `.claude/` hooks, this log (tooling only, not submitted work) | Policy file, PreToolUse guard script, log template | accepted |
| 2026-10-03 | Claude Code | Refine my hand-written Stage 1 draft (commit fe9a7c9) | `my_report.md` Stage 1 section (HackMD analysis) | Rewrote English and added subheadings; corrected facts against `solver.c` | accepted |
| 2026-10-03 | Claude Code | Review my hand-written Stage 1 Invariants and Time Cost Centers sections over several drafts | `my_report.md` Stage 1: Invariants, Time Cost Centers (HackMD analysis) | Explained concepts in general terms (invariants, correctness gates, cost centers); gave feedback on each draft pointing out errors and missing points as questions (e.g. fixed corner is not LFD, table-build loops run over 5040 + 729 not all states, `*` and `toward_solved` reads run per move not per state, `parse_state`/`valid` do run); spelling/grammar and Markdown formatting pass on both sections; did not write the technical content of either section | Chat with AI to figure out what this part want me to do and complete it with AI guiding |
