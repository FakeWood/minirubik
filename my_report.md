# Assignment 1: Optimizations and RISC-V Assembly

## Version Information

- Ripes
  - Software: Ripes-v2.2.6-106-g5b8a616-win-x86_64
  - Model: RV32_ISS
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

### IDA\*

The retired instructions must stay below $5 \times 10^7$. At roughly 200 instructions per node (the estimate from the spec), that leaves room for about $2.5 \times 10^5$ nodes. The current 1.6×10⁸ nodes for a distance-11 state is about 650× too many, so we need to cut off hopeless branches as early as possible.

To do so we need a heuristic h(s), a lower bound on the number of moves still needed. A\* is the classic algorithm using f = g + h: it always expands the unexpanded node with the smallest f. To do that it keeps every generated-but-unexpanded node in an open list (a priority queue) and every expanded state in a closed set (usually a hash table). Both grow with the number of nodes, which needs a large memory pool without a heap. In the worst case the closed set approaches all 3,674,160 states, which is exactly the full table this assignment forbids.

So we use IDA\*. Like IDDFS it runs depth-limited DFS with limits 0, 1, 2, …, keeping only the current path on the stack, but it backtracks as soon as g + h(s) > limit. If h is admissible, i.e. h(s) ≤ d(s) for every state, a pruned branch could never reach the solved state within the limit, so the first solution found is still the shortest.

To design h(), we follow the direction given in the spec: a pattern database (PDB). A PDB ignores part of the state (for example, only the corner orientations) and stores the exact distance to solved in that smaller problem. Since ignoring information can only make the problem easier, the PDB value never exceeds the real distance, so h is admissible. The goal is a PDB small enough to fit in 128 KiB but strong enough to bring the node count down to the budget.

#### PDB 1: Orientation + Permutation

Two small tables, both generated on the host by `pdb_generator.c` (a BFS from solved over the relaxed problem) and linked in as read-only data:

| Table | Keeps | Ignores | Index | Entries | max h | mean h |
| --- | --- | --- | --- | ---: | ---: | ---: |
| `pdb_orient` | orientation of the 7 cubies | positions | first 6 orientations as base 3 (the 7th is implied by sum ≡ 0 mod 3) | 729 | 6 | 4.44 |
| `pdb_perm` | positions of the 7 cubies | orientations | Lehmer code of the permutation | 5,040 | 7 | 4.86 |

$h(s) = \max(\text{pdb\_orient}, \text{pdb\_perm})$. The max of two admissible bounds is still admissible. The sum is not, because every move changes both positions and orientations, so one move would be counted twice.

- static data ≤ 128 KiB: ✅
  - 5,769 B of PDB
- Optimality: ✅
  - Checked on the host by `pdb_check.c`: a full BFS gives the true distance $d(s)$ of all 3,674,160 states (host-only oracle, not shipped to the target), and $h(s) \le d(s)$ holds for every state (H1). All 2,644 distance-11 states are solved in exactly 11 moves.
- Retired instructions ≤ $5 \times 10^7$: ❌ (not yet measured on target, but likely over)
  - h is weak: on average it is 3.6 moves below the true distance, and up to 8 below.

    | $d-h$ | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
    | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
    | states | 17,108 | 83,910 | 377,894 | 1,107,100 | 1,416,753 | 591,000 | 77,589 | 2,738 | 68 |

  - Nodes over all 2,644 distance-11 states:

    | mean | max |
    | ---: | ---: |
    | 206,658 | 639,837 |

  - The worst state is `54721631111111`. At 200 instructions per node this is about $1.3 \times 10^8$ instructions, 2.6× over the budget. To pass with this table, a node would have to cost at most about 78 instructions.

#### PDB 2: R Face

PDB 1 is weak because each table throws away half of the state: `pdb_orient` does not know where the cubies are, `pdb_perm` does not know how they are twisted. A better abstraction keeps **both** position and orientation, but only for some of the cubies.

We track the four cubies of the R face, positions 1, 2, 4, 5 in the README numbering, which are cubies `{0, 1, 3, 4}` in the solver (the anchor at position 0 is dropped, so every label shifts down by 1). They are exactly the positions that `source[0]` (the R move) cycles. The other three cubies `{2, 5, 6}` are ignored completely.

- Placements: the 4 cubies sit in 4 distinct positions out of 7, $7 \cdot 6 \cdot 5 \cdot 4 = 840$
- Twists: each tracked cubie has 3 orientations, $3^4 = 81$ (the sum constraint involves all 7 cubies. We can not skip the 4th twists here)
- Table size: $840 \times 81 = 68{,}040$ entries, 1 byte each

The table is admissible for the same reason as PDB 1.

##### Change in ranking: follow the cubie, not the position

`rank_perm` asks, for each **position** $i$, which cubie is there, and encodes it as "how many cubies to the right of $i$ are smaller", which is the cubie's rank among the cubies not used yet. That works because all 7 positions are encoded.

With only 4 cubies tracked, there is no full sequence to look "to the right" of, so the direction is reversed. For each tracked **cubie** $k$ we ask which position it is in:

1. `where[cubie] = position` is built first as the inverse of `p[position] = cubie`, and `pos = where[r_cubies[k]]`.
2. The digit is not `pos` itself but $d_k = \text{pos} - \text{skip}$, where `skip` is the number of earlier tracked cubies ($j < k$) in a position below `pos`. So $d_k$ is the position counted among the positions not yet taken by `r_cubies[0..k-1]`, and $d_k < 7 - k$.
3. The digits form a mixed-radix number with bases 7, 6, 5, 4, and the four twists are appended in base 3:

$$\text{place} = ((d_0 \cdot 6 + d_1) \cdot 5 + d_2) \cdot 4 + d_3, \qquad \text{rank} = \text{place} \times 81 + \text{turned}$$

The solved state is no longer index 0. Its placement digits are $(0, 0, 1, 1)$, so its rank is $5 \times 81 = 405$. The BFS in `pdb_generator.c` now starts from `rank(solved)` instead of 0.

##### Result

$h(s) = \text{pdb\_r\_face}[\text{rank\_r\_face}(s)]$

| Table | Entries | max h | mean h |
| --- | ---: | ---: | ---: |
| `pdb_r_face` | 68,040 | 8 | 6.29 |

- static data ≤ 128 KiB: ✅
  - 68,040 B of PDB
- Optimality: ✅
  - `pdb_check.c`: $h(s) \le d(s)$ for all 3,674,160 states, and all 2,644 distance-11 states are solved in exactly 11 moves.
- Retired instructions ≤ $5 \times 10^7$: ❌ (estimated, not yet measured on target)
  - The mean gap $d - h$ drops from 3.61 to 2.46, but the tail gets longer: up to 11, because a state whose R face is already solved gets $h = 0$ no matter how scrambled the other three cubies are.

    | $d-h$ | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
    | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
    | states | 170,071 | 537,081 | 1,225,146 | 1,106,114 | 479,349 | 125,387 | 25,242 | 4,651 | 921 | 166 | 29 | 3 |

  - Nodes over all 2,644 distance-11 states:

    | | mean | max |
    | --- | ---: | ---: |
    | PDB 1 | 206,658 | 639,837 |
    | R face | 121,174 | 857,595 |

  - The mean improves, but the worst case is worse than PDB 1. The worst state is still `54721631111111`: at 200 instructions per node, 857,595 nodes is about $1.7 \times 10^8$ instructions, 3.4× over the budget.

#### PDB 3: PDB 1 + PDB 2

PDB 1 and PDB 2 fail in different places. PDB 2 is blind when the R face is solved but the other three cubies are not, while PDB 1 sees all 7 cubies and still gives a non-zero bound there. So we take the max of all three tables:

$h(s) = \max(\text{pdb\_orient}, \text{pdb\_perm}, \text{pdb\_r\_face})$

Each table is admissible, so their max is admissible too.

- static data ≤ 128 KiB: ✅
  - 73,809 B of PDB (68,040 + 5,040 + 729), about 72.1 KiB
- Optimality: ✅
  - `pdb_check.c`: $h(s) \le d(s)$ for all 3,674,160 states, and all 2,644 distance-11 states are solved in exactly 11 moves.
- Retired instructions ≤ $5 \times 10^7$: ⚠️ (estimated, not yet measured on target)
  - The mean gap $d - h$ drops to 2.38, and the largest gap shrinks from 11 to 7:

    | $d-h$ | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
    | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
    | states | 173,321 | 549,253 | 1,260,501 | 1,161,347 | 455,846 | 70,358 | 3,455 | 79 |

  - Nodes over all 2,644 distance-11 states:

    | | mean | max |
    | --- | ---: | ---: |
    | PDB 1 | 206,658 | 639,837 |
    | PDB 2 (R face) | 121,174 | 857,595 |
    | PDB 3 (both) | 30,050 | 203,475 |

  - Combining them cuts the max by 3.1× over PDB 1 and 4.2× over PDB 2: the two tables cover each other's worst states. The worst state is still `54721631111111`. At 200 instructions per node, 203,475 nodes is about $4.1 \times 10^7$ instructions, under the budget with only about 20% margin. Each node now does three ranks and three lookups, so the real cost per node has to be measured on the target.

PDB 3 seems feasible so we'll take it and try to turn it into assembly code.

## Stage 3: Improve Efficiency in C

### Remove Unsupported Instructions

First, we have to take out every operation RV32I cannot execute natively. When the compiler meets a `*`, `/` or `%` that RV32I has no instruction for, it emits a call to a libgcc helper (`__mulsi3`, `__udivsi3`, `__umodsi3`, ...), and it may also emit `memcpy` for struct copies. None of these exist on Ripes. So we link the search core alone (`rv32i_check.c`, which only includes `search.h`) without libgcc or libc, and let the linker report every helper it cannot find:

```sh
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -O2 -std=c99 \
    -ffreestanding -nostdlib -e solve rv32i_check.c -o /dev/null
```

And without surprise there are some. Compiling with `-fno-inline` shows where each one comes from:

```sh
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -O2 -std=c99 -ffreestanding -fno-inline \
  -S rv32i_check.c -o - \
  | awk '/^[a-zA-Z_0-9]+:/{f=$1} /call|tail/ && $2 ~ /^(__|mem)/{print f, $2}' \
  | sort | uniq -c
```

| function | helper | source |
| --- | --- | --- |
| `dls` | `__udivsi3` ×2 | `move / 3U` in same-face pruning |
| `apply_move` | `__udivsi3`, `__umodsi3` | `move / 3U`, `move % 3U` |
| `quarter_turn` | `__umodsi3` | `(o + twist) % 3U` |
| `rank_perm` | `__mulsi3` | `rank * (CUBIES - i)` |
| `rank_r_face` | `__mulsi3` | `place * (CUBIES - k)` |
| `dls`, `apply_move`, `quarter_turn`, `iddfs` | `memcpy` | `state_t` passed and returned by value |

Multiplications by a constant (`* 3U` in `rank_orient`, `* 81U` in `rank_r_face`) do not appear. This is probably because GCC rewrites them as shifts and adds. We check this by the assembly code:

```sh
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -O2 -fno-inline -S rv32i_check.c -o - \
  | awk '/^rank_r_face:/,/\.size\trank_r_face/'
```

```asm
    sub   a0,s2,s1        # a0 = 7 - k  (s2 = 7, s1 = k)
    ...
    call  __mulsi3        # place * (CUBIES - k): variable, so a libcall
    ...
    slli  a5,s11,1        # turned * 2
    add   a5,a5,s11       # turned * 3
    add   s11,a3,a5       # turned * 3 + o[pos]
    ...
    slli  a5,a1,2         # place * 4
    add   a5,a5,a1        # place * 5
    slli  a5,a5,4         # place * 80
    add   a5,a5,a1        # place * 81
    ...
    add   a0,a5,s11       # place * 81 + turned
```

Next, we need to remove them.

#### 1. One Table Row per Move

`apply_move` used to call `quarter_turn` 1, 2 or 3 times, with `move % 3U + 1U` turns on face `move / 3U`. Each quarter turn is a full pass over the 7 cubies, so R' moved 21 cubies to produce a 7-cubie result.

Instead, the `source` and `twist` tables now have one row per move instead of one per face. Each row is the face's quarter turn composed 1, 2 or 3 times, generated by running the old `apply_move` on a solved cube with every cubie tagged by its position. Composing twists is just adding them mod 3, so the twist a row adds does not depend on the incoming orientations, and one row is enough.

```c
static void apply_move(state_t *out, const state_t *in, uint8_t move)
{
    const uint8_t *src = source[move], *tw = twist[move];
    for (uint8_t i = 0; i < CUBIES; ++i) { ... }
}
```

| | passes over cubies | `/`, `%` on `move` |
| --- | ---: | ---: |
| before | 7, 14 or 21 | 2 |
| after | 7 | 0 |

#### 2. Mod 3 by Conditional Subtract

Both terms of `in->o[from] + tw[i]` are below 3, so the sum is at most 4 and needs at most one subtraction of 3:

```c
uint32_t o = (uint32_t) in->o[from] + tw[i];
out->o[i] = (uint8_t) (o - (3U & -(uint32_t) (o >= 3U)));
```

`o >= 3U` is 1 or 0, and its negation is all ones or all zeros, so the mask picks 3 or 0. In RV32I this is `sltiu`, `sub`, `andi`, `sub`: four instructions and no branch, instead of one `__umodsi3` call per cubie. GCC still turns the mask back into a branch (`sltiu` + `bne`) in its own output, so the branchless form has to be kept by hand in Stage 4.

#### 3. Same-face Pruning Without Division

The old check `move / 3U == path[depth - 1] / 3U` divided twice for every move tried. The moves of one face are numbered together (R R2 R' = 0 1 2, B B2 B' = 3 4 5, D D2 D' = 6 7 8), so the face only needs its first move number, which a 9-byte table gives:

```c
static const uint8_t face_start[MOVES] = {0, 0, 0, 3, 3, 3, 6, 6, 6};
```

When `dls` goes one level deeper it stores `skip[depth] = face_start[move]`. At the new level, when the next move to try equals `skip[depth]`, it jumps 3 moves ahead and passes over the whole face in one comparison. The root has `skip[0] = MOVES`, which no move equals, so nothing is skipped there.

| per depth | divisions | comparisons for the same face |
| --- | ---: | ---: |
| before | 2 per move tried, up to 18 | 3 |
| after | 0 | 1 |

#### 4. Constant Radices in the Ranks

`rank_perm` and `rank_r_face` multiply by `CUBIES - i`, which is a variable inside the loop but actually predictable, so we do the loop manually with fixed (7, 6, 5, 4, 3, 2).
We first collect the digits in a loop and then write the Horner steps out, one constant per line:

```c
uint32_t rank = c[0];
rank = (rank << 2) + (rank << 1) + c[1]; /* * 6 */
rank = (rank << 2) + rank + c[2];        /* * 5 */
rank = (rank << 2) + c[3];               /* * 4 */
rank = (rank << 1) + rank + c[4];        /* * 3 */
rank = (rank << 1) + c[5];               /* * 2 */
```

`rank_r_face` does the same for radices 6, 5, 4, and its `* 3U` and `* 81U` are written as shifts:

$$81p = 64p + 16p + p = (p \ll 6) + (p \ll 4) + p$$

#### 5. No Struct Copies

`apply_move`, `quarter_turn`, `dls` and `iddfs` took and returned `state_t` by value, and GCC copies a 14-byte struct with `memcpy`. They now take pointers, and `apply_move` writes the child straight into `stack[depth + 1]`. The only copy left is the start state into `stack[0]`, done field by field once per `dls` call.

#### Result: No Helpers Left

- `rv32i_check.c` now links with `-nostdlib`: no helper and no `memcpy` is left in the search core.
- The search itself is unchanged, so every count must be exactly the same as before:
  - `pdb_generator.c` rebuilt with the new `cube.h` produces a `pdb.h` identical byte for byte.
  - `pdb_check.c` prints the same output as before: H1 admissible, all 2,644 distance-11 states solved in 11 moves, nodes max 203,475.

### Improve Efficiency

At about 620 instructions per node the search is still 2.5× over the budget (see [Unsupported Instructions Removed](#unsupported-instructions-removed)), so first we find where those 620 go.

#### Where the Work Is

`search_stats.c` is a copy of `dls` with counters added and the cutoff split per table, so it expands exactly the same nodes. It counts on the host what `dls` does for the worst state `54721631111111`:

```sh
make search_stats && ./search_stats
```

| event | count |
| --- | ---: |
| loop iterations | 237,379 |
| nodes (`apply_move` + `heuristic`) | 203,475 |
| pops (a level runs out of moves) | 33,902 |
| goal tests (`is_solved`) | 2 |

Every node costs one `apply_move` and one `heuristic`, i.e. three ranks and three lookups. Pops and goal tests are rare, so the per-node functions are what we need to measure.

#### Cost per Call on Ripes

`bench.c` calls one function 1,024 times in a loop, picked at compile time with `-DBENCH=n`:

| `BENCH` | loop body |
| --- | --- |
| 0 | read one byte (baseline) |
| 1 | `apply_move` |
| 2 | `rank_orient` |
| 3 | `rank_perm` |
| 4 | `rank_r_face` |
| 5 | `heuristic` |

- The inputs cycle through 16 states, each scrambled by two moves from the previous one, so data-dependent paths (such as the mod-3 branch) are exercised rather than one fixed state.
- Results are summed into `acc` and stored to a `volatile` variable, and an empty `asm volatile("" ::: "memory")` sits in the loop, so GCC cannot drop the calls or hoist them out of the loop.
- Each build goes through the same path as `ripes_main.s` (`riscv64-unknown-elf-gcc -O2 -S`, `gcc2ripes.py`, Ripes `RV32_ISS --iret`).
- Cost per call = (iret of `BENCH=n` − iret of `BENCH=0`) / 1024. Subtracting the baseline removes setup, scrambling, the loop itself and the exit.

`bench.sh` runs all six builds and prints the table below:

```sh
sh bench.sh
```

| `BENCH` | retired | per call |
| --- | ---: | ---: |
| 0 | 13,620 | — |
| 1 `apply_move` | 143,412 | 126.8 |
| 2 `rank_orient` | 52,536 | 38.0 |
| 3 `rank_perm` | 262,453 | 243.0 |
| 4 `rank_r_face` | 189,752 | 172.0 |
| 5 `heuristic` | 487,248 | 462.5 |

`heuristic` (462.5) is the three ranks (453) plus three lookups and two maxes. Per node:

| part | instructions | share |
| --- | ---: | ---: |
| `rank_perm` | 243 | 39% |
| `rank_r_face` | 172 | 28% |
| `apply_move` | 127 | 20% |
| `rank_orient` | 38 | 6% |
| lookups, max, `dls` loop, `++nodes` | ~40 | 6% |
| total | ~620 | |

This matches the full run, 126,147,427 / 203,475 ≈ 620, so the per-call numbers add up.

#### Which Table Cuts

Every node computes all three ranks, but one table above the threshold $t = \text{limit} - \text{depth} - 1$ is already enough to cut. `search_stats` also checks each table against $t$ on its own. Over the 203,475 nodes of the worst state:

| table | nodes it would cut alone |
| --- | ---: |
| `pdb_orient` | 62,076 (31%) |
| `pdb_perm` | 111,841 (55%) |
| `pdb_r_face` | 143,552 (71%) |
| none (node expanded) | 33,903 (17%) |

So 83% of the nodes are cut, and for most of them at least one of the three ranks was not needed.

The two ranks that cost the most, `rank_perm` and `rank_r_face`, are two thirds of every node, so they come first.

#### Unroll Fixed Loops

`rank_perm` compiled by GCC spends most of its time in the inner loop, 8 instructions per comparison, of which only 3 do the work:

```asm
.L12:
    add   a3,a0,a4      # address p + j: RV32I has no base + index addressing
    lbu   a3,0(a3)      # load p[j]                      (work)
    addi  a4,a4,1       # ++j                            (loop)
    andi  a2,a4,0xff    # j is uint8_t, truncate to 8 bits
    sltu  a3,a3,a6      # p[j] < p[i]                    (work)
    add   a5,a5,a3      # smaller += ...                 (work)
    andi  a5,a5,0xff    # smaller is uint8_t, truncate
    bne   a2,a1,.L12    # j != 7                         (loop)
```

The overhead comes from three things RV32I does not do cheaply:

- **Loop control**: every iteration pays a counter update and a branch, even though the trip count is fixed.
- **Variable index**: loads and stores only take base + constant offset, so `p[j]` needs an `add` first. With a constant index, the offset goes straight into `lbu`.
- **8-bit locals**: RV32I has no 8-bit ALU, so every add on a `uint8_t` is followed by `andi 0xff`.

On top of that, digits stored to an array (`c[]`, `d[]`) make a round trip through memory, a store and a load each, where a register would do.

All loops in the ranks have fixed trip counts, so we write them out and keep every local in a `uint32_t` register.

##### `rank_perm`

The 7 ids are loaded once, and each of the 21 comparisons becomes one `sltu` and one `add`:

```c
uint32_t p0 = p[0], p1 = p[1], ..., p6 = p[6];
uint32_t c0 = (p1 < p0) + (p2 < p0) + (p3 < p0) + (p4 < p0) + (p5 < p0) + (p6 < p0);
uint32_t c1 = (p2 < p1) + (p3 < p1) + (p4 < p1) + (p5 < p1) + (p6 < p1);
...
uint32_t c5 = (p6 < p5);
```

| | loads | per comparison | branches |
| --- | ---: | ---: | ---: |
| before | 6 `p[i]` + 21 `p[j]` + 6 `c[]` = 33 | 8 | 27 |
| after | 7 | 2 | 0 |

That is about 7 + 21 × 2 = 49 instructions for the digits plus the Horner steps. The compiled function is 60 instructions long, straight-line, with no branch.

##### `rank_r_face`

`where[]` still has to go through memory: finding which position holds a cubie means indexing by a variable. But the 7 stores now have constant values, the 4 tracked positions `where[0]`, `where[1]`, `where[3]`, `where[4]` are read at constant offsets, and the nested loop for the digits becomes 6 `sltu` and 6 `sub`:

```c
uint32_t w0 = where[0], w1 = where[1], w3 = where[3], w4 = where[4];
uint32_t d1 = w1 - (w0 < w1);
uint32_t d2 = w3 - (w0 < w3) - (w1 < w3);
uint32_t d3 = w4 - (w0 < w4) - (w1 < w4) - (w3 < w4);
```

Only the 4 twists `o[w]` still need an `add` before the `lbu`, since `w` is a variable.

##### Result: Unrolled Ranks

`sh bench.sh` after each change:

| per call | start | `rank_perm` unrolled | `rank_r_face` unrolled |
| --- | ---: | ---: | ---: |
| `apply_move` | 126.8 | 126.8 | 126.8 |
| `rank_orient` | 38.0 | 38.0 | 38.0 |
| `rank_perm` | 243.0 | **56.0** | 56.0 |
| `rank_r_face` | 172.0 | 172.0 | **76.0** |
| `heuristic` | 462.5 | 274.5 | 191.0 |

And the full search on the worst state (`ripes_main.s`, `RV32_ISS`):

| | retired | per node | vs. budget |
| --- | ---: | ---: | ---: |
| start | 126,147,427 | ≈ 620 | 2.52× |
| `rank_perm` unrolled | 90,776,690 | ≈ 446 | 1.82× |
| `rank_r_face` unrolled | 72,145,525 | ≈ 355 | 1.44× |

The search is unchanged: `pdb.h` regenerates byte for byte, `pdb_check` prints the same output, and Ripes still prints the same 11 moves and 203,475 nodes. Still 1.44× over, so each node has to lose about 110 more instructions.

#### Lazy Cutoff

Currently `dls` computes all three tables and takes the max as h. But it does not need the exact h, only whether h is large enough to cut the child. Since h is the largest of the three, h is large enough as soon as any one table is. So we can look up one table at a time, and once one of them says the child should be cut, skip the others.

This happens a lot: as [Which Table Cuts](#which-table-cuts) shows, 83% of the nodes are cut, most of them by more than one table.

##### Which Table First

The order matters. A table that cuts often saves the later ranks, but a cheap table costs less when it fails. To compare orders, `search_stats` sorts every node by the set of tables that would cut it (8 classes), and from that computes how many times each rank runs in each order. Given the cost per call from `bench.sh` (orient 38, perm 56, r_face 76), it also prints the rank cost per node:

```sh
./search_stats 54721631111111 38 56 76
```

```text
lazy order               rank calls: 1st      2nd      3rd   rank cost per node
orient  perm    r_face            203475   141399    71279                103.5
orient  r_face  perm              203475   141399    52503                105.3
perm    orient  r_face            203475    91634    71279                 99.7
perm    r_face  orient            203475    91634    38188                 97.4
r_face  orient  perm              203475    59923    52503                101.6
r_face  perm    orient            203475    59923    38188                 99.6
```

perm → r_face → orient is the cheapest, at 97.4 against 170 (38 + 56 + 76) for computing all three. r_face cuts the most (71%) but perm is cheaper, and after perm has cut its 55% only 45% of the nodes still need r_face. orient goes last: it is cheap but cuts the least, and only 19% of the nodes reach it.

The best order depends on the state: for `21345671111111`, r_face → perm → orient is best (98.6, against 102.4 for perm first). The difference is about 2%, and the budget is about the worst state, so we take perm → r_face → orient.

```c
static int exceeds(const state_t *state, int t)
{
    if (pdb_perm[rank_perm(state)] > t)
        return 1;
    if (pdb_r_face[rank_r_face(state)] > t)
        return 1;
    return pdb_orient[rank_orient(state)] > t;
}
```

`dls` calls `exceeds(&stack[depth + 1], limit - depth - 1)` instead of computing `heuristic`. The full $h$ is now only needed by the H1 check, so `heuristic` moved into `pdb_check.c`, and `BENCH=5` was dropped from `bench.c`.

These are branches added on purpose: each one skips at least one rank (38 to 76 instructions) when taken, while the max it replaces cost two compares anyway.

##### Result: Lazy Cutoff

| | retired | per node | vs. budget |
| --- | ---: | ---: | ---: |
| ranks unrolled | 72,145,525 | ≈ 355 | 1.44× |
| lazy cutoff | 52,368,301 | ≈ 257 | 1.05× |

Each node saves about 97 instructions, a bit more than the 73 (170 − 97.4) predicted from the ranks alone, because the three lookups and the two maxes of the full `heuristic` went away too.

`pdb_check` still prints the same output (H1 admissible, all 2,644 distance-11 states solved in 11 moves, max 203,475 nodes): the cutoff decides exactly as before, only with less work. Each node still has to lose about 12 instructions to fit the budget.

## Stage 4: RV32I Assembly

### Unsupported Instructions Removed

Let's use GCC to generate assembly and run it on Ripes to see how many instructions we have to cut per node.

```sh
make ripes_main.s
```

Ripes has no `argv` and no libc, so `ripes_main.c` fixes the worst state `54721631111111` in the code, calls `iddfs`, and prints the length, the moves and the node count with Ripes' `ecall`s instead of `printf`. GCC's assembly output does not assemble in Ripes as is, so `gcc2ripes.py` cleans it up:

- prepends `_start` (`call main`, then exit with `ecall` 10), since Ripes starts at the first instruction of `.text`
- maps every section to `.text` or `.data`, and rewrites `.ascii`/`.string` tables as `.byte`
- turns `.set .LANCHORn,. + 0` into labels and `.align` into `.zero` padding
- rewrites `sgtu` as `sltu` with swapped operands, and `lla` as `la`
- compiles with `-mno-explicit-relocs`, because Ripes treats `%lo(sym)` as unsigned and rejects any low part above 2047

Now we can run `ripes_main.s` on Ripes.

```sh
Ripes.exe --mode cli --src ripes_main.s -t asm --proc RV32_ISS --iret --timeout 600000 | cat
```

```text
11: 4 2 3 2 8 3 1 3 0 3 8
203475

Program exited with code: 0
===== instructions retired
126147427
```

The moves are B2 R' B R' D' B R2 B R B D', the same as the host solver, and the node count matches too.

| | value |
| --- | ---: |
| retired instructions | 126,147,427 |
| budget | 50,000,000 |
| nodes | 203,475 |
| instructions per node | ≈ 620 |
| budget per node | ≈ 245 |

Removing the helpers is not enough: the search is still about 2.5× over the budget, so each node has to drop from about 620 to under 245 instructions.

## Concept

## Implementation

### C code

### Assembly code

## Analysis

## Reference
