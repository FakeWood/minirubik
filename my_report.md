# Assignment 1: Optimizations and RISC-V Assembly

## Version Information

- Ripes
  - Software: Ripes-v2.2.6-106-g5b8a616-win-x86_64
  - Model: Single-cycle processor
- minirubik
  - Forked commit: 3811ad0

## Stage 1: Characterize the Baseline

### State Representation

`solver.c` models the cube as two arrays: the **permutation** (which cubie sits in each position) and the **orientation** (how each cubie is twisted).

A 2×2×2 cube has 8 corner cubies, labeled 0–7, and each cubie has one of 3 orientations, labeled 0–2. For example, permutation `01234567` with orientation `00000000` is the solved cube.

Whole-cube rotations do not change the puzzle, so we can fix one cubie's position and orientation. This leaves 7 cubies, each with a position and an orientation.

Furthermore, the sum of all orientations must be 0 (mod 3), so the last orientation is determined by the other six. A state therefore needs only 7 numbers for the permutation and 6 numbers for the orientation.

### Ranking

Storing those 13 numbers directly makes the state space unnecessarily large. For example, the permutation

```
7 7 7 7 7 7 7
```

is representable, but it is not a legal permutation, since every cubie must appear exactly once. A naive radix encoding would cover $7^7 \times 3^6$ codes, most of them illegal.

Instead, `solver.c` maps each state to a **rank**:

$$
\text{rank} \in [0,\ 3{,}674{,}160), \qquad 3{,}674{,}160 = 7! \times 3^6 = 5040 \times 729
$$

Every rank decodes to exactly one legal state, and every legal state has exactly one rank. `solver.c` builds this dense bijection with the Lehmer code (factorial number system) for the permutation and base 3 for the orientation:

$$
\text{rank} = p \times 729 + o, \qquad p \in [0, 5040),\ o \in [0, 729)
$$

### Search

With states encoded, the solver runs a breadth-first search (BFS) outward from the solved state, applying all 9 moves (R, B, D, each as a quarter turn, half turn, or inverse) until every state has been reached. For each state, it records the inverse of the move that first reached it, which is one move toward solved. To solve a scrambled cube, it starts from the given state and follows those recorded moves back to the solved state.

### Invariants

- We fix one cubie's position and orientation, since R, B, and D turns never move the FUL cubie, and there is only one permutation of the other 7 cubies for the solved cube, so 7 numbers are enough for the position. By observation, the total orientation change of every move is divisible by 3, so the sum of orientations must always be divisible by 3. The 7th cubie's orientation can therefore be calculated from the other 6 cubies, so 6 numbers are enough for the orientation.
- State and rank form a bijective dense mapping, and a move performed in state space has an equivalent move in rank space. That is to say, state A (rank A') → move (move') → state B (rank B'), so we can use `permutation[3][PERMUTATIONS]` and `orientation[3][ORIENTATIONS]` to perform state changes directly on ranks.
- Every move has an inverse move that undoes it, so we can retrieve the path back to the solved state.
- A move changes position and orientation independently: the new permutation depends only on the old permutation, and the new orientation depends only on the old orientation. So we can use two separate tables to store moves, reducing the entries needed from 3 × 5040 × 729 to 3 × (5040 + 729).
- BFS visits states level by level (all states at distance d before any at d + 1). This guarantees that the first time a state is reached is along a shortest path.
- `build_table` checks that BFS visited 3,674,160 states after the process. Since BFS visits each state only once, this guarantees that all states are visited and reachable from the solved state.

### Memory Consumption

This is where the memory cost comes from.

- **BFS queue.** Each state expands into 9 neighbors that must be visited later, so BFS needs a queue. `solver.c` uses a linear queue with one 32-bit rank per state: $3{,}674{,}160 \times 4$ B $= 14{,}696{,}640$ B ≈ 14.016 MiB (heap).
- **Move table.** The one-move-toward-solved table stores 8 bits per state: $3{,}674{,}160 \times 1$ B ≈ 3.504 MiB (heap).
- **Transition tables.** To avoid decoding and re-encoding states during the search, `solver.c` precomputes how each quarter turn changes the permutation rank and the orientation rank, stored as two separate tables because the two parts change independently. Half and inverse turns apply the quarter turn 2 or 3 times. With 16-bit entries, this is $3 \times (7! + 3^6) \times 2$ B $= 34{,}614$ B ≈ 33.803 KiB (stack).

| Buffer | Bytes | Size |
| --- | ---: | ---: |
| BFS queue | 14,696,640 | 14.016 MiB |
| Move table | 3,674,160 | 3.504 MiB |
| Transition tables | 34,614 | 33.803 KiB |
| **Peak total** | **18,405,414** | **17.553 MiB** |

The memory cost mostly rely on the queue. So it is the optimize target.

### Time Cost Centers

- **Building the transition tables:** calls `unrank_state`, `quarter_turn`, and `rank_state` $O(\text{FACES} \times (\text{PERMUTATIONS} + \text{ORIENTATIONS}))$ times, since we treat permutation and orientation separately.
- **BFS loop:** visits all 3,674,160 states, and each state has to perform 9 moves. So 3,674,160 × 9 × 2 tables = 66,134,880 transition updates, which can be heavy when run on the guest simulator, since guest memory is sparse host memory.
  We also separate `p` and `o` using `/` and `%` for all 3,674,160 states, and use `*` to combine them back 9 times per state. That is 3,674,160 `/` and `%` each, and 33,067,440 `*`, which is heavy in this homework: RV32I has no multiply or divide instructions, so we have to do them manually.
  We also read `toward_solved[there]` on each move, which is 33,067,440 scattered reads. So the BFS is the critical part.
- **Answering the query (`main`):** at most 11 steps, since the diameter is 11.
- **`self_test`:** does not run on a normal run.
- **`valid`:** $O(\text{CUBIES})$. Not critical.
- **`parse_state`:** runs only once, on the input string. Not critical.
- **`output_failed`:** runs only on failure. Not relevant here.

## Stage 2: Redesign for The Target

## Stage 3: Improve Efficiency in C

## Stage 4: RV32I Assembly

## Concept

## Implementation

### C code

### Assembly code

## Analysis

## Reference
