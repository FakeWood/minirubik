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

```text
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

### Cayley Graph

By the definition of a [Cayley graph](https://mathworld.wolfram.com/CayleyGraph.html):

> A Cayley graph associated with $(G, S)$, ++where $G$ is a group and $S \subseteq G$ is a connection set with identity element $I \notin S$, is the directed graph having one vertex for each group element and directed edges $(g, h)$ whenever $gh^{-1} \in S$++. The Cayley graph may depend on the choice of a generating set, and is connected iff $S$ generates $G$ (i.e., the set $S$ are group generators of $G$).
>
> Care is needed since the term "Cayley graph" is also used when $S$ is implicitly understood to be a set of generators for the group, in which case the graph is always connected.

- **$G = \langle R, B, D \rangle$ is a group:**
  - **Closure:** no matter how you move, the result is still a sequence of R, B, D turns. E.g., `R B` followed by `B` is `R B B`, another sequence of R, B, D turns.
  - **Identity:** the empty sequence of R, B, D turns, which does nothing, is the identity.
  - **Inverses:** every sequence of moves has an inverse sequence that cancels its effect and produces no change: do the inverse moves in reverse order. E.g., $(R\,B\,D)^{-1} = D'\,B'\,R'$.
  - **Associativity:** no matter how you group the moves inside an ordered sequence, the result is the same.
- **Stabilizer:** we choose FUL to be the fixed cubie, and $\langle R, B, D \rangle$ is the stabilizer of FUL: R, B, and D never turn a face containing FUL, so they leave FUL unchanged. Conversely, the BFS in `solver.c` reaches all 3,674,160 states with FUL fixed, so no FUL-fixing state is missing from $\langle R, B, D \rangle$.
- **Order of $G$:** $|G| = 7! \cdot 3^6 = 3{,}674{,}160$, which matches one vertex per state. The order is discussed in the "Invariants" section, where we calculate that there are 3,674,160 states and each of them is reachable by BFS.
- **Connected:** since $S$ generates $G$, the graph is connected. `solver.c` also checks that all states are reachable, which confirms it.
- **$S \subseteq G$:** we choose the 9 HTM turns as the generators $S$ of $G$ for our graph. We can get all 9 turns from $\langle R, B, D \rangle$, e.g., `R2` = `R R` and `R'` = `R R R`, and R, B, D are themselves among the 9 turns. So both generate the same $G$.
- **$I \notin S$:** there is no "don't move" among the 9 HTM turns.
- **One vertex for each group element:** Once an element of $G$ is applied to the solved state, each element of $G$ corresponds to a legal state, which means that state can be reached from the solved state by moves. Suppose we don't fix the FUL corner and all 6 faces may turn. Since whole-cube rotations look the same in the real world, a move can produce the same result as another move seen from a different perspective of the cube. E.g., L and R' give the same result up to a whole-cube rotation. This violates the definition of one vertex for each group element, and the graph becomes a Schreier coset graph instead, which would complicate moves and encoding. So we fix FUL to get a Cayley graph rather than a Schreier coset graph.
- **Directed edges $(g, h)$ whenever $gh^{-1} \in S$:** each HTM move is a directed edge that links two states. If there is an edge $g \to h$, there is also an edge $h \to g$, since every move has an inverse move. So the distance from solved to $s$ is the same as from $s$ to solved. This is the property `solver.c` uses to run BFS from the solved state and retrieve the path from the given state.
- **Diameter:** The diameter of the HTM graph is 11 so all the states can be reached within 11 HTM moves. This is proved by the BFS in `solver.c`, which checks every state's shortest distance and finds that the deepest level is 11 and no state needs more moves. See [Pocket Cube](https://www.jaapsch.net/puzzles/cube2.htm#numpos) to get more information.
  > The number of positions that can be reached in n moves from the start, but which cannot be reached in fewer than n moves:
  > - HTM: 1, 9, 54, 321, 1847, 9992, 50136, 227536, 870072, 1887748, 623800, 2644
  > - QTM: 1, 6, 27, 120, 534, 2256, 8969, 33058, 114149, 360508, 930588, 1350852, 782536, 90280, 276

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

### Ripes Measurements

This section test the Ripes Simulator perfomance.
We focus on Speed (retired-instructions-per-second rate) and memory (retired-instructions-per-second rate).

Benchmarks are run with `RV32_ISS` and `RV32_5S` models.

#### Speed

- benchmark: bench_speed.s
  - A simple loops that swap two addresses' value.

##### RV32_ISS

- Expected `--iret`: 6 × 20,480,000 + 7 = 122,880,007
- test command: `.\Ripes.exe --mode cli --src ..\minirubik\bench_speed.s -t asm --proc "RV32_ISS" --iret --exectime --output runN_iss.txt`

| Runs | Measured `--iret` | Time (s) | Rate (instr/s) |
| --- | ---: | ---: | ---: |
| #1 | 122,880,007 | 11.759 | 10.45 million |
| #2 | 122,880,007 | 11.818 | 10.40 million |
| #3 | 122,880,007 | 11.932 | 10.30 million |
| Average (mean of the rates) | - | - | 10.38 million |

##### RV32_5S

- Expected `--iret`: 6 × 409,600 + 7 = 2,457,607
- test command: `.\Ripes.exe --mode cli --src ..\minirubik\bench_speed.s -t asm --proc "RV32_5S" --iret --exectime --output runN_5s.txt`

| Runs | Measured `--iret` | Time (s) | Rate (instr/s) |
| --- | ---: | ---: | ---: |
| #1 | 2,457,607 | 14.459 | 169.97 thousand |
| #2 | 2,457,607 | 14.476 | 169.77 thousand |
| #3 | 2,457,607 | 14.674 | 167.48 thousand |
| Average (mean of the rates) | - | - | 169.07 thousand |

#### Memory

There are two builds of the benchmark: a small-memory one and a large-memory one. We subtract them to get the real amount of host memory used by the guest bytes the assembly writes.
`PeakWorkingSet64` is the property used in the test script `measure_mem.ps1` to get the peak memory usage during the run. Although it counts all pages in RAM, including shared DLL pages, those cancel out in the subtraction.

##### RV32_ISS

| Run | Small (bytes) | Large (bytes) |
| --- | ---: | ---: |
| #1 | 25,264,128 | 108,892,160 |
| #2 | 24,940,544 | 108,937,216 |
| #3 | 25,010,176 | 108,949,504 |
| Average | 25,071,616 | 108,926,293 |

- Difference in guest bytes written: (1 MiB + 4 KiB) − 4 KiB = 1 MiB = 1,048,576 bytes
- Average memory usage over 3 runs for SMALL: 25,071,616 bytes
- Average memory usage over 3 runs for LARGE: 108,926,293 bytes
- Delta: 83,854,677 bytes ≈ 79.97 MiB
- Ratio: 83,854,677 / 1,048,576 ≈ 79.97 ≈ 80

The host-bytes-per-guest-byte ratio is around 80, so the 18,405,414-byte peak of `solver.c` would cost about 1.37 GiB of host memory.

## Stage 2: Redesign for The Target

- Constraint: optimality, 128 KiB, no full distance table, search on the target, no heap/recursion/FP/M

### 1. Naive DFS

Plain DFS that backtracks when it reaches depth 11 without solving the cube.

- static data ≤ 128 KiB: ✅
  - a few dozen bytes for `source`, `twist` and `move_names`
- Optimality: ❌
  - Returns the first path it found.
- Retired instructions ≤ $5 \times 10^7$: ❌
  - Worst case is the whole tree, $\sum_{d=1}^{11} 9^d \approx 3.5\times10^{10}$ nodes

### 2. IDDFS

Iterative deepening tries depth limits 0, 1, …, 11 in order. Like BFS, it finishes each depth before the next one, but like DFS, it keeps only one path in memory. This ensures the found path is the shortest.

- static data ≤ 128 KiB: ✅
  - a few dozen bytes for `source`, `twist` and `move_names`
- Optimality: ✅
  - Returns the first path it found. Because it tries depth limits in order, the first found path is the shortest.
- Retired instructions ≤ $5 \times 10^7$: ❌
  - IDDFS re-searches the shallower levels on every pass. For a depth-11 state:
    - Lower bound (limits 0–10 fully searched): $\sum_{L=1}^{10}\sum_{d=1}^{L} 9^d \approx 4.4\times10^{9}$ node
    - Worst case: $\sum_{L=1}^{11}\sum_{d=1}^{L} 9^d \approx 4.0\times10^{10}$ node

### 3. Same-face Pruning

After a move on face f, any next move on f either cancels it or merges into one move. For example, `R` `R` = `R2`, `R` `R2` = `R'` and `R` `R'` does nothing. So we can skip these kinds of moves and reduce the nodes at no cost.

Here we add same-face pruning on top of the previous IDDFS approach: after the first move, only the 6 moves on the other two faces are tried, so depth $d$ has $9\cdot6^{d-1}$ nodes instead of $9^d$.

- static data ≤ 128 KiB: ✅
  - a few dozen bytes for `source`, `twist` and `move_names`
- Optimality: ✅
  - Two consecutive moves on the same face can always be merged into one move or removed, so a path containing them is never a shortest path. Pruning only removes such paths, so the shortest path is never pruned.
- Retired instructions ≤ $5 \times 10^7$: ❌
  - About 50× fewer nodes than plain IDDFS, but still far over the budget. A search with limit $L$ visits $N(L)=\sum_{d=1}^{L} 9\cdot6^{d-1}=\frac{9}{5}(6^L-1)$ nodes. For a depth-11 state:
    - Lower bound (limits 0–10 fully searched): $\sum_{L=1}^{10} N(L) \approx 1.3\times10^{8}$
    - Worst case: $\sum_{L=1}^{11} N(L) \approx 7.8\times10^{8}$ node
  - Measured nodes:

    | Distance | State | Nodes |
    | ---: | --- | ---: |
    | 8 | `62345713133111` | 1,149,862 |
    | 8 | `24316572122213` | 1,567,270 |
    | 8 | `25713642221111` | 686,310 |
    | 9 | `24513763133333` | 14,156,521 |
    | 9 | `43752611332133` | 5,056,836 |
    | 10 | `25416373331111` | 39,971,573 |
    | 11 | `21345671111111` | 163,549,347 |

## Stage 3: Improve Efficiency in C

## Stage 4: RV32I Assembly

## Concept

## Implementation

### C code

### Assembly code

## Analysis

## Reference
