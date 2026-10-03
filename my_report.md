# Assignment 1: Optimizations and RISC-V Assembly

## Version Information

- Ripe
  - Software: Ripes-v2.2.6-106-g5b8a616-win-x86_64
  - Model: Single-cycle processor
- minirubik
  - forked commit: 3811ad0

## Stage 1: Characterize The Baseline

`solver.c` model the rubic as a set of number represent cubics permutation and oreientation.

0~7 represent 8 cubic and 0 ~ 3 represent each cubic's orientation.

For exampale, permutation 01234567 with orientation 00000000 represent a solved rubic.

and we can fix one cubic position and orientation so we got 7 positions and 7 orientations.

further more, since the last orientaion is determine by other 7 cubics, we can use 7 number for position and 6 number for orientation.

but the state space is unnessarly big

for example:

position: 7 7 7 7 7 7 7

is representable by state, but it is a illegal permutation

so `solver.c` use rank to represent a state.

where $$rank \belong[0, 3,674,160]$

each rank can be translate to a legal state and every legal state can be represent by a unique rank.

`solver.c` use Lehmer Code and Factoradic to do this Bijective dence mapping.

Now we have a way to encode the states. To solve a cubic from a scrambled one, we start from a solved one and apply all moves to get all possible state. And then we start from the given state and follow the inverse move to get back to the solved state.

and the memory comsumption comes.

while apply 9 moves to current state, we got 9 more state to apply move. So we have to maintain a queue while computing all the possible state

`solver.c` use a linear queue which length is 3,674,160 and each state is represent by a rank, which is 32 bit. so the queue is about 14.016 MB

and to reduce the calculation while appling moves, `solver.c` precompute the move and use two map to record postion and orientation changes while different face move seperatly. And that is 3 * (7! + 3^6) * 16bit per move, about 33.803 KB.

and the a table record the inverse move for all 3674160 states is required.
so that is another 3674160 states * 8bit permove, about 3.504 MB

so it is totally arrond 17.553 MB

## Stage 2: Redesign for The Target

## Stage 3: Improve Efficiency in C

## Stage 4: RV32I Assembly

## Concept

## Implementation

### C code

### Assembly code

## Analysis

## Reference
