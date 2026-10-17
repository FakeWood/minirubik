# Optimal 2x2x2 solver for Ripes, RV32I only: IDA* with the three pattern
# databases of Stage 2 and the Stage 3 optimizations (written-out moves, lazy
# orientations, lazy cutoff perm -> r_face -> orient, unrolled ranks).
#
# Input: the list at `tests` below, one 16-byte record per state: the state
# string (PPPPPPPOOOOOOO, as my_solver.c) with its NUL, then the expected
# distance (255: not known). An empty string ends the list.
# Output, per state: the state, the moves, the node count, the self check
# and the length check; then whether every test passed.
#
# Ripes evaluates .equ symbols wrongly as load/store offsets, so every offset
# below is a literal number; the layout tables say what each one means. Its
# print-string ecall also prints the terminating NUL, so strings go out one
# character at a time (print_str).
#
# State slot (16 bytes, stack[d] = stack + 16 d):
#     0..6   p[0..6]    cubie at each position
#     7      0          padding, never written
#     8..14  o[0..6]    orientation at each position
#     15     0          padding, never written
# The child of the slot at s2 is the next slot, so its p is at 16(s2) and its
# o at 24(s2).
#
# Block D (s3), all per-depth arrays indexed by depth (s8 = D + depth):
#     0   next[12]       next move to try at each depth
#     16  skip[12]       first move of the face turned just before (9: none)
#     32  path[12]       move taken at each depth
#     48  plus[3][3]     plus[t][o] = (o + t) mod 3
#     64  face_start[9]  first move of each move's face
#     80  where[8]       rank_r_face scratch: where[cubie] = position
#     96  jt_perm[9]     move_perm block of each move (words)
#     132 jt_orient[9]   move_orient block of each move (words)
#
# Registers kept through the search:
#     s0  limit            s5  pdb_r_face        s8  D + depth
#     s2  &stack[depth]    s6  pdb_orient        s9  nodes (for checking)
#     s3  D                s7  t = limit - depth - 1
#     s4  pdb_perm         s10 9 (MOVES)
#     a0  current move; t0..t6 the child's p[0..6] after move_perm.
#
# Renderer: lines starting with "#R " are the LED matrix renderer. This file
# is the CLI build used for --iret and code size: they stay comments, and
# RENDER is 0. `make my_solver_led.s` uncomments them and sets RENDER to 1;
# nothing else differs. Ripes has no .if, and the LED_MATRIX_0_* symbols only
# exist once the LED Matrix peripheral (35 x 25) is added in the GUI, so the
# CLI build cannot even contain a guarded reference to them.
.equ RENDER, 0
#R .equ DELAY, 200000          # busy-wait per frame, to see each move

.text
main:
    la   s3, D
    la   s4, pdb_perm
    la   s5, pdb_r_face
    la   s6, pdb_orient
    li   s10, 9
    la   s11, tests

# One state per record at s11.
next_test:
    lbu  t0, 0(s11)
    beqz t0, done            # empty string: end of the list
    mv   a0, s11
    jal  ra, print_str       # the state
    li   a0, 10
    li   a7, 11
    ecall
    li   s9, 0

# Parse the 14 digits into stack[0]: p[i] = state[i] - '1', o[i] =
# state[7 + i] - '1'. The input is trusted; my_solver.c validates it.
    mv   t0, s11
    la   t1, stack
    li   t2, 7
parse:
    lbu  t3, 0(t0)
    addi t3, t3, -49
    sb   t3, 0(t1)
    lbu  t3, 7(t0)
    addi t3, t3, -49
    sb   t3, 8(t1)
    addi t0, t0, 1
    addi t1, t1, 1
    addi t2, t2, -1
    bnez t2, parse

# Iterative deepening: limit = 0, 1, ..., 11. The first limit with a
# solution is the optimal length.
    li   s0, 0
deepen:
    la   s2, stack
    mv   s8, s3
    addi s7, s0, -1          # t = limit - 0 - 1
    sb   zero, 0(s8)         # next[0] = 0
    sb   s10, 16(s8)         # skip[0] = 9: the root skips no face

# Depth-limited DFS with an explicit stack, as dls() in search.h.
loop:
    bltz s7, at_limit        # depth == limit <=> t == -1
    lbu  a0, 0(s8)           # move = next[depth]
    lbu  a1, 16(s8)          # skip[depth]
    bne  a0, a1, no_skip
    addi a0, a0, 3           # same face as the last move: jump the face
no_skip:
    bgeu a0, s10, pop        # all moves tried
    addi a1, a0, 1
    sb   a1, 0(s8)           # next[depth] = move + 1
    sb   a0, 32(s8)          # path[depth] = move
    addi s9, s9, 1           # ++nodes

# move_perm: child p = parent p permuted by the move.
    slli a1, a0, 2
    add  a1, a1, s3
    lw   a1, 96(a1)          # jt_perm[move]
    jr   a1
perm_done:

# rank_perm on t0..t6, the child's p[0..6]. The 21 comparisons ci (cubies
# after position i with a smaller id) are added straight into the
# Horner sum ((((c0*6 + c1)*5 + c2)*4 + c3)*3 + c4)*2 + c5.
    sltu a1, t1, t0          # c0
    sltu a2, t2, t0
    add  a1, a1, a2
    sltu a2, t3, t0
    add  a1, a1, a2
    sltu a2, t4, t0
    add  a1, a1, a2
    sltu a2, t5, t0
    add  a1, a1, a2
    sltu a2, t6, t0
    add  a1, a1, a2
    slli a2, a1, 2           # * 6
    slli a1, a1, 1
    add  a1, a1, a2
    sltu a2, t2, t1          # + c1
    add  a1, a1, a2
    sltu a2, t3, t1
    add  a1, a1, a2
    sltu a2, t4, t1
    add  a1, a1, a2
    sltu a2, t5, t1
    add  a1, a1, a2
    sltu a2, t6, t1
    add  a1, a1, a2
    slli a2, a1, 2           # * 5
    add  a1, a1, a2
    sltu a2, t3, t2          # + c2
    add  a1, a1, a2
    sltu a2, t4, t2
    add  a1, a1, a2
    sltu a2, t5, t2
    add  a1, a1, a2
    sltu a2, t6, t2
    add  a1, a1, a2
    slli a1, a1, 2           # * 4
    sltu a2, t4, t3          # + c3
    add  a1, a1, a2
    sltu a2, t5, t3
    add  a1, a1, a2
    sltu a2, t6, t3
    add  a1, a1, a2
    slli a2, a1, 1           # * 3
    add  a1, a1, a2
    sltu a2, t5, t4          # + c4
    add  a1, a1, a2
    sltu a2, t6, t4
    add  a1, a1, a2
    slli a1, a1, 1           # * 2
    sltu a2, t6, t5          # + c5
    add  a1, a1, a2
    add  a1, a1, s4
    lbu  a1, 0(a1)           # pdb_perm[rank]
    blt  s7, a1, loop        # cut: pdb > t

# move_orient: only now that perm has not cut. Uses a1..a7 only, so the
# child's p stays in t0..t6.
    slli a1, a0, 2
    add  a1, a1, s3
    lw   a1, 132(a1)         # jt_orient[move]
    jr   a1
orient_done:

# rank_r_face. where[cubie] = position, from t0..t6 (p[i] = ti).
    add  a1, s3, t0
    sb   zero, 80(a1)        # where[p[0]] = 0
    li   a2, 1
    add  a1, s3, t1
    sb   a2, 80(a1)
    li   a2, 2
    add  a1, s3, t2
    sb   a2, 80(a1)
    li   a2, 3
    add  a1, s3, t3
    sb   a2, 80(a1)
    li   a2, 4
    add  a1, s3, t4
    sb   a2, 80(a1)
    li   a2, 5
    add  a1, s3, t5
    sb   a2, 80(a1)
    li   a2, 6
    add  a1, s3, t6
    sb   a2, 80(a1)
    lbu  a1, 80(s3)          # w0 = where[0]
    lbu  a2, 81(s3)          # w1 = where[1]
    lbu  a3, 83(s3)          # w3 = where[3]
    lbu  a4, 84(s3)          # w4 = where[4]
# place = ((w0*6 + d1)*5 + d2)*4 + d3, dk = wk minus earlier ones below it.
    sltu a5, a1, a2
    sub  a6, a2, a5          # d1
    slli a7, a1, 2
    slli a5, a1, 1
    add  a7, a7, a5          # w0 * 6
    add  a7, a7, a6
    sltu a5, a1, a3
    sub  a6, a3, a5
    sltu a5, a2, a3
    sub  a6, a6, a5          # d2
    slli a5, a7, 2           # * 5
    add  a7, a7, a5
    add  a7, a7, a6
    sltu a5, a1, a4
    sub  a6, a4, a5
    sltu a5, a2, a4
    sub  a6, a6, a5
    sltu a5, a3, a4
    sub  a6, a6, a5          # d3
    slli a7, a7, 2           # * 4
    add  a7, a7, a6          # place
# turned = ((o[w0]*3 + o[w1])*3 + o[w3])*3 + o[w4], child o at 24(s2).
    add  a1, a1, s2
    add  a2, a2, s2
    add  a3, a3, s2
    add  a4, a4, s2
    lbu  a1, 24(a1)
    lbu  a2, 24(a2)
    lbu  a3, 24(a3)
    lbu  a4, 24(a4)
    slli a5, a1, 1
    add  a1, a1, a5
    add  a1, a1, a2
    slli a5, a1, 1
    add  a1, a1, a5
    add  a1, a1, a3
    slli a5, a1, 1
    add  a1, a1, a5
    add  a1, a1, a4          # turned
# rank = place * 81 + turned = (place << 6) + (place << 4) + place + turned
    slli a5, a7, 6
    slli a6, a7, 4
    add  a5, a5, a6
    add  a5, a5, a7
    add  a5, a5, a1
    add  a5, a5, s5
    lbu  a5, 0(a5)           # pdb_r_face[rank]
    blt  s7, a5, loop

# rank_orient: o[0..5] of the child as a base-3 number.
    lbu  a1, 24(s2)
    lbu  a2, 25(s2)
    lbu  a3, 26(s2)
    lbu  a4, 27(s2)
    lbu  a5, 28(s2)
    lbu  a6, 29(s2)
    slli a7, a1, 1
    add  a1, a1, a7
    add  a1, a1, a2
    slli a7, a1, 1
    add  a1, a1, a7
    add  a1, a1, a3
    slli a7, a1, 1
    add  a1, a1, a7
    add  a1, a1, a4
    slli a7, a1, 1
    add  a1, a1, a7
    add  a1, a1, a5
    slli a7, a1, 1
    add  a1, a1, a7
    add  a1, a1, a6
    add  a1, a1, s6
    lbu  a1, 0(a1)           # pdb_orient[rank]
    blt  s7, a1, loop

# Not cut: descend into the child.
    addi s2, s2, 16
    addi s8, s8, 1
    addi s7, s7, -1
    sb   zero, 0(s8)         # next[depth] = 0
    add  a1, s3, a0
    lbu  a1, 64(a1)          # face_start[move]
    sb   a1, 16(s8)          # skip[depth]
    j    loop

pop:
    addi s2, s2, -16
    addi s8, s8, -1
    addi s7, s7, 1
    blt  s7, s0, loop        # depth >= 0 <=> t < limit
# This limit is exhausted: try the next one.
    addi s0, s0, 1
    li   t0, 12
    blt  s0, t0, deepen
    la   a0, msg_none
    jal  ra, print_str
    j    test_fail

# depth == limit: solved iff p = 0 1 2 3 4 5 6 and o = 0. The padding bytes
# 7 and 15 are always 0, so four word compares cover the slot.
at_limit:
    lw   t0, 0(s2)
    li   t1, 0x03020100
    bne  t0, t1, pop
    lw   t0, 4(s2)
    li   t1, 0x00060504
    bne  t0, t1, pop
    lw   t0, 8(s2)
    bnez t0, pop
    lw   t0, 12(s2)
    bnez t0, pop

# Found: print path[0..limit-1] as move names separated by spaces.
    li   s1, 0
print_move:
    beq  s1, s0, print_done
    beqz s1, no_space
    li   a0, 32              # ' '
    li   a7, 11
    ecall
no_space:
    add  t0, s3, s1
    lbu  t0, 32(t0)          # path[i]
    slli t0, t0, 2
    la   a0, names
    add  a0, a0, t0
    jal  ra, print_str
    addi s1, s1, 1
    j    print_move
print_done:
    li   a0, 10              # '\n'
    li   a7, 11
    ecall
    la   a0, msg_nodes
    jal  ra, print_str
    mv   a0, s9
    li   a7, 1
    ecall
    li   a0, 10
    li   a7, 11
    ecall

# T5: replay path[0..limit-1] on the state and check that it ends solved.
# This does not trust the search: the state is parsed again, and each move is
# its face's quarter turn (qt_src/qt_tw, the R, B, D rows of the table in
# cube.h) applied 1, 2 or 3 times in a loop, with a conditional subtract for
# mod 3, instead of the written-out move blocks.
    mv   t0, s11
    la   t1, chk
    li   t2, 7
vparse:
    lbu  t3, 0(t0)
    addi t3, t3, -49
    sb   t3, 0(t1)
    lbu  t3, 7(t0)
    addi t3, t3, -49
    sb   t3, 8(t1)
    addi t0, t0, 1
    addi t1, t1, 1
    addi t2, t2, -1
    bnez t2, vparse
    li   s1, 0
    li   t1, 3
vmove:
#R     jal  ra, render         # draw chk: the state, then each move's result
#R     li   t1, 3              # render clobbers t1
    beq  s1, s0, vcheck
    add  t0, s3, s1
    lbu  t0, 32(t0)          # path[i] = 3 face + turns - 1
    la   a1, qt_src
    la   a2, qt_tw
vface:                       # skip one 7-byte row per face; t0 = turns - 1
    blt  t0, t1, vturn
    addi t0, t0, -3
    addi a1, a1, 7
    addi a2, a2, 7
    j    vface
vturn:                       # tmp = quarter turn of chk
    la   a3, chk
    la   a4, tmp
    li   t2, 0
vcubie:
    add  t3, a1, t2
    lbu  t3, 0(t3)           # s = src[j]
    add  t3, a3, t3
    lbu  t4, 0(t3)           # chk.p[s]
    lbu  t5, 8(t3)           # chk.o[s]
    add  t6, a2, t2
    lbu  t6, 0(t6)           # tw[j]
    add  t5, t5, t6          # o + tw <= 4: one subtract is enough
    blt  t5, t1, vmod
    addi t5, t5, -3
vmod:
    add  t6, a4, t2
    sb   t4, 0(t6)           # tmp.p[j]
    sb   t5, 8(t6)           # tmp.o[j]
    addi t2, t2, 1
    li   t6, 7
    blt  t2, t6, vcubie
    lw   t2, 0(a4)           # chk = tmp
    sw   t2, 0(a3)
    lw   t2, 4(a4)
    sw   t2, 4(a3)
    lw   t2, 8(a4)
    sw   t2, 8(a3)
    lw   t2, 12(a4)
    sw   t2, 12(a3)
    addi t0, t0, -1
    bgez t0, vturn
    addi s1, s1, 1
    j    vmove
vcheck:                      # same solved test as at_limit
    la   t2, chk
    lw   t0, 0(t2)
    li   t1, 0x03020100
    bne  t0, t1, vfail
    lw   t0, 4(t2)
    li   t1, 0x00060504
    bne  t0, t1, vfail
    lw   t0, 8(t2)
    bnez t0, vfail
    lw   t0, 12(t2)
    bnez t0, vfail
    la   a0, msg_ok
    jal  ra, print_str
    j    vlength
vfail:
    la   a0, msg_fail
    jal  ra, print_str
    la   t0, fails
    lw   t1, 0(t0)
    addi t1, t1, 1
    sw   t1, 0(t0)

# Length check: the solution length is the limit s0, compared with the
# record's expected distance unless that is 255.
vlength:
    la   a0, msg_length
    jal  ra, print_str
    mv   a0, s0
    li   a7, 1
    ecall
    lbu  t0, 15(s11)         # expected distance
    li   t1, 255
    beq  t0, t1, test_end
    la   a0, msg_len_ok
    beq  t0, s0, test_said
test_fail:
    la   t0, fails
    lw   t1, 0(t0)
    addi t1, t1, 1
    sw   t1, 0(t0)
    la   a0, msg_len_fail
test_said:
    jal  ra, print_str
test_end:
    li   a0, 10              # blank line after each test
    li   a7, 11
    ecall
    ecall
    addi s11, s11, 16
    j    next_test

# All records done: report the number of failed checks.
done:
    la   t0, fails
    lw   a0, 0(t0)
    beqz a0, all_pass
    li   a7, 1
    ecall
    la   a0, msg_failed
    j    report
all_pass:
    la   a0, msg_pass
report:
    jal  ra, print_str
exit:
    li   a7, 10
    ecall

# print_str(a0): print the NUL-terminated string at a0 one character at a
# time. Ripes' print-string ecall (4) also prints the terminating NUL.
print_str:
    mv   t0, a0
    li   a7, 11
print_char:
    lbu  a0, 0(t0)
    beqz a0, print_end
    ecall
    addi t0, t0, 1
    j    print_char
print_end:
    ret

#R # render: draw chk on the LED matrix as an unfolded net, then wait DELAY.
#R # Net: U above F, then L F R B across, D below F. A face slot is 8 x 6
#R # pixels (2 x 2 facelets of 4 x 3) plus a 1-pixel separator, so the net
#R # is 4 * 9 - 1 = 35 wide and 3 * 7 - 1 = 20 tall. For each of the 24
#R # facelets: the cubie at its position and that cubie's twist o give the
#R # sticker's slot j = (k - o) mod 3 on the cubie, cface gives its face,
#R # palette its colour. No multiply: a row is reached by adding WIDTH * 4
#R # y times, and the 4 x 3 block walks +4 per column, +WIDTH * 4 per row.
#R render:
#R     la   a0, facelets
#R     la   a1, cface
#R     la   a2, palette
#R     la   a3, chk
#R     li   a4, 24
#R     li   a5, LED_MATRIX_0_WIDTH
#R     slli a5, a5, 2            # row stride in bytes
#R r_next:
#R     lbu  t0, 0(a0)            # position (0 = anchor)
#R     lbu  t1, 1(a0)            # slot k at that position
#R     li   t2, 0                # anchor: cubie 0, o = 0
#R     li   t3, 0
#R     beqz t0, r_slot
#R     add  t4, a3, t0
#R     lbu  t2, -1(t4)           # p[position - 1]
#R     addi t2, t2, 1            # solver cubie label + 1 = cface row
#R     lbu  t3, 7(t4)            # o[position - 1]
#R r_slot:
#R     sub  t1, t1, t3           # j = k - o, in -2..2
#R     bgez t1, r_face
#R     addi t1, t1, 3
#R r_face:
#R     slli t2, t2, 2
#R     add  t2, t2, a1
#R     add  t2, t2, t1
#R     lbu  t2, 0(t2)            # cface[cubie][j]
#R     slli t2, t2, 2
#R     add  t2, t2, a2
#R     lw   t2, 0(t2)            # colour
#R     lbu  t3, 2(a0)            # x
#R     lbu  t4, 3(a0)            # y
#R     li   t5, LED_MATRIX_0_BASE
#R     slli t3, t3, 2
#R     add  t5, t5, t3
#R r_row:                        # t5 += y * WIDTH * 4
#R     beqz t4, r_rows
#R     add  t5, t5, a5
#R     addi t4, t4, -1
#R     j    r_row
#R r_rows:
#R     li   t4, 3
#R r_fill:                       # one 4-pixel row of the facelet
#R     sw   t2, 0(t5)
#R     sw   t2, 4(t5)
#R     sw   t2, 8(t5)
#R     sw   t2, 12(t5)
#R     add  t5, t5, a5
#R     addi t4, t4, -1
#R     bnez t4, r_fill
#R     addi a0, a0, 4
#R     addi a4, a4, -1
#R     bnez a4, r_next
#R     li   t0, DELAY
#R r_wait:
#R     addi t0, t0, -1
#R     bnez t0, r_wait
#R     ret

# Move blocks, reached through jt_perm / jt_orient. Generated from the
# source/twist table in cube.h.
perm_R:                       # R: source 1 4 2 0 3 5 6
    lbu  t0, 1(s2)              # p[1]
    lbu  t1, 4(s2)              # p[4]
    lbu  t2, 2(s2)              # p[2]
    lbu  t3, 0(s2)              # p[0]
    lbu  t4, 3(s2)              # p[3]
    lbu  t5, 5(s2)              # p[5]
    lbu  t6, 6(s2)              # p[6]
    sb   t0, 16(s2)             # child p[0]
    sb   t1, 17(s2)             # child p[1]
    sb   t2, 18(s2)             # child p[2]
    sb   t3, 19(s2)             # child p[3]
    sb   t4, 20(s2)             # child p[4]
    sb   t5, 21(s2)             # child p[5]
    sb   t6, 22(s2)             # child p[6]
    j    perm_done

perm_R2:                       # R2: source 4 3 2 1 0 5 6
    lbu  t0, 4(s2)              # p[4]
    lbu  t1, 3(s2)              # p[3]
    lbu  t2, 2(s2)              # p[2]
    lbu  t3, 1(s2)              # p[1]
    lbu  t4, 0(s2)              # p[0]
    lbu  t5, 5(s2)              # p[5]
    lbu  t6, 6(s2)              # p[6]
    sb   t0, 16(s2)             # child p[0]
    sb   t1, 17(s2)             # child p[1]
    sb   t2, 18(s2)             # child p[2]
    sb   t3, 19(s2)             # child p[3]
    sb   t4, 20(s2)             # child p[4]
    sb   t5, 21(s2)             # child p[5]
    sb   t6, 22(s2)             # child p[6]
    j    perm_done

perm_Rp:                       # R': source 3 0 2 4 1 5 6
    lbu  t0, 3(s2)              # p[3]
    lbu  t1, 0(s2)              # p[0]
    lbu  t2, 2(s2)              # p[2]
    lbu  t3, 4(s2)              # p[4]
    lbu  t4, 1(s2)              # p[1]
    lbu  t5, 5(s2)              # p[5]
    lbu  t6, 6(s2)              # p[6]
    sb   t0, 16(s2)             # child p[0]
    sb   t1, 17(s2)             # child p[1]
    sb   t2, 18(s2)             # child p[2]
    sb   t3, 19(s2)             # child p[3]
    sb   t4, 20(s2)             # child p[4]
    sb   t5, 21(s2)             # child p[5]
    sb   t6, 22(s2)             # child p[6]
    j    perm_done

perm_B:                       # B: source 0 1 2 4 5 6 3
    lbu  t0, 0(s2)              # p[0]
    lbu  t1, 1(s2)              # p[1]
    lbu  t2, 2(s2)              # p[2]
    lbu  t3, 4(s2)              # p[4]
    lbu  t4, 5(s2)              # p[5]
    lbu  t5, 6(s2)              # p[6]
    lbu  t6, 3(s2)              # p[3]
    sb   t0, 16(s2)             # child p[0]
    sb   t1, 17(s2)             # child p[1]
    sb   t2, 18(s2)             # child p[2]
    sb   t3, 19(s2)             # child p[3]
    sb   t4, 20(s2)             # child p[4]
    sb   t5, 21(s2)             # child p[5]
    sb   t6, 22(s2)             # child p[6]
    j    perm_done

perm_B2:                       # B2: source 0 1 2 5 6 3 4
    lbu  t0, 0(s2)              # p[0]
    lbu  t1, 1(s2)              # p[1]
    lbu  t2, 2(s2)              # p[2]
    lbu  t3, 5(s2)              # p[5]
    lbu  t4, 6(s2)              # p[6]
    lbu  t5, 3(s2)              # p[3]
    lbu  t6, 4(s2)              # p[4]
    sb   t0, 16(s2)             # child p[0]
    sb   t1, 17(s2)             # child p[1]
    sb   t2, 18(s2)             # child p[2]
    sb   t3, 19(s2)             # child p[3]
    sb   t4, 20(s2)             # child p[4]
    sb   t5, 21(s2)             # child p[5]
    sb   t6, 22(s2)             # child p[6]
    j    perm_done

perm_Bp:                       # B': source 0 1 2 6 3 4 5
    lbu  t0, 0(s2)              # p[0]
    lbu  t1, 1(s2)              # p[1]
    lbu  t2, 2(s2)              # p[2]
    lbu  t3, 6(s2)              # p[6]
    lbu  t4, 3(s2)              # p[3]
    lbu  t5, 4(s2)              # p[4]
    lbu  t6, 5(s2)              # p[5]
    sb   t0, 16(s2)             # child p[0]
    sb   t1, 17(s2)             # child p[1]
    sb   t2, 18(s2)             # child p[2]
    sb   t3, 19(s2)             # child p[3]
    sb   t4, 20(s2)             # child p[4]
    sb   t5, 21(s2)             # child p[5]
    sb   t6, 22(s2)             # child p[6]
    j    perm_done

perm_D:                       # D: source 0 2 5 3 1 4 6
    lbu  t0, 0(s2)              # p[0]
    lbu  t1, 2(s2)              # p[2]
    lbu  t2, 5(s2)              # p[5]
    lbu  t3, 3(s2)              # p[3]
    lbu  t4, 1(s2)              # p[1]
    lbu  t5, 4(s2)              # p[4]
    lbu  t6, 6(s2)              # p[6]
    sb   t0, 16(s2)             # child p[0]
    sb   t1, 17(s2)             # child p[1]
    sb   t2, 18(s2)             # child p[2]
    sb   t3, 19(s2)             # child p[3]
    sb   t4, 20(s2)             # child p[4]
    sb   t5, 21(s2)             # child p[5]
    sb   t6, 22(s2)             # child p[6]
    j    perm_done

perm_D2:                       # D2: source 0 5 4 3 2 1 6
    lbu  t0, 0(s2)              # p[0]
    lbu  t1, 5(s2)              # p[5]
    lbu  t2, 4(s2)              # p[4]
    lbu  t3, 3(s2)              # p[3]
    lbu  t4, 2(s2)              # p[2]
    lbu  t5, 1(s2)              # p[1]
    lbu  t6, 6(s2)              # p[6]
    sb   t0, 16(s2)             # child p[0]
    sb   t1, 17(s2)             # child p[1]
    sb   t2, 18(s2)             # child p[2]
    sb   t3, 19(s2)             # child p[3]
    sb   t4, 20(s2)             # child p[4]
    sb   t5, 21(s2)             # child p[5]
    sb   t6, 22(s2)             # child p[6]
    j    perm_done

perm_Dp:                       # D': source 0 4 1 3 5 2 6
    lbu  t0, 0(s2)              # p[0]
    lbu  t1, 4(s2)              # p[4]
    lbu  t2, 1(s2)              # p[1]
    lbu  t3, 3(s2)              # p[3]
    lbu  t4, 5(s2)              # p[5]
    lbu  t5, 2(s2)              # p[2]
    lbu  t6, 6(s2)              # p[6]
    sb   t0, 16(s2)             # child p[0]
    sb   t1, 17(s2)             # child p[1]
    sb   t2, 18(s2)             # child p[2]
    sb   t3, 19(s2)             # child p[3]
    sb   t4, 20(s2)             # child p[4]
    sb   t5, 21(s2)             # child p[5]
    sb   t6, 22(s2)             # child p[6]
    j    perm_done

orient_R:                     # R: twist 1 2 0 2 1 0 0
    lbu  a1, 9(s2)              # o[1]
    lbu  a2, 12(s2)              # o[4]
    lbu  a3, 8(s2)              # o[0]
    lbu  a4, 11(s2)              # o[3]
    add  a1, a1, s3
    add  a2, a2, s3
    add  a3, a3, s3
    add  a4, a4, s3
    lbu  a1, 51(a1)              # plus[1][o[1]]
    lbu  a2, 54(a2)              # plus[2][o[4]]
    lbu  a3, 54(a3)              # plus[2][o[0]]
    lbu  a4, 51(a4)              # plus[1][o[3]]
    sb   a1, 24(s2)             # child o[0]
    sb   a2, 25(s2)             # child o[1]
    sb   a3, 27(s2)             # child o[3]
    sb   a4, 28(s2)             # child o[4]
    lbu  a1, 10(s2)              # o[2]
    lbu  a2, 13(s2)              # o[5]
    lbu  a3, 14(s2)              # o[6]
    sb   a1, 26(s2)             # child o[2]
    sb   a2, 29(s2)             # child o[5]
    sb   a3, 30(s2)             # child o[6]
    j    orient_done

orient_R2:                     # R2: twist 0 0 0 0 0 0 0
    lbu  a1, 12(s2)              # o[4]
    lbu  a2, 11(s2)              # o[3]
    lbu  a3, 10(s2)              # o[2]
    lbu  a4, 9(s2)              # o[1]
    lbu  a5, 8(s2)              # o[0]
    lbu  a6, 13(s2)              # o[5]
    lbu  a7, 14(s2)              # o[6]
    sb   a1, 24(s2)             # child o[0]
    sb   a2, 25(s2)             # child o[1]
    sb   a3, 26(s2)             # child o[2]
    sb   a4, 27(s2)             # child o[3]
    sb   a5, 28(s2)             # child o[4]
    sb   a6, 29(s2)             # child o[5]
    sb   a7, 30(s2)             # child o[6]
    j    orient_done

orient_Rp:                     # R': twist 1 2 0 2 1 0 0
    lbu  a1, 11(s2)              # o[3]
    lbu  a2, 8(s2)              # o[0]
    lbu  a3, 12(s2)              # o[4]
    lbu  a4, 9(s2)              # o[1]
    add  a1, a1, s3
    add  a2, a2, s3
    add  a3, a3, s3
    add  a4, a4, s3
    lbu  a1, 51(a1)              # plus[1][o[3]]
    lbu  a2, 54(a2)              # plus[2][o[0]]
    lbu  a3, 54(a3)              # plus[2][o[4]]
    lbu  a4, 51(a4)              # plus[1][o[1]]
    sb   a1, 24(s2)             # child o[0]
    sb   a2, 25(s2)             # child o[1]
    sb   a3, 27(s2)             # child o[3]
    sb   a4, 28(s2)             # child o[4]
    lbu  a1, 10(s2)              # o[2]
    lbu  a2, 13(s2)              # o[5]
    lbu  a3, 14(s2)              # o[6]
    sb   a1, 26(s2)             # child o[2]
    sb   a2, 29(s2)             # child o[5]
    sb   a3, 30(s2)             # child o[6]
    j    orient_done

orient_B:                     # B: twist 0 0 0 1 2 1 2
    lbu  a1, 12(s2)              # o[4]
    lbu  a2, 13(s2)              # o[5]
    lbu  a3, 14(s2)              # o[6]
    lbu  a4, 11(s2)              # o[3]
    add  a1, a1, s3
    add  a2, a2, s3
    add  a3, a3, s3
    add  a4, a4, s3
    lbu  a1, 51(a1)              # plus[1][o[4]]
    lbu  a2, 54(a2)              # plus[2][o[5]]
    lbu  a3, 51(a3)              # plus[1][o[6]]
    lbu  a4, 54(a4)              # plus[2][o[3]]
    sb   a1, 27(s2)             # child o[3]
    sb   a2, 28(s2)             # child o[4]
    sb   a3, 29(s2)             # child o[5]
    sb   a4, 30(s2)             # child o[6]
    lbu  a1, 8(s2)              # o[0]
    lbu  a2, 9(s2)              # o[1]
    lbu  a3, 10(s2)              # o[2]
    sb   a1, 24(s2)             # child o[0]
    sb   a2, 25(s2)             # child o[1]
    sb   a3, 26(s2)             # child o[2]
    j    orient_done

orient_B2:                     # B2: twist 0 0 0 0 0 0 0
    lbu  a1, 8(s2)              # o[0]
    lbu  a2, 9(s2)              # o[1]
    lbu  a3, 10(s2)              # o[2]
    lbu  a4, 13(s2)              # o[5]
    lbu  a5, 14(s2)              # o[6]
    lbu  a6, 11(s2)              # o[3]
    lbu  a7, 12(s2)              # o[4]
    sb   a1, 24(s2)             # child o[0]
    sb   a2, 25(s2)             # child o[1]
    sb   a3, 26(s2)             # child o[2]
    sb   a4, 27(s2)             # child o[3]
    sb   a5, 28(s2)             # child o[4]
    sb   a6, 29(s2)             # child o[5]
    sb   a7, 30(s2)             # child o[6]
    j    orient_done

orient_Bp:                     # B': twist 0 0 0 1 2 1 2
    lbu  a1, 14(s2)              # o[6]
    lbu  a2, 11(s2)              # o[3]
    lbu  a3, 12(s2)              # o[4]
    lbu  a4, 13(s2)              # o[5]
    add  a1, a1, s3
    add  a2, a2, s3
    add  a3, a3, s3
    add  a4, a4, s3
    lbu  a1, 51(a1)              # plus[1][o[6]]
    lbu  a2, 54(a2)              # plus[2][o[3]]
    lbu  a3, 51(a3)              # plus[1][o[4]]
    lbu  a4, 54(a4)              # plus[2][o[5]]
    sb   a1, 27(s2)             # child o[3]
    sb   a2, 28(s2)             # child o[4]
    sb   a3, 29(s2)             # child o[5]
    sb   a4, 30(s2)             # child o[6]
    lbu  a1, 8(s2)              # o[0]
    lbu  a2, 9(s2)              # o[1]
    lbu  a3, 10(s2)              # o[2]
    sb   a1, 24(s2)             # child o[0]
    sb   a2, 25(s2)             # child o[1]
    sb   a3, 26(s2)             # child o[2]
    j    orient_done

orient_D:                     # D: twist 0 0 0 0 0 0 0
    lbu  a1, 8(s2)              # o[0]
    lbu  a2, 10(s2)              # o[2]
    lbu  a3, 13(s2)              # o[5]
    lbu  a4, 11(s2)              # o[3]
    lbu  a5, 9(s2)              # o[1]
    lbu  a6, 12(s2)              # o[4]
    lbu  a7, 14(s2)              # o[6]
    sb   a1, 24(s2)             # child o[0]
    sb   a2, 25(s2)             # child o[1]
    sb   a3, 26(s2)             # child o[2]
    sb   a4, 27(s2)             # child o[3]
    sb   a5, 28(s2)             # child o[4]
    sb   a6, 29(s2)             # child o[5]
    sb   a7, 30(s2)             # child o[6]
    j    orient_done

orient_D2:                     # D2: twist 0 0 0 0 0 0 0
    lbu  a1, 8(s2)              # o[0]
    lbu  a2, 13(s2)              # o[5]
    lbu  a3, 12(s2)              # o[4]
    lbu  a4, 11(s2)              # o[3]
    lbu  a5, 10(s2)              # o[2]
    lbu  a6, 9(s2)              # o[1]
    lbu  a7, 14(s2)              # o[6]
    sb   a1, 24(s2)             # child o[0]
    sb   a2, 25(s2)             # child o[1]
    sb   a3, 26(s2)             # child o[2]
    sb   a4, 27(s2)             # child o[3]
    sb   a5, 28(s2)             # child o[4]
    sb   a6, 29(s2)             # child o[5]
    sb   a7, 30(s2)             # child o[6]
    j    orient_done

orient_Dp:                     # D': twist 0 0 0 0 0 0 0
    lbu  a1, 8(s2)              # o[0]
    lbu  a2, 12(s2)              # o[4]
    lbu  a3, 9(s2)              # o[1]
    lbu  a4, 11(s2)              # o[3]
    lbu  a5, 13(s2)              # o[5]
    lbu  a6, 10(s2)              # o[2]
    lbu  a7, 14(s2)              # o[6]
    sb   a1, 24(s2)             # child o[0]
    sb   a2, 25(s2)             # child o[1]
    sb   a3, 26(s2)             # child o[2]
    sb   a4, 27(s2)             # child o[3]
    sb   a5, 28(s2)             # child o[4]
    sb   a6, 29(s2)             # child o[5]
    sb   a7, 30(s2)             # child o[6]
    j    orient_done


# Data comes after the code: Ripes resolves the code labels in the jump
# tables only once it has seen them.
.data
stack:                       # 12 state slots of 16 bytes; must stay first,
    .zero 192                # so that the slots are word aligned
chk:                         # T5 replay state, same layout as a slot
    .zero 16
tmp:                         # T5 replay scratch
    .zero 16
fails:                       # failed checks over all tests
    .word 0
D:
    .zero 48                 # next, skip, path
    .byte 0,1,2, 1,2,0, 2,0,1    # plus[3][3]
    .zero 7
    .byte 0,0,0, 3,3,3, 6,6,6    # face_start[9]
    .zero 7
    .zero 16                 # where[8] and padding
    .word perm_R             # jt_perm, at D + 96
    .word perm_R2
    .word perm_Rp
    .word perm_B
    .word perm_B2
    .word perm_Bp
    .word perm_D
    .word perm_D2
    .word perm_Dp
    .word orient_R           # jt_orient, at D + 132
    .word orient_R2
    .word orient_Rp
    .word orient_B
    .word orient_B2
    .word orient_Bp
    .word orient_D
    .word orient_D2
    .word orient_Dp

#R # LED renderer data. palette[face] is 0x00RRGGBB, faces U D F B R L.
#R palette:                    # word aligned: D is 168 bytes
#R     .word 0xFFFFFF           # U
#R     .word 0xFFD500           # D
#R     .word 0x009B48           # F
#R     .word 0x0046AD           # B
#R     .word 0xB71234           # R
#R     .word 0xFF5800           # L
#R # cface[cubie][j]: face of the cubie's j-th sticker, clockwise from its
#R # U/D sticker as seen from outside; 4 bytes per cubie (cubie 0 = anchor).
#R cface:
#R     .byte 0,5,2,0        # cubie 0
#R     .byte 0,2,4,0        # cubie 1
#R     .byte 1,4,2,0        # cubie 2
#R     .byte 1,2,5,0        # cubie 3
#R     .byte 0,4,3,0        # cubie 4
#R     .byte 1,3,4,0        # cubie 5
#R     .byte 1,5,3,0        # cubie 6
#R     .byte 0,3,5,0        # cubie 7
#R # facelets: position (0 = anchor), slot k at that position, x, y of the
#R # facelet's top-left pixel in the net.
#R facelets:
#R     .byte 0,0,9,3     # U
#R     .byte 1,0,13,3    # U
#R     .byte 4,0,13,0    # U
#R     .byte 7,0,9,0     # U
#R     .byte 0,1,4,7     # L
#R     .byte 3,2,4,10    # L
#R     .byte 6,1,0,10    # L
#R     .byte 7,2,0,7     # L
#R     .byte 0,2,9,7     # F
#R     .byte 1,1,13,7    # F
#R     .byte 2,2,13,10   # F
#R     .byte 3,1,9,10    # F
#R     .byte 1,2,18,7    # R
#R     .byte 2,1,18,10   # R
#R     .byte 4,1,22,7    # R
#R     .byte 5,2,22,10   # R
#R     .byte 4,2,27,7    # B
#R     .byte 5,1,27,10   # B
#R     .byte 6,2,31,10   # B
#R     .byte 7,1,31,7    # B
#R     .byte 2,0,13,14   # D
#R     .byte 3,0,9,14    # D
#R     .byte 5,0,13,17   # D
#R     .byte 6,0,9,17    # D


# The states to solve: 16 bytes each, the state string, its NUL, and the
# expected distance (255 if not known, e.g. a grader's state: then only the
# self check applies). An empty string ends the list. To measure one state
# with --iret, leave only its record. Other distance-11 states:
#   54721631111111  the most nodes (203,475)
tests:
    .string "12345671111111"     # solved
    .byte 0
    .string "26547312333212"     # short scramble: R B D'
    .byte 3
    .string "21345671111111"     # distance 11 (the spec's T6)
    .byte 11
    .byte 0                      # end of the list

names:                       # 4 bytes per move name
    .string "R"
    .zero 2
    .string "R2"
    .zero 1
    .string "R'"
    .zero 1
    .string "B"
    .zero 2
    .string "B2"
    .zero 1
    .string "B'"
    .zero 1
    .string "D"
    .zero 2
    .string "D2"
    .zero 1
    .string "D'"
    .zero 1
msg_nodes:
    .string "nodes: "
msg_none:
    .string "no solution within 11 moves\n"
msg_ok:
    .string "verify: solved\n"
msg_fail:
    .string "verify: FAIL\n"
msg_length:
    .string "length: "
msg_len_ok:
    .string " ok"
msg_len_fail:
    .string " FAIL"
msg_failed:
    .string " check(s) failed\n"
msg_pass:
    .string "all tests passed\n"

# Quarter turns R, B, D for the T5 replay (cube.h, rows R, B, D).
qt_src:
    .byte 1,4,2,0,3,5,6
    .byte 0,1,2,4,5,6,3
    .byte 0,2,5,3,1,4,6
qt_tw:
    .byte 1,2,0,2,1,0,0
    .byte 0,0,0,1,2,1,2
    .byte 0,0,0,0,0,0,0

# Pattern databases, generated by pdb_generator.c (pdb.h).
pdb_perm:
    .byte 0,7,7,6,6,6,7,5,6,1,6,6,6,6,6,6,1,6,1,6,6,7,6,5
    .byte 7,3,3,6,6,6,5,5,6,6,4,4,4,5,5,4,6,5,6,4,5,5,3,5
    .byte 5,5,4,6,5,4,6,4,6,4,4,5,6,5,3,4,5,5,5,5,6,5,5,4
    .byte 6,4,5,5,6,3,6,4,7,6,4,4,3,6,4,4,6,5,5,5,6,6,4,3
    .byte 6,4,4,5,5,5,4,5,6,6,4,4,4,5,4,5,6,5,5,4,5,5,3,5
    .byte 7,4,5,5,5,5,4,5,5,6,4,5,5,4,5,5,6,5,6,5,5,5,5,6
    .byte 5,5,5,6,3,5,6,5,3,4,4,6,6,2,4,5,5,6,5,5,6,3,6,5
    .byte 3,4,4,5,6,6,6,6,6,3,5,4,5,5,5,5,3,5,2,5,6,5,5,6
    .byte 6,5,5,2,5,5,1,6,6,5,5,6,6,5,6,5,5,2,6,6,2,5,5,6
    .byte 6,5,5,7,3,4,6,5,3,5,4,5,5,2,5,5,5,6,5,5,6,3,6,4
    .byte 5,5,5,3,6,5,3,4,6,6,5,5,4,6,5,5,5,3,5,6,2,7,5,4
    .byte 6,5,4,5,5,6,6,5,4,6,4,4,4,5,6,4,5,5,6,3,5,5,4,5
    .byte 6,4,5,5,4,6,4,6,5,5,4,4,4,5,5,5,5,4,5,5,5,5,3,6
    .byte 5,4,5,6,4,5,6,6,4,4,5,5,5,4,5,6,5,6,4,6,6,3,5,5
    .byte 5,6,6,3,5,6,3,5,5,6,5,5,5,6,6,5,5,3,6,5,2,5,6,5
    .byte 6,5,6,5,2,5,6,6,1,6,6,5,5,2,6,5,6,5,5,5,5,2,6,5
    .byte 6,5,4,6,5,3,7,4,6,6,3,5,4,6,4,3,5,6,6,4,6,6,5,3
    .byte 4,6,6,3,6,5,3,5,6,5,6,5,5,6,5,6,5,3,5,5,2,6,6,4
    .byte 4,5,5,5,4,6,5,5,3,5,5,4,5,4,6,4,4,5,5,5,4,4,5,5
    .byte 5,5,4,6,6,5,6,5,6,5,3,5,4,5,5,4,5,6,5,4,6,6,5,6
    .byte 3,4,4,6,5,6,6,5,6,3,5,4,5,6,6,5,2,6,3,5,5,5,5,6
    .byte 4,4,6,5,5,4,6,3,6,5,6,4,4,6,4,5,5,5,5,5,5,6,5,4
    .byte 5,4,4,5,5,5,6,6,6,5,4,4,3,6,6,3,6,6,5,3,5,6,4,5
    .byte 5,5,5,6,6,2,5,2,6,4,5,6,6,5,1,6,5,5,4,6,6,5,5,2
    .byte 5,3,5,5,5,6,5,6,6,5,4,4,4,5,5,5,5,4,5,5,5,5,4,6
    .byte 4,6,5,3,6,5,3,4,5,5,6,5,5,5,5,5,5,3,5,6,2,6,6,4
    .byte 6,4,4,5,5,5,6,5,5,7,4,3,3,6,5,3,6,6,6,3,5,6,4,6
    .byte 5,4,4,6,5,5,5,5,5,5,4,5,5,5,4,5,5,5,4,5,6,4,4,5
    .byte 5,5,6,5,3,5,6,6,3,5,6,4,4,4,6,6,5,6,4,6,5,4,5,6
    .byte 4,6,6,3,5,5,3,4,6,5,5,5,5,6,5,6,4,3,5,6,2,6,6,5
    .byte 7,5,4,5,5,5,5,6,5,6,5,5,5,5,5,5,6,4,6,5,5,4,4,5
    .byte 3,7,5,5,5,5,5,5,5,4,4,6,6,6,5,4,4,5,4,4,6,6,6,4
    .byte 5,5,6,4,6,4,4,4,6,5,5,5,4,5,4,6,4,4,5,6,3,6,5,3
    .byte 5,4,5,6,4,6,6,5,4,5,6,4,4,3,5,5,5,6,4,5,5,4,5,6
    .byte 4,6,4,6,5,4,5,5,5,5,4,6,6,6,5,4,4,6,4,3,6,6,6,5
    .byte 6,5,4,4,4,5,4,5,5,7,4,4,4,5,6,3,6,5,6,4,5,5,4,5
    .byte 5,6,5,4,6,3,4,4,5,4,5,6,6,6,4,5,5,4,5,4,3,5,5,4
    .byte 6,3,5,5,4,6,4,5,4,5,4,4,4,3,6,5,6,4,6,5,5,4,4,6
    .byte 5,5,2,7,5,5,6,6,5,5,3,5,5,5,5,3,4,6,4,3,6,4,6,5
    .byte 4,5,5,5,6,3,4,4,5,3,6,6,6,5,4,6,4,4,4,5,4,6,5,4
    .byte 4,4,6,5,5,5,4,6,5,4,6,5,5,6,5,7,4,5,3,6,5,5,4,5
    .byte 6,5,6,5,2,5,6,5,3,5,6,4,5,3,4,6,5,6,6,5,6,3,4,5
    .byte 5,5,2,5,6,6,5,6,6,4,3,5,6,6,5,3,5,5,4,3,4,5,6,6
    .byte 5,3,5,3,5,5,2,6,5,5,4,4,4,5,5,5,5,3,4,5,3,4,4,6
    .byte 6,4,5,6,6,5,6,5,6,6,4,4,4,5,5,4,6,6,5,5,6,5,5,4
    .byte 6,4,3,5,6,6,4,5,6,6,4,4,5,5,6,4,5,5,6,4,4,5,4,6
    .byte 1,6,6,5,6,6,6,5,6,2,5,5,5,5,6,5,2,5,2,6,5,6,5,5
    .byte 6,4,5,5,5,4,6,5,5,7,4,4,3,5,5,4,6,6,6,4,6,6,4,4
    .byte 5,5,6,7,3,4,6,4,4,4,5,4,5,4,3,5,5,6,5,6,6,4,4,4
    .byte 3,5,6,5,4,4,5,3,5,4,6,5,4,5,4,5,4,5,4,6,4,5,5,4
    .byte 6,5,5,5,4,4,5,4,3,6,5,6,6,4,5,5,6,5,5,6,4,4,6,4
    .byte 6,5,5,2,5,5,3,6,5,7,5,5,4,5,5,4,6,3,6,4,3,6,5,5
    .byte 2,5,6,5,4,4,6,3,5,3,6,5,4,5,4,5,3,6,3,5,5,5,5,4
    .byte 5,5,6,4,4,5,4,5,3,5,6,6,5,4,6,6,5,3,4,5,4,4,6,5
    .byte 5,6,3,4,5,6,5,6,5,5,4,5,6,5,5,4,5,5,4,4,4,4,6,5
    .byte 5,4,6,5,6,5,4,5,5,5,6,5,5,5,4,6,4,5,4,5,5,5,4,5
    .byte 5,6,6,5,2,5,5,4,3,5,6,5,6,3,5,5,4,6,5,5,6,3,5,4
    .byte 6,6,3,4,6,6,4,5,6,5,4,5,5,6,6,4,5,4,5,4,4,5,6,5
    .byte 4,3,5,4,6,4,3,5,6,4,5,4,4,5,5,6,4,4,3,6,4,5,4,5
    .byte 5,4,4,5,6,5,6,5,5,6,4,4,4,6,5,3,5,6,6,4,5,6,5,4
    .byte 6,5,4,4,4,5,4,5,4,6,5,4,5,4,6,5,6,4,7,4,3,5,5,5
    .byte 4,4,6,5,5,5,6,4,6,5,5,4,3,6,5,6,4,6,5,6,5,5,4,5
    .byte 4,6,5,3,6,6,4,5,5,4,4,5,5,6,6,5,5,4,5,4,4,5,6,5
    .byte 5,6,5,5,4,4,6,4,3,5,5,6,6,4,5,4,4,5,5,4,6,4,6,4
    .byte 4,5,7,5,5,5,6,4,6,5,6,5,4,5,5,6,4,5,5,6,5,5,4,5
    .byte 6,5,5,5,5,4,5,4,6,5,5,5,6,5,3,6,6,5,5,5,6,5,5,4
    .byte 5,6,5,3,4,6,4,6,5,4,6,5,5,5,6,6,5,4,4,5,4,5,6,6
    .byte 5,6,5,5,3,4,5,5,4,5,5,5,6,4,5,4,5,5,6,5,4,4,6,5
    .byte 2,5,7,5,6,5,5,4,5,3,6,5,5,5,5,6,3,4,3,6,4,5,6,5
    .byte 5,5,5,3,4,6,4,5,5,5,5,5,5,5,6,5,4,4,5,4,4,5,6,6
    .byte 5,5,4,6,6,5,5,6,5,5,4,5,5,5,6,5,5,5,4,5,6,5,4,6
    .byte 3,6,5,4,6,5,5,6,6,4,4,6,6,5,5,4,4,5,4,4,5,6,5,5
    .byte 4,3,6,4,5,5,5,4,6,5,6,3,2,6,5,5,5,5,5,5,4,6,3,5
    .byte 5,5,6,5,3,4,5,4,4,4,5,5,6,4,3,6,5,5,5,6,5,4,5,4
    .byte 6,4,4,6,5,4,5,5,5,6,5,5,5,4,5,5,6,5,5,5,5,5,5,5
    .byte 5,6,5,4,5,5,4,6,5,4,5,6,6,5,5,6,5,5,5,6,4,4,6,6
    .byte 6,4,6,4,5,4,4,4,6,5,6,4,5,6,3,6,6,5,5,5,5,6,4,4
    .byte 5,4,3,6,5,4,5,5,5,5,4,5,5,4,5,4,5,5,4,4,6,5,5,5
    .byte 4,3,5,4,5,5,3,6,6,4,6,4,4,6,5,6,4,4,3,6,4,5,4,6
    .byte 5,6,4,4,6,5,5,4,5,4,5,5,6,5,5,5,5,5,5,5,4,5,6,5
    .byte 5,4,6,6,5,4,5,5,5,5,5,5,5,4,4,6,6,5,5,6,6,5,5,5
    .byte 5,4,5,5,4,6,4,6,4,5,5,5,5,3,6,5,5,5,6,6,5,4,4,7
    .byte 6,6,4,4,5,4,5,5,4,5,5,5,6,5,5,5,6,5,6,4,4,5,6,5
    .byte 3,6,5,4,4,6,5,5,5,4,5,6,5,5,5,4,4,5,4,5,5,5,6,5
    .byte 4,4,5,5,4,5,6,4,5,5,5,4,3,5,5,4,5,6,5,5,5,5,4,5
    .byte 5,5,5,5,5,6,4,6,5,6,5,6,6,4,6,6,5,5,5,6,5,5,5,7
    .byte 4,6,4,5,5,4,5,5,5,5,4,6,5,4,5,5,5,5,4,5,6,5,6,5
    .byte 4,4,5,5,5,5,6,4,6,5,6,4,3,6,5,5,5,6,5,6,5,6,4,5
    .byte 6,6,6,4,4,5,5,5,4,5,5,5,5,5,4,5,6,4,6,6,4,5,6,5
    .byte 5,4,4,7,5,3,6,4,4,5,4,5,5,4,4,4,5,6,4,5,6,5,5,4
    .byte 5,6,5,6,4,3,6,3,5,4,5,5,5,4,2,5,5,6,5,6,7,5,5,3
    .byte 6,5,6,2,5,5,1,6,6,5,5,6,6,6,5,6,5,2,5,6,2,5,5,5
    .byte 5,5,5,6,3,4,6,4,2,6,5,6,5,3,5,4,5,5,5,5,5,3,6,4
    .byte 2,6,5,5,5,6,5,5,6,3,4,6,6,6,6,5,3,4,3,4,4,6,5,6
    .byte 5,6,3,6,5,5,5,4,5,4,4,6,7,5,4,4,4,5,4,4,5,4,6,5
    .byte 5,6,5,4,3,6,5,6,2,5,5,5,5,3,7,5,6,4,5,4,5,3,5,6
    .byte 7,4,4,6,6,4,6,5,6,6,3,4,3,5,5,3,6,5,6,4,5,6,4,4
    .byte 5,6,5,4,5,5,4,4,6,6,5,5,6,6,5,5,5,4,6,4,3,5,6,4
    .byte 5,5,5,5,4,5,5,4,3,5,5,4,5,4,5,4,4,5,5,4,4,4,5,5
    .byte 4,5,5,5,5,6,6,5,5,5,4,5,4,5,5,4,4,6,4,5,5,6,5,6
    .byte 3,6,5,6,4,5,6,4,5,4,4,6,6,5,5,4,4,5,4,4,5,5,6,4
    .byte 4,5,5,5,5,6,6,5,5,4,6,4,4,4,5,6,4,6,3,5,6,5,4,5
    .byte 5,5,4,6,4,4,5,4,4,4,3,6,6,3,3,4,5,5,4,4,6,4,5,4
    .byte 6,3,5,6,5,4,6,4,6,5,4,3,2,6,5,4,6,6,6,5,5,6,3,5
    .byte 4,6,6,6,3,4,5,3,4,5,6,5,6,4,4,5,4,6,5,5,6,4,5,4
    .byte 4,3,5,6,5,4,5,4,6,4,6,4,4,5,3,6,4,5,3,6,6,6,4,4
    .byte 5,5,6,4,3,6,3,6,4,4,5,5,5,4,6,6,4,4,5,5,4,4,4,7
    .byte 5,5,5,5,4,5,6,4,3,5,5,4,4,4,5,5,4,6,5,4,5,4,5,5
    .byte 6,5,5,4,6,5,5,4,6,6,5,6,6,5,5,4,6,5,6,4,4,5,5,4
    .byte 5,4,6,6,6,4,5,5,5,5,6,4,4,6,5,6,5,5,4,5,6,5,3,5
    .byte 6,5,6,4,3,5,3,5,4,5,5,5,5,4,5,6,5,4,5,6,4,4,4,5
    .byte 4,4,5,6,5,3,5,3,5,4,4,5,5,4,2,5,4,5,3,5,6,5,5,3
    .byte 5,4,5,5,4,6,5,6,4,5,5,5,5,3,6,6,5,5,4,6,6,4,4,6
    .byte 5,6,6,4,4,6,3,5,5,4,6,6,5,5,6,5,4,4,4,6,4,5,5,6
    .byte 6,6,4,5,5,4,6,5,5,5,5,7,6,4,4,5,6,5,6,5,5,4,6,5
    .byte 4,5,5,6,4,4,6,4,4,5,4,5,4,4,4,4,5,7,5,5,6,5,5,3
    .byte 6,4,6,6,4,4,5,5,4,5,5,5,4,3,5,6,6,5,5,6,6,4,4,5
    .byte 5,5,5,3,6,5,2,5,5,4,6,6,6,6,4,6,5,3,4,6,3,6,5,5
    .byte 4,6,4,5,5,5,6,5,4,5,4,5,6,5,5,4,4,6,5,3,5,5,6,4
    .byte 5,4,6,5,4,7,6,6,3,5,6,4,3,4,6,5,6,6,5,5,5,4,4,6
    .byte 4,4,6,5,6,4,4,5,6,4,6,4,4,6,5,6,4,4,3,5,5,5,3,5
    .byte 6,5,5,6,3,5,6,5,3,5,6,4,5,2,4,6,6,5,5,6,5,3,4,5
    .byte 5,6,2,6,6,5,6,5,6,4,3,5,6,5,4,3,5,6,4,3,5,5,6,5
    .byte 6,4,4,4,4,5,3,6,4,5,3,5,5,4,5,4,6,4,5,4,4,3,4,6
    .byte 6,3,5,5,5,5,5,4,5,6,5,4,4,5,4,5,5,6,6,6,5,6,4,4
    .byte 4,6,5,4,5,5,5,5,5,4,4,5,6,6,5,5,3,5,4,5,5,5,6,4
    .byte 6,5,3,6,5,4,6,5,5,5,4,5,6,5,4,4,5,5,5,4,6,4,5,4
    .byte 4,4,5,6,4,5,6,5,5,4,5,5,5,5,4,5,4,5,3,6,6,5,4,5
    .byte 6,6,5,4,5,4,5,3,6,6,5,5,5,5,4,4,5,5,6,5,4,6,6,4
    .byte 6,4,4,5,4,5,5,6,4,5,4,5,5,4,5,5,6,4,5,5,5,3,5,6
    .byte 5,6,6,4,5,4,4,4,4,5,6,5,5,5,5,5,6,4,6,5,3,4,6,5
    .byte 6,5,4,3,4,5,4,6,5,6,4,5,4,5,6,3,6,4,5,4,4,5,5,6
    .byte 3,6,5,5,3,5,6,4,4,4,5,5,5,4,5,4,4,6,4,5,6,4,6,5
    .byte 5,5,5,4,3,5,5,5,2,6,5,5,5,3,6,5,6,4,5,4,4,3,6,6
    .byte 4,5,4,3,5,6,4,6,5,4,5,4,5,6,6,5,4,4,3,5,4,5,5,5
    .byte 5,4,5,5,4,5,5,5,5,6,5,4,3,5,5,5,6,6,6,4,5,5,4,4
    .byte 5,4,6,5,4,3,6,4,3,6,6,5,5,4,4,5,6,5,5,6,5,4,5,4
    .byte 6,4,5,2,6,5,1,6,6,5,5,5,5,5,5,6,6,2,5,6,2,5,4,6
    .byte 5,5,3,6,6,6,6,6,5,4,4,4,5,5,6,4,4,6,4,4,5,6,5,5
    .byte 4,5,5,5,5,6,6,6,4,5,5,5,4,5,6,4,5,5,5,4,5,5,5,5
    .byte 2,5,6,5,5,5,5,4,6,3,6,5,4,6,5,5,3,5,3,5,4,6,5,4
    .byte 6,4,2,6,6,5,5,4,6,6,3,5,5,5,5,3,5,6,5,3,6,6,4,5
    .byte 4,5,5,6,4,4,5,5,5,3,4,5,6,5,4,5,4,6,4,5,6,5,5,5
    .byte 6,4,5,6,6,3,5,4,6,6,5,5,4,6,4,5,6,6,5,4,5,5,4,4
    .byte 6,4,4,5,6,5,4,5,6,6,5,5,5,5,4,5,6,5,5,5,5,5,4,5
    .byte 6,5,4,4,6,5,4,4,5,6,4,6,6,5,5,5,5,4,6,5,5,6,5,5
    .byte 3,4,6,4,5,5,4,5,5,4,6,4,3,6,5,5,4,4,4,5,3,6,4,4
    .byte 4,4,3,6,6,6,5,6,6,5,3,5,5,6,6,4,5,5,5,4,6,6,4,5
    .byte 5,6,5,5,4,4,5,5,4,4,5,6,6,4,4,6,5,6,5,6,6,3,6,5
    .byte 4,5,6,3,5,5,4,4,6,5,6,5,4,6,5,5,4,4,5,5,4,6,5,5
    .byte 5,5,4,3,5,5,4,4,5,5,3,6,6,5,5,4,6,4,6,4,4,4,6,5
    .byte 3,6,4,6,5,4,6,5,5,3,5,6,6,5,5,5,3,6,2,5,6,4,5,5
    .byte 6,3,5,6,4,4,5,4,5,6,6,4,4,5,3,6,5,5,5,6,6,5,4,4
    .byte 5,4,5,5,3,6,5,6,4,6,5,4,3,4,6,5,5,5,6,4,4,4,4,5
    .byte 5,6,5,6,4,5,6,4,3,5,5,6,5,4,5,4,5,5,4,5,6,4,6,5
    .byte 5,6,6,4,5,6,4,5,5,5,6,5,5,4,5,6,4,4,5,6,3,4,6,6
    .byte 6,3,5,5,6,4,5,4,7,5,6,4,4,6,3,5,6,5,5,5,6,6,3,4
    .byte 6,5,3,5,5,4,5,5,5,5,4,6,6,4,5,4,6,4,5,4,5,4,5,5
    .byte 5,3,5,5,4,5,4,6,5,4,5,4,4,5,6,6,5,5,4,5,5,5,4,6
    .byte 5,6,4,4,5,5,4,4,6,5,5,5,5,6,5,5,6,5,6,5,4,5,6,5
    .byte 6,4,5,5,4,5,6,6,4,5,5,4,3,5,6,5,5,6,6,4,5,5,4,6
    .byte 5,6,5,6,4,4,5,4,3,6,5,6,6,4,5,4,5,5,6,5,5,4,7,4
    .byte 4,5,5,4,4,5,3,6,5,4,6,5,6,5,5,6,4,4,3,6,4,5,6,6
    .byte 6,4,2,5,6,6,4,5,6,6,3,5,5,5,6,3,5,5,6,3,5,5,4,6
    .byte 4,4,4,6,5,4,6,5,5,5,3,5,5,4,4,4,5,6,4,4,7,5,5,4
    .byte 6,6,4,5,5,5,5,4,4,6,5,6,6,5,5,4,5,4,6,5,5,5,5,4
    .byte 4,3,6,4,4,6,4,5,5,5,6,3,2,5,6,5,5,4,5,5,3,5,3,5
    .byte 3,5,4,5,5,6,6,5,6,4,4,6,5,6,6,3,4,5,4,3,6,6,5,5
    .byte 6,5,5,4,5,3,5,4,4,5,6,6,6,4,4,5,6,5,6,6,5,4,6,4
    .byte 5,6,6,4,5,6,4,5,6,5,7,5,5,5,6,6,4,5,5,6,5,5,6,5
    .byte 5,4,3,5,5,5,5,6,5,5,4,5,5,5,5,4,5,4,4,4,5,4,5,6
    .byte 3,6,5,4,5,6,5,6,5,4,4,6,6,6,6,4,4,4,4,4,5,5,7,5
    .byte 5,5,6,4,6,3,5,2,6,6,6,5,4,6,3,5,5,5,6,6,5,6,5,3
    .byte 5,5,6,5,4,6,6,6,4,4,6,4,4,4,5,5,5,6,4,5,5,5,4,6
    .byte 4,6,4,5,5,5,5,5,5,5,5,5,5,6,5,4,5,6,5,4,6,6,6,4
    .byte 5,3,5,6,5,5,5,5,6,5,6,4,4,5,4,6,5,5,4,6,6,6,4,5
    .byte 5,5,6,4,3,5,4,6,4,5,6,6,6,4,5,6,5,4,6,5,4,4,5,6
    .byte 4,5,5,5,4,5,6,4,4,5,5,4,4,5,5,5,5,6,5,4,5,5,5,5
    .byte 6,5,4,4,6,6,4,5,6,6,4,6,6,5,5,5,7,4,6,4,5,5,5,5
    .byte 5,3,5,6,6,4,5,5,6,5,6,4,4,6,4,6,5,5,4,5,6,6,4,5
    .byte 4,6,5,5,4,4,5,4,5,3,5,6,5,4,3,6,4,6,4,6,6,4,5,4
    .byte 5,4,6,3,6,5,2,5,7,5,5,5,5,6,4,5,6,3,5,5,3,6,5,4
    .byte 4,5,5,6,4,4,7,4,3,5,5,5,4,4,5,4,5,6,4,5,6,4,5,4
    .byte 3,5,5,4,4,5,4,6,5,4,5,5,5,5,6,6,4,3,4,5,4,5,4,6
    .byte 5,6,3,6,6,4,6,4,6,4,4,5,6,5,3,4,5,6,4,4,5,5,5,4
    .byte 4,5,6,5,4,6,5,5,3,5,5,5,4,4,6,5,5,5,5,5,4,4,5,6
    .byte 6,4,3,6,5,4,5,5,5,6,4,5,4,4,5,4,6,5,5,4,5,5,4,5
    .byte 6,5,5,5,4,5,4,5,5,6,6,6,6,5,4,6,5,4,5,5,4,5,5,5
    .byte 5,5,4,4,4,6,5,5,4,6,4,5,4,5,6,4,5,5,6,3,5,5,5,5
    .byte 4,4,5,6,5,6,5,5,4,4,5,5,5,4,5,5,5,5,4,6,6,5,5,6
    .byte 4,6,4,6,5,5,5,4,5,5,5,6,6,6,5,5,4,5,5,4,5,5,7,5
    .byte 4,4,6,5,6,5,6,5,6,5,6,4,3,5,4,6,4,6,4,6,5,6,4,5
    .byte 4,5,4,5,5,5,6,5,5,5,3,6,6,4,4,4,5,6,5,4,6,5,6,5
    .byte 6,4,5,6,5,4,5,4,5,5,5,4,3,5,4,5,6,5,6,6,5,6,4,5
    .byte 4,7,5,5,3,5,5,4,4,4,5,6,6,4,4,5,4,6,5,4,5,4,6,5
    .byte 5,3,4,6,5,5,5,5,5,5,5,4,4,4,4,5,5,5,4,5,6,5,4,5
    .byte 4,6,5,5,3,5,4,5,4,5,5,6,6,4,6,5,5,4,5,4,5,4,5,6
    .byte 5,4,5,4,5,6,5,5,4,5,6,4,3,5,6,5,5,5,5,5,5,5,4,6
    .byte 6,5,4,5,5,5,4,5,5,5,5,6,6,4,4,5,6,5,6,5,5,4,5,5
    .byte 6,4,6,5,7,4,4,5,6,6,5,5,5,6,4,5,6,5,5,5,5,6,4,5
    .byte 5,6,6,5,4,5,4,5,5,5,5,6,6,5,4,5,4,4,5,5,5,5,5,5
    .byte 4,4,4,5,6,4,4,4,6,4,5,5,5,5,3,5,4,5,3,5,5,6,5,4
    .byte 5,4,6,6,4,6,6,5,3,5,6,5,5,4,5,5,5,6,5,6,6,4,5,5
    .byte 4,6,5,4,5,5,4,4,5,5,6,5,5,6,5,6,5,5,5,5,4,6,6,5
    .byte 5,5,5,5,4,4,6,5,4,4,5,6,5,3,5,6,5,6,5,6,6,4,6,5
    .byte 5,5,5,5,4,5,5,5,5,6,5,5,4,5,5,4,6,6,6,5,5,5,5,4
    .byte 5,4,6,6,5,4,6,5,4,6,6,5,4,4,5,5,6,6,6,5,6,5,4,5
    .byte 6,5,5,3,6,5,2,6,5,5,5,6,6,5,5,6,6,3,5,5,3,5,5,6
    .byte 5,5,4,6,5,6,6,5,5,5,5,5,6,6,6,5,4,7,5,4,6,6,5,5
    .byte 4,5,6,4,5,6,5,5,4,5,5,5,4,5,6,5,5,5,5,5,4,5,5,6

pdb_r_face:
    .byte 6,4,6,4,4,4,6,6,7,6,7,7,7,6,6,4,7,5,6,5,5,7,5,7
    .byte 5,7,6,6,7,6,6,7,7,7,6,6,6,6,4,7,7,7,7,6,6,5,6,7
    .byte 7,7,6,7,7,7,6,7,7,7,7,7,6,7,7,6,7,7,7,7,5,7,7,7
    .byte 6,6,5,6,7,7,8,5,7,3,7,5,5,4,5,5,7,6,7,7,7,7,6,7
    .byte 6,5,4,6,4,7,6,7,7,6,7,6,6,6,7,6,7,7,6,7,6,5,5,6
    .byte 6,7,8,6,7,7,7,7,5,8,7,7,8,7,6,7,7,7,6,6,6,7,7,6
    .byte 7,6,7,7,5,7,7,7,7,5,6,5,6,7,6,6,7,7,6,4,6,5,5,3
    .byte 5,6,7,7,6,7,7,7,6,4,7,5,6,6,5,7,6,7,5,7,7,7,6,7
    .byte 7,7,7,7,5,7,6,6,5,7,6,7,6,6,7,4,7,7,8,7,7,7,7,8
    .byte 7,6,6,6,6,7,6,7,6,7,7,7,7,7,4,7,7,8,6,5,6,7,7,6
    .byte 7,6,7,4,7,6,5,4,5,6,6,6,6,7,7,7,7,7,7,6,3,6,5,7
    .byte 6,7,7,7,6,6,7,6,6,6,7,6,6,7,7,6,5,5,6,7,7,5,7,7
    .byte 7,6,5,7,7,7,7,7,7,7,7,6,6,7,6,7,7,5,6,7,7,7,5,6
    .byte 6,7,7,6,6,6,6,6,7,6,6,8,6,4,4,7,4,6,6,5,6,4,8,7
    .byte 6,6,6,6,7,7,6,5,6,7,6,8,5,5,6,7,7,7,5,6,6,7,7,6
    .byte 7,6,7,5,7,5,6,6,6,7,6,8,6,6,7,7,6,6,7,7,7,7,7,6
    .byte 6,7,5,6,8,6,7,6,7,7,7,7,7,5,6,7,6,6,5,6,6,0,7,7
    .byte 7,7,6,7,6,7,7,7,6,6,6,7,7,6,6,7,6,7,7,6,6,6,7,6
    .byte 8,7,7,7,7,7,6,6,7,7,7,7,7,6,6,7,6,7,6,6,7,7,6,7
    .byte 8,6,7,8,7,7,6,7,6,7,7,7,6,7,6,8,7,6,7,7,6,7,7,7
    .byte 7,7,6,7,6,6,4,4,5,7,4,7,6,5,6,5,6,6,6,6,6,8,8,5
    .byte 4,7,7,5,5,7,6,6,6,7,7,7,6,6,6,7,7,7,6,7,5,7,6,5
    .byte 7,6,6,6,6,7,6,7,7,6,6,7,7,7,7,6,6,7,7,6,5,7,7,7
    .byte 6,6,7,6,7,6,6,6,6,7,6,7,6,7,5,6,4,4,6,6,5,4,7,8
    .byte 6,6,5,5,6,5,6,7,7,7,6,4,7,8,6,6,6,6,7,7,7,7,6,5
    .byte 6,6,8,6,5,7,5,6,6,7,7,7,7,6,7,7,6,6,7,7,6,7,7,7
    .byte 7,8,6,7,7,6,7,6,7,7,6,6,6,6,6,5,6,6,6,7,6,5,5,7
    .byte 6,5,6,5,5,6,6,5,3,5,6,5,5,7,7,5,8,7,6,6,7,5,5,7
    .byte 6,6,6,6,5,7,7,7,6,6,6,7,6,7,6,7,5,7,7,6,6,6,5,7
    .byte 6,6,6,7,6,7,7,7,7,6,6,6,7,6,7,6,7,6,7,8,6,6,7,6
    .byte 7,6,6,4,6,6,7,6,6,5,5,7,7,4,7,5,5,4,6,4,5,7,7,7
    .byte 6,7,7,6,6,7,5,7,7,4,7,7,6,6,5,7,6,7,7,7,7,6,6,6
    .byte 7,6,6,7,6,4,7,7,6,6,7,6,7,8,7,6,7,7,5,7,7,6,7,6
    .byte 7,7,6,6,7,6,7,8,7,6,7,7,6,4,6,6,6,6,5,7,6,6,7,5
    .byte 7,1,6,6,5,6,6,7,7,6,6,7,5,7,6,6,6,6,6,7,7,6,6,6
    .byte 6,7,7,6,7,7,7,7,6,6,7,6,7,6,6,6,7,6,7,8,6,6,7,7
    .byte 6,7,6,7,6,7,6,7,6,7,7,6,7,6,7,6,6,7,7,7,6,7,6,5
    .byte 8,6,7,4,7,7,4,6,6,4,4,5,6,6,5,7,5,7,6,7,5,4,7,6
    .byte 7,6,5,7,7,5,7,6,6,8,7,7,7,7,7,6,6,6,7,6,7,7,5,6
    .byte 6,7,7,5,7,6,7,7,7,7,7,6,6,6,6,7,8,7,5,7,7,6,7,6
    .byte 7,7,7,6,7,7,7,4,6,6,7,6,7,5,4,6,5,6,6,4,5,5,7,6
    .byte 5,7,6,6,7,7,5,6,6,7,7,7,6,4,7,7,6,7,6,6,7,6,6,5
    .byte 7,6,6,6,6,6,7,6,7,7,6,8,6,6,7,6,6,6,6,7,6,7,7,7
    .byte 6,7,6,5,8,6,7,6,7,7,7,7,7,6,5,6,5,7,5,5,6,5,4,5
    .byte 7,3,7,7,5,6,6,5,7,6,6,5,7,7,5,5,7,7,6,5,7,5,7,5
    .byte 6,6,6,7,7,6,6,7,6,7,7,4,6,6,6,7,7,7,7,7,6,7,7,7
    .byte 6,6,7,6,7,7,5,6,7,7,6,6,6,7,7,7,6,6,7,7,7,6,6,6
    .byte 7,6,6,7,7,5,5,5,5,5,7,4,3,7,7,7,6,6,5,6,6,7,7,7
    .byte 7,6,4,7,7,6,7,6,6,7,7,7,7,6,6,5,6,7,6,5,6,6,7,5
    .byte 7,6,8,7,7,6,7,7,7,7,7,5,6,6,7,6,7,6,7,7,6,8,7,7
    .byte 7,5,6,7,6,7,6,7,5,6,7,6,5,6,7,1,7,7,7,6,6,7,6,6
    .byte 7,7,5,6,6,7,7,7,6,7,7,7,6,7,6,5,6,6,7,6,6,7,7,7
    .byte 7,6,7,6,7,6,7,5,7,7,6,6,7,6,6,7,7,7,7,5,7,8,7,6
    .byte 7,6,5,7,7,6,5,7,6,7,7,7,7,7,7,6,6,7,7,6,7,7,6,7
    .byte 6,5,5,6,5,6,6,5,4,6,7,6,6,6,6,5,7,7,7,7,7,6,5,7
    .byte 6,5,5,6,6,6,7,7,6,7,6,7,6,6,6,7,6,7,6,5,7,5,6,6
    .byte 7,5,7,7,5,7,6,8,7,6,6,6,7,7,6,6,7,7,6,7,7,6,7,5
    .byte 7,6,7,5,6,5,6,6,6,5,7,7,7,7,5,7,1,7,7,6,7,5,6,6
    .byte 6,7,6,6,6,6,5,6,7,6,6,6,6,7,7,7,7,6,7,8,7,7,6,6
    .byte 6,7,5,7,6,7,6,6,6,7,8,6,7,7,6,6,7,7,6,6,6,6,7,7
    .byte 7,8,7,7,7,6,5,6,6,7,8,6,7,6,6,7,6,6,4,7,6,5,7,7
    .byte 3,5,5,6,6,6,7,4,7,6,6,6,5,6,6,7,6,6,7,6,5,6,7,6
    .byte 7,6,7,6,6,7,5,6,7,7,7,7,7,5,6,6,6,7,6,7,7,6,7,7
    .byte 7,7,6,5,6,7,7,8,7,6,7,7,6,7,7,6,6,7,6,7,7,6,5,7
    .byte 7,6,5,4,6,6,7,4,7,5,6,4,6,5,6,6,6,6,6,7,6,5,7,7
    .byte 6,6,7,3,6,6,6,6,5,7,6,7,7,6,8,6,6,7,7,6,7,7,5,5
    .byte 6,7,7,6,7,7,6,7,7,7,7,7,5,6,6,7,7,6,7,7,6,7,7,5
    .byte 6,7,6,5,7,7,7,5,6,6,6,6,6,5,8,7,5,6,6,5,3,6,4,5
    .byte 6,7,7,6,7,7,6,5,6,6,6,7,5,7,6,6,6,5,7,7,6,6,7,7
    .byte 6,7,7,8,6,7,7,7,4,7,6,5,7,7,6,7,8,8,6,7,7,5,7,6
    .byte 6,6,7,7,6,7,6,6,7,7,8,7,6,7,7,6,5,5,7,6,6,5,7,5
    .byte 5,6,6,6,2,7,5,5,6,7,7,6,7,6,6,5,7,6,6,7,6,7,7,6
    .byte 6,5,6,7,7,6,7,7,6,7,7,6,6,7,7,7,5,6,6,6,6,7,7,7
    .byte 7,7,8,7,7,6,6,6,6,6,6,7,6,7,6,7,7,6,7,7,7,7,7,5
    .byte 6,6,6,7,7,7,6,6,7,6,6,6,7,6,3,5,5,4,5,7,7,6,8,7
    .byte 6,5,7,6,5,6,6,7,7,5,5,6,7,7,7,5,7,7,5,7,7,8,6,7
    .byte 7,6,5,7,5,6,7,7,6,8,7,7,7,7,6,6,6,7,7,5,7,6,6,7
    .byte 6,7,6,7,8,7,6,6,6,5,6,6,7,6,6,5,7,6,5,5,6,5,3,6
    .byte 5,5,5,7,6,6,7,7,5,4,7,7,6,6,5,6,7,6,6,5,6,8,7,7
    .byte 6,7,6,7,6,6,6,7,7,6,5,6,6,6,6,6,7,7,7,7,7,7,6,6
    .byte 7,7,5,6,7,7,5,7,7,7,7,5,7,8,7,6,6,6,6,5,5,6,7,7
    .byte 1,7,7,6,6,6,7,6,6,7,7,5,6,5,7,6,5,6,7,5,7,6,6,6
    .byte 6,7,7,7,6,7,6,7,6,6,5,6,6,6,6,6,7,6,7,7,6,7,6,7
    .byte 8,7,6,8,7,7,8,7,7,7,7,6,6,7,7,7,7,6,8,7,6,7,6,5
    .byte 7,6,7,6,6,6,6,7,6,3,5,5,7,5,6,6,6,6,5,7,7,7,6,6
    .byte 7,7,4,4,6,7,5,6,6,6,6,6,7,7,8,7,5,6,6,7,6,5,7,6
    .byte 6,7,5,6,7,7,7,6,7,6,7,7,6,7,7,6,7,6,6,7,7,7,6,5
    .byte 7,7,6,6,7,7,7,7,7,6,6,7,6,7,6,5,7,6,6,5,4,6,3,6
    .byte 7,6,6,4,7,7,6,6,7,6,6,6,6,4,6,7,5,7,5,6,6,7,7,6
    .byte 6,6,6,7,6,6,6,5,6,5,7,6,7,7,5,7,7,7,7,5,7,7,7,6
    .byte 6,7,8,7,6,7,5,7,5,6,7,7,7,6,7,6,7,7,6,6,5,7,6,7
    .byte 6,6,7,6,4,5,6,5,5,5,7,7,6,6,5,6,7,5,6,6,6,6,5,5
    .byte 7,7,7,6,6,7,7,6,7,6,6,6,6,5,7,6,6,6,5,5,6,6,7,7
    .byte 6,7,8,7,7,6,6,7,7,7,7,6,7,7,5,6,7,5,7,6,7,7,7,5
    .byte 7,7,6,6,6,6,5,6,6,6,6,6,5,5,6,6,7,5,2,7,7,6,6,7
    .byte 6,5,5,7,6,6,6,6,5,6,7,7,7,5,6,6,7,6,7,6,7,6,6,7
    .byte 6,6,7,6,7,5,6,6,7,7,7,6,8,6,8,7,7,6,6,6,6,6,7,6
    .byte 7,7,7,8,7,7,7,5,6,7,7,7,7,6,6,5,7,6,6,6,7,5,5,5
    .byte 6,4,8,6,6,5,6,6,7,6,6,5,6,7,6,6,7,8,7,6,7,5,6,4
    .byte 5,6,7,7,7,5,7,7,6,6,6,4,7,6,7,6,6,7,7,8,6,7,6,7
    .byte 7,6,8,6,7,7,4,6,7,6,7,6,5,7,8,7,6,6,7,7,6,7,6,7
    .byte 7,7,5,7,6,6,6,6,5,6,6,5,6,3,5,6,7,6,4,7,6,6,6,7
    .byte 5,6,7,7,7,7,7,4,7,6,6,6,6,7,7,7,6,6,6,6,6,6,6,6
    .byte 7,6,7,7,6,7,7,7,8,7,7,7,6,6,7,6,7,6,6,7,7,6,7,7
    .byte 6,6,7,6,7,7,7,7,6,6,4,7,6,6,6,2,6,6,6,5,7,6,5,5
    .byte 7,7,5,6,6,6,7,7,5,6,7,8,6,7,6,4,5,7,6,6,6,7,7,7
    .byte 7,6,7,7,7,6,7,4,7,6,6,7,6,6,6,7,7,8,7,6,7,7,7,6
    .byte 7,6,4,7,7,6,6,7,7,6,6,6,7,7,7,7,7,7,7,6,7,7,5,6
    .byte 2,7,6,6,5,6,6,7,5,7,7,6,7,6,7,6,5,5,7,4,6,5,7,6
    .byte 6,7,6,6,6,7,6,7,6,7,6,6,5,6,7,6,7,7,6,7,6,7,7,6
    .byte 8,7,7,7,7,7,7,6,6,6,7,5,6,7,7,7,7,7,8,6,7,7,6,6
    .byte 6,6,6,7,7,6,6,7,7,6,5,5,5,3,5,7,6,6,5,7,6,6,6,7
    .byte 5,6,5,6,4,6,7,5,6,5,7,6,6,7,6,6,7,6,6,7,6,6,6,5
    .byte 6,7,7,7,6,5,6,6,7,7,6,6,7,8,6,6,8,8,7,7,7,5,7,6
    .byte 6,7,8,8,7,6,6,7,6,6,7,4,6,7,7,7,6,7,5,5,6,5,4,4
    .byte 5,7,7,6,6,6,6,8,5,5,6,5,6,5,6,7,7,7,5,7,7,7,5,7
    .byte 6,7,6,7,4,6,6,6,5,6,5,7,5,7,7,5,8,7,8,6,7,6,7,7
    .byte 7,7,5,6,6,6,7,7,5,8,6,6,8,7,4,7,6,7,5,6,6,6,7,6
    .byte 7,6,6,3,6,6,6,5,6,6,6,7,5,7,7,7,7,6,7,6,3,5,6,7
    .byte 6,7,6,7,6,7,6,6,7,7,6,6,7,6,6,6,6,6,6,7,6,5,7,7
    .byte 6,7,6,7,7,8,6,8,6,7,7,5,5,7,7,7,7,6,7,7,6,7,6,6
    .byte 7,7,7,5,6,7,6,7,7,5,7,7,5,6,6,6,7,6,2,6,6,7,6,7
    .byte 7,4,6,7,6,6,6,6,6,7,7,7,6,5,6,6,7,5,7,6,7,7,6,8
    .byte 5,7,7,6,7,6,6,5,7,7,7,6,7,7,7,6,6,7,7,7,6,5,7,6
    .byte 7,7,6,7,7,7,6,6,6,7,7,7,7,7,7,5,6,7,7,5,6,5,6,6
    .byte 6,7,6,6,2,6,7,7,7,4,7,6,7,6,6,6,6,6,6,7,7,6,5,6
    .byte 5,7,6,7,7,7,7,7,6,6,5,7,6,6,6,7,5,6,7,7,7,7,7,7
    .byte 7,7,6,6,6,7,5,6,7,6,7,8,7,7,7,7,6,6,6,7,7,7,7,6
    .byte 7,5,7,7,6,5,3,6,6,7,5,7,6,5,5,7,6,6,5,6,6,7,7,5
    .byte 6,7,7,7,6,6,3,6,6,7,5,5,7,7,7,8,5,7,7,7,6,7,5,7
    .byte 6,5,6,6,6,7,7,7,7,7,7,7,7,7,7,6,6,5,8,7,5,7,7,7
    .byte 7,7,5,7,7,7,6,7,6,7,6,7,7,5,5,5,6,5,7,5,7,6,6,5
    .byte 6,7,7,6,6,6,5,7,7,7,7,7,7,6,7,6,5,5,6,7,7,7,7,5
    .byte 6,6,6,6,6,5,7,6,7,6,5,6,6,7,7,8,5,8,7,6,7,6,7,7
    .byte 5,6,6,6,6,6,5,8,8,6,7,7,7,7,5,7,6,7,6,6,5,7,6,7
    .byte 6,6,6,5,7,6,4,5,6,6,4,5,6,6,5,6,8,7,6,6,6,6,7,6
    .byte 5,6,6,6,7,6,7,6,7,7,7,7,5,7,7,7,7,7,6,6,6,6,5,6
    .byte 7,6,6,6,6,6,6,6,6,6,6,4,7,7,7,6,7,6,6,5,7,6,8,7
    .byte 7,7,7,7,7,5,7,7,7,3,8,8,7,7,7,7,4,7,7,7,4,5,7,6
    .byte 7,6,6,7,7,7,5,8,8,5,6,7,8,6,6,8,8,7,7,7,8,8,8,7
    .byte 8,6,7,8,8,8,6,6,5,6,7,7,8,7,7,8,6,6,6,5,6,8,7,8
    .byte 7,8,7,8,7,7,8,8,8,8,7,8,6,7,7,8,7,6,6,6,7,6,5,7
    .byte 5,6,5,6,5,5,6,4,6,7,7,5,5,6,7,6,6,7,4,6,6,7,6,6
    .byte 7,7,7,7,6,7,7,7,5,7,7,7,7,7,7,5,6,6,7,5,7,7,5,6
    .byte 6,7,6,6,5,6,7,7,5,6,7,7,5,7,6,7,7,7,7,7,7,5,7,7
    .byte 7,7,7,6,6,6,6,6,6,6,5,4,4,6,5,5,6,6,6,7,8,5,6,7
    .byte 6,6,7,6,5,6,6,6,6,7,7,7,6,6,7,7,7,7,7,7,7,6,7,8
    .byte 6,4,6,7,5,7,6,7,5,6,6,7,6,6,5,5,7,7,7,7,7,6,6,6
    .byte 6,6,6,7,7,6,7,6,6,7,7,7,3,7,7,6,7,6,6,3,7,6,7,5
    .byte 5,7,6,8,5,5,6,7,6,4,7,7,5,7,6,8,5,6,7,7,7,6,7,8
    .byte 7,7,7,7,7,7,7,7,7,6,5,4,6,6,7,7,7,7,8,6,5,6,5,6
    .byte 7,7,7,7,7,6,7,7,7,7,7,7,7,7,7,7,6,7,7,7,6,5,6,7
    .byte 6,6,7,5,5,6,6,6,4,7,4,6,7,7,4,5,7,7,6,6,6,5,6,6
    .byte 7,5,7,6,7,7,7,6,7,7,7,6,7,8,7,7,7,6,4,6,5,7,6,6
    .byte 7,6,6,6,7,6,6,6,6,7,7,5,5,7,6,5,7,7,7,6,7,7,7,6
    .byte 6,6,7,7,8,7,6,6,6,6,6,6,5,4,5,6,3,5,7,6,5,6,7,7
    .byte 6,7,6,6,6,6,5,6,6,6,7,5,6,5,7,6,7,7,6,8,6,7,7,7
    .byte 7,7,5,7,5,6,7,7,5,5,7,7,6,5,7,7,6,5,6,7,7,7,7,6
    .byte 6,6,7,6,7,7,7,7,7,6,6,6,7,7,7,6,6,7,7,6,5,6,6,5
    .byte 4,6,6,5,6,7,6,7,7,6,6,6,7,5,7,6,5,6,6,5,6,7,7,8
    .byte 7,7,7,6,7,7,7,6,7,7,7,7,5,4,7,7,5,7,6,7,5,6,6,6
    .byte 5,5,6,6,7,7,6,7,6,7,7,6,5,7,6,7,7,6,6,7,7,8,7,6
    .byte 5,6,6,6,6,6,5,5,6,7,4,5,7,5,5,5,7,7,5,7,7,5,7,7
    .byte 4,5,5,6,6,5,7,5,8,7,6,7,6,8,6,6,6,7,7,6,6,7,6,7
    .byte 7,7,6,6,7,7,6,5,7,6,7,5,6,6,6,7,7,6,7,6,6,7,7,7
    .byte 7,8,6,6,6,6,7,7,6,6,7,6,5,6,7,4,6,6,6,6,5,7,3,6
    .byte 6,7,5,5,7,7,6,7,7,5,6,5,6,6,6,7,7,8,8,6,7,6,7,6
    .byte 7,7,6,7,6,7,5,6,6,7,5,6,6,6,6,6,6,7,7,6,5,7,6,5
    .byte 6,7,7,4,8,7,7,7,7,7,7,7,6,6,8,7,7,7,3,7,7,7,8,6
    .byte 7,3,6,7,6,5,5,6,5,8,6,6,7,6,7,5,8,7,4,6,6,7,6,5
    .byte 7,7,7,6,7,7,7,7,7,7,7,7,7,7,7,6,6,5,5,7,7,7,7,6
    .byte 7,6,6,6,4,6,7,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,6,7
    .byte 7,6,6,6,5,6,6,6,6,6,6,5,4,7,6,5,5,7,5,7,7,6,6,7
    .byte 6,6,8,5,4,5,5,6,6,7,6,7,7,6,7,7,7,7,6,7,6,7,6,7
    .byte 6,5,7,7,4,6,5,6,5,5,7,7,6,5,5,6,7,6,7,8,7,6,7,6
    .byte 6,7,5,7,8,6,6,7,6,7,7,7,5,6,6,6,5,8,5,6,6,6,6,5
    .byte 7,4,5,7,7,5,4,7,7,5,7,7,5,5,5,7,6,7,6,6,7,7,5,7
    .byte 7,6,6,7,8,6,6,7,7,5,5,6,7,6,6,6,6,5,5,6,6,7,6,6
    .byte 7,7,4,6,7,7,5,7,7,7,7,7,7,8,6,6,7,7,7,7,7,2,7,7
    .byte 7,7,7,7,4,7,7,6,5,4,7,6,8,6,6,7,6,6,5,7,7,5,7,7
    .byte 8,6,6,7,7,6,6,6,7,7,7,8,7,7,6,7,8,8,6,5,5,6,7,7
    .byte 7,7,7,7,6,5,7,5,6,7,7,8,6,8,6,7,7,6,7,7,7,8,6,8
    .byte 7,7,8,8,6,5,6,5,6,5,7,5,5,5,6,7,4,4,7,6,4,6,7,7
    .byte 6,6,6,6,6,6,5,6,6,7,7,6,7,6,7,6,6,7,6,7,7,6,7,6
    .byte 7,7,6,6,6,7,7,7,5,6,7,6,6,6,6,7,7,5,7,6,6,7,6,5
    .byte 7,6,7,7,7,7,6,7,7,7,7,6,7,6,7,5,6,6,7,5,6,7,6,5
    .byte 3,7,6,6,5,6,6,7,7,6,5,7,6,6,7,5,5,6,6,6,6,6,6,7
    .byte 7,7,7,7,7,8,6,7,6,7,7,7,5,5,7,6,5,7,6,6,4,6,6,6
    .byte 6,5,6,6,6,6,6,8,7,7,6,7,6,7,6,7,7,5,7,7,7,7,6,7
    .byte 5,6,6,4,6,5,5,6,8,7,5,6,7,6,7,5,6,3,6,6,7,7,6,7
    .byte 5,7,6,7,6,7,6,7,7,7,6,7,6,7,6,8,7,7,6,6,7,5,6,5
    .byte 6,6,7,7,5,6,6,7,5,7,6,7,6,6,5,8,7,8,7,7,4,7,6,7
    .byte 7,7,6,6,8,7,7,7,6,4,7,7,5,5,5,5,6,7,6,6,7,7,5,7
    .byte 5,6,3,6,5,6,7,6,6,5,6,5,6,6,6,5,7,7,7,6,6,6,7,7
    .byte 7,7,8,6,7,7,6,5,5,7,5,7,7,5,7,6,6,6,7,6,6,6,6,5
    .byte 7,7,7,6,6,5,6,6,7,6,7,7,6,7,7,8,7,7,5,6,7,5,6,5
    .byte 5,5,7,7,6,7,7,6,6,6,7,2,6,6,7,7,6,7,5,6,6,7,5,7
    .byte 6,6,7,7,6,7,7,7,7,7,7,7,6,7,6,6,6,6,7,6,7,6,6,6
    .byte 6,6,6,7,6,7,6,6,5,7,8,7,7,6,5,7,6,7,7,7,7,6,7,7
    .byte 7,6,7,5,6,7,5,5,4,6,6,7,7,6,7,8,6,7,6,7,3,5,6,6
    .byte 7,5,7,6,6,6,6,6,6,6,6,7,7,7,6,6,7,6,8,7,7,5,7,7
    .byte 6,5,6,7,6,6,6,6,7,5,7,6,7,5,7,5,5,6,7,8,7,6,7,5
    .byte 7,5,7,7,7,6,6,8,7,7,7,7,6,5,6,5,5,4,5,7,7,6,6,6
    .byte 6,8,6,5,7,5,6,6,5,6,7,6,4,6,7,6,6,7,7,7,7,6,5,7
    .byte 6,5,5,6,6,7,6,6,7,5,7,7,7,6,8,7,7,8,7,7,6,5,5,6
    .byte 7,7,6,7,7,6,7,6,4,6,6,7,5,6,6,6,7,5,7,7,7,5,5,6
    .byte 5,4,5,7,5,7,6,6,6,7,5,7,5,7,5,6,5,6,7,5,7,4,7,5
    .byte 6,6,6,7,7,6,7,7,7,7,6,5,6,6,6,6,7,6,5,6,7,8,7,6
    .byte 7,7,6,6,7,7,7,6,7,6,7,6,5,7,8,7,7,6,6,6,7,6,6,5
    .byte 6,7,7,8,6,6,3,7,6,6,4,6,6,8,6,8,7,6,8,5,7,6,5,5
    .byte 7,3,7,6,7,7,6,7,5,6,7,7,6,7,6,7,7,7,4,6,6,6,7,7
    .byte 7,7,7,6,7,6,7,7,7,7,7,7,7,6,7,7,7,6,7,7,7,7,7,7
    .byte 7,5,7,7,7,7,6,7,5,6,6,5,7,7,7,4,6,6,5,5,6,6,5,7
    .byte 5,7,6,6,7,7,7,6,3,6,6,7,5,7,7,6,5,6,7,5,6,7,7,7
    .byte 7,7,7,7,5,6,6,8,6,4,7,8,6,7,6,7,7,7,6,7,7,8,7,6
    .byte 6,6,6,7,7,6,7,8,7,7,6,5,7,6,7,6,6,6,5,6,6,6,6,7
    .byte 7,6,5,5,6,6,7,4,5,5,7,6,5,7,6,5,7,6,4,6,7,6,7,7
    .byte 7,3,7,7,7,6,7,7,7,7,6,6,7,5,5,7,7,6,7,7,7,8,5,7
    .byte 7,7,8,6,7,7,7,7,6,7,7,7,7,7,7,6,7,7,7,5,6,6,7,7
    .byte 7,7,5,6,5,7,6,6,7,6,5,6,6,4,7,7,6,6,7,6,7,6,6,4
    .byte 6,6,6,6,6,7,6,6,7,5,7,5,6,6,7,7,7,6,7,7,7,7,6,3
    .byte 6,7,6,6,6,6,6,7,5,7,7,7,7,6,7,6,6,7,5,6,7,7,6,7
    .byte 5,8,7,7,6,6,7,7,7,6,6,6,6,6,5,7,6,6,4,6,6,6,7,5
    .byte 3,7,7,7,5,7,6,6,6,6,6,6,7,5,5,7,6,6,7,6,5,6,7,7
    .byte 7,6,7,6,7,7,5,5,7,6,7,5,7,7,7,6,7,5,7,7,7,7,7,6
    .byte 5,5,7,6,6,6,7,8,7,7,6,8,6,5,5,7,6,8,6,6,6,6,7,5
    .byte 6,7,8,2,6,6,7,6,7,7,6,6,6,7,5,6,7,7,7,7,5,6,7,7
    .byte 6,7,7,4,5,6,7,6,5,8,8,7,7,5,7,6,7,6,7,4,7,6,6,6
    .byte 7,5,6,6,7,7,7,6,6,7,6,6,7,6,5,7,8,6,6,8,6,6,6,6
    .byte 6,8,7,6,7,6,7,6,7,8,6,6,5,5,4,7,4,7,7,6,7,4,7,7
    .byte 7,5,7,7,7,7,5,5,7,6,6,7,4,6,5,7,6,6,6,6,6,8,7,7
    .byte 7,5,7,4,6,6,7,6,6,7,6,7,7,6,7,7,7,6,7,7,7,8,7,7
    .byte 6,7,4,6,7,7,7,6,6,6,7,6,6,6,5,7,7,6,6,6,6,4,5,4
    .byte 7,5,7,6,5,7,4,6,6,7,5,6,7,7,5,4,7,7,4,6,7,6,5,6
    .byte 7,7,8,6,6,7,7,7,7,6,6,6,7,6,4,6,6,7,7,6,7,6,7,7
    .byte 5,7,7,7,7,7,7,7,7,7,6,5,8,7,7,5,6,7,7,7,6,7,6,6
    .byte 6,7,7,6,6,6,1,7,6,7,6,7,6,6,7,7,6,5,6,6,6,7,6,7
    .byte 7,5,6,7,5,6,5,6,6,7,6,6,6,8,7,6,6,7,6,7,7,6,7,5
    .byte 6,7,7,7,6,6,7,7,6,7,7,6,7,6,7,7,6,7,6,7,6,7,6,7
    .byte 8,7,6,7,6,6,6,6,6,7,6,6,7,7,6,6,3,5,6,6,6,5,7,8
    .byte 5,6,5,5,7,5,5,7,7,6,6,5,6,7,6,5,5,6,7,7,6,7,6,6
    .byte 6,6,7,6,6,6,4,6,6,7,6,8,7,7,7,7,6,6,6,6,7,6,7,6
    .byte 7,7,6,7,6,6,7,6,7,6,6,6,7,7,5,6,7,5,6,7,5,6,6,7
    .byte 6,6,7,6,5,6,7,5,4,4,5,5,4,7,7,6,7,7,5,6,6,5,5,6
    .byte 7,6,7,6,5,7,6,8,7,6,7,6,6,6,6,8,5,8,6,7,5,7,5,7
    .byte 7,7,5,8,6,7,7,7,6,7,6,7,6,6,6,6,7,7,7,8,5,7,7,7
    .byte 7,5,5,5,6,7,7,7,5,5,6,6,6,7,6,7,2,7,6,6,5,6,7,6
    .byte 6,6,7,4,7,6,6,7,6,6,7,7,7,6,7,6,8,7,6,7,7,6,7,6
    .byte 6,7,7,6,5,5,7,6,6,6,7,7,6,7,7,7,6,6,7,7,7,5,7,7
    .byte 7,7,6,6,7,7,7,7,7,6,7,6,7,6,6,7,6,6,6,4,7,7,5,7
    .byte 6,5,4,5,4,4,6,6,7,7,6,6,5,6,7,6,6,6,5,7,7,7,7,5
    .byte 7,7,7,7,7,7,6,6,6,7,7,6,6,7,3,7,7,6,6,6,6,7,7,7
    .byte 5,7,7,6,7,7,7,6,7,6,7,6,7,7,7,6,7,8,6,7,6,7,5,6
    .byte 6,7,6,5,6,7,5,6,7,5,4,6,6,6,5,6,6,6,7,7,5,3,6,7
    .byte 7,6,4,7,7,6,7,6,7,7,7,8,7,6,7,6,6,6,7,6,7,7,6,5
    .byte 6,7,7,6,6,7,8,6,6,7,6,6,7,7,6,6,7,7,5,7,6,7,6,6
    .byte 7,8,6,5,6,7,6,5,6,5,7,6,6,5,4,7,6,6,6,6,5,6,7,7
    .byte 6,6,5,4,6,8,7,6,8,6,6,7,5,5,5,6,7,6,7,7,6,7,6,6
    .byte 7,7,5,6,7,6,6,4,7,6,7,7,7,5,8,7,6,7,6,7,8,6,6,7
    .byte 7,7,6,6,7,7,6,7,7,7,7,5,8,7,6,6,6,4,6,5,7,4,7,5
    .byte 7,5,7,6,5,5,6,6,7,6,6,6,6,7,5,6,8,7,7,5,7,2,6,6
    .byte 7,6,5,7,7,7,7,6,7,7,7,6,6,6,6,7,4,6,7,7,7,6,7,7
    .byte 7,6,7,7,7,6,6,7,6,7,7,6,7,8,7,7,7,4,7,7,7,6,6,6
    .byte 7,6,7,6,6,6,5,7,6,6,7,6,7,2,7,7,6,7,5,6,5,7,6,5
    .byte 6,6,5,6,6,7,5,5,6,6,6,7,7,7,7,7,7,7,7,5,6,5,7,6
    .byte 7,6,6,6,7,6,7,8,7,6,6,6,7,7,6,6,6,7,6,6,7,6,8,8
    .byte 7,6,5,6,7,7,7,7,6,6,6,7,7,6,6,4,7,7,6,6,7,3,6,5
    .byte 7,7,7,7,4,6,6,6,5,6,5,7,7,6,6,6,6,5,6,6,6,7,6,7
    .byte 7,6,7,4,6,7,6,6,7,7,6,6,7,7,6,7,6,7,6,6,7,7,7,7
    .byte 6,7,7,6,7,6,7,7,8,6,6,6,7,6,7,6,7,7,6,6,6,6,6,6
    .byte 5,6,6,6,7,5,3,6,7,7,5,6,5,6,5,6,7,7,7,6,5,6,7,6
    .byte 6,6,5,6,6,6,7,5,7,6,7,8,6,6,6,7,7,6,6,6,7,6,6,5
    .byte 7,7,7,7,7,6,6,6,6,5,7,5,7,8,7,7,7,7,6,4,6,7,7,7
    .byte 6,7,6,6,7,5,6,6,7,6,5,6,7,4,7,6,6,5,6,5,6,5,5,5
    .byte 7,7,5,5,6,8,7,5,7,4,7,5,6,5,6,8,7,6,7,6,7,7,7,4
    .byte 7,7,7,7,7,7,6,7,6,7,6,7,7,5,7,6,7,7,5,5,6,6,7,6
    .byte 5,7,7,6,6,5,7,6,7,6,6,7,6,7,6,8,7,6,6,6,5,6,6,6
    .byte 7,4,4,5,6,5,5,6,6,6,7,7,5,5,7,6,6,6,7,4,6,6,6,6
    .byte 6,7,7,7,5,6,7,6,6,7,7,6,7,7,7,7,5,7,7,6,7,7,7,6
    .byte 7,6,7,6,7,6,6,7,7,6,7,6,6,6,7,7,6,7,7,7,6,7,5,7
    .byte 6,6,7,2,7,7,7,6,6,7,5,6,7,7,4,5,7,7,8,6,6,7,7,7
    .byte 5,7,7,4,6,7,7,5,6,8,8,6,6,6,8,7,8,7,8,5,6,7,7,7
    .byte 7,6,5,7,8,7,7,6,7,8,6,6,6,5,5,7,8,7,6,7,6,7,7,7
    .byte 7,8,8,7,6,7,6,7,7,7,6,7,4,7,6,5,7,6,7,2,7,6,6,6
    .byte 6,7,7,7,5,6,5,7,5,5,6,6,6,7,6,7,6,7,6,7,7,6,7,7
    .byte 6,7,7,7,8,7,7,6,6,7,6,5,6,7,7,7,7,7,7,7,5,6,6,7
    .byte 6,7,6,6,6,5,7,6,7,7,7,6,7,8,6,6,6,6,7,7,7,6,5,7
    .byte 6,5,6,6,4,4,6,3,5,7,7,6,7,7,7,6,6,6,6,6,7,5,7,7
    .byte 7,7,4,6,6,7,6,6,7,6,7,6,7,7,7,7,7,4,7,6,6,7,7,5
    .byte 6,7,7,6,6,8,6,7,6,6,7,6,7,7,6,6,6,7,6,7,8,6,7,7
    .byte 6,5,6,7,7,7,6,6,7,6,6,6,7,6,4,5,5,5,5,7,7,6,7,7
    .byte 6,6,6,6,4,7,7,6,6,6,4,6,7,7,7,6,7,7,5,7,7,8,5,7
    .byte 7,7,6,6,4,7,7,6,6,7,7,6,6,6,6,6,5,7,7,6,6,5,6,7
    .byte 6,7,5,6,7,6,7,6,6,5,7,7,8,7,6,5,6,7,5,6,7,5,4,6
    .byte 6,6,4,7,5,7,7,7,4,4,7,7,6,5,5,6,7,6,6,5,7,7,6,8
    .byte 6,7,6,7,6,5,7,7,7,7,6,6,5,7,6,6,6,6,7,7,7,7,7,5
    .byte 7,6,6,6,7,6,4,7,6,6,7,6,7,7,6,6,7,7,6,5,6,6,8,7
    .byte 4,5,5,7,5,7,5,6,7,5,7,6,7,5,5,7,7,5,3,7,7,5,6,7
    .byte 6,6,5,7,6,7,6,6,6,7,6,7,6,7,6,7,7,5,7,7,7,6,5,7
    .byte 6,7,6,6,7,6,6,6,6,7,7,6,7,7,4,7,6,6,6,6,7,7,7,7
    .byte 7,7,6,7,7,7,6,6,6,1,7,7,7,7,7,7,5,7,7,6,6,5,6,6
    .byte 7,6,7,7,6,6,6,6,7,6,7,6,8,6,7,6,7,6,5,6,7,7,6,7
    .byte 7,7,6,7,7,7,7,5,6,7,7,6,7,7,7,7,6,6,7,6,6,6,6,7
    .byte 7,7,6,7,7,5,7,6,6,7,7,7,7,7,7,7,7,5,5,5,5,7,4,6
    .byte 7,6,6,3,7,7,7,6,6,7,7,7,5,4,7,7,6,7,5,6,6,6,7,6
    .byte 6,5,7,8,7,7,7,6,7,5,7,6,7,7,6,6,6,7,6,6,7,7,6,5
    .byte 7,7,7,7,6,7,6,6,5,5,7,6,7,5,7,7,8,6,7,6,6,7,7,7
    .byte 6,5,7,7,4,5,5,6,6,5,6,7,6,5,4,6,7,4,6,7,7,6,6,5
    .byte 7,7,7,5,6,7,6,6,7,7,5,6,5,6,8,6,6,7,5,6,5,7,7,7
    .byte 7,7,7,6,7,5,7,7,6,7,7,6,7,8,6,7,6,6,6,5,6,6,6,6
    .byte 7,7,6,6,7,6,6,7,6,6,6,6,6,5,7,4,5,4,4,6,7,7,5,7
    .byte 6,7,6,5,6,4,6,6,6,6,6,7,5,7,7,7,6,6,7,6,6,7,5,7
    .byte 7,6,6,7,6,8,6,7,7,5,7,6,7,7,7,7,6,7,7,7,6,6,6,6
    .byte 7,7,5,7,7,7,7,6,3,7,7,7,6,6,6,7,7,6,7,7,7,3,7,6
    .byte 6,5,6,5,7,6,7,6,7,7,5,7,5,6,4,7,4,6,6,6,6,5,7,6
    .byte 5,7,6,5,6,7,7,6,6,5,6,7,7,6,8,6,7,7,6,6,5,7,6,6
    .byte 7,6,7,6,7,7,6,6,6,7,7,6,8,6,6,7,5,6,7,7,6,6,7,6
    .byte 7,7,6,7,8,7,6,5,6,5,4,5,6,6,7,6,7,7,7,6,7,5,7,4
    .byte 5,5,6,7,4,7,5,6,6,5,7,5,7,6,7,7,7,6,7,7,5,7,7,7
    .byte 6,6,6,6,5,7,8,7,5,6,7,7,5,7,7,6,6,6,5,6,7,6,8,7
    .byte 7,6,5,7,6,6,7,7,5,5,8,8,8,6,7,4,6,7,6,5,6,5,6,6
    .byte 6,7,7,6,7,6,7,7,2,6,6,7,6,6,7,6,6,7,6,6,7,7,6,7
    .byte 7,6,6,7,6,6,7,7,7,5,7,7,7,6,6,6,7,7,7,7,7,7,6,6
    .byte 6,6,7,7,7,6,6,7,7,6,5,5,6,7,7,6,7,7,6,7,7,6,7,8
    .byte 4,6,6,7,5,6,5,6,5,7,5,6,6,5,5,6,7,6,5,7,6,6,6,7
    .byte 3,5,5,7,6,4,7,6,8,8,6,8,6,7,7,7,6,6,7,5,6,7,6,7
    .byte 7,8,6,7,7,7,6,6,7,6,6,5,7,6,6,8,7,6,6,7,5,7,6,6
    .byte 6,7,6,7,6,7,7,6,6,5,7,6,5,7,7,3,6,6,7,7,6,7,3,6
    .byte 6,7,6,6,6,7,7,6,7,6,6,5,5,7,6,7,6,7,7,5,7,5,7,7
    .byte 7,7,7,7,6,7,6,7,7,7,6,6,5,7,7,6,6,7,6,6,6,6,7,6
    .byte 6,6,8,5,7,7,7,6,6,7,8,7,6,6,7,7,6,6,4,7,6,7,7,6
    .byte 7,2,6,7,6,6,5,6,5,7,6,5,7,5,6,6,7,7,5,6,6,6,6,6
    .byte 7,7,7,6,7,6,7,6,7,6,7,6,7,6,7,7,7,6,6,8,7,7,6,5
    .byte 7,7,6,6,5,7,6,6,7,7,7,7,7,6,6,6,7,6,7,8,7,7,6,7
    .byte 7,6,6,6,6,5,6,6,6,5,6,5,5,7,7,5,5,6,5,7,7,7,7,7
    .byte 6,5,8,5,4,4,5,6,6,8,6,6,7,5,7,7,6,6,7,7,6,7,5,7
    .byte 6,6,7,8,4,7,6,6,6,5,7,8,6,5,6,7,7,5,6,7,7,5,7,7
    .byte 7,6,4,8,7,6,6,7,5,6,6,7,6,5,6,6,6,5,6,7,7,7,5,6
    .byte 7,7,5,5,7,6,6,7,6,6,6,6,4,6,6,6,7,7,8,6,7,5,6,7
    .byte 5,6,5,6,7,7,7,6,7,6,6,6,7,6,7,6,6,7,7,7,7,6,5,7
    .byte 7,7,7,7,8,7,7,7,5,7,7,6,6,6,5,5,7,4,6,7,7,3,6,7
    .byte 7,5,6,5,8,5,7,6,6,7,4,7,7,5,6,7,3,7,7,6,6,7,6,5
    .byte 7,7,7,7,7,6,7,7,7,5,6,6,6,7,7,7,7,7,6,8,5,7,7,7
    .byte 7,7,6,7,6,8,7,7,7,7,7,7,7,7,7,6,6,7,7,7,7,5,8,6
    .byte 5,6,4,7,7,7,5,6,5,5,6,6,7,4,7,6,7,6,6,6,6,7,6,4
    .byte 5,7,6,5,7,7,6,4,6,7,5,7,7,7,8,7,7,6,6,6,6,6,7,6
    .byte 5,7,7,6,6,7,7,6,7,5,6,7,7,7,6,7,6,6,7,6,7,6,7,7
    .byte 7,6,6,7,7,8,7,7,5,4,5,6,7,6,7,4,5,5,6,5,6,7,6,7
    .byte 6,6,6,6,6,6,6,7,5,6,6,6,7,6,6,3,6,5,7,6,7,7,7,7
    .byte 7,6,7,6,7,5,6,6,6,6,6,7,5,6,7,7,7,7,7,7,6,7,6,7
    .byte 7,5,7,7,7,5,5,6,7,7,7,5,7,7,7,7,6,5,5,7,6,8,6,6
    .byte 6,6,5,6,7,7,8,4,6,6,7,6,5,6,6,6,6,5,4,7,6,5,8,7
    .byte 6,3,7,6,6,7,7,7,8,7,7,7,7,5,5,6,7,6,6,7,7,7,5,7
    .byte 7,6,8,5,6,7,7,7,6,6,7,7,7,7,7,7,7,7,7,5,6,7,6,7
    .byte 7,7,4,5,6,6,7,6,6,3,6,7,6,6,5,4,8,6,8,5,7,6,5,6
    .byte 7,6,7,7,4,6,7,6,6,6,6,5,6,7,6,6,7,7,7,7,7,6,5,6
    .byte 5,7,6,7,6,7,7,7,4,7,7,7,7,7,6,6,5,7,7,6,7,7,7,7
    .byte 6,7,8,7,6,6,7,7,8,5,7,7,5,7,5,6,6,7,3,6,5,7,6,7
    .byte 8,6,6,6,7,6,5,7,7,7,7,6,6,7,7,6,6,7,3,5,6,7,5,6
    .byte 7,7,7,8,5,7,6,7,6,6,5,7,7,6,6,6,5,7,6,6,7,7,6,5
    .byte 7,5,6,7,6,6,8,7,5,6,7,6,6,7,5,7,7,7,6,7,5,6,6,7
    .byte 7,6,5,6,5,6,7,5,6,7,7,7,7,5,6,7,7,5,5,7,6,7,7,7
    .byte 5,7,6,5,6,6,6,6,7,8,7,6,6,6,8,6,6,4,6,7,6,6,6,7
    .byte 5,7,5,7,6,6,6,7,7,7,6,7,6,6,7,6,6,8,6,7,6,7,6,6
    .byte 7,8,6,7,5,5,6,6,4,6,6,7,6,6,7,7,5,6,7,4,5,4,4,4
    .byte 5,7,7,6,7,6,4,6,6,5,6,5,7,6,7,7,6,7,5,8,7,7,7,7
    .byte 7,7,7,7,6,7,7,7,5,7,6,7,6,6,5,7,6,7,6,7,6,7,7,7
    .byte 6,7,6,7,6,7,7,7,6,7,7,7,7,6,6,6,5,7,6,6,4,6,6,6
    .byte 7,6,6,7,3,6,5,5,4,6,7,7,7,7,7,4,6,7,6,7,5,6,7,7
    .byte 7,5,7,6,8,6,6,7,7,6,6,7,6,7,6,7,6,5,7,6,7,6,6,6
    .byte 6,7,7,6,7,7,7,7,7,5,7,7,6,6,7,7,7,7,6,7,7,7,6,6
    .byte 7,5,6,6,5,5,5,6,7,6,6,7,6,4,5,5,5,4,6,7,7,7,7,6
    .byte 3,5,7,6,7,4,7,7,7,7,6,7,6,7,7,7,7,7,6,6,6,6,6,7
    .byte 7,7,5,7,7,7,5,5,6,7,7,6,6,6,7,8,6,7,6,7,7,6,7,7
    .byte 8,7,7,6,8,7,6,7,6,7,5,7,5,6,5,6,5,7,7,5,7,7,4,5
    .byte 5,5,3,6,7,7,7,7,6,4,6,6,6,6,5,6,7,7,7,6,6,6,7,7
    .byte 7,7,8,6,6,7,7,7,6,7,7,4,6,7,6,5,6,6,7,7,7,5,7,7
    .byte 7,7,8,6,6,7,7,7,7,7,8,7,6,7,7,6,7,7,7,4,7,6,6,5
    .byte 7,5,5,6,6,6,6,7,6,6,6,7,6,6,4,4,6,7,6,6,7,6,7,7
    .byte 5,6,6,6,7,6,7,7,7,6,7,7,6,6,5,6,7,6,6,5,7,6,6,6
    .byte 8,5,7,6,6,7,6,7,7,6,6,6,7,7,7,7,7,7,7,6,6,7,7,6
    .byte 7,6,5,6,7,3,6,6,7,4,6,5,7,5,7,7,6,6,6,7,7,6,7,7
    .byte 7,7,6,6,7,7,6,5,7,2,6,6,8,6,6,6,7,8,7,6,8,7,7,6
    .byte 6,6,6,7,5,6,6,6,7,6,6,8,7,6,6,7,6,6,6,6,6,7,7,5
    .byte 6,7,7,7,7,4,8,7,8,7,6,5,6,6,7,7,5,6,3,7,7,7,5,6
    .byte 4,7,5,7,6,7,7,5,6,6,5,6,6,4,7,7,5,6,6,7,5,6,6,7
    .byte 7,6,7,7,7,7,5,6,7,5,7,6,7,7,7,7,7,5,7,6,7,7,7,6
    .byte 7,6,7,7,7,7,6,7,6,7,7,8,7,7,6,7,7,7,5,8,7,5,7,5
    .byte 7,7,6,6,7,5,6,6,6,7,3,7,6,7,6,6,6,6,7,6,5,5,7,5
    .byte 5,7,7,6,4,6,7,6,8,6,7,8,8,7,7,7,6,5,5,6,5,6,6,6
    .byte 6,6,6,6,7,8,5,5,7,7,7,6,7,7,7,7,6,7,7,7,7,7,6,5
    .byte 6,7,7,7,6,5,5,5,7,7,6,7,4,6,4,7,5,7,7,7,7,5,6,6
    .byte 6,6,7,7,7,6,5,6,7,6,6,6,3,6,5,7,6,6,7,7,7,7,6,8
    .byte 7,6,6,5,6,6,6,6,7,6,6,8,7,6,7,7,7,6,6,6,7,7,6,7
    .byte 7,7,4,6,6,7,7,7,5,7,7,7,7,7,4,6,7,6,7,6,6,5,6,4
    .byte 6,6,7,7,4,7,5,7,6,6,5,5,7,7,5,5,7,6,4,7,7,6,4,6
    .byte 6,6,7,6,7,8,7,6,7,7,6,6,6,6,5,6,6,7,7,5,7,6,7,7
    .byte 4,6,7,6,6,7,7,7,7,7,6,6,7,8,6,6,6,6,7,7,7,6,7,5
    .byte 5,6,7,7,5,6,2,7,7,7,6,6,5,7,6,7,5,6,6,5,6,7,6,7
    .byte 7,4,6,7,5,5,6,6,6,7,6,6,7,7,7,7,7,6,6,6,7,6,6,6
    .byte 6,7,7,7,7,5,8,7,6,6,6,5,7,6,7,7,7,7,6,7,6,7,6,7
    .byte 7,6,7,8,7,7,6,7,7,6,7,5,7,6,7,7,4,6,7,6,6,6,7,7
    .byte 6,6,6,6,7,4,5,7,7,6,7,6,6,6,6,5,5,5,7,6,6,8,6,7
    .byte 6,6,7,6,7,5,5,7,7,6,5,7,6,6,6,7,6,6,5,7,6,6,7,7
    .byte 7,6,7,7,6,7,7,7,7,7,6,6,8,7,5,6,6,4,6,7,4,5,7,7
    .byte 6,4,4,6,6,7,6,7,7,5,7,7,7,6,6,7,6,7,7,6,7,7,8,7
    .byte 6,6,7,7,6,6,6,7,7,7,7,8,7,5,6,5,5,5,7,6,6,6,6,6
    .byte 7,6,6,6,6,7,6,7,6,7,6,5,6,6,6,6,7,5,6,6,7,5,6,5
    .byte 7,5,6,5,7,7,7,5,7,3,5,5,7,7,6,7,7,6,7,7,4,6,7,6
    .byte 7,7,6,7,7,7,7,7,7,6,7,7,7,7,6,7,7,7,7,7,7,5,7,6
    .byte 5,5,6,7,7,7,6,7,7,6,7,7,6,7,6,7,6,7,7,4,8,7,6,7
    .byte 6,4,7,6,6,6,6,6,4,5,6,7,7,6,6,5,8,6,6,4,5,7,7,6
    .byte 5,7,8,5,7,6,6,5,6,6,7,7,6,7,7,6,8,7,7,7,6,7,7,7
    .byte 6,7,7,7,7,8,7,5,7,6,5,4,6,7,7,7,7,7,7,7,6,6,6,7
    .byte 7,7,6,7,6,5,6,7,7,7,6,5,6,6,6,5,5,5,7,4,6,6,7,6
    .byte 6,6,7,4,4,6,7,6,7,7,7,6,6,6,5,6,7,7,7,7,6,6,7,7
    .byte 7,7,7,7,7,7,6,7,7,7,6,7,8,7,6,6,7,6,4,5,6,7,6,7
    .byte 7,7,6,7,6,6,5,7,6,6,6,6,7,5,7,7,6,6,6,5,7,7,7,5
    .byte 6,6,4,5,7,7,6,6,6,6,7,6,7,5,7,7,6,6,6,6,7,7,6,7
    .byte 7,6,6,7,6,6,6,6,6,7,7,7,6,7,7,7,6,7,6,6,7,7,7,7
    .byte 7,7,4,7,6,6,6,7,6,4,7,7,7,7,7,7,7,7,6,6,6,6,6,6
    .byte 6,6,7,4,7,7,5,7,6,5,6,6,7,4,5,5,7,6,6,6,6,5,7,7
    .byte 7,5,7,7,7,5,8,7,5,6,7,6,6,6,5,6,5,6,7,7,7,6,7,7
    .byte 6,6,5,6,7,7,7,7,7,4,6,7,6,5,7,6,7,5,5,7,7,7,7,8
    .byte 7,8,7,8,5,7,6,5,6,6,6,7,7,6,6,7,6,6,7,6,6,4,7,6
    .byte 6,5,7,6,7,5,5,6,7,7,6,6,6,7,5,6,7,7,6,6,8,6,6,4
    .byte 7,7,6,7,6,7,6,6,7,7,5,6,7,7,7,7,6,6,6,4,5,6,5,7
    .byte 8,6,7,7,6,7,7,7,7,7,6,7,6,7,6,4,6,6,8,6,6,7,8,5
    .byte 6,4,6,4,6,6,4,5,6,7,6,7,7,6,6,6,5,6,5,6,6,6,6,7
    .byte 6,6,7,7,6,7,5,7,5,6,7,5,7,7,6,7,7,7,6,7,6,6,7,6
    .byte 7,7,7,6,5,5,7,7,6,5,7,7,6,6,6,7,7,6,7,7,7,6,6,7
    .byte 6,5,6,6,7,6,6,7,7,7,7,4,6,4,6,5,5,6,6,7,6,5,8,7
    .byte 7,5,6,6,5,6,7,5,6,7,6,6,6,6,6,7,6,7,7,6,7,5,7,7
    .byte 7,7,7,7,7,7,7,7,7,7,7,6,7,6,7,7,6,6,7,6,3,6,7,7
    .byte 6,8,7,5,6,8,6,6,6,7,6,7,7,6,6,5,6,6,6,6,6,4,8,7
    .byte 5,7,7,6,5,6,7,5,5,6,6,7,7,6,6,6,7,6,6,7,6,5,6,7
    .byte 7,7,7,7,7,7,7,6,7,5,7,8,7,5,7,7,8,7,7,7,6,6,7,7
    .byte 6,5,8,6,6,5,7,7,7,7,7,7,7,6,7,6,7,5,6,7,7,7,7,6
    .byte 5,7,7,7,7,4,7,7,7,6,6,6,7,5,8,7,6,5,7,6,6,5,7,6
    .byte 7,4,7,6,6,7,6,7,5,6,7,7,6,7,7,7,7,6,7,6,6,7,7,6
    .byte 7,7,7,5,7,7,8,7,5,6,7,6,6,5,5,7,7,6,7,7,8,6,6,6
    .byte 5,6,6,6,6,7,7,7,6,6,7,5,6,6,7,6,6,7,7,7,6,6,6,6
    .byte 6,4,7,6,7,6,7,4,6,6,6,6,5,7,7,7,5,6,7,7,6,5,7,8
    .byte 6,7,6,8,7,7,7,7,6,7,6,7,6,6,6,5,7,7,7,6,7,5,5,5
    .byte 6,7,7,6,6,7,6,6,6,6,5,5,5,7,7,7,6,7,5,6,5,6,5,5
    .byte 7,6,7,6,7,7,5,6,6,5,7,5,6,5,6,7,6,7,7,6,6,8,6,7
    .byte 6,7,5,6,5,7,7,6,7,7,7,7,6,7,7,7,6,7,7,7,7,7,6,6
    .byte 7,6,4,6,6,7,7,6,7,5,7,7,7,7,6,7,7,7,7,5,6,5,7,7
    .byte 6,6,7,3,7,7,6,6,6,6,5,6,7,5,5,4,7,6,7,5,6,6,6,6
    .byte 6,6,7,7,6,5,6,6,8,7,6,7,5,6,5,6,7,7,7,6,7,7,5,7
    .byte 7,6,5,7,7,7,6,7,6,6,5,6,7,5,6,7,6,7,7,5,7,6,7,8
    .byte 6,6,6,6,7,6,5,6,6,7,6,6,6,7,6,6,4,6,5,6,6,5,5,7
    .byte 7,5,7,7,6,6,6,6,5,6,7,7,5,6,7,7,7,6,7,5,6,6,7,5
    .byte 7,7,5,7,7,7,7,6,7,6,7,7,6,7,7,7,7,8,6,5,6,6,7,5
    .byte 5,7,7,6,7,7,7,6,7,7,7,7,6,5,7,7,5,7,6,6,5,6,6,7
    .byte 7,6,4,7,4,7,6,5,7,5,7,5,5,7,7,4,6,7,7,6,8,6,7,4
    .byte 7,6,6,5,7,6,7,6,6,6,6,7,7,7,6,6,7,7,7,7,4,7,7,8
    .byte 7,7,8,5,6,6,7,4,7,7,6,6,6,7,7,7,7,7,7,7,6,7,5,6
    .byte 6,6,6,5,6,7,6,7,6,7,6,5,7,7,6,4,7,7,6,5,7,7,6,6
    .byte 6,5,6,7,5,7,7,4,7,7,6,6,6,6,6,7,5,6,6,7,7,6,7,8
    .byte 6,7,7,7,6,7,6,7,7,8,7,7,6,5,6,7,6,6,7,6,4,6,7,7
    .byte 6,7,6,5,6,7,6,6,7,6,5,7,6,6,5,5,7,7,6,5,5,4,7,7
    .byte 5,7,7,7,6,7,6,5,4,7,7,5,5,7,7,6,5,6,5,6,7,6,7,6
    .byte 5,7,7,7,7,7,8,7,7,7,5,6,7,7,6,7,7,6,5,7,7,7,6,5
    .byte 6,7,7,7,4,6,7,6,7,7,6,7,7,6,7,6,7,6,6,6,7,7,7,5
    .byte 6,7,6,5,6,6,5,6,6,7,7,6,6,7,6,7,3,6,5,6,7,7,5,7
    .byte 5,7,5,6,8,7,7,5,6,7,8,5,6,6,7,6,7,7,8,7,6,7,7,6
    .byte 7,5,7,6,6,7,4,7,7,7,7,7,5,6,6,7,7,7,5,7,7,6,7,7
    .byte 6,6,5,6,7,7,7,5,7,5,6,6,5,5,5,8,6,7,6,7,6,6,7,7
    .byte 4,6,5,6,6,6,8,6,7,6,6,6,6,7,6,6,6,8,6,7,6,6,7,7
    .byte 8,7,7,4,7,8,7,6,6,7,7,7,7,6,7,6,7,7,7,5,7,6,5,6
    .byte 7,8,7,6,7,6,7,5,6,6,6,6,6,6,7,6,6,6,5,7,7,6,6,3
    .byte 7,7,6,6,6,7,7,6,8,7,6,4,6,6,6,6,7,7,5,6,6,7,6,6
    .byte 7,6,5,6,6,7,7,8,7,6,6,8,6,6,6,6,6,6,8,5,6,6,7,7
    .byte 7,6,7,7,6,6,7,7,7,6,7,6,6,6,6,6,5,6,7,5,7,6,6,3
    .byte 6,5,7,7,5,7,6,6,6,6,6,6,6,6,6,5,6,5,7,6,6,5,7,5
    .byte 7,8,5,7,5,6,7,7,6,5,6,6,7,7,6,7,8,8,7,8,7,5,7,7
    .byte 6,6,6,6,7,8,6,8,6,5,8,6,6,7,7,7,8,7,7,7,6,6,6,7
    .byte 5,6,5,6,6,7,7,2,7,5,7,7,6,6,6,5,7,6,7,7,5,6,7,7
    .byte 6,6,6,6,7,6,6,6,6,6,8,7,6,7,6,6,7,6,6,5,6,6,7,6
    .byte 7,7,7,6,7,8,7,5,7,6,6,5,7,6,7,6,6,8,6,6,7,6,7,6
    .byte 7,7,8,5,6,7,6,5,6,6,5,6,6,6,6,6,6,3,7,4,6,6,6,7
    .byte 5,6,7,6,6,6,6,7,6,6,5,6,7,5,7,6,6,6,7,7,6,6,6,6
    .byte 6,7,6,6,5,7,6,6,7,7,8,7,7,7,7,6,6,6,5,6,6,6,6,7
    .byte 7,8,5,6,7,7,6,7,7,8,7,6,7,7,6,6,5,6,4,6,6,6,6,7
    .byte 7,3,6,5,6,6,6,7,7,6,7,5,7,7,5,7,7,7,5,6,6,6,7,6
    .byte 4,7,7,7,6,6,7,5,7,7,7,5,6,7,6,5,5,6,7,6,7,7,7,7
    .byte 6,7,8,7,4,6,6,6,7,7,6,7,7,7,6,7,7,7,7,6,7,4,7,7
    .byte 6,7,7,7,7,7,7,5,4,5,7,5,6,5,6,5,7,6,7,6,7,7,6,6
    .byte 7,7,6,4,6,7,7,6,6,7,8,6,7,7,5,6,6,6,5,6,7,7,5,7
    .byte 7,7,6,7,7,6,6,7,7,6,7,7,6,7,6,6,7,7,7,7,6,6,7,6
    .byte 6,7,7,7,8,7,5,5,6,7,6,7,7,6,5,5,6,7,7,3,7,7,6,5
    .byte 5,7,6,7,7,5,7,5,5,6,5,7,6,7,6,6,7,7,6,7,7,6,6,6
    .byte 5,6,6,6,6,6,7,6,7,7,7,5,7,7,7,6,7,7,7,7,7,6,6,6
    .byte 7,7,7,6,7,6,5,7,7,6,6,6,7,7,7,5,4,6,7,7,7,7,7,5
    .byte 6,6,4,5,4,5,7,6,6,5,7,6,7,5,7,6,6,7,6,6,7,7,5,7
    .byte 6,6,7,6,7,7,7,7,7,6,6,6,6,4,6,7,7,6,7,7,7,6,7,7
    .byte 7,7,7,7,7,6,6,6,4,6,6,6,7,7,6,6,6,6,7,6,6,7,8,7
    .byte 7,5,6,6,6,7,6,7,6,6,4,7,6,6,4,3,7,7,6,7,6,7,6,6
    .byte 7,7,6,6,7,6,5,5,7,6,7,7,7,6,7,6,6,6,5,7,7,5,6,6
    .byte 6,6,6,7,7,5,7,8,7,5,7,7,7,7,7,7,6,6,8,6,8,6,5,7
    .byte 7,7,7,7,7,6,7,6,5,5,6,6,7,7,7,4,7,6,4,6,5,7,6,6
    .byte 7,6,4,6,7,6,6,6,5,6,7,7,5,6,7,6,7,6,7,6,6,7,7,7
    .byte 5,6,7,6,6,7,6,7,7,7,6,6,6,7,5,6,8,7,6,7,6,7,6,7
    .byte 6,6,6,7,6,7,5,5,6,7,7,7,7,7,7,7,6,7,7,6,6,7,5,7
    .byte 6,7,5,3,6,6,7,4,6,7,7,4,7,7,6,6,6,6,6,6,7,6,6,6
    .byte 6,7,6,6,6,7,4,7,7,5,6,6,6,6,8,7,6,6,5,7,7,7,6,6
    .byte 7,7,8,7,6,7,7,7,7,7,5,8,7,7,6,6,6,7,7,7,8,7,7,7
    .byte 6,7,7,7,6,7,6,6,7,6,5,6,7,7,4,6,7,7,7,5,7,6,8,7
    .byte 5,6,4,6,6,7,6,7,8,7,6,7,7,6,5,6,6,7,6,5,5,8,7,6
    .byte 5,6,7,7,5,6,6,7,6,6,7,6,6,7,6,6,7,7,7,7,7,7,6,6
    .byte 6,7,5,6,7,7,6,7,6,7,7,5,6,6,8,6,5,7,5,6,4,5,4,5
    .byte 5,6,7,6,4,6,6,7,6,6,6,6,7,6,6,6,7,6,5,7,7,7,6,6
    .byte 5,7,8,7,6,7,6,6,7,6,6,5,6,6,6,6,6,6,7,7,6,7,8,7
    .byte 6,7,7,7,5,7,6,6,7,7,6,7,8,7,6,7,8,7,6,6,6,3,6,6
    .byte 6,6,6,7,7,7,6,6,4,5,6,4,6,6,6,5,6,7,7,7,6,6,6,6
    .byte 7,6,5,5,6,6,6,6,6,5,8,8,7,6,5,4,5,6,6,5,7,6,6,7
    .byte 7,7,4,7,7,6,5,7,8,7,7,7,6,5,7,7,7,6,7,6,6,6,6,7
    .byte 7,5,7,6,7,7,5,5,5,7,7,7,7,6,6,6,7,4,4,5,5,7,6,6
    .byte 6,7,5,7,5,6,6,6,6,6,7,7,7,6,7,7,6,6,7,7,6,7,7,7
    .byte 6,6,6,7,5,6,8,7,7,7,6,6,6,7,6,8,7,7,7,7,6,6,7,5
    .byte 5,5,7,7,7,7,6,7,6,8,7,7,7,7,6,6,6,7,6,7,7,6,7,7
    .byte 7,3,8,6,6,4,4,7,8,7,7,6,7,7,7,6,6,6,6,7,5,5,5,7
    .byte 7,7,7,6,7,6,7,6,5,6,6,6,6,6,7,7,6,7,6,7,6,6,7,6
    .byte 7,7,7,6,7,6,6,7,5,5,7,7,7,7,6,7,7,6,7,7,7,7,7,7
    .byte 5,6,6,7,6,7,6,6,6,4,7,6,6,4,7,6,6,6,5,8,7,8,7,5
    .byte 6,5,4,5,5,7,6,8,7,7,7,7,6,5,7,7,6,7,5,6,8,6,7,5
    .byte 6,6,7,6,6,4,7,8,7,6,6,7,6,6,7,7,5,7,7,5,7,7,5,7
    .byte 7,7,7,7,7,6,7,6,6,5,7,6,6,7,6,4,6,6,5,6,5,7,5,7
    .byte 7,6,3,6,7,7,6,5,6,6,7,6,5,7,6,6,6,7,6,6,6,5,6,7
    .byte 6,7,7,5,7,7,8,7,6,6,7,8,6,6,5,6,7,7,7,7,8,6,7,7
    .byte 7,6,7,7,6,6,6,5,7,6,7,7,7,6,8,7,6,7,6,6,6,6,7,7
    .byte 6,4,6,7,7,4,6,7,7,6,5,7,6,7,7,5,6,4,7,6,7,7,7,7
    .byte 7,7,8,7,6,4,5,6,6,6,6,5,7,7,6,6,6,7,7,5,7,6,6,5
    .byte 6,7,6,7,7,7,6,7,6,6,7,7,6,5,7,6,7,6,6,7,7,7,7,7
    .byte 6,8,6,7,6,7,7,5,7,5,6,5,5,5,5,6,5,7,7,3,7,6,7,7
    .byte 5,6,5,7,6,6,6,7,7,6,7,7,6,6,6,6,8,7,6,7,6,6,6,6
    .byte 6,7,6,7,7,7,5,6,5,6,7,8,7,6,7,7,5,6,6,6,6,6,6,6
    .byte 5,6,6,6,8,7,7,7,7,7,6,6,7,5,7,7,5,6,7,6,6,4,6,6
    .byte 7,4,7,7,7,4,7,7,7,6,6,7,5,6,7,7,6,6,6,7,6,6,5,6
    .byte 5,7,8,7,5,7,6,6,4,6,6,7,7,5,7,7,7,7,8,8,7,6,6,7
    .byte 6,7,6,6,6,5,8,7,6,5,6,7,6,7,7,8,6,5,7,7,6,7,6,6
    .byte 6,6,6,7,7,7,7,7,6,3,6,6,7,6,5,7,5,6,5,6,7,5,7,7
    .byte 6,6,7,5,5,5,6,6,6,5,7,6,6,7,5,7,3,6,7,6,6,6,7,6
    .byte 7,7,6,6,8,7,6,6,5,6,7,7,6,6,7,6,7,7,5,7,6,6,6,7
    .byte 6,5,6,7,6,6,5,7,7,6,7,7,6,8,7,6,7,7,8,5,6,6,7,5
    .byte 6,5,6,8,6,6,6,7,6,6,7,7,5,6,6,6,6,5,5,7,7,6,6,7
    .byte 5,7,4,7,7,6,7,7,7,7,8,6,7,7,7,6,7,6,5,8,7,6,5,6
    .byte 7,6,7,7,7,7,6,7,6,7,5,5,6,6,7,6,7,7,6,6,7,6,6,7
    .byte 7,6,7,7,6,5,6,7,6,5,7,7,6,6,5,7,6,6,6,5,7,2,6,5
    .byte 6,6,7,6,6,7,5,7,7,4,6,5,6,6,6,6,7,7,7,7,6,6,6,7
    .byte 6,6,7,8,6,7,6,6,5,7,7,7,5,6,7,6,7,7,6,6,6,6,7,6
    .byte 6,7,7,6,6,5,7,7,7,6,6,7,5,6,6,5,7,6,5,6,7,6,7,6
    .byte 7,7,7,6,7,8,6,2,6,7,7,6,2,6,7,7,6,6,6,7,6,6,7,7
    .byte 7,6,8,6,7,7,6,5,7,7,6,7,7,8,7,7,5,7,7,6,7,6,7,7
    .byte 6,6,7,6,6,6,7,8,6,6,6,6,6,6,6,8,7,6,7,7,6,4,7,6
    .byte 6,6,6,7,5,5,7,6,6,6,6,7,6,7,6,6,5,5,7,6,6,6,6,5
    .byte 6,6,7,6,7,6,7,7,4,7,7,8,7,6,7,6,7,6,7,7,7,7,7,7
    .byte 7,7,6,6,6,5,6,6,8,5,7,6,6,7,6,7,7,6,7,7,7,6,7,6
    .byte 7,7,6,7,5,7,6,6,7,6,5,6,7,5,6,7,6,7,6,7,4,5,7,7
    .byte 7,4,7,6,7,5,4,5,6,7,6,5,6,7,7,5,7,5,6,7,7,7,7,7
    .byte 5,7,6,7,7,7,7,7,7,7,5,7,5,6,5,7,6,8,7,6,6,7,6,4
    .byte 6,6,7,5,6,8,6,7,7,6,8,6,7,6,6,7,6,5,5,6,6,6,6,6
    .byte 7,7,6,6,7,6,5,5,7,5,6,6,4,6,7,6,6,5,6,4,7,5,6,7
    .byte 7,6,6,7,7,7,6,7,7,7,6,5,8,7,7,7,6,6,6,7,6,6,6,6
    .byte 6,7,7,6,6,6,6,6,7,7,6,7,7,6,6,7,6,6,7,7,7,6,6,6
    .byte 6,6,6,6,7,4,6,7,6,7,6,7,5,6,6,3,5,7,6,7,6,7,5,6
    .byte 6,6,7,5,7,5,5,6,6,7,6,8,7,5,7,7,7,6,7,8,6,7,6,6
    .byte 5,6,6,6,6,6,7,5,7,6,6,7,5,7,6,6,6,6,7,6,7,7,6,7
    .byte 7,7,7,7,7,6,5,6,7,7,6,6,7,7,4,6,5,7,7,5,6,6,7,6
    .byte 6,6,4,7,6,6,5,6,5,6,6,6,7,4,5,6,5,7,7,6,7,6,7,6
    .byte 6,6,7,7,6,8,6,6,6,6,6,6,6,6,6,7,7,6,6,6,5,6,6,6
    .byte 5,6,7,7,7,5,8,7,6,7,7,7,5,6,5,4,6,5,5,7,7,5,7,7
    .byte 5,7,7,6,5,5,7,6,7,5,7,7,7,5,7,6,6,5,6,7,6,4,6,6
    .byte 5,6,7,7,8,7,6,7,6,7,7,7,7,7,7,6,7,7,7,6,7,7,7,7
    .byte 6,7,8,6,4,6,6,6,6,6,6,5,7,5,6,7,7,7,7,6,8,6,7,6
    .byte 6,5,6,7,8,6,7,6,6,6,8,5,6,4,7,7,7,7,6,8,6,4,7,7
    .byte 6,3,6,3,8,7,8,5,6,7,7,6,7,8,6,5,7,7,7,8,6,7,7,8
    .byte 8,6,6,6,6,7,7,6,7,7,7,7,6,7,5,7,7,7,7,6,7,6,7,6
    .byte 7,7,7,7,7,7,7,5,6,6,6,4,5,6,7,7,6,7,5,6,6,6,7,7
    .byte 6,7,7,5,6,7,5,5,7,6,5,7,5,6,6,6,6,7,3,5,7,7,7,8
    .byte 7,7,6,6,6,6,6,6,7,8,6,7,7,7,6,5,6,7,7,6,7,7,6,6
    .byte 5,6,6,6,7,6,7,7,7,7,6,7,7,7,7,7,7,7,5,6,5,6,5,6
    .byte 6,7,5,7,6,6,6,5,6,7,5,7,6,6,3,6,7,6,5,6,6,7,6,6
    .byte 5,6,6,6,5,5,7,5,7,5,7,7,6,7,7,7,7,7,7,7,7,6,7,7
    .byte 6,7,6,6,7,7,7,7,6,6,6,5,6,7,7,7,6,6,6,6,7,8,8,6
    .byte 6,6,7,6,7,6,6,6,6,5,6,7,5,7,7,6,7,5,7,6,7,6,6,5
    .byte 6,7,7,7,3,7,6,6,6,7,7,4,5,6,6,8,7,6,6,7,7,6,7,7
    .byte 6,7,6,7,7,7,5,7,7,6,5,6,5,7,7,6,7,7,5,6,5,6,6,6
    .byte 6,6,7,5,7,7,7,7,7,7,6,6,6,5,6,7,4,6,6,6,8,7,6,5
    .byte 7,6,4,7,7,6,6,5,6,6,7,6,5,6,6,5,7,6,6,6,7,6,6,5
    .byte 6,7,6,7,7,7,7,6,5,7,6,7,7,8,8,6,5,7,6,7,5,7,6,6
    .byte 7,7,6,4,6,6,5,6,7,6,7,7,7,5,7,7,7,7,6,6,6,6,6,6
    .byte 7,5,5,7,7,6,4,7,7,6,5,5,6,7,6,6,5,6,6,6,7,6,5,7
    .byte 6,7,5,5,6,6,5,6,6,7,6,7,6,6,7,6,6,7,7,7,6,7,7,6
    .byte 7,6,7,7,6,7,5,6,6,7,5,7,6,7,6,8,6,7,6,6,5,5,7,6
    .byte 8,7,6,7,6,7,6,6,6,4,6,6,6,7,6,6,6,7,7,6,6,6,4,6
    .byte 5,6,6,7,5,7,7,8,3,7,7,6,5,6,5,7,3,7,7,7,8,7,6,7
    .byte 6,6,6,7,7,6,6,7,6,6,6,7,7,7,7,7,6,4,6,7,6,7,7,6
    .byte 7,7,6,5,5,6,6,6,7,7,7,7,7,7,6,5,7,7,6,6,7,6,8,5
    .byte 7,7,7,7,6,7,3,7,6,5,6,4,6,6,7,5,5,6,5,7,7,6,6,7
    .byte 7,7,4,7,7,7,7,7,6,6,7,5,6,7,7,7,7,6,5,7,6,6,6,7
    .byte 7,6,8,5,7,7,7,7,7,5,6,6,6,6,5,7,7,7,6,6,7,6,7,7
    .byte 7,6,7,4,5,6,7,5,6,7,7,6,7,7,6,6,6,5,3,6,6,7,7,7
    .byte 6,6,7,4,6,7,7,6,7,6,6,5,7,8,6,7,7,7,7,5,7,7,6,7
    .byte 7,6,7,6,7,7,7,7,7,6,6,6,7,5,6,7,6,6,7,6,6,5,6,5
    .byte 6,7,6,7,6,8,7,6,7,6,6,6,6,5,5,7,7,5,7,6,7,7,6,6
    .byte 7,6,5,5,6,6,5,6,7,4,5,6,6,7,6,7,5,7,7,7,7,7,7,7
    .byte 7,7,7,5,7,6,5,7,7,7,5,6,6,7,5,6,6,6,7,5,6,7,7,5
    .byte 6,7,6,6,7,7,7,7,6,6,6,6,7,7,5,6,7,7,6,5,7,6,6,6
    .byte 6,6,7,7,6,7,6,4,4,7,5,5,7,7,7,3,7,7,7,6,6,5,6,7
    .byte 6,7,6,5,7,8,7,7,6,7,7,7,6,8,6,7,7,7,7,6,7,5,5,6
    .byte 6,5,7,7,6,7,7,6,7,7,7,7,6,6,7,7,7,6,6,6,7,7,7,7
    .byte 7,5,7,7,6,6,6,7,7,6,7,7,7,7,7,6,7,1,7,6,7,7,7,6
    .byte 6,6,6,7,6,7,5,7,7,5,6,7,6,7,7,7,7,7,6,7,6,6,7,6
    .byte 6,5,6,6,6,6,6,7,4,6,7,5,7,5,5,6,6,6,6,6,6,7,7,7
    .byte 7,6,8,6,6,6,7,6,6,7,6,6,5,6,6,5,7,6,6,6,7,7,6,6
    .byte 5,4,6,6,5,7,7,7,6,6,7,5,6,6,7,6,7,7,6,6,7,7,6,7
    .byte 7,6,7,7,7,7,7,7,4,7,7,6,5,6,7,6,5,5,6,5,7,5,5,7
    .byte 6,7,6,7,7,6,7,8,6,7,7,6,5,7,7,6,7,7,7,7,7,6,7,6
    .byte 7,5,5,7,7,6,4,7,7,5,4,3,7,6,6,6,7,7,7,6,6,6,7,6
    .byte 6,6,6,6,6,8,6,7,7,5,6,7,7,6,7,6,8,6,3,5,7,8,7,7
    .byte 7,7,6,6,6,6,7,5,6,7,7,5,7,6,7,6,7,6,8,7,7,8,6,7
    .byte 6,6,7,6,7,6,6,5,5,7,7,6,6,5,7,6,7,5,5,4,5,7,7,5
    .byte 7,7,6,5,7,7,6,5,6,6,6,6,6,7,7,6,6,7,6,7,6,7,7,7
    .byte 7,6,6,4,7,6,7,7,5,7,6,6,6,5,5,7,5,6,7,7,6,7,7,7
    .byte 6,7,6,7,7,7,6,6,7,6,7,6,7,7,7,5,6,6,6,7,7,7,6,6
    .byte 6,4,4,5,5,6,6,6,5,6,7,6,6,7,6,4,5,6,3,8,7,7,7,7
    .byte 7,7,7,7,6,7,7,7,8,7,6,7,6,5,6,7,7,7,7,6,7,6,5,7
    .byte 6,6,6,6,7,7,7,6,7,6,6,7,7,7,7,6,7,7,6,7,5,8,6,7
    .byte 6,7,5,7,7,7,5,7,8,7,5,6,6,6,3,6,6,7,8,7,6,7,7,7
    .byte 5,6,5,7,5,6,6,7,6,7,7,7,7,6,5,6,7,6,7,7,6,6,6,4
    .byte 6,6,7,6,7,7,7,6,7,6,5,7,6,6,7,7,8,6,7,7,5,7,6,5
    .byte 5,7,7,6,6,6,6,7,6,7,6,6,7,7,7,6,6,5,4,6,6,5,5,5
    .byte 7,7,5,6,6,7,7,6,7,6,7,4,6,6,6,7,7,7,6,6,6,7,7,7
    .byte 7,7,6,6,7,6,6,6,6,5,7,6,5,6,6,6,6,4,5,7,6,7,6,7
    .byte 7,5,7,6,6,7,7,7,7,6,5,7,7,7,8,6,7,6,7,4,6,6,5,7
    .byte 6,6,6,7,7,4,5,6,6,7,6,6,7,7,6,6,6,7,5,6,5,6,7,7
    .byte 7,6,7,7,5,7,7,6,7,6,6,7,6,6,6,6,4,7,7,6,7,5,6,6
    .byte 4,5,5,7,7,7,7,7,6,6,7,6,6,7,7,7,7,7,6,7,6,7,7,7
    .byte 6,6,5,4,6,6,6,6,7,6,6,7,4,6,7,6,5,3,6,6,6,5,7,6
    .byte 5,8,8,6,6,6,6,7,7,6,7,7,5,6,7,6,6,8,6,7,7,6,7,6
    .byte 5,7,6,7,6,7,7,6,6,6,5,5,7,6,7,7,6,7,7,6,6,7,7,6
    .byte 7,6,7,7,5,6,7,6,7,7,7,6,6,7,6,5,7,7,6,8,7,7,6,5
    .byte 7,2,6,6,7,6,7,8,6,6,7,6,7,4,6,4,7,6,8,7,7,7,7,7
    .byte 8,7,6,6,7,6,7,6,6,6,6,7,7,6,5,5,7,7,7,4,6,7,7,7
    .byte 6,7,8,7,7,6,7,7,7,7,7,6,5,7,7,8,8,8,6,6,6,6,6,6
    .byte 7,7,6,5,7,7,4,6,5,5,5,6,5,7,6,7,6,7,6,7,6,6,5,6
    .byte 6,7,6,7,7,8,7,5,6,5,6,7,7,7,7,6,6,7,5,6,7,6,5,6
    .byte 6,7,6,6,5,6,6,6,6,6,7,6,6,6,7,8,5,7,7,7,7,7,6,7
    .byte 7,7,7,7,6,6,6,6,6,7,5,6,6,5,6,4,6,5,7,7,3,7,7,5
    .byte 7,7,4,5,6,7,6,7,6,6,6,7,7,7,7,6,6,6,6,5,6,7,6,8
    .byte 6,6,5,7,5,6,6,6,7,7,5,6,7,7,4,6,6,7,6,5,7,6,6,5
    .byte 7,7,7,6,7,6,5,7,6,6,6,7,7,7,7,6,6,7,6,6,7,5,5,6
    .byte 7,6,5,6,6,7,7,5,6,5,7,7,4,6,6,5,7,7,6,7,7,6,8,7
    .byte 7,4,7,7,7,6,7,7,7,6,7,5,6,6,6,7,4,7,6,7,6,6,5,6
    .byte 7,6,7,7,7,6,7,7,6,7,7,7,8,6,7,6,6,7,6,7,7,7,7,7
    .byte 7,5,7,6,5,7,7,7,6,6,6,5,7,4,5,7,6,4,6,7,6,5,6,6
    .byte 7,6,7,6,7,7,7,7,7,6,5,7,7,7,6,6,7,6,7,7,6,6,7,5
    .byte 7,6,6,6,7,5,5,6,7,6,6,7,7,6,7,7,7,6,7,7,6,7,7,6
    .byte 4,7,7,7,7,7,7,8,6,7,7,6,7,6,6,5,7,6,2,6,6,7,6,6
    .byte 7,7,5,7,6,6,5,5,7,7,7,6,6,6,6,7,7,7,6,6,7,7,7,7
    .byte 6,7,6,6,7,7,7,7,7,4,5,7,6,6,5,5,6,7,7,7,7,6,6,6
    .byte 6,6,7,6,7,6,7,6,8,8,7,7,7,6,7,5,5,7,6,6,7,7,4,7
    .byte 6,7,6,6,6,7,5,6,6,7,7,2,6,6,6,6,6,5,6,7,6,5,7,6
    .byte 7,6,7,8,4,8,7,7,6,6,7,7,7,7,6,6,6,7,6,6,6,6,6,6
    .byte 7,6,7,6,7,6,6,6,5,7,7,7,6,7,6,7,7,7,7,7,7,7,7,7
    .byte 6,7,6,7,7,6,7,5,7,6,6,6,6,6,6,7,4,6,6,6,4,6,7,7
    .byte 5,7,7,6,7,7,6,6,6,6,7,7,6,7,7,7,7,7,6,6,6,6,7,5
    .byte 7,7,6,6,7,7,5,6,7,7,6,5,6,7,7,7,4,7,7,7,7,6,6,5
    .byte 7,7,6,7,7,7,7,7,7,5,6,6,6,6,6,5,5,6,6,5,7,7,6,5
    .byte 6,7,6,6,5,4,5,7,5,5,6,7,6,6,6,6,6,7,6,7,8,5,7,8
    .byte 6,6,6,7,5,7,7,6,7,5,6,7,7,6,6,6,6,5,5,6,6,8,6,6
    .byte 6,6,6,7,7,7,5,6,7,7,6,7,6,6,7,7,7,6,5,7,5,4,8,7
    .byte 5,7,6,4,7,7,5,6,7,7,5,7,6,5,4,6,6,5,7,6,6,6,7,6
    .byte 4,7,7,7,6,7,6,7,5,6,7,7,7,5,6,7,6,7,8,7,7,7,6,7
    .byte 6,7,5,5,6,6,7,7,6,6,7,7,7,6,6,7,6,6,7,6,5,7,7,6
    .byte 6,7,6,8,8,7,7,6,6,2,7,7,7,7,6,6,5,7,6,5,7,6,7,7
    .byte 6,7,6,6,5,5,7,6,6,6,6,7,6,6,6,4,7,5,7,7,7,6,7,6
    .byte 7,7,6,7,6,7,7,7,7,5,7,7,6,5,6,7,6,7,7,7,7,7,6,6
    .byte 6,6,4,5,7,7,5,7,7,6,6,7,7,7,7,7,5,7,6,6,5,5,7,7
    .byte 6,7,7,6,6,4,7,7,7,7,5,6,3,6,5,5,6,7,7,7,6,6,7,6
    .byte 5,5,5,7,7,6,6,7,7,6,7,6,7,6,8,7,7,6,7,5,7,5,6,6
    .byte 6,7,7,5,7,7,6,7,7,6,6,6,7,7,6,7,6,6,7,7,6,7,7,7
    .byte 6,5,6,5,5,6,6,7,6,6,7,7,7,6,6,6,7,6,6,7,7,7,2,7
    .byte 7,6,6,4,6,7,5,6,6,7,4,6,8,7,6,5,7,6,6,7,5,7,8,6
    .byte 7,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,6,6,6,4,6,6,6,6
    .byte 6,6,6,7,7,7,7,7,6,6,7,6,7,5,5,6,7,5,6,6,6,7,6,5
    .byte 6,7,5,5,7,7,5,6,6,6,7,6,3,6,6,8,6,7,7,7,6,6,7,7
    .byte 7,6,7,5,7,6,6,6,7,6,6,7,7,7,7,8,6,7,7,5,7,5,6,6
    .byte 5,7,7,7,6,5,8,7,6,7,6,7,6,6,6,7,7,7,7,7,6,5,6,6
    .byte 5,6,5,6,5,4,7,7,6,7,6,7,6,7,6,6,5,6,7,6,6,3,6,6
    .byte 7,6,6,7,7,6,6,7,4,5,6,7,7,7,7,5,7,7,7,7,6,7,6,8
    .byte 7,5,7,6,6,6,7,5,7,6,7,5,7,5,5,7,6,7,6,6,8,6,7,6
    .byte 6,7,7,7,7,6,7,7,6,5,5,6,5,6,6,8,7,6,6,7,6,6,5,6
    .byte 4,6,6,5,6,6,7,7,5,7,5,7,6,5,6,6,6,7,7,7,7,6,7,7
    .byte 6,6,6,7,6,6,7,7,6,6,7,7,7,6,6,6,7,7,5,5,6,6,7,6
    .byte 6,7,7,6,7,7,7,5,7,8,7,7,7,5,7,7,5,6,6,7,3,6,6,6
    .byte 7,7,7,5,7,6,4,5,7,6,6,6,7,6,7,6,5,6,7,6,7,6,7,6
    .byte 8,6,4,7,7,7,7,7,7,6,7,7,6,7,7,7,8,7,7,7,5,6,6,6
    .byte 6,6,7,4,7,6,6,7,6,7,7,6,7,7,7,6,6,5,7,7,7,6,6,7
    .byte 6,7,6,5,5,6,6,5,5,7,6,7,7,7,5,5,7,7,6,4,6,7,7,5
    .byte 6,7,6,6,7,7,4,4,7,7,7,7,7,7,5,6,7,7,5,7,7,8,7,8
    .byte 6,7,6,5,5,7,7,6,7,8,6,7,5,7,5,5,7,7,7,6,7,7,5,8
    .byte 7,7,7,6,6,7,6,6,5,6,5,6,7,6,5,7,7,6,5,6,6,8,5,7
    .byte 6,7,3,6,6,7,6,5,6,6,6,7,6,6,6,5,6,5,7,5,7,5,7,7
    .byte 6,6,8,7,7,6,7,7,7,6,7,6,6,7,6,7,7,6,6,7,7,6,5,6
    .byte 7,7,6,7,6,5,7,7,6,8,8,7,7,7,7,6,6,7,5,6,6,4,7,7
    .byte 6,6,7,6,7,5,7,6,7,6,6,5,6,7,6,7,4,6,6,7,6,7,7,6
    .byte 6,7,5,7,7,5,7,6,7,7,7,6,7,6,7,8,7,7,5,6,7,5,7,5
    .byte 6,7,7,6,7,7,3,7,6,6,6,6,7,6,6,7,6,7,7,7,7,7,6,6
    .byte 5,5,5,7,4,5,7,6,6,5,6,7,5,6,6,6,7,6,6,5,6,7,6,7
    .byte 6,5,6,6,6,6,7,6,5,5,5,7,7,7,6,6,7,7,7,7,6,5,8,7
    .byte 7,7,7,6,6,7,6,5,6,6,7,7,7,6,6,6,5,5,5,7,6,6,6,7
    .byte 6,6,7,7,8,7,6,7,6,7,5,6,6,5,5,5,7,7,6,7,5,7,7,3
    .byte 7,7,6,6,5,6,6,7,6,5,6,7,6,7,6,5,5,5,6,7,7,6,7,7
    .byte 5,7,6,6,7,6,7,6,6,7,6,7,7,7,7,7,6,7,6,6,6,7,4,6
    .byte 6,7,5,7,5,7,5,7,5,6,7,6,8,6,6,7,6,7,6,6,6,5,6,6
    .byte 7,7,5,6,6,7,7,7,5,6,4,6,4,5,6,8,5,6,7,8,4,7,6,7
    .byte 5,5,6,7,4,6,7,7,7,7,6,6,6,7,7,7,6,7,7,7,5,7,7,6
    .byte 7,8,6,7,6,5,5,8,6,6,6,7,7,7,7,5,4,6,6,6,8,6,7,6
    .byte 7,7,6,4,7,8,6,6,7,6,7,6,6,6,7,7,6,7,4,7,6,5,6,4
    .byte 7,6,6,5,6,7,4,7,7,6,6,6,7,7,6,7,7,6,6,7,6,7,5,7
    .byte 7,5,7,6,7,7,7,8,7,7,7,7,6,7,7,7,5,6,6,7,6,7,6,6
    .byte 6,7,5,6,7,7,7,7,8,6,7,7,5,5,6,7,6,5,7,6,6,7,7,7
    .byte 7,6,6,7,6,6,5,6,6,5,6,6,5,5,7,5,7,7,6,5,7,7,7,5
    .byte 6,8,7,7,8,6,7,6,5,6,6,7,6,7,6,6,8,7,6,7,7,7,6,7
    .byte 5,6,6,6,7,7,6,6,6,6,6,6,6,6,7,6,6,8,6,7,7,7,6,6
    .byte 3,6,6,8,6,6,7,7,6,7,7,5,6,6,6,3,5,6,7,7,7,6,6,7
    .byte 5,6,6,6,7,6,6,5,6,7,7,7,6,6,7,7,6,6,7,8,7,7,7,7
    .byte 4,6,6,7,6,7,7,6,6,7,5,6,6,7,6,7,6,6,6,6,7,7,6,8
    .byte 8,7,7,7,7,7,5,5,7,7,6,6,7,7,3,7,6,7,6,5,5,5,7,6
    .byte 6,7,4,7,7,6,5,5,6,5,7,6,7,5,6,6,4,6,6,7,7,6,7,6
    .byte 6,5,8,7,6,7,7,7,6,5,6,6,5,6,6,6,7,7,6,7,6,6,5,7
    .byte 6,6,7,7,6,5,7,7,7,7,7,7,6,6,5,4,7,6,4,7,7,4,7,7
    .byte 6,7,7,6,4,6,7,6,7,6,7,7,8,5,6,6,7,5,6,6,5,5,6,7
    .byte 4,6,7,6,7,7,7,6,6,6,7,6,7,7,7,5,7,8,6,7,6,7,7,6
    .byte 5,7,7,7,4,7,6,7,6,6,7,5,6,4,6,7,6,7,7,6,7,7,6,6
    .byte 7,6,6,6,7,6,7,6,5,6,8,6,6,5,6,7,6,6,7,8,6,4,8,6
    .byte 5,3,6,4,7,6,8,6,7,7,7,6,8,7,7,5,7,6,6,7,6,7,7,7
    .byte 7,6,7,7,6,7,6,7,7,6,6,6,5,7,6,6,7,7,6,6,6,6,6,6
    .byte 6,7,8,7,6,7,7,6,7,6,5,5,5,6,6,6,5,7,5,7,6,6,7,6
    .byte 6,6,7,5,6,7,6,5,7,6,4,6,5,7,7,6,4,7,6,7,6,7,7,6
    .byte 7,6,6,6,6,6,5,6,7,8,6,7,7,7,5,6,7,7,7,6,6,7,7,6
    .byte 6,6,7,5,6,6,7,7,7,6,5,6,7,6,6,6,6,6,7,4,7,6,6,7
    .byte 6,6,6,7,7,7,6,5,5,7,6,6,6,7,7,3,7,7,6,7,6,6,7,7
    .byte 6,6,6,6,7,7,7,6,7,6,6,5,6,7,6,7,5,6,6,6,7,5,7,4
    .byte 6,7,6,6,6,5,5,7,7,7,6,6,7,7,6,7,6,8,6,5,6,7,5,7
    .byte 6,6,7,5,5,6,5,7,5,6,7,7,7,6,7,6,5,6,6,6,7,7,7,7
    .byte 5,7,4,6,5,6,7,6,7,7,6,6,8,5,7,6,7,6,6,7,7,7,7,5
    .byte 7,8,6,6,7,6,6,5,5,7,6,7,6,5,7,7,7,6,7,7,6,7,7,5
    .byte 6,8,6,4,7,6,5,8,7,7,6,6,6,7,5,7,5,6,7,7,6,5,7,7
    .byte 5,5,3,7,6,6,6,7,7,7,5,7,6,6,6,6,7,7,7,6,6,6,6,7
    .byte 8,7,5,6,7,7,7,7,6,7,7,7,6,6,7,4,5,6,7,6,7,6,7,7
    .byte 7,7,7,7,7,7,6,6,7,7,7,7,6,6,6,7,6,8,8,4,6,6,5,6
    .byte 7,6,7,7,6,7,7,7,7,6,6,2,7,7,7,7,7,6,5,6,6,7,5,6
    .byte 5,6,7,7,5,7,6,6,6,6,6,6,7,5,6,7,7,6,3,6,7,7,7,6
    .byte 7,7,7,6,6,6,7,6,6,7,8,6,7,6,6,5,7,7,7,7,6,7,5,8
    .byte 6,5,6,6,7,6,7,4,5,6,6,7,7,5,7,7,7,6,6,5,6,7,7,6
    .byte 7,8,5,5,7,7,6,6,6,4,7,7,7,6,7,6,6,7,6,5,6,6,7,7
    .byte 7,6,7,6,6,6,6,7,7,6,5,7,5,5,7,5,7,7,7,6,8,7,6,7
    .byte 6,6,6,7,7,6,6,6,7,6,7,6,7,5,7,6,6,4,7,7,7,5,6,8
    .byte 7,6,7,7,7,4,6,7,8,8,7,6,7,7,7,6,6,4,7,5,6,7,6,6
    .byte 7,6,7,6,7,4,6,7,7,7,7,7,6,7,4,7,6,6,7,6,6,7,6,7
    .byte 6,5,7,7,7,7,6,7,6,7,7,5,7,7,5,4,8,7,5,6,6,6,7,6
    .byte 6,6,6,8,7,7,7,7,5,5,7,6,6,6,5,6,7,5,7,5,8,7,5,8
    .byte 6,6,4,6,6,6,7,7,6,6,5,8,6,7,5,7,7,7,7,7,7,5,7,6
    .byte 7,7,5,7,6,6,7,6,6,7,6,6,6,7,7,7,6,6,6,7,6,7,7,6
    .byte 7,5,6,7,7,5,6,6,7,6,5,6,6,6,7,7,6,6,7,4,5,6,6,6
    .byte 6,7,6,7,7,6,5,7,6,4,5,6,6,7,5,7,7,7,7,6,7,5,5,7
    .byte 7,7,7,7,6,6,6,6,7,6,6,6,6,6,6,7,6,7,6,7,7,7,7,6
    .byte 6,6,6,7,6,7,7,7,8,6,5,7,6,7,6,6,5,7,6,7,5,6,5,7
    .byte 7,4,6,5,6,6,7,7,4,8,7,6,7,7,4,4,6,7,7,7,5,5,6,8
    .byte 7,7,7,7,7,5,6,6,5,8,5,7,7,7,6,7,5,7,6,6,6,6,5,6
    .byte 6,7,5,7,6,6,6,6,7,6,6,4,8,7,7,7,7,7,6,6,6,6,5,7
    .byte 7,7,6,7,5,7,6,6,6,5,5,6,6,7,6,6,7,7,7,6,7,5,6,7
    .byte 3,6,5,5,7,7,6,7,7,7,6,7,7,6,7,7,7,7,7,7,6,6,7,6
    .byte 7,8,5,7,6,5,5,7,5,5,6,7,7,7,7,7,6,7,7,7,6,7,6,7
    .byte 7,8,7,3,7,7,7,7,6,6,8,6,7,6,7,7,6,7,5,7,5,3,5,6
    .byte 7,5,6,7,7,5,7,6,7,5,6,6,7,6,6,5,6,7,7,7,7,7,5,7
    .byte 6,6,5,7,7,7,7,7,5,6,7,7,6,4,8,6,7,6,7,6,7,8,7,8
    .byte 6,6,7,6,7,5,7,7,7,7,6,7,6,5,7,6,6,7,7,6,6,7,6,6
    .byte 6,4,7,7,6,6,6,7,5,7,5,6,7,6,5,6,7,6,5,5,6,6,6,6
    .byte 6,6,6,7,7,6,7,7,7,7,7,7,6,6,5,6,7,7,6,7,8,4,5,7
    .byte 6,7,6,6,7,7,8,7,7,6,6,6,6,7,6,6,6,7,7,5,7,7,7,7
    .byte 7,5,7,4,5,6,5,6,7,7,4,6,7,7,6,7,6,6,6,6,7,7,7,3
    .byte 5,6,5,7,7,4,6,7,6,4,6,6,7,7,7,7,5,7,8,6,6,5,7,6
    .byte 7,7,7,6,5,7,6,6,6,7,7,7,7,7,7,7,7,6,7,6,6,7,7,7
    .byte 7,7,7,6,7,6,7,8,6,7,6,6,5,6,5,7,7,6,6,5,7,6,7,6
    .byte 6,7,6,8,4,6,7,7,5,5,7,7,5,7,6,7,6,7,6,5,6,6,7,7
    .byte 6,7,7,7,7,6,6,6,6,7,6,7,5,7,6,6,6,5,5,7,6,6,6,7
    .byte 7,7,7,6,6,6,7,7,7,6,6,6,6,6,7,6,6,8,7,6,7,5,7,4
    .byte 4,8,7,6,6,6,5,7,6,6,5,8,7,6,7,7,6,5,5,6,5,7,6,6
    .byte 7,7,6,6,6,6,6,6,7,6,6,8,7,7,7,6,6,5,7,6,6,7,7,7
    .byte 5,7,6,6,6,7,7,6,6,7,7,7,7,4,7,7,7,6,5,6,6,7,6,6
    .byte 7,6,7,7,6,6,4,6,6,6,6,6,5,6,6,7,5,7,6,7,6,7,7,6
    .byte 7,6,5,4,6,5,6,7,6,6,6,6,5,7,7,7,7,7,6,7,7,7,7,7
    .byte 6,7,6,7,6,7,6,7,7,6,8,6,4,6,6,6,6,5,6,6,6,7,6,8
    .byte 6,6,6,6,6,6,7,7,7,7,5,7,6,6,7,6,7,5,6,3,7,7,6,7
    .byte 6,6,6,7,7,4,5,6,5,8,6,6,6,8,5,5,6,6,5,7,6,5,7,6
    .byte 6,6,7,6,6,7,7,7,7,6,6,6,7,7,6,7,4,7,7,6,7,4,6,6
    .byte 5,5,6,7,7,7,8,7,7,7,7,5,5,7,7,7,6,6,6,7,5,6,7,6
    .byte 7,5,5,4,7,5,7,6,8,7,5,7,5,6,7,6,6,4,7,6,6,6,7,6
    .byte 5,7,7,6,5,6,5,6,7,7,7,7,6,6,7,7,6,7,7,7,6,5,6,6
    .byte 5,7,7,6,6,7,7,5,5,6,6,6,6,7,8,7,6,7,7,6,7,7,7,6
    .byte 7,5,7,7,4,6,7,5,7,7,6,5,5,6,7,5,6,7,6,7,7,7,7,6
    .byte 7,3,6,6,7,6,7,7,5,6,6,6,6,4,6,5,6,6,8,7,6,7,6,7
    .byte 7,6,6,6,6,6,7,6,6,7,6,7,6,7,5,6,7,7,6,5,6,7,7,7
    .byte 5,7,8,7,7,6,6,7,6,7,7,7,4,7,7,7,7,7,7,7,7,5,5,6
    .byte 6,7,6,6,7,7,5,6,5,6,6,6,6,7,6,7,5,7,6,7,6,6,4,6
    .byte 6,6,6,7,7,6,7,7,5,6,6,6,5,5,7,8,7,6,7,6,7,7,6,7
    .byte 6,6,7,6,5,7,7,7,6,7,7,6,5,7,7,7,5,7,6,7,4,6,7,7
    .byte 7,7,7,7,7,7,6,7,4,7,6,7,7,6,7,6,7,7,6,7,4,6,7,7
    .byte 6,5,6,7,5,8,6,5,5,6,7,6,6,6,7,6,4,8,6,7,7,6,7,4
    .byte 7,7,7,6,7,8,7,7,7,7,7,7,6,6,6,7,7,8,6,7,7,7,7,6
    .byte 5,6,6,6,4,5,7,7,6,7,7,7,6,7,7,6,5,6,7,6,7,7,7,7
    .byte 7,7,5,6,5,6,7,6,6,6,7,5,6,7,7,5,5,7,7,5,7,7,6,6
    .byte 7,6,5,7,6,6,5,6,6,7,7,7,7,6,7,6,7,6,7,6,7,7,6,6
    .byte 7,8,7,7,7,7,6,7,7,7,6,7,6,7,3,6,7,6,7,8,7,6,7,7
    .byte 5,6,5,6,6,7,6,7,6,5,6,6,6,6,5,5,7,7,6,6,7,7,6,7
    .byte 7,5,5,6,6,7,7,5,6,6,5,7,5,7,7,6,6,5,7,7,7,5,7,7
    .byte 7,7,6,7,6,7,6,6,6,7,7,8,6,7,6,6,7,6,6,7,7,6,4,5
    .byte 6,7,7,7,6,8,7,7,6,6,4,6,6,7,6,7,7,7,6,7,6,6,5,5
    .byte 7,7,6,6,7,6,6,7,6,4,6,6,4,7,7,7,5,7,7,7,6,7,7,4
    .byte 7,7,5,7,6,5,7,5,7,7,6,6,7,8,7,7,7,6,7,7,6,8,6,7
    .byte 4,7,7,5,6,7,6,7,6,5,7,7,7,7,8,7,8,6,7,5,7,7,6,6
    .byte 7,5,7,6,6,7,7,6,7,6,6,5,4,6,6,6,6,6,6,7,6,6,5,7
    .byte 7,6,6,7,7,6,5,7,6,7,6,7,6,6,4,6,7,6,7,6,7,6,7,7
    .byte 7,5,7,7,7,7,8,5,7,5,5,5,5,5,8,7,6,6,7,7,7,7,7,7
    .byte 6,7,8,6,6,7,5,6,6,8,7,5,7,7,5,7,5,5,5,6,5,3,6,7
    .byte 7,6,7,7,7,6,6,6,6,7,5,7,7,6,7,6,7,7,7,6,7,7,5,6
    .byte 6,5,7,6,7,6,6,7,7,7,7,6,5,6,7,7,7,7,7,6,5,6,6,6
    .byte 6,6,5,4,7,6,8,6,7,7,8,6,5,6,7,7,5,6,7,7,6,4,6,7
    .byte 6,7,7,4,7,6,6,5,4,6,6,6,7,7,7,5,6,7,6,5,7,7,7,7
    .byte 5,7,6,7,7,7,6,7,5,6,7,6,6,8,5,7,7,8,7,7,6,7,6,6
    .byte 7,6,7,7,5,6,6,7,5,5,6,7,6,6,7,6,8,7,6,7,7,7,7,6
    .byte 5,6,6,6,7,6,7,7,6,7,7,4,5,5,6,5,4,5,6,7,6,5,7,7
    .byte 6,6,6,7,6,7,4,7,7,7,7,6,7,5,6,7,6,4,8,7,6,6,7,7
    .byte 7,6,7,6,7,6,7,6,7,8,7,7,5,6,7,6,7,5,5,7,7,6,7,7
    .byte 7,7,6,6,7,7,6,6,7,7,6,6,7,6,6,7,6,6,6,6,4,7,5,6
    .byte 7,6,6,5,7,6,4,6,7,7,7,6,6,7,6,7,5,6,6,7,7,6,7,7
    .byte 5,5,6,6,7,7,8,7,6,7,5,7,7,6,5,7,7,7,7,8,7,5,5,7
    .byte 7,6,6,7,7,6,7,5,7,7,7,7,6,7,6,5,6,6,6,6,6,7,7,6
    .byte 5,7,6,6,4,6,6,7,6,6,6,7,7,4,7,6,6,5,5,6,6,6,6,7
    .byte 7,6,5,7,6,7,5,7,5,6,5,7,7,6,7,7,7,8,6,6,6,6,6,6
    .byte 7,7,6,7,7,6,7,5,4,6,6,6,6,5,6,6,7,7,7,6,7,7,7,7
    .byte 7,5,6,4,7,7,7,6,7,4,7,6,5,5,6,6,6,7,7,6,6,5,7,6
    .byte 8,4,5,4,7,7,6,6,8,6,6,5,7,7,7,4,7,7,7,7,6,7,7,7
    .byte 7,7,6,5,7,7,7,6,4,7,7,7,7,7,8,6,6,6,7,4,7,6,6,7
    .byte 6,6,7,7,7,8,7,6,5,6,5,6,7,6,6,6,7,6,7,8,6,7,6,4
    .byte 7,7,5,5,7,7,6,6,6,6,5,6,3,6,6,7,6,7,8,7,7,7,7,3
    .byte 6,7,6,8,6,6,7,6,7,8,7,7,6,8,8,8,7,6,7,7,6,8,6,8
    .byte 5,7,7,5,6,6,7,8,6,6,7,8,6,7,7,7,8,6,8,6,7,7,5,7
    .byte 7,6,6,6,5,7,7,6,6,6,6,5,5,6,7,6,5,6,6,8,6,6,5,5
    .byte 7,5,8,7,6,7,6,7,6,7,6,7,7,5,7,7,5,6,7,7,6,6,7,6
    .byte 7,7,6,5,7,7,7,7,8,7,5,6,5,6,6,7,7,5,5,7,6,8,5,7
    .byte 7,7,7,6,7,7,7,6,6,6,7,5,5,6,6,7,6,7,4,7,5,6,5,5
    .byte 6,6,6,7,6,7,5,5,6,7,6,7,6,7,7,5,7,6,7,6,6,6,7,6
    .byte 6,7,7,6,7,6,7,7,7,7,7,7,7,6,7,6,7,7,6,6,7,6,6,4
    .byte 6,7,8,7,7,7,6,7,6,6,7,8,7,6,7,6,6,6,6,6,6,7,6,6
    .byte 6,6,5,5,6,5,6,5,6,6,7,5,5,7,8,5,4,6,7,6,6,7,7,7
    .byte 6,7,6,6,6,7,6,6,5,6,6,6,7,7,7,7,7,7,6,6,7,7,6,7
    .byte 8,6,6,5,6,6,4,5,7,7,6,7,7,7,7,7,6,6,5,7,7,5,6,7
    .byte 6,6,7,7,6,5,6,6,6,7,6,5,6,7,4,4,6,7,6,5,7,7,7,6
    .byte 6,6,7,7,6,7,4,6,6,7,7,6,8,6,6,7,7,4,7,7,7,6,7,7
    .byte 7,6,7,7,7,5,7,5,8,7,6,6,4,7,6,7,7,6,5,6,6,7,7,7
    .byte 6,8,7,6,6,7,6,6,6,6,6,7,8,5,7,6,7,6,5,5,5,7,6,6
    .byte 6,6,5,5,8,7,5,5,6,6,7,5,6,7,6,7,6,5,6,7,6,5,7,6
    .byte 5,6,7,8,7,7,7,7,8,7,5,7,7,7,6,6,8,6,6,7,6,7,5,5
    .byte 6,7,6,6,4,6,6,6,7,7,6,8,7,6,6,7,6,7,5,7,6,7,6,6
    .byte 5,7,6,5,6,7,6,6,6,7,6,6,6,6,6,7,4,6,5,7,6,7,7,8
    .byte 6,6,6,7,7,7,5,7,7,6,6,6,7,7,7,7,7,7,4,7,7,7,7,5
    .byte 7,7,7,8,6,7,6,7,6,7,5,7,6,5,6,6,7,8,7,7,7,6,5,5
    .byte 6,5,7,6,6,7,7,6,5,6,7,6,7,5,3,7,7,5,5,7,6,7,7,7
    .byte 6,5,5,7,6,6,7,6,7,7,4,6,7,6,7,6,7,6,6,4,6,6,7,7
    .byte 7,7,7,6,6,6,6,6,6,7,7,7,7,7,7,5,5,6,7,6,6,7,7,5
    .byte 6,6,7,7,7,7,6,6,7,6,6,6,5,5,7,6,7,6,5,7,7,6,5,5
    .byte 5,7,7,6,7,7,7,5,7,5,6,5,5,5,6,6,6,5,5,6,7,8,7,7
    .byte 6,7,7,5,7,6,7,7,7,6,6,6,6,6,6,7,5,7,6,6,6,6,7,6
    .byte 7,7,7,6,6,7,7,7,7,5,7,7,6,8,6,7,6,7,6,6,6,6,6,7
    .byte 6,6,7,8,6,7,5,6,2,7,6,6,6,6,7,5,7,7,6,6,6,5,7,6
    .byte 5,6,7,5,7,6,7,8,8,7,7,5,6,7,5,6,6,7,6,5,7,7,6,5
    .byte 6,7,6,7,5,6,7,6,6,6,7,7,7,6,6,7,7,8,7,7,6,7,6,6
    .byte 7,7,6,5,7,6,6,6,6,7,7,6,6,7,7,6,3,5,7,6,7,7,8,5
    .byte 7,7,5,6,7,7,6,6,6,6,6,6,6,6,7,7,7,7,6,6,8,5,7,6
    .byte 6,6,7,7,5,6,6,6,6,6,6,6,7,6,6,7,7,5,7,7,6,5,7,7
    .byte 8,7,7,6,7,7,7,8,5,6,6,7,5,6,6,5,6,7,6,6,7,7,6,7
    .byte 5,5,3,7,6,5,6,7,7,4,7,8,7,5,7,6,7,6,6,6,7,6,7,6
    .byte 7,7,8,7,7,6,6,7,4,7,7,7,5,6,7,7,5,6,6,6,7,6,6,7
    .byte 6,6,6,6,7,6,6,7,6,7,7,7,6,6,6,7,6,7,7,7,7,6,6,6
    .byte 7,6,6,7,7,5,5,7,7,5,3,4,7,6,7,7,7,6,7,7,5,5,6,7
    .byte 7,6,6,6,6,6,7,6,6,6,7,7,7,7,5,7,7,7,5,6,6,6,7,6
    .byte 6,6,7,6,7,5,5,6,7,7,6,6,7,6,7,7,7,6,7,6,6,6,6,7
    .byte 7,7,8,6,7,6,6,5,5,6,6,7,6,5,7,7,7,4,5,6,7,7,6,5
    .byte 6,7,7,6,6,6,5,5,6,6,7,6,5,7,6,5,6,7,7,5,7,6,7,7
    .byte 7,7,7,6,6,6,7,5,7,7,7,6,5,5,6,6,5,8,7,6,6,6,7,6
    .byte 7,7,6,7,6,7,7,6,6,7,7,7,7,7,7,5,7,6,5,7,6,5,7,6
    .byte 6,5,6,6,3,7,7,7,7,6,7,6,7,7,6,7,5,6,6,6,6,7,5,7
    .byte 7,5,7,7,6,7,6,7,6,7,6,6,5,5,6,7,6,6,5,7,6,5,5,5
    .byte 7,6,6,7,6,5,7,7,6,7,7,8,7,7,7,6,6,7,7,6,7,6,7,6
    .byte 5,5,6,6,6,7,5,6,7,4,6,6,7,4,4,7,7,6,4,7,7,6,7,7
    .byte 6,6,5,4,8,7,8,7,7,8,7,7,7,7,6,6,7,6,8,7,7,6,5,7
    .byte 7,6,6,5,7,7,8,5,7,7,7,6,7,7,7,7,7,7,8,7,6,7,6,7
    .byte 6,7,7,7,8,7,7,6,5,7,7,5,7,7,6,6,7,7,5,6,6,6,6,5
    .byte 6,7,7,7,7,6,6,7,6,7,6,6,6,7,7,6,7,7,7,5,5,6,6,6
    .byte 7,7,7,6,7,7,6,7,7,6,5,7,5,6,6,5,5,6,7,5,7,7,7,6
    .byte 6,7,6,8,5,7,7,7,7,7,6,7,7,6,6,6,7,6,7,7,7,7,5,7
    .byte 5,6,6,4,6,6,7,7,4,7,7,4,7,7,5,4,6,7,7,8,6,6,8,7
    .byte 6,8,6,7,4,7,7,7,7,7,8,6,7,7,6,5,7,6,7,5,6,7,6,5
    .byte 5,6,6,7,6,7,6,7,5,7,8,7,7,7,7,7,7,8,7,6,7,6,7,7
    .byte 7,7,7,7,6,7,6,5,7,6,7,6,5,6,6,8,5,6,6,6,5,7,7,6
    .byte 6,7,6,6,7,7,7,6,7,7,6,7,6,6,6,7,5,7,7,7,7,7,7,5
    .byte 7,6,6,7,6,7,6,6,6,7,6,4,6,7,7,7,6,6,6,6,6,7,7,6
    .byte 7,7,6,6,7,7,7,7,6,7,7,7,6,6,8,5,5,6,5,6,6,7,6,4
    .byte 7,7,7,7,6,6,6,8,7,5,6,6,6,6,8,6,8,7,6,8,7,6,6,6
    .byte 8,6,6,5,6,6,7,7,6,6,6,6,7,6,6,6,6,5,6,5,6,6,6,7
    .byte 6,6,6,8,7,6,7,7,7,7,7,7,5,7,7,7,6,6,6,8,7,6,8,6
    .byte 6,7,6,6,6,5,3,5,6,7,6,7,6,6,5,7,7,7,5,4,6,7,7,5
    .byte 6,6,6,7,6,7,7,7,6,5,7,6,6,7,6,6,7,7,4,5,6,7,7,6
    .byte 6,6,6,6,7,6,6,5,6,6,6,6,7,6,7,7,7,5,7,6,7,7,7,7
    .byte 7,6,7,7,7,6,6,6,6,7,7,6,6,5,7,6,6,4,5,5,6,7,7,5
    .byte 7,7,7,6,7,6,5,6,7,6,6,6,6,6,8,6,6,7,6,7,6,7,7,7
    .byte 7,6,6,4,6,5,7,7,6,6,7,7,6,6,6,6,5,6,7,7,6,7,7,7
    .byte 7,7,7,7,7,7,7,6,8,6,6,7,7,7,6,6,6,6,6,6,7,6,6,6
    .byte 5,5,5,6,4,5,6,7,6,5,8,7,7,6,7,5,6,5,3,8,8,7,7,7
    .byte 7,7,7,8,7,7,7,8,7,8,7,8,6,4,7,7,7,6,6,7,7,7,6,7
    .byte 7,6,6,6,7,8,8,7,8,7,7,7,7,7,8,7,7,7,7,8,6,8,7,6
    .byte 7,7,6,6,8,7,6,7,7,6,6,6,7,6,4,6,6,8,8,8,7,7,7,6
    .byte 6,7,6,7,6,6,6,6,7,6,7,6,7,5,6,6,7,6,7,8,6,6,5,5
    .byte 6,6,7,6,7,7,6,6,7,5,5,7,6,6,7,7,7,7,7,7,5,6,6,6
    .byte 6,6,7,6,7,7,7,7,6,6,7,6,6,7,6,5,7,5,5,6,6,5,4,6
    .byte 7,8,6,5,7,7,7,7,6,6,6,5,6,7,7,7,6,7,6,6,6,7,7,6
    .byte 7,7,7,6,7,6,6,6,7,5,6,7,5,6,5,5,6,6,6,6,7,7,6,5
    .byte 6,6,6,7,6,6,6,7,7,7,7,7,7,6,7,6,6,7,7,6,7,7,4,7
    .byte 6,6,6,5,6,6,6,7,5,7,7,3,7,7,6,5,6,6,6,7,7,6,6,7
    .byte 7,6,6,6,7,6,7,6,7,7,7,7,6,7,4,7,7,6,7,7,7,5,6,6
    .byte 7,6,5,6,7,7,6,5,6,6,7,7,6,6,6,6,6,6,7,6,7,7,7,7
    .byte 6,7,7,7,6,7,5,4,6,6,6,7,7,6,4,6,7,7,6,5,5,5,7,6
    .byte 6,6,6,7,5,7,6,7,7,6,8,7,5,7,7,7,7,7,6,5,7,7,7,7
    .byte 6,7,6,8,7,6,6,5,5,5,5,6,7,6,6,6,6,6,7,8,7,6,7,7
    .byte 8,7,6,5,7,7,8,7,6,5,7,6,5,7,7,5,6,6,5,7,6,4,5,7
    .byte 7,5,7,6,5,5,7,7,6,6,5,6,7,7,5,6,7,7,7,7,6,7,4,7
    .byte 7,7,7,7,7,7,7,7,6,6,6,7,7,6,7,6,5,5,6,6,7,7,7,6
    .byte 7,7,5,7,7,7,7,7,7,7,7,7,6,7,7,6,8,7,7,7,6,6,7,7
    .byte 7,5,6,6,7,7,5,7,7,8,5,6,5,6,5,6,7,6,5,6,7,6,7,7
    .byte 6,8,7,7,7,5,7,3,7,7,6,7,6,7,6,7,6,6,5,8,6,7,6,5
    .byte 6,7,6,5,6,6,6,6,7,5,7,5,7,7,7,7,6,6,7,6,7,6,7,7
    .byte 6,7,6,6,8,6,6,7,7,7,4,7,6,7,5,6,6,6,7,5,7,6,7,6
    .byte 7,7,7,6,6,5,6,6,6,5,7,8,6,7,7,6,6,4,7,6,5,7,6,7
    .byte 7,7,7,6,8,8,6,6,6,6,7,7,5,6,6,6,5,7,7,7,6,6,7,6
    .byte 7,5,6,7,7,6,7,6,6,7,6,6,5,7,7,6,7,8,7,5,6,5,6,7
    .byte 5,6,6,7,7,4,8,7,5,6,6,6,3,7,6,7,7,6,6,7,7,7,5,7
    .byte 6,5,5,7,5,7,7,6,6,7,7,6,7,7,6,6,5,8,6,7,7,7,7,4
    .byte 7,6,6,6,7,6,6,7,7,7,6,5,8,7,6,7,7,7,6,6,5,7,7,7
    .byte 6,6,7,4,6,5,6,7,5,7,6,5,6,7,7,6,7,7,6,7,7,4,5,6
    .byte 6,7,7,6,7,7,5,7,7,5,6,6,7,6,6,5,6,6,7,7,5,6,6,7
    .byte 6,6,7,7,6,6,7,5,6,7,7,7,6,6,7,7,7,7,7,6,7,6,7,7
    .byte 5,7,7,6,5,5,7,7,7,7,7,7,6,6,5,6,6,5,4,6,7,6,6,6
    .byte 7,7,6,6,7,7,6,3,6,7,7,6,7,7,6,5,7,5,5,7,7,7,6,7
    .byte 7,6,7,7,7,7,6,7,6,7,5,6,6,7,6,5,6,7,7,6,8,6,6,6
    .byte 5,7,6,7,7,6,7,5,6,6,6,6,7,7,7,6,6,6,4,7,6,6,6,6
    .byte 6,8,5,7,5,7,6,4,7,7,7,7,6,6,5,7,6,7,6,6,5,6,7,6
    .byte 5,5,6,6,6,6,6,7,7,6,7,5,6,7,7,6,7,7,7,7,6,7,6,8
    .byte 7,7,6,6,7,7,6,5,6,6,6,6,7,6,6,7,6,6,7,7,7,6,6,8
    .byte 6,7,5,6,5,5,7,7,7,6,6,7,6,8,4,6,5,7,8,6,6,5,7,6
    .byte 5,7,7,6,4,6,6,6,6,6,4,6,7,6,7,7,6,7,6,7,6,7,7,7
    .byte 6,6,7,6,7,6,5,7,7,6,6,6,7,6,7,6,5,5,6,7,6,6,6,7
    .byte 7,7,6,7,7,6,7,7,7,6,7,5,5,5,5,5,6,8,5,7,6,5,7,6
    .byte 7,5,5,7,7,7,4,6,7,6,6,7,7,6,6,3,8,8,7,6,6,7,7,7
    .byte 6,7,5,6,7,7,7,7,7,6,6,8,7,6,6,5,7,8,8,5,7,7,7,7
    .byte 7,7,6,7,7,7,7,6,6,6,6,6,7,7,6,7,7,7,7,5,5,7,7,5
    .byte 6,6,6,7,7,7,6,6,6,7,6,6,6,7,7,6,6,6,6,6,6,7,6,7
    .byte 5,7,6,5,6,7,4,6,7,8,7,7,8,7,5,5,6,5,7,6,7,7,5,7
    .byte 7,6,6,6,6,7,6,5,7,7,6,6,5,6,7,6,6,7,7,7,7,6,7,6
    .byte 7,7,7,6,7,6,5,7,6,6,5,7,7,7,5,7,7,7,6,4,6,7,6,7
    .byte 6,7,4,6,7,6,6,7,6,6,5,5,6,7,4,6,7,6,8,6,7,7,6,7
    .byte 6,6,6,7,7,7,6,7,7,5,7,7,6,6,7,6,6,6,5,7,6,6,7,6
    .byte 7,7,6,7,6,7,5,7,7,6,7,7,7,6,7,6,6,6,7,5,6,6,5,7
    .byte 8,6,6,6,7,3,7,7,7,7,5,7,6,7,7,5,5,6,7,6,6,5,6,6
    .byte 7,6,6,7,6,7,6,6,7,6,6,6,7,6,7,7,6,7,6,6,7,6,6,6
    .byte 7,7,6,7,7,6,7,7,5,5,7,7,7,7,7,6,6,7,7,8,6,6,5,7
    .byte 5,7,6,5,6,7,6,6,8,6,7,6,6,6,4,7,6,6,6,7,6,5,7,7
    .byte 6,4,6,5,7,6,6,6,7,6,7,6,7,8,7,7,6,7,6,7,4,6,7,7
    .byte 6,7,8,7,4,7,6,6,6,7,6,6,7,7,6,5,6,6,5,7,7,7,7,8
    .byte 7,5,7,7,6,7,7,6,6,6,6,5,7,6,5,7,7,5,5,7,7,5,4,5
    .byte 7,7,7,7,6,6,7,7,6,5,5,7,2,7,8,7,7,6,7,7,7,7,6,7
    .byte 6,7,7,7,6,7,7,4,7,8,7,7,7,8,7,7,6,6,7,6,7,7,6,7
    .byte 7,6,7,7,7,7,7,7,7,6,7,7,7,7,6,7,7,6,7,6,5,5,8,6
    .byte 6,6,6,7,6,5,6,5,5,7,7,8,7,8,7,6,6,6,6,6,5,6,6,6
    .byte 7,6,7,7,7,6,7,7,5,6,6,7,8,7,7,5,6,5,7,7,7,7,7,7
    .byte 7,7,6,5,5,6,7,7,7,6,7,7,6,7,6,7,7,6,6,6,7,6,7,7
    .byte 7,7,5,6,5,7,7,5,7,6,6,6,6,6,6,7,5,6,6,7,5,6,7,7
    .byte 7,5,7,6,6,6,5,5,6,7,6,6,6,7,6,5,6,6,6,7,6,6,7,7
    .byte 5,6,6,7,8,6,7,7,6,7,6,6,5,6,6,6,6,7,7,6,7,7,7,4
    .byte 6,6,8,6,6,7,6,6,7,7,7,6,6,6,6,8,6,5,5,5,6,6,6,5
    .byte 6,6,6,7,8,5,6,6,7,6,7,7,5,6,7,6,6,5,6,5,7,5,7,6
    .byte 7,6,5,7,7,6,6,8,6,6,5,6,7,7,7,7,6,6,6,7,7,5,6,6
    .byte 7,7,8,6,7,7,6,6,6,6,7,7,6,5,7,7,6,6,7,7,6,5,7,6
    .byte 7,6,6,6,8,5,5,7,7,6,5,6,6,7,6,4,6,7,7,7,6,7,5,6
    .byte 6,8,6,6,7,7,5,6,6,7,6,7,6,5,7,6,6,7,7,7,5,8,7,6
    .byte 6,5,6,6,5,7,6,6,7,6,6,6,7,7,7,7,7,8,7,6,5,4,7,6
    .byte 7,6,6,6,7,6,6,6,6,4,6,6,6,7,5,5,6,7,7,5,7,6,5,5
    .byte 6,7,7,7,5,7,7,7,4,6,7,8,6,6,6,6,7,5,7,6,7,7,7,6
    .byte 6,6,4,6,6,6,7,7,7,5,7,5,6,6,6,6,6,8,6,6,7,7,7,7
    .byte 6,6,7,6,6,5,7,6,6,6,6,6,5,7,7,8,5,7,4,4,6,6,6,7
    .byte 8,6,5,7,7,7,6,6,5,4,7,6,6,7,7,7,5,7,5,7,7,7,6,7
    .byte 6,6,5,7,8,7,7,6,7,7,6,6,6,6,7,6,7,7,6,6,6,6,7,6
    .byte 6,7,7,7,6,5,7,6,6,8,7,7,5,7,6,6,6,6,7,5,8,6,6,7
    .byte 6,6,6,6,5,6,7,7,6,6,7,6,7,7,6,7,6,4,6,6,7,5,6,7
    .byte 5,6,6,6,7,7,6,7,5,6,3,7,7,7,7,7,6,6,7,7,5,7,7,7
    .byte 6,7,7,6,5,6,6,6,7,7,7,5,7,7,6,7,7,6,7,7,6,6,6,7
    .byte 6,6,6,7,7,6,7,7,7,6,7,6,6,5,6,6,7,6,6,7,6,7,6,7
    .byte 4,7,5,5,7,5,5,6,7,6,6,6,7,7,6,6,7,6,6,5,6,6,7,7
    .byte 6,7,6,6,6,6,6,7,7,7,7,5,7,4,7,6,6,6,6,7,7,6,7,7
    .byte 6,6,7,6,6,6,7,8,6,6,6,6,6,7,7,6,7,6,5,6,6,6,6,6
    .byte 7,7,6,6,7,7,6,5,5,6,7,7,7,6,7,7,3,7,6,7,6,6,6,7
    .byte 6,5,6,4,7,6,7,7,6,7,6,6,7,6,5,7,7,7,6,6,8,6,6,7
    .byte 7,6,6,7,6,7,7,7,7,6,5,7,6,7,4,6,7,7,6,7,6,7,6,6
    .byte 7,7,7,6,5,7,7,6,5,6,7,7,7,6,6,7,6,4,7,6,6,7,6,7
    .byte 4,7,6,4,6,6,4,7,7,6,6,6,7,7,6,7,6,8,6,6,6,7,5,7
    .byte 8,6,7,8,7,7,5,7,5,5,7,6,7,7,6,6,7,7,6,6,5,6,6,6
    .byte 7,5,6,6,6,7,7,6,6,7,7,7,7,6,6,3,7,7,6,7,6,5,6,7
    .byte 6,4,6,6,7,8,7,6,7,5,6,5,7,5,5,4,7,7,5,6,7,7,5,6
    .byte 8,7,7,4,7,7,7,7,6,7,7,7,6,7,6,5,6,7,7,6,5,7,6,7
    .byte 6,7,7,7,7,7,7,4,6,7,7,7,7,5,7,6,6,7,8,6,6,6,6,6
    .byte 7,6,5,7,7,5,7,7,7,6,6,4,7,7,6,6,7,7,6,5,5,7,6,6
    .byte 6,6,7,6,5,6,7,7,7,5,7,7,6,6,6,6,6,5,7,6,7,6,6,6
    .byte 6,8,7,6,6,7,7,7,7,7,4,6,6,6,5,6,6,7,6,6,6,6,7,6
    .byte 8,7,7,6,6,7,7,6,6,5,5,6,7,7,6,7,6,6,8,6,6,6,5,5
    .byte 3,6,6,7,6,6,7,8,5,4,6,7,7,6,7,7,7,6,7,7,5,7,7,5
    .byte 7,6,6,7,4,7,6,6,6,8,7,7,7,7,7,7,7,7,7,5,6,5,7,6
    .byte 6,7,7,6,7,6,6,7,6,8,8,8,6,7,6,6,6,6,6,7,6,7,5,7
    .byte 6,7,6,7,6,7,7,7,6,4,6,7,6,7,7,6,6,7,7,6,7,6,5,7
    .byte 7,5,6,6,7,7,7,7,7,7,6,7,7,6,7,6,6,5,6,7,6,7,7,6
    .byte 6,6,6,6,7,6,6,6,6,7,6,6,5,5,6,5,7,7,7,7,6,7,7,6
    .byte 5,7,8,7,5,6,6,8,6,5,5,8,7,6,8,5,7,5,5,6,4,7,7,6
    .byte 6,6,6,5,7,7,7,5,7,7,7,6,6,7,7,7,7,7,6,7,5,6,7,7
    .byte 5,7,5,7,7,7,6,7,7,7,7,7,6,6,6,6,6,7,7,6,6,6,5,6
    .byte 6,6,7,7,7,7,5,6,7,8,7,6,4,6,6,7,7,7,6,7,5,7,7,5
    .byte 6,6,6,4,4,5,6,7,6,6,6,6,6,7,6,6,6,7,5,4,7,6,6,7
    .byte 7,7,4,7,7,7,5,7,7,7,8,7,6,7,7,6,5,6,7,7,7,7,7,7
    .byte 6,7,5,4,6,7,7,5,6,7,6,7,7,6,7,7,6,7,6,6,6,6,5,7
    .byte 7,6,6,8,7,5,6,6,6,7,6,7,6,7,4,6,7,6,5,6,6,6,6,5
    .byte 7,6,6,7,7,5,6,7,5,6,5,7,7,7,6,7,7,6,7,7,7,5,6,7
    .byte 5,6,6,6,7,6,6,7,7,4,8,6,7,6,6,6,6,5,6,7,7,6,7,7
    .byte 7,6,7,6,6,4,7,5,6,7,6,7,6,6,8,5,7,5,6,7,7,6,5,7
    .byte 7,5,8,5,5,5,6,6,7,7,6,7,6,7,5,7,6,6,6,6,6,7,6,8
    .byte 6,7,6,7,6,6,7,6,7,6,6,6,6,8,6,7,8,7,6,6,7,6,7,6
    .byte 7,7,4,6,7,6,7,7,7,7,6,7,5,6,6,5,6,7,5,8,7,5,6,6
    .byte 6,7,6,6,6,7,6,7,6,7,6,6,7,5,5,6,5,7,7,6,6,5,5,7
    .byte 6,7,7,6,7,6,7,7,6,4,7,6,8,8,6,7,5,7,6,6,6,7,7,7
    .byte 6,6,7,7,6,6,5,6,7,7,5,6,6,6,7,7,7,7,7,6,7,6,4,5
    .byte 7,6,5,6,8,7,7,6,6,7,6,4,7,7,6,7,6,6,7,6,6,4,6,6
    .byte 4,5,5,7,6,7,7,7,6,6,6,7,8,7,7,6,6,6,5,7,8,6,7,6
    .byte 6,7,7,8,7,7,6,5,7,5,7,6,5,7,6,6,6,5,7,7,7,8,7,7
    .byte 6,6,7,6,6,7,7,6,7,6,7,6,6,5,5,6,6,5,7,7,5,6,7,6
    .byte 6,6,5,5,6,5,6,6,7,6,6,5,8,5,7,7,5,6,6,7,6,7,7,8
    .byte 7,6,7,7,6,6,7,6,5,6,8,5,7,7,7,6,7,6,6,7,7,6,5,7
    .byte 6,7,6,7,7,6,5,8,7,7,5,7,7,7,7,7,6,7,8,6,7,6,7,4
    .byte 5,5,7,7,6,8,5,7,6,5,5,6,6,7,6,7,6,7,3,6,7,7,6,7
    .byte 7,7,6,7,7,3,6,6,7,7,7,7,6,6,8,7,6,6,7,7,7,8,6,7
    .byte 7,6,7,8,5,7,6,7,6,6,6,6,7,7,6,7,7,7,7,7,6,7,7,7
    .byte 7,7,7,7,6,6,6,6,5,6,6,6,7,7,6,7,7,6,6,6,7,5,5,6
    .byte 6,7,6,6,5,6,7,7,7,7,7,7,7,6,5,7,6,7,6,7,6,6,6,6
    .byte 6,6,7,7,7,6,7,6,6,6,6,7,7,6,6,5,7,7,5,6,7,7,7,7
    .byte 7,6,7,7,7,5,6,6,7,5,6,7,7,6,6,6,5,6,5,6,6,7,7,6
    .byte 6,7,5,5,7,7,6,5,6,7,7,5,5,7,7,7,6,7,6,5,6,8,7,7
    .byte 6,7,7,6,5,7,7,7,6,7,7,8,3,7,7,7,6,6,7,7,7,8,5,6
    .byte 6,7,6,7,6,7,6,6,6,7,6,8,7,6,7,6,6,6,6,5,6,7,6,7
    .byte 7,7,4,6,7,6,7,5,4,6,7,6,5,7,5,7,7,7,6,6,5,5,6,6
    .byte 7,6,6,7,6,6,7,7,6,6,7,7,6,6,6,8,7,7,7,7,7,7,6,7
    .byte 6,7,7,6,7,7,5,7,7,6,6,6,7,7,5,6,5,7,5,6,7,7,6,8
    .byte 7,7,6,7,6,6,5,6,6,7,6,6,6,6,7,5,6,7,6,7,7,6,5,6
    .byte 7,6,6,6,4,7,6,6,6,6,6,7,4,6,7,7,7,7,7,6,6,7,7,5
    .byte 7,6,6,6,6,7,6,7,7,7,7,5,6,6,7,8,5,6,5,7,6,6,7,6
    .byte 6,5,5,7,6,6,7,7,7,7,6,7,6,7,6,6,7,6,7,5,6,6,7,6
    .byte 6,6,5,8,5,6,6,7,5,4,7,7,6,4,7,6,7,7,7,6,7,6,4,6
    .byte 7,7,8,6,8,6,7,4,7,7,7,7,7,7,7,6,6,6,5,7,6,7,7,7
    .byte 7,8,7,6,5,7,6,7,6,7,6,5,7,6,6,7,7,7,6,7,6,5,7,6
    .byte 4,6,7,5,7,7,6,7,7,7,5,6,6,6,7,6,8,6,7,5,6,5,6,6
    .byte 5,8,6,8,8,4,6,4,7,6,7,6,5,6,6,7,6,5,6,8,7,6,7,6
    .byte 5,7,7,6,6,6,6,7,7,6,7,6,6,7,7,7,7,7,7,7,8,7,6,6
    .byte 6,7,6,6,7,5,7,6,6,6,3,7,6,7,6,6,7,6,6,6,7,6,6,6
    .byte 6,6,7,7,6,5,7,7,6,7,7,7,7,6,7,6,5,6,7,5,6,7,6,5
    .byte 6,7,6,7,7,7,6,5,7,6,7,6,6,7,5,7,5,6,7,7,6,6,6,7
    .byte 7,6,6,7,7,7,7,6,6,5,6,5,6,6,7,7,5,8,5,6,4,6,6,6
    .byte 7,6,6,6,7,7,6,7,6,6,6,7,4,6,6,7,7,7,7,7,7,6,8,7
    .byte 6,7,6,6,7,6,5,5,6,7,7,5,7,7,6,6,6,8,7,6,7,7,6,6
    .byte 7,7,7,7,6,7,7,7,8,7,7,6,7,7,7,4,7,7,7,5,6,6,6,6
    .byte 6,7,6,6,5,4,7,5,5,5,7,7,5,6,7,6,7,6,7,7,7,7,4,7
    .byte 7,6,6,6,6,7,7,7,7,7,6,5,6,7,5,6,5,7,7,7,7,7,8,7
    .byte 6,6,7,6,6,7,5,7,6,6,6,6,7,7,6,7,7,6,6,6,7,7,7,6
    .byte 7,6,5,7,5,6,4,6,7,5,6,7,7,4,6,6,6,6,6,7,6,7,7,4
    .byte 7,7,5,6,6,6,4,7,6,7,7,6,7,7,7,6,7,6,6,7,7,6,6,6
    .byte 6,6,6,7,7,6,6,7,6,6,6,6,7,7,6,6,7,6,7,7,8,6,6,7
    .byte 6,7,7,7,7,7,7,5,5,5,5,6,7,6,7,5,6,6,4,6,6,7,6,6
    .byte 7,7,5,6,6,6,6,5,6,7,7,7,6,5,6,7,7,7,7,6,5,7,7,7
    .byte 6,5,6,6,6,7,6,6,6,7,6,6,7,7,6,6,7,7,6,8,7,6,6,7
    .byte 7,6,7,6,6,8,6,5,6,7,7,7,7,7,7,7,7,6,6,6,6,7,6,7
    .byte 6,7,4,4,5,5,6,5,7,6,6,5,6,7,6,7,5,6,7,6,6,5,6,7
    .byte 6,6,7,7,7,7,4,8,8,6,6,5,7,6,8,6,6,5,5,8,7,7,6,7
    .byte 7,6,8,7,6,7,6,7,8,7,6,7,7,7,7,6,7,6,7,7,7,8,7,7
    .byte 6,7,7,6,7,6,6,7,7,6,6,6,7,6,4,7,7,6,6,6,7,7,7,6
    .byte 6,6,5,6,7,7,6,6,7,6,7,7,7,6,6,7,7,7,6,5,6,7,7,6
    .byte 5,6,7,6,6,6,6,7,6,6,7,7,7,7,7,6,7,7,7,7,6,7,7,7
    .byte 6,6,6,7,7,7,7,7,6,8,7,6,6,6,7,5,5,7,6,7,4,6,5,6
    .byte 6,6,6,5,5,7,7,8,5,6,6,6,7,6,6,5,8,6,6,7,7,6,5,6
    .byte 3,7,8,7,6,5,7,6,8,7,6,6,5,8,7,6,5,6,7,5,8,7,6,7
    .byte 6,7,8,7,5,6,7,7,8,7,6,7,8,6,6,7,7,7,7,7,8,5,7,7
    .byte 6,7,7,6,7,6,7,5,4,6,7,6,6,6,7,6,7,5,6,5,6,6,7,7
    .byte 6,7,7,5,7,6,7,6,5,7,7,6,7,6,6,7,7,7,6,7,6,6,5,7
    .byte 7,7,7,6,7,6,7,7,7,6,6,7,7,7,7,5,6,7,7,6,7,6,7,7
    .byte 6,7,7,7,8,7,5,6,6,7,6,7,7,6,4,5,5,6,6,4,7,7,6,6
    .byte 6,7,6,7,6,5,6,6,6,5,6,7,6,6,7,6,6,7,6,7,6,6,6,6
    .byte 6,7,6,6,6,5,6,7,6,6,8,6,7,6,6,6,7,7,7,6,7,7,7,6
    .byte 6,6,7,6,7,7,5,7,7,7,6,6,7,6,6,6,4,7,7,6,6,6,7,5
    .byte 5,6,5,6,5,5,7,7,5,6,7,6,6,5,6,7,7,7,5,5,7,7,6,6
    .byte 7,6,6,6,6,7,7,6,6,7,7,6,5,5,7,7,7,6,7,7,6,5,7,7
    .byte 7,7,7,7,7,6,7,6,5,6,6,7,6,7,7,7,7,6,7,6,5,7,7,7
    .byte 7,5,6,5,6,7,7,7,5,6,5,6,7,6,5,4,6,7,7,7,5,7,6,6
    .byte 7,7,5,5,7,7,6,6,7,5,6,7,6,7,7,7,7,7,5,6,6,7,6,6
    .byte 6,5,7,6,7,6,7,7,5,7,7,7,6,6,7,7,6,6,6,7,7,7,6,7
    .byte 7,7,7,8,7,7,7,6,6,3,7,6,7,6,6,7,7,6,6,6,5,5,5,5
    .byte 7,6,5,5,6,7,6,6,7,6,6,6,7,7,6,6,5,7,7,7,5,7,7,7
    .byte 6,7,7,7,6,6,7,5,7,7,6,6,7,6,5,7,6,6,7,6,7,6,7,5
    .byte 6,7,6,6,5,7,6,7,7,6,6,6,7,7,6,6,7,6,6,6,6,5,7,6
    .byte 5,7,7,8,4,8,5,5,5,5,6,7,8,6,6,7,7,7,6,7,5,5,6,6
    .byte 5,6,6,7,6,8,5,8,7,7,7,4,5,4,7,6,6,7,6,6,6,7,7,4
    .byte 7,7,7,5,7,7,6,6,7,7,6,7,6,7,6,7,7,7,7,7,7,7,6,7
    .byte 7,7,7,6,5,5,7,7,6,7,6,6,7,7,5,5,4,6,7,7,7,6,7,5
    .byte 7,6,7,5,6,5,5,6,6,6,7,6,7,7,6,6,7,7,7,7,6,6,6,6
    .byte 6,7,6,6,6,7,6,7,6,7,7,6,6,7,8,6,6,7,6,7,6,6,7,6
    .byte 7,7,6,8,7,6,7,7,7,6,7,6,6,6,5,7,5,7,5,6,6,5,6,6
    .byte 6,5,7,6,6,6,6,7,6,8,8,5,6,6,5,6,6,7,5,7,7,6,7,6
    .byte 6,6,6,6,7,7,5,6,7,7,7,6,7,7,6,5,6,4,7,7,7,7,6,7
    .byte 6,5,7,7,5,7,6,6,7,7,6,7,6,6,7,6,7,7,8,7,7,5,6,6
    .byte 6,6,7,5,6,5,5,7,6,7,5,6,7,7,4,6,7,7,5,5,6,7,7,7
    .byte 6,7,5,6,6,7,6,6,6,6,6,5,6,7,5,7,7,6,7,6,8,7,6,7
    .byte 7,5,5,7,8,7,7,7,7,5,7,7,6,6,8,7,6,7,5,7,6,6,7,7
    .byte 7,7,7,6,7,7,6,6,6,6,6,7,6,5,6,6,6,6,6,5,7,6,4,7
    .byte 7,7,7,5,6,4,7,6,7,7,6,7,6,7,7,5,5,6,6,7,6,6,7,6
    .byte 6,7,6,8,7,7,7,7,7,6,5,5,7,7,7,7,7,8,5,7,7,6,7,7
    .byte 7,7,6,6,6,6,6,7,6,6,7,7,7,6,7,6,6,6,6,7,7,7,4,6
    .byte 6,6,5,6,6,8,7,5,7,7,7,6,6,7,4,7,6,6,7,6,7,6,7,7
    .byte 6,5,5,6,7,7,6,7,7,6,7,6,7,8,7,8,6,7,5,7,4,6,7,7
    .byte 7,7,8,7,4,6,7,6,7,7,7,7,6,6,6,6,7,7,6,7,8,7,6,7
    .byte 6,5,7,7,5,7,6,6,5,5,6,5,8,5,6,7,7,5,6,7,8,5,5,6
    .byte 6,6,7,7,7,6,6,7,6,6,6,6,6,6,7,6,6,6,7,5,6,6,7,6
    .byte 6,7,6,6,6,6,6,8,7,7,8,5,7,4,6,6,6,7,6,6,7,7,7,7
    .byte 6,7,6,7,7,5,7,7,6,5,6,5,5,7,8,6,6,6,6,7,6,6,6,7
    .byte 7,7,6,6,7,8,6,5,4,7,6,7,7,7,6,6,4,6,6,6,5,5,7,7
    .byte 6,7,6,7,7,7,8,7,8,7,7,5,6,6,7,7,6,6,7,7,7,5,7,5
    .byte 6,7,7,7,7,6,5,8,8,6,6,6,7,7,6,7,5,7,5,6,6,6,5,6
    .byte 6,7,7,6,6,7,4,8,6,6,8,7,6,5,7,7,4,6,7,7,8,8,6,7
    .byte 6,6,4,7,6,6,5,7,7,6,6,6,7,6,7,7,7,6,5,7,7,8,6,7
    .byte 6,6,7,6,7,7,4,6,7,7,7,6,7,6,7,7,7,7,7,6,7,7,5,6
    .byte 7,7,7,6,5,7,6,5,8,8,5,6,5,5,7,7,6,6,7,7,6,6,7,6
    .byte 6,5,3,8,7,7,6,8,7,6,5,5,7,5,6,5,7,6,5,4,6,5,7,7
    .byte 7,7,7,8,7,5,7,6,6,6,6,7,7,5,8,6,6,6,7,7,7,7,7,7
    .byte 8,7,7,6,5,6,5,7,5,7,7,6,6,6,6,8,7,6,7,7,6,6,5,6
    .byte 6,6,6,7,6,7,6,7,7,7,6,4,7,6,6,6,7,7,4,7,6,5,6,6
    .byte 6,6,6,7,6,6,8,6,7,6,7,7,7,6,5,7,7,6,7,7,7,5,6,6
    .byte 6,7,6,6,7,7,8,6,7,7,5,6,6,6,6,6,6,6,6,5,7,6,6,6
    .byte 7,6,7,5,5,7,6,5,7,6,5,7,7,6,7,6,6,5,7,7,7,7,6,4
    .byte 4,6,5,7,7,5,6,8,6,6,5,6,6,6,7,6,6,6,7,7,6,6,7,7
    .byte 8,7,7,6,7,7,7,6,4,5,7,6,7,6,7,7,7,7,7,7,7,6,7,7
    .byte 7,6,6,5,6,7,5,7,7,6,6,7,6,7,5,5,7,8,6,6,6,5,7,5
    .byte 5,4,7,7,6,7,6,6,5,6,6,5,6,6,7,7,6,6,6,6,6,7,6,6
    .byte 7,6,7,7,7,7,7,7,6,7,7,6,6,7,7,5,7,5,7,6,7,7,6,7
    .byte 7,7,7,7,5,7,6,7,6,6,7,6,7,5,7,7,6,7,7,7,7,4,6,6
    .byte 7,6,6,5,6,7,7,6,7,5,7,5,7,7,6,7,6,6,5,5,5,5,7,6
    .byte 6,6,6,4,5,6,6,6,7,6,6,6,8,6,5,6,6,6,8,6,7,7,4,8
    .byte 6,7,6,7,6,7,8,8,7,7,7,7,7,6,6,6,7,6,7,7,6,6,6,6
    .byte 7,8,6,8,7,7,5,6,6,7,7,7,6,6,7,6,6,6,7,7,5,7,5,6
    .byte 6,8,6,5,7,7,5,6,6,7,7,7,5,6,5,7,7,6,7,6,6,6,6,7
    .byte 7,7,6,7,6,6,5,7,7,6,6,5,6,6,7,8,7,7,6,6,8,6,6,7
    .byte 6,6,6,6,7,6,7,6,7,7,6,7,7,6,6,5,6,6,7,6,6,6,6,7
    .byte 6,5,6,5,7,5,7,7,5,7,7,7,6,6,5,4,6,6,6,6,6,6,6,6
    .byte 7,6,7,7,6,6,6,8,6,6,8,7,7,7,6,7,7,6,7,6,4,5,7,5
    .byte 6,6,8,7,8,7,7,6,7,6,6,6,6,6,7,6,7,7,4,8,7,6,6,7
    .byte 6,7,6,6,7,8,7,6,7,5,7,4,4,4,6,8,6,7,6,6,6,6,5,6
    .byte 5,6,6,7,6,7,5,6,7,7,7,7,7,6,7,6,6,6,7,7,6,7,8,6
    .byte 7,7,7,6,5,7,6,7,6,7,7,7,7,6,7,6,6,6,5,7,6,6,7,6
    .byte 7,6,7,6,5,6,6,7,6,6,5,7,6,5,7,6,5,7,7,5,7,5,6,5
    .byte 7,6,7,7,7,5,5,7,6,6,6,6,7,7,6,4,5,7,6,7,7,6,7,5
    .byte 7,7,4,7,5,7,8,7,7,7,5,8,6,6,7,6,6,7,7,7,6,7,6,7
    .byte 7,6,7,6,6,5,7,7,6,7,6,6,7,7,6,7,6,7,6,7,6,7,6,7
    .byte 7,6,7,6,6,5,7,6,5,7,6,7,6,7,7,5,7,7,4,6,5,6,8,6
    .byte 5,7,7,7,6,6,7,6,7,7,7,7,6,7,7,7,5,8,6,6,6,7,7,7
    .byte 3,7,7,6,6,6,7,6,7,8,6,7,6,6,7,7,6,7,6,7,7,6,6,7
    .byte 7,5,8,7,6,5,5,4,6,7,6,7,7,7,5,6,7,5,6,5,4,7,7,6
    .byte 6,8,6,6,6,6,6,6,5,6,6,7,7,7,6,7,6,6,8,6,7,7,7,6
    .byte 6,6,6,8,7,7,6,7,6,6,7,6,6,6,7,7,8,7,6,7,8,6,7,6
    .byte 7,7,5,6,6,7,4,6,6,6,6,7,7,7,7,6,6,6,5,7,6,6,7,7
    .byte 6,5,6,6,5,6,6,7,7,7,5,7,6,6,5,6,5,7,5,6,7,7,6,6
    .byte 7,5,6,7,7,7,7,7,7,6,5,7,6,8,7,7,7,6,7,5,6,5,7,7
    .byte 7,7,7,7,7,7,6,6,7,6,7,6,7,6,6,6,5,5,6,6,7,6,6,6
    .byte 6,7,7,5,7,7,6,7,6,7,7,7,7,4,5,6,6,7,6,7,5,6,5,6
    .byte 6,5,5,5,7,6,5,5,7,5,7,7,8,7,8,7,7,5,7,6,6,7,5,6
    .byte 7,5,7,5,6,7,6,6,6,7,7,7,8,6,7,6,6,5,5,7,6,7,6,5
    .byte 6,6,5,7,7,6,7,6,6,5,6,6,7,7,7,7,6,7,5,7,7,7,7,5
    .byte 8,5,6,6,7,6,5,7,7,5,5,6,5,6,6,7,5,7,6,5,6,5,6,6
    .byte 8,6,5,8,7,7,4,6,7,7,8,6,7,6,7,7,6,6,7,6,7,7,8,7
    .byte 7,6,6,4,7,7,6,6,6,7,6,7,6,5,6,7,7,6,6,5,6,6,6,7
    .byte 7,6,7,8,6,5,6,6,6,7,6,6,7,7,5,6,7,6,5,6,6,6,5,5
    .byte 6,6,7,6,6,6,6,6,4,7,6,7,8,7,7,6,7,5,7,7,7,6,7,7
    .byte 6,7,6,6,6,7,7,7,7,5,7,7,7,7,5,6,7,5,5,7,8,5,7,7
    .byte 7,6,7,6,6,5,7,6,6,7,7,6,6,6,7,5,6,6,6,7,6,6,6,8
    .byte 7,5,7,5,5,5,5,6,6,6,6,7,6,6,6,6,5,5,7,6,7,8,7,7
    .byte 6,7,5,7,6,7,6,6,7,6,6,7,5,7,7,7,7,7,6,6,7,6,6,5
    .byte 7,7,5,6,7,7,6,7,7,7,5,7,5,6,5,6,7,7,6,7,7,6,6,7
    .byte 6,6,5,7,6,7,7,6,7,7,6,7,6,6,5,6,5,6,7,6,6,6,5,7
    .byte 5,7,6,7,7,6,7,8,6,4,7,6,7,8,6,7,5,7,7,6,7,7,6,6
    .byte 6,7,8,7,6,7,5,6,7,6,6,6,7,6,7,7,6,6,6,6,6,6,5,5
    .byte 6,6,6,7,7,6,7,5,6,6,6,5,6,7,6,7,7,6,6,6,6,5,5,6
    .byte 5,7,6,7,7,7,6,6,7,7,7,7,6,5,6,6,6,6,6,5,6,6,7,7
    .byte 6,7,7,4,5,6,8,7,6,7,6,7,5,7,7,6,7,6,6,7,7,6,7,6
    .byte 6,7,6,6,6,6,5,6,7,7,6,7,7,7,7,5,6,6,6,6,2,6,6,7
    .byte 6,7,6,6,8,7,5,7,6,5,6,7,6,7,8,7,6,6,6,7,7,6,7,7
    .byte 6,6,5,6,7,6,5,7,7,6,7,6,7,6,3,6,7,7,7,6,7,6,5,7
    .byte 6,5,6,6,6,7,5,6,7,6,7,8,7,6,6,6,5,7,6,5,6,6,6,7
    .byte 8,6,5,5,6,6,8,6,6,6,7,7,6,7,7,6,6,5,7,7,7,6,6,7
    .byte 6,6,7,6,7,7,6,6,7,5,7,5,5,6,6,7,6,7,7,6,6,7,5,4
    .byte 8,5,7,8,7,6,6,6,7,7,6,6,7,7,7,7,5,7,7,7,7,7,7,6
    .byte 7,6,6,6,6,7,6,7,6,6,7,5,6,2,5,6,6,5,6,7,7,5,6,7
    .byte 7,5,7,5,7,6,7,7,7,7,6,7,8,6,7,6,6,6,8,5,6,6,5,6
    .byte 7,6,6,6,7,7,6,4,6,6,6,7,7,7,7,7,7,5,6,7,6,7,7,5
    .byte 5,8,7,8,7,8,6,7,6,7,5,6,6,6,6,5,7,7,3,6,6,5,5,5
    .byte 5,7,6,7,6,7,6,7,6,7,6,5,6,6,7,6,7,8,7,5,7,5,7,7
    .byte 7,7,6,6,6,5,5,6,6,6,7,6,7,6,6,7,5,4,7,6,6,7,6,7
    .byte 6,6,7,6,6,5,6,6,6,5,7,6,6,7,7,7,6,7,5,6,6,6,6,7
    .byte 7,6,7,7,5,4,5,6,6,7,5,5,7,7,7,6,7,7,5,5,6,7,6,6
    .byte 6,6,8,7,6,7,5,7,8,7,5,7,6,7,5,4,6,7,7,6,7,7,7,6
    .byte 6,5,5,7,5,7,8,7,5,6,6,7,6,7,7,7,6,6,7,6,8,6,6,7
    .byte 7,7,6,6,6,6,7,6,6,7,6,7,7,7,5,5,3,5,7,6,5,6,7,7
    .byte 5,7,7,6,5,7,4,8,6,7,7,7,7,7,7,6,7,8,6,6,7,7,6,7
    .byte 6,6,6,7,7,7,6,7,7,5,4,6,7,7,6,6,6,7,6,6,7,7,6,7
    .byte 6,7,6,7,7,7,7,8,5,7,6,7,5,7,6,7,7,7,6,7,7,6,5,6
    .byte 6,6,2,6,7,7,7,7,6,7,7,7,5,6,6,6,6,6,7,7,7,7,6,7
    .byte 7,6,6,5,6,6,7,6,6,6,6,5,6,7,6,6,7,7,7,5,7,6,6,6
    .byte 6,6,7,8,7,6,7,6,6,6,7,4,5,7,6,7,6,7,5,7,7,6,6,7
    .byte 7,6,6,6,6,6,3,7,7,6,5,5,6,7,6,6,7,7,7,7,7,7,7,4
    .byte 5,7,7,7,7,6,6,7,7,7,7,7,6,6,7,6,7,7,6,6,7,7,7,7
    .byte 5,6,7,5,5,6,8,6,6,7,5,8,6,7,7,7,7,7,7,6,6,7,7,7
    .byte 7,7,6,6,5,7,6,7,7,6,7,7,7,6,7,6,6,6,7,6,1,7,6,7
    .byte 7,7,6,7,7,7,6,7,6,7,7,7,7,6,7,6,6,7,6,7,7,7,6,8
    .byte 5,7,5,5,7,7,7,6,7,6,7,5,6,5,5,7,4,7,7,7,6,5,7,6
    .byte 7,7,7,6,7,6,7,6,7,7,7,6,6,7,7,6,6,7,7,6,6,7,6,7
    .byte 7,6,6,5,3,4,7,5,5,6,7,7,4,7,7,6,6,7,6,7,6,6,7,8
    .byte 6,6,6,6,7,6,7,7,7,5,7,5,6,6,6,6,6,6,7,6,5,7,6,4
    .byte 7,6,6,7,6,7,6,6,6,7,6,6,6,5,7,5,6,6,7,7,7,7,5,7
    .byte 6,6,7,5,6,7,6,6,7,7,6,5,4,5,6,7,5,6,7,7,6,6,7,6
    .byte 6,5,6,6,7,7,7,6,7,7,5,7,7,5,7,6,7,7,7,6,5,6,6,6
    .byte 6,6,7,6,6,6,6,5,7,5,6,7,7,7,7,7,6,5,7,7,7,7,7,5
    .byte 5,7,7,7,7,7,6,6,7,7,6,6,7,5,5,6,7,6,3,7,7,6,4,4
    .byte 6,6,6,7,7,7,7,7,6,6,7,5,7,7,7,7,7,7,7,5,7,6,7,7
    .byte 6,6,7,6,6,4,5,6,6,7,5,7,6,7,6,7,4,5,7,5,7,7,7,6
    .byte 6,6,6,7,7,7,7,6,6,6,6,7,6,7,7,7,7,7,7,5,7,6,5,7
    .byte 7,7,7,6,6,5,6,3,5,6,6,4,5,7,7,5,7,6,7,6,7,6,7,7
    .byte 7,6,7,6,6,6,6,6,6,7,7,7,6,6,4,6,6,6,6,6,6,7,6,6
    .byte 7,6,4,6,6,6,6,5,7,5,6,6,7,6,6,5,6,7,4,7,6,7,6,8
    .byte 8,6,7,6,5,7,6,6,7,6,5,7,7,5,5,5,6,6,7,5,6,6,6,7
    .byte 5,7,7,6,6,6,5,7,7,7,7,7,7,6,7,6,7,7,7,6,7,6,6,6
    .byte 5,6,6,7,6,6,6,7,7,5,5,5,7,7,5,6,6,7,6,6,7,7,6,7
    .byte 6,7,7,7,6,7,7,8,6,7,6,7,6,6,7,7,6,6,6,6,7,5,6,5
    .byte 7,7,2,7,6,6,6,6,5,6,7,7,6,7,7,6,7,7,8,7,8,7,5,6
    .byte 7,6,7,6,6,7,7,6,6,5,6,6,7,6,7,7,6,6,6,5,7,6,5,7
    .byte 7,7,6,7,7,6,7,7,6,7,6,5,4,7,7,8,7,7,6,7,7,7,6,7
    .byte 7,6,6,6,7,7,2,7,7,6,5,5,6,7,5,7,6,6,6,6,7,6,7,5
    .byte 5,6,6,7,7,7,7,6,7,6,6,6,6,7,6,5,8,6,7,6,6,6,7,7
    .byte 6,6,6,6,6,6,6,6,7,6,5,6,6,6,8,6,7,5,7,6,7,8,7,7
    .byte 6,7,6,6,6,6,6,7,6,6,6,6,5,6,7,6,5,5,6,6,6,6,6,3
    .byte 6,6,6,5,7,7,5,7,7,4,6,6,8,6,7,7,5,8,6,6,5,6,7,7
    .byte 6,7,6,7,6,7,6,7,7,5,6,6,6,6,6,6,7,6,6,6,6,7,7,7
    .byte 6,7,5,7,6,7,7,7,8,6,6,7,6,6,6,6,6,7,7,5,7,5,6,6
    .byte 5,6,6,6,5,7,7,6,3,7,7,7,6,7,7,6,7,6,5,5,6,7,7,8
    .byte 6,6,8,6,7,6,6,7,7,6,8,7,7,6,7,5,6,8,6,6,6,5,7,7
    .byte 7,6,7,7,6,5,7,7,8,5,6,6,7,5,8,7,8,8,7,6,7,5,5,7
    .byte 6,6,7,7,5,7,5,7,7,6,6,6,5,6,7,7,7,2,6,7,7,6,6,6
    .byte 6,7,6,5,6,6,7,7,8,6,6,8,5,6,6,7,6,6,6,7,7,6,5,7
    .byte 6,6,7,6,6,5,5,7,7,7,6,6,7,6,6,7,6,8,5,6,6,8,6,7
    .byte 7,7,7,7,6,6,6,6,6,5,7,7,6,6,6,4,7,6,5,6,6,6,5,7
    .byte 6,6,3,7,6,6,6,6,7,6,6,6,6,6,6,6,5,5,6,6,7,7,7,7
    .byte 5,7,7,7,7,7,7,6,7,7,6,7,6,6,7,6,5,7,6,7,6,6,6,5
    .byte 7,7,7,5,5,7,6,7,6,7,6,7,7,7,6,5,6,6,5,6,5,6,7,7
    .byte 6,7,6,5,7,8,6,6,4,6,6,7,6,6,7,7,4,7,6,6,5,5,7,7
    .byte 4,7,6,6,5,6,7,7,8,6,5,7,7,7,7,7,8,7,6,7,5,6,7,7
    .byte 6,6,5,8,5,7,5,7,7,6,7,7,6,5,6,7,5,7,7,7,7,6,6,7
    .byte 7,7,5,4,6,7,7,6,6,8,7,5,6,5,7,7,6,6,6,7,6,6,7,5
    .byte 7,6,6,6,6,5,6,7,7,4,6,5,5,7,6,6,7,7,6,8,7,6,7,6
    .byte 7,7,7,5,6,7,7,7,7,7,7,6,7,6,7,6,5,7,6,6,7,6,6,4
    .byte 7,6,5,6,7,7,6,6,8,6,7,6,5,4,6,8,7,5,7,6,6,6,7,6
    .byte 6,4,6,6,8,6,6,7,7,4,6,6,6,4,6,4,7,7,7,4,7,7,7,6
    .byte 7,7,7,6,6,7,7,7,7,7,7,7,7,6,6,6,7,6,6,6,6,7,7,6
    .byte 7,7,5,6,7,7,7,6,6,6,7,6,7,7,7,7,6,6,7,6,6,7,5,4
    .byte 4,7,7,6,6,6,6,6,6,5,6,6,6,7,6,5,6,7,5,6,7,6,6,6
    .byte 6,7,5,6,6,6,7,7,6,6,7,5,7,8,7,7,6,7,6,6,7,7,7,6
    .byte 6,7,7,6,7,6,5,7,5,6,5,7,6,6,6,7,6,6,7,7,6,6,6,6
    .byte 7,7,7,7,7,7,7,4,7,5,6,6,6,5,7,7,5,7,8,6,7,7,6,4
    .byte 4,7,6,7,4,7,6,7,5,3,7,7,7,6,7,5,7,6,6,6,8,7,7,8
    .byte 7,7,6,7,6,7,7,7,6,7,7,7,7,5,8,7,7,7,6,7,7,5,5,7
    .byte 6,6,7,7,7,6,7,5,6,7,6,7,7,7,6,7,7,6,3,6,5,7,7,6
    .byte 7,6,6,7,5,7,5,5,7,5,6,6,7,6,5,7,7,6,5,6,7,7,6,5
    .byte 6,7,7,6,7,6,6,7,7,6,6,7,6,6,7,7,7,7,7,8,8,7,6,7
    .byte 6,6,5,6,5,7,7,6,6,7,7,5,5,7,7,4,6,8,7,7,7,7,7,7
    .byte 7,6,6,7,6,5,6,7,6,6,6,6,6,7,5,6,7,6,5,5,6,5,7,6
    .byte 4,6,7,6,6,6,6,4,6,6,5,7,7,6,7,7,7,7,6,7,6,6,7,5
    .byte 8,7,7,7,6,6,7,7,5,6,5,6,5,8,6,6,6,5,7,6,7,7,5,7
    .byte 6,6,6,8,7,5,7,7,7,5,7,6,6,6,7,7,7,5,5,7,7,7,7,6
    .byte 5,6,5,3,5,6,6,7,7,6,6,6,6,7,5,7,7,5,6,4,6,6,6,7
    .byte 7,7,7,7,7,6,7,8,7,6,7,6,5,6,7,6,6,6,7,7,7,6,6,6
    .byte 5,6,6,6,6,7,6,6,6,5,6,7,7,6,7,7,7,7,7,6,7,7,4,7
    .byte 7,6,4,5,5,6,7,6,6,6,6,6,6,7,6,5,6,6,6,7,5,5,7,7
    .byte 7,6,7,7,6,4,6,6,6,7,6,7,6,8,7,8,8,8,7,7,7,7,7,7
    .byte 6,7,6,8,6,7,4,6,7,5,7,7,7,6,6,7,7,7,7,5,6,6,6,7
    .byte 8,7,7,7,7,6,4,5,6,6,6,6,6,6,5,5,6,7,5,7,7,6,6,7
    .byte 5,6,5,7,6,7,5,7,6,6,7,6,5,6,5,7,7,6,6,7,7,6,7,7
    .byte 6,7,7,7,7,6,6,7,7,7,5,6,6,6,8,7,6,7,6,7,6,7,6,6
    .byte 6,5,7,6,7,7,7,6,7,7,6,7,8,7,6,6,7,5,7,6,6,4,7,6
    .byte 7,6,6,8,6,7,7,6,6,2,7,6,7,5,7,6,6,7,6,6,7,4,5,5
    .byte 6,5,6,7,7,7,7,6,7,7,7,7,6,7,7,7,7,7,6,7,4,7,7,6
    .byte 6,7,7,5,6,6,6,6,6,7,7,5,7,7,6,6,7,6,7,7,6,5,6,7
    .byte 4,7,6,4,6,6,6,6,6,6,6,6,6,7,6,5,8,8,6,3,5,6,7,6
    .byte 5,7,5,7,8,5,5,5,7,8,7,6,6,7,6,7,7,6,7,7,6,7,7,7
    .byte 5,7,7,6,6,7,5,7,7,7,7,7,4,7,4,6,6,7,6,7,7,6,7,7
    .byte 8,8,7,7,5,7,6,5,6,6,3,7,7,6,7,7,5,6,6,6,5,8,7,5
    .byte 6,6,5,6,7,6,5,6,6,6,6,5,6,7,6,6,5,5,7,6,6,6,6,7
    .byte 6,7,6,6,7,7,7,7,8,5,6,7,6,6,6,5,7,8,7,6,7,5,7,5
    .byte 6,7,6,7,6,7,7,5,6,7,7,7,6,7,7,7,6,5,6,6,5,6,5,7
    .byte 5,7,7,5,7,6,7,6,7,6,5,5,6,6,7,7,3,7,5,5,7,7,7,6
    .byte 3,6,7,6,7,7,7,6,6,7,6,6,6,7,7,7,7,7,6,6,6,6,6,7
    .byte 7,7,6,7,5,7,6,5,7,5,7,6,7,6,7,7,6,7,8,7,7,7,7,6
    .byte 5,5,5,6,6,5,5,7,6,7,6,6,6,6,5,6,6,7,7,5,4,7,7,6
    .byte 5,6,6,6,6,7,7,6,7,6,6,5,6,7,7,7,7,7,7,5,6,7,6,7
    .byte 8,7,8,7,6,7,6,7,6,7,6,7,7,7,5,5,5,6,6,6,7,6,8,6
    .byte 6,6,6,7,7,7,5,7,7,6,7,6,6,5,6,6,7,6,4,7,7,7,6,4
    .byte 7,7,6,5,6,6,6,6,7,6,5,7,4,7,7,7,6,7,7,6,4,7,7,7
    .byte 7,7,6,7,7,6,6,7,7,7,7,7,6,7,6,7,7,6,7,5,7,4,7,7
    .byte 6,8,7,5,6,5,7,7,5,7,7,7,6,6,7,7,6,6,7,6,7,5,6,7
    .byte 7,4,5,7,6,6,7,6,6,6,6,5,4,7,6,7,7,6,5,5,7,7,6,5
    .byte 6,6,6,6,4,6,6,6,7,7,7,8,7,6,7,6,7,6,7,6,6,6,6,6
    .byte 6,7,7,6,6,4,6,7,7,7,6,7,7,7,7,6,6,6,7,7,7,7,6,7
    .byte 7,7,7,6,6,7,6,6,7,6,7,4,6,7,7,7,6,7,3,7,7,5,7,5
    .byte 7,6,6,6,4,6,5,6,5,6,6,7,6,6,7,7,5,6,7,7,8,7,6,7
    .byte 7,7,6,6,7,7,6,7,7,7,6,7,5,7,6,7,6,8,6,7,7,7,6,7
    .byte 6,6,6,6,7,7,7,7,5,7,5,7,6,7,5,5,6,7,5,7,6,6,7,7
    .byte 7,5,5,7,5,6,6,6,7,7,5,7,7,7,3,4,5,6,7,5,7,6,6,6
    .byte 7,7,5,7,7,7,7,6,6,7,7,7,6,6,6,7,7,7,7,7,7,6,6,6
    .byte 7,6,7,7,7,7,7,7,5,6,5,6,7,6,7,6,7,7,6,6,6,6,6,7
    .byte 7,5,6,6,6,4,6,6,7,6,6,7,6,7,6,5,7,7,5,7,7,4,5,5
    .byte 6,7,7,4,7,6,7,5,7,6,7,7,7,6,7,7,7,6,6,7,7,6,7,5
    .byte 7,7,6,5,7,6,7,5,7,5,6,6,7,8,7,7,6,6,7,5,7,7,7,7
    .byte 6,5,7,7,7,5,3,7,6,6,5,6,7,7,5,7,6,6,6,5,6,6,6,7
    .byte 7,7,6,7,6,6,7,6,6,6,7,7,5,6,6,6,7,6,5,7,7,7,7,7
    .byte 7,7,5,7,7,7,4,7,7,7,6,7,8,6,7,7,5,8,5,5,7,6,7,7
    .byte 7,6,5,7,7,5,6,7,6,6,7,8,5,7,6,4,5,6,8,7,6,7,7,5
    .byte 6,7,7,5,5,5,6,7,7,6,6,7,5,6,6,6,5,6,5,7,6,5,6,6
    .byte 6,7,7,7,6,6,5,7,7,7,7,7,8,7,7,7,6,7,6,7,6,7,4,8
    .byte 7,6,6,6,6,6,7,8,7,6,6,8,6,8,7,7,6,7,7,6,6,6,6,6
    .byte 6,7,4,7,7,6,6,6,6,6,7,8,6,6,3,6,6,7,6,6,7,7,5,7
    .byte 6,6,6,5,7,6,7,4,6,8,7,7,6,6,7,7,6,6,6,7,7,6,7,7
    .byte 6,6,5,7,7,6,6,7,7,7,6,5,7,7,4,6,8,7,6,6,6,7,7,5
    .byte 6,7,7,7,6,6,6,6,5,6,4,5,4,7,7,6,5,6,7,7,6,6,5,5
    .byte 6,7,5,5,7,7,5,7,7,6,7,6,7,7,5,7,7,6,6,5,6,5,6,6
    .byte 8,6,7,8,7,6,7,7,6,5,6,7,6,6,7,5,6,6,7,7,6,6,7,6
    .byte 5,6,6,7,6,7,6,7,6,6,5,7,7,6,7,7,7,6,6,6,7,7,3,8
    .byte 6,6,4,4,6,6,7,7,5,7,6,6,6,6,6,5,6,6,6,7,6,5,7,7
    .byte 6,7,7,6,5,6,7,8,6,6,7,6,5,6,6,6,7,6,7,7,7,7,7,7
    .byte 7,4,7,5,6,7,6,5,7,6,7,6,7,6,7,7,6,7,5,7,7,6,7,7
    .byte 7,7,7,7,6,5,6,7,6,6,5,6,4,6,5,7,7,7,7,6,7,7,7,6
    .byte 3,6,6,7,6,7,5,7,6,6,7,7,6,5,5,6,6,6,6,7,8,6,7,6
    .byte 7,7,7,7,6,6,6,7,6,6,6,5,7,6,7,5,7,7,6,7,7,6,7,7
    .byte 7,7,7,6,4,7,6,7,7,8,7,6,7,7,5,5,4,6,6,7,5,5,6,5
    .byte 6,5,7,6,7,6,6,6,6,6,5,6,6,7,7,6,6,7,7,6,7,5,6,5
    .byte 7,4,6,7,7,7,7,6,7,7,7,7,6,7,6,7,6,7,7,7,3,6,7,6
    .byte 6,6,6,5,5,6,6,6,7,7,7,6,7,6,7,7,6,7,7,8,7,6,5,8
    .byte 5,6,5,3,6,7,6,7,6,6,7,6,7,7,6,5,7,7,5,4,6,7,7,7
    .byte 5,7,5,7,8,6,6,6,6,7,7,6,6,6,7,7,7,7,8,7,7,6,7,6
    .byte 5,7,6,6,5,6,6,7,7,6,7,6,4,7,5,6,6,7,7,7,7,7,7,7
    .byte 7,7,7,6,6,6,6,6,7,7,2,7,6,6,7,6,5,6,5,6,6,7,7,4
    .byte 6,6,6,6,7,6,6,7,6,6,5,6,7,7,6,4,7,7,7,7,7,6,6,5
    .byte 7,6,7,7,7,7,7,7,7,6,7,5,6,5,7,7,6,5,7,6,7,7,6,7
    .byte 6,6,6,7,6,7,7,7,6,7,7,7,6,6,6,6,6,6,5,6,4,5,6,7
    .byte 6,5,7,7,6,6,5,5,6,7,5,5,6,7,5,6,6,6,7,5,5,6,7,7
    .byte 6,6,6,7,7,6,6,5,7,6,8,6,6,6,7,7,7,7,6,5,6,6,6,5
    .byte 6,7,7,7,5,8,6,7,6,5,7,7,7,6,8,6,5,7,6,6,6,6,6,7
    .byte 7,6,6,5,6,4,7,4,7,6,7,6,5,7,7,7,5,6,6,6,5,6,5,7
    .byte 8,4,7,6,6,7,7,7,7,6,5,6,7,7,7,6,6,7,6,6,7,7,7,7
    .byte 7,7,7,7,7,6,6,6,6,7,6,7,8,8,4,6,6,6,6,7,7,7,7,6
    .byte 6,7,6,7,6,7,5,6,7,6,7,7,6,4,6,6,6,6,5,7,7,7,6,4
    .byte 7,7,5,6,7,7,6,6,6,7,6,7,7,6,5,7,7,7,6,7,6,7,6,6
    .byte 8,7,7,7,6,6,7,7,6,7,8,6,6,6,7,6,6,5,4,6,6,7,6,6
    .byte 6,6,7,7,7,7,6,7,6,5,6,6,7,7,8,7,7,7,7,3,7,5,6,5
    .byte 5,6,7,7,6,6,7,6,7,6,5,5,5,7,5,6,4,7,7,7,6,4,7,7
    .byte 6,7,6,4,6,6,7,5,7,6,7,7,7,6,5,7,7,6,6,7,7,7,6,6
    .byte 6,4,7,7,6,6,7,6,6,6,5,7,7,5,8,6,7,6,6,6,5,7,7,7
    .byte 7,6,7,6,7,5,3,5,6,6,7,6,7,6,6,8,4,6,5,6,6,6,7,6
    .byte 8,7,6,8,6,6,5,6,7,7,7,6,6,6,6,6,6,6,7,7,6,6,6,6
    .byte 6,7,7,6,8,7,6,7,7,7,6,7,7,7,6,6,6,7,8,7,6,7,7,6
    .byte 5,6,7,4,6,7,7,7,7,8,7,7,6,7,5,6,6,4,6,7,6,5,6,6
    .byte 6,7,5,6,6,7,6,5,5,5,7,6,5,6,7,6,6,7,6,5,6,7,5,6
    .byte 6,7,7,7,7,7,6,7,6,5,6,6,7,7,7,6,7,5,6,6,4,5,6,6
    .byte 6,8,5,7,6,5,7,6,7,6,6,7,5,6,7,7,7,6,6,7,7,4,7,7
    .byte 6,5,7,7,7,6,4,7,7,8,6,5,6,6,4,4,6,7,6,7,7,6,7,7
    .byte 4,6,6,7,6,6,7,7,5,6,6,7,7,6,7,7,7,5,5,6,7,7,7,7
    .byte 7,7,5,6,7,6,6,4,6,5,8,6,6,7,6,6,7,6,7,7,6,7,7,8
    .byte 6,5,7,6,7,5,6,6,6,6,6,7,7,3,6,6,7,6,6,6,5,7,7,5
    .byte 5,6,7,6,7,7,5,5,6,4,6,6,6,7,7,5,6,7,7,6,7,6,7,8
    .byte 6,7,6,6,6,6,7,6,7,6,7,7,7,6,7,6,6,5,7,5,7,7,7,8
    .byte 7,6,8,7,6,7,7,6,7,7,8,6,6,5,7,6,7,4,6,7,7,5,6,7
    .byte 7,7,8,6,5,4,7,6,7,7,7,7,7,6,7,7,7,4,5,5,6,6,6,8
    .byte 6,6,7,7,7,5,7,7,7,6,7,5,7,7,6,6,7,7,6,7,7,6,6,7
    .byte 6,5,6,7,6,7,7,7,7,7,7,5,6,5,6,6,6,7,6,7,6,5,6,6
    .byte 6,6,6,7,6,6,7,7,3,6,7,7,5,5,6,6,7,5,6,7,7,6,7,7
    .byte 5,5,5,6,7,6,6,7,6,6,5,6,5,7,6,7,7,7,6,6,6,5,7,7
    .byte 8,6,7,6,6,6,5,7,6,6,5,5,6,6,6,6,7,7,7,7,7,7,6,6
    .byte 7,6,8,7,6,6,8,6,7,5,6,6,6,5,7,7,7,4,7,6,6,6,6,7
    .byte 4,7,7,6,7,6,7,7,7,6,4,6,6,7,7,6,6,5,7,7,6,7,7,7
    .byte 5,6,8,8,7,7,7,7,7,7,6,7,5,7,7,7,5,8,7,7,7,7,6,6
    .byte 6,7,7,6,5,7,6,7,6,7,7,7,7,6,6,6,6,7,6,7,5,7,7,7
    .byte 7,7,6,5,7,8,7,7,4,7,6,7,6,6,6,7,5,7,7,6,5,6,6,6
    .byte 5,5,5,6,6,6,6,7,6,7,7,6,7,7,6,6,7,7,5,7,7,7,6,7
    .byte 8,7,7,7,6,7,6,6,6,6,6,7,7,6,5,7,6,4,5,8,7,5,7,7
    .byte 6,6,7,5,5,7,7,7,6,7,7,6,5,6,6,6,5,5,5,7,7,6,7,7
    .byte 5,5,6,6,5,5,6,6,6,5,6,5,7,5,7,7,7,8,7,6,6,7,7,7
    .byte 7,7,6,7,8,5,7,7,6,6,7,6,7,6,7,4,7,7,7,7,6,7,6,5
    .byte 7,5,6,7,6,7,6,6,7,6,7,6,4,6,7,6,6,7,7,7,6,6,6,6
    .byte 6,6,7,6,6,7,7,7,6,7,6,5,6,5,6,5,8,6,7,3,6,7,6,7
    .byte 6,7,8,7,6,6,7,7,7,6,7,7,7,7,6,7,7,7,7,7,7,7,7,6
    .byte 7,6,5,5,7,7,6,6,6,6,6,5,7,7,6,7,6,6,7,6,5,7,5,5
    .byte 4,7,8,7,6,6,6,6,5,6,6,6,7,7,6,5,7,7,5,6,6,6,6,6
    .byte 6,7,6,7,6,7,7,7,6,7,7,5,7,7,7,6,6,6,6,6,6,7,7,6
    .byte 5,6,7,5,6,6,5,6,6,7,6,7,5,5,7,7,6,6,7,7,5,6,7,6
    .byte 7,6,8,7,8,6,7,4,7,5,5,6,6,6,7,7,6,6,7,6,6,7,6,5
    .byte 5,7,6,6,4,6,6,7,5,6,5,7,7,6,5,6,6,7,7,7,7,7,7,7
    .byte 7,7,6,7,7,6,7,7,7,7,7,7,7,6,7,6,7,6,7,6,8,8,6,5
    .byte 8,6,6,5,7,7,3,7,8,7,8,7,7,6,8,7,7,6,6,7,5,6,7,7
    .byte 5,7,6,5,7,5,6,7,7,6,4,6,5,7,6,5,6,6,4,6,6,7,6,6
    .byte 5,7,6,7,6,8,6,7,8,6,6,5,7,7,7,7,7,7,6,6,6,6,5,7
    .byte 6,7,7,7,7,7,6,4,6,7,6,7,7,6,6,7,6,6,7,7,7,8,7,7
    .byte 6,7,6,3,6,6,7,7,7,8,7,6,7,4,7,4,6,7,5,6,6,8,6,6
    .byte 8,6,5,6,5,6,5,5,6,7,5,7,7,6,7,7,7,7,5,7,6,6,6,6
    .byte 8,6,7,6,6,6,6,7,5,6,6,6,6,7,6,7,5,4,6,6,6,6,6,7
    .byte 6,6,6,7,8,6,7,7,6,5,7,7,6,5,6,7,7,6,5,7,7,7,7,5
    .byte 6,5,5,4,5,6,5,7,7,5,7,7,4,6,5,7,7,5,6,6,6,7,7,5
    .byte 6,7,6,8,7,7,7,7,7,6,6,7,6,7,7,6,6,7,6,7,7,7,7,7
    .byte 4,7,5,6,5,6,7,6,7,6,8,7,7,7,7,6,6,6,6,6,7,7,3,7
    .byte 7,6,7,7,4,7,6,7,6,7,6,4,5,5,6,7,6,6,5,7,6,7,5,4
    .byte 6,6,7,6,6,6,6,7,7,6,6,6,7,7,7,6,6,8,7,7,7,6,6,7
    .byte 7,5,6,6,7,7,7,6,7,6,6,5,6,6,6,7,6,7,7,5,6,7,7,6
    .byte 5,6,6,7,7,6,6,7,5,7,5,6,6,7,6,6,7,7,6,6,6,6,5,5
    .byte 5,6,8,8,4,7,6,4,6,6,7,6,4,7,7,6,7,6,6,5,6,7,7,7
    .byte 6,7,7,7,7,6,6,7,6,6,6,7,6,7,6,6,6,8,7,5,6,6,6,5
    .byte 6,6,7,7,7,7,7,7,7,6,6,6,6,6,6,6,7,5,5,7,7,7,6,6
    .byte 7,7,6,6,5,6,6,4,5,7,6,6,6,6,6,5,5,6,6,6,7,7,6,6
    .byte 7,6,6,7,7,7,7,6,7,7,6,8,7,7,7,7,7,7,7,7,7,7,7,7
    .byte 7,7,5,6,6,6,5,6,7,7,7,7,6,7,5,8,6,6,4,6,6,7,7,6
    .byte 7,5,7,6,6,7,5,6,7,8,6,4,6,7,5,5,7,7,6,6,7,7,6,7
    .byte 7,6,4,7,7,6,5,5,7,6,6,6,8,6,6,7,7,5,7,7,6,6,6,7
    .byte 6,5,7,6,7,7,7,7,7,6,6,7,5,5,5,7,7,6,5,6,7,6,6,7
    .byte 7,6,6,6,7,7,7,5,7,7,4,8,6,6,4,5,6,6,8,6,5,7,5,7
    .byte 6,6,6,4,6,5,6,7,6,5,7,6,7,6,7,7,6,5,7,6,7,7,7,8
    .byte 6,7,6,7,7,7,7,6,7,7,6,6,7,7,6,8,7,7,5,7,7,6,6,6
    .byte 7,6,7,7,6,6,7,4,7,5,7,7,7,7,6,6,7,6,5,5,7,6,7,6
    .byte 6,7,5,6,5,6,6,7,6,5,5,6,6,5,6,7,7,7,5,6,6,6,7,7
    .byte 6,6,6,7,7,6,6,8,6,6,6,6,6,7,7,6,7,6,6,7,7,7,5,7
    .byte 6,7,8,7,5,6,6,7,5,6,6,7,7,6,8,5,7,7,6,7,6,6,7,8
    .byte 8,6,6,6,7,6,6,6,6,3,6,6,7,7,7,7,5,7,7,6,6,3,6,5
    .byte 7,6,7,5,6,8,7,6,7,5,6,4,7,5,6,6,6,7,7,7,7,7,6,8
    .byte 6,8,6,6,7,6,7,6,4,7,6,7,6,7,7,5,6,5,7,5,7,7,6,6
    .byte 7,7,6,7,7,6,7,7,7,6,6,7,5,7,6,4,6,7,6,7,6,7,6,6
    .byte 7,7,6,4,8,7,5,4,6,6,7,6,4,6,7,7,5,6,6,7,5,7,7,7
    .byte 7,6,7,8,8,6,5,6,6,7,7,7,7,6,6,7,7,7,7,5,7,5,7,7
    .byte 5,7,7,6,6,6,6,6,6,7,7,8,5,6,6,7,7,6,7,6,6,6,7,7
    .byte 7,4,6,6,6,7,6,5,6,7,6,6,5,7,6,6,6,7,4,5,6,7,6,5
    .byte 6,7,7,5,5,6,5,7,7,7,7,7,6,7,7,6,7,6,7,7,7,6,6,6
    .byte 6,7,7,7,6,5,6,6,7,7,6,6,6,7,6,6,5,7,8,6,7,7,6,7
    .byte 7,7,7,6,6,7,6,6,7,7,7,4,7,6,6,6,6,6,4,7,6,6,6,6
    .byte 7,7,6,6,3,6,5,4,6,7,5,7,6,5,7,6,7,5,6,6,7,7,6,6
    .byte 6,8,6,6,7,7,7,7,7,6,7,7,6,6,7,8,6,7,6,6,7,7,6,5
    .byte 6,5,5,6,6,7,5,7,6,6,7,6,7,6,6,7,6,6,6,6,4,5,7,7
    .byte 6,6,6,5,7,6,6,6,7,6,6,7,5,5,4,5,6,6,7,6,7,6,6,7
    .byte 6,6,7,7,7,7,7,7,6,6,7,7,7,7,8,5,7,8,7,7,7,6,7,6
    .byte 6,6,8,6,7,7,7,5,7,6,5,6,7,7,8,6,7,6,7,4,7,6,7,5
    .byte 6,6,7,5,7,7,6,7,7,6,5,4,7,6,7,7,6,8,8,6,7,7,7,4
    .byte 5,7,7,5,6,6,6,7,5,6,6,6,6,7,7,7,6,6,7,6,8,5,7,6
    .byte 7,7,7,7,6,7,6,6,8,6,6,6,5,7,7,6,5,5,6,7,5,6,7,7
    .byte 6,7,7,6,6,7,5,5,7,7,6,6,7,6,6,6,7,6,6,5,6,6,7,6
    .byte 5,7,7,4,6,6,6,5,6,6,7,7,5,6,6,7,4,7,7,6,7,7,6,6
    .byte 7,8,7,7,7,7,7,7,4,7,8,7,6,7,6,7,6,6,4,7,6,6,7,7
    .byte 7,6,6,6,4,7,7,6,7,5,6,7,7,8,6,4,7,7,6,6,7,7,6,5
    .byte 7,6,6,7,6,7,5,7,6,6,7,5,7,5,6,6,6,6,6,7,7,6,6,5
    .byte 6,7,7,7,7,7,5,7,7,7,8,7,7,7,6,6,5,7,6,7,7,7,5,7
    .byte 7,6,7,6,5,6,7,7,6,6,5,7,5,7,6,7,7,7,7,6,5,6,7,7
    .byte 6,7,5,6,7,6,6,7,5,5,7,7,7,7,4,6,5,6,5,5,7,7,4,6
    .byte 7,7,5,5,7,7,7,4,6,7,7,6,7,7,7,7,7,6,7,6,6,7,6,7
    .byte 6,7,6,7,7,7,7,7,6,8,7,6,6,6,5,6,7,7,6,7,5,7,6,6
    .byte 7,7,7,6,5,7,7,7,6,7,5,5,3,7,7,7,6,5,7,6,5,6,6,5
    .byte 6,7,6,4,6,7,6,6,6,5,7,7,5,7,6,7,7,6,5,6,6,7,6,6
    .byte 7,7,7,7,7,7,7,7,6,7,7,7,6,6,7,5,6,6,6,7,6,7,8,7
    .byte 3,7,5,7,6,7,6,6,6,6,7,6,8,7,6,7,6,7,5,5,6,6,3,6
    .byte 7,6,6,6,5,7,5,6,6,7,7,5,6,6,5,6,6,7,6,6,5,6,5,7
    .byte 7,7,5,4,6,6,7,6,7,6,6,6,6,7,7,7,6,6,7,7,7,5,7,6
    .byte 5,6,7,7,7,6,6,6,7,6,5,6,6,7,5,7,5,6,6,7,6,7,8,8
    .byte 7,7,7,6,6,6,6,6,5,4,7,7,7,6,7,6,7,5,6,6,7,7,5,5
    .byte 6,7,6,6,5,5,6,6,5,5,7,7,5,5,6,6,7,7,7,6,6,6,7,6
    .byte 5,7,7,7,7,7,6,6,6,6,6,6,6,6,7,8,6,7,5,6,6,5,7,7
    .byte 6,7,7,7,4,7,7,7,7,6,7,7,6,6,5,6,6,5,7,5,6,6,8,6
    .byte 5,6,6,7,6,7,7,6,4,6,6,7,7,4,6,6,6,7,6,7,6,6,5,6
    .byte 7,6,7,6,7,6,7,6,6,6,7,7,8,6,8,6,7,7,7,6,6,7,7,7
    .byte 7,7,5,6,5,5,6,7,7,6,7,7,5,6,6,7,7,7,5,7,7,6,6,7
    .byte 6,5,6,5,7,7,5,7,6,7,7,3,7,7,6,6,6,6,6,7,7,6,5,7
    .byte 7,7,5,6,6,6,6,5,6,6,5,7,7,7,7,7,8,6,6,7,6,6,6,6
    .byte 6,6,6,6,7,7,7,7,7,5,7,7,4,6,6,7,7,6,6,7,7,6,6,8
    .byte 6,6,7,7,7,7,6,5,8,7,4,7,6,7,3,5,6,7,8,6,6,6,6,6
    .byte 5,6,6,5,5,6,7,7,6,4,7,6,6,7,7,6,6,6,6,7,5,5,7,7
    .byte 6,7,7,5,7,7,7,7,6,7,6,8,7,5,7,6,7,7,6,5,7,5,7,5
    .byte 6,5,6,6,6,7,6,6,7,7,7,6,7,7,7,7,7,5,7,7,6,6,5,7
    .byte 4,6,6,7,6,6,7,6,7,6,6,6,3,7,6,6,5,7,4,7,7,7,6,7
    .byte 6,6,5,7,7,7,7,7,7,5,8,7,7,7,7,6,6,7,7,7,7,7,7,6
    .byte 7,6,6,5,6,6,6,7,7,7,6,6,7,7,6,6,5,7,6,6,6,8,6,7
    .byte 7,7,5,5,5,6,5,6,5,6,6,4,6,6,7,6,7,7,6,6,7,6,6,6
    .byte 6,6,7,6,5,7,7,5,7,5,6,5,7,5,5,7,6,6,8,7,7,6,6,7
    .byte 5,7,7,7,7,7,7,7,4,7,7,7,5,6,7,4,6,6,7,6,7,6,7,6
    .byte 7,7,6,6,6,6,6,7,6,6,6,7,5,7,6,4,5,7,6,6,5,7,6,6
    .byte 7,7,5,5,7,7,6,4,6,7,8,6,7,7,6,6,7,6,6,6,5,7,6,6
    .byte 7,7,7,6,6,7,7,7,7,8,7,5,6,6,6,5,7,6,5,7,6,6,6,7
    .byte 6,6,7,6,7,6,7,6,5,6,6,5,7,7,7,7,8,7,7,4,7,4,5,6
    .byte 6,6,6,6,6,7,7,5,7,6,6,5,5,7,6,7,3,7,7,6,5,6,6,7
    .byte 7,7,6,5,6,6,7,7,7,6,8,7,7,7,6,7,6,7,7,7,7,6,7,7
    .byte 6,6,6,7,7,6,7,6,7,7,6,6,7,6,5,4,7,7,4,7,7,7,7,7
    .byte 8,6,7,7,6,6,6,6,5,5,7,7,6,7,7,6,7,4,7,7,6,6,5,6
    .byte 4,7,5,5,6,7,4,7,7,7,6,7,5,7,6,7,6,8,7,6,7,7,7,6
    .byte 7,7,7,7,6,7,6,7,6,6,5,7,7,6,7,6,7,7,6,5,7,7,6,7
    .byte 6,7,5,7,6,6,6,6,7,7,7,7,7,6,6,2,6,6,7,6,7,7,6,7
    .byte 7,5,7,5,6,7,5,7,5,7,6,6,7,6,6,5,6,7,6,5,6,7,4,7
    .byte 7,7,7,6,6,7,6,7,5,6,7,6,7,7,7,6,7,6,7,6,5,6,6,5
    .byte 6,7,6,7,6,5,6,5,6,6,6,6,6,7,6,7,8,6,7,7,7,5,7,7
    .byte 7,5,6,6,7,6,5,7,7,7,6,5,5,6,5,4,6,6,6,7,6,6,7,6
    .byte 3,6,6,8,6,7,7,7,5,7,7,7,6,6,6,7,7,6,6,6,6,7,7,8
    .byte 6,7,6,7,6,7,6,5,6,5,8,7,6,7,7,6,6,6,6,7,6,7,7,8
    .byte 6,6,6,7,7,6,7,5,6,5,7,6,6,4,6,6,6,6,6,6,6,6,6,6
    .byte 5,6,6,7,6,7,5,4,6,5,5,5,6,6,7,5,6,7,6,7,6,7,6,7
    .byte 6,7,6,7,7,7,5,7,7,7,7,6,7,7,6,5,6,7,8,5,8,7,7,7
    .byte 7,7,4,5,4,6,7,5,8,6,6,7,6,7,5,7,6,7,7,6,5,7,6,4
    .byte 6,7,6,6,6,6,6,7,6,6,7,7,5,7,6,5,4,5,5,6,6,7,6,7
    .byte 6,5,7,6,6,6,7,7,7,7,6,7,7,7,6,7,7,7,5,7,7,6,6,7
    .byte 6,7,6,6,6,7,6,6,7,6,6,7,6,6,6,7,7,7,7,7,6,7,5,6
    .byte 5,7,5,5,7,8,4,6,7,7,7,7,6,4,5,6,6,6,6,7,8,8,5,7
    .byte 6,7,4,6,7,6,6,6,7,6,5,7,6,7,7,7,6,7,7,7,7,6,7,7
    .byte 8,7,7,5,7,5,6,6,7,7,6,5,7,6,7,7,6,7,7,6,6,6,6,6
    .byte 8,7,7,8,7,7,7,7,7,6,5,7,7,6,7,7,8,3,7,7,7,6,6,6
    .byte 4,8,7,5,7,5,7,7,7,6,4,6,6,6,7,6,7,6,7,7,8,6,7,6
    .byte 5,5,5,7,6,7,6,6,6,5,7,6,6,7,6,6,6,7,6,7,7,7,6,7
    .byte 8,7,7,6,7,6,6,6,7,6,7,7,7,5,7,4,6,4,5,7,7,6,5,5
    .byte 6,6,6,7,5,7,6,6,7,6,7,5,5,7,6,7,6,5,7,6,6,5,6,7
    .byte 7,7,6,8,6,7,7,6,6,4,6,5,7,7,6,7,6,7,6,6,7,6,7,7
    .byte 7,7,7,7,6,7,7,6,7,7,7,7,6,7,7,7,7,6,6,7,7,6,5,6
    .byte 4,6,4,6,6,7,6,4,6,7,6,6,6,6,6,7,5,7,7,7,5,5,7,7
    .byte 6,7,5,6,6,6,6,6,7,7,7,7,7,7,7,6,7,7,5,6,5,7,7,7
    .byte 6,7,7,5,6,7,7,6,7,6,7,7,7,6,7,7,6,7,7,7,7,6,6,7
    .byte 7,6,7,7,7,7,7,4,7,3,5,5,5,6,8,6,4,6,7,7,6,7,6,6
    .byte 6,6,6,7,8,4,5,7,6,6,7,4,7,7,6,6,6,7,7,6,7,7,7,8
    .byte 7,7,6,5,6,4,7,6,7,7,7,7,5,7,7,7,7,7,7,7,6,7,6,7
    .byte 7,5,8,8,6,7,5,6,6,7,7,6,7,6,7,7,5,6,4,6,5,6,6,7
    .byte 5,5,5,7,6,7,7,6,6,6,6,6,6,7,5,4,7,6,6,7,5,7,7,6
    .byte 6,7,7,8,6,7,7,6,8,7,7,6,6,6,6,6,6,6,7,7,5,6,6,6
    .byte 6,7,6,6,6,7,7,7,8,6,7,7,7,6,6,7,7,6,7,8,6,2,7,6
    .byte 6,7,5,6,7,7,6,6,6,7,6,6,6,7,6,4,6,7,6,5,5,7,6,6
    .byte 7,6,7,6,6,7,7,5,5,6,7,7,7,7,7,7,7,6,6,6,6,7,6,6
    .byte 6,7,6,6,6,7,7,6,6,6,6,6,5,7,6,7,6,6,6,7,7,6,7,4
    .byte 8,7,7,7,7,7,6,5,6,7,5,6,7,6,6,6,4,7,7,6,5,5,6,6
    .byte 6,6,6,6,6,7,7,7,6,6,6,6,3,7,5,6,6,7,6,8,6,7,6,7
    .byte 7,6,7,6,5,6,6,6,7,6,6,7,7,6,7,7,7,7,5,6,7,6,6,7
    .byte 7,7,7,7,7,6,6,7,6,7,7,7,7,8,7,6,5,6,6,6,7,7,4,7
    .byte 6,6,5,6,5,7,6,4,7,6,7,6,7,7,4,7,7,6,7,7,5,5,7,7
    .byte 7,6,5,6,7,8,8,6,6,6,6,7,6,5,5,7,6,7,6,7,4,5,7,7
    .byte 6,5,8,6,7,6,7,6,7,7,7,7,7,7,7,6,7,5,7,7,7,7,6,7
    .byte 5,4,6,7,5,6,7,5,5,6,5,6,6,4,7,7,6,6,6,7,5,6,5,6
    .byte 7,7,6,6,7,6,5,5,7,6,6,6,6,6,7,7,6,7,7,6,8,6,6,5
    .byte 5,7,7,7,6,6,7,8,5,7,6,6,6,6,6,7,7,7,7,6,7,6,6,6
    .byte 7,6,7,7,6,5,7,7,5,3,7,6,6,6,6,5,7,6,6,6,6,7,6,7
    .byte 7,7,5,5,7,7,6,6,5,6,7,6,7,5,8,7,6,7,7,5,4,5,7,7
    .byte 7,7,6,6,7,8,7,6,6,6,6,6,7,5,7,6,6,7,6,7,7,5,5,7
    .byte 5,6,7,6,7,7,6,6,7,7,6,7,7,6,7,6,7,7,6,6,6,5,6,6
    .byte 7,4,7,6,6,4,7,6,8,6,5,8,7,7,7,7,7,4,7,7,7,7,8,6
    .byte 6,7,7,6,6,4,6,6,7,7,5,7,7,7,7,5,6,6,7,5,7,6,7,5
    .byte 4,7,8,6,6,7,7,7,6,7,6,6,7,7,7,7,7,6,7,6,6,6,7,7
    .byte 7,6,6,6,4,7,6,4,7,7,6,5,6,4,6,6,5,7,7,5,7,7,8,5
    .byte 6,5,6,8,7,7,7,8,5,5,6,7,6,6,6,6,6,7,7,7,6,7,6,7
    .byte 7,7,5,7,6,6,6,7,6,5,7,6,6,7,6,6,7,6,6,7,6,7,7,7
    .byte 5,6,8,7,7,5,7,7,7,7,7,6,7,5,6,7,6,5,6,6,6,5,4,6
    .byte 7,6,6,6,7,6,7,5,6,6,6,6,6,6,7,7,7,6,4,7,5,5,6,6
    .byte 6,6,7,8,7,7,7,5,7,6,7,6,6,6,7,7,6,5,8,7,6,7,7,6
    .byte 6,6,6,7,6,7,6,6,8,6,7,7,8,7,7,7,7,6,6,8,6,3,7,5
    .byte 5,7,6,6,6,6,6,6,5,7,5,7,6,7,5,5,7,7,5,5,4,7,6,7
    .byte 7,6,7,6,5,7,6,5,5,7,7,7,7,7,7,7,7,6,7,6,6,7,6,6
    .byte 5,7,6,6,6,7,7,7,7,5,6,5,6,7,6,6,7,6,6,6,7,7,7,5
    .byte 7,7,7,7,6,7,7,4,6,7,6,6,6,6,6,5,4,6,6,6,5,6,7,6
    .byte 7,6,6,5,5,6,7,6,7,7,6,6,4,6,4,6,5,6,6,6,7,7,5,6
    .byte 6,7,6,6,6,6,7,5,7,6,7,5,5,7,7,7,6,8,7,7,6,6,7,7
    .byte 7,6,7,7,7,7,6,7,6,6,6,7,6,6,7,6,4,6,7,5,6,7,6,5
    .byte 6,4,7,7,5,7,6,5,6,7,7,6,5,5,5,7,7,7,6,7,6,4,6,6
    .byte 7,6,6,6,8,7,7,7,7,7,6,7,7,6,5,6,6,7,6,6,6,7,6,7
    .byte 6,7,7,5,6,7,6,7,7,6,7,7,7,7,7,7,7,7,7,7,8,7,7,7
    .byte 5,6,6,6,7,7,8,3,7,6,5,5,6,6,7,7,5,8,7,7,7,6,6,3
    .byte 7,7,7,7,8,6,5,7,6,7,6,5,5,6,6,7,7,7,8,6,7,7,7,5
    .byte 6,6,6,7,5,6,8,7,6,7,7,6,5,7,7,7,6,7,7,7,7,5,6,7
    .byte 8,7,6,6,7,6,7,7,6,3,6,6,6,7,6,6,7,7,5,5,6,7,6,6
    .byte 7,7,6,5,6,6,6,6,5,7,6,7,7,6,7,6,6,7,6,4,5,5,7,7
    .byte 7,6,7,6,7,7,6,6,6,7,6,6,5,7,5,5,7,7,6,6,8,7,6,5
    .byte 7,7,6,6,7,8,7,7,7,6,7,6,7,7,6,6,5,7,6,3,6,7,5,7
    .byte 7,6,4,5,5,6,6,5,6,7,6,6,7,7,6,6,4,6,7,8,6,7,7,6
    .byte 5,6,6,6,5,6,6,7,6,7,7,7,7,6,7,6,6,6,6,5,6,6,6,7
    .byte 7,5,7,7,7,7,4,6,7,6,6,7,7,7,8,7,7,7,7,7,6,6,7,7
    .byte 7,7,7,6,6,5,6,7,7,8,4,6,5,6,5,7,5,7,7,5,7,6,6,7
    .byte 6,6,4,7,7,6,6,7,6,5,7,7,6,5,5,6,7,7,8,7,7,6,7,7
    .byte 7,6,6,7,7,5,6,6,7,6,7,7,6,7,7,5,6,5,6,6,5,7,6,7
    .byte 6,7,7,7,7,5,7,6,6,7,7,7,7,5,7,6,6,6,6,7,6,6,3,7
    .byte 7,7,6,5,6,7,7,6,5,6,6,6,7,7,7,7,7,5,4,7,5,6,6,6
    .byte 5,5,5,7,6,7,6,6,8,4,6,6,6,6,6,6,7,6,5,7,7,5,7,7
    .byte 7,6,6,6,6,7,7,6,7,7,7,7,6,6,7,7,6,3,6,6,7,7,6,7
    .byte 6,7,6,5,7,7,6,7,6,7,6,6,6,6,6,8,6,6,5,5,6,6,6,5
    .byte 7,5,6,6,8,6,6,7,7,6,5,5,7,5,7,7,7,7,5,7,7,6,5,7
    .byte 6,6,7,6,6,7,7,7,7,5,7,6,7,6,5,6,6,6,8,6,7,7,4,6
    .byte 4,5,6,7,6,6,6,7,7,7,6,7,6,7,6,6,6,7,8,6,6,6,7,5
    .byte 6,7,6,6,6,6,5,7,5,6,6,5,6,7,7,7,6,6,2,6,6,7,6,7
    .byte 7,6,7,7,7,4,6,7,5,8,7,6,7,6,6,8,6,7,5,7,7,7,7,5
    .byte 6,7,6,7,6,7,5,7,7,6,6,5,6,8,7,7,6,7,6,7,7,6,7,6
    .byte 7,5,6,7,5,7,6,7,7,6,5,7,7,6,7,6,6,5,6,6,6,7,6,7
    .byte 6,7,6,5,3,6,6,7,7,6,7,7,5,7,6,5,6,6,6,7,6,5,7,6
    .byte 7,8,7,6,6,7,6,7,7,7,6,7,7,6,6,6,6,6,3,6,6,7,5,7
    .byte 7,8,7,6,6,6,5,6,7,6,6,6,6,6,7,7,7,6,7,6,6,6,7,6
    .byte 7,6,4,5,7,6,7,6,6,6,7,6,6,6,5,6,5,7,7,7,6,7,7,7
    .byte 6,6,4,7,5,6,6,6,6,6,7,8,6,6,6,6,6,6,7,7,7,8,7,7
    .byte 7,6,3,5,7,7,7,5,6,6,8,6,6,7,7,6,6,7,6,5,7,5,7,7
    .byte 7,5,8,4,7,7,6,6,6,7,6,6,6,6,6,5,7,6,8,5,6,7,7,5
    .byte 5,7,7,8,5,6,5,7,7,6,7,6,4,6,6,5,6,7,7,7,7,7,4,7
    .byte 7,6,5,7,7,6,6,7,7,6,4,6,6,6,5,7,6,7,8,5,7,7,7,7
    .byte 5,7,6,6,7,6,6,7,7,7,7,7,6,7,6,7,4,6,6,7,6,6,6,6
    .byte 6,5,7,7,7,6,5,6,6,6,7,6,4,7,7,8,6,6,7,5,6,6,7,5
    .byte 7,6,6,7,7,6,6,7,6,6,6,6,7,7,7,7,7,7,5,6,7,6,6,4
    .byte 6,7,7,6,7,6,7,6,7,7,6,6,5,6,7,7,6,6,7,7,6,7,5,7
    .byte 6,6,4,6,5,7,7,5,6,6,7,5,5,7,8,3,6,6,7,7,7,7,6,5
    .byte 6,7,6,5,7,7,7,6,5,6,7,7,7,6,7,5,6,6,7,6,4,8,8,7
    .byte 7,6,7,6,6,6,7,3,6,6,6,7,7,6,7,7,7,8,6,7,6,7,5,5
    .byte 7,7,6,6,7,7,7,8,6,7,6,5,6,8,6,5,7,6,7,6,7,7,6,7
    .byte 6,6,7,6,5,6,7,5,7,7,7,7,6,5,7,6,6,5,6,6,7,7,6,7
    .byte 5,7,6,6,6,7,6,6,6,7,6,6,6,6,4,6,5,6,7,7,6,4,7,7
    .byte 7,6,7,6,8,7,6,6,7,6,6,7,7,7,7,4,7,7,6,6,6,5,6,6
    .byte 6,5,5,6,7,7,7,7,6,6,5,7,6,6,5,6,7,6,6,7,7,6,7,7
    .byte 5,7,4,7,6,5,7,7,7,5,6,7,6,5,7,7,6,7,7,5,7,6,5,4
    .byte 5,6,7,7,5,7,6,7,6,7,7,7,7,7,8,7,6,7,4,6,6,8,7,6
    .byte 7,7,5,7,5,5,5,6,6,4,6,7,7,6,6,7,7,7,4,7,7,7,4,7
    .byte 7,8,6,8,7,5,7,6,6,6,5,5,7,4,6,7,7,7,7,7,6,6,6,6
    .byte 7,7,6,7,7,6,3,7,6,6,6,6,6,6,6,5,7,7,7,6,7,7,7,7
    .byte 7,5,7,7,6,5,7,6,8,7,6,7,7,5,7,7,6,6,5,7,5,6,6,6
    .byte 7,6,6,5,6,7,6,6,6,6,6,7,5,7,7,6,7,7,6,6,4,6,7,6
    .byte 6,7,6,6,6,7,7,6,5,7,7,6,6,6,7,7,4,6,7,7,5,4,7,7
    .byte 6,6,7,7,7,7,6,7,7,7,7,7,6,6,6,6,7,7,7,7,7,7,7,4
    .byte 6,5,7,6,5,6,5,7,7,6,7,7,6,4,7,6,6,7,7,6,5,6,5,5
    .byte 6,6,7,8,6,6,6,5,7,6,6,7,6,7,7,7,6,6,7,7,7,6,7,7
    .byte 6,7,6,7,6,7,6,6,2,6,7,6,7,7,7,6,7,7,6,7,6,6,6,7
    .byte 7,7,6,5,7,6,7,6,6,5,7,8,5,7,6,7,6,6,7,6,6,6,6,6
    .byte 6,6,6,7,3,8,6,7,6,5,7,5,6,6,7,5,7,7,6,7,6,7,7,7
    .byte 7,6,6,6,7,7,6,7,7,7,6,6,6,6,6,5,4,4,6,6,6,6,7,7
    .byte 5,7,7,6,6,6,7,7,7,6,7,7,6,7,5,6,6,7,7,6,7,6,7,6
    .byte 6,7,7,6,5,7,6,6,7,7,6,6,7,6,5,5,6,6,4,6,6,7,7,7
    .byte 6,6,6,6,5,7,6,6,8,6,5,7,6,8,7,6,7,5,6,6,6,7,4,8
    .byte 5,6,4,6,6,7,7,7,6,7,7,7,6,8,5,7,7,7,6,7,7,6,7,6
    .byte 7,8,4,7,6,7,7,5,5,6,6,7,7,6,6,6,6,7,6,5,7,6,5,7
    .byte 5,7,6,7,6,6,7,6,6,4,7,8,6,6,5,7,7,7,7,7,6,7,7,7
    .byte 7,6,6,6,7,7,7,6,7,6,5,4,5,6,7,7,6,8,7,6,6,6,5,6
    .byte 6,6,7,6,7,7,6,6,5,6,5,6,7,7,6,5,6,7,6,6,7,5,7,6
    .byte 6,6,6,6,6,6,8,3,6,7,6,7,6,7,5,6,5,6,7,7,6,6,6,7
    .byte 5,6,7,6,5,7,7,7,7,7,6,7,6,4,6,6,7,5,7,7,5,6,7,7
    .byte 7,7,7,5,6,7,7,7,6,6,5,7,6,7,6,5,7,7,7,5,4,5,7,8
    .byte 6,6,7,6,6,7,6,6,5,5,7,5,7,6,7,6,5,5,6,7,7,5,7,7
    .byte 5,7,5,7,7,8,8,6,8,3,7,7,7,7,6,7,6,7,7,5,7,6,6,6
    .byte 6,5,6,7,4,6,6,7,7,7,7,7,6,5,6,7,6,7,6,7,7,6,6,6
    .byte 6,7,7,7,6,3,7,7,6,6,7,6,7,7,7,6,6,5,7,6,4,6,7,7
    .byte 6,6,6,6,7,7,6,7,5,5,6,7,7,7,7,7,7,8,6,4,6,6,8,6
    .byte 7,7,7,6,7,6,6,6,5,5,6,7,7,3,7,7,6,7,6,6,8,6,6,6
    .byte 7,7,7,6,7,6,7,7,6,6,7,6,5,7,7,6,6,5,7,7,7,7,6,5
    .byte 7,4,6,5,7,7,6,6,7,4,6,6,7,7,6,7,5,6,7,7,5,7,6,8
    .byte 7,7,7,7,7,6,7,7,6,7,5,7,7,7,7,3,6,7,6,6,6,6,6,6
    .byte 7,7,6,6,7,8,6,6,6,6,7,6,7,7,7,7,6,7,6,7,7,5,5,5
    .byte 8,6,7,7,7,6,6,7,6,5,6,6,6,6,7,5,7,7,5,7,6,6,7,6
    .byte 6,4,6,6,7,6,6,6,7,6,7,7,6,6,6,6,6,5,7,7,7,7,7,7
    .byte 6,7,7,6,7,5,6,7,7,5,7,7,7,4,7,6,6,6,6,7,6,7,6,4
    .byte 7,5,6,6,7,7,4,7,7,6,7,6,7,7,7,7,5,7,7,6,7,6,6,7
    .byte 7,7,7,6,6,7,7,5,6,6,6,5,5,7,7,6,7,7,5,6,7,5,6,6
    .byte 5,6,5,7,4,7,6,6,7,7,7,6,6,5,6,7,7,7,7,6,7,6,6,6
    .byte 6,6,7,7,4,7,6,6,4,6,6,7,8,6,7,7,7,6,6,7,6,6,7,7
    .byte 5,6,6,6,6,6,4,7,6,7,8,5,7,4,7,7,7,6,5,6,5,8,7,6
    .byte 7,7,7,6,7,6,4,7,7,7,5,5,6,7,7,5,7,7,6,7,6,6,7,6
    .byte 6,7,8,6,6,6,5,7,7,6,7,5,7,5,7,7,3,6,6,6,6,7,7,7
    .byte 6,6,6,7,7,6,6,7,7,6,6,6,7,7,6,7,5,6,6,7,7,6,7,5
    .byte 5,7,6,5,4,7,6,6,7,7,7,7,6,7,7,6,5,6,4,7,6,7,5,7
    .byte 7,7,6,7,7,7,5,6,6,8,6,7,7,6,6,7,5,5,4,6,6,6,6,7
    .byte 6,4,5,6,7,5,7,8,7,7,7,5,7,7,5,7,7,7,5,7,6,7,7,6
    .byte 6,7,7,6,7,6,6,5,7,6,7,5,7,5,7,7,7,5,6,6,6,6,7,7
    .byte 6,7,6,7,5,7,5,6,7,7,6,7,7,6,7,8,7,7,7,6,5,3,7,5
    .byte 7,5,6,7,7,6,6,6,5,6,6,5,7,7,6,5,7,6,6,7,7,7,6,6
    .byte 7,6,6,6,6,7,7,7,6,4,8,7,7,7,5,5,4,7,6,6,6,6,7,7
    .byte 8,6,4,7,7,7,4,7,8,6,7,7,7,5,7,7,7,6,6,7,7,7,6,7
    .byte 7,6,7,6,6,6,6,4,4,7,6,7,7,6,7,7,6,5,5,5,5,7,7,6
    .byte 7,7,5,7,6,7,6,7,6,6,7,7,7,7,7,6,7,7,7,7,6,7,7,7
    .byte 6,5,6,7,4,6,7,7,6,6,7,6,7,7,5,7,7,6,6,7,6,6,7,6
    .byte 5,4,6,7,7,8,6,7,6,7,7,6,7,6,5,6,5,6,6,7,6,5,7,7
    .byte 7,4,7,6,6,5,5,6,8,8,7,7,7,7,7,6,7,6,6,7,6,5,6,7
    .byte 7,7,8,6,6,7,7,6,5,5,7,5,5,6,7,6,6,7,6,7,6,7,7,5
    .byte 7,6,8,7,6,7,6,6,6,6,6,7,7,7,6,7,7,7,7,6,7,7,7,6
    .byte 5,5,6,7,6,6,6,6,5,5,7,5,5,5,7,6,6,7,6,7,6,8,7,5
    .byte 5,6,5,6,6,7,6,7,7,7,8,6,4,7,7,8,7,6,8,5,7,8,7,5
    .byte 6,8,7,6,5,5,8,6,7,6,7,7,6,7,8,7,5,5,7,7,8,6,6,8
    .byte 7,7,6,8,6,6,7,7,7,5,6,6,5,7,7,7,7,6,7,5,5,5,6,6
    .byte 7,6,7,6,8,6,7,6,7,7,7,7,7,8,7,5,7,7,8,6,6,6,6,6
    .byte 5,7,7,5,6,5,6,5,6,7,6,6,6,7,6,7,7,7,7,7,7,6,6,7
    .byte 7,7,5,6,7,7,7,6,7,4,7,7,6,7,6,7,6,7,6,4,6,6,6,6
    .byte 7,6,5,6,5,5,6,5,4,7,6,6,6,7,6,6,5,7,6,7,7,6,6,7
    .byte 6,6,6,7,6,6,7,7,6,7,6,6,6,6,6,6,6,6,7,5,7,7,7,6
    .byte 6,7,6,7,7,7,5,7,7,6,6,6,6,6,8,7,6,7,7,7,6,6,7,7
    .byte 6,7,6,4,6,6,7,5,7,7,6,5,6,6,6,6,4,6,7,7,6,6,7,7
    .byte 6,7,5,7,6,6,6,6,8,5,7,7,7,6,7,6,6,6,7,7,7,6,6,5
    .byte 5,5,6,6,7,6,6,6,7,5,7,7,7,7,7,7,6,6,6,5,5,6,7,6
    .byte 6,6,7,7,6,6,7,6,6,6,7,7,6,4,5,6,6,6,6,7,5,7,5,7
    .byte 6,6,4,4,7,7,7,7,6,7,5,6,7,7,6,6,7,7,6,6,6,6,6,7
    .byte 6,6,6,6,7,5,6,6,7,6,5,5,6,7,5,7,7,6,7,7,7,6,6,6
    .byte 6,6,7,7,6,5,7,7,7,6,5,7,6,7,6,6,6,6,7,6,5,5,6,6
    .byte 7,7,6,5,7,7,5,5,6,6,6,6,7,7,5,6,7,5,7,6,6,7,7,7
    .byte 5,6,7,7,7,7,7,6,6,3,7,7,6,7,6,7,5,7,7,6,6,4,7,6
    .byte 8,6,7,8,6,7,6,6,7,6,6,7,7,6,7,7,7,6,5,6,6,6,7,8
    .byte 7,7,6,6,7,7,6,6,6,6,7,7,6,6,6,7,7,5,6,6,7,7,6,8
    .byte 6,8,7,6,6,5,7,7,7,7,6,8,7,7,8,7,6,6,6,7,6,5,5,7
    .byte 5,6,7,5,7,6,7,5,5,7,7,6,5,8,7,5,7,7,6,5,6,6,5,7
    .byte 6,5,7,6,4,7,7,6,7,7,7,6,6,7,6,6,5,6,8,6,7,5,7,4
    .byte 4,5,5,7,5,7,7,7,5,7,7,6,6,6,6,7,6,7,6,7,7,6,7,7
    .byte 7,7,7,6,7,7,6,6,6,7,7,6,4,7,6,6,5,7,7,7,7,6,6,7
    .byte 6,7,6,5,6,7,6,6,7,6,6,7,7,6,6,6,7,8,7,7,5,7,7,6
    .byte 5,6,7,6,5,8,6,7,3,6,5,5,6,5,6,6,5,7,7,7,6,6,6,7
    .byte 7,7,7,6,7,5,6,7,7,7,6,7,6,6,7,6,6,6,6,5,7,6,7,6
    .byte 7,7,7,5,6,3,7,7,7,7,5,7,5,6,7,6,4,7,7,6,7,7,6,7
    .byte 6,7,6,7,7,6,7,6,6,5,7,6,6,6,7,5,6,5,6,7,6,6,5,7
    .byte 6,7,4,6,8,6,6,6,6,7,7,7,6,7,6,5,6,7,7,6,7,5,7,7
    .byte 6,6,6,5,7,6,6,7,6,7,6,7,5,6,4,7,6,7,7,6,7,6,5,5
    .byte 7,6,6,6,6,7,6,6,5,5,7,6,7,7,8,6,6,7,6,5,6,7,4,7
    .byte 7,5,6,5,6,6,7,5,6,6,6,5,7,7,7,6,6,6,6,6,6,7,7,7
    .byte 5,7,6,7,6,6,6,7,6,5,6,6,6,6,7,7,6,6,6,7,7,6,6,4
    .byte 7,6,7,7,6,7,5,7,7,7,6,6,6,6,7,7,6,7,5,7,6,7,7,7
    .byte 7,5,7,6,7,5,6,7,6,6,4,6,7,7,5,6,6,7,7,6,6,7,7,7
    .byte 6,7,4,8,7,7,8,7,7,6,7,7,7,6,5,6,7,6,6,6,4,7,6,6
    .byte 7,5,8,8,6,7,7,6,4,6,7,6,6,6,8,6,7,6,5,7,7,7,6,8
    .byte 6,6,5,5,6,6,8,7,7,5,7,7,6,6,7,7,6,6,5,6,6,6,6,6
    .byte 7,4,6,6,4,6,7,8,7,5,6,5,8,5,7,7,7,7,6,7,6,6,6,7
    .byte 4,6,6,6,5,7,6,6,6,7,7,8,7,6,5,7,6,7,7,7,7,7,6,7
    .byte 6,7,4,4,7,6,6,6,5,7,7,6,6,7,5,7,5,7,7,6,6,7,7,7
    .byte 7,6,6,7,7,7,6,6,6,3,7,7,7,6,6,6,6,8,6,5,7,7,7,7
    .byte 6,7,7,6,6,5,8,6,6,6,5,7,5,6,6,3,8,6,6,6,7,7,6,5
    .byte 6,6,6,7,7,6,6,7,7,6,6,6,6,6,5,7,5,8,7,6,6,6,6,7
    .byte 5,7,4,5,6,7,6,6,7,7,5,7,7,7,6,6,5,7,7,7,5,6,7,7
    .byte 7,7,7,7,6,5,7,7,7,7,6,7,4,6,6,5,6,7,7,7,6,7,7,5
    .byte 6,4,6,7,7,7,5,7,6,6,6,7,6,7,8,7,7,6,7,5,7,6,5,6
    .byte 6,8,7,6,7,7,7,6,6,5,5,5,7,7,7,7,7,6,7,6,7,7,6,6
    .byte 6,6,6,6,6,6,7,7,7,7,6,8,6,6,6,5,7,7,7,7,6,6,3,7
    .byte 7,7,6,3,7,7,5,5,7,6,5,5,8,8,6,5,7,7,7,7,6,7,8,7
    .byte 6,7,7,5,5,7,6,5,6,7,6,7,6,6,6,7,7,7,7,3,6,6,7,7
    .byte 6,6,7,6,7,7,7,7,6,6,6,5,7,6,4,7,7,5,7,7,7,6,6,5
    .byte 7,7,6,6,7,7,6,6,6,7,6,7,4,6,6,7,6,6,7,7,6,6,7,7
    .byte 7,6,6,6,7,5,5,6,7,6,6,7,6,7,6,7,6,7,7,4,7,5,6,5
    .byte 4,7,7,7,7,5,7,7,6,7,7,6,6,7,7,6,7,7,6,7,6,6,7,7
    .byte 6,5,5,6,6,5,7,7,6,7,7,7,6,7,6,5,6,6,6,7,7,2,7,7
    .byte 6,6,6,7,7,6,7,6,4,6,5,7,6,6,7,6,6,7,7,7,6,7,7,7
    .byte 8,6,6,6,6,7,7,4,6,6,7,6,7,6,6,7,7,7,7,6,7,7,6,5
    .byte 7,7,7,7,7,6,8,7,6,6,6,6,6,7,5,8,8,7,7,6,5,7,6,7
    .byte 5,6,6,6,7,6,6,6,4,7,4,6,7,5,5,5,7,7,7,6,7,7,7,7
    .byte 7,5,7,7,5,6,6,7,6,6,7,7,6,7,6,6,6,6,5,4,6,6,7,7
    .byte 7,7,6,6,8,8,7,4,6,7,7,6,7,6,8,7,6,7,6,7,4,6,6,7
    .byte 6,7,7,5,6,7,5,6,6,7,6,7,6,6,8,6,4,6,6,6,6,6,7,6
    .byte 7,6,5,7,7,6,6,7,7,5,6,6,6,7,7,7,7,7,7,6,6,5,6,6
    .byte 7,5,7,5,6,6,5,6,7,7,6,7,7,6,7,6,7,5,7,7,7,6,6,6
    .byte 7,7,5,5,6,6,6,6,6,7,7,6,7,7,6,6,6,7,5,5,7,7,6,5
    .byte 6,7,5,5,7,6,5,3,6,6,6,6,7,7,5,7,7,7,6,7,6,7,7,7
    .byte 6,6,7,6,4,7,7,7,6,7,7,7,6,7,5,5,7,6,6,6,6,6,6,7
    .byte 6,6,7,6,6,8,7,7,6,5,5,6,7,6,6,7,7,6,6,7,6,7,6,7
    .byte 6,7,4,5,6,7,6,6,7,6,6,7,7,5,7,6,6,4,6,5,6,6,7,7
    .byte 7,6,7,7,6,6,6,7,7,6,7,6,6,7,6,6,7,5,7,8,7,6,6,7
    .byte 7,6,7,7,6,4,7,7,5,7,8,7,7,7,7,6,7,7,4,6,6,5,7,7
    .byte 6,6,7,7,6,6,7,7,7,6,7,6,7,6,5,7,5,6,6,7,6,7,6,6
    .byte 6,7,4,6,6,4,6,6,8,6,8,7,7,6,6,7,6,6,5,7,8,4,6,6
    .byte 6,6,7,5,8,7,4,7,6,7,6,6,6,5,5,6,6,6,7,7,7,8,7,7
    .byte 6,6,5,6,5,6,7,5,7,6,7,8,6,7,6,7,8,7,7,5,7,6,6,7
    .byte 6,5,6,5,6,7,6,5,5,5,4,6,6,6,6,7,7,6,7,7,6,5,7,7
    .byte 7,7,6,6,6,7,6,5,6,7,6,6,6,6,6,7,6,5,5,6,7,6,6,6
    .byte 5,6,6,7,7,7,7,7,7,6,5,6,7,6,5,6,7,6,6,7,6,7,7,4
    .byte 7,8,7,7,6,6,6,6,5,5,6,7,5,6,6,6,4,5,6,7,7,6,7,7
    .byte 5,7,5,6,6,6,7,6,7,7,7,7,6,7,7,7,5,7,6,7,7,7,3,6
    .byte 7,7,4,6,6,7,5,6,6,6,7,6,7,6,7,6,7,7,7,6,5,5,6,6
    .byte 7,7,6,7,7,6,8,7,5,7,5,6,4,6,6,7,6,7,6,7,5,7,5,6
    .byte 6,4,6,7,5,5,6,7,6,7,6,7,6,7,6,6,5,7,7,6,6,6,7,6
    .byte 6,7,6,6,6,6,5,7,5,5,5,6,6,6,7,6,5,6,6,7,7,7,6,6
    .byte 7,7,5,5,7,7,7,6,7,6,7,6,6,6,7,8,7,7,5,6,6,5,6,4
    .byte 7,7,7,6,7,7,3,7,7,6,5,6,7,7,5,7,7,6,7,7,6,6,6,6
    .byte 7,5,6,5,7,6,7,7,7,7,6,7,7,7,7,7,5,5,5,7,6,7,6,7
    .byte 5,7,6,6,7,7,8,7,7,7,6,7,6,6,5,6,7,5,7,6,7,7,7,7
    .byte 8,7,7,7,7,7,5,7,6,6,7,7,6,6,7,4,7,7,7,5,6,7,7,6
    .byte 5,8,8,8,7,6,7,6,4,5,6,7,6,7,6,7,7,7,5,7,7,7,6,6
    .byte 6,5,5,5,6,7,7,6,6,6,6,6,5,6,7,7,6,7,5,7,6,7,7,5
    .byte 4,6,6,7,7,6,7,6,6,8,7,6,6,6,7,4,5,6,6,7,7,6,7,7
    .byte 4,7,7,7,6,6,7,5,5,8,7,7,5,6,6,7,6,6,7,7,7,8,7,7
    .byte 4,7,7,6,5,6,6,6,7,8,4,6,7,7,6,7,5,6,6,6,6,6,5,7
    .byte 7,7,7,6,7,6,6,6,7,6,6,6,8,6,4,7,7,7,7,6,5,6,7,6
    .byte 6,7,5,7,6,7,6,6,5,6,6,6,6,6,6,6,3,6,7,6,7,5,7,6
    .byte 7,5,7,7,7,6,7,7,7,6,6,6,4,6,6,6,8,7,6,8,6,7,4,7
    .byte 6,7,6,7,5,5,7,7,6,7,6,7,7,7,6,5,7,7,4,6,6,5,8,7
    .byte 7,7,8,7,5,6,6,6,7,7,7,6,7,5,6,6,7,5,6,6,6,5,7,7
    .byte 3,6,6,7,7,7,7,5,6,6,6,6,7,7,6,6,7,7,6,6,6,7,6,5
    .byte 6,6,7,8,5,7,5,7,6,5,7,6,6,4,6,7,7,6,7,7,8,7,5,7
    .byte 7,7,6,5,7,5,8,6,6,6,7,7,7,6,6,8,6,7,7,7,6,4,7,7
    .byte 6,4,6,5,7,6,7,5,7,7,7,5,7,7,7,6,6,7,5,7,7,7,7,7
    .byte 7,7,7,7,5,6,5,7,7,7,7,6,5,6,7,6,7,6,7,6,6,6,5,6
    .byte 6,6,7,7,6,7,6,6,6,6,6,6,5,6,6,6,5,7,6,7,7,6,7,6
    .byte 7,7,6,6,6,7,7,6,6,7,5,7,6,6,7,7,5,7,5,6,5,7,5,6
    .byte 6,6,7,7,7,7,7,7,7,5,6,7,5,7,7,6,6,5,7,6,6,6,6,7
    .byte 6,7,6,7,5,5,7,6,5,7,6,7,6,6,6,6,8,6,7,6,7,4,7,6
    .byte 6,7,5,7,6,6,6,7,6,6,8,7,6,7,7,5,4,6,6,6,6,5,6,7
    .byte 5,6,7,5,6,3,6,7,6,6,6,7,6,7,7,7,7,8,5,6,6,6,7,7
    .byte 5,6,7,7,6,6,6,6,6,6,6,7,7,4,6,7,6,7,7,6,6,6,6,7
    .byte 6,7,6,7,7,8,6,6,6,6,7,7,5,7,6,7,7,5,7,6,6,6,6,6
    .byte 3,6,6,7,7,6,6,7,6,7,7,4,6,2,6,7,5,7,7,8,6,6,7,7
    .byte 6,8,7,7,6,5,6,7,7,6,6,6,5,6,7,5,7,6,7,6,6,6,6,5
    .byte 7,6,7,6,7,7,6,7,7,5,7,7,6,7,7,7,5,7,7,7,5,7,6,6
    .byte 8,6,7,6,7,7,7,6,7,6,6,5,7,6,6,5,7,7,4,6,6,5,5,5
    .byte 7,6,6,6,6,7,6,8,6,5,7,7,6,6,6,7,7,6,7,6,5,8,6,6
    .byte 6,6,7,6,7,7,6,5,6,6,6,6,6,6,8,5,6,5,7,6,6,7,7,6
    .byte 6,7,6,6,7,6,5,7,7,6,7,6,7,7,7,6,6,7,7,3,6,7,7,6
    .byte 1,7,7,7,7,5,7,7,7,7,7,7,7,7,7,7,7,7,7,5,7,8,7,7
    .byte 7,7,7,7,6,7,7,7,7,7,6,6,7,6,6,7,6,6,7,7,7,5,7,7
    .byte 7,6,6,7,6,6,7,7,6,5,7,7,7,6,6,7,6,6,7,6,6,7,7,7
    .byte 7,7,7,7,6,6,7,6,6,5,4,5,7,5,6,6,6,7,4,7,6,7,6,7
    .byte 7,7,8,6,6,5,7,7,7,6,6,7,6,6,7,4,7,6,6,6,7,7,5,7
    .byte 6,7,4,6,6,7,6,6,7,7,7,8,7,7,6,7,6,7,7,7,5,6,6,6
    .byte 7,7,6,7,7,7,7,7,6,6,5,7,6,7,6,5,6,6,5,5,6,7,5,6
    .byte 7,6,5,6,7,5,7,6,7,7,7,6,5,7,6,6,6,8,6,7,7,6,7,7
    .byte 6,6,6,6,7,7,6,6,6,6,7,5,7,6,5,6,7,8,5,7,7,6,7,6
    .byte 7,6,7,7,6,8,6,6,6,7,6,7,7,6,6,6,7,5,6,6,6,7,5,7
    .byte 7,6,5,5,5,4,6,5,6,4,6,7,6,7,6,6,7,6,7,8,7,7,6,5
    .byte 7,7,7,7,7,6,7,7,6,6,7,5,7,6,7,6,6,6,5,6,6,7,6,7
    .byte 7,5,7,6,6,7,7,7,7,6,7,6,6,7,6,7,7,5,6,7,6,7,6,7
    .byte 6,7,6,4,6,7,7,8,7,6,4,7,4,7,5,6,5,6,4,6,6,7,7,7
    .byte 7,7,6,6,5,5,7,5,7,7,6,6,7,7,5,6,6,8,7,6,7,6,6,5
    .byte 5,5,7,6,6,7,7,7,6,6,7,6,7,7,6,7,7,6,6,7,6,6,5,7
    .byte 7,7,6,7,6,7,7,5,7,7,6,7,5,6,4,5,7,6,6,7,6,7,5,6
    .byte 4,5,5,7,5,6,6,6,7,6,7,6,5,7,6,6,6,6,7,6,8,6,7,7
    .byte 7,7,6,6,7,7,7,6,5,6,7,4,6,7,8,7,6,7,6,7,7,7,7,5
    .byte 7,6,7,6,7,7,6,6,7,6,6,8,5,8,7,7,7,5,7,7,7,6,6,6
    .byte 6,7,6,7,4,7,6,5,5,6,6,3,5,7,6,7,7,7,7,7,7,5,7,6
    .byte 6,7,6,7,7,8,5,7,7,6,6,7,6,6,7,6,6,6,6,6,5,7,7,6
    .byte 7,6,6,4,8,7,7,6,6,7,7,7,7,5,7,7,5,6,6,6,7,7,7,6
    .byte 7,7,4,7,7,7,6,5,7,7,7,6,6,6,6,4,6,7,6,5,6,6,6,6
    .byte 7,7,6,7,7,8,6,7,4,7,6,7,7,7,7,7,5,6,6,7,6,6,6,5
    .byte 7,6,6,5,6,5,5,7,7,6,6,7,6,5,6,7,6,7,6,7,7,7,7,6
    .byte 7,6,5,7,7,5,5,7,7,6,5,6,6,8,7,7,6,6,6,6,7,6,5,7
    .byte 6,6,6,4,7,4,4,7,7,7,6,7,6,6,7,7,7,7,7,7,5,8,6,6
    .byte 6,7,6,6,6,6,7,6,7,5,5,7,5,6,5,6,7,5,7,5,7,7,7,7
    .byte 6,7,7,6,6,5,5,7,7,7,6,7,7,7,5,7,6,7,7,5,7,7,7,7
    .byte 6,6,5,7,6,6,6,6,6,6,5,5,7,3,6,7,6,7,7,5,7,7,7,6
    .byte 7,7,6,6,6,7,6,6,6,6,7,6,7,6,6,7,6,7,5,6,5,6,7,5
    .byte 6,5,6,7,6,6,7,6,6,7,7,7,5,6,6,5,6,6,5,7,8,6,7,7
    .byte 6,8,6,7,6,6,7,7,7,5,6,6,7,6,7,7,7,6,6,6,5,5,5,6
    .byte 6,5,6,6,7,7,5,7,6,6,6,7,6,6,7,6,7,7,6,5,7,7,6,7
    .byte 6,7,7,5,5,5,6,5,6,6,5,6,7,6,7,7,7,8,7,7,7,5,6,5
    .byte 6,6,6,6,7,7,6,7,7,5,8,5,7,5,7,7,6,6,6,7,5,5,6,7
    .byte 6,4,7,2,7,7,7,6,5,7,7,6,7,7,6,6,6,7,7,8,6,7,7,7
    .byte 7,7,7,6,7,7,7,6,7,7,7,7,7,7,6,6,7,6,6,6,7,7,7,6
    .byte 7,7,7,8,7,7,7,4,6,7,7,5,6,6,6,7,7,6,5,7,6,7,7,7
    .byte 7,7,7,6,6,6,6,6,7,7,6,7,5,7,6,6,7,7,4,6,6,6,6,7
    .byte 6,5,7,7,6,7,6,7,6,7,6,6,7,6,6,6,6,7,6,5,6,6,6,7
    .byte 6,7,7,7,7,7,6,5,5,5,6,6,7,6,7,6,7,7,7,6,7,4,7,7
    .byte 7,7,6,6,7,7,7,6,7,5,5,6,6,7,7,7,5,7,7,7,4,6,6,7
    .byte 6,7,4,7,2,7,7,7,7,6,6,7,7,7,6,7,7,6,5,6,7,6,6,6
    .byte 6,7,7,7,6,5,7,7,6,7,6,6,6,7,5,6,6,6,6,5,6,8,8,7
    .byte 7,8,6,6,7,7,7,6,6,6,8,6,7,7,7,7,7,7,4,7,6,6,7,5
    .byte 6,7,6,6,6,7,5,6,6,7,5,6,6,6,4,7,7,7,6,7,7,6,6,7
    .byte 6,7,7,7,6,7,6,6,6,6,7,6,6,6,6,6,6,6,7,5,6,7,6,7
    .byte 5,6,6,5,7,5,7,6,7,7,5,7,7,7,6,5,6,6,7,6,6,7,7,7
    .byte 7,7,6,7,7,5,6,5,7,5,7,6,5,6,6,5,7,7,7,5,7,6,6,4
    .byte 7,6,6,7,7,7,5,7,5,5,7,6,6,7,7,4,7,6,6,5,6,6,6,7
    .byte 6,7,8,6,6,8,6,5,7,7,6,4,6,7,7,7,6,7,6,7,7,8,6,8
    .byte 4,5,6,7,6,7,7,7,6,7,7,6,6,6,6,4,7,6,7,6,7,7,6,6
    .byte 6,6,6,6,5,6,6,6,7,6,6,8,7,7,7,6,7,5,5,6,7,6,4,6
    .byte 6,7,6,5,7,5,7,6,6,8,6,5,6,7,6,6,7,7,7,6,7,6,6,7
    .byte 8,7,4,7,7,7,6,6,7,6,6,6,5,6,7,7,7,7,6,5,4,7,6,5
    .byte 7,7,6,4,7,8,8,6,7,4,8,7,5,6,7,6,7,6,7,7,7,7,6,6
    .byte 6,7,5,6,5,6,7,6,6,6,7,5,5,7,6,6,5,6,6,6,5,5,6,7
    .byte 7,6,7,6,7,7,6,7,6,6,6,5,6,7,6,5,7,6,6,7,7,7,6,7
    .byte 7,6,6,6,4,5,7,6,6,7,8,6,7,7,6,7,7,7,5,6,7,5,6,5
    .byte 4,6,7,7,6,7,6,8,6,6,7,5,6,6,7,6,6,7,6,6,7,7,5,6
    .byte 7,5,6,7,6,6,6,7,6,7,5,8,7,7,6,6,7,6,6,7,6,6,6,7
    .byte 7,6,6,7,6,6,6,7,6,7,6,7,6,6,2,7,6,7,7,7,7,6,7,7
    .byte 7,7,7,5,7,7,6,6,7,6,6,6,7,7,7,6,7,6,7,8,3,6,6,7
    .byte 5,5,7,6,6,6,6,6,7,6,5,7,6,6,6,6,7,5,7,7,6,6,7,7
    .byte 6,7,7,6,7,6,7,7,7,6,6,6,7,6,6,7,6,6,5,7,7,5,4,4
    .byte 6,7,7,6,7,7,6,6,6,6,7,7,6,6,6,7,5,7,7,7,6,4,7,7
    .byte 6,6,7,7,7,7,4,4,7,8,6,6,6,7,6,5,7,7,6,5,6,7,7,6
    .byte 7,5,7,6,6,6,7,7,7,7,7,6,7,6,6,7,7,5,6,6,6,7,7,7
    .byte 5,5,6,5,7,5,6,5,6,7,7,5,7,7,6,6,7,7,6,5,7,2,7,7
    .byte 7,7,7,7,6,7,7,6,7,6,7,7,7,6,8,7,5,6,7,7,7,6,7,6
    .byte 7,5,7,6,6,6,5,6,7,7,6,7,7,7,6,7,7,7,6,6,6,6,7,6
    .byte 7,7,7,7,7,6,7,7,7,6,6,7,7,6,7,7,6,4,7,6,7,7,7,7
    .byte 8,7,7,6,7,6,5,6,5,6,6,7,5,7,7,6,7,7,7,6,6,7,7,6
    .byte 3,7,6,6,6,6,7,7,6,6,5,6,6,5,6,8,6,6,7,6,7,7,7,6
    .byte 7,7,7,7,5,8,6,7,7,6,7,6,6,7,6,6,7,6,7,6,5,6,5,5
    .byte 6,5,6,6,7,6,6,7,7,7,7,7,5,6,6,6,5,6,6,7,6,6,7,7
    .byte 6,6,5,6,7,5,6,7,6,5,6,5,6,7,7,5,6,7,6,6,6,6,5,7
    .byte 5,5,8,6,7,7,6,7,4,7,6,6,6,7,7,5,7,6,7,7,5,7,7,6
    .byte 7,8,7,6,6,5,5,5,5,5,5,6,7,7,6,6,7,7,7,7,7,6,6,5
    .byte 6,7,7,7,7,7,6,5,5,6,5,6,6,7,7,7,7,7,5,7,6,6,4,7
    .byte 6,6,6,5,4,6,7,6,6,6,7,6,5,7,7,8,4,7,8,7,7,7,5,7
    .byte 7,7,7,7,7,5,7,7,6,6,5,7,6,6,6,4,6,6,6,7,4,7,7,5
    .byte 7,7,5,5,7,6,7,7,7,7,6,7,6,6,6,5,5,5,6,4,6,7,7,7
    .byte 7,6,6,7,6,5,6,7,7,6,6,7,6,6,4,5,6,7,7,5,7,7,6,6
    .byte 6,7,6,7,6,5,6,7,7,7,7,6,7,6,7,7,6,8,6,6,7,5,6,6
    .byte 7,6,5,7,6,8,7,6,7,6,7,7,5,6,7,6,7,8,5,7,7,5,7,6
    .byte 6,3,6,7,7,6,7,7,7,6,6,6,6,7,5,6,5,6,7,7,6,6,6,6
    .byte 6,6,6,6,7,6,6,8,7,8,7,6,7,7,7,7,6,6,5,7,6,6,7,7
    .byte 8,6,6,6,6,7,7,8,6,6,5,5,7,5,6,7,7,5,7,8,6,6,7,7
    .byte 7,7,7,6,7,7,6,7,7,5,5,6,7,6,5,6,6,6,7,8,5,5,6,6
    .byte 7,5,6,7,7,6,5,6,6,6,6,7,6,6,6,7,6,5,8,6,6,8,7,6
    .byte 5,7,7,6,7,7,6,7,7,7,8,5,7,6,6,6,7,6,3,6,6,7,7,6
    .byte 7,7,5,7,7,7,5,5,6,7,7,6,6,6,6,7,7,7,6,5,5,6,7,6
    .byte 6,7,6,7,6,7,6,5,7,6,6,6,6,5,7,5,6,5,5,7,6,6,5,7
    .byte 7,5,7,7,6,6,7,7,7,6,6,6,7,7,7,7,6,6,7,5,6,5,6,6
    .byte 6,6,7,6,7,5,5,7,7,7,5,6,7,7,7,7,6,7,6,6,6,7,6,6
    .byte 8,5,7,7,5,6,6,5,7,5,6,6,7,7,6,5,5,7,7,5,7,5,7,5
    .byte 5,4,5,7,6,7,7,7,6,7,7,5,7,7,7,6,7,7,5,7,7,7,6,7
    .byte 6,6,6,5,6,7,5,6,6,6,7,7,4,6,7,7,5,4,7,6,6,5,6,7
    .byte 6,8,7,7,7,6,6,7,7,6,7,6,4,6,7,7,6,7,5,7,6,7,7,7
    .byte 6,6,6,6,6,7,6,7,5,6,5,5,6,5,7,7,6,7,6,7,5,7,7,6
    .byte 7,7,7,6,6,5,6,7,7,6,7,6,6,7,6,5,7,6,6,8,7,7,6,6
    .byte 6,3,7,7,6,7,6,7,6,6,8,5,7,5,7,3,7,7,8,7,6,7,6,6
    .byte 7,7,5,6,7,6,8,7,6,6,6,7,6,7,6,4,6,7,7,5,7,7,8,6
    .byte 6,7,8,7,8,6,7,6,6,7,7,7,6,7,6,7,8,7,6,5,6,7,7,6
    .byte 6,6,6,6,8,7,5,6,6,6,6,6,6,7,7,7,6,7,6,7,7,7,6,7
    .byte 7,7,6,6,7,7,5,6,6,6,7,7,6,6,6,6,7,7,7,7,7,5,5,7
    .byte 6,5,4,4,6,6,7,6,7,7,5,6,6,5,7,7,6,5,7,6,7,7,7,6
    .byte 8,5,7,5,6,6,6,6,7,7,4,7,7,7,5,6,7,7,5,6,6,7,6,3
    .byte 7,7,6,6,7,6,6,7,7,5,7,6,7,7,6,7,3,7,7,7,7,6,6,6
    .byte 7,7,5,7,5,6,7,7,6,5,6,6,7,5,6,7,7,7,6,6,5,6,6,7
    .byte 7,7,7,6,7,7,7,6,7,7,8,7,7,6,5,7,6,7,7,5,6,6,7,7
    .byte 6,7,7,7,5,6,5,7,5,7,8,7,6,7,7,7,7,7,5,7,6,5,8,8
    .byte 4,7,7,7,7,7,7,4,6,7,6,7,6,6,7,8,6,7,7,6,5,4,6,5
    .byte 7,6,6,7,5,7,6,7,7,6,7,6,7,6,7,6,7,7,8,6,7,4,6,6
    .byte 5,7,6,5,7,6,5,7,7,5,6,7,6,6,6,6,5,5,7,7,6,7,6,6
    .byte 7,6,6,5,6,7,7,6,6,5,7,6,7,6,6,7,6,6,5,7,5,6,7,6
    .byte 6,7,7,4,6,6,6,5,4,6,6,7,7,5,7,7,6,7,6,5,6,7,6,6
    .byte 7,7,7,7,8,7,6,7,7,7,6,7,5,5,6,7,6,6,7,7,5,5,6,6
    .byte 7,5,5,6,7,6,6,6,7,6,6,6,4,7,7,6,4,6,5,8,6,7,7,7
    .byte 7,6,6,7,5,7,6,5,7,7,5,7,7,7,5,7,7,6,7,6,6,7,7,7
    .byte 5,6,7,4,7,6,7,6,7,6,6,6,7,6,6,7,6,6,7,5,6,6,7,7
    .byte 7,6,7,7,7,7,6,6,5,7,7,6,5,8,7,4,6,6,6,7,5,5,6,6
    .byte 7,5,6,7,5,6,7,7,6,5,7,7,7,7,7,6,7,7,6,6,7,3,6,6
    .byte 7,7,6,6,6,8,6,7,7,7,7,6,7,5,6,7,6,7,5,6,7,7,6,8
    .byte 7,5,5,6,6,7,6,7,6,7,7,6,7,8,7,7,6,3,8,7,8,7,7,6
    .byte 6,6,6,7,4,6,6,6,6,5,7,6,7,7,6,7,6,8,6,6,4,5,6,7
    .byte 6,6,6,7,7,7,6,6,5,5,8,6,6,7,6,5,7,8,7,5,6,6,6,6
    .byte 7,5,7,6,6,6,7,4,7,5,6,7,6,6,7,5,7,6,7,8,7,7,6,7
    .byte 7,5,7,7,7,7,8,6,6,6,7,3,6,6,6,7,6,6,7,6,5,7,4,7
    .byte 7,7,6,5,7,6,7,6,6,6,7,6,6,8,6,6,5,6,7,5,8,5,6,7
    .byte 7,7,6,7,6,5,6,6,4,6,7,6,5,7,6,5,7,7,6,5,7,6,7,6
    .byte 7,6,7,7,7,7,6,7,7,6,6,4,7,7,7,7,6,6,6,5,7,6,6,6
    .byte 4,6,6,7,5,7,6,5,5,6,6,5,7,6,6,7,6,7,4,5,7,7,7,5
    .byte 7,7,7,7,6,7,6,6,7,7,7,6,6,7,5,5,6,7,7,7,5,6,6,7
    .byte 5,4,6,7,7,6,6,5,6,7,6,7,7,6,7,7,7,6,7,6,7,6,7,6
    .byte 6,8,6,6,6,7,5,7,5,6,6,6,7,6,5,6,4,7,6,6,5,7,7,7
    .byte 7,8,7,4,7,6,7,7,6,7,6,7,7,5,7,6,7,5,6,7,8,7,5,6
    .byte 6,7,6,6,6,5,7,6,7,7,6,6,5,7,7,7,6,6,6,7,7,6,7,6
    .byte 6,5,6,7,7,6,5,7,7,6,6,7,6,6,5,5,5,6,5,7,6,7,6,7
    .byte 7,5,6,5,4,5,6,7,8,7,6,6,5,7,6,6,6,6,6,6,7,6,6,8
    .byte 4,7,7,7,7,7,6,6,7,7,6,6,7,7,5,7,6,7,6,6,6,8,5,7
    .byte 6,7,5,6,7,7,6,7,7,7,6,7,7,7,5,7,6,8,7,7,6,7,6,7
    .byte 7,6,4,7,5,6,7,5,7,7,5,6,6,6,3,7,7,8,7,7,7,5,6,5
    .byte 7,6,6,7,7,7,6,6,7,6,6,6,7,7,7,5,7,6,7,7,6,7,7,4
    .byte 5,7,7,5,6,7,7,7,6,6,6,6,7,7,7,6,7,6,6,6,7,6,7,6
    .byte 7,7,6,6,6,7,8,4,7,6,6,5,4,7,6,8,7,6,7,6,6,7,7,7
    .byte 5,7,7,8,6,7,7,7,7,7,7,7,4,6,7,6,5,6,7,6,7,7,6,7
    .byte 6,6,6,6,5,6,7,7,6,6,6,7,7,5,8,6,6,4,6,4,6,7,6,7
    .byte 7,7,6,7,8,5,6,6,5,7,7,6,6,7,6,6,6,6,6,6,5,4,6,6
    .byte 6,6,6,5,7,7,7,6,7,6,6,6,7,7,7,8,5,7,7,6,6,5,5,6
    .byte 5,6,6,6,6,7,7,7,7,6,6,5,4,7,6,7,5,6,7,7,4,7,7,6
    .byte 7,6,6,5,6,6,6,7,7,7,6,7,5,7,8,7,7,5,7,6,7,5,7,6
    .byte 5,7,6,6,6,7,5,5,6,7,7,7,7,5,7,6,7,6,6,6,6,6,6,6
    .byte 5,8,7,6,7,7,6,4,6,6,6,7,6,7,7,6,7,7,7,5,6,7,7,5
    .byte 7,6,7,7,5,6,7,5,8,6,5,6,6,7,6,5,7,6,7,7,7,7,7,6
    .byte 7,4,6,6,6,7,7,7,4,6,6,5,6,5,6,6,5,7,7,6,6,6,6,7
    .byte 7,5,6,7,7,6,6,7,6,7,7,7,5,7,6,5,6,7,5,6,7,7,7,7
    .byte 6,6,7,7,6,5,6,7,6,7,6,7,4,7,6,6,6,6,6,6,7,6,6,7
    .byte 6,7,7,6,6,7,6,6,6,7,6,6,7,7,7,7,4,6,6,7,5,6,5,7
    .byte 6,7,5,6,6,7,7,5,7,6,6,7,6,7,7,7,7,5,6,7,7,6,6,6
    .byte 6,5,7,7,6,7,7,6,7,7,6,6,6,5,6,6,7,6,6,7,7,6,5,6
    .byte 7,6,6,5,6,7,7,7,6,7,6,7,7,5,6,5,7,6,7,6,5,8,7,7
    .byte 7,7,5,3,5,7,7,7,6,4,5,7,7,6,7,6,8,4,7,7,5,7,4,8
    .byte 7,6,7,8,4,7,7,7,7,6,6,6,7,7,6,7,6,7,7,6,6,5,5,5
    .byte 7,7,7,6,7,7,6,7,5,7,6,7,7,7,5,7,6,7,6,7,7,6,6,6
    .byte 7,7,6,6,7,7,6,7,7,5,7,7,4,6,4,6,7,7,5,5,7,7,7,6
    .byte 6,6,7,7,5,6,7,8,6,6,7,6,6,7,6,7,5,7,5,7,6,6,7,6
    .byte 7,6,8,5,5,6,5,7,5,6,7,7,8,5,7,5,5,7,6,7,6,6,6,7
    .byte 7,6,7,6,5,6,7,6,7,6,7,6,7,6,6,7,7,6,6,6,6,5,6,5
    .byte 7,7,7,5,6,6,7,6,6,7,6,6,7,7,7,7,7,6,7,7,6,7,7,6
    .byte 7,7,5,4,7,6,6,5,8,7,7,8,7,6,6,6,6,5,6,5,7,7,7,7
    .byte 4,7,7,7,6,6,7,8,7,7,7,8,7,5,7,6,7,5,4,5,6,7,6,6
    .byte 7,7,6,7,6,6,5,6,6,7,6,6,6,5,5,6,6,6,7,7,7,7,7,7
    .byte 6,7,4,6,7,7,6,7,7,5,6,7,6,6,5,6,6,6,7,7,7,7,5,7
    .byte 6,7,5,5,6,7,6,4,7,7,6,7,7,5,7,4,6,6,6,6,7,7,5,7
    .byte 8,7,7,7,6,6,7,7,7,8,7,4,5,6,4,7,7,5,5,7,7,3,6,6
    .byte 7,7,6,6,6,6,7,5,6,5,6,6,7,7,7,7,5,7,7,6,5,7,7,6
    .byte 8,7,6,7,7,7,7,7,5,6,6,7,7,6,7,5,7,6,6,8,6,8,7,6
    .byte 5,6,5,7,6,6,7,6,7,7,7,7,6,6,6,7,5,6,7,8,6,6,6,6
    .byte 6,7,6,8,6,7,5,6,5,7,6,7,7,5,8,6,7,7,7,6,5,6,6,6
    .byte 6,7,7,5,6,6,7,5,6,6,6,7,7,6,7,7,5,7,7,6,6,5,6,5
    .byte 7,6,7,7,5,8,7,7,7,3,6,6,6,6,6,6,7,7,8,6,7,6,7,6
    .byte 6,7,7,8,6,6,5,6,6,5,7,7,7,5,6,5,5,5,6,6,7,6,7,6
    .byte 6,6,6,7,6,7,7,7,7,6,7,7,6,7,5,4,6,6,6,5,6,7,6,8
    .byte 6,7,7,6,6,7,6,5,7,6,7,8,6,7,8,7,6,7,6,7,5,5,7,7
    .byte 6,7,7,6,7,5,6,5,7,7,7,6,7,6,6,6,6,4,7,6,7,6,7,6
    .byte 6,7,5,7,7,7,5,7,7,7,6,6,6,4,6,7,7,5,7,6,6,6,8,7
    .byte 6,7,7,5,6,6,7,7,7,7,6,8,5,6,6,5,7,5,6,7,7,6,7,6
    .byte 6,6,7,7,6,6,6,6,7,8,5,7,6,7,6,6,6,7,7,7,3,6,5,7
    .byte 7,6,7,5,8,6,5,7,7,6,7,6,6,6,7,7,6,6,5,7,7,7,6,7
    .byte 5,6,5,6,6,7,7,7,7,7,5,7,6,6,4,7,6,7,7,7,7,6,5,7
    .byte 7,6,5,7,6,7,7,4,7,7,7,8,6,7,5,6,6,6,6,6,6,7,7,6
    .byte 6,7,5,6,3,6,6,7,5,6,6,7,6,5,7,7,6,6,5,6,6,7,6,7
    .byte 8,6,6,8,6,6,5,6,5,7,4,6,7,5,7,7,7,7,5,7,7,6,5,6
    .byte 6,7,7,7,7,7,7,6,4,6,7,6,7,6,6,5,7,6,7,7,7,7,6,6
    .byte 7,4,6,5,6,7,6,6,7,4,6,7,5,6,5,6,6,7,6,6,6,5,7,7
    .byte 7,5,6,4,6,7,6,7,8,7,7,5,6,6,7,5,7,6,6,6,6,6,7,7
    .byte 6,7,7,6,6,6,7,7,3,7,7,8,7,7,7,6,5,6,7,4,7,7,7,7
    .byte 6,6,7,6,7,7,6,7,6,7,4,6,7,6,5,5,7,7,7,7,5,6,6,5
    .byte 7,7,6,5,7,6,6,6,7,6,6,6,7,6,7,6,7,7,7,4,7,5,7,7
    .byte 6,6,5,6,7,6,6,6,7,6,7,7,7,6,7,7,6,5,7,6,7,6,6,7
    .byte 7,6,6,6,7,5,6,5,5,6,6,5,7,7,7,6,6,6,5,6,5,6,6,7
    .byte 7,7,6,7,6,4,5,6,7,7,5,6,7,8,6,6,7,7,6,5,6,5,7,6
    .byte 7,7,6,7,7,6,6,7,7,5,6,7,7,6,7,6,6,7,7,6,7,6,7,7
    .byte 6,4,7,7,8,7,6,7,6,6,6,7,7,5,7,5,7,5,7,6,6,6,7,6
    .byte 7,6,7,5,7,5,6,7,8,7,6,7,6,6,6,6,7,3,7,7,6,7,6,6
    .byte 7,6,7,6,6,6,7,5,6,7,6,7,7,6,6,7,5,6,5,6,7,7,7,7
    .byte 7,6,6,6,7,6,7,7,7,7,6,7,7,7,6,6,7,7,7,7,6,7,6,7
    .byte 6,7,3,5,6,6,7,7,7,5,7,7,6,6,6,7,5,7,7,6,5,4,7,7
    .byte 7,5,6,5,7,7,6,6,7,7,6,6,7,6,5,7,7,6,7,5,7,7,6,7
    .byte 4,8,7,7,5,6,6,7,6,5,6,7,7,6,6,7,7,6,7,6,5,7,6,7
    .byte 7,6,5,6,6,7,6,7,7,6,5,5,6,6,8,7,5,8,7,7,5,5,5,6
    .byte 6,7,7,7,6,7,6,7,5,5,4,6,7,7,6,6,7,6,6,7,7,5,6,6
    .byte 6,6,7,7,6,6,6,6,6,6,6,7,6,7,7,6,6,3,6,7,6,6,6,7
    .byte 6,7,7,7,4,6,7,6,7,7,6,6,6,5,5,6,6,7,7,6,6,6,6,6
    .byte 7,7,7,7,6,7,7,6,6,5,5,7,7,7,6,7,7,4,6,4,6,5,6,5
    .byte 4,6,6,6,7,7,7,7,7,5,7,7,7,5,7,7,7,6,7,6,5,7,6,6
    .byte 7,6,4,6,5,6,7,7,6,7,7,6,6,6,5,6,6,6,7,6,7,4,7,6
    .byte 6,6,7,5,7,6,4,6,7,7,7,7,7,7,7,7,4,8,7,6,6,6,6,8
    .byte 7,5,6,6,6,6,7,5,6,5,6,6,5,6,6,7,7,6,7,6,7,7,6,7
    .byte 7,6,6,6,6,7,7,5,7,6,6,6,5,6,7,7,7,7,6,6,7,7,6,7
    .byte 6,5,7,8,7,6,7,6,5,7,6,6,7,6,6,3,7,7,7,6,6,7,8,7
    .byte 6,5,6,7,6,6,7,7,7,3,7,8,6,6,6,5,7,5,6,5,5,6,7,7
    .byte 6,7,6,6,6,7,6,6,6,7,7,7,5,6,7,6,6,7,5,6,5,6,7,6
    .byte 7,7,6,7,7,7,6,6,5,7,7,5,7,7,7,7,5,6,6,6,6,5,7,6
    .byte 7,5,7,7,7,7,7,6,7,6,7,7,6,6,7,5,6,7,6,7,6,7,8,3
    .byte 6,5,6,6,5,6,6,7,7,6,7,7,6,5,6,7,7,7,6,7,7,5,6,5
    .byte 6,6,5,5,8,7,6,7,7,6,7,7,7,6,6,7,6,7,7,6,7,6,6,7
    .byte 6,6,8,7,6,4,7,7,8,7,6,7,6,6,5,6,7,7,6,6,7,7,5,5
    .byte 6,7,7,7,5,6,6,6,6,5,6,4,6,5,7,6,8,6,5,6,7,3,6,6
    .byte 8,7,6,8,6,7,6,6,4,5,7,6,7,7,5,7,6,7,7,7,6,5,7,7
    .byte 7,7,6,6,7,7,7,6,7,6,8,7,6,6,5,6,7,7,7,6,7,5,6,6
    .byte 6,7,5,7,5,6,8,4,7,6,6,7,5,5,7,7,5,6,7,6,4,6,7,7
    .byte 7,6,7,6,8,5,6,5,5,7,6,7,7,7,8,5,7,6,7,6,6,7,6,6
    .byte 7,5,7,6,7,7,6,6,6,6,7,6,6,7,6,8,6,7,7,5,7,5,6,6
    .byte 7,6,6,6,7,7,7,5,6,6,7,6,5,7,7,7,5,5,5,6,6,5,7,6
    .byte 6,5,7,5,7,4,7,6,6,6,6,7,7,5,7,5,4,7,6,7,7,6,7,7
    .byte 5,6,6,6,6,7,6,7,6,6,7,6,6,7,8,7,6,6,5,7,7,7,5,7
    .byte 7,7,5,6,6,7,4,6,7,8,5,7,7,7,7,6,5,7,4,6,7,6,5,7
    .byte 7,5,6,6,7,6,7,6,7,6,6,6,7,7,3,5,7,7,6,6,6,7,6,5
    .byte 6,7,6,7,6,7,7,6,6,7,7,7,6,7,7,5,6,6,7,6,7,7,7,7
    .byte 4,7,7,6,6,6,8,6,6,7,5,8,7,6,6,7,6,7,7,5,6,6,7,7
    .byte 7,8,7,6,4,6,7,6,6,5,6,7,7,5,6,6,6,6,7,6,2,7,7,6
    .byte 6,7,7,6,7,8,6,6,5,6,7,7,7,6,6,5,7,6,6,7,7,7,6,7
    .byte 6,7,5,6,7,7,7,6,8,7,7,6,7,6,6,7,4,8,7,7,7,4,7,6
    .byte 7,7,7,5,7,7,6,6,7,6,7,7,6,7,6,5,6,6,7,6,7,7,5,7
    .byte 6,6,7,4,4,4,8,6,6,7,7,6,5,7,7,5,6,6,7,7,5,6,7,7
    .byte 7,6,5,6,7,6,6,6,6,4,7,6,7,7,7,7,6,7,7,5,6,7,7,5
    .byte 7,7,6,6,6,7,6,6,6,6,6,6,6,4,7,6,5,7,7,6,8,7,5,7
    .byte 6,6,6,6,6,7,7,7,6,6,7,6,4,6,6,6,5,6,7,7,6,6,6,6
    .byte 7,4,5,7,6,7,7,6,7,7,4,7,7,5,7,6,7,6,6,5,5,7,7,7
    .byte 7,7,7,6,6,7,7,6,7,6,6,7,7,7,7,6,5,5,7,7,6,7,7,5
    .byte 5,7,6,6,7,7,6,5,6,7,7,6,6,4,6,6,6,5,4,8,8,6,4,5
    .byte 5,7,7,6,6,7,6,6,7,6,6,5,7,7,5,7,6,5,6,5,6,7,7,6
    .byte 5,6,7,7,7,7,7,7,7,6,6,6,7,5,7,6,6,7,5,7,6,6,7,6
    .byte 7,7,7,5,5,6,7,7,7,7,6,7,6,7,6,6,6,6,6,6,5,6,6,7
    .byte 6,7,7,6,7,7,6,6,5,5,7,6,6,7,7,7,3,8,6,7,6,6,6,6
    .byte 5,6,5,4,7,6,6,7,7,6,7,6,6,7,6,7,7,7,6,6,7,6,7,7
    .byte 7,6,6,6,6,7,6,6,7,7,6,7,6,6,3,6,6,6,6,6,7,7,6,7
    .byte 6,7,6,6,4,6,7,7,4,6,7,6,7,7,7,6,5,5,7,7,6,7,6,7
    .byte 4,6,6,5,5,7,3,7,7,7,5,6,7,7,6,7,7,8,7,6,6,8,6,7
    .byte 7,6,6,7,6,6,6,7,5,5,7,6,6,7,6,7,7,6,6,7,6,6,6,6
    .byte 7,6,6,7,7,7,7,7,5,7,7,6,6,5,5,3,8,7,6,6,5,6,6,7
    .byte 5,5,7,7,7,7,6,7,7,6,6,6,7,6,6,4,7,6,4,6,7,6,5,6
    .byte 7,7,7,5,6,7,7,7,6,7,7,7,6,7,6,6,6,6,6,6,5,7,5,6
    .byte 5,7,7,7,6,7,7,4,6,7,6,7,7,6,7,7,6,6,7,7,5,5,6,6
    .byte 7,6,5,7,8,4,7,6,7,7,6,5,6,8,6,5,6,6,6,6,6,7,6,6
    .byte 6,6,6,6,5,6,7,7,6,6,7,6,6,7,6,7,7,6,7,5,7,6,7,7
    .byte 7,8,7,6,6,6,6,7,6,6,4,7,6,7,5,7,6,7,6,7,6,7,6,5
    .byte 7,7,7,7,7,7,6,5,6,4,6,7,6,6,6,7,6,7,8,7,6,6,5,5
    .byte 4,6,6,8,5,7,7,8,5,4,6,7,6,6,6,7,7,6,6,7,6,6,7,6
    .byte 6,6,7,6,5,7,6,7,7,7,7,7,7,7,7,6,7,6,6,4,6,6,6,5
    .byte 7,7,6,6,7,6,5,7,7,8,7,7,7,7,7,6,6,5,6,6,6,6,6,6
    .byte 6,7,6,7,6,6,6,6,7,5,6,6,5,7,7,5,5,7,7,6,7,6,5,6
    .byte 6,5,6,7,6,7,7,7,7,7,7,7,7,6,6,7,7,6,7,7,5,7,8,5
    .byte 6,5,6,5,7,6,5,6,6,7,7,7,6,5,7,6,7,7,7,7,5,7,6,6
    .byte 5,7,7,7,6,7,7,8,5,6,6,8,7,6,7,5,6,6,4,5,5,7,6,6
    .byte 6,7,7,4,8,8,7,6,7,6,8,6,6,7,7,7,7,7,7,7,5,6,7,7
    .byte 6,6,6,7,7,8,6,6,8,7,7,7,6,6,6,5,6,8,7,5,7,7,6,5
    .byte 6,5,6,7,7,8,6,6,6,7,7,6,4,5,5,7,7,7,7,7,6,7,6,6
    .byte 6,5,7,4,5,6,7,7,6,7,6,6,6,7,5,6,7,6,5,4,7,7,6,7
    .byte 7,7,5,7,7,6,6,7,7,7,7,7,5,7,6,6,5,7,6,7,7,7,7,6
    .byte 5,7,4,5,6,7,7,6,7,6,6,7,7,7,7,7,5,7,7,6,6,5,4,7
    .byte 7,6,6,7,6,6,6,7,5,7,6,6,5,7,4,6,6,6,6,5,7,5,7,6
    .byte 6,7,5,6,6,5,7,7,5,6,6,7,7,7,6,7,7,6,8,6,7,4,7,7
    .byte 5,7,6,5,7,7,6,7,7,4,7,5,6,7,5,7,6,6,6,6,6,7,7,8
    .byte 7,7,7,6,6,5,7,5,5,6,6,7,6,7,7,5,7,5,6,7,7,7,4,6
    .byte 7,6,7,6,4,6,5,7,7,7,6,7,5,6,5,7,6,7,6,7,7,7,5,7
    .byte 7,6,7,7,7,7,7,7,6,5,7,7,7,7,6,7,7,6,5,5,6,7,6,7
    .byte 7,7,5,7,7,6,7,7,7,6,7,7,6,7,7,5,5,7,5,7,6,5,6,7
    .byte 7,6,5,7,6,6,5,7,5,7,6,6,7,5,6,5,6,7,6,6,6,4,5,7
    .byte 6,7,7,7,7,7,7,6,6,5,7,7,7,8,7,6,5,7,5,6,7,7,6,7
    .byte 7,5,7,6,5,6,4,7,7,7,6,7,6,5,7,8,7,6,6,7,6,6,5,6
    .byte 7,6,4,6,7,7,6,7,6,6,6,4,6,7,7,7,5,5,7,7,6,5,5,7
    .byte 4,6,6,7,5,7,7,6,5,7,7,6,8,7,7,6,7,6,6,7,7,7,6,7
    .byte 7,7,7,8,7,6,7,5,6,4,7,6,5,7,7,6,6,4,8,7,6,7,7,7
    .byte 5,6,7,7,6,7,6,7,7,5,6,7,6,5,4,7,6,5,7,7,6,7,7,6
    .byte 5,7,6,6,6,6,6,6,6,7,6,5,7,5,6,7,4,6,6,6,7,7,7,7
    .byte 7,7,7,6,6,7,7,6,5,7,7,6,6,8,8,6,7,5,5,7,6,6,5,6
    .byte 6,7,6,7,6,7,6,7,8,6,5,7,7,7,7,6,6,7,7,6,7,7,7,4
    .byte 6,6,7,7,6,8,4,7,7,5,6,6,7,6,6,7,5,7,3,6,7,6,5,7
    .byte 7,6,5,7,7,4,6,6,7,7,7,7,6,7,7,7,7,5,7,7,8,7,6,7
    .byte 6,5,6,7,5,7,6,7,6,7,6,5,7,6,6,7,7,7,6,7,6,7,6,7
    .byte 6,6,7,7,6,5,6,6,5,6,7,6,7,7,6,7,7,6,6,6,7,4,6,7
    .byte 5,6,5,5,5,6,6,6,7,6,7,6,7,5,5,7,7,7,7,7,7,6,7,6
    .byte 5,6,8,6,8,7,7,7,6,6,6,6,7,5,7,5,7,7,6,6,7,6,7,7
    .byte 7,7,8,7,7,4,7,6,7,6,7,6,6,7,6,6,6,6,6,6,6,6,6,6
    .byte 6,6,6,5,7,7,6,4,7,7,7,4,5,7,6,7,7,6,6,4,6,7,7,7
    .byte 6,7,7,7,6,6,6,7,7,7,7,7,4,7,7,6,6,6,7,7,6,7,5,5
    .byte 6,7,5,7,6,6,7,6,6,6,6,7,7,6,8,7,7,7,6,6,7,7,5,7
    .byte 7,6,4,6,6,6,6,6,5,5,7,5,6,6,5,6,7,6,6,6,6,5,7,7
    .byte 8,6,7,7,7,5,7,6,6,6,7,7,6,7,6,7,7,7,8,7,6,6,6,7
    .byte 5,7,6,7,6,7,4,7,7,5,6,7,7,7,6,7,6,6,6,6,7,7,5,8
    .byte 7,7,7,7,6,6,4,5,5,7,6,7,6,7,6,6,7,7,6,7,7,5,6,6
    .byte 6,6,6,7,5,7,6,7,6,6,7,6,4,5,6,7,7,7,7,6,7,7,7,6
    .byte 7,7,7,6,7,7,5,7,7,6,6,6,6,7,8,8,5,7,6,6,5,6,7,6
    .byte 5,5,6,6,7,7,7,6,7,7,6,7,7,7,5,5,6,6,7,6,6,5,7,7
    .byte 6,6,6,7,6,6,7,7,6,3,7,7,6,4,7,6,7,7,7,6,7,5,4,5
    .byte 7,6,7,6,7,7,7,5,7,7,7,7,7,7,6,6,7,7,5,7,5,7,7,6
    .byte 7,7,6,6,5,7,7,7,7,7,6,4,6,7,6,6,7,7,7,7,6,5,6,7
    .byte 3,7,7,5,7,6,7,6,7,7,5,7,6,6,7,6,8,7,7,4,5,6,7,5
    .byte 5,7,7,4,6,7,6,6,7,6,7,8,6,6,6,7,7,6,5,6,7,6,6,6
    .byte 7,7,5,5,7,6,7,4,6,6,7,5,6,7,7,6,6,6,7,6,7,7,7,7
    .byte 7,6,6,7,7,5,4,7,5,5,6,6,7,7,6,6,6,6,6,4,6,6,6,7
    .byte 7,7,6,7,6,6,6,6,6,4,6,6,5,7,6,5,7,8,8,7,7,6,7,7
    .byte 6,8,6,7,6,7,6,7,6,6,6,6,7,4,7,6,5,6,6,7,6,7,7,7
    .byte 7,6,7,6,7,7,6,7,7,7,7,7,7,6,6,6,6,5,7,7,6,5,7,6
    .byte 7,6,8,6,7,2,6,5,7,7,6,7,6,6,6,6,7,6,6,6,5,7,5,7
    .byte 7,7,7,6,7,7,7,6,7,6,7,6,5,6,7,6,5,5,7,7,6,6,7,6
    .byte 6,5,5,7,7,4,7,7,7,6,6,7,7,7,6,7,7,7,7,7,5,7,7,6
    .byte 6,5,6,5,7,7,6,5,6,6,7,6,6,5,4,6,6,4,6,7,6,4,8,8
    .byte 7,6,7,6,6,7,5,7,7,7,7,7,6,7,7,7,7,7,7,8,4,6,7,6
    .byte 4,6,7,7,6,6,7,6,7,6,5,7,5,6,7,7,8,6,7,7,6,7,6,6
    .byte 6,7,7,6,7,7,6,7,7,5,6,6,8,6,6,7,7,5,5,7,7,4,4,4
    .byte 7,7,6,7,6,7,6,7,6,5,6,6,7,6,6,7,6,7,7,4,6,6,6,6
    .byte 7,7,7,7,7,7,6,6,6,5,5,7,6,7,6,5,5,5,7,6,6,7,8,5
    .byte 6,7,7,8,5,7,7,8,6,6,6,8,7,6,7,7,7,6,6,6,7,7,4,7
    .byte 6,6,5,3,7,6,7,6,4,8,7,5,6,7,5,5,7,7,6,8,7,6,7,6
    .byte 6,7,7,6,4,6,7,7,7,6,7,7,7,7,6,6,6,6,7,5,6,6,7,5
    .byte 5,5,5,7,5,7,6,7,6,6,7,7,7,7,7,7,7,8,7,5,7,6,7,7
    .byte 7,8,7,7,6,6,5,5,7,6,7,5,6,5,6,7,4,6,7,6,5,7,7,5
    .byte 6,6,7,7,6,7,7,5,6,7,7,7,6,6,6,7,5,7,7,7,7,7,6,6
    .byte 7,6,6,6,7,6,7,5,7,6,7,3,5,7,6,7,6,7,6,5,6,6,7,7
    .byte 7,7,6,6,7,7,6,7,7,8,7,7,7,5,7,6,6,6,4,5,7,7,7,5
    .byte 6,6,7,6,6,6,6,7,7,5,5,6,6,7,7,5,8,7,6,7,8,6,5,7
    .byte 7,7,6,6,7,5,6,7,6,5,7,6,7,6,7,6,7,6,6,5,7,5,6,7
    .byte 6,5,7,7,7,6,7,6,7,7,7,7,5,8,7,6,7,7,7,7,7,7,7,6
    .byte 7,7,5,6,6,6,3,5,5,7,7,6,6,7,6,7,7,6,4,5,6,7,6,6
    .byte 7,5,5,7,7,7,7,6,6,7,6,7,7,8,6,7,6,6,6,6,6,6,7,6
    .byte 6,5,7,6,6,4,4,7,7,7,6,6,7,6,7,7,7,7,6,7,7,5,6,7
    .byte 6,7,7,7,7,7,7,4,6,6,6,6,5,5,7,7,7,5,6,6,7,6,5,6
    .byte 6,7,6,6,5,6,6,6,6,5,8,7,6,7,7,5,5,6,7,6,8,6,7,7
    .byte 7,6,6,6,6,6,7,6,7,6,6,5,5,4,6,7,5,7,7,7,6,7,6,6
    .byte 7,6,7,6,7,7,7,6,6,7,7,7,7,7,7,6,7,6,4,6,7,6,7,6
    .byte 6,5,6,7,3,7,6,6,6,7,7,5,7,7,6,7,5,7,7,6,7,7,6,7
    .byte 7,4,6,7,6,7,6,7,7,7,7,7,5,5,7,6,6,7,6,7,5,5,5,4
    .byte 6,7,7,7,7,5,7,7,6,7,6,7,6,7,7,6,7,7,7,7,7,7,7,6
    .byte 5,6,7,6,5,7,6,7,6,3,7,7,7,5,4,7,7,5,5,7,6,6,7,8
    .byte 7,7,6,4,7,7,7,7,7,7,6,6,7,7,6,7,8,5,7,6,7,5,6,7
    .byte 6,7,6,5,7,6,7,5,7,6,7,6,6,6,7,8,7,6,8,6,7,6,7,7
    .byte 5,7,7,7,7,7,7,6,6,7,7,6,7,7,5,6,7,7,4,5,5,6,6,6
    .byte 6,7,7,7,6,6,5,6,6,6,6,7,5,6,5,7,6,7,7,7,6,5,7,7
    .byte 7,7,7,7,7,6,4,5,7,7,6,6,7,7,5,6,7,6,6,4,5,6,7,5
    .byte 7,6,6,7,7,6,7,7,7,8,7,7,7,6,6,7,7,6,6,6,6,6,7,7
    .byte 6,4,6,6,7,5,6,5,5,7,7,4,6,6,6,5,7,7,6,6,7,3,7,7
    .byte 6,7,7,6,7,7,8,7,7,7,7,7,7,7,7,7,5,6,6,6,6,6,7,6
    .byte 7,5,8,6,5,5,6,6,7,7,7,7,7,7,7,6,6,7,7,7,7,7,8,6
    .byte 7,6,7,6,6,5,7,8,6,5,7,7,7,6,7,7,6,3,6,5,8,7,7,7
    .byte 7,6,6,6,7,5,6,7,6,5,6,7,6,6,6,5,7,7,6,7,7,7,7,7
    .byte 4,7,6,7,6,6,7,7,6,5,6,6,7,4,5,7,6,5,7,7,7,6,7,7
    .byte 7,7,7,7,6,8,7,7,6,7,6,6,5,7,5,5,6,7,7,7,5,6,5,5
    .byte 6,5,6,5,7,6,6,7,7,7,7,7,5,5,6,6,6,6,5,7,7,6,6,7
    .byte 7,6,6,7,8,6,7,8,5,6,6,5,5,7,7,6,7,7,6,6,7,6,5,6
    .byte 6,6,7,7,8,7,7,8,5,7,5,6,6,7,7,6,7,6,6,6,6,6,7,6
    .byte 7,7,6,6,7,4,5,6,6,4,5,5,7,7,5,6,7,7,7,7,7,5,6,5
    .byte 6,7,6,7,7,7,6,5,6,7,8,6,7,6,6,6,7,7,7,7,7,5,6,6
    .byte 5,6,5,5,5,6,6,7,7,6,6,5,5,6,6,7,6,6,7,7,7,7,7,7
    .byte 7,6,8,6,6,7,7,6,8,6,3,6,7,6,6,6,6,7,6,6,6,6,6,3
    .byte 7,7,7,6,7,6,7,8,6,6,6,7,6,7,7,5,7,7,7,7,7,6,5,6
    .byte 7,7,6,6,7,7,7,7,6,6,6,5,5,5,6,7,6,5,7,5,7,7,7,6
    .byte 6,7,7,7,7,7,6,7,7,7,7,7,5,6,6,5,7,7,4,6,5,5,6,7
    .byte 5,6,6,6,6,7,5,4,5,7,6,6,7,6,5,7,6,6,6,5,6,7,7,7
    .byte 5,7,7,7,7,7,7,6,7,6,7,5,7,6,7,7,7,6,5,5,6,6,6,5
    .byte 7,7,6,7,5,7,7,7,6,5,6,6,7,6,7,7,6,7,7,7,7,6,6,7
    .byte 6,7,6,4,5,5,6,5,7,6,7,5,6,6,7,6,4,5,6,7,6,6,5,6
    .byte 7,5,7,6,6,6,7,7,7,7,4,7,7,8,7,7,7,6,6,7,6,7,6,7
    .byte 6,7,7,6,6,6,6,6,6,6,6,7,7,7,4,6,7,7,7,6,7,7,7,7
    .byte 7,7,6,7,7,8,6,6,6,7,6,7,6,4,6,7,6,6,6,6,7,7,5,5
    .byte 6,6,4,7,7,7,6,7,6,7,7,6,4,7,7,5,6,7,6,6,4,7,6,5
    .byte 6,7,7,7,7,7,7,7,8,6,7,5,6,7,7,6,6,7,7,5,7,7,6,6
    .byte 5,7,7,6,5,5,6,7,6,7,7,7,6,7,7,6,6,7,6,6,7,7,6,5
    .byte 6,6,6,6,7,6,7,6,5,7,7,6,5,6,7,3,6,6,6,6,6,6,7,6
    .byte 6,6,5,7,3,7,6,6,7,7,7,7,7,7,7,6,7,7,7,7,4,7,8,7
    .byte 6,7,7,6,7,6,4,7,6,6,6,6,6,6,6,7,5,7,6,7,7,5,6,7
    .byte 6,8,7,5,6,7,7,5,7,7,6,4,6,6,6,7,6,7,5,7,7,6,7,6
    .byte 6,5,6,7,5,6,5,6,7,7,4,6,6,6,5,7,6,6,7,6,6,7,7,7
    .byte 7,7,7,6,6,7,6,7,7,7,7,5,8,6,6,5,6,6,5,7,7,7,6,4
    .byte 8,6,6,7,7,7,5,5,6,7,7,6,6,6,6,4,7,6,7,6,4,7,6,5
    .byte 6,7,6,6,7,6,5,7,7,5,5,6,5,7,6,6,6,7,5,6,6,5,6,6
    .byte 7,6,6,6,7,7,7,8,6,6,7,6,5,5,7,7,7,7,7,6,6,7,6,6
    .byte 6,5,7,6,7,7,7,5,7,5,7,7,6,7,8,6,6,4,7,7,7,7,7,6
    .byte 6,7,6,6,7,6,5,7,7,6,7,5,6,6,7,5,6,8,7,3,7,8,7,5
    .byte 5,7,6,6,6,7,4,6,6,7,6,7,7,7,6,6,6,6,7,6,6,8,6,7
    .byte 7,7,6,5,6,7,7,6,6,7,7,6,4,6,6,7,6,7,6,6,6,6,7,6
    .byte 8,7,6,7,6,7,6,6,6,5,4,7,6,7,6,6,6,7,6,5,6,8,6,6
    .byte 5,7,4,6,7,7,6,6,5,5,6,6,7,7,4,5,6,5,7,7,6,6,7,7
    .byte 6,7,7,7,6,6,7,6,7,4,7,7,5,6,6,6,7,7,6,7,7,5,6,6
    .byte 6,7,5,7,5,7,5,7,6,7,7,7,8,7,7,7,6,6,7,5,5,5,6,7
    .byte 7,6,6,6,7,4,6,7,7,7,4,6,7,7,7,6,5,5,7,6,6,5,6,6
    .byte 6,5,6,7,6,7,6,7,6,6,7,6,7,7,7,8,6,8,6,7,6,7,6,6
    .byte 7,7,7,7,7,6,6,6,5,6,6,7,6,6,7,5,6,6,8,8,6,6,6,7
    .byte 6,6,6,5,5,7,6,6,7,6,7,6,7,7,4,7,7,7,5,7,5,6,6,6
    .byte 7,4,7,5,6,6,5,6,7,5,6,6,6,7,7,8,7,7,7,7,5,6,7,7
    .byte 7,7,7,6,5,7,5,6,6,7,6,6,7,6,7,5,5,6,4,7,7,6,7,7
    .byte 7,4,7,7,7,6,6,7,7,7,6,6,7,6,4,7,6,6,5,7,6,6,5,5
    .byte 6,7,7,7,5,5,7,7,7,6,4,7,7,6,6,5,6,5,5,6,6,7,5,7
    .byte 7,6,8,8,7,7,7,7,6,7,6,6,6,7,5,6,7,6,6,6,7,5,6,6
    .byte 4,7,6,7,7,6,6,6,7,6,7,7,6,7,6,7,6,6,5,6,7,7,5,7
    .byte 6,7,4,6,6,7,7,5,7,6,6,6,5,5,5,6,5,6,6,7,6,5,6,6
    .byte 5,6,6,6,6,7,6,7,6,6,7,6,7,7,8,6,6,8,7,7,6,7,6,7
    .byte 7,6,7,7,7,7,6,4,6,5,6,5,6,6,6,6,6,6,6,7,7,7,7,7
    .byte 6,7,6,7,6,5,6,7,7,7,6,6,5,7,5,7,5,7,7,6,7,6,7,6
    .byte 4,7,6,6,4,7,7,5,6,7,4,6,6,6,6,7,6,6,7,6,6,7,7,7
    .byte 7,5,8,5,7,7,6,7,7,7,7,5,7,7,6,5,5,6,5,7,6,6,6,7
    .byte 6,7,6,8,7,5,7,6,7,6,7,6,5,6,6,4,7,7,5,6,7,6,7,6
    .byte 7,6,6,6,6,6,5,6,7,7,5,7,7,7,6,3,7,7,7,6,6,6,7,6
    .byte 6,7,6,6,7,7,6,8,6,7,7,7,7,6,7,6,7,8,7,6,7,7,7,6
    .byte 6,6,6,6,6,7,7,5,7,7,7,5,6,6,6,7,7,7,7,5,6,7,7,5
    .byte 5,5,6,6,7,6,6,7,5,7,7,7,6,6,7,5,6,7,6,6,6,6,6,7
    .byte 2,6,7,7,6,6,7,7,6,7,7,8,7,6,7,7,6,7,7,5,6,8,6,7
    .byte 6,8,6,6,6,7,6,6,6,6,7,7,7,7,6,6,6,6,6,7,6,6,7,7
    .byte 7,7,5,7,7,7,6,6,6,4,7,7,7,5,5,7,6,6,6,5,6,7,6,7
    .byte 6,7,6,6,6,6,6,5,6,5,5,5,6,6,6,5,7,7,5,7,6,7,7,6
    .byte 7,7,7,6,7,6,6,7,7,7,7,7,7,6,7,5,6,6,7,5,8,7,6,7
    .byte 7,7,3,5,5,7,6,5,8,7,7,7,6,8,5,7,5,6,8,7,4,6,6,5
    .byte 7,7,6,6,6,6,7,8,6,6,6,7,5,6,7,5,5,6,6,6,5,7,6,6
    .byte 7,6,6,6,6,5,6,6,7,8,7,7,6,7,6,6,7,7,6,6,7,6,6,7
    .byte 5,6,6,7,7,7,6,7,7,5,6,6,6,6,6,7,7,7,6,7,6,7,6,6
    .byte 6,6,6,6,6,7,5,6,7,7,6,7,6,5,6,5,7,5,6,7,7,8,4,8
    .byte 6,7,5,5,6,5,5,5,7,5,6,7,6,7,6,6,6,7,7,8,7,6,6,6
    .byte 7,7,7,6,7,5,6,6,6,6,6,5,6,7,7,7,6,7,6,5,7,7,7,6
    .byte 7,6,7,7,7,6,7,8,6,6,6,6,7,7,6,7,8,4,6,7,7,7,6,6
    .byte 5,7,7,4,6,6,6,7,7,6,5,6,6,8,6,6,7,7,5,5,5,7,6,7
    .byte 7,6,8,7,5,8,7,7,6,8,7,5,7,6,6,6,6,6,6,6,6,7,6,6
    .byte 6,6,7,7,7,7,7,6,4,5,7,5,7,7,7,7,7,6,6,5,7,3,6,7
    .byte 6,7,6,6,7,8,8,5,7,6,5,6,5,7,7,7,4,6,7,7,4,5,7,7
    .byte 7,6,7,5,5,5,8,7,7,7,7,8,7,6,6,7,6,7,7,7,7,5,7,7
    .byte 6,6,6,7,7,7,7,6,6,7,6,5,7,7,6,4,6,6,5,7,6,7,6,7
    .byte 7,6,7,7,7,5,5,6,6,6,7,6,6,7,7,6,7,5,7,6,5,6,6,7
    .byte 4,7,6,5,5,7,5,7,8,7,6,7,6,7,5,7,7,7,7,7,7,6,7,5
    .byte 6,7,7,7,7,6,5,7,6,5,6,7,7,6,7,5,7,8,6,6,7,6,6,7
    .byte 6,7,5,7,7,6,6,5,7,6,8,7,7,6,7,3,5,5,7,6,7,7,6,6
    .byte 6,6,7,6,6,6,4,6,5,7,6,7,7,5,7,6,7,7,6,6,5,6,3,7
    .byte 8,7,7,7,6,7,7,7,6,6,7,7,6,7,7,5,6,7,7,6,6,7,7,5
    .byte 7,6,5,7,7,5,7,6,6,6,6,6,6,6,7,7,7,7,7,7,7,6,7,7
    .byte 7,5,7,7,7,5,6,7,7,6,6,6,4,7,5,5,6,5,6,7,6,6,6,6
    .byte 7,6,6,6,7,6,6,8,7,5,7,6,6,5,6,7,6,6,7,6,7,5,7,7
    .byte 7,6,6,6,6,6,6,7,6,7,7,8,7,6,7,6,7,6,6,7,7,5,7,7
    .byte 7,5,6,5,6,5,5,7,7,7,5,4,6,5,6,6,6,7,5,6,7,5,7,5
    .byte 6,7,6,7,5,6,7,5,7,4,7,6,8,7,5,7,5,7,6,7,5,4,7,6
    .byte 7,7,5,7,7,7,6,7,6,5,7,7,7,6,6,6,6,7,6,7,7,6,8,7
    .byte 6,7,6,6,7,7,6,6,7,5,6,6,5,7,4,7,5,6,7,3,7,6,6,7
    .byte 6,6,6,6,6,6,7,6,5,5,7,7,7,7,6,6,7,5,7,6,7,7,7,8
    .byte 6,6,7,6,6,5,6,7,4,6,7,7,6,7,7,6,6,8,6,7,7,6,7,6
    .byte 8,5,7,7,6,7,7,6,7,6,6,5,7,7,7,7,6,7,6,5,5,5,6,6
    .byte 6,5,7,6,5,4,7,6,7,8,6,6,6,6,6,5,7,5,5,6,7,5,7,6
    .byte 6,6,7,6,5,7,6,7,7,7,7,6,5,6,6,6,5,6,6,7,7,7,7,6
    .byte 6,7,8,7,6,7,5,7,7,7,5,7,8,7,6,7,6,7,5,6,7,8,6,7
    .byte 7,7,6,6,4,6,3,6,6,6,5,8,7,4,6,6,7,6,7,7,6,7,6,5
    .byte 8,7,4,6,7,7,5,7,5,7,6,5,6,7,7,7,7,7,6,6,7,6,6,6
    .byte 7,5,7,6,6,6,6,7,6,6,7,7,7,6,7,7,6,7,6,6,8,7,7,6
    .byte 7,6,6,8,7,6,7,7,6,2,7,6,7,6,5,7,8,7,7,5,5,6,6,5
    .byte 7,7,6,4,7,7,6,6,6,6,6,5,6,6,6,6,6,7,7,6,6,6,7,7
    .byte 7,6,8,7,6,7,6,5,6,7,6,7,6,7,5,6,6,6,7,7,6,7,7,6
    .byte 5,7,6,6,5,7,7,7,8,5,7,5,7,7,7,6,7,6,5,5,6,6,6,6
    .byte 6,6,7,7,4,8,6,6,5,5,7,7,7,6,7,6,7,7,7,6,6,6,6,6
    .byte 4,6,6,6,7,7,5,7,8,8,6,5,5,5,7,6,5,6,7,7,7,7,7,3
    .byte 6,7,7,5,6,8,6,7,7,7,5,7,7,7,7,7,7,7,6,6,6,7,6,7
    .byte 7,7,6,5,5,5,7,6,6,7,5,6,6,6,5,5,5,6,8,7,6,7,8,4
    .byte 6,5,7,6,6,6,5,7,6,6,6,7,7,7,6,7,7,7,7,6,6,6,6,6
    .byte 5,6,6,6,6,7,5,6,6,6,7,6,7,7,7,6,7,7,7,6,6,6,7,6
    .byte 8,7,7,7,6,6,6,7,7,6,7,6,6,5,6,6,6,7,6,5,6,5,7,6
    .byte 6,5,7,5,5,7,6,7,6,8,8,4,6,6,5,6,6,6,6,7,7,7,7,6
    .byte 7,6,6,7,6,6,6,7,7,6,5,5,5,6,6,7,7,6,7,7,6,6,6,7
    .byte 7,7,7,7,6,6,8,7,7,7,6,6,7,6,7,7,6,6,7,6,4,4,6,6
    .byte 6,6,7,5,7,7,5,6,6,7,5,7,8,6,5,5,7,6,7,6,6,6,7,7
    .byte 6,6,7,7,6,6,7,6,5,4,8,7,6,7,6,7,6,7,6,7,6,5,7,6
    .byte 7,5,7,7,7,7,7,7,7,6,6,8,6,5,8,7,8,7,6,7,7,7,6,7
    .byte 7,6,7,5,7,6,7,6,6,5,6,6,7,5,7,6,7,5,6,7,7,7,6,8
    .byte 6,7,6,6,7,4,7,7,6,7,7,7,7,7,8,6,6,5,7,6,7,6,6,6
    .byte 6,5,7,6,7,6,6,6,6,6,7,6,6,7,7,6,8,7,6,6,7,6,6,6
    .byte 7,6,7,5,5,7,8,6,6,6,7,6,7,6,6,7,5,5,7,6,6,6,7,5
    .byte 4,5,5,6,5,7,7,7,5,7,6,5,6,6,6,7,5,7,6,7,7,5,7,6
    .byte 6,6,6,7,7,7,7,5,6,7,7,7,4,7,7,7,6,7,7,7,6,5,7,7
    .byte 6,7,7,6,7,6,7,6,6,7,7,7,7,6,6,7,7,7,7,8,6,7,6,6
    .byte 6,5,7,6,4,7,6,6,4,5,5,6,6,6,7,6,5,7,7,8,5,5,5,6
    .byte 7,7,7,6,8,6,6,7,7,6,6,7,4,6,7,7,7,6,8,6,7,7,6,5
    .byte 5,7,6,6,4,6,8,6,7,7,7,7,5,7,7,7,5,6,7,7,7,6,6,7
    .byte 7,7,5,7,7,6,8,7,7,4,6,6,6,7,7,7,6,7,6,4,5,6,6,6
    .byte 7,6,7,5,7,6,6,6,6,7,6,7,6,7,7,5,6,7,7,5,6,5,7,7
    .byte 6,7,7,6,7,6,5,6,6,7,6,6,6,7,5,6,7,7,7,7,7,7,6,6
    .byte 6,7,5,7,7,8,7,7,7,5,6,7,7,7,5,6,6,7,6,3,7,7,6,7
    .byte 7,7,4,6,6,5,6,5,5,7,7,6,6,7,5,6,4,7,7,7,6,6,6,7
    .byte 6,6,7,7,6,6,7,7,5,7,7,6,6,7,7,6,6,6,7,4,7,6,7,6
    .byte 7,6,7,7,8,7,5,7,7,6,6,7,6,7,8,7,7,7,6,7,6,5,8,6
    .byte 7,7,7,5,6,5,6,6,7,7,5,5,6,6,6,7,4,7,6,6,6,6,6,7
    .byte 6,7,4,6,6,6,6,6,7,5,7,7,6,6,6,5,6,7,7,7,7,7,7,6
    .byte 6,5,7,6,7,5,6,6,7,6,8,8,6,8,7,6,6,5,7,6,4,7,6,7
    .byte 7,7,7,7,6,5,7,5,6,7,7,7,7,5,6,6,7,6,6,7,6,7,4,7
    .byte 7,7,5,4,7,7,7,7,6,7,6,6,7,8,6,6,7,6,5,6,6,6,7,6
    .byte 7,6,7,7,7,7,6,5,7,7,6,6,7,6,7,6,5,4,8,7,7,7,6,6
    .byte 6,6,7,7,5,7,7,6,7,7,6,7,7,6,6,7,7,7,7,7,6,4,7,5
    .byte 5,7,7,5,5,6,6,7,6,7,4,7,6,6,4,5,7,7,6,5,5,6,7,7
    .byte 6,6,6,6,5,7,6,6,6,6,7,6,7,7,7,6,7,5,7,7,6,7,6,7
    .byte 4,7,5,6,7,8,7,7,7,6,5,6,7,7,6,7,7,7,6,6,6,6,7,6
    .byte 7,6,7,6,5,7,7,4,6,7,5,7,7,6,6,5,5,6,7,5,6,7,7,5
    .byte 7,7,7,5,6,6,6,5,7,7,6,7,5,6,5,7,5,5,6,6,6,7,6,5
    .byte 6,7,6,6,6,7,7,5,8,6,6,5,6,7,7,7,7,8,6,7,6,6,7,7
    .byte 7,5,8,6,7,6,5,7,7,7,6,8,5,7,7,6,5,6,7,6,6,6,6,6
    .byte 5,5,6,7,5,7,6,4,7,7,7,7,4,5,5,7,6,7,6,7,7,5,6,6
    .byte 6,6,7,6,7,7,6,6,7,6,6,7,8,7,6,7,7,7,5,6,5,7,7,7
    .byte 7,7,7,5,7,8,7,6,6,7,7,7,7,6,7,6,6,6,7,7,7,7,6,7
    .byte 5,7,6,7,8,7,7,3,7,7,6,5,5,6,8,7,5,7,6,7,6,6,7,3
    .byte 8,7,6,7,7,7,6,7,7,6,6,5,6,7,7,7,5,5,7,6,6,7,6,6
    .byte 5,7,7,8,7,7,6,7,6,6,6,7,4,6,7,7,6,7,6,7,7,7,7,6
    .byte 6,7,7,6,5,7,7,7,6,6,6,7,7,6,7,7,5,6,6,6,6,7,7,6
    .byte 6,7,7,6,7,7,7,6,3,7,6,8,6,7,6,6,6,6,7,5,5,7,5,7
    .byte 6,5,5,7,5,6,7,8,5,6,7,7,7,7,6,6,8,6,6,7,6,7,5,6
    .byte 7,6,7,6,6,7,7,7,6,7,6,6,7,6,5,7,7,5,5,7,6,4,7,8
    .byte 7,6,7,5,6,6,7,6,7,7,7,6,6,7,7,5,6,4,6,7,7,6,6,7
    .byte 6,5,7,5,6,5,6,6,6,5,6,5,6,6,7,7,7,7,7,6,5,6,7,7
    .byte 6,6,5,6,7,6,6,7,5,6,7,7,7,6,6,4,7,7,7,6,7,6,6,5
    .byte 7,6,7,6,6,7,7,5,7,6,7,7,5,6,6,5,7,6,7,7,6,7,6,7
    .byte 6,5,7,6,6,7,8,7,6,6,7,4,6,5,5,5,7,7,6,3,7,6,7,7
    .byte 7,7,7,7,7,6,7,6,7,5,6,6,7,6,7,7,7,6,7,7,7,7,7,7
    .byte 7,6,6,6,6,7,5,7,6,7,7,6,7,6,6,7,6,5,7,6,5,7,5,6
    .byte 5,7,7,7,5,6,7,6,6,7,6,5,7,7,5,6,7,6,4,7,7,6,6,6
    .byte 5,6,6,7,6,6,6,7,6,6,7,6,6,6,7,7,6,7,6,6,7,6,7,7
    .byte 4,6,7,5,6,6,6,5,7,8,7,7,5,5,6,7,6,6,7,8,6,7,6,6
    .byte 7,6,7,7,7,5,6,4,7,6,6,7,6,6,6,7,7,5,6,6,5,7,7,5
    .byte 5,7,6,5,5,5,6,7,6,6,6,6,7,6,5,7,5,7,7,6,7,7,7,7
    .byte 7,7,5,7,7,6,6,6,6,6,7,6,6,6,7,6,8,7,6,6,8,7,6,6
    .byte 7,7,6,6,7,7,3,7,7,7,7,7,6,6,7,6,6,7,6,7,6,6,7,6
    .byte 5,6,5,6,6,6,7,7,7,7,5,7,5,7,6,6,5,7,4,6,6,7,6,6
    .byte 6,6,6,7,7,7,7,7,7,6,6,6,6,7,7,7,6,7,6,5,5,6,6,7
    .byte 6,7,7,7,7,8,6,5,6,7,7,6,7,6,6,6,5,6,6,6,8,7,6,6
    .byte 6,7,6,4,6,7,6,7,7,7,6,7,7,4,6,5,7,7,6,7,5,7,6,6
    .byte 7,5,5,5,6,5,6,6,7,6,6,7,7,6,7,7,7,6,6,7,6,7,5,7
    .byte 8,5,7,5,6,7,6,6,6,6,7,7,7,7,7,7,6,4,5,7,7,7,6,6
    .byte 7,6,5,7,8,5,7,6,6,5,7,6,7,6,7,6,6,6,4,7,7,7,7,5
    .byte 7,6,6,5,6,6,5,7,6,6,6,7,5,6,5,7,7,5,7,6,6,7,7,6
    .byte 6,7,5,7,8,7,7,6,7,5,6,7,7,6,6,7,6,6,7,7,8,7,6,6
    .byte 5,7,6,6,5,7,7,5,7,7,7,6,7,6,7,5,5,6,6,6,8,7,4,7
    .byte 7,7,7,7,5,6,7,6,6,7,7,4,5,5,5,7,6,5,6,8,6,6,5,5
    .byte 7,6,7,6,6,7,7,7,8,6,6,6,7,7,7,6,6,8,6,7,6,6,6,7
    .byte 7,5,7,7,7,8,7,5,7,7,7,5,6,7,6,6,6,7,7,6,7,7,7,7
    .byte 4,6,5,6,7,7,5,7,6,7,6,6,6,6,6,6,6,7,7,5,6,5,6,5
    .byte 5,6,7,7,5,7,6,4,5,6,6,7,5,7,7,7,7,7,7,6,6,7,7,8
    .byte 6,7,7,7,7,5,5,7,7,6,6,7,7,7,7,6,6,7,7,6,6,6,6,6
    .byte 6,7,7,6,6,8,7,7,8,5,6,5,5,7,7,5,7,6,6,7,6,6,5,7
    .byte 6,6,7,7,5,6,6,5,5,6,6,6,7,6,7,4,6,5,6,7,6,7,6,7
    .byte 8,6,6,6,7,6,8,7,8,7,5,7,6,7,6,8,6,7,8,7,6,8,8,7
    .byte 7,7,6,6,6,7,6,6,7,6,6,7,7,7,5,8,6,6,4,5,6,7,6,7
    .byte 7,5,8,7,7,7,6,6,6,8,5,5,7,8,5,6,6,6,6,6,6,7,7,6
    .byte 6,7,4,7,7,7,6,6,7,6,6,7,7,7,7,7,7,6,6,6,6,7,5,6
    .byte 6,5,7,7,6,7,7,7,8,7,6,7,6,6,5,6,7,7,6,6,7,6,6,6
    .byte 7,7,5,6,6,7,6,6,6,7,5,8,6,5,5,4,7,6,8,7,5,8,6,7
    .byte 6,6,5,4,6,6,7,7,6,4,6,6,7,7,7,7,6,6,7,6,6,7,8,7
    .byte 7,7,6,7,7,7,7,5,7,6,6,5,7,7,6,7,7,7,6,6,7,6,6,6
    .byte 7,6,7,7,6,6,6,4,7,5,6,7,7,6,6,6,6,6,5,5,7,6,6,7
    .byte 6,6,6,7,5,7,6,7,6,6,6,5,6,5,6,7,6,6,6,6,6,6,6,6
    .byte 7,5,6,7,7,7,7,8,7,7,7,5,6,8,6,6,6,5,5,8,6,6,6,8
    .byte 7,8,7,7,5,7,7,7,6,6,6,6,7,7,7,4,8,8,6,7,7,6,7,7
    .byte 7,7,7,7,6,6,6,7,5,4,5,5,7,6,7,7,6,6,7,6,7,4,6,5
    .byte 7,6,7,5,6,7,7,6,6,6,7,5,6,6,5,7,5,7,7,7,7,7,5,8
    .byte 6,7,7,5,6,6,6,6,5,7,5,7,7,7,7,6,6,5,7,6,7,7,7,7
    .byte 7,7,6,7,6,6,7,7,6,7,5,8,6,7,7,5,6,6,7,7,6,7,6,6
    .byte 7,7,6,5,7,7,4,5,5,6,8,6,5,7,7,7,4,6,7,6,6,6,7,6
    .byte 7,6,6,8,7,7,4,6,6,7,7,6,7,6,6,7,7,7,7,6,7,6,7,7
    .byte 6,7,6,5,6,6,7,6,6,7,6,7,6,5,5,7,6,6,7,5,6,6,7,7
    .byte 8,5,6,7,6,6,7,6,6,7,7,5,6,7,6,5,6,7,5,6,6,7,6,5
    .byte 6,7,6,5,5,7,6,7,6,7,6,6,6,7,7,5,7,5,6,8,6,6,6,6
    .byte 6,6,7,7,6,6,5,6,7,8,6,7,6,6,6,6,6,6,7,6,7,7,6,6
    .byte 6,7,7,6,6,6,5,7,7,7,7,5,7,5,6,6,6,6,5,6,7,7,6,7
    .byte 6,7,5,5,4,5,6,4,6,7,6,6,7,6,6,6,7,4,7,6,8,7,7,7
    .byte 6,7,5,7,7,7,7,6,6,6,6,7,7,6,7,7,7,7,6,7,7,7,7,6
    .byte 7,6,5,5,7,7,4,7,7,7,7,7,6,7,6,7,7,7,6,7,5,6,7,7
    .byte 5,6,5,6,7,6,6,6,8,7,5,8,5,6,5,5,7,7,7,5,6,7,6,7
    .byte 6,5,6,6,7,7,8,7,7,6,7,6,6,7,7,5,6,8,6,6,8,5,7,7
    .byte 6,7,7,7,7,7,7,5,6,7,6,6,7,7,7,7,6,6,8,4,7,6,6,5
    .byte 7,7,6,6,7,8,7,7,8,7,6,4,7,6,7,7,7,7,7,6,6,7,6,5
    .byte 5,6,6,7,6,6,7,5,7,5,7,7,6,7,6,5,6,6,6,7,7,6,7,6
    .byte 7,6,6,6,5,6,7,6,7,7,6,7,6,5,6,6,6,3,6,6,6,7,7,7
    .byte 6,7,7,4,7,6,6,7,6,7,7,7,6,7,7,7,7,7,6,5,5,7,7,6
    .byte 7,6,5,5,7,7,7,7,7,3,7,7,7,6,6,6,7,6,7,7,5,6,7,5
    .byte 7,6,6,8,6,7,8,5,6,6,7,7,7,6,5,6,6,6,7,6,6,4,7,7
    .byte 6,6,5,5,7,7,7,6,7,7,7,7,6,6,6,7,5,5,8,6,6,6,7,7
    .byte 6,6,7,7,6,6,6,7,6,6,5,6,7,6,7,7,7,7,6,4,6,6,7,7
    .byte 7,7,7,6,7,7,6,6,6,7,7,6,5,8,7,6,8,8,7,5,6,5,7,6
    .byte 7,6,7,8,5,7,7,6,5,3,6,7,7,4,7,6,8,7,6,6,6,5,6,6
    .byte 7,6,7,5,7,7,7,6,7,6,7,5,7,6,6,7,6,5,5,6,6,7,6,6
    .byte 6,6,7,5,6,5,7,6,7,7,7,6,5,7,7,5,6,8,6,7,6,7,6,7
    .byte 7,7,6,5,7,7,7,6,5,7,6,7,7,6,7,6,4,5,5,4,6,7,6,7
    .byte 6,6,7,7,6,7,6,7,5,7,6,6,7,7,7,7,8,6,6,7,6,6,6,5
    .byte 6,7,5,7,7,4,7,7,7,7,6,7,7,5,5,6,6,7,7,7,7,7,7,7
    .byte 7,7,5,7,6,6,6,7,6,7,8,8,7,5,7,6,7,6,7,7,8,8,6,7
    .byte 6,6,4,4,7,6,8,4,6,6,8,7,5,6,7,6,6,7,7,6,7,5,7,7
    .byte 8,5,8,5,6,6,7,7,6,7,7,6,6,5,6,6,6,6,7,6,7,4,7,6
    .byte 6,6,6,5,7,6,8,7,5,7,6,6,6,6,6,8,6,7,7,6,6,6,6,7
    .byte 6,6,5,6,7,7,7,7,6,4,6,6,5,6,4,6,6,7,7,7,6,7,6,8
    .byte 7,6,6,6,6,6,7,7,6,7,7,7,7,5,8,7,7,5,6,6,7,6,5,5
    .byte 7,6,6,6,6,7,4,7,6,8,7,6,7,7,6,6,7,7,5,7,7,6,6,6
    .byte 6,7,6,7,6,7,5,7,7,7,6,5,8,7,7,7,6,7,6,5,5,6,3,5
    .byte 7,6,6,6,7,8,6,6,7,5,7,5,8,6,5,7,7,7,7,7,7,6,8,5
    .byte 7,6,5,7,7,6,6,7,5,7,7,6,7,6,7,6,6,6,6,7,6,7,5,7
    .byte 5,7,8,7,8,5,4,5,6,6,6,7,7,7,7,7,5,6,6,5,6,6,7,6
    .byte 6,7,7,7,4,6,6,7,4,6,6,6,7,6,7,7,6,7,5,6,6,7,7,6
    .byte 7,7,6,7,8,7,7,8,6,7,5,5,7,7,7,6,6,6,5,6,6,7,7,7
    .byte 6,5,7,6,6,6,7,5,6,6,6,5,6,6,6,7,6,7,5,5,6,7,7,7
    .byte 7,8,7,6,6,7,6,6,6,6,7,6,6,6,7,7,5,7,6,5,2,6,6,6
    .byte 6,6,7,6,8,7,7,6,6,6,7,7,7,7,7,6,6,6,8,6,6,6,6,7
    .byte 5,7,7,7,5,7,7,7,7,6,6,7,7,6,5,6,4,7,6,7,6,5,7,6
    .byte 7,6,7,6,6,7,7,7,7,7,8,7,7,5,7,5,7,6,7,7,6,7,6,6
    .byte 7,5,7,5,4,3,6,6,6,7,6,7,5,7,7,6,6,6,7,7,7,7,7,7
    .byte 6,7,6,7,7,6,6,6,7,6,7,6,6,6,6,6,6,7,5,6,7,7,5,6
    .byte 6,5,7,5,7,6,6,7,5,7,5,7,5,6,7,6,7,6,7,8,8,7,6,7
    .byte 6,7,7,7,7,6,6,6,6,7,5,7,6,5,3,5,6,7,7,5,8,6,7,7
    .byte 7,6,6,7,6,7,7,8,7,7,6,5,7,6,6,7,6,6,6,6,7,7,6,7
    .byte 6,7,7,6,6,7,6,6,6,7,5,6,6,6,6,5,7,6,6,6,8,6,6,6
    .byte 6,6,7,7,7,7,6,6,7,5,7,7,6,7,5,6,5,7,7,4,8,5,5,3
    .byte 6,5,6,7,6,7,6,7,7,7,7,5,6,6,7,7,8,7,6,7,6,8,7,5
    .byte 7,5,7,6,6,6,7,6,7,7,7,6,6,6,7,6,7,5,7,4,6,6,6,8
    .byte 6,7,6,5,6,6,7,7,7,7,7,6,6,6,7,6,4,6,6,7,6,7,6,7
    .byte 7,4,6,6,7,4,6,7,5,6,7,7,6,7,6,5,6,7,7,7,7,7,6,7
    .byte 7,7,7,6,7,6,7,6,4,6,7,7,7,6,6,5,6,7,6,7,6,5,7,6
    .byte 7,6,7,7,6,5,6,6,7,4,7,7,5,7,6,7,7,7,8,7,7,4,7,7
    .byte 7,6,6,7,6,7,7,5,7,6,5,5,6,4,6,7,5,6,6,7,7,7,7,7
    .byte 6,6,6,8,6,6,7,7,7,6,7,7,6,7,6,7,6,4,7,7,6,7,7,5
    .byte 7,7,7,7,5,6,4,7,7,6,6,6,5,6,6,7,7,5,7,6,6,7,6,6
    .byte 7,6,7,7,6,7,7,7,6,7,6,6,7,6,7,7,7,6,3,7,7,5,6,5
    .byte 6,6,6,6,7,7,7,6,7,6,5,6,7,6,6,8,7,6,7,6,7,7,6,7
    .byte 6,6,6,7,6,7,6,6,6,6,6,7,6,6,6,7,5,5,5,7,7,7,7,6
    .byte 7,8,7,6,6,6,6,6,6,6,8,7,6,7,8,7,4,7,5,7,5,7,6,8
    .byte 7,6,6,6,5,5,4,6,6,7,3,7,6,7,7,6,5,7,6,7,6,7,7,7
    .byte 5,7,6,7,6,7,6,7,6,6,6,6,7,7,6,6,6,7,6,6,5,7,5,6
    .byte 5,6,6,7,6,6,7,6,6,6,7,7,5,6,7,6,7,5,7,7,7,7,7,7
    .byte 5,7,6,6,6,6,7,7,7,7,6,6,6,5,4,6,4,6,7,6,7,5,7,8
    .byte 6,6,7,6,7,6,7,7,6,6,6,7,7,7,7,5,7,6,6,5,5,6,7,6
    .byte 7,6,5,6,7,6,6,6,7,7,5,6,6,7,6,7,7,7,7,7,7,6,7,6
    .byte 6,7,5,6,7,6,7,7,8,6,5,7,6,6,6,7,6,7,7,5,7,7,6,4
    .byte 4,6,7,7,4,7,5,7,6,6,6,6,6,6,7,7,6,7,4,7,6,7,6,7
    .byte 6,6,6,7,6,5,6,7,6,5,6,7,7,5,6,7,6,7,4,6,7,7,5,7
    .byte 6,7,5,8,8,4,7,6,6,6,5,6,8,5,6,8,6,7,7,6,6,7,6,6
    .byte 7,7,6,6,6,6,3,6,7,6,7,5,6,6,7,6,7,6,6,6,7,7,6,6
    .byte 7,6,6,7,6,5,7,7,8,7,6,7,7,6,6,7,7,7,6,6,6,6,7,6
    .byte 7,6,7,6,6,7,7,7,6,7,5,7,6,7,8,6,8,6,5,6,5,7,7,7
    .byte 7,6,7,6,6,7,7,5,5,7,6,6,6,6,7,6,4,5,7,7,4,5,7,6
    .byte 6,6,7,7,7,7,5,7,7,7,7,6,6,6,6,7,7,7,7,7,7,7,6,5
    .byte 7,6,7,7,6,6,4,7,7,7,8,7,6,6,7,5,6,7,5,7,6,7,8,7
    .byte 6,5,7,7,7,7,6,5,8,7,7,7,6,7,5,5,5,4,7,6,7,7,6,7
    .byte 5,7,7,5,6,5,6,6,7,6,6,7,7,4,7,5,6,6,6,7,6,7,6,5
    .byte 7,6,7,6,7,7,5,7,6,7,7,6,6,7,8,6,5,7,7,6,6,5,7,7
    .byte 7,7,4,7,4,7,8,7,7,6,7,5,7,7,6,6,7,6,7,7,5,5,7,7
    .byte 6,4,6,6,6,7,5,7,7,7,6,6,6,6,5,5,7,7,6,6,6,6,7,7
    .byte 6,7,6,7,5,7,7,4,7,7,7,6,8,7,6,7,6,6,6,8,7,7,7,8
    .byte 6,5,7,7,7,6,6,6,7,5,6,7,6,7,5,6,7,7,6,4,6,7,6,7
    .byte 7,7,6,7,7,6,7,6,6,3,7,6,7,5,7,6,7,6,7,6,7,5,5,6
    .byte 8,5,7,7,7,6,7,5,5,5,6,6,7,7,7,5,5,5,7,7,5,6,8,7
    .byte 7,6,6,8,7,5,7,7,7,5,8,5,7,7,7,5,6,7,7,6,7,6,6,6
    .byte 7,6,7,5,7,6,6,7,7,7,6,6,6,7,7,5,7,7,5,6,4,6,4,7
    .byte 6,5,7,7,7,7,7,4,6,7,7,6,6,6,6,7,6,7,5,7,6,7,4,6
    .byte 6,7,5,7,7,6,8,7,6,6,6,5,7,7,7,6,8,7,6,6,6,6,5,7
    .byte 5,7,7,6,7,6,5,5,6,6,7,6,7,6,6,7,6,6,6,5,6,7,6,7
    .byte 7,6,7,6,5,6,5,5,7,7,6,6,6,6,6,7,7,7,6,6,5,4,6,6
    .byte 7,5,7,6,7,6,7,7,6,6,6,6,8,7,7,5,6,6,7,7,6,6,7,6
    .byte 7,6,6,6,6,7,6,8,6,7,7,6,8,6,6,6,6,6,7,5,5,7,7,6
    .byte 6,7,6,6,7,4,8,6,7,6,7,7,5,6,6,4,4,6,7,6,8,6,7,7
    .byte 6,6,6,7,5,4,6,5,6,6,8,7,6,7,7,8,4,7,6,6,6,6,6,8
    .byte 7,6,6,7,6,7,6,7,7,6,6,7,6,6,7,8,7,7,7,7,7,6,6,6
    .byte 5,7,6,6,6,7,7,6,8,7,7,6,6,7,5,7,6,7,7,7,7,5,6,7
    .byte 5,5,6,6,7,5,7,6,7,7,5,7,7,7,5,6,6,6,7,7,6,6,7,5
    .byte 6,6,5,5,6,7,7,7,7,6,7,5,7,7,6,6,6,6,6,6,7,6,6,7
    .byte 7,7,6,5,7,8,7,7,4,5,4,7,6,6,7,7,8,7,7,6,5,6,6,7
    .byte 5,7,7,7,6,7,7,5,7,6,7,5,6,7,7,8,6,6,7,6,7,6,6,5
    .byte 6,4,5,6,7,7,6,7,7,7,7,6,6,6,5,7,7,6,7,6,6,6,7,6
    .byte 6,7,7,6,7,7,7,7,6,6,7,7,7,6,6,5,6,6,6,7,7,7,6,6
    .byte 6,7,6,7,7,7,6,6,6,6,6,7,7,5,7,6,5,5,6,7,7,7,4,7
    .byte 6,7,5,5,6,5,7,5,6,6,7,6,6,6,6,5,7,6,6,5,7,6,7,6
    .byte 7,7,6,7,6,6,6,6,7,7,6,6,5,7,6,7,8,7,7,6,7,4,7,8
    .byte 6,7,5,7,6,7,8,7,7,5,7,7,8,7,7,8,7,7,7,6,6,6,6,7
    .byte 7,5,7,7,6,7,5,6,6,6,7,7,7,6,6,6,7,7,7,6,7,6,6,7
    .byte 6,5,6,8,7,5,6,7,7,7,7,7,7,7,7,7,5,6,7,7,6,7,6,7
    .byte 7,7,8,8,6,7,6,6,7,6,6,6,7,7,5,5,7,6,7,6,7,7,7,7
    .byte 5,6,7,7,7,5,6,7,7,5,6,7,6,6,7,6,6,5,5,6,7,7,6,5
    .byte 7,7,7,5,6,7,7,6,7,6,7,3,5,6,5,7,6,6,6,6,7,7,6,6
    .byte 7,7,7,7,7,6,6,8,5,7,7,7,7,6,7,6,6,6,5,5,6,6,7,7
    .byte 5,7,7,7,5,6,6,7,6,5,7,7,6,7,6,7,6,6,5,5,6,7,4,7
    .byte 6,4,6,6,5,7,6,6,5,7,7,6,6,6,7,7,6,7,4,7,4,5,5,5
    .byte 6,6,7,7,7,6,6,7,5,7,6,6,7,7,7,6,7,6,6,7,7,7,7,8
    .byte 5,7,7,6,7,6,6,6,7,6,7,7,7,7,7,5,7,4,7,7,8,7,4,7
    .byte 6,7,6,6,4,7,8,5,7,6,6,6,5,6,6,7,7,6,7,6,6,6,6,7
    .byte 6,6,6,6,7,5,7,7,6,6,5,7,6,6,5,7,7,6,7,6,5,7,7,7
    .byte 7,7,6,4,7,6,7,7,7,4,6,7,6,7,7,6,7,5,7,7,5,7,6,7
    .byte 5,7,5,8,6,8,6,6,7,7,6,6,7,6,6,7,6,6,6,5,4,4,6,6
    .byte 7,6,7,6,7,8,7,6,6,7,4,6,7,5,6,6,7,6,7,6,6,6,6,6
    .byte 7,7,6,7,6,5,6,7,6,7,7,7,5,7,6,7,7,7,7,7,6,7,6,5
    .byte 6,6,5,6,5,7,7,7,6,7,7,5,7,7,7,5,6,7,6,7,6,5,6,7
    .byte 6,6,8,6,6,4,5,5,5,7,6,7,6,7,7,5,7,8,7,5,5,5,7,6
    .byte 7,6,7,8,4,6,6,5,6,6,7,7,6,6,5,7,6,7,7,6,7,6,7,6
    .byte 7,6,6,7,6,6,6,7,6,6,6,7,6,7,7,6,7,8,7,6,5,6,7,6
    .byte 6,6,6,6,7,7,7,6,6,6,5,6,6,5,6,5,7,5,6,6,7,8,5,7
    .byte 6,7,6,7,6,6,6,5,7,7,6,6,6,6,7,6,6,6,6,7,7,7,7,4
    .byte 8,7,7,7,7,7,7,6,6,8,6,6,3,8,7,7,8,5,7,6,6,7,8,6
    .byte 6,8,7,6,6,5,7,5,6,7,7,6,5,7,8,7,4,5,6,7,7,6,5,7
    .byte 6,7,6,7,5,6,6,7,7,6,6,7,5,6,7,6,6,5,7,6,5,5,7,7
    .byte 8,6,6,7,7,6,6,6,7,7,8,7,7,8,7,6,7,7,7,7,7,6,7,6
    .byte 5,7,7,5,7,5,7,6,7,7,6,7,7,6,7,7,6,6,7,7,7,7,6,7
    .byte 6,6,5,5,7,7,7,5,7,4,7,6,5,7,6,7,5,7,7,5,6,6,7,6
    .byte 7,6,6,7,5,6,7,6,5,7,6,7,6,7,7,7,5,7,7,7,7,6,7,6
    .byte 5,7,6,7,5,6,7,7,6,7,6,6,7,6,6,7,7,7,6,6,7,7,7,7
    .byte 6,7,6,7,7,7,5,6,7,5,5,6,6,5,7,7,6,6,6,7,6,6,6,7
    .byte 6,6,6,4,6,7,6,6,7,6,7,5,7,7,7,6,5,6,7,6,7,6,7,7
    .byte 6,7,4,8,7,7,6,5,7,6,7,7,7,6,7,6,6,7,7,6,6,6,5,6
    .byte 6,6,7,7,7,6,6,6,8,6,6,6,6,7,7,6,6,7,5,5,6,5,7,5
    .byte 6,6,7,7,5,7,7,6,6,7,7,7,6,5,5,7,6,6,6,6,5,7,6,7
    .byte 6,7,4,5,7,7,6,7,7,6,5,7,7,6,6,6,7,6,7,6,6,7,6,6
    .byte 5,7,7,6,5,7,6,7,5,7,7,8,7,5,6,7,6,6,7,8,7,7,6,6
    .byte 7,6,5,4,7,6,6,6,6,6,7,6,6,6,6,6,5,7,7,5,6,6,7,6
    .byte 7,5,6,6,7,7,6,7,6,4,6,6,7,6,6,6,7,8,7,6,6,8,6,6
    .byte 6,6,7,5,7,5,7,7,6,6,7,7,7,7,4,6,4,6,7,6,7,6,8,6
    .byte 6,7,7,7,7,7,7,7,6,6,6,7,5,5,6,6,7,6,5,8,7,8,5,7
    .byte 5,5,5,6,6,7,6,6,5,7,6,6,6,6,6,6,6,7,6,5,6,6,7,6
    .byte 8,6,7,7,7,6,5,7,8,7,7,7,7,4,6,7,7,5,4,7,7,6,6,6
    .byte 6,6,6,7,7,7,5,7,7,7,8,7,7,7,7,7,7,7,5,6,7,6,5,5
    .byte 7,5,7,7,5,6,7,7,7,7,3,5,6,7,6,5,6,7,6,6,7,6,7,5
    .byte 6,5,5,6,6,5,8,7,6,7,7,7,7,7,5,7,7,7,6,8,7,6,6,7
    .byte 7,5,7,6,6,6,4,6,6,4,7,6,7,7,7,7,6,6,6,7,7,7,6,7
    .byte 6,7,7,6,7,6,6,5,5,7,5,7,7,6,6,5,7,7,5,6,5,5,5,7
    .byte 7,6,7,7,5,7,6,6,6,6,6,7,7,7,5,7,7,7,7,7,7,6,7,6
    .byte 7,7,7,6,6,7,5,5,6,6,6,6,5,6,6,6,6,5,6,7,6,6,7,7
    .byte 8,6,7,6,7,5,6,6,8,7,5,7,7,7,6,6,5,7,7,4,7,6,5,5
    .byte 4,6,6,7,7,5,7,7,5,6,6,6,6,7,7,5,7,6,6,6,6,6,6,7
    .byte 7,5,6,6,7,6,7,6,6,7,8,7,6,7,5,4,6,7,7,7,7,7,6,5
    .byte 7,5,5,6,6,4,6,6,6,7,7,7,7,7,6,7,6,8,6,6,6,6,7,7
    .byte 6,6,7,5,7,7,6,6,5,4,4,6,7,6,7,7,7,7,5,8,7,7,4,6
    .byte 6,8,5,6,6,7,7,5,7,6,6,5,6,6,8,6,6,6,6,6,7,6,6,6
    .byte 6,7,6,7,7,7,6,5,6,6,6,6,7,6,6,7,7,6,6,7,7,7,7,6
    .byte 5,7,7,6,7,6,7,7,8,7,6,7,5,6,6,7,4,6,6,6,5,5,7,6
    .byte 7,6,7,6,6,6,6,7,6,6,6,7,7,5,6,6,7,6,5,6,7,6,7,7
    .byte 7,8,5,8,7,7,6,6,7,6,6,6,7,6,6,3,6,7,5,6,6,7,7,5
    .byte 7,6,5,7,6,7,6,7,6,7,6,7,7,7,7,7,7,7,7,6,6,6,6,6
    .byte 7,4,5,5,6,6,6,5,7,6,7,7,7,6,6,7,5,5,7,6,6,7,7,6
    .byte 7,7,7,6,6,7,7,7,5,7,7,6,7,7,6,6,6,7,6,6,6,7,7,6
    .byte 6,6,6,5,5,6,6,6,7,7,7,6,5,7,6,7,7,7,6,7,7,6,7,6
    .byte 7,6,7,6,6,6,6,7,7,7,3,7,7,7,4,5,6,6,6,5,7,7,7,6
    .byte 7,6,7,5,6,6,7,5,6,6,7,6,6,7,7,6,7,6,7,7,6,7,6,6
    .byte 5,6,6,7,7,7,6,6,6,7,6,6,6,5,6,7,6,4,6,7,6,7,7,7
    .byte 7,7,7,6,6,7,7,7,6,6,7,7,6,6,7,5,7,7,5,6,5,4,5,6
    .byte 6,6,6,7,6,7,6,7,7,7,5,6,6,7,4,5,6,6,7,6,7,6,6,6
    .byte 7,6,7,7,7,7,6,6,6,6,7,5,6,7,7,7,6,7,5,7,7,6,5,5
    .byte 7,7,7,6,7,8,8,6,7,6,7,5,6,7,7,6,6,7,7,7,7,5,6,7
    .byte 7,5,7,6,5,5,5,6,6,6,6,5,7,7,5,5,7,7,7,6,7,4,7,5
    .byte 6,6,6,5,6,7,8,6,7,7,6,6,8,6,7,6,7,7,5,6,5,5,7,7
    .byte 7,7,8,4,7,7,5,6,5,7,7,6,7,7,6,6,7,7,7,7,7,7,6,7
    .byte 6,6,7,7,7,7,7,6,7,7,6,7,6,5,5,5,7,6,6,5,7,5,8,6
    .byte 7,6,7,7,6,6,7,5,7,7,7,5,7,7,6,7,7,7,7,7,6,8,6,7
    .byte 7,7,7,6,6,7,7,6,7,7,7,7,3,7,7,6,7,5,6,6,5,7,8,7
    .byte 6,7,7,7,7,6,7,6,7,8,7,7,5,7,7,6,5,6,6,6,7,7,4,7
    .byte 7,7,7,7,4,5,7,7,6,5,5,7,6,6,7,6,6,5,6,6,6,6,6,6
    .byte 8,6,5,7,7,6,7,7,6,7,7,7,7,8,6,6,6,7,7,6,6,7,6,7
    .byte 7,7,5,6,4,7,6,6,7,6,7,6,6,6,7,6,7,6,7,7,7,6,6,6
    .byte 4,6,7,5,8,6,5,7,6,7,4,7,6,6,5,7,6,6,7,6,5,7,6,6
    .byte 7,6,6,6,7,7,5,6,5,5,8,6,7,7,7,7,6,6,6,6,7,6,7,6
    .byte 7,5,6,7,7,5,6,7,7,6,6,6,6,7,6,7,7,7,7,6,7,6,7,6
    .byte 7,8,7,7,7,6,6,5,6,4,6,7,7,6,7,6,7,6,6,7,6,6,5,7
    .byte 6,5,6,5,6,6,6,6,7,6,7,6,7,7,6,5,6,7,7,5,7,6,7,8
    .byte 7,7,5,7,6,7,6,5,7,6,6,6,7,6,7,6,6,6,4,7,7,4,6,6
    .byte 7,7,7,8,6,6,6,7,7,7,7,7,7,7,8,7,6,7,6,5,6,6,6,7
    .byte 7,5,7,5,7,6,5,7,6,6,4,7,8,6,6,7,6,7,7,5,6,7,6,6
    .byte 6,7,5,8,7,7,7,7,7,7,6,6,7,7,7,6,7,6,5,6,7,7,5,6
    .byte 5,7,6,6,7,5,5,4,6,6,7,7,7,7,6,7,6,7,6,6,6,7,7,7
    .byte 7,6,7,7,4,7,6,6,6,7,7,7,7,6,5,6,7,6,5,6,5,5,6,7
    .byte 6,5,7,6,7,7,7,7,6,5,5,6,8,7,7,6,7,6,6,7,6,6,7,7
    .byte 7,7,5,5,6,6,6,7,6,7,6,6,7,5,7,5,6,5,7,6,6,7,7,8
    .byte 7,7,7,7,6,6,7,7,7,7,8,7,5,7,7,5,6,5,6,7,6,6,6,8
    .byte 7,6,7,7,6,4,6,6,5,6,7,7,7,7,6,6,6,6,4,7,6,6,7,7
    .byte 7,7,6,7,6,7,7,6,7,7,6,7,6,6,6,7,6,6,7,7,6,7,5,7
    .byte 5,7,5,7,6,5,7,7,7,6,7,7,6,6,5,8,7,7,6,7,8,4,6,7
    .byte 5,5,6,6,7,7,5,6,7,7,6,7,6,5,4,6,6,6,6,7,7,7,7,7
    .byte 7,5,6,5,6,6,7,6,7,6,7,7,6,6,7,7,7,7,6,6,8,6,6,6
    .byte 7,6,7,6,6,7,7,6,4,5,4,7,6,7,7,7,8,7,8,7,6,6,7,7
    .byte 6,7,7,7,7,8,7,5,7,6,6,6,6,7,6,8,6,5,6,6,7,5,6,5
    .byte 5,5,6,7,6,7,6,8,7,6,6,6,6,5,6,7,7,6,7,7,7,7,7,5
    .byte 6,8,7,7,7,6,6,7,5,6,7,7,6,7,7,6,6,6,6,6,6,6,6,7
    .byte 7,8,6,7,7,5,6,7,7,5,5,7,7,7,6,5,6,6,7,6,7,7,6,4
    .byte 5,6,5,7,6,7,6,7,7,5,7,8,7,6,4,6,7,7,7,6,7,7,5,7
    .byte 5,6,7,7,7,7,7,6,4,7,7,6,7,7,7,5,7,7,7,7,6,5,7,7
    .byte 5,7,7,6,7,6,7,7,6,7,7,7,6,7,5,7,6,7,6,5,6,7,6,5
    .byte 6,6,7,6,6,7,6,6,4,4,6,6,7,6,7,7,7,7,6,6,7,6,5,5
    .byte 6,6,7,6,7,7,6,6,7,6,6,6,7,6,7,6,5,4,6,6,7,7,8,6
    .byte 6,7,7,7,8,7,6,8,7,6,7,7,6,6,7,7,7,7,7,7,7,6,8,4
    .byte 7,7,7,6,4,7,6,7,6,6,5,7,7,5,7,6,6,5,5,7,5,7,6,6
    .byte 7,7,7,6,7,7,6,6,5,7,7,6,7,6,7,7,6,7,6,6,6,6,7,7
    .byte 6,5,4,6,7,7,7,7,7,5,6,6,7,8,7,6,7,7,6,7,6,5,7,7
    .byte 6,7,7,7,7,7,6,7,5,7,6,6,6,5,6,6,7,6,6,6,7,6,5,6
    .byte 6,5,5,5,7,5,7,5,7,7,6,6,6,7,7,6,6,5,6,6,7,7,6,6
    .byte 7,6,7,6,7,6,7,6,7,7,6,3,7,7,7,8,7,7,6,7,7,8,7,7
    .byte 7,6,7,6,6,7,7,7,6,5,7,7,6,6,7,7,7,7,5,5,7,7,6,5
    .byte 7,7,6,4,6,7,6,5,6,7,7,5,6,5,8,6,5,6,7,7,7,6,6,6
    .byte 7,7,6,6,7,4,5,7,6,6,6,6,5,6,7,6,6,6,6,6,6,7,6,5
    .byte 7,8,6,7,7,7,7,6,7,3,8,8,6,8,6,6,5,7,7,7,7,5,8,7
    .byte 7,7,7,7,6,6,7,6,6,6,7,7,7,5,7,6,6,6,6,6,6,7,7,7
    .byte 7,7,6,6,7,7,6,6,6,6,6,6,7,6,6,8,7,5,7,6,7,7,7,7
    .byte 7,6,7,7,5,5,6,6,6,7,7,7,7,7,7,7,6,6,6,6,7,6,7,7
    .byte 6,7,7,6,6,6,7,8,6,6,7,7,5,6,5,7,6,7,6,5,7,6,5,5
    .byte 5,6,7,6,4,8,6,7,6,6,6,4,8,6,6,7,7,7,5,7,7,6,7,5
    .byte 7,6,7,7,7,7,6,6,6,6,6,5,6,5,7,7,6,6,6,7,7,6,8,6
    .byte 7,6,6,6,6,6,6,6,7,6,7,7,6,7,7,7,5,7,7,7,7,4,6,6
    .byte 7,6,6,7,6,6,5,5,5,6,4,7,7,5,6,7,5,6,6,7,6,7,7,7
    .byte 6,5,8,6,6,7,5,7,5,6,6,6,7,7,6,7,6,6,5,6,5,7,6,5
    .byte 7,7,6,6,7,7,7,7,7,6,6,7,7,7,7,6,7,7,6,6,6,6,6,7
    .byte 7,6,7,8,7,6,5,6,6,7,5,6,7,6,6,4,5,6,6,5,6,6,7,5
    .byte 6,6,8,7,4,6,7,7,6,7,5,7,7,7,7,6,7,5,6,6,6,6,6,6
    .byte 6,7,7,5,7,5,6,7,5,7,6,5,7,7,6,6,6,6,8,7,6,7,6,7
    .byte 7,7,6,5,6,6,7,5,6,7,8,7,6,6,6,6,7,4,7,6,7,6,6,7
    .byte 6,6,5,4,5,7,7,5,8,6,7,6,6,6,5,7,5,5,6,6,7,6,7,7
    .byte 6,6,6,7,5,7,7,6,7,6,7,7,7,6,5,6,5,7,7,7,7,6,6,7
    .byte 6,7,6,7,7,7,6,7,7,7,7,7,6,6,6,7,7,6,7,6,7,7,7,6
    .byte 5,5,7,7,6,7,7,6,6,5,5,5,5,5,7,7,6,6,6,6,6,7,6,6
    .byte 7,7,6,5,6,7,7,6,7,5,7,6,7,7,6,6,6,7,7,7,6,4,6,6
    .byte 7,7,5,7,7,5,7,7,7,6,6,7,7,7,7,4,7,8,6,8,5,5,4,6
    .byte 6,7,7,6,8,7,6,6,6,7,6,6,6,6,6,6,6,7,7,5,7,7,7,5
    .byte 7,7,7,7,7,7,8,6,6,6,6,6,6,5,6,5,7,6,6,6,7,8,7,6
    .byte 7,6,6,8,8,7,6,5,6,6,6,6,6,7,6,7,8,7,7,7,6,7,7,7
    .byte 7,7,6,5,7,7,6,7,6,6,7,8,6,5,6,7,7,7,6,6,6,6,6,6
    .byte 6,6,5,3,6,6,7,6,6,7,6,6,7,5,8,6,5,5,7,6,7,7,6,6
    .byte 8,6,6,5,6,5,6,6,7,6,5,6,6,7,6,6,7,6,6,6,6,7,6,4
    .byte 8,7,7,6,7,6,7,7,7,4,7,7,7,7,5,6,4,7,7,8,7,6,7,6
    .byte 7,7,6,6,6,6,7,7,5,6,7,7,6,4,7,7,6,6,6,6,6,6,6,7
    .byte 7,7,6,5,7,7,7,6,7,6,7,7,7,6,6,7,6,6,7,5,6,7,7,7
    .byte 7,6,6,7,6,6,5,7,6,8,8,8,7,6,7,7,7,7,6,7,7,6,7,7
    .byte 5,7,7,7,7,7,6,5,7,7,6,7,5,5,7,7,7,7,7,7,5,4,5,4
    .byte 6,5,7,8,6,7,6,6,6,6,6,6,7,7,7,6,6,7,7,5,7,4,6,6
    .byte 6,7,6,6,7,6,6,7,7,5,7,6,6,6,5,6,6,6,7,7,7,7,6,6
    .byte 7,7,7,6,7,7,7,6,7,6,7,7,7,6,6,6,7,7,5,7,6,6,6,5
    .byte 7,7,7,5,6,7,6,5,4,5,5,8,7,5,8,6,6,6,7,5,5,8,6,6
    .byte 7,7,6,6,7,8,5,7,6,7,5,7,6,6,6,7,7,6,7,7,6,5,5,6
    .byte 7,6,6,7,7,6,6,7,6,6,6,6,7,7,7,6,6,7,6,6,6,6,7,7
    .byte 7,6,7,7,6,7,6,6,7,6,6,6,6,6,6,4,6,6,6,6,5,6,6,6
    .byte 7,5,7,7,5,6,7,7,7,7,6,6,7,7,7,6,6,5,6,6,7,5,6,5
    .byte 6,7,7,6,7,6,5,6,6,7,5,5,7,8,7,7,7,6,7,7,7,7,7,7
    .byte 7,6,7,6,6,6,6,6,7,6,6,7,7,7,6,5,6,6,8,6,7,6,7,6
    .byte 5,4,5,6,5,7,7,6,6,6,6,5,7,7,7,6,7,6,5,6,7,6,6,7
    .byte 5,7,6,6,7,7,6,6,6,7,7,7,5,6,6,7,6,4,7,7,6,6,6,8
    .byte 6,7,7,7,7,7,7,7,7,6,7,7,5,7,6,7,6,7,6,7,7,6,6,7
    .byte 6,6,5,7,7,7,6,6,6,6,6,5,5,6,8,7,5,8,5,7,5,6,6,5
    .byte 7,6,6,6,6,6,6,7,7,6,6,6,7,6,7,6,7,6,7,7,7,6,6,6
    .byte 6,4,7,8,6,7,7,7,7,5,7,5,7,6,7,4,8,8,7,8,6,6,5,6
    .byte 7,8,6,6,8,7,7,7,6,6,5,6,7,7,6,5,7,8,7,4,6,6,7,6
    .byte 7,6,7,6,7,6,7,6,6,6,7,7,7,6,7,6,7,7,6,5,6,7,7,6
    .byte 6,6,7,7,7,7,6,6,7,6,6,6,6,7,7,7,7,7,6,7,7,8,7,7
    .byte 5,7,7,5,5,6,5,7,6,7,8,6,7,6,7,7,6,6,7,6,7,7,6,7
    .byte 7,7,6,6,6,5,7,6,6,7,7,6,4,7,7,4,6,6,6,6,6,6,6,7
    .byte 7,5,6,6,5,6,7,6,6,7,7,6,8,7,7,7,7,7,6,7,6,7,7,7
    .byte 5,7,7,5,5,7,6,7,5,5,7,7,7,6,7,6,5,6,7,6,7,4,7,7
    .byte 6,8,6,7,7,7,7,7,7,4,7,7,6,6,5,7,5,7,6,6,7,6,6,6
    .byte 7,4,6,7,6,6,5,7,7,7,6,8,6,6,5,7,5,6,6,7,6,7,8,7
    .byte 7,8,7,7,7,4,7,7,7,6,7,6,6,6,6,7,4,6,6,7,7,6,7,4
    .byte 7,4,7,7,6,7,5,7,6,6,7,7,7,8,6,7,7,6,6,6,6,6,4,7
    .byte 5,7,6,6,7,6,7,5,6,6,6,4,6,7,6,6,7,6,6,7,6,6,6,7
    .byte 7,6,7,7,5,7,7,8,7,7,7,6,7,6,5,6,7,7,7,6,7,6,5,7
    .byte 7,6,6,6,6,6,5,6,7,6,7,5,7,7,8,7,5,5,6,6,7,6,7,7
    .byte 6,7,7,6,5,6,4,8,5,6,6,7,6,7,7,7,5,6,5,5,6,7,4,7
    .byte 6,7,6,7,4,6,5,7,6,7,7,7,5,6,6,7,7,6,6,7,7,6,6,6
    .byte 7,7,6,7,6,7,5,7,4,6,6,6,4,7,6,7,6,6,5,5,6,5,7,6
    .byte 7,7,5,8,5,7,5,6,7,7,7,6,8,7,7,7,5,7,6,6,7,7,7,6
    .byte 6,7,5,6,6,7,6,6,4,5,6,7,6,4,7,7,7,7,7,6,6,6,6,7
    .byte 7,7,7,6,7,5,7,7,7,6,7,6,6,7,6,6,6,7,5,7,6,6,6,7
    .byte 7,7,4,6,4,7,6,7,6,6,8,7,7,7,6,5,6,7,6,7,7,7,7,8
    .byte 7,5,7,5,7,5,7,7,7,7,5,6,7,6,7,5,5,4,6,5,6,7,6,6
    .byte 5,7,7,7,6,7,7,6,6,7,8,7,7,6,6,7,7,6,5,7,7,6,6,6
    .byte 7,7,5,5,6,6,7,6,6,7,5,7,6,6,6,7,6,4,7,6,7,6,7,7
    .byte 5,6,5,7,7,7,6,8,7,5,6,7,5,5,6,7,7,7,5,7,6,7,6,7
    .byte 7,6,3,6,6,6,5,7,7,6,8,6,7,5,6,6,7,7,6,7,7,6,6,6
    .byte 7,6,7,7,7,6,6,6,7,7,5,7,7,6,6,6,7,6,6,6,7,6,6,6
    .byte 6,5,6,6,7,7,6,6,7,6,7,6,6,7,7,6,7,7,6,6,8,4,6,6
    .byte 6,7,6,6,5,7,7,5,7,6,6,4,7,5,6,7,6,6,7,6,6,7,7,6
    .byte 5,6,7,7,7,7,7,7,6,8,7,6,7,5,7,6,6,6,6,6,7,7,7,5
    .byte 3,7,7,7,8,5,7,7,6,7,7,7,6,7,7,7,6,6,6,6,6,7,7,7
    .byte 5,7,7,6,5,6,7,6,7,7,5,7,6,6,6,6,4,5,7,7,6,6,6,8
    .byte 6,5,7,5,6,4,7,5,6,6,7,7,8,7,6,7,8,5,7,7,6,7,7,6
    .byte 6,7,6,6,7,6,6,6,6,5,7,6,5,6,7,5,7,6,7,7,6,7,7,7
    .byte 6,7,6,8,6,7,7,7,7,6,5,7,5,6,5,6,6,7,7,6,6,5,6,6
    .byte 4,7,5,7,5,7,7,6,5,7,7,7,7,6,7,6,6,6,6,7,6,7,7,7
    .byte 6,6,7,7,6,6,7,7,7,5,6,5,6,6,7,7,5,7,7,6,6,6,6,6
    .byte 6,7,6,7,6,6,7,7,6,7,7,6,7,8,7,6,8,7,6,6,7,5,6,7
    .byte 7,6,7,7,6,7,6,6,5,5,6,6,7,5,6,5,7,7,5,6,6,6,6,6
    .byte 7,7,7,6,6,7,7,6,8,6,6,7,7,7,5,8,7,7,6,4,6,7,6,6
    .byte 6,6,7,6,5,7,6,7,6,7,5,7,5,7,7,7,7,5,5,5,7,5,7,6
    .byte 7,8,8,7,5,6,5,5,6,5,8,6,6,7,7,7,5,7,7,7,5,7,7,7
    .byte 7,6,6,7,5,7,6,5,6,6,7,6,6,7,5,6,8,7,7,7,6,7,5,6
    .byte 7,7,7,6,6,5,6,6,5,6,6,6,7,5,5,5,6,6,6,7,7,6,7,7
    .byte 6,7,5,7,7,7,6,7,7,6,7,7,6,6,6,5,6,6,7,6,8,7,4,7
    .byte 7,7,5,4,7,6,7,4,7,7,7,7,7,5,7,4,6,6,7,6,7,6,6,7
    .byte 7,7,7,7,7,5,7,6,6,8,7,5,5,6,5,7,7,6,6,6,7,4,7,7
    .byte 6,7,5,7,7,6,8,6,6,5,7,6,8,7,6,8,6,7,7,5,6,7,7,7
    .byte 7,6,6,7,6,7,6,6,5,5,6,7,7,6,6,5,8,6,6,7,7,7,7,6
    .byte 6,5,6,7,6,5,7,7,7,7,7,8,6,7,7,7,6,7,7,7,7,6,5,6
    .byte 6,7,7,8,7,7,6,6,6,6,5,6,7,6,7,6,7,8,7,6,6,5,6,6
    .byte 6,7,8,6,6,6,8,6,6,6,5,6,7,5,7,6,5,6,6,6,7,5,6,4
    .byte 7,7,6,6,6,8,7,7,7,3,6,5,6,6,6,6,7,8,7,7,7,6,7,6
    .byte 7,6,6,7,7,7,6,6,5,5,7,7,8,6,7,6,6,6,6,6,6,7,7,5
    .byte 6,7,7,6,7,7,7,7,7,6,7,7,6,7,6,5,7,7,6,5,6,6,6,8
    .byte 6,7,6,5,5,6,6,5,6,7,7,7,6,6,8,8,6,7,6,7,4,6,7,6
    .byte 7,7,7,7,7,6,7,6,7,7,7,6,7,7,6,6,7,4,7,6,7,6,6,6
    .byte 5,6,6,6,7,6,6,6,7,7,7,7,7,7,7,6,7,5,6,7,7,7,5,7
    .byte 7,6,6,7,5,6,7,5,7,6,6,6,5,5,5,6,7,5,6,7,6,6,5,6
    .byte 7,6,7,5,7,6,7,7,6,7,6,7,7,6,6,6,7,7,7,6,6,8,7,7
    .byte 7,6,6,3,6,7,7,7,7,4,5,7,6,6,7,7,7,4,7,7,4,7,5,7
    .byte 6,6,6,8,5,7,7,7,7,6,6,7,7,7,7,7,7,6,6,5,5,4,5,6
    .byte 7,6,6,6,7,7,7,7,5,6,5,6,7,6,5,7,7,7,6,7,6,7,7,7
    .byte 7,6,6,7,7,6,6,7,7,6,7,7,5,6,5,7,7,7,6,6,6,6,7,6
    .byte 6,6,7,7,6,7,6,8,7,6,7,6,6,7,7,7,6,7,6,6,7,6,6,6
    .byte 6,6,7,6,5,6,6,7,5,5,7,7,8,5,8,5,6,6,6,7,6,6,6,7
    .byte 7,6,7,5,6,6,6,6,7,6,6,7,7,7,5,7,7,7,6,6,7,6,5,6
    .byte 8,6,7,6,7,6,7,6,5,6,7,5,7,6,7,6,7,7,6,7,6,7,7,7
    .byte 6,7,6,5,7,7,6,5,7,6,7,8,7,6,5,5,5,5,6,5,6,7,7,7
    .byte 4,8,8,6,5,6,6,8,6,7,6,7,7,5,7,7,6,6,5,6,7,7,5,6
    .byte 7,7,6,7,6,6,6,6,6,6,6,6,5,7,6,7,6,6,5,6,5,7,6,6
    .byte 5,7,7,6,7,7,7,7,6,6,7,7,5,7,8,5,6,5,6,5,6,7,6,7
    .byte 6,7,7,7,4,5,7,6,5,6,6,6,6,7,7,6,7,6,7,5,6,5,7,6
    .byte 7,7,6,7,7,7,7,7,5,7,7,8,5,8,7,6,5,6,7,5,7,6,6,6
    .byte 6,6,7,5,6,4,7,7,7,6,5,6,7,7,7,7,7,7,6,7,6,7,6,6
    .byte 4,7,6,6,6,6,5,7,6,7,6,7,6,4,7,7,5,6,6,7,5,7,5,6
    .byte 6,7,6,7,7,7,5,6,6,6,7,6,5,7,7,7,7,6,8,6,6,7,6,6
    .byte 4,7,5,7,7,6,6,7,7,7,7,3,6,3,6,8,6,8,6,8,6,7,8,7
    .byte 7,8,7,7,6,6,6,7,7,6,5,7,5,6,7,6,8,7,8,6,6,6,6,5
    .byte 6,7,6,5,6,6,6,7,6,5,7,7,7,6,8,7,5,7,7,8,6,8,7,6
    .byte 8,7,6,6,8,8,7,6,7,6,5,6,7,7,6,6,7,7,5,6,7,5,6,5
    .byte 7,7,7,6,6,7,6,7,7,6,6,7,7,6,6,7,7,6,6,6,5,7,6,6
    .byte 7,7,6,5,8,7,5,5,6,6,6,6,6,5,7,6,5,6,6,6,6,7,7,7
    .byte 6,7,6,7,7,7,6,8,7,6,8,7,6,7,7,6,6,7,6,4,6,7,7,6
    .byte 2,8,7,7,7,4,7,7,6,7,7,7,7,7,8,7,7,6,7,6,7,8,7,7
    .byte 6,7,7,7,5,6,7,7,8,7,5,6,6,6,6,6,5,6,7,8,7,5,6,8
    .byte 6,6,6,6,5,5,7,6,6,6,7,7,7,7,6,7,7,6,7,6,7,7,7,7
    .byte 7,7,6,7,6,7,7,7,7,6,5,6,6,6,5,7,5,6,5,6,7,7,6,6
    .byte 6,6,8,6,7,5,7,7,7,7,6,7,5,6,7,4,7,6,5,7,7,6,5,8
    .byte 7,6,5,6,6,7,7,6,6,7,6,7,6,6,5,6,7,7,6,7,5,6,7,7
    .byte 7,8,7,7,6,7,6,7,7,5,6,6,7,6,6,6,6,6,6,6,6,6,5,5
    .byte 7,7,5,7,7,6,7,7,7,7,8,7,6,7,7,7,7,7,6,6,7,5,6,7
    .byte 7,6,7,6,6,6,6,6,6,6,6,6,7,6,5,5,7,7,5,7,7,5,7,6
    .byte 7,7,6,6,6,7,7,6,7,7,7,7,7,7,5,7,7,6,5,5,6,7,6,7
    .byte 7,6,6,5,6,5,5,6,6,5,6,6,6,6,7,7,6,7,6,7,7,7,6,6
    .byte 7,6,8,6,6,7,6,6,6,6,7,6,6,5,6,5,6,5,5,7,6,7,5,8
    .byte 8,5,6,6,7,7,6,6,6,7,6,6,6,7,6,7,7,6,6,7,6,7,6,7
    .byte 6,8,6,5,6,6,6,7,6,7,4,7,4,7,6,5,6,6,5,6,6,7,7,6
    .byte 8,7,7,6,6,5,7,6,8,8,5,6,7,7,5,7,5,7,8,5,6,6,6,5
    .byte 5,6,6,7,6,6,7,7,6,6,6,7,6,6,6,6,7,6,7,7,6,7,6,6
    .byte 7,6,6,7,6,7,6,6,6,7,7,8,6,6,5,4,7,7,7,7,6,7,6,5
    .byte 5,6,5,6,5,6,6,6,7,7,8,7,6,6,6,6,7,7,6,7,7,6,6,7
    .byte 6,7,7,6,6,7,6,5,5,6,6,5,6,7,7,7,6,7,6,7,7,6,6,5
    .byte 7,6,7,7,6,7,6,6,7,6,6,7,5,7,7,7,7,5,7,7,7,7,6,7
    .byte 6,6,5,7,5,7,7,6,5,6,6,4,5,6,5,7,6,7,7,8,7,6,6,6
    .byte 7,7,7,6,7,7,6,6,7,6,6,8,6,6,7,6,6,5,5,5,5,7,6,6
    .byte 7,7,6,5,7,7,6,5,6,6,7,6,7,5,8,7,5,7,7,6,6,6,7,7
    .byte 7,6,5,7,7,7,7,5,7,7,7,5,6,6,7,4,6,7,5,6,7,6,6,5
    .byte 7,7,5,7,6,8,6,7,5,7,6,8,7,6,7,7,6,6,7,6,7,7,6,5
    .byte 6,5,5,5,6,5,6,6,7,7,6,7,6,6,6,6,5,6,6,6,6,7,7,6
    .byte 7,7,6,7,7,6,6,6,6,6,6,6,6,8,7,7,6,6,5,7,6,7,6,6
    .byte 6,6,6,4,6,5,5,6,7,7,6,7,6,6,6,6,7,7,7,7,6,7,6,7
    .byte 6,6,7,6,6,6,7,7,7,6,4,6,6,7,5,5,7,6,7,5,7,7,6,7
    .byte 6,6,7,5,6,5,6,6,7,7,7,7,7,7,6,6,6,6,7,6,7,7,7,6
    .byte 6,6,5,7,7,6,7,5,7,6,6,6,6,4,5,7,6,6,6,6,7,7,6,7
    .byte 6,7,6,6,6,8,7,7,6,7,7,7,6,6,6,8,5,7,5,5,5,6,6,6
    .byte 6,5,5,7,6,6,6,6,7,6,7,7,4,6,5,6,6,6,6,7,8,7,7,7
    .byte 7,7,6,7,7,6,7,7,7,5,6,6,6,6,7,7,7,7,7,6,6,6,5,5
    .byte 7,6,5,6,6,7,6,7,7,7,6,8,6,7,6,6,7,6,6,6,7,6,6,7
    .byte 5,7,7,5,6,6,5,5,7,6,5,6,7,6,8,6,6,7,7,6,7,5,6,4
    .byte 6,7,6,6,7,6,7,7,7,6,7,6,7,6,7,6,6,6,5,7,5,6,7,7
    .byte 7,5,7,3,8,8,6,7,4,8,7,7,7,7,7,6,7,7,8,8,7,7,7,7
    .byte 7,6,7,7,7,8,7,6,7,8,7,8,6,6,6,6,7,7,6,6,7,6,8,6
    .byte 6,7,8,7,6,7,7,4,6,7,7,6,7,7,7,8,8,7,6,8,7,8,6,7
    .byte 7,8,7,7,6,6,7,6,8,7,7,7,5,8,7,6,7,6,4,5,5,6,7,7
    .byte 6,6,6,7,6,7,6,6,7,8,7,7,7,7,6,6,5,6,6,5,6,7,7,6
    .byte 6,7,6,6,6,7,6,5,5,5,5,6,7,5,7,6,6,7,8,7,7,5,6,7
    .byte 8,7,7,6,7,6,7,7,7,5,6,7,6,7,6,6,5,6,6,7,5,6,6,8
    .byte 7,7,3,6,3,7,7,7,7,7,7,7,7,7,6,6,7,6,6,6,7,6,7,7
    .byte 6,6,7,6,6,6,7,7,7,7,6,6,7,7,6,6,6,5,5,5,6,7,7,6
    .byte 6,7,6,7,7,7,7,6,6,6,8,7,7,7,7,7,7,6,5,8,7,7,7,6
    .byte 6,6,6,6,7,7,6,6,6,7,5,6,6,6,5,7,6,7,6,6,7,7,7,7
    .byte 6,7,6,7,7,6,7,7,7,5,7,7,5,6,6,5,7,6,7,5,7,6,5,7
    .byte 6,6,5,6,6,5,7,6,7,7,6,6,7,7,6,5,7,7,7,6,6,6,7,6
    .byte 7,7,7,7,6,6,7,5,7,5,7,6,6,7,6,6,7,6,7,6,6,6,6,5
    .byte 8,6,5,6,7,7,5,7,6,6,7,5,7,7,8,5,8,7,5,5,6,5,5,7
    .byte 6,7,7,6,7,7,7,5,6,7,6,4,7,6,6,6,7,8,6,8,7,8,5,7
    .byte 5,6,7,7,7,7,7,7,7,7,7,6,7,6,7,5,7,7,7,6,6,7,6,6

pdb_orient:
    .byte 0,5,5,4,4,5,4,6,3,6,3,4,4,3,5,5,1,5,5,4,4,5,5,3
    .byte 3,5,4,4,3,6,4,5,4,5,4,4,4,4,2,3,5,4,5,5,4,5,5,4
    .byte 5,4,3,5,3,5,4,5,4,5,5,5,4,4,5,5,4,5,4,5,4,5,4,5
    .byte 4,4,4,5,5,5,3,4,4,5,3,5,4,5,4,5,4,5,4,4,4,4,5,5
    .byte 4,4,5,4,5,5,5,4,5,4,4,5,4,5,3,5,6,5,5,4,6,4,5,5
    .byte 4,5,5,6,5,4,6,5,4,5,6,4,4,5,5,6,3,4,4,5,6,4,3,5
    .byte 2,5,4,5,5,5,3,5,5,5,4,5,4,5,6,5,5,5,5,5,3,6,4,3
    .byte 4,3,5,4,5,5,2,5,4,5,4,5,4,5,4,4,4,4,3,5,4,5,5,4
    .byte 4,5,3,5,6,4,5,5,4,5,4,5,5,5,4,4,5,5,4,4,5,5,5,5
    .byte 4,4,5,4,6,5,5,5,6,6,5,4,3,4,4,5,5,6,4,6,5,5,5,5
    .byte 5,4,5,5,3,5,4,4,5,4,5,5,5,4,3,3,5,4,4,5,5,6,4,3
    .byte 4,4,4,4,2,5,4,4,4,4,5,4,4,4,4,4,5,5,4,3,5,5,5,5
    .byte 4,5,2,4,5,3,4,5,3,4,5,5,4,5,5,3,4,4,4,5,6,4,5,4
    .byte 5,3,5,4,5,5,5,4,5,4,5,4,3,3,5,3,4,4,5,5,4,4,4,5
    .byte 5,4,5,4,4,3,3,5,4,4,5,3,5,2,4,4,5,4,4,4,5,5,5,5
    .byte 5,4,5,4,5,4,5,4,5,5,4,5,5,5,5,4,5,5,4,5,3,4,4,5
    .byte 4,4,5,4,5,5,5,3,4,3,3,4,2,3,3,5,4,4,5,5,4,5,5,2
    .byte 5,4,4,5,4,4,4,4,5,5,5,2,5,5,5,4,5,4,1,5,6,5,2,5
    .byte 5,4,3,4,5,4,5,5,4,5,6,3,4,4,4,4,4,5,4,4,5,3,4,5
    .byte 4,4,3,5,5,5,4,5,4,5,5,6,5,4,6,5,5,5,5,4,5,5,5,5
    .byte 3,5,4,5,4,4,5,5,3,4,5,5,4,4,4,5,4,5,4,5,4,5,4,4
    .byte 5,4,4,5,5,4,4,5,5,4,5,5,3,4,4,4,4,4,4,5,5,5,5,5
    .byte 5,3,4,5,6,4,5,5,5,4,4,5,4,5,4,4,5,5,4,4,5,5,4,5
    .byte 5,4,6,4,4,5,4,5,6,5,6,6,5,5,4,5,2,5,5,5,5,5,3,4
    .byte 3,4,5,5,4,4,3,6,6,5,5,5,5,5,6,4,4,5,5,4,4,5,6,5
    .byte 5,4,5,6,5,3,4,4,5,5,5,6,5,6,4,5,5,5,6,4,4,5,4,4
    .byte 4,4,5,4,4,5,4,5,4,3,4,5,5,5,5,5,5,5,4,4,5,4,4,5
    .byte 3,5,3,4,3,5,4,4,5,4,5,5,5,2,4,4,3,4,3,4,4,5,3,4
    .byte 5,5,4,5,4,5,4,5,4,5,5,5,4,5,5,5,5,5,6,5,4,5,6,5
    .byte 4,5,3,5,5,4,3,4,4,4,5,4,4,5,4,5,6,5,4,5,5,4,4,5
    .byte 5,5,4,5,4,5,3,5,5
