.text
_start:
    call main
    li a7, 10
    ecall
main:
    addi	sp,sp,-288
    la	a5,L_ANCHOR0
    sw	s2,276(sp)
    sw	s8,252(sp)
    lw	s2,0(a5)
    li	s8,17170432
    li	a5,65536
    sw	s11,240(sp)
    addi	s8,s8,772
    li	s11,131072
    addi	a5,a5,-1
    sw	s1,280(sp)
    sw	s3,272(sp)
    sw	s5,264(sp)
    sw	s6,260(sp)
    sw	s7,256(sp)
    sw	s9,248(sp)
    sw	s0,284(sp)
    sw	s4,268(sp)
    sw	s10,244(sp)
    li	a2,0
    li	t0,0
    addi	s11,s11,1280
    li	s1,-1
    li	s3,8
    li	t2,7
    la	s5,L_12
    la	s6,L_ANCHOR1
    sw	a5,12(sp)
    la	s7,pdb_perm
    mv	s9,s8
L_2:
    li	a5,9
    sw	s9,72(sp)
    sw	s11,76(sp)
    sw	zero,80(sp)
    sh	zero,84(sp)
    sb	zero,48(sp)
    sb	a5,60(sp)
    li	a4,0
L_34:
    beq	a4,t0,L_66
L_3:
    addi	a3,sp,16
    addi	a5,a4,224
    add	a5,a5,a3
    lbu	a3,-192(a5)
    lbu	a1,-180(a5)
    beq	a1,a3,L_67
    bgtu	a3,s3,L_64
L_9:
    addi	t6,a4,1
    slli	a1,t6,3
    sub	a1,a1,t6
    sub	a0,t0,a4
    slli	a1,a1,1
    addi	a6,a3,1
    addi	a0,a0,-1
    sb	a6,-192(a5)
    addi	a2,a1,-14
    sb	a3,-204(a5)
    addi	a6,sp,72
    addi	a5,sp,72
    sw	a0,8(sp)
    addi	s2,s2,1
    add	a5,a5,a1
    add	a2,a6,a2
    bgtu	a3,t2,L_10
    slli	a0,a3,2
    add	a0,a0,s5
    lw	a0,0(a0)
    jr	a0
L_67:
    addi	a3,a3,3
    andi	a3,a3,0xff
    bleu	a3,s3,L_9
L_64:
    addi	a4,a4,-1
    bne	a4,s1,L_34
    addi	t0,t0,1
    li	a5,12
    bne	t0,a5,L_2
    beq	a2,zero,L_35
    la	a5,L_ANCHOR0
    sw	s2,0(a5)
L_35:
    li	a0,-1
    li	a7,1
    #APP
    # 18 "ripes_main.c" 1
    ecall
    # 0 "" 2
    #NO_APP
    li	a0,58
    li	a7,11
    #APP
    # 18 "ripes_main.c" 1
    ecall
    # 0 "" 2
    #NO_APP
L_37:
    li	a0,10
    li	a7,11
    #APP
    # 18 "ripes_main.c" 1
    ecall
    # 0 "" 2
    #NO_APP
    la	a5,L_ANCHOR0
    lw	a0,0(a5)
    li	a7,1
    #APP
    # 18 "ripes_main.c" 1
    ecall
    # 0 "" 2
    #NO_APP
    li	a0,10
    li	a7,11
    #APP
    # 18 "ripes_main.c" 1
    ecall
    # 0 "" 2
    #NO_APP
    lw	s0,284(sp)
    lw	s1,280(sp)
    lw	s2,276(sp)
    lw	s3,272(sp)
    lw	s4,268(sp)
    lw	s5,264(sp)
    lw	s6,260(sp)
    lw	s7,256(sp)
    lw	s8,252(sp)
    lw	s9,248(sp)
    lw	s10,244(sp)
    lw	s11,240(sp)
    li	a0,0
    addi	sp,sp,288
    jr	ra
L_13:
    lbu	t5,0(a2)
    sb	t5,0(a5)
    lbu	t4,2(a2)
    sb	t4,1(a5)
    lbu	t3,5(a2)
    sltu	s0,t4,t5
    sb	t3,2(a5)
    lbu	t1,3(a2)
    sltu	a0,t3,t5
    add	s0,s0,a0
    sb	t1,3(a5)
    lbu	a6,4(a2)
    lbu	a7,1(a2)
    sltu	s4,t1,t5
    slli	a0,a6,8
    or	a0,a7,a0
    sh	a0,4(a5)
    lbu	a0,6(a2)
    add	s0,s0,s4
    sltu	s4,a7,t5
    add	s0,s0,s4
    sltu	s4,a6,t5
    add	s0,s0,s4
    sltu	s10,a0,t5
    sltu	s8,t1,t4
    sltu	s4,t3,t4
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s8,a7,t4
    slli	s10,s0,1
    add	s4,s4,s8
    sltu	s8,a6,t4
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s10,a0,t4
    add	s10,s4,s10
    sltu	s8,a7,t3
    slli	s0,s0,1
    sltu	s4,t1,t3
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s10,a6,t3
    slli	s8,s0,2
    add	s4,s4,s10
    sltu	s10,a0,t3
    add	s8,s8,s0
    add	s4,s4,s10
    sltu	s0,a6,t1
    sltu	s10,a7,t1
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s8,a0,t1
    add	s0,s0,s8
    slli	s4,s4,2
    add	s4,s0,s4
    slli	s10,s4,1
    sltu	s0,a6,a7
    sltu	s8,a0,a7
    add	s4,s10,s4
    add	s0,s0,s8
    add	s0,s0,s4
    slli	s0,s0,1
    sltu	s4,a0,a6
    add	s0,s7,s0
    add	s0,s0,s4
    lbu	s0,0(s0)
    lw	s4,8(sp)
    sb	a0,6(a5)
    bge	s4,s0,L_68
L_20:
    li	a2,1
    bne	a4,t0,L_3
L_66:
    slli	a3,a4,3
    sub	a3,a3,a4
    addi	a5,sp,72
    slli	a3,a3,1
    add	a3,a5,a3
    li	a5,0
L_5:
    lbu	a1,0(a3)
    bne	a1,a5,L_64
    lbu	a1,7(a3)
    bne	a1,zero,L_64
    addi	a5,a5,1
    andi	a5,a5,0xff
    addi	a3,a3,1
    bne	a5,t2,L_5
    beq	a2,zero,L_38
    la	a5,L_ANCHOR0
    sw	s2,0(a5)
L_38:
    mv	a0,t0
    li	a7,1
    #APP
    # 18 "ripes_main.c" 1
    ecall
    # 0 "" 2
    #NO_APP
    li	a0,58
    li	a7,11
    #APP
    # 18 "ripes_main.c" 1
    ecall
    # 0 "" 2
    #NO_APP
    addi	a5,sp,36
    add	a4,t0,a5
    beq	t0,zero,L_37
L_36:
    li	a0,32
    li	a7,11
    #APP
    # 18 "ripes_main.c" 1
    ecall
    # 0 "" 2
    #NO_APP
    li	a7,1
    lbu	a0,0(a5)
    #APP
    # 18 "ripes_main.c" 1
    ecall
    # 0 "" 2
    #NO_APP
    addi	a5,a5,1
    bne	a4,a5,L_36
    j	L_37
L_14:
    lbu	t5,0(a2)
    sb	t5,0(a5)
    lbu	t4,1(a2)
    sb	t4,1(a5)
    lbu	t3,2(a2)
    sltu	s0,t4,t5
    sb	t3,2(a5)
    lbu	t1,6(a2)
    sltu	a0,t3,t5
    add	s0,s0,a0
    sb	t1,3(a5)
    lbu	a6,4(a2)
    lbu	a7,3(a2)
    sltu	s4,t1,t5
    slli	a0,a6,8
    or	a0,a0,a7
    sh	a0,4(a5)
    lbu	a0,5(a2)
    add	s0,s0,s4
    sltu	s4,a7,t5
    add	s0,s0,s4
    sltu	s4,a6,t5
    add	s0,s0,s4
    sltu	s10,a0,t5
    sltu	s8,t1,t4
    sltu	s4,t3,t4
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s8,a7,t4
    slli	s10,s0,1
    add	s4,s4,s8
    sltu	s8,a6,t4
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s10,a0,t4
    add	s10,s4,s10
    sltu	s8,a7,t3
    slli	s0,s0,1
    sltu	s4,t1,t3
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s10,a6,t3
    slli	s8,s0,2
    add	s4,s4,s10
    sltu	s10,a0,t3
    add	s8,s8,s0
    add	s4,s4,s10
    sltu	s0,a6,t1
    sltu	s10,a7,t1
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s8,a0,t1
    add	s0,s0,s8
    slli	s4,s4,2
    add	s4,s0,s4
    slli	s10,s4,1
    sltu	s0,a6,a7
    sltu	s8,a0,a7
    add	s4,s10,s4
    add	s0,s0,s8
    add	s0,s0,s4
    slli	s0,s0,1
    sltu	s4,a0,a6
    add	s0,s7,s0
    add	s0,s0,s4
    lbu	s0,0(s0)
    lw	s4,8(sp)
    sb	a0,6(a5)
    blt	s4,s0,L_20
    lbu	s4,7(a2)
    la	s0,L_ANCHOR1
    sb	s4,7(a5)
    lbu	s4,8(a2)
    sb	s4,8(a5)
    lbu	s4,9(a2)
    sb	s4,9(a5)
    lbu	s4,13(a2)
    add	s4,s0,s4
    lbu	s4,3(s4)
    sb	s4,10(a5)
    lbu	s4,10(a2)
    add	s4,s0,s4
    lbu	s4,6(s4)
    sb	s4,11(a5)
    lbu	s4,11(a2)
    add	s4,s0,s4
    lbu	s4,3(s4)
    sb	s4,12(a5)
    lbu	a2,12(a2)
    add	s0,s0,a2
    lbu	s0,6(s0)
    j	L_30
L_15:
    lbu	t5,0(a2)
    sb	t5,0(a5)
    lbu	t4,1(a2)
    sb	t4,1(a5)
    lbu	t3,2(a2)
    sltu	s0,t4,t5
    sb	t3,2(a5)
    lbu	t1,5(a2)
    sltu	a0,t3,t5
    add	s0,s0,a0
    sb	t1,3(a5)
    lbu	a6,3(a2)
    lbu	a7,6(a2)
    sltu	s4,t1,t5
    slli	a0,a6,8
    or	a0,a7,a0
    sh	a0,4(a5)
    lbu	a0,4(a2)
    add	s0,s0,s4
    sltu	s4,a7,t5
    add	s0,s0,s4
    sltu	s4,a6,t5
    add	s0,s0,s4
    sltu	s10,a0,t5
    sltu	s8,t1,t4
    sltu	s4,t3,t4
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s8,a7,t4
    slli	s10,s0,1
    add	s4,s4,s8
    sltu	s8,a6,t4
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s10,a0,t4
    add	s10,s4,s10
    sltu	s8,a7,t3
    slli	s0,s0,1
    sltu	s4,t1,t3
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s10,a6,t3
    slli	s8,s0,2
    add	s4,s4,s10
    sltu	s10,a0,t3
    add	s8,s8,s0
    add	s4,s4,s10
    sltu	s0,a6,t1
    sltu	s10,a7,t1
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s8,a0,t1
    add	s0,s0,s8
    slli	s4,s4,2
    add	s4,s0,s4
    slli	s10,s4,1
    sltu	s0,a6,a7
    sltu	s8,a0,a7
    add	s4,s10,s4
    add	s0,s0,s8
    add	s0,s0,s4
    slli	s0,s0,1
    sltu	s4,a0,a6
    add	s0,s7,s0
    add	s0,s0,s4
    lbu	s0,0(s0)
    lw	s4,8(sp)
    sb	a0,6(a5)
    blt	s4,s0,L_20
    lbu	s0,7(a2)
    sb	s0,7(a5)
    lbu	s0,8(a2)
    sb	s0,8(a5)
    lbu	s0,9(a2)
    sb	s0,9(a5)
    lbu	s0,12(a2)
    sb	s0,10(a5)
    lbu	s0,13(a2)
    sb	s0,11(a5)
    lbu	s0,10(a2)
    sb	s0,12(a5)
    lbu	s0,11(a2)
    j	L_30
L_19:
    lbu	t5,1(a2)
    sb	t5,0(a5)
    lbu	t4,4(a2)
    sb	t4,1(a5)
    lbu	t3,2(a2)
    sltu	a0,t4,t5
    sb	t3,2(a5)
    lbu	t1,0(a2)
    sltu	s0,t3,t5
    add	s0,s0,a0
    sb	t1,3(a5)
    lbu	a6,5(a2)
    lbu	a7,3(a2)
    sltu	s4,t1,t5
    slli	a0,a6,8
    or	a0,a7,a0
    sh	a0,4(a5)
    lbu	a0,6(a2)
    add	s0,s0,s4
    sltu	s4,a7,t5
    add	s0,s0,s4
    sltu	s4,a6,t5
    add	s0,s0,s4
    sltu	s10,a0,t5
    sltu	s8,t1,t4
    sltu	s4,t3,t4
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s8,a7,t4
    slli	s10,s0,1
    add	s4,s4,s8
    sltu	s8,a6,t4
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s10,a0,t4
    add	s10,s4,s10
    sltu	s8,a7,t3
    slli	s0,s0,1
    sltu	s4,t1,t3
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s10,a6,t3
    slli	s8,s0,2
    add	s4,s4,s10
    sltu	s10,a0,t3
    add	s8,s8,s0
    add	s4,s4,s10
    sltu	s0,a6,t1
    sltu	s10,a7,t1
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s8,a0,t1
    add	s0,s0,s8
    slli	s4,s4,2
    add	s4,s0,s4
    slli	s10,s4,1
    sltu	s0,a6,a7
    sltu	s8,a0,a7
    add	s4,s10,s4
    add	s0,s0,s8
    add	s0,s0,s4
    slli	s0,s0,1
    sltu	s4,a0,a6
    add	s0,s7,s0
    add	s0,s0,s4
    lbu	s0,0(s0)
    lw	s4,8(sp)
    sb	a0,6(a5)
    blt	s4,s0,L_20
    lbu	s4,8(a2)
    la	s0,L_ANCHOR1
    add	s4,s0,s4
    lbu	s4,3(s4)
    sb	s4,7(a5)
    lbu	s4,11(a2)
    add	s4,s0,s4
    lbu	s4,6(s4)
    sb	s4,8(a5)
    lbu	s4,9(a2)
    sb	s4,9(a5)
    lbu	s4,7(a2)
    add	s4,s0,s4
    lbu	s4,6(s4)
    sb	s4,10(a5)
    lbu	s4,10(a2)
    j	L_63
L_17:
    lbu	t5,3(a2)
    sb	t5,0(a5)
    lbu	t4,0(a2)
    sb	t4,1(a5)
    lbu	t3,2(a2)
    sltu	s0,t4,t5
    sb	t3,2(a5)
    lbu	t1,4(a2)
    sltu	a0,t3,t5
    add	s0,s0,a0
    sb	t1,3(a5)
    lbu	a6,5(a2)
    lbu	a7,1(a2)
    sltu	s4,t1,t5
    slli	a0,a6,8
    or	a0,a7,a0
    sh	a0,4(a5)
    lbu	a0,6(a2)
    add	s0,s0,s4
    sltu	s4,a7,t5
    add	s0,s0,s4
    sltu	s4,a6,t5
    add	s0,s0,s4
    sltu	s10,a0,t5
    sltu	s8,t1,t4
    sltu	s4,t3,t4
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s8,a7,t4
    slli	s10,s0,1
    add	s4,s4,s8
    sltu	s8,a6,t4
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s10,a0,t4
    add	s10,s4,s10
    sltu	s8,a7,t3
    slli	s0,s0,1
    sltu	s4,t1,t3
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s10,a6,t3
    slli	s8,s0,2
    add	s4,s4,s10
    sltu	s10,a0,t3
    add	s8,s8,s0
    add	s4,s4,s10
    sltu	s0,a6,t1
    sltu	s10,a7,t1
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s8,a0,t1
    add	s0,s0,s8
    slli	s4,s4,2
    add	s4,s0,s4
    slli	s10,s4,1
    sltu	s0,a6,a7
    sltu	s8,a0,a7
    add	s4,s10,s4
    add	s0,s0,s8
    add	s0,s0,s4
    slli	s0,s0,1
    sltu	s4,a0,a6
    add	s0,s7,s0
    add	s0,s0,s4
    lbu	s0,0(s0)
    lw	s4,8(sp)
    sb	a0,6(a5)
    blt	s4,s0,L_20
    lbu	s4,10(a2)
    la	s0,L_ANCHOR1
    add	s4,s0,s4
    lbu	s4,3(s4)
    sb	s4,7(a5)
    lbu	s4,7(a2)
    add	s4,s0,s4
    lbu	s4,6(s4)
    sb	s4,8(a5)
    lbu	s4,9(a2)
    sb	s4,9(a5)
    lbu	s4,11(a2)
    add	s4,s0,s4
    lbu	s4,6(s4)
    sb	s4,10(a5)
    lbu	s4,8(a2)
L_63:
    add	s0,s0,s4
    lbu	s0,3(s0)
    sb	s0,11(a5)
    lbu	s0,12(a2)
    sb	s0,12(a5)
    lbu	s0,13(a2)
    j	L_30
L_11:
    lbu	t5,0(a2)
    sb	t5,0(a5)
    lbu	t4,5(a2)
    sb	t4,1(a5)
    lbu	t3,4(a2)
    sltu	s0,t4,t5
    sb	t3,2(a5)
    lbu	t1,3(a2)
    sltu	a0,t3,t5
    add	s0,s0,a0
    sb	t1,3(a5)
    lbu	a7,2(a2)
    lbu	a6,1(a2)
    sltu	s4,t1,t5
    slli	a0,a7,8
    or	a0,a0,a6
    slli	s8,a0,8
    srli	a0,a0,8
    or	s8,s8,a0
    sh	s8,4(a5)
    lbu	a0,6(a2)
    add	s0,s0,s4
    sltu	s4,a7,t5
    add	s0,s0,s4
    sltu	s4,a6,t5
    add	s0,s0,s4
    sltu	s10,a0,t5
    sltu	s8,t1,t4
    sltu	s4,t3,t4
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s8,a7,t4
    slli	s10,s0,1
    add	s4,s4,s8
    sltu	s8,a6,t4
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s10,a0,t4
    add	s10,s4,s10
    sltu	s8,a7,t3
    slli	s0,s0,1
    sltu	s4,t1,t3
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s10,a6,t3
    slli	s8,s0,2
    add	s4,s4,s10
    sltu	s10,a0,t3
    add	s8,s8,s0
    add	s4,s4,s10
    sltu	s0,a6,t1
    sltu	s10,a7,t1
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s8,a0,t1
    add	s0,s0,s8
    slli	s4,s4,2
    add	s4,s0,s4
    slli	s10,s4,1
    sltu	s0,a6,a7
    sltu	s8,a0,a7
    add	s4,s10,s4
    add	s0,s0,s8
    add	s0,s0,s4
    slli	s0,s0,1
    sltu	s4,a0,a6
    add	s0,s7,s0
    add	s0,s0,s4
    lbu	s0,0(s0)
    lw	s4,8(sp)
    sb	a0,6(a5)
    blt	s4,s0,L_20
    lbu	s0,7(a2)
    sb	s0,7(a5)
    lbu	s0,12(a2)
    sb	s0,8(a5)
    lbu	s0,11(a2)
    sb	s0,9(a5)
    lbu	s0,10(a2)
    sb	s0,10(a5)
    lbu	s0,9(a2)
    sb	s0,11(a5)
    lbu	s0,8(a2)
    sb	s0,12(a5)
    lbu	s0,13(a2)
    j	L_30
L_16:
    lbu	t5,0(a2)
    sb	t5,0(a5)
    lbu	t4,1(a2)
    sb	t4,1(a5)
    lbu	t3,2(a2)
    sltu	s0,t4,t5
    sb	t3,2(a5)
    lbu	t1,4(a2)
    sltu	a0,t3,t5
    add	s0,s0,a0
    sb	t1,3(a5)
    lbu	a6,6(a2)
    lbu	a7,5(a2)
    sltu	s4,t1,t5
    slli	a0,a6,8
    or	a0,a0,a7
    sh	a0,4(a5)
    lbu	a0,3(a2)
    add	s0,s0,s4
    sltu	s4,a7,t5
    add	s0,s0,s4
    sltu	s4,a6,t5
    add	s0,s0,s4
    sltu	s10,a0,t5
    sltu	s8,t1,t4
    sltu	s4,t3,t4
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s8,a7,t4
    slli	s10,s0,1
    add	s4,s4,s8
    sltu	s8,a6,t4
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s10,a0,t4
    add	s10,s4,s10
    sltu	s8,a7,t3
    slli	s0,s0,1
    sltu	s4,t1,t3
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s10,a6,t3
    slli	s8,s0,2
    add	s4,s4,s10
    sltu	s10,a0,t3
    add	s8,s8,s0
    add	s4,s4,s10
    sltu	s0,a6,t1
    sltu	s10,a7,t1
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s8,a0,t1
    add	s0,s0,s8
    slli	s4,s4,2
    add	s4,s0,s4
    slli	s10,s4,1
    sltu	s0,a6,a7
    sltu	s8,a0,a7
    add	s4,s10,s4
    add	s0,s0,s8
    add	s0,s0,s4
    slli	s0,s0,1
    sltu	s4,a0,a6
    add	s0,s7,s0
    add	s0,s0,s4
    lbu	s0,0(s0)
    lw	s4,8(sp)
    sb	a0,6(a5)
    blt	s4,s0,L_20
    lbu	s4,7(a2)
    la	s0,L_ANCHOR1
    sb	s4,7(a5)
    lbu	s4,8(a2)
    sb	s4,8(a5)
    lbu	s4,9(a2)
    sb	s4,9(a5)
    lbu	s4,11(a2)
    add	s4,s0,s4
    lbu	s4,3(s4)
    sb	s4,10(a5)
    lbu	s4,12(a2)
    add	s4,s0,s4
    lbu	s4,6(s4)
    sb	s4,11(a5)
    lbu	s4,13(a2)
    add	s4,s0,s4
    lbu	s4,3(s4)
    sb	s4,12(a5)
    lbu	a2,10(a2)
    add	s0,s0,a2
    lbu	s0,6(s0)
    j	L_30
L_18:
    lbu	t5,4(a2)
    sb	t5,0(a5)
    lbu	t4,3(a2)
    sb	t4,1(a5)
    lbu	t3,2(a2)
    sltu	s0,t4,t5
    sb	t3,2(a5)
    lbu	t1,1(a2)
    sltu	a0,t3,t5
    add	s0,s0,a0
    sb	t1,3(a5)
    lbu	a6,5(a2)
    lbu	a7,0(a2)
    sltu	s4,t1,t5
    slli	a0,a6,8
    or	a0,a7,a0
    sh	a0,4(a5)
    lbu	a0,6(a2)
    add	s0,s0,s4
    sltu	s4,a7,t5
    add	s0,s0,s4
    sltu	s4,a6,t5
    add	s0,s0,s4
    sltu	s10,a0,t5
    sltu	s8,t1,t4
    sltu	s4,t3,t4
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s8,a7,t4
    slli	s10,s0,1
    add	s4,s4,s8
    sltu	s8,a6,t4
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s10,a0,t4
    add	s10,s4,s10
    sltu	s8,a7,t3
    slli	s0,s0,1
    sltu	s4,t1,t3
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s10,a6,t3
    slli	s8,s0,2
    add	s4,s4,s10
    sltu	s10,a0,t3
    add	s8,s8,s0
    add	s4,s4,s10
    sltu	s0,a6,t1
    sltu	s10,a7,t1
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s8,a0,t1
    add	s0,s0,s8
    slli	s4,s4,2
    add	s4,s0,s4
    slli	s10,s4,1
    sltu	s0,a6,a7
    sltu	s8,a0,a7
    add	s4,s10,s4
    add	s0,s0,s8
    add	s0,s0,s4
    slli	s0,s0,1
    sltu	s4,a0,a6
    add	s0,s7,s0
    add	s0,s0,s4
    lbu	s0,0(s0)
    lw	s4,8(sp)
    sb	a0,6(a5)
    blt	s4,s0,L_20
    lbu	s0,11(a2)
    sb	s0,7(a5)
    lbu	s0,10(a2)
    sb	s0,8(a5)
    lbu	s0,9(a2)
    sb	s0,9(a5)
    lbu	s0,8(a2)
    sb	s0,10(a5)
    lbu	s0,7(a2)
    sb	s0,11(a5)
    lbu	s0,12(a2)
    sb	s0,12(a5)
    lbu	s0,13(a2)
    j	L_30
L_68:
    lbu	s0,7(a2)
    sb	s0,7(a5)
    lbu	s0,9(a2)
    sb	s0,8(a5)
    lbu	s0,12(a2)
    sb	s0,9(a5)
    lbu	s0,10(a2)
    sb	s0,10(a5)
    lbu	s0,8(a2)
    sb	s0,11(a5)
    lbu	s0,11(a2)
    sb	s0,12(a5)
    lbu	s0,13(a2)
L_30:
    addi	a2,t5,224
    addi	t5,sp,16
    add	t5,a2,t5
    addi	a2,t4,224
    addi	t4,sp,16
    sb	zero,-212(t5)
    add	t4,a2,t4
    li	a2,1
    sb	a2,-212(t4)
    addi	a2,t3,224
    addi	t3,sp,16
    add	t3,a2,t3
    li	a2,2
    sb	a2,-212(t3)
    addi	a2,t1,224
    addi	t1,sp,16
    add	t1,a2,t1
    li	a2,3
    sb	a2,-212(t1)
    addi	a2,a7,224
    addi	a7,sp,16
    add	a7,a2,a7
    li	a2,4
    sb	a2,-212(a7)
    addi	a2,a6,224
    addi	a6,sp,16
    add	a6,a2,a6
    li	a2,5
    sb	a2,-212(a6)
    addi	a2,a0,224
    addi	a0,sp,16
    add	a0,a2,a0
    li	a2,6
    sb	a2,-212(a0)
    lbu	a2,28(sp)
    lbu	t4,29(sp)
    lbu	t3,31(sp)
    slli	t5,a2,1
    add	t5,t5,a2
    addi	a0,sp,72
    addi	a7,a1,7
    lbu	t1,32(sp)
    add	a7,a0,a7
    slli	t5,t5,1
    sb	s0,13(a5)
    sltu	a0,a2,t4
    add	a6,a7,a2
    add	t5,t5,t4
    sub	t5,t5,a0
    lbu	s0,0(a6)
    sltu	a0,t4,t3
    sltu	a6,a2,t3
    slli	s4,t5,2
    add	a6,a6,a0
    add	s8,a7,t4
    sltu	a0,a2,t1
    sltu	a2,t4,t1
    add	s4,s4,t5
    sub	a6,t3,a6
    add	a0,a0,a2
    lbu	t4,0(s8)
    sltu	a2,t3,t1
    sub	a0,t1,a0
    add	a6,a6,s4
    slli	t5,s0,1
    slli	a6,a6,2
    sub	a0,a0,a2
    add	t5,t5,s0
    add	a2,a7,t3
    add	a0,a0,a6
    add	t4,t4,t5
    lbu	a6,0(a2)
    add	a7,a7,t1
    slli	a2,a0,2
    slli	t3,t4,1
    lbu	t1,0(a7)
    add	a2,a2,a0
    add	a7,t3,t4
    add	a6,a6,a7
    slli	a2,a2,4
    add	a2,a2,a0
    slli	a0,a6,1
    add	a0,a0,a6
    add	a2,a2,t1
    add	a2,a2,a0
    la	a0,pdb_r_face
    add	a2,a0,a2
    lbu	a2,0(a2)
    lw	a0,8(sp)
    blt	a0,a2,L_20
    addi	a2,sp,78
    add	a1,a2,a1
    li	a2,0
L_31:
    lbu	a0,7(a5)
    slli	a6,a2,1
    add	a2,a6,a2
    addi	a5,a5,1
    add	a2,a0,a2
    bne	a1,a5,L_31
    lw	a5,12(sp)
    and	a2,a2,a5
    add	a2,s6,a2
    lbu	a5,12(a2)
    lw	a2,8(sp)
    blt	a2,a5,L_20
    add	a3,s6,a3
    lbu	a4,744(a3)
    addi	a5,t6,224
    addi	a3,sp,16
    add	a5,a5,a3
    sb	a4,-180(a5)
    sb	zero,-192(a5)
    mv	a4,t6
    li	a2,1
    j	L_34
L_10:
    lbu	t5,0(a2)
    sb	t5,0(a5)
    lbu	t4,4(a2)
    sb	t4,1(a5)
    lbu	t3,1(a2)
    sltu	s0,t4,t5
    sb	t3,2(a5)
    lbu	t1,3(a2)
    sltu	a0,t3,t5
    add	s0,s0,a0
    sb	t1,3(a5)
    lbu	a6,2(a2)
    lbu	a7,5(a2)
    sltu	s4,t1,t5
    slli	a0,a6,8
    or	a0,a7,a0
    sh	a0,4(a5)
    lbu	a0,6(a2)
    add	s0,s0,s4
    sltu	s4,a7,t5
    add	s0,s0,s4
    sltu	s4,a6,t5
    add	s0,s0,s4
    sltu	s10,a0,t5
    sltu	s8,t1,t4
    sltu	s4,t3,t4
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s8,a7,t4
    slli	s10,s0,1
    add	s4,s4,s8
    sltu	s8,a6,t4
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s10,a0,t4
    add	s10,s4,s10
    sltu	s8,a7,t3
    slli	s0,s0,1
    sltu	s4,t1,t3
    add	s0,s0,s10
    add	s4,s4,s8
    sltu	s10,a6,t3
    slli	s8,s0,2
    add	s4,s4,s10
    sltu	s10,a0,t3
    add	s8,s8,s0
    add	s4,s4,s10
    sltu	s0,a6,t1
    sltu	s10,a7,t1
    add	s4,s4,s8
    add	s0,s10,s0
    sltu	s8,a0,t1
    add	s0,s0,s8
    slli	s4,s4,2
    add	s4,s0,s4
    slli	s10,s4,1
    sltu	s0,a6,a7
    sltu	s8,a0,a7
    add	s4,s10,s4
    add	s0,s0,s8
    add	s0,s0,s4
    slli	s0,s0,1
    sltu	s4,a0,a6
    add	s0,s7,s0
    add	s0,s0,s4
    lbu	s0,0(s0)
    lw	s4,8(sp)
    sb	a0,6(a5)
    blt	s4,s0,L_20
    lbu	s0,7(a2)
    sb	s0,7(a5)
    lbu	s0,11(a2)
    sb	s0,8(a5)
    lbu	s0,8(a2)
    sb	s0,9(a5)
    lbu	s0,10(a2)
    sb	s0,10(a5)
    lbu	s0,12(a2)
    sb	s0,11(a5)
    lbu	s0,9(a2)
    sb	s0,12(a5)
    lbu	s0,13(a2)
    j	L_30
.data
L_12:
    .word	L_19
    .word	L_18
    .word	L_17
    .word	L_16
    .word	L_15
    .word	L_14
    .word	L_13
    .word	L_11
L_ANCHOR0:
nodes:
    .zero	4
L_ANCHOR1:
plus:
    .byte 0
    .byte 1, 2
    .byte 1, 2, 0
    .byte 2, 0
    .byte 1
    .zero	3
pdb_orient:
    .byte 0
    .byte 5, 5, 4, 4, 5, 4, 6, 3, 6, 3, 4, 4, 3, 5, 5
    .byte 1, 5, 5, 4, 4, 5, 5, 3, 3, 5, 4, 4, 3, 6, 4
    .byte 5, 4, 5, 4, 4, 4, 4, 2, 3, 5, 4, 5, 5, 4, 5
    .byte 5, 4, 5, 4, 3, 5, 3, 5, 4, 5, 4, 5, 5, 5, 4
    .byte 4, 5, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 4, 4, 5
    .byte 5, 5, 3, 4, 4, 5, 3, 5, 4, 5, 4, 5, 4, 5, 4
    .byte 4, 4, 4, 5, 5, 4, 4, 5, 4, 5, 5, 5, 4, 5, 4
    .byte 4, 5, 4, 5, 3, 5, 6, 5, 5, 4, 6, 4, 5, 5, 4
    .byte 5, 5, 6, 5, 4, 6, 5, 4, 5, 6, 4, 4, 5, 5, 6
    .byte 3, 4, 4, 5, 6, 4, 3, 5, 2, 5, 4, 5, 5, 5, 3
    .byte 5, 5, 5, 4, 5, 4, 5, 6, 5, 5, 5, 5, 5, 3, 6
    .byte 4, 3, 4, 3, 5, 4, 5, 5, 2, 5, 4, 5, 4, 5, 4
    .byte 5, 4, 4, 4, 4, 3, 5, 4, 5, 5, 4, 4, 5, 3, 5
    .byte 6, 4, 5, 5, 4, 5, 4, 5, 5, 5, 4, 4, 5, 5, 4
    .byte 4, 5, 5, 5, 5, 4, 4, 5, 4, 6, 5, 5, 5, 6, 6
    .byte 5, 4, 3, 4, 4, 5, 5, 6, 4, 6, 5, 5, 5, 5, 5
    .byte 4, 5, 5, 3, 5, 4, 4, 5, 4, 5, 5, 5, 4, 3, 3
    .byte 5, 4, 4, 5, 5, 6, 4, 3, 4, 4, 4, 4, 2, 5, 4
    .byte 4, 4, 4, 5, 4, 4, 4, 4, 4, 5, 5, 4, 3, 5, 5
    .byte 5, 5, 4, 5, 2, 4, 5, 3, 4, 5, 3, 4, 5, 5, 4
    .byte 5, 5, 3, 4, 4, 4, 5, 6, 4, 5, 4, 5, 3, 5, 4
    .byte 5, 5, 5, 4, 5, 4, 5, 4, 3, 3, 5, 3, 4, 4, 5
    .byte 5, 4, 4, 4, 5, 5, 4, 5, 4, 4, 3, 3, 5, 4, 4
    .byte 5, 3, 5, 2, 4, 4, 5, 4, 4, 4, 5, 5, 5, 5, 5
    .byte 4, 5, 4, 5, 4, 5, 4, 5, 5, 4, 5, 5, 5, 5, 4
    .byte 5, 5, 4, 5, 3, 4, 4, 5, 4, 4, 5, 4, 5, 5, 5
    .byte 3, 4, 3, 3, 4, 2, 3, 3, 5, 4, 4, 5, 5, 4, 5
    .byte 5, 2, 5, 4, 4, 5, 4, 4, 4, 4, 5, 5, 5, 2, 5
    .byte 5, 5, 4, 5, 4, 1, 5, 6, 5, 2, 5, 5, 4, 3, 4
    .byte 5, 4, 5, 5, 4, 5, 6, 3, 4, 4, 4, 4, 4, 5, 4
    .byte 4, 5, 3, 4, 5, 4, 4, 3, 5, 5, 5, 4, 5, 4, 5
    .byte 5, 6, 5, 4, 6, 5, 5, 5, 5, 4, 5, 5, 5, 5, 3
    .byte 5, 4, 5, 4, 4, 5, 5, 3, 4, 5, 5, 4, 4, 4, 5
    .byte 4, 5, 4, 5, 4, 5, 4, 4, 5, 4, 4, 5, 5, 4, 4
    .byte 5, 5, 4, 5, 5, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5
    .byte 5, 5, 5, 3, 4, 5, 6, 4, 5, 5, 5, 4, 4, 5, 4
    .byte 5, 4, 4, 5, 5, 4, 4, 5, 5, 4, 5, 5, 4, 6, 4
    .byte 4, 5, 4, 5, 6, 5, 6, 6, 5, 5, 4, 5, 2, 5, 5
    .byte 5, 5, 5, 3, 4, 3, 4, 5, 5, 4, 4, 3, 6, 6, 5
    .byte 5, 5, 5, 5, 6, 4, 4, 5, 5, 4, 4, 5, 6, 5, 5
    .byte 4, 5, 6, 5, 3, 4, 4, 5, 5, 5, 6, 5, 6, 4, 5
    .byte 5, 5, 6, 4, 4, 5, 4, 4, 4, 4, 5, 4, 4, 5, 4
    .byte 5, 4, 3, 4, 5, 5, 5, 5, 5, 5, 5, 4, 4, 5, 4
    .byte 4, 5, 3, 5, 3, 4, 3, 5, 4, 4, 5, 4, 5, 5, 5
    .byte 2, 4, 4, 3, 4, 3, 4, 4, 5, 3, 4, 5, 5, 4, 5
    .byte 4, 5, 4, 5, 4, 5, 5, 5, 4, 5, 5, 5, 5, 5, 6
    .byte 5, 4, 5, 6, 5, 4, 5, 3, 5, 5, 4, 3, 4, 4, 4
    .byte 5, 4, 4, 5, 4, 5, 6, 5, 4, 5, 5, 4, 4, 5, 5
    .byte 5, 4, 5, 4, 5, 3, 5, 5
    .zero	3
face_start:
    .byte 0
    .byte 0
    .byte 0
    .byte 3, 3, 3, 6, 6, 6
    .zero	3
pdb_r_face:
    .byte 6, 4, 6, 4, 4, 4, 6, 6, 7, 6, 7, 7, 7, 6, 6
    .byte 4, 7, 5, 6, 5, 5, 7, 5, 7, 5, 7, 6, 6, 7, 6
    .byte 6, 7, 7, 7, 6, 6, 6, 6, 4, 7, 7, 7, 7, 6, 6
    .byte 5, 6, 7, 7, 7, 6, 7, 7, 7, 6, 7, 7, 7, 7, 7
    .byte 6, 7, 7, 6, 7, 7, 7, 7, 5, 7, 7, 7, 6, 6, 5
    .byte 6, 7, 7, 8, 5, 7, 3, 7, 5, 5, 4, 5, 5, 7, 6, 7
    .byte 7, 7, 7, 6, 7, 6, 5, 4, 6, 4, 7, 6, 7, 7, 6
    .byte 7, 6, 6, 6, 7, 6, 7, 7, 6, 7, 6, 5, 5, 6, 6
    .byte 7, 8, 6, 7, 7, 7, 7, 5, 8, 7, 7, 8, 7, 6, 7, 7
    .byte 7
    .byte 6, 6, 6, 7, 7, 6, 7, 6, 7, 7, 5
    .byte 7, 7, 7, 7, 5, 6, 5, 6, 7, 6, 6, 7, 7, 6, 4, 6
    .byte 5, 5, 3, 5, 6, 7, 7, 6, 7, 7, 7, 6, 4, 7, 5, 6
    .byte 6, 5, 7, 6, 7, 5, 7, 7, 7, 6, 7, 7, 7, 7, 7, 5
    .byte 7, 6, 6, 5, 7, 6, 7, 6, 6, 7, 4, 7, 7, 8, 7, 7
    .byte 7, 7, 8, 7, 6, 6, 6, 6, 7, 6, 7, 6, 7, 7, 7, 7
    .byte 7, 4, 7, 7, 8, 6, 5, 6, 7, 7, 6, 7, 6, 7, 4, 7
    .byte 6, 5, 4, 5, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 6, 3
    .byte 6, 5, 7, 6, 7, 7, 7, 6, 6, 7, 6, 6, 6, 7, 6, 6
    .byte 7, 7, 6, 5, 5, 6, 7, 7, 5, 7, 7, 7, 6, 5, 7, 7
    .byte 7, 7, 7, 7, 7, 7, 6, 6, 7, 6, 7, 7, 5, 6, 7, 7
    .byte 7, 5, 6, 6, 7, 7, 6, 6, 6, 6, 6, 7, 6, 6, 8, 6
    .byte 4, 4, 7, 4, 6, 6, 5, 6, 4, 8, 7, 6, 6, 6, 6, 7
    .byte 7, 6, 5, 6, 7, 6, 8, 5, 5, 6, 7, 7, 7, 5, 6, 6
    .byte 7, 7, 6, 7, 6, 7, 5, 7, 5, 6, 6, 6, 7, 6, 8, 6
    .byte 6, 7, 7, 6, 6, 7, 7, 7, 7, 7, 6, 6, 7, 5, 6, 8
    .byte 6, 7, 6, 7, 7, 7, 7, 7, 5, 6, 7, 6, 6, 5, 6, 6
    .byte 0
    .byte 7, 7, 7, 7, 6, 7, 6, 7, 7, 7, 6, 6, 6, 7, 7
    .byte 6, 6, 7, 6, 7, 7, 6, 6, 6, 7, 6, 8, 7, 7, 7, 7
    .byte 7, 6, 6, 7, 7, 7, 7, 7, 6, 6, 7, 6, 7, 6, 6
    .byte 7, 7, 6, 7, 8, 6, 7, 8, 7, 7, 6, 7, 6, 7, 7, 7
    .byte 6, 7, 6, 8, 7, 6, 7, 7, 6, 7, 7, 7, 7, 7, 6, 7
    .byte 6, 6, 4, 4, 5, 7, 4, 7, 6, 5, 6, 5, 6, 6, 6
    .byte 6, 6, 8, 8, 5, 4, 7, 7, 5, 5, 7, 6, 6, 6, 7, 7
    .byte 7, 6, 6, 6, 7, 7, 7, 6, 7, 5, 7, 6, 5, 7, 6
    .byte 6, 6, 6, 7, 6, 7, 7, 6, 6, 7, 7, 7, 7, 6, 6
    .byte 7, 7, 6, 5, 7, 7, 7, 6, 6, 7, 6, 7, 6, 6, 6
    .byte 6, 7, 6, 7, 6, 7, 5, 6, 4, 4, 6, 6, 5, 4, 7
    .byte 8, 6, 6, 5, 5, 6, 5, 6, 7, 7, 7, 6, 4, 7, 8, 6
    .byte 6, 6, 6, 7, 7, 7, 7, 6, 5, 6, 6, 8, 6, 5, 7, 5
    .byte 6, 6, 7, 7, 7, 7, 6, 7, 7, 6, 6, 7, 7, 6, 7
    .byte 7, 7, 7, 8, 6, 7, 7, 6, 7, 6, 7, 7, 6, 6, 6, 6
    .byte 6, 5, 6, 6, 6, 7, 6, 5, 5, 7, 6, 5, 6, 5, 5
    .byte 6, 6, 5, 3, 5, 6, 5, 5, 7, 7, 5, 8, 7, 6, 6, 7
    .byte 5, 5, 7, 6, 6, 6, 6, 5, 7, 7, 7, 6, 6, 6, 7
    .byte 6, 7, 6, 7, 5, 7, 7, 6, 6, 6, 5, 7, 6, 6, 6
    .byte 7, 6, 7, 7, 7, 7, 6, 6, 6, 7, 6, 7, 6, 7, 6
    .byte 7, 8, 6, 6, 7, 6, 7, 6, 6, 4, 6, 6, 7, 6, 6, 5
    .byte 5, 7, 7, 4, 7, 5, 5, 4, 6, 4, 5, 7, 7, 7, 6
    .byte 7, 7, 6, 6, 7, 5, 7, 7, 4, 7, 7, 6, 6, 5, 7
    .byte 6, 7, 7, 7, 7, 6, 6, 6, 7, 6, 6, 7, 6, 4, 7
    .byte 7, 6, 6, 7, 6, 7, 8, 7, 6, 7, 7, 5, 7, 7, 6, 7
    .byte 6, 7, 7, 6, 6, 7, 6, 7, 8, 7, 6, 7, 7, 6, 4, 6
    .byte 6, 6, 6, 5, 7, 6, 6, 7, 5, 7, 1, 6, 6, 5, 6
    .byte 6, 7, 7, 6, 6, 7, 5, 7, 6, 6, 6, 6, 6, 7, 7
    .byte 6, 6, 6, 6, 7, 7, 6, 7, 7, 7, 7, 6, 6, 7, 6
    .byte 7, 6, 6, 6, 7, 6, 7, 8, 6, 6, 7, 7, 6, 7, 6, 7
    .byte 6, 7, 6, 7, 6, 7, 7, 6, 7, 6, 7, 6, 6, 7, 7
    .byte 7, 6, 7, 6, 5, 8, 6, 7, 4, 7, 7, 4, 6, 6, 4, 4
    .byte 5, 6, 6, 5, 7, 5, 7, 6, 7, 5, 4, 7, 6, 7, 6
    .byte 5, 7, 7, 5, 7, 6, 6, 8, 7, 7, 7, 7, 7, 6, 6, 6
    .byte 7, 6, 7, 7, 5, 6, 6, 7, 7, 5, 7, 6, 7, 7, 7
    .byte 7, 7, 6, 6, 6, 6, 7, 8, 7, 5, 7, 7, 6, 7, 6, 7
    .byte 7, 7, 6, 7, 7, 7, 4, 6, 6, 7, 6, 7, 5, 4, 6
    .byte 5, 6, 6, 4, 5, 5, 7, 6, 5, 7, 6, 6, 7, 7, 5
    .byte 6, 6, 7, 7, 7, 6, 4, 7, 7, 6, 7, 6, 6, 7, 6
    .byte 6, 5, 7, 6, 6, 6, 6, 6, 7, 6, 7, 7, 6, 8, 6, 6
    .byte 7, 6, 6, 6, 6, 7, 6, 7, 7, 7, 6, 7, 6, 5, 8, 6
    .byte 7, 6, 7, 7, 7, 7, 7, 6, 5, 6, 5, 7, 5, 5, 6
    .byte 5, 4, 5, 7, 3, 7, 7, 5, 6, 6, 5, 7, 6, 6, 5
    .byte 7, 7, 5, 5, 7, 7, 6, 5, 7, 5, 7, 5, 6, 6, 6
    .byte 7, 7, 6, 6, 7, 6, 7, 7, 4, 6, 6, 6, 7, 7, 7
    .byte 7, 7, 6, 7, 7, 7, 6, 6, 7, 6, 7, 7, 5, 6, 7
    .byte 7, 6, 6, 6, 7, 7, 7, 6, 6, 7, 7, 7, 6, 6, 6
    .byte 7, 6, 6, 7, 7, 5, 5, 5, 5, 5, 7, 4, 3, 7, 7
    .byte 7, 6, 6, 5, 6, 6, 7, 7, 7, 7, 6, 4, 7, 7, 6
    .byte 7, 6, 6, 7, 7, 7, 7, 6, 6, 5, 6, 7, 6, 5, 6
    .byte 6, 7, 5, 7, 6, 8, 7, 7, 6, 7, 7, 7, 7, 7, 5, 6
    .byte 6, 7, 6, 7, 6, 7, 7, 6, 8, 7, 7, 7, 5, 6, 7, 6
    .byte 7, 6, 7, 5, 6, 7, 6, 5, 6, 7, 1, 7, 7, 7, 6
    .byte 6, 7, 6, 6, 7, 7, 5, 6, 6, 7, 7, 7, 6, 7, 7
    .byte 7, 6, 7, 6, 5, 6, 6, 7, 6, 6, 7, 7, 7, 7, 6
    .byte 7, 6, 7, 6, 7, 5, 7, 7, 6, 6, 7, 6, 6, 7, 7
    .byte 7, 7, 5, 7, 8, 7, 6, 7, 6, 5, 7, 7, 6, 5, 7, 6
    .byte 7, 7, 7, 7, 7, 7, 6, 6, 7, 7, 6, 7, 7, 6, 7
    .byte 6, 5, 5, 6, 5, 6, 6, 5, 4, 6, 7, 6, 6, 6, 6
    .byte 5, 7, 7, 7, 7, 7, 6, 5, 7, 6, 5, 5, 6, 6, 6
    .byte 7, 7, 6, 7, 6, 7, 6, 6, 6, 7, 6, 7, 6, 5, 7
    .byte 5, 6, 6, 7, 5, 7, 7, 5, 7, 6, 8, 7, 6, 6, 6, 7
    .byte 7, 6, 6, 7, 7, 6, 7, 7, 6, 7, 5, 7, 6, 7, 5
    .byte 6, 5, 6, 6, 6, 5, 7, 7, 7, 7, 5, 7, 1, 7, 7
    .byte 6, 7, 5, 6, 6, 6, 7, 6, 6, 6, 6, 5, 6, 7, 6
    .byte 6, 6, 6, 7, 7, 7, 7, 6, 7, 8, 7, 7, 6, 6, 6, 7
    .byte 5, 7, 6, 7, 6, 6, 6, 7, 8, 6, 7, 7, 6, 6, 7, 7
    .byte 6, 6, 6, 6, 7, 7, 7, 8, 7, 7, 7, 6, 5, 6, 6, 7
    .byte 8, 6, 7, 6, 6, 7, 6, 6, 4, 7, 6, 5, 7, 7, 3, 5
    .byte 5, 6, 6, 6, 7, 4, 7, 6, 6, 6, 5, 6, 6, 7, 6
    .byte 6, 7, 6, 5, 6, 7, 6, 7, 6, 7, 6, 6, 7, 5, 6
    .byte 7, 7, 7, 7, 7, 5, 6, 6, 6, 7, 6, 7, 7, 6, 7
    .byte 7, 7, 7, 6, 5, 6, 7, 7, 8, 7, 6, 7, 7, 6, 7, 7
    .byte 6, 6, 7, 6, 7, 7, 6, 5, 7, 7, 6, 5, 4, 6, 6
    .byte 7, 4, 7, 5, 6, 4, 6, 5, 6, 6, 6, 6, 6, 7, 6
    .byte 5, 7, 7, 6, 6, 7, 3, 6, 6, 6, 6, 5, 7, 6, 7
    .byte 7, 6, 8, 6, 6, 7, 7, 6, 7, 7, 5, 5, 6, 7, 7, 6
    .byte 7, 7, 6, 7, 7, 7, 7, 7, 5, 6, 6, 7, 7, 6, 7
    .byte 7, 6, 7, 7, 5, 6, 7, 6, 5, 7, 7, 7, 5, 6, 6
    .byte 6, 6, 6, 5, 8, 7, 5, 6, 6, 5, 3, 6, 4, 5, 6, 7
    .byte 7, 6, 7, 7, 6, 5, 6, 6, 6, 7, 5, 7, 6, 6, 6
    .byte 5, 7, 7, 6, 6, 7, 7, 6, 7, 7, 8, 6, 7, 7, 7, 4
    .byte 7, 6, 5, 7, 7, 6, 7, 8, 8, 6, 7, 7, 5, 7, 6, 6
    .byte 6, 7, 7, 6, 7, 6, 6, 7, 7, 8, 7, 6, 7, 7, 6, 5
    .byte 5, 7, 6, 6, 5, 7, 5, 5, 6, 6, 6, 2, 7, 5, 5
    .byte 6, 7, 7, 6, 7, 6, 6, 5, 7, 6, 6, 7, 6, 7, 7
    .byte 6, 6, 5, 6, 7, 7, 6, 7, 7, 6, 7, 7, 6, 6, 7
    .byte 7, 7, 5, 6, 6, 6, 6, 7, 7, 7, 7, 7, 8, 7, 7, 6
    .byte 6, 6, 6, 6, 6, 7, 6, 7, 6, 7, 7, 6, 7, 7, 7
    .byte 7, 7, 5, 6, 6, 6, 7, 7, 7, 6, 6, 7, 6, 6, 6
    .byte 7, 6, 3, 5, 5, 4, 5, 7, 7, 6, 8, 7, 6, 5, 7, 6
    .byte 5, 6, 6, 7, 7, 5, 5, 6, 7, 7, 7, 5, 7, 7, 5
    .byte 7, 7, 8, 6, 7, 7, 6, 5, 7, 5, 6, 7, 7, 6, 8, 7
    .byte 7, 7, 7, 6, 6, 6, 7, 7, 5, 7, 6, 6, 7, 6, 7
    .byte 6, 7, 8, 7, 6, 6, 6, 5, 6, 6, 7, 6, 6, 5, 7, 6
    .byte 5, 5, 6, 5, 3, 6, 5, 5, 5, 7, 6, 6, 7, 7, 5
    .byte 4, 7, 7, 6, 6, 5, 6, 7, 6, 6, 5, 6, 8, 7, 7, 6
    .byte 7, 6, 7, 6, 6, 6, 7, 7, 6, 5, 6, 6, 6, 6, 6
    .byte 7, 7, 7, 7, 7, 7, 6, 6, 7, 7, 5, 6, 7, 7, 5
    .byte 7, 7, 7, 7, 5, 7, 8, 7, 6, 6, 6, 6, 5, 5, 6, 7
    .byte 7, 1, 7, 7, 6, 6, 6, 7, 6, 6, 7, 7, 5, 6, 5
    .byte 7, 6, 5, 6, 7, 5, 7, 6, 6, 6, 6, 7, 7, 7, 6
    .byte 7, 6, 7, 6, 6, 5, 6, 6, 6, 6, 6, 7, 6, 7, 7
    .byte 6, 7, 6, 7, 8, 7, 6, 8, 7, 7, 8, 7
    .byte 7, 7, 7, 6, 6, 7, 7, 7, 7, 6, 8, 7, 6, 7, 6, 5
    .byte 7, 6, 7, 6, 6, 6, 6, 7, 6, 3, 5, 5, 7, 5, 6
    .byte 6, 6, 6, 5, 7, 7, 7, 6, 6, 7, 7, 4, 4, 6, 7
    .byte 5, 6, 6, 6, 6, 6, 7, 7, 8, 7, 5, 6, 6, 7, 6, 5
    .byte 7, 6, 6, 7, 5, 6, 7, 7, 7, 6, 7, 6, 7, 7, 6
    .byte 7, 7, 6, 7, 6, 6, 7, 7, 7, 6, 5, 7, 7, 6, 6
    .byte 7, 7, 7, 7, 7, 6, 6, 7, 6, 7, 6, 5, 7, 6, 6
    .byte 5, 4, 6, 3, 6, 7, 6, 6, 4, 7, 7, 6, 6, 7, 6
    .byte 6, 6, 6, 4, 6, 7, 5, 7, 5, 6, 6, 7, 7, 6, 6
    .byte 6, 6, 7, 6, 6, 6, 5, 6, 5, 7, 6, 7, 7, 5, 7
    .byte 7, 7, 7, 5, 7, 7, 7, 6, 6, 7, 8, 7, 6, 7, 5, 7
    .byte 5, 6, 7, 7, 7, 6, 7, 6, 7, 7, 6, 6, 5, 7, 6
    .byte 7, 6, 6, 7, 6, 4, 5, 6, 5, 5, 5, 7, 7, 6, 6
    .byte 5, 6, 7, 5, 6, 6, 6, 6, 5, 5, 7, 7, 7, 6, 6
    .byte 7, 7, 6, 7, 6, 6, 6, 6, 5, 7, 6, 6, 6, 5, 5
    .byte 6, 6, 7, 7, 6, 7, 8, 7, 7, 6, 6, 7, 7, 7, 7, 6
    .byte 7, 7, 5, 6, 7, 5, 7, 6, 7, 7, 7, 5, 7, 7, 6
    .byte 6, 6, 6, 5, 6, 6, 6, 6, 6, 5, 5, 6, 6, 7, 5
    .byte 2, 7, 7, 6, 6, 7, 6, 5, 5, 7, 6, 6, 6, 6, 5
    .byte 6, 7, 7, 7, 5, 6, 6, 7, 6, 7, 6, 7, 6, 6, 7
    .byte 6, 6, 7, 6, 7, 5, 6, 6, 7, 7, 7, 6, 8, 6, 8, 7
    .byte 7, 6, 6, 6, 6, 6, 7, 6, 7, 7, 7, 8, 7, 7, 7, 5
    .byte 6, 7, 7, 7, 7, 6, 6, 5, 7, 6, 6, 6, 7, 5, 5
    .byte 5, 6, 4, 8, 6, 6, 5, 6, 6, 7, 6, 6, 5, 6, 7, 6
    .byte 6, 7, 8, 7, 6, 7, 5, 6, 4, 5, 6, 7, 7, 7, 5, 7
    .byte 7, 6, 6, 6, 4, 7, 6, 7, 6, 6, 7, 7, 8, 6, 7, 6
    .byte 7, 7, 6, 8, 6, 7, 7, 4, 6, 7, 6, 7, 6, 5, 7, 8
    .byte 7, 6, 6, 7, 7, 6, 7, 6, 7, 7, 7, 5, 7, 6, 6
    .byte 6, 6, 5, 6, 6, 5, 6, 3, 5, 6, 7, 6, 4, 7, 6
    .byte 6, 6, 7, 5, 6, 7, 7, 7, 7, 7, 4, 7, 6, 6, 6
    .byte 6, 7, 7, 7, 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 7
    .byte 7, 6, 7, 7, 7, 8, 7, 7, 7, 6, 6, 7, 6, 7, 6, 6
    .byte 7, 7, 6, 7, 7, 6, 6, 7, 6, 7, 7, 7, 7, 6, 6
    .byte 4, 7, 6, 6, 6, 2, 6, 6, 6, 5, 7, 6, 5, 5, 7
    .byte 7, 5, 6, 6, 6, 7, 7, 5, 6, 7, 8, 6, 7, 6, 4, 5
    .byte 7, 6, 6, 6, 7, 7, 7, 7, 6, 7, 7, 7, 6, 7, 4
    .byte 7, 6, 6, 7, 6, 6, 6, 7, 7, 8, 7, 6, 7, 7, 7, 6
    .byte 7, 6, 4, 7, 7, 6, 6, 7, 7, 6, 6, 6, 7, 7, 7
    .byte 7, 7, 7, 7, 6, 7, 7, 5, 6, 2, 7, 6, 6, 5, 6
    .byte 6, 7, 5, 7, 7, 6, 7, 6, 7, 6, 5, 5, 7, 4, 6
    .byte 5, 7, 6, 6, 7, 6, 6, 6, 7, 6, 7, 6, 7, 6, 6
    .byte 5, 6, 7, 6, 7, 7, 6, 7, 6, 7, 7, 6, 8, 7, 7, 7
    .byte 7, 7, 7, 6, 6, 6, 7, 5, 6, 7, 7, 7, 7, 7, 8, 6
    .byte 7, 7, 6, 6, 6, 6, 6, 7, 7, 6, 6, 7, 7, 6, 5
    .byte 5, 5, 3, 5, 7, 6, 6, 5, 7, 6, 6, 6, 7, 5, 6
    .byte 5, 6, 4, 6, 7, 5, 6, 5, 7, 6, 6, 7, 6, 6, 7
    .byte 6, 6, 7, 6, 6, 6, 5, 6, 7, 7, 7, 6, 5, 6, 6
    .byte 7, 7, 6, 6, 7, 8, 6, 6, 8, 8, 7, 7, 7, 5, 7, 6
    .byte 6
    .byte 7, 8, 8, 7, 6, 6, 7, 6, 6, 7, 4, 6, 7, 7, 7, 6
    .byte 7, 5, 5, 6, 5, 4, 4, 5, 7, 7, 6, 6, 6, 6, 8, 5
    .byte 5, 6, 5, 6, 5, 6, 7, 7, 7, 5, 7, 7, 7, 5, 7
    .byte 6, 7, 6, 7, 4, 6, 6, 6, 5, 6, 5, 7, 5, 7, 7
    .byte 5, 8, 7, 8, 6, 7, 6, 7, 7, 7, 7, 5, 6, 6, 6, 7
    .byte 7, 5, 8, 6, 6, 8, 7, 4, 7, 6, 7, 5, 6, 6, 6, 7
    .byte 6, 7, 6, 6, 3, 6, 6, 6, 5, 6, 6, 6, 7, 5, 7
    .byte 7, 7, 7, 6, 7, 6, 3, 5, 6, 7, 6, 7, 6, 7, 6
    .byte 7, 6, 6, 7, 7, 6, 6, 7, 6, 6, 6, 6, 6, 6, 7
    .byte 6, 5, 7, 7, 6, 7, 6, 7, 7, 8, 6, 8, 6, 7, 7, 5
    .byte 5, 7, 7, 7, 7, 6, 7, 7, 6, 7, 6, 6, 7, 7, 7
    .byte 5, 6, 7, 6, 7, 7, 5, 7, 7, 5, 6, 6, 6, 7, 6
    .byte 2, 6, 6, 7, 6, 7, 7, 4, 6, 7, 6, 6, 6, 6, 6
    .byte 7, 7, 7, 6, 5, 6, 6, 7, 5, 7, 6, 7, 7, 6, 8, 5
    .byte 7, 7, 6, 7, 6, 6, 5, 7, 7, 7, 6, 7, 7, 7, 6
    .byte 6, 7, 7, 7, 6, 5, 7, 6, 7, 7, 6, 7, 7, 7, 6
    .byte 6, 6, 7, 7, 7, 7, 7, 7, 5, 6, 7, 7, 5, 6, 5
    .byte 6, 6, 6, 7, 6, 6, 2, 6, 7, 7, 7, 4, 7, 6, 7
    .byte 6, 6, 6, 6, 6, 6, 7, 7, 6, 5, 6, 5, 7, 6, 7
    .byte 7, 7, 7, 7, 6, 6, 5, 7, 6, 6, 6, 7, 5, 6, 7
    .byte 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 7, 5, 6, 7, 6
    .byte 7, 8, 7, 7, 7, 7, 6, 6, 6, 7, 7, 7, 7, 6, 7, 5
    .byte 7, 7, 6, 5, 3, 6, 6, 7, 5, 7, 6, 5, 5, 7, 6
    .byte 6, 5, 6, 6, 7, 7, 5, 6, 7, 7, 7, 6, 6, 3, 6
    .byte 6, 7, 5, 5, 7, 7, 7, 8, 5, 7, 7, 7, 6, 7, 5, 7
    .byte 6, 5, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
    .byte 6, 6, 5, 8, 7, 5, 7, 7, 7, 7, 7, 5, 7, 7, 7, 6
    .byte 7, 6, 7, 6, 7, 7, 5, 5, 5, 6, 5, 7, 5, 7, 6
    .byte 6, 5, 6, 7, 7, 6, 6, 6, 5, 7, 7, 7, 7, 7, 7
    .byte 6, 7, 6, 5, 5, 6, 7, 7, 7, 7, 5, 6, 6, 6, 6
    .byte 6, 5, 7, 6, 7, 6, 5, 6, 6, 7, 7, 8, 5, 8, 7, 6
    .byte 7, 6, 7, 7, 5, 6, 6, 6, 6, 6, 5, 8, 8, 6, 7, 7
    .byte 7, 7, 5, 7, 6, 7, 6, 6, 5, 7, 6, 7, 6, 6, 6
    .byte 5, 7, 6, 4, 5, 6, 6, 4, 5, 6, 6, 5, 6, 8, 7, 6
    .byte 6, 6, 6, 7, 6, 5, 6, 6, 6, 7, 6, 7, 6, 7, 7
    .byte 7, 7, 5, 7, 7, 7, 7, 7, 6, 6, 6, 6, 5, 6, 7
    .byte 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4, 7, 7, 7, 6
    .byte 7, 6, 6, 5, 7, 6, 8, 7, 7, 7, 7, 7, 7, 5, 7, 7
    .byte 7, 3, 8, 8, 7, 7, 7, 7, 4, 7, 7, 7, 4, 5, 7, 6
    .byte 7, 6, 6, 7, 7, 7, 5, 8, 8, 5, 6, 7, 8, 6, 6, 8
    .byte 8, 7
    .byte 7, 7, 8, 8, 8, 7, 8, 6, 7, 8, 8, 8, 6, 6, 5, 6
    .byte 7, 7, 8
    .byte 7, 7, 8, 6, 6, 6, 5, 6, 8, 7, 8, 7, 8, 7, 8, 7
    .byte 7, 8
    .byte 8, 8, 8, 7, 8, 6, 7, 7, 8, 7, 6, 6, 6, 7, 6, 5
    .byte 7, 5
    .byte 6, 5, 6, 5, 5, 6, 4, 6, 7, 7, 5, 5, 6, 7, 6
    .byte 6, 7, 4, 6, 6, 7, 6, 6, 7, 7, 7, 7, 6, 7, 7
    .byte 7, 5, 7, 7, 7, 7, 7, 7, 5, 6, 6, 7, 5, 7, 7
    .byte 5, 6, 6, 7, 6, 6, 5, 6, 7, 7, 5, 6, 7, 7, 5
    .byte 7, 6, 7, 7, 7, 7, 7, 7, 5, 7, 7, 7, 7, 7, 6
    .byte 6, 6, 6, 6, 6, 6, 5, 4, 4, 6, 5, 5, 6, 6, 6
    .byte 7, 8, 5, 6, 7, 6, 6, 7, 6, 5, 6, 6, 6, 6, 7, 7
    .byte 7, 6, 6, 7, 7, 7, 7, 7, 7, 7, 6, 7, 8, 6, 4, 6
    .byte 7, 5, 7, 6, 7, 5, 6, 6, 7, 6, 6, 5, 5, 7, 7
    .byte 7, 7, 7, 6, 6, 6, 6, 6, 6, 7, 7, 6, 7, 6, 6
    .byte 7, 7, 7, 3, 7, 7, 6, 7, 6, 6, 3, 7, 6, 7, 5
    .byte 5, 7, 6, 8, 5, 5, 6, 7, 6, 4, 7, 7, 5, 7, 6, 8
    .byte 5, 6, 7, 7, 7, 6, 7, 8, 7, 7, 7, 7, 7, 7, 7, 7
    .byte 7, 6, 5, 4, 6, 6, 7, 7, 7, 7, 8, 6, 5, 6, 5, 6
    .byte 7, 7, 7, 7, 7, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7
    .byte 7, 6, 7, 7, 7, 6, 5, 6, 7, 6, 6, 7, 5, 5, 6
    .byte 6, 6, 4, 7, 4, 6, 7, 7, 4, 5, 7, 7, 6, 6, 6
    .byte 5, 6, 6, 7, 5, 7, 6, 7, 7, 7, 6, 7, 7, 7, 6
    .byte 7, 8, 7, 7, 7, 6, 4, 6, 5, 7, 6, 6, 7, 6, 6, 6
    .byte 7, 6, 6, 6, 6, 7, 7, 5, 5, 7, 6, 5, 7, 7, 7
    .byte 6, 7, 7, 7, 6, 6, 6, 7, 7, 8, 7, 6, 6, 6, 6, 6
    .byte 6, 5, 4, 5, 6, 3, 5, 7, 6, 5, 6, 7, 7, 6, 7
    .byte 6, 6, 6, 6, 5, 6, 6, 6, 7, 5, 6, 5, 7, 6, 7
    .byte 7, 6, 8, 6, 7, 7, 7, 7, 7, 5, 7, 5, 6, 7, 7, 5
    .byte 5, 7, 7, 6, 5, 7, 7, 6, 5, 6, 7, 7, 7, 7, 6
    .byte 6, 6, 7, 6, 7, 7, 7, 7, 7, 6, 6, 6, 7, 7, 7
    .byte 6, 6, 7, 7, 6, 5, 6, 6, 5, 4, 6, 6, 5, 6, 7
    .byte 6, 7, 7, 6, 6, 6, 7, 5, 7, 6, 5, 6, 6, 5, 6
    .byte 7, 7, 8, 7, 7, 7, 6, 7, 7, 7, 6, 7, 7, 7, 7, 5
    .byte 4, 7, 7, 5, 7, 6, 7, 5, 6, 6, 6, 5, 5, 6, 6
    .byte 7, 7, 6, 7, 6, 7, 7, 6, 5, 7, 6, 7, 7, 6, 6
    .byte 7, 7, 8, 7, 6, 5, 6, 6, 6, 6, 6, 5, 5, 6, 7, 4
    .byte 5, 7, 5, 5, 5, 7, 7, 5, 7, 7, 5, 7, 7, 4, 5
    .byte 5, 6, 6, 5, 7, 5, 8, 7, 6, 7, 6, 8, 6, 6, 6, 7
    .byte 7, 6, 6, 7, 6, 7, 7, 7, 6, 6, 7, 7, 6, 5, 7
    .byte 6, 7, 5, 6, 6, 6, 7, 7, 6, 7, 6, 6, 7, 7, 7
    .byte 7, 8, 6, 6, 6, 6, 7, 7, 6, 6, 7, 6, 5, 6, 7, 4
    .byte 6, 6, 6, 6, 5, 7, 3, 6, 6, 7, 5, 5, 7, 7, 6
    .byte 7, 7, 5, 6, 5, 6, 6, 6, 7
    .byte 7, 8, 8, 6, 7, 6, 7, 6, 7, 7, 6, 7, 6, 7, 5, 6
    .byte 6, 7, 5, 6, 6, 6, 6, 6, 6, 7, 7, 6, 5, 7, 6
    .byte 5, 6, 7, 7, 4, 8, 7, 7, 7, 7, 7, 7, 7, 6, 6, 8
    .byte 7, 7, 7, 3, 7, 7, 7, 8, 6, 7, 3, 6, 7, 6, 5, 5
    .byte 6, 5, 8, 6, 6, 7, 6, 7, 5, 8, 7, 4, 6, 6, 7, 6
    .byte 5, 7, 7, 7, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
    .byte 7, 6, 6, 5, 5, 7, 7, 7, 7, 6, 7, 6, 6, 6, 4
    .byte 6, 7, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
    .byte 7, 7, 6, 7, 7, 6, 6, 6, 5, 6, 6, 6, 6, 6, 6
    .byte 5, 4, 7, 6, 5, 5, 7, 5, 7, 7, 6, 6, 7, 6, 6
    .byte 8, 5, 4, 5, 5, 6, 6, 7, 6, 7, 7, 6, 7, 7, 7, 7
    .byte 6, 7, 6, 7, 6, 7, 6, 5, 7, 7, 4, 6, 5, 6, 5
    .byte 5, 7, 7, 6, 5, 5, 6, 7, 6, 7, 8, 7, 6, 7, 6, 6
    .byte 7, 5, 7, 8, 6, 6, 7, 6, 7, 7, 7, 5, 6, 6, 6, 5
    .byte 8, 5, 6, 6, 6, 6, 5, 7, 4, 5, 7, 7, 5, 4, 7, 7
    .byte 5, 7, 7, 5, 5, 5, 7, 6, 7, 6, 6, 7, 7, 5, 7
    .byte 7, 6, 6, 7, 8, 6, 6, 7, 7, 5, 5, 6, 7, 6, 6, 6
    .byte 6, 5, 5, 6, 6, 7, 6, 6, 7, 7, 4, 6, 7, 7, 5
    .byte 7, 7, 7, 7, 7, 7, 8, 6, 6, 7, 7, 7, 7, 7, 2, 7
    .byte 7, 7, 7, 7, 7, 4, 7, 7, 6, 5, 4, 7, 6, 8, 6, 6
    .byte 7, 6, 6, 5, 7, 7, 5, 7, 7, 8, 6, 6, 7, 7, 6, 6
    .byte 6, 7, 7, 7, 8, 7, 7, 6, 7, 8, 8, 6, 5, 5, 6, 7
    .byte 7
    .byte 7, 7, 7, 7, 6, 5, 7, 5, 6, 7, 7, 8, 6, 8, 6, 7
    .byte 7, 6, 7, 7, 7, 8, 6, 8, 7, 7, 8, 8, 6, 5, 6, 5
    .byte 6
    .byte 5, 7, 5, 5, 5, 6, 7, 4, 4, 7, 6, 4, 6, 7, 7
    .byte 6, 6, 6, 6, 6, 6, 5, 6, 6, 7, 7, 6, 7, 6, 7
    .byte 6, 6, 7, 6, 7, 7, 6, 7, 6, 7, 7, 6, 6, 6, 7
    .byte 7, 7, 5, 6, 7, 6, 6, 6, 6, 7, 7, 5, 7, 6, 6
    .byte 7, 6, 5, 7, 6, 7, 7, 7, 7, 6, 7, 7, 7, 7, 6
    .byte 7, 6, 7, 5, 6, 6, 7, 5, 6, 7, 6, 5, 3, 7, 6
    .byte 6, 5, 6, 6, 7, 7, 6, 5, 7, 6, 6, 7, 5, 5, 6
    .byte 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 8, 6, 7, 6, 7
    .byte 7, 7, 5, 5, 7, 6, 5, 7, 6, 6, 4, 6, 6, 6, 6
    .byte 5, 6, 6, 6, 6, 6, 8, 7, 7, 6, 7, 6, 7, 6, 7, 7
    .byte 5, 7, 7, 7, 7, 6, 7, 5, 6, 6, 4, 6, 5, 5, 6
    .byte 8, 7, 5, 6, 7, 6, 7, 5, 6, 3, 6, 6, 7, 7, 6, 7
    .byte 5, 7, 6, 7, 6, 7, 6, 7, 7, 7, 6, 7, 6, 7, 6
    .byte 8, 7, 7, 6, 6, 7, 5, 6, 5, 6, 6, 7, 7, 5, 6, 6
    .byte 7, 5, 7, 6, 7, 6, 6, 5, 8, 7, 8, 7, 7, 4, 7, 6
    .byte 7, 7, 7, 6, 6, 8, 7, 7, 7, 6, 4, 7, 7, 5, 5, 5
    .byte 5, 6, 7, 6, 6, 7, 7, 5, 7, 5, 6, 3, 6, 5, 6
    .byte 7, 6, 6, 5, 6, 5, 6, 6, 6, 5, 7, 7, 7, 6, 6
    .byte 6, 7, 7, 7, 7, 8, 6, 7, 7, 6, 5, 5, 7, 5, 7, 7
    .byte 5, 7, 6, 6, 6, 7, 6, 6, 6, 6, 5, 7, 7, 7, 6
    .byte 6, 5, 6, 6, 7, 6, 7, 7, 6, 7, 7, 8, 7, 7, 5, 6
    .byte 7, 5, 6, 5, 5, 5, 7, 7, 6, 7, 7, 6, 6, 6, 7
    .byte 2, 6, 6, 7, 7, 6, 7, 5, 6, 6, 7, 5, 7, 6, 6
    .byte 7, 7, 6, 7, 7, 7, 7, 7, 7, 7, 6, 7, 6, 6, 6
    .byte 6, 7, 6, 7, 6, 6, 6, 6, 6, 6, 7, 6, 7, 6, 6
    .byte 5, 7, 8, 7, 7, 6, 5, 7, 6, 7, 7, 7, 7, 6, 7, 7
    .byte 7, 6, 7, 5, 6, 7, 5, 5, 4, 6, 6, 7, 7, 6, 7
    .byte 8, 6, 7, 6, 7, 3, 5, 6, 6, 7, 5, 7, 6, 6, 6, 6
    .byte 6, 6, 6, 6, 7, 7, 7, 6, 6, 7, 6, 8, 7, 7, 5, 7
    .byte 7, 6, 5, 6, 7, 6, 6, 6, 6, 7, 5, 7, 6, 7, 5
    .byte 7, 5, 5, 6, 7, 8, 7, 6, 7, 5, 7, 5, 7, 7, 7, 6
    .byte 6, 8, 7, 7, 7, 7, 6, 5, 6, 5, 5, 4, 5, 7, 7, 6
    .byte 6, 6, 6, 8, 6, 5, 7, 5, 6, 6, 5, 6, 7, 6, 4, 6
    .byte 7, 6, 6, 7, 7, 7, 7, 6, 5, 7, 6, 5, 5, 6, 6
    .byte 7, 6, 6, 7, 5, 7, 7, 7, 6, 8, 7, 7, 8, 7, 7, 6
    .byte 5, 5, 6, 7, 7, 6, 7, 7, 6, 7, 6, 4, 6, 6, 7
    .byte 5, 6, 6, 6, 7, 5, 7, 7, 7, 5, 5, 6, 5, 4, 5
    .byte 7, 5, 7, 6, 6, 6, 7, 5, 7, 5, 7, 5, 6, 5, 6
    .byte 7, 5, 7, 4, 7, 5, 6, 6, 6, 7, 7, 6, 7, 7, 7
    .byte 7, 6, 5, 6, 6, 6, 6, 7, 6, 5, 6, 7, 8, 7, 6, 7
    .byte 7, 6, 6, 7, 7, 7, 6, 7, 6, 7, 6, 5, 7, 8, 7, 7
    .byte 6, 6, 6, 7, 6, 6, 5, 6, 7, 7, 8, 6, 6, 3, 7, 6
    .byte 6, 4, 6, 6, 8, 6, 8, 7, 6, 8, 5, 7, 6, 5, 5, 7
    .byte 3
    .byte 7, 6, 7, 7, 6, 7, 5, 6, 7, 7, 6, 7, 6, 7, 7
    .byte 7, 4, 6, 6, 6, 7, 7, 7, 7, 7, 6, 7, 6, 7, 7
    .byte 7, 7, 7, 7, 7, 6, 7, 7, 7, 6, 7, 7, 7, 7, 7
    .byte 7, 7, 5, 7, 7, 7, 7, 6, 7, 5, 6, 6, 5, 7, 7
    .byte 7, 4, 6, 6, 5, 5, 6, 6, 5, 7, 5, 7, 6, 6, 7
    .byte 7, 7, 6, 3, 6, 6, 7, 5, 7, 7, 6, 5, 6, 7, 5
    .byte 6, 7, 7, 7, 7, 7, 7, 7, 5, 6, 6, 8, 6, 4, 7, 8
    .byte 6, 7, 6, 7, 7, 7, 6, 7, 7, 8, 7, 6, 6, 6, 6, 7
    .byte 7, 6, 7, 8, 7, 7, 6, 5, 7, 6, 7, 6, 6, 6, 5, 6
    .byte 6, 6, 6, 7, 7, 6, 5, 5, 6, 6, 7, 4, 5, 5, 7
    .byte 6, 5, 7, 6, 5, 7, 6, 4, 6, 7, 6, 7, 7, 7, 3
    .byte 7, 7, 7, 6, 7, 7, 7, 7, 6, 6, 7, 5, 5, 7, 7
    .byte 6, 7, 7, 7, 8, 5, 7, 7, 7, 8, 6, 7, 7, 7, 7, 6
    .byte 7, 7, 7, 7, 7, 7, 6, 7, 7, 7, 5, 6, 6, 7, 7
    .byte 7, 7, 5, 6, 5, 7, 6, 6, 7, 6, 5, 6, 6, 4, 7
    .byte 7, 6, 6, 7, 6, 7, 6, 6, 4, 6, 6, 6, 6, 6, 7
    .byte 6, 6, 7, 5, 7, 5, 6, 6, 7, 7, 7, 6, 7, 7, 7
    .byte 7, 6, 3, 6, 7, 6, 6, 6, 6, 6, 7, 5, 7, 7, 7
    .byte 7, 6, 7, 6, 6, 7, 5, 6, 7, 7, 6, 7, 5, 8, 7, 7
    .byte 6, 6, 7, 7, 7, 6, 6, 6, 6, 6, 5, 7, 6, 6, 4
    .byte 6, 6, 6, 7, 5, 3, 7, 7, 7, 5, 7, 6, 6, 6, 6
    .byte 6, 6, 7, 5, 5, 7, 6, 6, 7, 6, 5, 6, 7, 7, 7
    .byte 6, 7, 6, 7, 7, 5, 5, 7, 6, 7, 5, 7, 7, 7, 6
    .byte 7, 5, 7, 7, 7, 7, 7, 6, 5, 5, 7, 6, 6, 6, 7
    .byte 8, 7, 7, 6, 8, 6, 5, 5, 7, 6, 8, 6, 6, 6, 6, 7
    .byte 5
    .byte 6, 7, 8, 2, 6, 6, 7, 6, 7, 7, 6, 6, 6, 7, 5, 6
    .byte 7, 7, 7, 7, 5, 6, 7, 7, 6, 7, 7, 4, 5, 6, 7
    .byte 6, 5, 8, 8, 7, 7, 5, 7, 6, 7, 6, 7, 4, 7, 6, 6
    .byte 6, 7, 5, 6, 6, 7, 7, 7, 6, 6, 7, 6, 6, 7, 6
    .byte 5, 7, 8, 6, 6, 8, 6, 6, 6, 6, 6, 8, 7, 6, 7, 6
    .byte 7
    .byte 6, 7, 8, 6, 6, 5, 5, 4, 7, 4, 7, 7, 6, 7, 4, 7
    .byte 7, 7, 5, 7, 7, 7, 7, 5, 5, 7, 6, 6, 7, 4, 6
    .byte 5, 7, 6, 6, 6, 6, 6, 8, 7, 7, 7, 5, 7, 4, 6, 6
    .byte 7, 6, 6, 7, 6, 7, 7, 6, 7, 7, 7, 6, 7, 7, 7
    .byte 8, 7, 7, 6, 7, 4, 6, 7, 7, 7, 6, 6, 6, 7, 6, 6
    .byte 6, 5, 7, 7, 6, 6, 6, 6, 4, 5, 4, 7, 5, 7, 6
    .byte 5, 7, 4, 6, 6, 7, 5, 6, 7, 7, 5, 4, 7, 7, 4
    .byte 6, 7, 6, 5, 6, 7, 7, 8, 6, 6, 7, 7, 7, 7, 6, 6
    .byte 6, 7, 6, 4, 6, 6, 7, 7, 6, 7, 6, 7, 7, 5, 7
    .byte 7, 7, 7, 7, 7, 7, 7, 7, 6, 5, 8, 7, 7, 5, 6, 7
    .byte 7, 7, 6, 7, 6, 6, 6, 7, 7, 6, 6, 6, 1, 7, 6
    .byte 7, 6, 7, 6, 6, 7, 7, 6, 5, 6, 6, 6, 7, 6, 7
    .byte 7, 5, 6, 7, 5, 6, 5, 6, 6, 7, 6, 6, 6, 8, 7, 6
    .byte 6, 7, 6, 7, 7, 6, 7, 5, 6, 7, 7, 7, 6, 6, 7
    .byte 7, 6, 7, 7, 6, 7, 6, 7, 7, 6, 7, 6, 7, 6, 7
    .byte 6, 7, 8, 7, 6, 7, 6, 6, 6, 6, 6, 7, 6, 6, 7, 7
    .byte 6, 6, 3, 5, 6, 6, 6, 5, 7, 8, 5, 6, 5, 5, 7, 5
    .byte 5, 7, 7, 6, 6, 5, 6, 7, 6, 5, 5, 6, 7, 7, 6
    .byte 7, 6, 6, 6, 6, 7, 6, 6, 6, 4, 6, 6, 7, 6, 8, 7
    .byte 7, 7, 7, 6, 6, 6, 6, 7, 6, 7, 6, 7, 7, 6, 7
    .byte 6, 6, 7, 6, 7, 6, 6, 6, 7, 7, 5, 6, 7, 5, 6
    .byte 7, 5, 6, 6, 7, 6, 6, 7, 6, 5, 6, 7, 5, 4, 4
    .byte 5, 5, 4, 7, 7, 6, 7, 7, 5, 6, 6, 5, 5, 6, 7
    .byte 6, 7, 6, 5, 7, 6, 8, 7, 6, 7, 6, 6, 6, 6, 8, 5
    .byte 8, 6, 7, 5, 7, 5, 7, 7, 7, 5, 8, 6, 7, 7, 7, 6
    .byte 7, 6, 7, 6, 6, 6, 6, 7, 7, 7, 8, 5, 7, 7, 7, 7
    .byte 5, 5, 5, 6, 7, 7, 7, 5, 5, 6, 6, 6, 7, 6, 7
    .byte 2, 7, 6, 6, 5, 6, 7, 6, 6, 6, 7, 4, 7, 6, 6
    .byte 7, 6, 6, 7, 7, 7, 6, 7, 6, 8, 7, 6, 7, 7, 6, 7
    .byte 6, 6, 7, 7, 6, 5, 5, 7, 6, 6, 6, 7, 7, 6, 7
    .byte 7, 7, 6, 6, 7, 7, 7, 5, 7, 7, 7, 7, 6, 6, 7
    .byte 7, 7, 7, 7, 6, 7, 6, 7, 6, 6, 7, 6, 6, 6, 4
    .byte 7, 7, 5, 7
    .byte 6, 5, 4, 5, 4, 4, 6, 6, 7, 7, 6, 6, 5, 6, 7
    .byte 6, 6, 6, 5, 7, 7, 7, 7, 5, 7, 7, 7, 7, 7, 7
    .byte 6, 6, 6, 7, 7, 6, 6, 7, 3, 7, 7, 6, 6, 6, 6
    .byte 7, 7, 7, 5, 7, 7, 6, 7, 7, 7, 6, 7, 6, 7, 6
    .byte 7, 7, 7, 6, 7, 8, 6, 7, 6, 7, 5, 6, 6, 7, 6, 5
    .byte 6, 7, 5, 6, 7, 5, 4, 6, 6, 6, 5, 6, 6, 6, 7
    .byte 7, 5, 3, 6, 7, 7, 6, 4, 7, 7, 6, 7, 6, 7, 7
    .byte 7, 8, 7, 6, 7, 6, 6, 6, 7, 6, 7, 7, 6, 5, 6, 7
    .byte 7, 6, 6, 7, 8, 6, 6, 7, 6, 6, 7, 7, 6, 6, 7, 7
    .byte 5, 7, 6, 7, 6, 6, 7, 8, 6, 5, 6, 7, 6, 5, 6, 5
    .byte 7, 6, 6, 5, 4, 7, 6, 6, 6, 6, 5, 6, 7, 7, 6
    .byte 6, 5, 4, 6, 8, 7, 6, 8, 6, 6, 7, 5, 5, 5, 6, 7
    .byte 6, 7, 7, 6, 7, 6, 6, 7, 7, 5, 6, 7, 6, 6, 4
    .byte 7, 6, 7, 7, 7, 5, 8, 7, 6, 7, 6, 7, 8, 6, 6, 7
    .byte 7, 7, 6, 6, 7, 7, 6, 7, 7, 7, 7, 5, 8, 7, 6, 6
    .byte 6, 4, 6, 5, 7, 4, 7, 5, 7, 5, 7, 6, 5, 5, 6
    .byte 6, 7, 6, 6, 6, 6, 7, 5, 6, 8, 7, 7, 5, 7, 2, 6
    .byte 6, 7, 6, 5, 7, 7, 7, 7, 6, 7, 7, 7, 6, 6, 6
    .byte 6, 7, 4, 6, 7, 7, 7, 6, 7, 7, 7, 6, 7, 7, 7
    .byte 6, 6, 7, 6, 7, 7, 6, 7, 8, 7, 7, 7, 4, 7, 7, 7
    .byte 6, 6, 6, 7, 6, 7, 6, 6, 6, 5, 7, 6, 6, 7, 6
    .byte 7, 2, 7, 7, 6, 7, 5, 6, 5, 7, 6, 5, 6, 6, 5
    .byte 6, 6, 7, 5, 5, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7
    .byte 7, 5, 6, 5, 7, 6, 7, 6, 6, 6, 7, 6, 7, 8, 7, 6
    .byte 6, 6, 7, 7, 6, 6, 6, 7, 6, 6, 7, 6, 8, 8, 7, 6
    .byte 5, 6, 7, 7, 7, 7, 6, 6, 6, 7, 7, 6, 6, 4, 7
    .byte 7, 6, 6, 7, 3, 6, 5, 7, 7, 7, 7, 4, 6, 6, 6
    .byte 5, 6, 5, 7, 7, 6, 6, 6, 6, 5, 6, 6, 6, 7, 6
    .byte 7, 7, 6, 7, 4, 6, 7, 6, 6, 7, 7, 6, 6, 7, 7
    .byte 6, 7, 6, 7, 6, 6, 7, 7, 7, 7, 6, 7, 7, 6, 7
    .byte 6, 7, 7, 8, 6, 6, 6, 7, 6, 7, 6, 7, 7, 6, 6, 6
    .byte 6, 6, 6, 5, 6, 6, 6, 7, 5, 3, 6, 7, 7, 5, 6
    .byte 5, 6, 5, 6, 7, 7, 7, 6, 5, 6, 7, 6, 6, 6, 5
    .byte 6, 6, 6, 7, 5, 7, 6, 7, 8, 6, 6, 6, 7, 7, 6, 6
    .byte 6, 7, 6, 6, 5, 7, 7, 7, 7, 7, 6, 6, 6, 6, 5
    .byte 7, 5, 7, 8, 7, 7, 7, 7, 6, 4, 6, 7, 7, 7, 6, 7
    .byte 6, 6, 7, 5, 6, 6, 7, 6, 5, 6, 7, 4, 7, 6, 6
    .byte 5, 6, 5, 6, 5, 5, 5, 7, 7, 5, 5, 6, 8, 7, 5, 7
    .byte 4, 7, 5, 6, 5, 6, 8, 7, 6, 7, 6, 7, 7, 7, 4, 7
    .byte 7, 7, 7, 7, 7, 6, 7, 6, 7, 6, 7, 7, 5, 7, 6
    .byte 7, 7, 5, 5, 6, 6, 7, 6, 5, 7, 7, 6, 6, 5, 7
    .byte 6, 7, 6, 6, 7, 6, 7, 6, 8, 7, 6, 6, 6, 5, 6, 6
    .byte 6, 7, 4, 4, 5, 6, 5, 5, 6, 6, 6, 7, 7, 5, 5
    .byte 7, 6, 6, 6, 7, 4, 6, 6, 6, 6, 6, 7, 7, 7, 5
    .byte 6, 7, 6, 6, 7, 7, 6, 7, 7, 7, 7, 5, 7, 7, 6
    .byte 7, 7, 7, 6, 7, 6, 7, 6, 7, 6, 6, 7, 7, 6, 7
    .byte 6, 6, 6, 7, 7, 6, 7, 7, 7, 6, 7, 5, 7, 6, 6
    .byte 7, 2, 7, 7, 7, 6, 6, 7, 5, 6, 7, 7, 4, 5, 7
    .byte 7, 8, 6, 6, 7, 7, 7, 5, 7, 7, 4, 6, 7, 7, 5, 6
    .byte 8, 8, 6, 6, 6, 8, 7, 8, 7, 8, 5, 6, 7, 7, 7, 7
    .byte 6, 5
    .byte 7, 8, 7, 7, 6, 7, 8, 6, 6, 6, 5, 5, 7, 8, 7, 6
    .byte 7
    .byte 6, 7, 7, 7, 7, 8, 8, 7, 6, 7, 6, 7, 7, 7, 6, 7
    .byte 4, 7, 6, 5, 7, 6, 7, 2, 7, 6, 6, 6, 6, 7, 7
    .byte 7, 5, 6, 5, 7, 5, 5, 6, 6, 6, 7, 6, 7, 6, 7
    .byte 6, 7, 7, 6, 7, 7, 6, 7, 7, 7, 8, 7, 7, 6, 6, 7
    .byte 6, 5, 6, 7, 7, 7, 7, 7, 7, 7, 5, 6, 6, 7, 6
    .byte 7, 6, 6, 6, 5, 7, 6, 7, 7, 7, 6, 7, 8, 6, 6, 6
    .byte 6, 7, 7, 7, 6, 5, 7, 6, 5, 6, 6, 4, 4, 6, 3
    .byte 5, 7, 7, 6, 7, 7, 7, 6, 6, 6, 6, 6, 7, 5, 7
    .byte 7, 7, 7, 4, 6, 6, 7, 6, 6, 7, 6, 7, 6, 7, 7
    .byte 7, 7, 7, 4, 7, 6, 6, 7, 7, 5, 6, 7, 7, 6, 6
    .byte 8, 6, 7, 6, 6, 7, 6, 7, 7, 6, 6, 6, 7, 6, 7, 8
    .byte 6, 7, 7, 6, 5, 6, 7, 7, 7, 6, 6, 7, 6, 6, 6
    .byte 7, 6, 4, 5, 5, 5, 5, 7, 7, 6, 7, 7, 6, 6, 6
    .byte 6, 4, 7, 7, 6, 6, 6, 4, 6, 7, 7, 7, 6, 7, 7
    .byte 5, 7, 7, 8, 5, 7, 7, 7, 6, 6, 4, 7, 7, 6, 6, 7
    .byte 7, 6, 6, 6, 6, 6, 5, 7, 7, 6, 6, 5, 6, 7, 6
    .byte 7, 5, 6, 7, 6, 7, 6, 6, 5, 7, 7, 8, 7, 6, 5, 6
    .byte 7, 5, 6, 7, 5, 4, 6, 6, 6, 4, 7, 5, 7, 7, 7
    .byte 4, 4, 7, 7, 6, 5, 5, 6, 7, 6, 6, 5, 7, 7, 6
    .byte 8, 6, 7, 6, 7, 6, 5, 7, 7, 7, 7, 6, 6, 5, 7, 6
    .byte 6, 6, 6, 7, 7, 7, 7, 7, 5, 7, 6, 6, 6, 7, 6
    .byte 4, 7, 6, 6, 7, 6, 7, 7, 6, 6, 7, 7, 6, 5, 6
    .byte 6, 8, 7, 4, 5, 5, 7, 5, 7, 5, 6, 7, 5, 7, 6, 7
    .byte 5, 5, 7, 7, 5, 3, 7, 7, 5, 6, 7, 6, 6, 5, 7
    .byte 6, 7, 6, 6, 6, 7, 6, 7, 6, 7, 6, 7, 7, 5, 7
    .byte 7, 7, 6, 5, 7, 6, 7, 6, 6, 7, 6, 6, 6, 6, 7
    .byte 7, 6, 7, 7, 4, 7, 6, 6, 6, 6, 7, 7, 7, 7, 7
    .byte 7, 6, 7, 7, 7, 6, 6, 6, 1, 7, 7, 7, 7, 7, 7
    .byte 5, 7, 7, 6, 6, 5, 6, 6, 7, 6, 7, 7, 6, 6, 6
    .byte 6, 7, 6, 7, 6, 8, 6, 7, 6, 7, 6, 5, 6, 7, 7, 6
    .byte 7, 7, 7, 6, 7, 7, 7, 7, 5, 6, 7, 7, 6, 7, 7
    .byte 7, 7, 6, 6, 7, 6, 6, 6, 6, 7, 7, 7, 6, 7, 7
    .byte 5, 7, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 5, 5, 5
    .byte 5, 7, 4, 6, 7, 6, 6, 3, 7, 7, 7, 6, 6, 7, 7
    .byte 7, 5, 4, 7, 7, 6, 7, 5, 6, 6, 6, 7, 6, 6, 5
    .byte 7, 8, 7, 7, 7, 6, 7, 5, 7, 6, 7, 7, 6, 6, 6, 7
    .byte 6, 6, 7, 7, 6, 5, 7, 7, 7, 7, 6, 7, 6, 6, 5
    .byte 5, 7, 6, 7, 5, 7, 7, 8, 6, 7, 6, 6, 7, 7, 7, 6
    .byte 5, 7, 7, 4, 5, 5, 6, 6, 5, 6, 7, 6, 5, 4, 6
    .byte 7, 4, 6, 7, 7, 6, 6, 5, 7, 7, 7, 5, 6, 7, 6
    .byte 6, 7, 7, 5, 6, 5, 6, 8, 6, 6, 7, 5, 6, 5, 7, 7
    .byte 7, 7, 7, 7, 6, 7, 5, 7, 7, 6, 7, 7, 6, 7, 8, 6
    .byte 7, 6, 6, 6, 5, 6, 6, 6, 6, 7, 7, 6, 6, 7, 6
    .byte 6, 7, 6, 6, 6, 6, 6, 5, 7, 4, 5, 4, 4, 6, 7
    .byte 7, 5, 7, 6, 7, 6, 5, 6, 4, 6, 6, 6, 6, 6, 7
    .byte 5, 7, 7, 7, 6, 6, 7, 6, 6, 7, 5, 7, 7, 6, 6
    .byte 7, 6, 8, 6, 7, 7, 5, 7, 6, 7, 7, 7, 7, 6, 7, 7
    .byte 7, 6, 6, 6, 6, 7, 7, 5, 7, 7, 7, 7, 6, 3, 7
    .byte 7, 7, 6, 6, 6, 7, 7, 6, 7, 7, 7, 3, 7, 6, 6
    .byte 5, 6, 5, 7, 6, 7, 6, 7, 7, 5, 7, 5, 6, 4, 7
    .byte 4, 6, 6, 6, 6, 5, 7, 6, 5, 7, 6, 5, 6, 7, 7
    .byte 6, 6, 5, 6, 7, 7, 6, 8, 6, 7, 7, 6, 6, 5, 7, 6
    .byte 6, 7, 6, 7, 6, 7, 7, 6, 6, 6, 7, 7, 6, 8, 6, 6
    .byte 7, 5, 6, 7, 7, 6, 6, 7, 6, 7, 7, 6, 7, 8, 7, 6
    .byte 5, 6, 5, 4, 5, 6, 6, 7, 6, 7, 7, 7, 6, 7, 5
    .byte 7, 4, 5, 5, 6, 7, 4, 7, 5, 6, 6, 5, 7, 5, 7
    .byte 6, 7, 7, 7, 6, 7, 7, 5, 7, 7, 7, 6, 6, 6, 6
    .byte 5, 7, 8, 7, 5, 6, 7, 7, 5, 7, 7, 6, 6, 6, 5, 6
    .byte 7, 6, 8, 7, 7, 6, 5, 7, 6, 6, 7, 7, 5, 5, 8, 8
    .byte 8
    .byte 6, 7, 4, 6, 7, 6, 5, 6, 5, 6, 6, 6, 7, 7, 6
    .byte 7, 6, 7, 7, 2, 6, 6, 7, 6, 6, 7, 6, 6, 7, 6
    .byte 6, 7, 7, 6, 7, 7, 6, 6, 7, 6, 6, 7, 7, 7, 5
    .byte 7, 7, 7, 6, 6, 6, 7, 7, 7, 7, 7, 7, 6, 6, 6
    .byte 6, 7, 7, 7, 6, 6, 7, 7, 6, 5, 5, 6, 7, 7, 6
    .byte 7, 7, 6, 7, 7, 6, 7, 8, 4, 6, 6, 7, 5, 6, 5, 6
    .byte 5, 7, 5, 6, 6, 5, 5, 6, 7, 6, 5, 7, 6, 6, 6
    .byte 7, 3, 5, 5, 7, 6, 4, 7, 6, 8, 8, 6, 8, 6, 7, 7
    .byte 7
    .byte 6, 6, 7, 5, 6, 7, 6, 7, 7, 8, 6, 7, 7, 7, 6, 6
    .byte 7, 6, 6, 5, 7, 6, 6, 8, 7, 6, 6, 7, 5, 7, 6, 6
    .byte 6, 7, 6, 7, 6, 7, 7, 6, 6, 5, 7, 6, 5, 7, 7
    .byte 3, 6, 6, 7, 7, 6, 7, 3, 6, 6, 7, 6, 6, 6, 7
    .byte 7, 6, 7, 6, 6, 5, 5, 7, 6, 7, 6, 7, 7, 5, 7
    .byte 5, 7, 7, 7, 7, 7, 7, 6, 7, 6, 7, 7, 7, 6, 6
    .byte 5, 7, 7, 6, 6, 7, 6, 6, 6, 6, 7, 6, 6, 6, 8, 5
    .byte 7, 7, 7, 6, 6, 7, 8, 7, 6, 6, 7, 7, 6, 6, 4, 7
    .byte 6, 7, 7, 6, 7, 2, 6, 7, 6, 6, 5, 6, 5, 7, 6
    .byte 5, 7, 5, 6, 6, 7, 7, 5, 6, 6, 6, 6, 6, 7, 7
    .byte 7, 6, 7, 6, 7, 6, 7, 6, 7, 6, 7, 6, 7, 7, 7
    .byte 6, 6, 8, 7, 7, 6, 5, 7, 7, 6, 6, 5, 7, 6, 6
    .byte 7, 7, 7, 7, 7, 6, 6, 6, 7, 6, 7, 8, 7, 7, 6, 7
    .byte 7, 6, 6, 6, 6, 5, 6, 6, 6, 5, 6, 5, 5, 7, 7
    .byte 5, 5, 6, 5, 7, 7, 7, 7, 7, 6, 5, 8, 5, 4, 4, 5
    .byte 6, 6, 8, 6, 6, 7, 5, 7, 7, 6, 6, 7, 7, 6, 7, 5
    .byte 7, 6, 6, 7, 8, 4, 7, 6, 6, 6, 5, 7, 8, 6, 5, 6
    .byte 7, 7, 5, 6, 7, 7, 5, 7, 7, 7, 6, 4, 8, 7, 6, 6
    .byte 7, 5, 6, 6, 7, 6, 5, 6, 6, 6, 5, 6, 7, 7, 7
    .byte 5, 6, 7, 7, 5, 5, 7, 6, 6, 7, 6, 6, 6, 6, 4
    .byte 6, 6, 6, 7, 7, 8, 6, 7, 5, 6, 7, 5, 6, 5, 6, 7
    .byte 7, 7, 6, 7, 6, 6, 6, 7, 6, 7, 6, 6, 7, 7, 7
    .byte 7, 6, 5, 7, 7, 7, 7, 7, 8, 7, 7, 7, 5, 7, 7, 6
    .byte 6, 6, 5, 5, 7, 4, 6, 7, 7, 3, 6, 7, 7, 5, 6
    .byte 5, 8, 5, 7, 6, 6, 7, 4, 7, 7, 5, 6, 7, 3, 7, 7
    .byte 6, 6, 7, 6, 5, 7, 7, 7, 7, 7, 6, 7, 7, 7, 5
    .byte 6, 6, 6, 7, 7, 7, 7, 7, 6, 8, 5, 7, 7, 7, 7, 7
    .byte 6, 7, 6, 8, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 7
    .byte 7, 7, 7, 5, 8, 6, 5, 6, 4, 7, 7, 7, 5, 6, 5, 5
    .byte 6, 6, 7, 4, 7, 6, 7, 6, 6, 6, 6, 7, 6, 4, 5
    .byte 7, 6, 5, 7, 7, 6, 4, 6, 7, 5, 7, 7, 7, 8, 7, 7
    .byte 6, 6, 6, 6, 6, 7, 6, 5, 7, 7, 6, 6, 7, 7, 6
    .byte 7, 5, 6, 7, 7, 7, 6, 7, 6, 6, 7, 6, 7, 6, 7
    .byte 7, 7, 6, 6, 7, 7, 8, 7, 7, 5, 4, 5, 6, 7, 6, 7
    .byte 4, 5, 5, 6, 5, 6, 7, 6, 7, 6, 6, 6, 6, 6, 6
    .byte 6, 7, 5, 6, 6, 6, 7, 6, 6, 3, 6, 5, 7, 6, 7
    .byte 7, 7, 7, 7, 6, 7, 6, 7, 5, 6, 6, 6, 6, 6, 7
    .byte 5, 6, 7, 7, 7, 7, 7, 7, 6, 7, 6, 7, 7, 5, 7
    .byte 7, 7, 5, 5, 6, 7, 7, 7, 5, 7, 7, 7, 7, 6, 5
    .byte 5, 7, 6, 8, 6, 6, 6, 6, 5, 6, 7, 7, 8, 4, 6, 6
    .byte 7, 6, 5, 6, 6, 6, 6, 5, 4, 7, 6, 5, 8, 7, 6, 3
    .byte 7, 6, 6, 7, 7, 7, 8, 7, 7, 7, 7, 5, 5, 6, 7, 6
    .byte 6, 7, 7, 7, 5, 7, 7, 6, 8, 5, 6, 7, 7, 7, 6, 6
    .byte 7, 7, 7, 7, 7, 7, 7, 7, 7, 5, 6, 7, 6, 7, 7
    .byte 7, 4, 5, 6, 6, 7, 6, 6, 3, 6, 7, 6, 6, 5, 4
    .byte 8, 6, 8, 5, 7, 6, 5, 6, 7, 6, 7, 7, 4, 6, 7, 6
    .byte 6, 6, 6, 5, 6, 7, 6, 6, 7, 7, 7, 7, 7, 6, 5
    .byte 6, 5, 7, 6, 7, 6, 7, 7, 7, 4, 7, 7, 7, 7, 7
    .byte 6, 6, 5, 7, 7, 6, 7, 7, 7, 7, 6, 7, 8, 7, 6, 6
    .byte 7, 7, 8, 5, 7, 7, 5, 7, 5, 6, 6, 7, 3, 6, 5, 7
    .byte 6, 7, 8, 6, 6, 6, 7, 6, 5, 7, 7, 7, 7, 6, 6, 7
    .byte 7, 6, 6, 7, 3, 5, 6, 7, 5, 6, 7, 7, 7, 8, 5, 7
    .byte 6, 7, 6, 6, 5, 7, 7, 6, 6, 6, 5, 7, 6, 6, 7
    .byte 7, 6, 5, 7, 5, 6, 7, 6, 6, 8, 7, 5, 6, 7, 6, 6
    .byte 7, 5, 7, 7, 7, 6, 7, 5, 6, 6, 7, 7, 6, 5, 6
    .byte 5, 6, 7, 5, 6, 7, 7, 7, 7, 5, 6, 7, 7, 5, 5
    .byte 7, 6, 7, 7, 7, 5, 7, 6, 5, 6, 6, 6, 6, 7, 8, 7
    .byte 6, 6, 6, 8, 6, 6, 4, 6, 7, 6, 6, 6, 7, 5, 7, 5
    .byte 7, 6, 6, 6, 7, 7, 7, 6, 7, 6, 6, 7, 6, 6, 8, 6
    .byte 7, 6, 7, 6, 6, 7, 8, 6, 7, 5, 5, 6, 6, 4, 6, 6
    .byte 7, 6, 6, 7, 7, 5, 6, 7, 4, 5, 4, 4, 4, 5, 7
    .byte 7, 6, 7, 6, 4, 6, 6, 5, 6, 5, 7, 6, 7, 7, 6
    .byte 7, 5, 8, 7, 7, 7, 7, 7, 7, 7, 7, 6, 7, 7, 7, 5
    .byte 7, 6, 7, 6, 6, 5, 7, 6, 7, 6, 7, 6, 7, 7, 7
    .byte 6, 7, 6, 7, 6, 7, 7, 7, 6, 7, 7, 7, 7, 6, 6
    .byte 6, 5, 7, 6, 6, 4, 6, 6, 6, 7, 6, 6, 7, 3, 6
    .byte 5, 5, 4, 6, 7, 7, 7, 7, 7, 4, 6, 7, 6, 7, 5
    .byte 6, 7, 7, 7, 5, 7, 6, 8, 6, 6, 7, 7, 6, 6, 7, 6
    .byte 7, 6, 7, 6, 5, 7, 6, 7, 6, 6, 6, 6, 7, 7, 6
    .byte 7, 7, 7, 7, 7, 5, 7, 7, 6, 6, 7, 7, 7, 7, 6
    .byte 7, 7, 7, 6, 6, 7, 5, 6, 6, 5, 5, 5, 6, 7, 6
    .byte 6, 7, 6, 4, 5, 5, 5, 4, 6, 7, 7, 7, 7, 6, 3
    .byte 5, 7, 6, 7, 4, 7, 7, 7, 7, 6, 7, 6, 7, 7, 7
    .byte 7, 7, 6, 6, 6, 6, 6, 7, 7, 7, 5, 7, 7, 7, 5
    .byte 5, 6, 7, 7, 6, 6, 6, 7, 8, 6, 7, 6, 7, 7, 6, 7
    .byte 7, 8, 7, 7, 6, 8, 7, 6, 7, 6, 7, 5, 7, 5, 6, 5
    .byte 6, 5, 7, 7, 5, 7, 7, 4, 5, 5, 5, 3, 6, 7, 7
    .byte 7, 7, 6, 4, 6, 6, 6, 6, 5, 6, 7, 7, 7, 6, 6
    .byte 6, 7, 7, 7, 7, 8, 6, 6, 7, 7, 7, 6, 7, 7, 4, 6
    .byte 7, 6, 5, 6, 6, 7, 7, 7, 5, 7, 7, 7, 7, 8, 6, 6
    .byte 7, 7, 7, 7, 7, 8, 7, 6, 7, 7, 6, 7, 7, 7, 4, 7
    .byte 6, 6, 5, 7, 5, 5, 6, 6, 6, 6, 7, 6, 6, 6, 7
    .byte 6, 6, 4, 4, 6, 7, 6, 6, 7, 6, 7, 7, 5, 6, 6
    .byte 6, 7, 6, 7, 7, 7, 6, 7, 7, 6, 6, 5, 6, 7, 6
    .byte 6, 5, 7, 6, 6, 6, 8, 5, 7, 6, 6, 7, 6, 7, 7, 6
    .byte 6, 6, 7, 7, 7, 7, 7, 7, 7, 6, 6, 7, 7, 6, 7
    .byte 6, 5, 6, 7, 3, 6, 6, 7, 4, 6, 5, 7, 5, 7, 7
    .byte 6, 6, 6, 7, 7, 6, 7, 7, 7, 7, 6, 6, 7, 7, 6
    .byte 5, 7, 2, 6, 6, 8, 6, 6, 6, 7, 8, 7, 6, 8, 7, 7
    .byte 6
    .byte 6, 6, 6, 7, 5, 6, 6, 6, 7, 6, 6, 8, 7, 6, 6, 7
    .byte 6, 6, 6, 6, 6, 7, 7, 5, 6, 7, 7, 7, 7, 4, 8, 7
    .byte 8, 7, 6, 5, 6, 6, 7, 7, 5, 6, 3, 7, 7, 7, 5, 6
    .byte 4, 7, 5, 7, 6, 7, 7, 5, 6, 6, 5, 6, 6, 4, 7
    .byte 7, 5, 6, 6, 7, 5, 6, 6, 7, 7, 6, 7, 7, 7, 7
    .byte 5, 6, 7, 5, 7, 6, 7, 7, 7, 7, 7, 5, 7, 6, 7
    .byte 7, 7, 6, 7, 6, 7, 7, 7, 7, 6, 7, 6, 7, 7, 8, 7
    .byte 7, 6, 7, 7, 7, 5, 8, 7, 5, 7, 5, 7, 7, 6, 6, 7
    .byte 5, 6, 6, 6, 7, 3, 7, 6, 7, 6, 6, 6, 6, 7, 6
    .byte 5, 5, 7, 5, 5, 7, 7, 6, 4, 6, 7, 6, 8, 6, 7, 8
    .byte 8, 7, 7, 7, 6, 5, 5, 6, 5, 6, 6, 6, 6, 6, 6, 6
    .byte 7, 8, 5, 5, 7, 7, 7, 6, 7, 7, 7, 7, 6, 7, 7, 7
    .byte 7, 7, 6, 5, 6, 7, 7, 7, 6, 5, 5, 5, 7, 7, 6
    .byte 7, 4, 6, 4, 7, 5, 7, 7, 7, 7, 5, 6, 6, 6, 6
    .byte 7, 7, 7, 6, 5, 6, 7, 6, 6, 6, 3, 6, 5, 7, 6
    .byte 6, 7, 7, 7, 7, 6, 8, 7, 6, 6, 5, 6, 6, 6, 6, 7
    .byte 6, 6, 8, 7, 6, 7, 7, 7, 6, 6, 6, 7, 7, 6, 7, 7
    .byte 7, 4, 6, 6, 7, 7, 7, 5, 7, 7, 7, 7, 7, 4, 6
    .byte 7, 6, 7, 6, 6, 5, 6, 4, 6, 6, 7, 7, 4, 7, 5
    .byte 7, 6, 6, 5, 5, 7, 7, 5, 5, 7, 6, 4, 7, 7, 6
    .byte 4, 6, 6, 6, 7, 6, 7, 8, 7, 6, 7, 7, 6, 6, 6, 6
    .byte 5, 6, 6, 7, 7, 5, 7, 6, 7, 7, 4, 6, 7, 6, 6
    .byte 7, 7, 7, 7, 7, 6, 6, 7, 8, 6, 6, 6, 6, 7, 7, 7
    .byte 6, 7, 5, 5, 6, 7, 7, 5, 6, 2, 7, 7, 7, 6, 6
    .byte 5, 7, 6, 7, 5, 6, 6, 5, 6, 7, 6, 7, 7, 4, 6
    .byte 7, 5, 5, 6, 6, 6, 7, 6, 6, 7, 7, 7, 7, 7, 6
    .byte 6, 6, 7, 6, 6, 6, 6, 7, 7, 7, 7, 5, 8, 7, 6, 6
    .byte 6, 5, 7, 6, 7, 7, 7, 7, 6, 7, 6, 7, 6, 7, 7
    .byte 6, 7, 8, 7, 7, 6, 7, 7, 6, 7, 5, 7, 6, 7, 7, 4
    .byte 6, 7, 6, 6, 6, 7, 7, 6, 6, 6, 6, 7, 4, 5, 7
    .byte 7, 6, 7, 6, 6, 6, 6, 5, 5, 5, 7, 6, 6, 8, 6, 7
    .byte 6, 6, 7, 6, 7, 5, 5, 7, 7, 6, 5, 7, 6, 6, 6
    .byte 7, 6, 6, 5, 7, 6, 6, 7, 7, 7, 6, 7, 7, 6, 7
    .byte 7, 7, 7, 7, 6, 6, 8, 7, 5, 6, 6, 4, 6, 7, 4, 5
    .byte 7, 7, 6, 4, 4, 6, 6, 7, 6, 7, 7, 5, 7, 7, 7
    .byte 6, 6, 7, 6, 7, 7, 6, 7, 7, 8, 7, 6, 6, 7, 7, 6
    .byte 6, 6, 7, 7, 7, 7, 8, 7, 5, 6, 5, 5, 5, 7, 6, 6
    .byte 6, 6, 6, 7, 6, 6, 6, 6, 7, 6, 7, 6, 7, 6, 5
    .byte 6, 6, 6, 6, 7, 5, 6, 6, 7, 5, 6, 5, 7, 5, 6
    .byte 5, 7, 7, 7, 5, 7, 3, 5, 5, 7, 7, 6, 7, 7, 6
    .byte 7, 7, 4, 6, 7, 6, 7, 7, 6, 7, 7, 7, 7, 7, 7
    .byte 6, 7, 7, 7, 7, 6, 7, 7, 7, 7, 7, 7, 5, 7, 6
    .byte 5, 5, 6, 7, 7, 7, 6, 7, 7, 6, 7, 7, 6, 7, 6
    .byte 7, 6, 7, 7, 4, 8, 7, 6, 7, 6, 4, 7, 6, 6, 6, 6
    .byte 6, 4, 5, 6, 7, 7, 6, 6, 5, 8, 6, 6, 4, 5, 7, 7
    .byte 6, 5, 7, 8, 5, 7, 6, 6, 5, 6, 6, 7, 7, 6, 7, 7
    .byte 6, 8, 7, 7, 7, 6, 7, 7, 7, 6, 7, 7, 7, 7, 8, 7
    .byte 5, 7, 6, 5, 4, 6, 7, 7, 7, 7, 7, 7, 7, 6, 6
    .byte 6, 7, 7, 7, 6, 7, 6, 5, 6, 7, 7, 7, 6, 5, 6
    .byte 6, 6, 5, 5, 5, 7, 4, 6, 6, 7, 6, 6, 6, 7, 4
    .byte 4, 6, 7, 6, 7, 7, 7, 6, 6, 6, 5, 6, 7, 7, 7
    .byte 7, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 6, 7, 7, 7
    .byte 6, 7, 8, 7, 6, 6
    .byte 7, 6, 4, 5, 6, 7, 6, 7, 7, 7, 6, 7, 6, 6, 5
    .byte 7, 6, 6, 6, 6, 7, 5, 7, 7, 6, 6, 6, 5, 7, 7
    .byte 7, 5, 6, 6, 4, 5, 7, 7, 6, 6, 6, 6, 7, 6, 7
    .byte 5, 7, 7, 6, 6, 6, 6, 7, 7, 6, 7, 7, 6, 6, 7
    .byte 6, 6, 6, 6, 6, 7, 7, 7, 6, 7, 7, 7, 6, 7, 6
    .byte 6, 7, 7, 7, 7, 7, 7, 4, 7, 6, 6, 6, 7, 6, 4
    .byte 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6, 6, 6, 6
    .byte 6, 7, 4, 7, 7, 5, 7, 6, 5, 6, 6, 7, 4, 5, 5
    .byte 7, 6, 6, 6, 6, 5, 7, 7, 7, 5, 7, 7, 7, 5, 8, 7
    .byte 5, 6, 7, 6, 6, 6, 5, 6, 5, 6, 7, 7, 7, 6, 7
    .byte 7, 6, 6, 5, 6, 7, 7, 7, 7, 7, 4, 6, 7, 6, 5
    .byte 7, 6, 7, 5, 5, 7, 7, 7, 7, 8, 7, 8, 7, 8, 5, 7
    .byte 6
    .byte 5, 6, 6, 6, 7, 7, 6, 6, 7, 6, 6, 7, 6, 6, 4
    .byte 7, 6, 6, 5, 7, 6, 7, 5, 5, 6, 7, 7, 6, 6, 6
    .byte 7, 5, 6, 7, 7, 6, 6, 8, 6, 6, 4, 7, 7, 6, 7, 6
    .byte 7, 6, 6, 7, 7, 5, 6, 7, 7, 7, 7, 6, 6, 6, 4
    .byte 5, 6, 5, 7, 8, 6, 7, 7, 6, 7, 7, 7, 7, 7, 6, 7
    .byte 6, 7, 6, 4, 6, 6, 8, 6, 6, 7, 8, 5, 6, 4, 6, 4
    .byte 6, 6, 4, 5, 6, 7, 6, 7, 7, 6, 6, 6, 5, 6, 5
    .byte 6, 6, 6, 6, 7, 6, 6, 7, 7, 6, 7, 5, 7, 5, 6
    .byte 7, 5, 7, 7, 6, 7, 7, 7, 6, 7, 6, 6, 7, 6, 7
    .byte 7, 7, 6, 5, 5, 7, 7, 6, 5, 7, 7, 6, 6, 6, 7
    .byte 7, 6, 7, 7, 7, 6, 6, 7, 6, 5, 6, 6, 7, 6, 6
    .byte 7, 7, 7, 7, 4, 6, 4, 6, 5, 5, 6, 6, 7, 6, 5
    .byte 8, 7, 7, 5, 6, 6, 5, 6, 7, 5, 6, 7, 6, 6, 6, 6
    .byte 6, 7, 6, 7, 7, 6, 7, 5, 7, 7, 7, 7, 7, 7, 7
    .byte 7, 7, 7, 7, 7, 7, 6, 7, 6, 7, 7, 6, 6, 7, 6
    .byte 3, 6, 7, 7, 6, 8, 7, 5, 6, 8, 6, 6, 6, 7, 6, 7
    .byte 7, 6, 6, 5, 6, 6, 6, 6, 6, 4, 8, 7, 5, 7, 7, 6
    .byte 5, 6, 7, 5, 5, 6, 6, 7, 7, 6, 6, 6, 7, 6, 6
    .byte 7, 6, 5, 6, 7, 7, 7, 7, 7, 7, 7, 7, 6, 7, 5
    .byte 7, 8, 7, 5, 7, 7, 8, 7, 7, 7, 6, 6, 7, 7, 6, 5
    .byte 8, 6, 6, 5, 7, 7, 7, 7, 7, 7, 7, 6, 7, 6, 7, 5
    .byte 6, 7, 7, 7, 7, 6, 5, 7, 7, 7, 7, 4, 7, 7, 7
    .byte 6, 6, 6, 7, 5, 8, 7, 6, 5, 7, 6, 6, 5, 7, 6, 7
    .byte 4, 7, 6, 6, 7, 6, 7, 5, 6, 7, 7, 6, 7, 7, 7
    .byte 7, 6, 7, 6, 6, 7, 7, 6, 7, 7, 7, 5, 7, 7, 8, 7
    .byte 5, 6, 7, 6, 6, 5, 5, 7, 7, 6, 7, 7, 8, 6, 6, 6
    .byte 5, 6, 6, 6, 6, 7, 7, 7, 6, 6, 7, 5, 6, 6, 7
    .byte 6, 6, 7, 7, 7, 6, 6, 6, 6, 6, 4, 7, 6, 7, 6
    .byte 7, 4, 6, 6, 6, 6, 5, 7, 7, 7, 5, 6, 7, 7, 6
    .byte 5, 7, 8, 6, 7, 6, 8, 7, 7, 7, 7, 6, 7, 6, 7, 6
    .byte 6, 6, 5, 7, 7, 7, 6, 7, 5, 5, 5, 6, 7, 7, 6
    .byte 6, 7, 6, 6, 6, 6, 5, 5, 5, 7, 7, 7, 6, 7, 5
    .byte 6, 5, 6, 5, 5, 7, 6, 7, 6, 7, 7, 5, 6, 6, 5
    .byte 7, 5, 6, 5, 6, 7, 6, 7, 7, 6, 6, 8, 6, 7, 6, 7
    .byte 5, 6, 5, 7, 7, 6, 7, 7, 7, 7, 6, 7, 7, 7, 6
    .byte 7, 7, 7, 7, 7, 6, 6, 7, 6, 4, 6, 6, 7, 7, 6
    .byte 7, 5, 7, 7, 7, 7, 6, 7, 7, 7, 7, 5, 6, 5, 7
    .byte 7, 6, 6, 7, 3, 7, 7, 6, 6, 6, 6, 5, 6, 7, 5
    .byte 5, 4, 7, 6, 7, 5, 6, 6, 6, 6, 6, 6, 7, 7, 6
    .byte 5, 6, 6, 8, 7, 6, 7, 5, 6, 5, 6, 7, 7, 7, 6, 7
    .byte 7, 5, 7, 7, 6, 5, 7, 7, 7, 6, 7, 6, 6, 5, 6
    .byte 7, 5, 6, 7, 6, 7, 7, 5, 7, 6, 7, 8, 6, 6, 6, 6
    .byte 7, 6, 5, 6, 6, 7, 6, 6, 6, 7, 6, 6, 4, 6, 5
    .byte 6, 6, 5, 5, 7, 7, 5, 7, 7, 6, 6, 6, 6, 5, 6
    .byte 7, 7, 5, 6, 7, 7, 7, 6, 7, 5, 6, 6, 7, 5, 7
    .byte 7, 5, 7, 7, 7, 7, 6, 7, 6, 7, 7, 6, 7, 7, 7
    .byte 7, 8, 6, 5, 6, 6, 7, 5, 5, 7, 7, 6, 7, 7, 7, 6
    .byte 7, 7, 7, 7, 6, 5, 7, 7, 5, 7, 6, 6, 5, 6, 6
    .byte 7, 7, 6, 4, 7, 4, 7, 6, 5, 7, 5, 7, 5, 5, 7
    .byte 7, 4, 6, 7, 7, 6, 8, 6, 7, 4, 7, 6, 6, 5, 7, 6
    .byte 7, 6, 6, 6, 6, 7, 7, 7, 6, 6, 7, 7, 7, 7, 4
    .byte 7, 7, 8, 7, 7, 8, 5, 6, 6, 7, 4, 7, 7, 6, 6, 6
    .byte 7, 7, 7, 7, 7, 7, 7, 6, 7, 5, 6, 6, 6, 6, 5
    .byte 6, 7, 6, 7, 6, 7, 6, 5, 7, 7, 6, 4, 7, 7, 6
    .byte 5, 7, 7, 6, 6, 6, 5, 6, 7, 5, 7, 7, 4, 7, 7
    .byte 6, 6, 6, 6, 6, 7, 5, 6, 6, 7, 7, 6, 7, 8, 6, 7
    .byte 7, 7, 6, 7, 6, 7, 7, 8, 7, 7, 6, 5, 6, 7, 6, 6
    .byte 7, 6, 4, 6, 7, 7, 6, 7, 6, 5, 6, 7, 6, 6, 7
    .byte 6, 5, 7, 6, 6, 5, 5, 7, 7, 6, 5, 5, 4, 7, 7
    .byte 5, 7, 7, 7, 6, 7, 6, 5, 4, 7, 7, 5, 5, 7, 7
    .byte 6, 5, 6, 5, 6, 7, 6, 7, 6, 5, 7, 7, 7, 7, 7
    .byte 8, 7, 7, 7, 5, 6, 7, 7, 6, 7, 7, 6, 5, 7, 7, 7
    .byte 6, 5, 6, 7, 7, 7, 4, 6, 7, 6, 7, 7, 6, 7, 7
    .byte 6, 7, 6, 7, 6, 6, 6, 7, 7, 7, 5, 6, 7, 6, 5
    .byte 6, 6, 5, 6, 6, 7, 7, 6, 6, 7, 6, 7, 3, 6, 5
    .byte 6, 7, 7, 5, 7, 5, 7, 5, 6, 8, 7, 7, 5, 6, 7, 8
    .byte 5, 6, 6, 7, 6, 7, 7, 8, 7, 6, 7, 7, 6, 7, 5, 7
    .byte 6, 6, 7, 4, 7, 7, 7, 7, 7, 5, 6, 6, 7, 7, 7
    .byte 5, 7, 7, 6, 7, 7, 6, 6, 5, 6, 7, 7, 7, 5, 7
    .byte 5, 6, 6, 5, 5, 5, 8, 6, 7, 6, 7, 6, 6, 7, 7, 4
    .byte 6, 5, 6, 6, 6, 8, 6, 7, 6, 6, 6, 6, 7, 6, 6, 6
    .byte 8, 6, 7, 6, 6, 7, 7, 8, 7, 7, 4, 7, 8, 7, 6, 6
    .byte 7
    .byte 7, 7, 7, 6, 7, 6, 7, 7, 7, 5, 7, 6, 5, 6, 7
    .byte 8, 7, 6, 7, 6, 7, 5, 6, 6, 6, 6, 6, 6, 7, 6, 6
    .byte 6, 5, 7, 7, 6, 6, 3, 7, 7, 6, 6, 6, 7, 7, 6
    .byte 8, 7, 6, 4, 6, 6, 6, 6, 7, 7, 5, 6, 6, 7, 6, 6
    .byte 7, 6, 5, 6, 6, 7, 7, 8, 7, 6, 6, 8, 6, 6, 6, 6
    .byte 6, 6, 8, 5, 6, 6, 7, 7, 7, 6, 7, 7, 6, 6, 7, 7
    .byte 7, 6, 7, 6, 6, 6, 6, 6, 5, 6, 7, 5, 7, 6, 6
    .byte 3, 6, 5, 7, 7, 5, 7, 6, 6, 6, 6, 6, 6, 6, 6
    .byte 6, 5, 6, 5, 7, 6, 6, 5, 7, 5, 7, 8, 5, 7, 5, 6
    .byte 7, 7, 6, 5, 6, 6, 7, 7, 6, 7, 8, 8, 7, 8, 7, 5
    .byte 7
    .byte 7, 6, 6, 6, 6, 7, 8, 6, 8, 6, 5, 8, 6, 6, 7, 7
    .byte 7
    .byte 8, 7, 7, 7, 6, 6, 6, 7, 5, 6, 5, 6, 6, 7, 7, 2
    .byte 7, 5, 7, 7, 6, 6, 6, 5, 7, 6, 7, 7, 5, 6, 7
    .byte 7, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 8, 7, 6, 7, 6
    .byte 6, 7, 6, 6, 5, 6, 6, 7, 6, 7, 7, 7, 6, 7, 8, 7
    .byte 5, 7, 6, 6, 5, 7, 6, 7, 6, 6, 8, 6, 6, 7, 6, 7
    .byte 6, 7, 7, 8, 5, 6, 7, 6, 5, 6, 6, 5, 6, 6, 6, 6
    .byte 6, 6, 3, 7, 4, 6, 6, 6, 7, 5, 6, 7, 6, 6, 6
    .byte 6, 7, 6, 6, 5, 6, 7, 5, 7, 6, 6, 6, 7, 7, 6
    .byte 6, 6, 6, 6, 7, 6, 6, 5, 7, 6, 6, 7, 7, 8, 7, 7
    .byte 7, 7, 6, 6, 6, 5, 6, 6, 6, 6, 7, 7, 8, 5, 6, 7
    .byte 7, 6, 7, 7, 8, 7, 6, 7, 7, 6, 6, 5, 6, 4, 6, 6
    .byte 6, 6, 7, 7, 3, 6, 5, 6, 6, 6, 7, 7, 6, 7, 5
    .byte 7, 7, 5, 7, 7, 7, 5, 6, 6, 6, 7, 6, 4, 7, 7
    .byte 7, 6, 6, 7, 5, 7, 7, 7, 5, 6, 7, 6, 5, 5, 6
    .byte 7, 6, 7, 7, 7, 7, 6, 7, 8, 7, 4, 6, 6, 6, 7, 7
    .byte 6, 7, 7, 7, 6, 7, 7, 7, 7, 6, 7, 4, 7, 7, 6
    .byte 7, 7, 7, 7, 7, 7, 5, 4, 5, 7, 5, 6, 5, 6, 5
    .byte 7, 6, 7, 6, 7, 7, 6, 6, 7, 7, 6, 4, 6, 7, 7
    .byte 6, 6, 7, 8, 6, 7, 7, 5, 6, 6, 6, 5, 6, 7, 7, 5
    .byte 7, 7, 7, 6, 7, 7, 6, 6, 7, 7, 6, 7, 7, 6, 7
    .byte 6, 6, 7, 7, 7, 7, 6, 6, 7, 6, 6, 7, 7, 7, 8, 7
    .byte 5, 5, 6, 7, 6, 7, 7, 6, 5, 5, 6, 7, 7, 3, 7
    .byte 7, 6, 5, 5, 7, 6, 7, 7, 5, 7, 5, 5, 6, 5, 7
    .byte 6, 7, 6, 6, 7, 7, 6, 7, 7, 6, 6, 6, 5, 6, 6
    .byte 6, 6, 6, 7, 6, 7, 7, 7, 5, 7, 7, 7, 6, 7, 7
    .byte 7, 7, 7, 6, 6, 6, 7, 7, 7, 6, 7, 6, 5, 7, 7
    .byte 6, 6, 6, 7, 7, 7, 5, 4, 6, 7, 7, 7, 7, 7, 5
    .byte 6, 6, 4, 5, 4, 5, 7, 6, 6, 5, 7, 6, 7, 5, 7
    .byte 6, 6, 7, 6, 6, 7, 7, 5, 7, 6, 6, 7, 6, 7, 7
    .byte 7, 7, 7, 6, 6, 6, 6, 4, 6, 7, 7, 6, 7, 7, 7
    .byte 6, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 4, 6, 6, 6
    .byte 7, 7, 6, 6, 6, 6, 7, 6, 6, 7, 8, 7, 7, 5, 6, 6
    .byte 6, 7, 6, 7, 6, 6, 4, 7, 6, 6, 4, 3, 7, 7, 6
    .byte 7, 6, 7, 6, 6, 7, 7, 6, 6, 7, 6, 5, 5, 7, 6
    .byte 7, 7, 7, 6, 7, 6, 6, 6, 5, 7, 7, 5, 6, 6
    .byte 6, 6, 6, 7, 7, 5, 7, 8, 7, 5, 7, 7, 7, 7, 7, 7
    .byte 6, 6, 8, 6, 8, 6, 5, 7, 7, 7, 7, 7, 7, 6, 7, 6
    .byte 5, 5, 6, 6, 7, 7, 7, 4, 7, 6, 4, 6, 5, 7, 6
    .byte 6, 7, 6, 4, 6, 7, 6, 6, 6, 5, 6, 7, 7, 5, 6
    .byte 7, 6, 7, 6, 7, 6, 6, 7, 7, 7, 5, 6, 7, 6, 6
    .byte 7, 6, 7, 7, 7, 6, 6, 6, 7, 5, 6, 8, 7, 6, 7, 6
    .byte 7, 6, 7, 6, 6, 6, 7, 6, 7, 5, 5, 6, 7, 7, 7
    .byte 7, 7, 7, 7, 6, 7, 7, 6, 6, 7, 5, 7, 6, 7, 5
    .byte 3, 6, 6, 7, 4, 6, 7, 7, 4, 7, 7, 6, 6, 6, 6
    .byte 6, 6, 7, 6, 6, 6, 6, 7, 6, 6, 6, 7, 4, 7, 7
    .byte 5, 6, 6, 6, 6, 8, 7, 6, 6, 5, 7, 7, 7, 6, 6, 7
    .byte 7, 8, 7, 6, 7, 7, 7, 7, 7, 5, 8, 7, 7, 6, 6, 6
    .byte 7, 7, 7, 8, 7, 7, 7, 6, 7, 7, 7, 6, 7, 6, 6, 7
    .byte 6, 5, 6, 7, 7, 4, 6, 7, 7, 7, 5, 7, 6, 8, 7, 5
    .byte 6, 4, 6, 6, 7, 6, 7, 8, 7, 6, 7, 7, 6, 5, 6, 6
    .byte 7, 6, 5, 5, 8, 7, 6, 5, 6, 7, 7, 5, 6, 6, 7, 6
    .byte 6, 7, 6, 6, 7, 6, 6, 7, 7, 7, 7, 7, 7, 6, 6
    .byte 6, 7, 5, 6, 7, 7, 6, 7, 6, 7, 7, 5, 6, 6, 8, 6
    .byte 5, 7, 5, 6, 4, 5, 4, 5, 5, 6, 7, 6, 4, 6, 6
    .byte 7, 6, 6, 6, 6, 7, 6, 6, 6, 7, 6, 5, 7, 7, 7
    .byte 6, 6, 5, 7, 8, 7, 6, 7, 6, 6, 7, 6, 6, 5, 6, 6
    .byte 6, 6, 6, 6, 7, 7, 6, 7, 8, 7, 6, 7, 7, 7, 5, 7
    .byte 6, 6, 7, 7, 6, 7, 8, 7, 6, 7, 8, 7, 6, 6, 6, 3
    .byte 6, 6, 6, 6, 6, 7, 7, 7, 6, 6, 4, 5, 6, 4, 6
    .byte 6, 6, 5, 6, 7, 7, 7, 6, 6, 6, 6, 7, 6, 5, 5
    .byte 6, 6, 6, 6, 6, 5, 8, 8, 7, 6, 5, 4, 5, 6, 6, 5
    .byte 7, 6, 6, 7, 7, 7, 4, 7, 7, 6, 5, 7, 8, 7, 7, 7
    .byte 6, 5, 7, 7, 7, 6, 7, 6, 6, 6, 6, 7, 7, 5, 7
    .byte 6, 7, 7, 5, 5, 5, 7, 7, 7, 7, 6, 6, 6, 7, 4
    .byte 4, 5, 5, 7, 6, 6, 6, 7, 5, 7, 5, 6, 6, 6, 6
    .byte 6, 7, 7, 7, 6, 7, 7, 6, 6, 7, 7, 6, 7, 7, 7
    .byte 6, 6, 6, 7, 5, 6, 8, 7, 7, 7, 6, 6, 6, 7, 6, 8
    .byte 7, 7, 7, 7, 6, 6, 7, 5, 5, 5, 7, 7, 7, 7, 6
    .byte 7, 6, 8, 7, 7, 7, 7, 6, 6, 6, 7, 6, 7, 7, 6, 7
    .byte 7, 7, 3, 8, 6, 6, 4, 4, 7, 8, 7, 7, 6, 7, 7, 7
    .byte 6, 6, 6, 6, 7, 5, 5, 5, 7, 7, 7, 7, 6, 7, 6
    .byte 7, 6, 5, 6, 6, 6, 6, 6, 7, 7, 6, 7, 6, 7, 6
    .byte 6, 7, 6, 7, 7, 7, 6, 7, 6, 6, 7, 5, 5, 7, 7
    .byte 7, 7, 6, 7, 7, 6, 7, 7, 7, 7, 7, 7, 5, 6, 6
    .byte 7, 6, 7, 6, 6, 6, 4, 7, 6, 6, 4, 7, 6, 6, 6
    .byte 5, 8, 7, 8, 7, 5, 6, 5, 4, 5, 5, 7, 6, 8, 7, 7
    .byte 7
    .byte 7, 6, 5, 7, 7, 6, 7, 5, 6, 8, 6, 7, 5, 6, 6, 7
    .byte 6, 6, 4, 7, 8, 7, 6, 6, 7, 6, 6, 7, 7, 5, 7, 7
    .byte 5, 7, 7, 5, 7, 7, 7, 7, 7, 7, 6, 7, 6, 6, 5
    .byte 7, 6, 6, 7, 6, 4, 6, 6, 5, 6, 5, 7, 5, 7, 7
    .byte 6, 3, 6, 7, 7, 6, 5, 6, 6, 7, 6, 5, 7, 6, 6
    .byte 6, 7, 6, 6, 6, 5, 6, 7, 6, 7, 7, 5, 7, 7, 8, 7
    .byte 6, 6, 7, 8, 6, 6, 5, 6, 7, 7, 7, 7, 8, 6, 7, 7
    .byte 7, 6, 7, 7, 6, 6, 6, 5, 7, 6, 7, 7, 7, 6, 8, 7
    .byte 6, 7, 6, 6, 6, 6, 7, 7, 6, 4, 6, 7, 7, 4, 6
    .byte 7, 7, 6, 5, 7, 6, 7, 7, 5, 6, 4, 7, 6, 7, 7
    .byte 7, 7, 7, 7, 8, 7, 6, 4, 5, 6, 6, 6, 6, 5, 7, 7
    .byte 6, 6, 6, 7, 7, 5, 7, 6, 6, 5, 6, 7, 6, 7, 7
    .byte 7, 6, 7, 6, 6, 7, 7, 6, 5, 7, 6, 7, 6, 6, 7
    .byte 7, 7, 7, 7, 6, 8, 6, 7, 6, 7, 7, 5, 7, 5, 6, 5
    .byte 5, 5, 5, 6, 5, 7, 7, 3, 7, 6, 7, 7, 5, 6, 5
    .byte 7, 6, 6, 6, 7, 7, 6, 7, 7, 6, 6, 6, 6, 8, 7, 6
    .byte 7, 6, 6, 6, 6, 6, 7, 6, 7, 7, 7, 5, 6, 5, 6
    .byte 7, 8, 7, 6, 7, 7, 5, 6, 6, 6, 6, 6, 6, 6, 5, 6
    .byte 6, 6, 8, 7, 7, 7, 7, 7, 6, 6, 7, 5, 7, 7, 5, 6
    .byte 7, 6, 6, 4, 6, 6, 7, 4, 7, 7, 7, 4, 7, 7, 7
    .byte 6, 6, 7, 5, 6, 7, 7, 6, 6, 6, 7, 6, 6, 5, 6
    .byte 5, 7, 8, 7, 5, 7, 6, 6, 4, 6, 6, 7, 7, 5, 7, 7
    .byte 7, 7, 8, 8, 7, 6, 6, 7, 6, 7, 6, 6, 6, 5, 8, 7
    .byte 6
    .byte 5, 6, 7, 6, 7, 7, 8, 6, 5, 7, 7, 6, 7, 6, 6, 6
    .byte 6, 6, 7, 7, 7, 7, 7, 6, 3, 6, 6, 7, 6, 5, 7
    .byte 5, 6, 5, 6, 7, 5, 7, 7, 6, 6, 7, 5, 5, 5, 6
    .byte 6, 6, 5, 7, 6, 6, 7, 5, 7, 3, 6, 7, 6, 6, 6
    .byte 7, 6, 7, 7, 6, 6, 8, 7, 6, 6, 5, 6, 7, 7, 6, 6
    .byte 7, 6, 7, 7, 5, 7, 6, 6, 6, 7, 6, 5, 6, 7, 6
    .byte 6, 5, 7, 7, 6, 7, 7, 6, 8, 7, 6, 7, 7, 8, 5, 6
    .byte 6, 7, 5, 6, 5, 6, 8, 6, 6, 6, 7, 6, 6, 7, 7, 5
    .byte 6, 6, 6, 6, 5, 5, 7, 7, 6, 6, 7, 5, 7, 4, 7
    .byte 7, 6, 7, 7, 7, 7, 8, 6, 7, 7, 7, 6, 7, 6, 5, 8
    .byte 7, 6, 5, 6, 7, 6, 7, 7, 7, 7, 6, 7, 6, 7, 5
    .byte 5, 6, 6, 7, 6, 7, 7, 6, 6, 7, 6, 6, 7, 7, 6
    .byte 7, 7, 6, 5, 6, 7, 6, 5, 7, 7, 6, 6, 5, 7, 6
    .byte 6, 6, 5, 7, 2, 6, 5, 6, 6, 7, 6, 6, 7, 5, 7
    .byte 7, 4, 6, 5, 6, 6, 6, 6, 7, 7, 7, 7, 6, 6, 6
    .byte 7, 6, 6, 7, 8, 6, 7, 6, 6, 5, 7, 7, 7, 5, 6, 7
    .byte 6, 7, 7, 6, 6, 6, 6, 7, 6, 6, 7, 7, 6, 6, 5
    .byte 7, 7, 7, 6, 6, 7, 5, 6, 6, 5, 7, 6, 5, 6, 7
    .byte 6, 7, 6, 7, 7, 7, 6, 7, 8, 6, 2, 6, 7, 7, 6, 2
    .byte 6, 7, 7, 6, 6, 6, 7, 6, 6, 7, 7, 7, 6, 8, 6, 7
    .byte 7, 6, 5, 7, 7, 6, 7, 7, 8, 7, 7, 5, 7, 7, 6, 7
    .byte 6, 7, 7, 6, 6, 7, 6, 6, 6, 7, 8, 6, 6, 6, 6, 6
    .byte 6, 6, 8, 7, 6, 7, 7, 6, 4, 7, 6, 6, 6, 6, 7, 5
    .byte 5, 7, 6, 6, 6, 6, 7, 6, 7, 6, 6, 5, 5, 7, 6
    .byte 6, 6, 6, 5, 6, 6, 7, 6, 7, 6, 7, 7, 4, 7, 7
    .byte 8, 7, 6, 7, 6, 7, 6, 7, 7, 7, 7, 7, 7, 7, 7, 6
    .byte 6, 6, 5, 6, 6, 8, 5, 7, 6, 6, 7, 6, 7, 7, 6, 7
    .byte 7, 7, 6, 7, 6, 7, 7, 6, 7, 5, 7, 6, 6, 7, 6
    .byte 5, 6, 7, 5, 6, 7, 6, 7, 6, 7, 4, 5, 7, 7, 7
    .byte 4, 7, 6, 7, 5, 4, 5, 6, 7, 6, 5, 6, 7, 7, 5
    .byte 7, 5, 6, 7, 7, 7, 7, 7, 5, 7, 6, 7, 7, 7, 7
    .byte 7, 7, 7, 5, 7, 5, 6, 5, 7, 6, 8, 7, 6, 6, 7, 6
    .byte 4, 6, 6, 7, 5, 6, 8, 6, 7, 7, 6, 8, 6, 7, 6, 6
    .byte 7, 6, 5, 5, 6, 6, 6, 6, 6, 7, 7, 6, 6, 7, 6
    .byte 5, 5, 7, 5, 6, 6, 4, 6, 7, 6, 6, 5, 6, 4, 7
    .byte 5, 6, 7, 7, 6, 6, 7, 7, 7, 6, 7, 7, 7, 6, 5
    .byte 8, 7, 7, 7, 6, 6, 6, 7, 6, 6, 6, 6, 6, 7, 7, 6
    .byte 6, 6, 6, 6, 7, 7, 6, 7, 7, 6, 6, 7, 6, 6, 7
    .byte 7, 7, 6, 6, 6, 6, 6, 6, 6, 7, 4, 6, 7, 6, 7
    .byte 6, 7, 5, 6, 6, 3, 5, 7, 6, 7, 6, 7, 5, 6, 6
    .byte 6, 7, 5, 7, 5, 5, 6, 6, 7, 6, 8, 7, 5, 7, 7, 7
    .byte 6, 7, 8, 6, 7, 6, 6, 5, 6, 6, 6, 6, 6, 7, 5, 7
    .byte 6, 6, 7, 5, 7, 6, 6, 6, 6, 7, 6, 7, 7, 6, 7
    .byte 7, 7, 7, 7, 7, 6, 5, 6, 7, 7, 6, 6, 7, 7, 4
    .byte 6, 5, 7, 7, 5, 6, 6, 7, 6, 6, 6, 4, 7, 6, 6
    .byte 5, 6, 5, 6, 6, 6, 7, 4, 5, 6, 5, 7, 7, 6, 7
    .byte 6, 7, 6, 6, 6, 7, 7, 6, 8, 6, 6, 6, 6, 6, 6, 6
    .byte 6, 6, 7, 7, 6, 6, 6, 5, 6, 6, 6, 5, 6, 7, 7
    .byte 7, 5, 8, 7, 6, 7, 7, 7, 5, 6, 5, 4, 6, 5, 5, 7
    .byte 7, 5, 7, 7, 5, 7, 7, 6, 5, 5, 7, 6, 7, 5, 7
    .byte 7, 7, 5, 7, 6, 6, 5, 6, 7, 6, 4, 6, 6, 5, 6
    .byte 7, 7, 8, 7, 6, 7, 6, 7, 7, 7, 7, 7, 7, 6, 7, 7
    .byte 7, 6, 7, 7, 7, 7, 6, 7, 8, 6, 4, 6, 6, 6, 6, 6
    .byte 6, 5, 7, 5, 6, 7, 7, 7, 7, 6, 8, 6, 7, 6, 6, 5
    .byte 6, 7, 8, 6, 7, 6, 6, 6, 8, 5, 6, 4, 7, 7, 7, 7
    .byte 6, 8, 6, 4, 7, 7, 6, 3, 6, 3, 8, 7, 8, 5, 6, 7
    .byte 7
    .byte 6, 7, 8, 6, 5, 7, 7, 7, 8, 6, 7, 7, 8, 8, 6, 6
    .byte 6
    .byte 6, 7, 7, 6, 7, 7, 7, 7, 6, 7, 5, 7, 7, 7, 7
    .byte 6, 7, 6, 7, 6, 7, 7, 7, 7, 7, 7, 7, 5, 6, 6
    .byte 6, 4, 5, 6, 7, 7, 6, 7, 5, 6, 6, 6, 7, 7, 6
    .byte 7, 7, 5, 6, 7, 5, 5, 7, 6, 5, 7, 5, 6, 6, 6
    .byte 6, 7, 3, 5, 7, 7, 7, 8, 7, 7, 6, 6, 6, 6, 6, 6
    .byte 7, 8, 6, 7, 7, 7, 6, 5, 6, 7, 7, 6, 7, 7, 6, 6
    .byte 5, 6, 6, 6, 7, 6, 7, 7, 7, 7, 6, 7, 7, 7, 7
    .byte 7, 7, 7, 5, 6, 5, 6, 5, 6, 6, 7, 5, 7, 6, 6
    .byte 6, 5
    .byte 6, 7, 5, 7, 6, 6, 3, 6, 7, 6, 5, 6, 6, 7, 6
    .byte 6, 5, 6, 6, 6, 5, 5, 7, 5, 7, 5, 7, 7, 6, 7
    .byte 7, 7, 7, 7, 7, 7, 7, 6, 7, 7, 6, 7, 6, 6, 7
    .byte 7, 7, 7, 6, 6, 6, 5, 6, 7, 7, 7, 6, 6, 6, 6
    .byte 7, 8, 8, 6, 6, 6, 7, 6, 7, 6, 6, 6, 6, 5, 6, 7
    .byte 5, 7, 7, 6, 7, 5, 7, 6, 7, 6, 6, 5, 6, 7, 7
    .byte 7, 3, 7, 6, 6, 6, 7, 7, 4, 5, 6, 6, 8, 7, 6, 6
    .byte 7, 7, 6, 7, 7, 6, 7, 6, 7, 7, 7, 5, 7, 7, 6
    .byte 5, 6, 5, 7, 7, 6, 7, 7, 5, 6, 5, 6, 6, 6, 6
    .byte 6, 7, 5, 7, 7, 7, 7, 7, 7, 6, 6, 6, 5, 6, 7
    .byte 4, 6, 6, 6, 8, 7, 6, 5, 7, 6, 4, 7, 7, 6, 6, 5
    .byte 6, 6, 7, 6, 5, 6, 6, 5, 7, 6, 6, 6, 7, 6, 6
    .byte 5, 6, 7, 6, 7, 7, 7, 7, 6, 5, 7, 6, 7, 7, 8, 8
    .byte 6, 5, 7, 6, 7, 5, 7, 6, 6, 7, 7, 6, 4, 6, 6
    .byte 5, 6, 7, 6, 7, 7, 7, 5, 7, 7, 7, 7, 6, 6, 6
    .byte 6, 6, 6, 7, 5, 5, 7, 7, 6, 4, 7, 7, 6, 5, 5
    .byte 6, 7, 6, 6, 5, 6, 6, 6, 7, 6, 5, 7, 6, 7, 5
    .byte 5, 6, 6, 5, 6, 6, 7, 6, 7, 6, 6, 7, 6, 6, 7
    .byte 7, 7, 6, 7, 7, 6, 7, 6, 7, 7, 6, 7, 5, 6, 6
    .byte 7, 5, 7, 6, 7, 6, 8, 6, 7, 6, 6, 5, 5, 7, 6, 8
    .byte 7, 6, 7, 6, 7, 6, 6, 6, 4, 6, 6, 6, 7, 6, 6
    .byte 6, 7, 7, 6, 6, 6, 4, 6, 5, 6, 6, 7, 5, 7, 7
    .byte 8, 3, 7, 7, 6, 5, 6, 5, 7, 3, 7, 7, 7, 8, 7, 6
    .byte 7, 6, 6, 6, 7, 7, 6, 6, 7, 6, 6, 6, 7, 7, 7
    .byte 7, 7, 6, 4, 6, 7, 6, 7, 7, 6, 7, 7, 6, 5, 5
    .byte 6, 6, 6, 7, 7, 7, 7, 7, 7, 6, 5, 7, 7, 6, 6
    .byte 7, 6, 8, 5, 7, 7, 7, 7, 6, 7, 3, 7, 6, 5, 6, 4
    .byte 6, 6, 7, 5, 5, 6, 5, 7, 7, 6, 6, 7, 7, 7, 4
    .byte 7, 7, 7, 7, 7, 6, 6, 7, 5, 6, 7, 7, 7, 7, 6
    .byte 5, 7, 6, 6, 6, 7, 7, 6, 8, 5, 7, 7, 7, 7, 7, 5
    .byte 6, 6, 6, 6, 5, 7, 7, 7, 6, 6, 7, 6, 7, 7, 7
    .byte 6, 7, 4, 5, 6, 7, 5, 6, 7, 7, 6, 7, 7, 6, 6
    .byte 6, 5, 3, 6, 6, 7, 7, 7, 6, 6, 7, 4, 6, 7, 7
    .byte 6, 7, 6, 6, 5, 7, 8, 6, 7, 7, 7, 7, 5, 7, 7, 6
    .byte 7, 7, 6, 7, 6, 7, 7, 7, 7, 7, 6, 6, 6, 7, 5
    .byte 6, 7, 6, 6, 7, 6, 6, 5, 6, 5, 6, 7, 6, 7, 6
    .byte 8, 7, 6, 7, 6, 6, 6, 6, 5, 5, 7, 7, 5, 7, 6, 7
    .byte 7, 6, 6, 7, 6, 5, 5, 6, 6, 5, 6, 7, 4, 5, 6
    .byte 6, 7, 6, 7, 5, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
    .byte 5, 7, 6, 5, 7, 7, 7, 5, 6, 6, 7, 5, 6, 6, 6
    .byte 7, 5, 6, 7, 7, 5, 6, 7, 6, 6, 7, 7, 7, 7, 6
    .byte 6, 6, 6, 7, 7, 5, 6, 7, 7, 6, 5, 7, 6, 6, 6
    .byte 6, 6, 7, 7, 6, 7, 6, 4, 4, 7, 5, 5, 7, 7, 7
    .byte 3, 7, 7, 7, 6, 6, 5, 6, 7, 6, 7, 6, 5, 7, 8, 7
    .byte 7, 6, 7, 7, 7, 6, 8, 6, 7, 7, 7, 7, 6, 7, 5, 5
    .byte 6, 6, 5, 7, 7, 6, 7, 7, 6, 7, 7, 7, 7, 6, 6
    .byte 7, 7, 7, 6, 6, 6, 7, 7, 7, 7, 7, 5, 7, 7, 6
    .byte 6, 6, 7, 7, 6, 7, 7, 7, 7, 7, 6, 7, 1, 7, 6
    .byte 7, 7, 7, 6, 6, 6, 6, 7, 6, 7, 5, 7, 7, 5, 6
    .byte 7, 6, 7, 7, 7, 7, 7, 6, 7, 6, 6, 7, 6, 6, 5
    .byte 6, 6, 6, 6, 6, 7, 4, 6, 7, 5, 7, 5, 5, 6, 6
    .byte 6, 6, 6, 6, 7, 7, 7, 7, 6, 8, 6, 6, 6, 7, 6, 6
    .byte 7, 6, 6, 5, 6, 6, 5, 7, 6, 6, 6, 7, 7, 6, 6
    .byte 5, 4, 6, 6, 5, 7, 7, 7, 6, 6, 7, 5, 6, 6, 7
    .byte 6, 7, 7, 6, 6, 7, 7, 6, 7, 7, 6, 7, 7, 7, 7
    .byte 7, 7, 4, 7, 7, 6, 5, 6, 7, 6, 5, 5, 6, 5, 7
    .byte 5, 5, 7, 6, 7, 6, 7, 7, 6, 7, 8, 6, 7, 7, 6, 5
    .byte 7, 7, 6, 7, 7, 7, 7, 7, 6, 7, 6, 7, 5, 5, 7
    .byte 7, 6, 4, 7, 7, 5, 4, 3, 7, 6, 6, 6, 7, 7, 7
    .byte 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 8, 6, 7, 7, 5, 6
    .byte 7, 7, 6, 7, 6, 8, 6, 3, 5, 7, 8, 7, 7, 7, 7, 6
    .byte 6, 6, 6, 7, 5, 6, 7, 7, 5, 7, 6, 7, 6, 7, 6
    .byte 8, 7, 7, 8, 6, 7, 6, 6, 7, 6, 7, 6, 6, 5, 5, 7
    .byte 7, 6, 6, 5, 7, 6, 7, 5, 5, 4, 5, 7, 7, 5, 7
    .byte 7, 6, 5, 7, 7, 6, 5, 6, 6, 6, 6, 6, 7, 7, 6
    .byte 6, 7, 6, 7, 6, 7, 7, 7, 7, 6, 6, 4, 7, 6, 7
    .byte 7, 5, 7, 6, 6, 6, 5, 5, 7, 5, 6, 7, 7, 6, 7
    .byte 7, 7, 6, 7, 6, 7, 7, 7, 6, 6, 7, 6, 7, 6, 7
    .byte 7, 7, 5, 6, 6, 6, 7, 7, 7, 6, 6, 6, 4, 4, 5
    .byte 5, 6, 6, 6, 5, 6, 7, 6, 6, 7, 6, 4, 5, 6, 3
    .byte 8, 7, 7, 7, 7, 7, 7, 7, 7, 6, 7, 7, 7, 8, 7, 6
    .byte 7, 6, 5, 6, 7, 7, 7, 7, 6, 7, 6, 5, 7, 6, 6
    .byte 6, 6, 7, 7, 7, 6, 7, 6, 6, 7, 7, 7, 7, 6, 7
    .byte 7, 6, 7, 5, 8, 6, 7, 6, 7, 5, 7, 7, 7, 5, 7, 8
    .byte 7, 5, 6, 6, 6, 3, 6, 6, 7, 8, 7, 6, 7, 7, 7, 5
    .byte 6, 5, 7, 5, 6, 6, 7, 6, 7, 7, 7, 7, 6, 5, 6
    .byte 7, 6, 7, 7, 6, 6, 6, 4, 6, 6, 7, 6, 7, 7, 7
    .byte 6, 7, 6, 5, 7, 6, 6, 7, 7, 8, 6, 7, 7, 5, 7, 6
    .byte 5, 5, 7, 7, 6, 6, 6, 6, 7, 6, 7, 6, 6, 7, 7
    .byte 7, 6, 6, 5, 4, 6, 6, 5, 5, 5, 7, 7, 5, 6, 6
    .byte 7, 7, 6, 7, 6, 7, 4, 6, 6, 6, 7, 7, 7, 6, 6
    .byte 6, 7, 7, 7, 7, 7, 6, 6, 7, 6, 6, 6, 6, 5, 7
    .byte 6, 5, 6, 6, 6, 6, 4, 5, 7, 6, 7, 6, 7, 7, 5
    .byte 7, 6, 6, 7, 7, 7, 7, 6, 5, 7, 7, 7, 8, 6, 7, 6
    .byte 7, 4, 6, 6, 5, 7, 6, 6, 6, 7, 7, 4, 5, 6, 6
    .byte 7, 6, 6, 7, 7, 6, 6, 6, 7, 5, 6, 5, 6, 7, 7
    .byte 7, 6, 7, 7, 5, 7, 7, 6, 7, 6, 6, 7, 6, 6, 6
    .byte 6, 4, 7, 7, 6, 7, 5, 6, 6, 4, 5, 5, 7, 7, 7
    .byte 7, 7, 6, 6, 7, 6, 6, 7, 7, 7, 7, 7, 6, 7, 6
    .byte 7, 7, 7, 6, 6, 5, 4, 6, 6, 6, 6, 7, 6, 6, 7
    .byte 4, 6, 7, 6, 5, 3, 6, 6, 6, 5, 7, 6, 5, 8, 8, 6
    .byte 6, 6, 6, 7, 7, 6, 7, 7, 5, 6, 7, 6, 6, 8, 6, 7
    .byte 7, 6, 7, 6, 5, 7, 6, 7, 6, 7, 7, 6, 6, 6, 5
    .byte 5, 7, 6, 7, 7, 6, 7, 7, 6, 6, 7, 7, 6, 7, 6
    .byte 7, 7, 5, 6, 7, 6, 7, 7, 7, 6, 6, 7, 6, 5, 7
    .byte 7, 6, 8, 7, 7, 6, 5, 7, 2, 6, 6, 7, 6, 7, 8, 6
    .byte 6, 7, 6, 7, 4, 6, 4, 7, 6, 8, 7, 7, 7, 7, 7, 8
    .byte 7, 6, 6, 7, 6, 7, 6, 6, 6, 6, 7, 7, 6, 5, 5
    .byte 7, 7, 7, 4, 6, 7, 7, 7, 6, 7, 8, 7, 7, 6, 7, 7
    .byte 7, 7, 7, 6, 5, 7, 7, 8, 8, 8, 6, 6, 6, 6, 6, 6
    .byte 7
    .byte 7, 6, 5, 7, 7, 4, 6, 5, 5, 5, 6, 5, 7, 6, 7
    .byte 6, 7, 6, 7, 6, 6, 5, 6, 6, 7, 6, 7, 7, 8, 7, 5
    .byte 6, 5, 6, 7, 7, 7, 7, 6, 6, 7, 5, 6, 7, 6, 5
    .byte 6, 6, 7, 6, 6, 5, 6, 6, 6, 6, 6, 7, 6, 6, 6
    .byte 7, 8, 5, 7, 7, 7, 7, 7, 6, 7, 7, 7, 7, 7, 6, 6
    .byte 6, 6, 6, 7, 5, 6, 6, 5, 6, 4, 6, 5, 7, 7, 3
    .byte 7, 7, 5, 7, 7, 4, 5, 6, 7, 6, 7, 6, 6, 6, 7
    .byte 7, 7, 7, 6, 6, 6, 6, 5, 6, 7, 6, 8, 6, 6, 5, 7
    .byte 5, 6, 6, 6, 7, 7, 5, 6, 7, 7, 4, 6, 6, 7, 6
    .byte 5, 7, 6, 6, 5, 7, 7, 7, 6, 7, 6, 5, 7, 6, 6
    .byte 6, 7, 7, 7, 7, 6, 6, 7, 6, 6, 7, 5, 5, 6, 7
    .byte 6, 5, 6, 6, 7, 7, 5, 6, 5, 7, 7, 4, 6, 6, 5
    .byte 7, 7, 6, 7, 7, 6, 8, 7, 7, 4, 7, 7, 7, 6, 7, 7
    .byte 7, 6, 7, 5, 6, 6, 6, 7, 4, 7, 6, 7, 6, 6, 5
    .byte 6, 7, 6, 7, 7, 7, 6, 7, 7, 6, 7, 7, 7, 8, 6, 7
    .byte 6, 6, 7, 6, 7, 7, 7, 7, 7, 7, 5, 7, 6, 5, 7
    .byte 7, 7, 6, 6, 6, 5, 7, 4, 5, 7, 6, 4, 6, 7, 6
    .byte 5, 6, 6, 7, 6, 7, 6, 7, 7, 7, 7, 7, 6, 5, 7
    .byte 7, 7, 6, 6, 7, 6, 7, 7, 6, 6, 7, 5, 7, 6, 6
    .byte 6, 7, 5, 5, 6, 7, 6, 6, 7, 7, 6, 7, 7, 7, 6
    .byte 7, 7, 6, 7, 7, 6, 4, 7, 7, 7, 7, 7, 7, 8, 6, 7
    .byte 7, 6, 7, 6, 6, 5, 7, 6, 2, 6, 6, 7, 6, 6, 7
    .byte 7, 5, 7, 6, 6, 5, 5, 7, 7, 7, 6, 6, 6, 6, 7
    .byte 7, 7, 6, 6, 7, 7, 7, 7, 6, 7, 6, 6, 7, 7, 7
    .byte 7, 7, 4, 5, 7, 6, 6, 5, 5, 6, 7, 7, 7, 7, 6
    .byte 6, 6, 6, 6, 7, 6, 7, 6, 7, 6, 8, 8, 7, 7, 7, 6
    .byte 7, 5, 5, 7, 6, 6, 7, 7, 4, 7, 6, 7, 6, 6, 6
    .byte 7, 5, 6, 6, 7, 7, 2, 6, 6, 6, 6, 6, 5, 6, 7
    .byte 6, 5, 7, 6, 7, 6, 7, 8, 4, 8, 7, 7, 6, 6, 7, 7
    .byte 7, 7, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 7, 6, 7
    .byte 6, 7, 6, 6, 6, 5, 7, 7, 7, 6, 7, 6, 7
    .byte 7, 7, 7, 7, 7, 7, 7, 7, 6, 7, 6, 7, 7, 6, 7
    .byte 5, 7, 6, 6, 6, 6, 6, 6, 7, 4, 6, 6, 6, 4, 6
    .byte 7, 7, 5, 7, 7, 6, 7, 7, 6, 6, 6, 6, 7, 7, 6
    .byte 7, 7, 7, 7, 7, 6, 6, 6, 6, 7, 5, 7, 7, 6, 6
    .byte 7, 7, 5, 6, 7, 7, 6, 5, 6, 7, 7, 7, 4, 7, 7
    .byte 7, 7, 6, 6, 5, 7, 7, 6, 7, 7, 7, 7, 7, 7, 5
    .byte 6, 6, 6, 6, 6, 5, 5, 6, 6, 5, 7, 7, 6, 5, 6
    .byte 7, 6, 6, 5, 4, 5, 7, 5, 5, 6, 7, 6, 6, 6, 6
    .byte 6, 7, 6, 7, 8, 5, 7, 8, 6, 6, 6, 7, 5, 7, 7, 6
    .byte 7, 5, 6, 7, 7, 6, 6, 6, 6, 5, 5, 6, 6, 8, 6, 6
    .byte 6, 6, 6, 7, 7, 7, 5, 6, 7, 7, 6, 7, 6, 6, 7
    .byte 7, 7, 6, 5, 7, 5, 4, 8, 7, 5, 7, 6, 4, 7, 7, 5
    .byte 6, 7, 7, 5, 7, 6, 5, 4, 6, 6, 5, 7, 6, 6, 6
    .byte 7, 6, 4, 7, 7, 7, 6, 7, 6, 7, 5, 6, 7, 7, 7
    .byte 5, 6, 7, 6, 7, 8, 7, 7, 7, 6, 7, 6, 7, 5, 5, 6
    .byte 6, 7, 7, 6, 6, 7, 7, 7, 6, 6, 7, 6, 6, 7, 6
    .byte 5, 7, 7, 6, 6, 7, 6, 8, 8, 7, 7, 6, 6, 2, 7, 7
    .byte 7, 7, 6, 6, 5, 7, 6, 5, 7, 6, 7, 7, 6, 7, 6
    .byte 6, 5, 5, 7, 6, 6, 6, 6, 7, 6, 6, 6, 4, 7, 5
    .byte 7, 7, 7, 6, 7, 6, 7, 7, 6, 7, 6, 7, 7, 7, 7
    .byte 5, 7, 7, 6, 5, 6, 7, 6, 7, 7, 7, 7, 7, 6, 6
    .byte 6, 6, 4, 5, 7, 7, 5, 7, 7, 6, 6, 7, 7, 7, 7
    .byte 7, 5, 7, 6, 6, 5, 5, 7, 7, 6, 7, 7, 6, 6, 4
    .byte 7, 7, 7, 7, 5, 6, 3, 6, 5, 5, 6, 7, 7, 7, 6
    .byte 6, 7, 6, 5, 5, 5, 7, 7, 6, 6, 7, 7, 6, 7, 6
    .byte 7, 6, 8, 7, 7, 6, 7, 5, 7, 5, 6, 6, 6, 7, 7, 5
    .byte 7, 7, 6, 7, 7, 6, 6, 6, 7, 7, 6, 7, 6, 6, 7
    .byte 7, 6, 7, 7, 7, 6, 5, 6, 5, 5, 6, 6, 7, 6, 6
    .byte 7, 7, 7, 6, 6, 6, 7, 6, 6, 7, 7, 7, 2, 7, 7
    .byte 6, 6, 4, 6, 7, 5, 6, 6, 7, 4, 6, 8, 7, 6, 5, 7
    .byte 6, 6, 7, 5, 7, 8, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6
    .byte 6, 6, 6, 6, 7, 7, 7, 6, 6, 6, 4, 6, 6, 6, 6
    .byte 6, 6, 6, 7, 7, 7, 7, 7, 6, 6, 7, 6, 7, 5, 5
    .byte 6, 7, 5, 6, 6, 6, 7, 6, 5, 6, 7, 5, 5, 7, 7
    .byte 5, 6, 6, 6, 7, 6, 3, 6, 6, 8, 6, 7, 7, 7, 6, 6
    .byte 7, 7, 7, 6, 7, 5, 7, 6, 6, 6, 7, 6, 6, 7, 7
    .byte 7, 7, 8, 6, 7, 7, 5, 7, 5, 6, 6, 5, 7, 7, 7, 6
    .byte 5, 8, 7, 6, 7, 6, 7, 6, 6, 6, 7, 7, 7, 7, 7, 6
    .byte 5, 6, 6, 5, 6, 5, 6, 5, 4, 7, 7, 6, 7, 6, 7
    .byte 6, 7, 6, 6, 5, 6, 7, 6, 6, 3, 6, 6, 7, 6, 6
    .byte 7, 7, 6, 6, 7, 4, 5, 6, 7, 7, 7, 7, 5, 7, 7
    .byte 7, 7, 6, 7, 6, 8, 7, 5, 7, 6, 6, 6, 7, 5, 7, 6
    .byte 7, 5, 7, 5, 5, 7, 6, 7, 6, 6, 8, 6, 7, 6, 6, 7
    .byte 7, 7, 7, 6, 7, 7, 6, 5, 5, 6, 5, 6, 6, 8, 7, 6
    .byte 6, 7, 6, 6, 5, 6, 4, 6, 6, 5, 6, 6, 7, 7, 5
    .byte 7, 5, 7, 6, 5, 6, 6, 6, 7, 7, 7, 7, 6, 7, 7
    .byte 6, 6, 6, 7, 6, 6, 7, 7, 6, 6, 7, 7, 7, 6, 6
    .byte 6, 7, 7, 5, 5, 6, 6, 7, 6, 6, 7, 7, 6, 7, 7
    .byte 7, 5, 7, 8, 7, 7, 7, 5, 7, 7, 5, 6, 6, 7, 3, 6
    .byte 6, 6, 7, 7, 7, 5, 7, 6, 4, 5, 7, 6, 6, 6, 7
    .byte 6, 7, 6, 5, 6, 7, 6, 7, 6, 7, 6, 8, 6, 4, 7, 7
    .byte 7, 7, 7, 7, 6, 7, 7, 6, 7, 7, 7, 8, 7, 7, 7, 5
    .byte 6, 6, 6, 6, 6, 7, 4, 7, 6, 6, 7, 6, 7, 7, 6
    .byte 7, 7, 7, 6, 6, 5, 7, 7, 7, 6, 6, 7, 6, 7, 6
    .byte 5, 5, 6, 6, 5, 5, 7, 6, 7, 7, 7, 5, 5, 7, 7
    .byte 6, 4, 6, 7, 7, 5, 6, 7, 6, 6, 7, 7, 4, 4, 7
    .byte 7, 7, 7, 7, 7, 5, 6, 7, 7, 5, 7, 7, 8, 7, 8, 6
    .byte 7, 6, 5, 5, 7, 7, 6, 7, 8, 6, 7, 5, 7, 5, 5, 7
    .byte 7, 7, 6, 7, 7, 5, 8, 7, 7, 7, 6, 6, 7, 6, 6, 5
    .byte 6, 5, 6, 7, 6, 5, 7, 7, 6, 5, 6, 6, 8, 5, 7, 6
    .byte 7, 3, 6, 6, 7, 6, 5, 6, 6, 6, 7, 6, 6, 6, 5
    .byte 6, 5, 7, 5, 7, 5, 7, 7, 6, 6, 8, 7, 7, 6, 7, 7
    .byte 7, 6, 7, 6, 6, 7, 6, 7, 7, 6, 6, 7, 7, 6, 5
    .byte 6, 7, 7, 6, 7, 6, 5, 7, 7, 6, 8, 8, 7, 7, 7, 7
    .byte 6, 6, 7, 5, 6, 6, 4, 7, 7, 6, 6, 7, 6, 7, 5
    .byte 7, 6, 7, 6, 6, 5, 6, 7, 6, 7, 4, 6, 6, 7, 6
    .byte 7, 7, 6, 6, 7, 5, 7, 7, 5, 7, 6, 7, 7, 7, 6
    .byte 7, 6, 7, 8, 7, 7, 5, 6, 7, 5, 7, 5, 6, 7, 7, 6
    .byte 7, 7, 3, 7, 6, 6, 6, 6, 7, 6, 6, 7, 6, 7, 7
    .byte 7, 7, 7, 6, 6, 5, 5, 5, 7, 4, 5, 7, 6, 6, 5
    .byte 6, 7, 5, 6, 6, 6, 7, 6, 6, 5, 6, 7, 6, 7, 6
    .byte 5, 6, 6, 6, 6, 7, 6, 5, 5, 5, 7, 7, 7, 6, 6
    .byte 7, 7, 7, 7, 6, 5, 8, 7, 7, 7, 7, 6, 6, 7, 6, 5
    .byte 6, 6, 7, 7, 7, 6, 6, 6, 5, 5, 5, 7, 6, 6, 6
    .byte 7, 6, 6, 7, 7, 8, 7, 6, 7, 6, 7, 5, 6, 6, 5, 5
    .byte 5, 7, 7, 6, 7, 5, 7, 7, 3, 7, 7, 6, 6, 5, 6
    .byte 6, 7, 6, 5, 6, 7, 6, 7, 6, 5, 5, 5, 6, 7, 7
    .byte 6, 7, 7, 5, 7, 6, 6, 7, 6, 7, 6, 6, 7, 6, 7
    .byte 7, 7, 7, 7, 6, 7, 6, 6, 6, 7, 4, 6, 6, 7, 5
    .byte 7, 5, 7, 5, 7, 5, 6, 7, 6, 8, 6, 6, 7, 6, 7, 6
    .byte 6, 6, 5, 6, 6, 7, 7, 5, 6, 6, 7, 7, 7, 5, 6
    .byte 4, 6, 4, 5, 6, 8, 5, 6, 7, 8, 4, 7, 6, 7, 5, 5
    .byte 6, 7, 4, 6, 7, 7, 7, 7, 6, 6, 6, 7, 7, 7, 6
    .byte 7, 7, 7, 5, 7, 7, 6, 7, 8, 6, 7, 6, 5, 5, 8, 6
    .byte 6, 6, 7, 7, 7, 7, 5, 4, 6, 6, 6, 8, 6, 7, 6, 7
    .byte 7, 6, 4, 7, 8, 6, 6, 7, 6, 7, 6, 6, 6, 7, 7, 6
    .byte 7, 4, 7, 6, 5, 6, 4, 7, 6, 6, 5, 6, 7, 4, 7
    .byte 7, 6, 6, 6, 7, 7, 6, 7, 7, 6, 6, 7, 6, 7, 5
    .byte 7, 7, 5, 7, 6, 7, 7, 7, 8, 7, 7, 7, 7, 6, 7, 7
    .byte 7, 5, 6, 6, 7, 6, 7, 6, 6, 6, 7, 5, 6, 7, 7
    .byte 7, 7, 8, 6, 7, 7, 5, 5, 6, 7, 6, 5, 7, 6, 6, 7
    .byte 7, 7, 7, 6, 6, 7, 6, 6, 5, 6, 6, 5, 6, 6, 5
    .byte 5, 7, 5, 7, 7, 6, 5, 7, 7, 7, 5, 6, 8, 7, 7, 8
    .byte 6, 7, 6, 5, 6, 6, 7, 6, 7, 6, 6, 8, 7, 6, 7, 7
    .byte 7, 6, 7, 5, 6, 6, 6, 7, 7, 6, 6, 6, 6, 6, 6
    .byte 6, 6, 7, 6, 6, 8, 6, 7, 7, 7, 6, 6, 3, 6, 6, 8
    .byte 6, 6, 7, 7, 6, 7, 7, 5, 6, 6, 6, 3, 5, 6, 7
    .byte 7, 7, 6, 6, 7, 5, 6, 6, 6, 7, 6, 6, 5, 6, 7
    .byte 7, 7, 6, 6, 7, 7, 6, 6, 7, 8, 7, 7, 7, 7, 4, 6
    .byte 6, 7, 6, 7, 7, 6, 6, 7, 5, 6, 6, 7, 6, 7, 6
    .byte 6, 6, 6, 7, 7, 6, 8, 8, 7, 7, 7, 7, 7, 5, 5, 7
    .byte 7, 6, 6, 7, 7, 3, 7, 6, 7, 6, 5, 5, 5, 7, 6
    .byte 6, 7, 4, 7, 7, 6, 5, 5, 6, 5, 7, 6, 7, 5, 6
    .byte 6, 4, 6, 6, 7, 7, 6, 7, 6, 6, 5, 8, 7, 6, 7, 7
    .byte 7, 6, 5, 6, 6, 5, 6, 6, 6, 7, 7, 6, 7, 6, 6
    .byte 5, 7, 6, 6, 7, 7, 6, 5, 7, 7, 7, 7, 7, 7, 6
    .byte 6, 5, 4, 7, 6, 4, 7, 7, 4, 7, 7, 6, 7, 7, 6
    .byte 4, 6, 7, 6, 7, 6, 7, 7, 8, 5, 6, 6, 7, 5, 6, 6
    .byte 5, 5, 6, 7, 4, 6, 7, 6, 7, 7, 7, 6, 6, 6, 7
    .byte 6, 7, 7, 7, 5, 7, 8, 6, 7, 6, 7, 7, 6, 5, 7, 7
    .byte 7, 4, 7, 6, 7, 6, 6, 7, 5, 6, 4, 6, 7, 6, 7
    .byte 7, 6, 7, 7, 6, 6, 7, 6, 6, 6, 7, 6, 7, 6, 5
    .byte 6, 8, 6, 6, 5, 6, 7, 6, 6, 7, 8, 6, 4, 8, 6, 5
    .byte 3
    .byte 6, 4, 7, 6, 8, 6, 7, 7, 7, 6, 8, 7, 7, 5, 7, 6
    .byte 6, 7, 6, 7, 7, 7, 7, 6, 7, 7, 6, 7, 6, 7, 7
    .byte 6, 6, 6, 5, 7, 6, 6, 7, 7, 6, 6, 6, 6, 6, 6
    .byte 6, 7, 8, 7, 6, 7, 7, 6, 7, 6, 5, 5, 5, 6, 6, 6
    .byte 5, 7, 5, 7, 6, 6, 7, 6, 6, 6, 7, 5, 6, 7, 6
    .byte 5, 7, 6, 4, 6, 5, 7, 7, 6, 4, 7, 6, 7, 6, 7
    .byte 7, 6, 7, 6, 6, 6, 6, 6, 5, 6, 7, 8, 6, 7, 7, 7
    .byte 5, 6, 7, 7, 7, 6, 6, 7, 7, 6, 6, 6, 7, 5, 6
    .byte 6, 7, 7, 7, 6, 5, 6, 7, 6, 6, 6, 6, 6, 7, 4
    .byte 7, 6, 6, 7, 6, 6, 6, 7, 7, 7, 6, 5, 5, 7, 6
    .byte 6, 6, 7, 7, 3, 7, 7, 6, 7, 6, 6, 7, 7, 6, 6
    .byte 6, 6, 7, 7, 7, 6, 7, 6, 6, 5, 6, 7, 6, 7, 5
    .byte 6, 6, 6, 7, 5, 7, 4, 6, 7, 6, 6, 6, 5, 5, 7
    .byte 7, 7, 6, 6, 7, 7, 6, 7, 6, 8, 6, 5, 6, 7, 5, 7
    .byte 6, 6, 7, 5, 5, 6, 5, 7, 5, 6, 7, 7, 7, 6, 7
    .byte 6, 5, 6, 6, 6, 7, 7, 7, 7, 5, 7, 4, 6, 5, 6
    .byte 7, 6, 7, 7, 6, 6, 8, 5, 7, 6, 7, 6, 6, 7, 7, 7
    .byte 7, 5
    .byte 7, 8, 6, 6, 7, 6, 6, 5, 5, 7, 6, 7, 6, 5, 7, 7
    .byte 7, 6, 7, 7, 6, 7, 7, 5, 6, 8, 6, 4, 7, 6, 5, 8
    .byte 7, 7, 6, 6, 6, 7, 5, 7, 5, 6, 7, 7, 6, 5, 7
    .byte 7, 5, 5, 3, 7, 6, 6, 6, 7, 7, 7, 5, 7, 6, 6
    .byte 6, 6, 7, 7, 7, 6, 6, 6, 6, 7, 8, 7, 5, 6, 7, 7
    .byte 7, 7, 6, 7, 7, 7, 6, 6, 7, 4, 5, 6, 7, 6, 7
    .byte 6, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 7, 7, 7, 7
    .byte 6, 6, 6, 7, 6, 8, 8, 4, 6, 6, 5, 6, 7, 6, 7, 7
    .byte 6, 7, 7, 7, 7, 6, 6, 2, 7, 7, 7, 7, 7, 6, 5
    .byte 6, 6, 7, 5, 6, 5, 6, 7, 7, 5, 7, 6, 6, 6, 6
    .byte 6, 6, 7, 5, 6, 7, 7, 6, 3, 6, 7, 7, 7, 6, 7
    .byte 7, 7, 6, 6, 6, 7, 6, 6, 7, 8, 6, 7, 6, 6, 5, 7
    .byte 7, 7, 7, 6, 7, 5, 8, 6, 5, 6, 6, 7, 6, 7, 4, 5
    .byte 6, 6, 7, 7, 5, 7, 7, 7, 6, 6, 5, 6, 7, 7, 6
    .byte 7, 8, 5, 5, 7, 7, 6, 6, 6, 4, 7, 7, 7, 6, 7, 6
    .byte 6, 7, 6, 5, 6, 6, 7, 7, 7, 6, 7, 6, 6, 6, 6
    .byte 7, 7, 6, 5, 7, 5, 5, 7, 5, 7, 7, 7, 6, 8, 7, 6
    .byte 7, 6, 6, 6, 7, 7, 6, 6, 6, 7, 6, 7, 6, 7, 5
    .byte 7, 6, 6, 4, 7, 7, 7, 5, 6, 8, 7, 6, 7, 7, 7, 4
    .byte 6, 7, 8, 8, 7, 6, 7, 7, 7, 6, 6, 4, 7, 5, 6, 7
    .byte 6, 6, 7, 6, 7, 6, 7, 4, 6, 7, 7, 7, 7, 7, 6
    .byte 7, 4, 7, 6, 6, 7, 6, 6, 7, 6, 7, 6, 5, 7, 7
    .byte 7, 7, 6, 7, 6, 7, 7, 5, 7, 7, 5, 4, 8, 7, 5, 6
    .byte 6, 6, 7, 6, 6, 6, 6, 8, 7, 7, 7, 7, 5, 5, 7, 6
    .byte 6, 6, 5, 6, 7, 5, 7, 5, 8, 7, 5, 8, 6, 6, 4, 6
    .byte 6, 6, 7, 7, 6, 6, 5, 8, 6, 7, 5, 7, 7, 7, 7, 7
    .byte 7, 5, 7, 6, 7, 7, 5, 7, 6, 6, 7, 6, 6, 7, 6
    .byte 6, 6, 7, 7, 7, 6, 6, 6, 7, 6, 7, 7, 6, 7, 5
    .byte 6, 7, 7, 5, 6, 6, 7, 6, 5, 6, 6, 6, 7, 7, 6
    .byte 6, 7, 4, 5, 6, 6, 6, 6, 7, 6, 7, 7, 6, 5, 7
    .byte 6, 4, 5, 6, 6, 7, 5, 7, 7, 7, 7, 6, 7, 5, 5
    .byte 7, 7, 7, 7, 7, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6
    .byte 6, 7, 6, 7, 6, 7, 7, 7, 7, 6, 6, 6, 6, 7, 6
    .byte 7, 7, 7, 8, 6, 5, 7, 6, 7, 6, 6, 5, 7, 6, 7, 5
    .byte 6, 5, 7, 7, 4, 6, 5, 6, 6, 7, 7, 4, 8, 7, 6, 7
    .byte 7, 4, 4, 6, 7, 7, 7, 5, 5, 6, 8, 7, 7, 7, 7, 7
    .byte 5, 6, 6, 5, 8, 5, 7, 7, 7, 6, 7, 5, 7, 6, 6, 6
    .byte 6, 5, 6, 6, 7, 5, 7, 6, 6, 6, 6, 7, 6, 6, 4
    .byte 8, 7, 7, 7, 7, 7, 6, 6, 6, 6, 5, 7, 7, 7, 6, 7
    .byte 5, 7, 6, 6, 6, 5, 5, 6, 6, 7, 6, 6, 7, 7, 7
    .byte 6, 7, 5, 6, 7, 3, 6, 5, 5, 7, 7, 6, 7, 7, 7
    .byte 6, 7, 7, 6, 7, 7, 7, 7, 7, 7, 6, 6, 7, 6, 7
    .byte 8, 5, 7, 6, 5, 5, 7, 5, 5, 6, 7, 7, 7, 7, 7, 6
    .byte 7, 7, 7, 6, 7, 6, 7, 7, 8, 7, 3, 7, 7, 7, 7, 6
    .byte 6, 8, 6, 7, 6, 7, 7, 6, 7, 5, 7, 5, 3, 5, 6, 7
    .byte 5, 6, 7, 7, 5, 7, 6, 7, 5, 6, 6, 7, 6, 6, 5
    .byte 6, 7, 7, 7, 7, 7, 5, 7, 6, 6, 5, 7, 7, 7, 7
    .byte 7, 5, 6, 7, 7, 6, 4, 8, 6, 7, 6, 7, 6, 7, 8, 7
    .byte 8, 6, 6, 7, 6, 7, 5, 7, 7, 7, 7, 6, 7, 6, 5, 7
    .byte 6, 6, 7, 7, 6, 6, 7, 6, 6, 6, 4, 7, 7, 6, 6
    .byte 6, 7, 5, 7, 5, 6, 7, 6, 5, 6, 7, 6, 5, 5, 6
    .byte 6, 6, 6, 6, 6, 6, 7, 7, 6, 7, 7, 7, 7, 7, 7
    .byte 6, 6, 5, 6, 7, 7, 6, 7, 8, 4, 5, 7, 6, 7, 6, 6
    .byte 7, 7, 8, 7, 7, 6, 6, 6, 6, 7, 6, 6, 6, 7, 7, 5
    .byte 7, 7, 7, 7, 7, 5, 7, 4, 5, 6, 5, 6, 7, 7, 4
    .byte 6, 7, 7, 6, 7, 6, 6, 6, 6, 7, 7, 7, 3, 5, 6
    .byte 5, 7, 7, 4, 6, 7, 6, 4, 6, 6, 7, 7, 7, 7, 5
    .byte 7, 8, 6, 6, 5, 7, 6, 7, 7, 7, 6, 5, 7, 6, 6, 6
    .byte 7, 7, 7, 7, 7, 7, 7, 7, 6, 7, 6, 6, 7, 7, 7
    .byte 7, 7, 7, 6, 7, 6, 7, 8, 6, 7, 6, 6, 5, 6, 5, 7
    .byte 7, 6, 6, 5, 7, 6, 7, 6, 6, 7, 6, 8, 4, 6, 7, 7
    .byte 5, 5, 7, 7, 5, 7, 6, 7, 6, 7, 6, 5, 6, 6, 7
    .byte 7, 6, 7, 7, 7, 7, 6, 6, 6, 6, 7, 6, 7, 5, 7
    .byte 6, 6, 6, 5, 5, 7, 6, 6, 6, 7, 7, 7, 7, 6, 6
    .byte 6, 7, 7, 7, 6, 6, 6, 6, 6, 7, 6, 6, 8, 7, 6, 7
    .byte 5, 7, 4, 4, 8, 7, 6, 6, 6, 5, 7, 6, 6, 5, 8, 7
    .byte 6, 7, 7, 6, 5, 5, 6, 5, 7, 6, 6, 7, 7, 6, 6
    .byte 6, 6, 6, 6, 7, 6, 6, 8, 7, 7, 7, 6, 6, 5, 7, 6
    .byte 6, 7, 7, 7, 5, 7, 6, 6, 6, 7, 7, 6, 6, 7, 7
    .byte 7, 7, 4, 7, 7, 7, 6, 5, 6, 6, 7, 6, 6, 7, 6
    .byte 7, 7, 6, 6, 4, 6, 6, 6, 6, 6, 5, 6, 6, 7, 5
    .byte 7, 6, 7, 6, 7, 7, 6, 7, 6, 5, 4, 6, 5, 6, 7
    .byte 6, 6, 6, 6, 5, 7, 7, 7, 7, 7, 6, 7, 7, 7, 7
    .byte 7, 6, 7, 6, 7, 6, 7, 6, 7, 7, 6, 8, 6, 4, 6, 6
    .byte 6, 6, 5, 6, 6, 6, 7, 6, 8, 6, 6, 6, 6, 6, 6, 7
    .byte 7, 7, 7, 5, 7, 6, 6, 7, 6, 7, 5, 6, 3, 7, 7
    .byte 6, 7, 6, 6, 6, 7, 7, 4, 5, 6, 5, 8, 6, 6, 6, 8
    .byte 5, 5, 6, 6, 5, 7, 6, 5, 7, 6, 6, 6, 7, 6, 6
    .byte 7, 7, 7, 7, 6, 6, 6, 7, 7, 6, 7, 4, 7, 7, 6
    .byte 7, 4, 6, 6, 5, 5, 6, 7, 7, 7, 8, 7, 7, 7, 7, 5
    .byte 5, 7, 7, 7, 6, 6, 6, 7, 5, 6, 7, 6, 7, 5, 5
    .byte 4, 7, 5, 7, 6, 8, 7, 5, 7, 5, 6, 7, 6, 6, 4, 7
    .byte 6, 6, 6, 7, 6, 5, 7, 7, 6, 5, 6, 5, 6, 7, 7
    .byte 7, 7, 6, 6, 7, 7, 6, 7, 7, 7, 6, 5, 6, 6, 5
    .byte 7, 7, 6, 6, 7, 7, 5, 5, 6, 6, 6, 6, 7, 8, 7, 6
    .byte 7, 7, 6, 7, 7, 7, 6, 7, 5, 7, 7, 4, 6, 7, 5
    .byte 7, 7, 6, 5, 5, 6, 7, 5, 6, 7, 6, 7, 7, 7, 7
    .byte 6, 7, 3, 6, 6, 7, 6, 7, 7, 5, 6, 6, 6, 6, 4
    .byte 6, 5, 6, 6, 8, 7, 6, 7, 6, 7, 7, 6, 6, 6, 6, 6
    .byte 7, 6, 6, 7, 6, 7, 6, 7, 5, 6, 7, 7, 6, 5, 6
    .byte 7, 7, 7, 5, 7, 8, 7, 7, 6, 6, 7, 6, 7, 7, 7, 4
    .byte 7, 7, 7, 7, 7, 7, 7, 7, 5, 5, 6, 6, 7, 6, 6
    .byte 7, 7, 5, 6, 5, 6, 6, 6, 6, 7, 6, 7, 5, 7, 6
    .byte 7, 6, 6, 4, 6, 6, 6, 6, 7, 7, 6, 7, 7, 5, 6
    .byte 6, 6, 5, 5, 7, 8, 7, 6, 7, 6, 7, 7, 6, 7, 6, 6
    .byte 7, 6, 5, 7, 7, 7, 6, 7, 7, 6, 5, 7, 7, 7, 5
    .byte 7, 6, 7, 4, 6, 7, 7, 7, 7, 7, 7, 7, 7, 6, 7
    .byte 4, 7, 6, 7, 7, 6, 7, 6, 7, 7, 6, 7, 4, 6, 7
    .byte 7, 6, 5, 6, 7, 5, 8, 6, 5, 5, 6, 7, 6, 6, 6, 7
    .byte 6, 4, 8, 6, 7, 7, 6, 7, 4, 7, 7, 7, 6, 7, 8, 7
    .byte 7, 7, 7, 7, 7, 6, 6, 6, 7, 7, 8, 6, 7, 7, 7, 7
    .byte 6, 5, 6, 6, 6, 4, 5, 7, 7, 6, 7, 7, 7, 6, 7
    .byte 7, 6, 5, 6, 7, 6, 7, 7, 7, 7, 7, 7, 5, 6, 5
    .byte 6, 7, 6, 6, 6, 7, 5, 6, 7, 7, 5, 5, 7, 7, 5
    .byte 7, 7, 6, 6, 7, 6, 5, 7, 6, 6, 5, 6, 6, 7, 7
    .byte 7, 7, 6, 7, 6, 7, 6, 7, 6, 7, 7, 6, 6, 7, 8, 7
    .byte 7, 7, 7, 6, 7, 7, 7, 6, 7, 6, 7, 3, 6, 7, 6
    .byte 7, 8, 7, 6, 7, 7, 5, 6, 5, 6, 6, 7, 6, 7, 6, 5
    .byte 6, 6, 6, 6, 5, 5, 7, 7, 6, 6, 7, 7, 6, 7, 7
    .byte 5, 5, 6, 6, 7, 7, 5, 6, 6, 5, 7, 5, 7, 7, 6
    .byte 6, 5, 7, 7, 7, 5, 7, 7, 7, 7, 6, 7, 6, 7, 6
    .byte 6, 6, 7, 7, 8, 6, 7, 6, 6, 7, 6, 6, 7, 7, 6, 4
    .byte 5, 6, 7, 7, 7, 6, 8, 7, 7, 6, 6, 4, 6, 6, 7, 6
    .byte 7, 7, 7, 6, 7, 6, 6, 5, 5, 7, 7, 6, 6, 7, 6
    .byte 6, 7, 6, 4, 6, 6, 4, 7, 7, 7, 5, 7, 7, 7, 6
    .byte 7, 7, 4, 7, 7, 5, 7, 6, 5, 7, 5, 7, 7, 6, 6
    .byte 7, 8, 7, 7, 7, 6, 7, 7, 6, 8, 6, 7, 4, 7, 7, 5
    .byte 6, 7, 6, 7, 6, 5, 7, 7, 7, 7, 8, 7, 8, 6, 7, 5
    .byte 7, 7, 6, 6, 7, 5, 7, 6, 6, 7, 7, 6, 7, 6, 6
    .byte 5, 4, 6, 6, 6, 6, 6, 6, 7, 6, 6, 5, 7, 7, 6
    .byte 6, 7, 7, 6, 5, 7, 6, 7, 6, 7, 6, 6, 4, 6, 7
    .byte 6, 7, 6, 7, 6, 7, 7, 7, 5, 7, 7, 7, 7, 8, 5, 7
    .byte 5, 5, 5, 5, 5, 8, 7, 6, 6, 7, 7, 7, 7, 7, 7, 6
    .byte 7, 8, 6, 6, 7, 5, 6, 6, 8, 7, 5, 7, 7, 5, 7, 5
    .byte 5, 5, 6, 5, 3, 6, 7, 7, 6, 7, 7, 7, 6, 6, 6
    .byte 6, 7, 5, 7, 7, 6, 7, 6, 7, 7, 7, 6, 7, 7, 5
    .byte 6, 6, 5, 7, 6, 7, 6, 6, 7, 7, 7, 7, 6, 5, 6
    .byte 7, 7, 7, 7, 7, 6, 5, 6, 6, 6, 6, 6, 5, 4, 7
    .byte 6, 8, 6, 7, 7, 8, 6, 5, 6, 7, 7, 5, 6, 7, 7, 6
    .byte 4, 6, 7, 6, 7, 7, 4, 7, 6, 6, 5
    .byte 4, 6, 6, 6, 7, 7, 7, 5, 6, 7, 6, 5, 7, 7, 7
    .byte 7, 5, 7, 6, 7, 7, 7, 6, 7, 5, 6, 7, 6, 6, 8, 5
    .byte 7, 7, 8, 7, 7, 6, 7, 6, 6, 7, 6, 7, 7, 5, 6, 6
    .byte 7, 5, 5, 6, 7, 6, 6, 7, 6, 8, 7, 6, 7, 7, 7, 7
    .byte 6, 5, 6, 6, 6, 7, 6, 7, 7, 6, 7, 7, 4, 5, 5
    .byte 6, 5, 4, 5, 6, 7, 6, 5, 7, 7, 6, 6, 6, 7, 6
    .byte 7, 4, 7, 7, 7, 7, 6, 7, 5, 6, 7, 6, 4, 8, 7, 6
    .byte 6, 7, 7, 7, 6, 7, 6, 7, 6, 7, 6, 7, 8, 7, 7, 5
    .byte 6, 7, 6, 7, 5, 5, 7, 7, 6, 7, 7, 7, 7, 6, 6
    .byte 7, 7, 6, 6, 7, 7, 6, 6, 7, 6, 6, 7, 6, 6, 6
    .byte 6, 4, 7, 5, 6, 7, 6, 6, 5, 7, 6, 4, 6, 7, 7
    .byte 7, 6, 6, 7, 6, 7, 5, 6, 6, 7, 7, 6, 7, 7, 5
    .byte 5, 6, 6, 7, 7, 8, 7, 6, 7, 5, 7, 7, 6, 5, 7, 7
    .byte 7, 7, 8, 7, 5, 5, 7, 7, 6, 6, 7, 7, 6, 7, 5, 7
    .byte 7, 7, 7, 6, 7, 6, 5, 6, 6, 6, 6, 6, 7, 7, 6
    .byte 5, 7, 6, 6, 4, 6, 6, 7, 6, 6, 6, 7, 7, 4, 7
    .byte 6, 6, 5, 5, 6, 6, 6, 6, 7, 7, 6, 5, 7, 6, 7
    .byte 5, 7, 5, 6, 5, 7, 7, 6, 7, 7, 7, 8, 6, 6, 6, 6
    .byte 6, 6, 7, 7, 6, 7, 7, 6, 7, 5, 4, 6, 6, 6, 6
    .byte 5, 6, 6, 7, 7, 7, 6, 7, 7, 7, 7, 7, 5, 6, 4
    .byte 7, 7, 7, 6, 7, 4, 7, 6, 5, 5, 6, 6, 6, 7, 7
    .byte 6, 6, 5, 7, 6, 8, 4, 5, 4, 7, 7, 6, 6, 8, 6, 6
    .byte 5, 7, 7, 7, 4, 7, 7, 7, 7, 6, 7, 7, 7, 7, 7
    .byte 6, 5, 7, 7, 7, 6, 4, 7, 7, 7, 7, 7, 8, 6, 6, 6
    .byte 7, 4, 7, 6, 6, 7, 6, 6, 7, 7, 7, 8, 7, 6, 5, 6
    .byte 5, 6, 7, 6, 6, 6, 7, 6, 7, 8, 6, 7, 6, 4, 7, 7
    .byte 5, 5, 7, 7, 6, 6, 6, 6, 5, 6, 3, 6, 6, 7, 6
    .byte 7, 8, 7, 7, 7, 7, 3, 6, 7, 6, 8, 6, 6, 7, 6, 7
    .byte 8, 7, 7, 6, 8, 8, 8, 7, 6, 7, 7, 6, 8, 6, 8, 5
    .byte 7, 7
    .byte 5, 6, 6, 7, 8, 6, 6, 7, 8, 6, 7, 7, 7, 8, 6, 8
    .byte 6
    .byte 7, 7, 5, 7, 7, 6, 6, 6, 5, 7, 7, 6, 6, 6, 6
    .byte 5, 5, 6, 7, 6, 5, 6, 6, 8, 6, 6, 5, 5, 7, 5, 8
    .byte 7, 6, 7, 6, 7, 6, 7, 6, 7, 7, 5, 7, 7, 5, 6
    .byte 7, 7, 6, 6, 7, 6, 7, 7, 6, 5, 7, 7, 7, 7, 8, 7
    .byte 5, 6, 5, 6, 6, 7, 7, 5, 5, 7, 6, 8, 5, 7, 7, 7
    .byte 7, 6, 7, 7, 7, 6, 6, 6, 7, 5, 5, 6, 6, 7, 6
    .byte 7, 4, 7, 5, 6, 5, 5, 6, 6, 6, 7, 6, 7, 5, 5
    .byte 6, 7, 6, 7, 6, 7, 7, 5, 7, 6, 7, 6, 6, 6, 7
    .byte 6, 6, 7, 7, 6, 7, 6, 7, 7, 7, 7, 7, 7, 7, 6
    .byte 7, 6, 7, 7, 6, 6, 7, 6, 6, 4, 6, 7, 8, 7, 7, 7
    .byte 6, 7, 6, 6, 7, 8, 7, 6, 7, 6, 6, 6, 6, 6, 6, 7
    .byte 6, 6, 6, 6, 5, 5, 6, 5, 6, 5, 6, 6, 7, 5, 5
    .byte 7, 8, 5, 4, 6, 7, 6, 6, 7, 7, 7, 6, 7, 6, 6, 6
    .byte 7, 6, 6, 5, 6, 6, 6, 7, 7, 7, 7, 7, 7, 6, 6
    .byte 7, 7, 6, 7, 8, 6, 6, 5, 6, 6, 4, 5, 7, 7, 6, 7
    .byte 7, 7, 7, 7, 6, 6, 5, 7, 7, 5, 6, 7, 6, 6, 7
    .byte 7, 6, 5, 6, 6, 6, 7, 6, 5, 6, 7, 4, 4, 6, 7
    .byte 6, 5, 7, 7, 7, 6, 6, 6, 7, 7, 6, 7, 4, 6, 6
    .byte 7, 7, 6, 8, 6, 6, 7, 7, 4, 7, 7, 7, 6, 7, 7, 7
    .byte 6, 7, 7, 7, 5, 7, 5, 8, 7, 6, 6, 4, 7, 6, 7, 7
    .byte 6, 5, 6, 6, 7, 7, 7, 6, 8, 7, 6, 6, 7, 6, 6, 6
    .byte 6, 6, 7, 8, 5, 7, 6, 7, 6, 5, 5, 5, 7, 6, 6, 6
    .byte 6, 5, 5, 8, 7, 5, 5, 6, 6, 7, 5, 6, 7, 6, 7, 6
    .byte 5, 6, 7, 6, 5, 7, 6, 5, 6, 7, 8, 7, 7, 7, 7, 8
    .byte 7, 5, 7, 7, 7, 6, 6, 8, 6, 6, 7, 6, 7, 5, 5, 6
    .byte 7, 6, 6, 4, 6, 6, 6, 7, 7, 6, 8, 7, 6, 6, 7, 6
    .byte 7, 5, 7, 6, 7, 6, 6, 5, 7, 6, 5, 6, 7, 6, 6
    .byte 6, 7, 6, 6, 6, 6, 6, 7, 4, 6, 5, 7, 6, 7, 7
    .byte 8, 6, 6, 6, 7, 7, 7, 5, 7, 7, 6, 6, 6, 7, 7, 7
    .byte 7, 7, 7, 4, 7, 7, 7, 7, 5, 7, 7, 7, 8, 6, 7, 6
    .byte 7, 6, 7, 5, 7, 6, 5, 6, 6, 7, 8, 7, 7, 7, 6, 5
    .byte 5, 6, 5, 7, 6, 6, 7, 7, 6, 5, 6, 7, 6, 7, 5
    .byte 3, 7, 7, 5, 5, 7, 6, 7, 7, 7, 6, 5, 5, 7, 6
    .byte 6, 7, 6, 7, 7, 4, 6, 7, 6, 7, 6, 7, 6, 6, 4
    .byte 6, 6, 7, 7, 7, 7, 7, 6, 6, 6, 6, 6, 6, 7, 7
    .byte 7, 7, 7, 7, 5, 5, 6, 7, 6, 6, 7, 7, 5, 6, 6
    .byte 7, 7, 7, 7, 6, 6, 7, 6, 6, 6, 5, 5, 7, 6, 7
    .byte 6, 5, 7, 7, 6, 5, 5, 5, 7, 7, 6, 7, 7, 7, 5
    .byte 7, 5, 6, 5, 5, 5, 6, 6, 6, 5, 5, 6, 7, 8, 7, 7
    .byte 6, 7, 7, 5, 7, 6, 7, 7, 7, 6, 6, 6, 6, 6, 6
    .byte 7, 5, 7, 6, 6, 6, 6, 7, 6, 7, 7, 7, 6, 6, 7
    .byte 7, 7, 7, 5, 7, 7, 6, 8, 6, 7, 6, 7, 6, 6, 6, 6
    .byte 6, 7, 6, 6, 7, 8, 6, 7, 5, 6, 2, 7, 6, 6, 6, 6
    .byte 7, 5, 7, 7, 6, 6, 6, 5, 7, 6, 5, 6, 7, 5, 7
    .byte 6, 7, 8, 8, 7, 7, 5, 6, 7, 5, 6, 6, 7, 6, 5, 7
    .byte 7, 6, 5, 6, 7, 6, 7, 5, 6, 7, 6, 6, 6, 7, 7
    .byte 7, 6, 6, 7, 7, 8, 7, 7, 6, 7, 6, 6, 7, 7, 6, 5
    .byte 7, 6, 6, 6, 6, 7, 7, 6, 6, 7, 7, 6, 3, 5, 7
    .byte 6, 7, 7, 8, 5, 7, 7, 5, 6, 7, 7, 6, 6, 6, 6, 6
    .byte 6, 6, 6, 7, 7, 7, 7, 6, 6, 8, 5, 7, 6, 6, 6, 7
    .byte 7, 5, 6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 7, 7, 5
    .byte 7, 7, 6, 5, 7, 7, 8, 7, 7, 6, 7, 7, 7, 8, 5, 6
    .byte 6, 7, 5, 6, 6, 5, 6, 7, 6, 6, 7, 7, 6, 7, 5
    .byte 5, 3, 7, 6, 5, 6, 7, 7, 4, 7, 8, 7, 5, 7, 6, 7
    .byte 6, 6, 6, 7, 6, 7, 6, 7, 7, 8, 7, 7, 6, 6, 7, 4
    .byte 7, 7, 7, 5, 6, 7, 7, 5, 6, 6, 6, 7, 6, 6, 7
    .byte 6, 6, 6, 6, 7, 6, 6, 7, 6, 7, 7, 7, 6, 6, 6
    .byte 7, 6, 7, 7, 7, 7, 6, 6, 6, 7, 6, 6, 7, 7, 5
    .byte 5, 7, 7, 5, 3, 4, 7, 6, 7, 7, 7, 6, 7, 7, 5
    .byte 5, 6, 7, 7, 6, 6, 6, 6, 6, 7, 6, 6, 6, 7, 7
    .byte 7, 7, 5, 7, 7, 7, 5, 6, 6, 6, 7, 6, 6, 6, 7
    .byte 6, 7, 5, 5, 6, 7, 7, 6, 6, 7, 6, 7, 7, 7, 6
    .byte 7, 6, 6, 6, 6, 7, 7, 7, 8, 6, 7, 6, 6, 5, 5, 6
    .byte 6, 7, 6, 5, 7, 7, 7, 4, 5, 6, 7, 7, 6, 5, 6
    .byte 7, 7, 6, 6, 6, 5, 5, 6, 6, 7, 6, 5, 7, 6, 5
    .byte 6, 7, 7, 5, 7, 6, 7, 7, 7, 7, 7, 6, 6, 6, 7
    .byte 5, 7, 7, 7, 6, 5, 5, 6, 6, 5, 8, 7, 6, 6, 6, 7
    .byte 6, 7, 7, 6, 7, 6, 7, 7, 6, 6, 7, 7, 7, 7, 7
    .byte 7, 5, 7, 6, 5, 7, 6, 5, 7, 6, 6, 5, 6, 6, 3
    .byte 7, 7, 7, 7, 6, 7, 6, 7, 7, 6, 7, 5, 6, 6, 6
    .byte 6, 7, 5, 7, 7, 5, 7, 7, 6, 7, 6, 7, 6, 7, 6
    .byte 6, 5, 5, 6, 7, 6, 6, 5, 7, 6, 5, 5, 5, 7, 6
    .byte 6, 7, 6, 5, 7, 7, 6, 7, 7, 8, 7, 7, 7, 6, 6, 7
    .byte 7, 6, 7, 6, 7, 6, 5, 5, 6, 6, 6, 7, 5, 6, 7
    .byte 4, 6, 6, 7, 4, 4, 7, 7, 6, 4, 7, 7, 6, 7, 7
    .byte 6, 6, 5, 4, 8, 7, 8, 7, 7, 8, 7, 7, 7, 7, 6, 6
    .byte 7
    .byte 6, 8, 7, 7, 6, 5, 7, 7, 6, 6, 5, 7, 7, 8, 5, 7
    .byte 7, 7, 6, 7, 7, 7, 7, 7, 7, 8, 7, 6, 7, 6, 7, 6
    .byte 7, 7, 7, 8, 7, 7, 6, 5, 7, 7, 5, 7, 7, 6, 6, 7
    .byte 7, 5, 6, 6, 6, 6, 5, 6, 7, 7, 7, 7, 6, 6, 7
    .byte 6, 7, 6, 6, 6, 7, 7, 6, 7, 7, 7, 5, 5, 6, 6
    .byte 6, 7, 7, 7, 6, 7, 7, 6, 7, 7, 6, 5, 7, 5, 6
    .byte 6, 5, 5, 6, 7, 5, 7, 7, 7, 6, 6, 7, 6, 8, 5, 7
    .byte 7, 7, 7, 7, 6, 7, 7, 6, 6, 6, 7, 6, 7, 7, 7
    .byte 7, 5, 7, 5, 6, 6, 4, 6, 6, 7, 7, 4, 7, 7, 4
    .byte 7, 7, 5, 4, 6, 7, 7, 8, 6, 6, 8, 7, 6, 8, 6, 7
    .byte 4
    .byte 7, 7, 7, 7, 7, 8, 6, 7, 7, 6, 5, 7, 6, 7, 5, 6
    .byte 7, 6, 5, 5, 6, 6, 7, 6, 7, 6, 7, 5, 7, 8, 7, 7
    .byte 7, 7, 7, 7, 8, 7, 6, 7, 6, 7, 7, 7, 7, 7, 7, 6
    .byte 7, 6, 5, 7, 6, 7, 6, 5, 6, 6, 8, 5, 6, 6, 6, 5
    .byte 7, 7, 6, 6, 7, 6, 6, 7, 7, 7, 6, 7, 7, 6, 7
    .byte 6, 6, 6, 7, 5, 7, 7, 7, 7, 7, 7, 5, 7, 6, 6
    .byte 7, 6, 7, 6, 6, 6, 7, 6, 4, 6, 7, 7, 7, 6, 6
    .byte 6, 6, 6, 7, 7, 6, 7, 7, 6, 6, 7, 7, 7, 7, 6
    .byte 7, 7, 7, 6, 6, 8, 5, 5, 6, 5, 6, 6, 7, 6, 4, 7
    .byte 7, 7, 7, 6, 6, 6, 8, 7, 5, 6, 6, 6, 6, 8, 6, 8
    .byte 7
    .byte 6, 8, 7, 6, 6, 6, 8, 6, 6, 5, 6, 6, 7, 7, 6, 6
    .byte 6, 6, 7, 6, 6, 6, 6, 5, 6, 5, 6, 6, 6, 7, 6
    .byte 6, 6, 8, 7, 6, 7, 7, 7, 7, 7, 7, 5, 7, 7, 7
    .byte 6, 6, 6, 8, 7, 6, 8, 6, 6, 7, 6, 6, 6, 5, 3, 5
    .byte 6, 7, 6, 7, 6, 6, 5, 7, 7, 7, 5, 4, 6, 7, 7
    .byte 5, 6, 6, 6, 7, 6, 7, 7, 7, 6, 5, 7, 6, 6, 7
    .byte 6, 6, 7, 7, 4, 5, 6, 7, 7, 6, 6, 6, 6, 6, 7
    .byte 6, 6, 5, 6, 6, 6, 6, 7, 6, 7, 7, 7, 5, 7, 6
    .byte 7, 7, 7, 7, 7, 6, 7, 7, 7, 6, 6, 6, 6, 7, 7
    .byte 6, 6, 5, 7, 6, 6, 4, 5, 5, 6, 7, 7, 5, 7, 7
    .byte 7, 6, 7, 6, 5, 6, 7, 6, 6, 6, 6, 6, 8, 6, 6, 7
    .byte 6, 7, 6, 7, 7, 7, 7, 6, 6, 4, 6, 5, 7, 7, 6
    .byte 6, 7, 7, 6, 6, 6, 6, 5, 6, 7, 7, 6, 7, 7, 7
    .byte 7, 7, 7, 7, 7, 7, 7, 6, 8, 6, 6, 7, 7, 7, 6, 6
    .byte 6, 6, 6, 6, 7, 6, 6, 6, 5, 5, 5, 6, 4, 5, 6
    .byte 7, 6, 5, 8, 7, 7, 6, 7, 5, 6, 5, 3, 8, 8, 7, 7
    .byte 7
    .byte 7, 7, 7, 8, 7, 7, 7, 8, 7, 8, 7, 8, 6, 4, 7, 7
    .byte 7
    .byte 6, 6, 7, 7, 7, 6, 7, 7, 6, 6, 6, 7, 8, 8, 7, 8
    .byte 7
    .byte 7, 7, 7, 7, 8, 7, 7, 7, 7, 8, 6, 8, 7, 6, 7, 7
    .byte 6
    .byte 6, 8, 7, 6, 7, 7, 6, 6, 6, 7, 6, 4, 6, 6, 8, 8
    .byte 8
    .byte 7, 7, 7, 6, 6, 7, 6, 7, 6, 6, 6, 6, 7, 6, 7
    .byte 6, 7, 5, 6, 6, 7, 6, 7, 8, 6, 6, 5, 5, 6, 6, 7
    .byte 6, 7, 7, 6, 6, 7, 5, 5, 7, 6, 6, 7, 7, 7, 7
    .byte 7, 7, 5, 6, 6, 6, 6, 6, 7, 6, 7, 7, 7, 7, 6
    .byte 6, 7, 6, 6, 7, 6, 5, 7, 5, 5, 6, 6, 5, 4, 6
    .byte 7, 8, 6, 5, 7, 7, 7, 7, 6, 6, 6, 5, 6, 7, 7, 7
    .byte 6, 7, 6, 6, 6, 7, 7, 6, 7, 7, 7, 6, 7, 6, 6
    .byte 6, 7, 5, 6, 7, 5, 6, 5, 5, 6, 6, 6, 6, 7, 7
    .byte 6, 5, 6, 6, 6, 7, 6, 6, 6, 7, 7, 7, 7, 7, 7
    .byte 6, 7, 6, 6, 7, 7, 6, 7, 7, 4, 7, 6, 6, 6, 5
    .byte 6, 6, 6, 7, 5, 7, 7, 3, 7, 7, 6, 5, 6, 6, 6
    .byte 7, 7, 6, 6, 7, 7, 6, 6, 6, 7, 6, 7, 6, 7, 7
    .byte 7, 7, 6, 7, 4, 7, 7, 6, 7, 7, 7, 5, 6, 6, 7
    .byte 6, 5, 6, 7, 7, 6, 5, 6, 6, 7, 7, 6, 6, 6, 6
    .byte 6, 6, 7, 6, 7, 7, 7, 7, 6, 7, 7, 7, 6, 7, 5
    .byte 4, 6, 6, 6, 7, 7, 6, 4, 6, 7, 7, 6, 5, 5, 5
    .byte 7, 6, 6, 6, 6, 7, 5, 7, 6, 7, 7, 6, 8, 7, 5, 7
    .byte 7, 7, 7, 7, 6, 5, 7, 7, 7, 7, 6, 7, 6, 8, 7, 6
    .byte 6, 5, 5, 5, 5, 6, 7, 6, 6, 6, 6, 6, 7, 8, 7, 6
    .byte 7, 7, 8, 7, 6, 5, 7, 7, 8, 7, 6, 5, 7, 6, 5, 7
    .byte 7, 5, 6, 6, 5, 7, 6, 4, 5, 7, 7, 5, 7, 6, 5
    .byte 5, 7, 7, 6, 6, 5, 6, 7, 7, 5, 6, 7, 7, 7, 7
    .byte 6, 7, 4, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6
    .byte 7, 7, 6, 7, 6, 5, 5, 6, 6, 7, 7, 7, 6, 7, 7
    .byte 5, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 7, 7, 6, 8, 7
    .byte 7, 7, 6, 6, 7, 7, 7, 5, 6, 6, 7, 7, 5, 7, 7
    .byte 8, 5, 6, 5, 6, 5, 6, 7, 6, 5, 6, 7, 6, 7, 7, 6
    .byte 8, 7, 7, 7, 5, 7, 3, 7, 7, 6, 7, 6, 7, 6, 7, 6
    .byte 6, 5, 8, 6, 7, 6, 5, 6, 7, 6, 5, 6, 6, 6, 6, 7
    .byte 5, 7, 5, 7, 7, 7, 7, 6, 6, 7, 6, 7, 6, 7, 7
    .byte 6, 7, 6, 6, 8, 6, 6, 7, 7, 7, 4, 7, 6, 7, 5, 6
    .byte 6, 6, 7, 5, 7, 6, 7, 6, 7, 7, 7, 6, 6, 5, 6
    .byte 6, 6, 5, 7, 8, 6, 7, 7, 6, 6, 4, 7, 6, 5, 7, 6
    .byte 7, 7, 7, 7, 6, 8, 8, 6, 6, 6, 6, 7, 7, 5, 6, 6
    .byte 6, 5, 7, 7, 7, 6, 6, 7, 6, 7, 5, 6, 7, 7, 6
    .byte 7, 6, 6, 7, 6, 6, 5, 7, 7, 6, 7, 8, 7, 5, 6, 5
    .byte 6, 7, 5, 6, 6, 7, 7, 4, 8, 7, 5, 6, 6, 6, 3, 7
    .byte 6, 7, 7, 6, 6, 7, 7, 7, 5, 7, 6, 5, 5, 7, 5
    .byte 7, 7, 6, 6, 7, 7, 6, 7, 7, 6, 6, 5, 8, 6, 7, 7
    .byte 7, 7, 4, 7, 6, 6, 6, 7, 6, 6, 7, 7, 7, 6, 5
    .byte 8, 7, 6, 7, 7, 7, 6, 6, 5, 7, 7, 7, 6, 6, 7, 4
    .byte 6, 5, 6, 7, 5, 7, 6, 5, 6, 7, 7, 6, 7, 7, 6
    .byte 7, 7, 4, 5, 6, 6, 7, 7, 6, 7, 7, 5, 7, 7, 5
    .byte 6, 6, 7, 6, 6, 5, 6, 6, 7, 7, 5, 6, 6, 7, 6
    .byte 6, 7, 7, 6, 6, 7, 5, 6, 7, 7, 7, 6, 6, 7, 7
    .byte 7, 7, 7, 6, 7, 6, 7, 7, 5, 7, 7, 6, 5, 5, 7
    .byte 7, 7, 7, 7, 7, 6, 6, 5, 6, 6, 5, 4, 6, 7, 6
    .byte 6, 6, 7, 7, 6, 6, 7, 7, 6, 3, 6, 7, 7, 6, 7
    .byte 7, 6, 5, 7, 5, 5, 7, 7, 7, 6, 7, 7, 6, 7, 7
    .byte 7, 7, 6, 7, 6, 7, 5, 6, 6, 7, 6, 5, 6, 7, 7
    .byte 6, 8, 6, 6, 6, 5, 7, 6, 7, 7, 6, 7, 5, 6, 6, 6
    .byte 6, 7, 7, 7, 6, 6, 6, 4, 7, 6, 6, 6, 6, 6, 8, 5
    .byte 7, 5, 7, 6, 4, 7, 7, 7, 7, 6, 6, 5, 7, 6, 7
    .byte 6, 6, 5, 6, 7, 6, 5, 5, 6, 6, 6, 6, 6, 7, 7
    .byte 6, 7, 5, 6, 7, 7, 6, 7, 7, 7, 7, 6, 7, 6, 8, 7
    .byte 7, 6, 6, 7, 7, 6, 5, 6, 6, 6, 6, 7, 6, 6, 7
    .byte 6, 6, 7, 7, 7, 6, 6, 8, 6, 7, 5, 6, 5, 5, 7, 7
    .byte 7, 6, 6, 7, 6, 8, 4, 6, 5, 7, 8, 6, 6, 5, 7, 6
    .byte 5, 7, 7, 6, 4, 6, 6, 6, 6, 6, 4, 6, 7, 6, 7
    .byte 7, 6, 7, 6, 7, 6, 7, 7, 7, 6, 6, 7, 6, 7, 6
    .byte 5, 7, 7, 6, 6, 6, 7, 6, 7, 6, 5, 5, 6, 7, 6
    .byte 6, 6, 7, 7, 7, 6, 7, 7, 6, 7, 7, 7, 6, 7, 5
    .byte 5, 5, 5, 5, 6, 8, 5, 7, 6, 5, 7, 6, 7, 5, 5, 7
    .byte 7, 7, 4, 6, 7, 6, 6, 7, 7, 6, 6, 3, 8, 8, 7, 6
    .byte 6, 7, 7, 7, 6, 7, 5, 6, 7, 7, 7, 7, 7, 6, 6
    .byte 8, 7, 6, 6, 5, 7, 8, 8, 5, 7, 7, 7, 7, 7, 7, 6
    .byte 7
    .byte 7, 7, 7, 6, 6, 6, 6, 6, 7, 7, 6, 7, 7, 7, 7
    .byte 5, 5, 7, 7, 5, 6, 6, 6, 7, 7, 7, 6, 6, 6, 7
    .byte 6, 6, 6, 7, 7, 6, 6, 6, 6, 6, 6, 7, 6, 7, 5
    .byte 7, 6, 5, 6, 7, 4, 6, 7, 8, 7, 7, 8, 7, 5, 5, 6
    .byte 5, 7, 6, 7, 7, 5, 7, 7, 6, 6, 6, 6, 7, 6, 5
    .byte 7, 7, 6, 6, 5, 6, 7, 6, 6, 7, 7, 7, 7, 6, 7
    .byte 6, 7, 7, 7, 6, 7, 6, 5, 7, 6, 6, 5, 7, 7, 7
    .byte 5, 7, 7, 7, 6, 4, 6, 7, 6, 7, 6, 7, 4, 6, 7
    .byte 6, 6, 7, 6, 6, 5, 5, 6, 7, 4, 6, 7, 6, 8, 6, 7
    .byte 7, 6, 7, 6, 6, 6, 7, 7, 7, 6, 7, 7, 5, 7, 7
    .byte 6, 6, 7, 6, 6, 6, 5, 7, 6, 6, 7, 6, 7, 7, 6
    .byte 7, 6, 7, 5, 7, 7, 6, 7, 7, 7, 6, 7, 6, 6, 6
    .byte 7, 5, 6, 6, 5, 7, 8, 6, 6, 6, 7, 3, 7, 7, 7, 7
    .byte 5, 7, 6, 7, 7, 5, 5, 6, 7, 6, 6, 5, 6, 6, 7
    .byte 6, 6, 7, 6, 7, 6, 6, 7, 6, 6, 6, 7, 6, 7, 7
    .byte 6, 7, 6, 6, 7, 6, 6, 6, 7, 7, 6, 7, 7, 6, 7
    .byte 7, 5, 5, 7, 7, 7, 7, 7, 6, 6, 7, 7, 8, 6, 6, 5
    .byte 7, 5, 7, 6, 5, 6, 7, 6, 6, 8, 6, 7, 6, 6, 6, 4
    .byte 7, 6, 6, 6, 7, 6, 5, 7, 7, 6, 4, 6, 5, 7, 6
    .byte 6, 6, 7, 6, 7, 6, 7, 8, 7, 7, 6, 7, 6, 7, 4, 6
    .byte 7, 7, 6, 7, 8, 7, 4, 7, 6, 6, 6, 7, 6, 6, 7, 7
    .byte 6, 5, 6, 6, 5, 7, 7, 7, 7, 8, 7, 5, 7, 7, 6, 7
    .byte 7, 6, 6, 6, 6, 5, 7, 6, 5, 7, 7, 5, 5, 7, 7
    .byte 5, 4, 5, 7, 7, 7, 7, 6, 6, 7, 7, 6, 5, 5, 7
    .byte 2, 7, 8, 7, 7, 6, 7, 7, 7, 7, 6, 7, 6, 7, 7, 7
    .byte 6, 7, 7, 4, 7, 8, 7, 7, 7, 8, 7, 7, 6, 6, 7, 6
    .byte 7, 7, 6, 7, 7, 6, 7, 7, 7, 7, 7, 7, 7, 6, 7
    .byte 7, 7, 7, 6, 7, 7, 6, 7, 6, 5, 5, 8, 6, 6, 6, 6
    .byte 7, 6, 5, 6, 5, 5, 7, 7, 8, 7, 8, 7, 6, 6, 6, 6
    .byte 6, 5, 6, 6, 6, 7, 6, 7, 7, 7, 6, 7, 7, 5, 6
    .byte 6, 7, 8, 7, 7, 5, 6, 5, 7, 7, 7, 7, 7, 7, 7, 7
    .byte 6, 5, 5, 6, 7, 7, 7, 6, 7, 7, 6, 7, 6, 7, 7
    .byte 6, 6, 6, 7, 6, 7, 7, 7, 7, 5, 6, 5, 7, 7, 5
    .byte 7, 6, 6, 6, 6, 6, 6, 7, 5, 6, 6, 7, 5, 6, 7
    .byte 7, 7, 5, 7, 6, 6, 6, 5, 5, 6, 7, 6, 6, 6, 7
    .byte 6, 5, 6, 6, 6, 7, 6, 6, 7, 7, 5, 6, 6, 7, 8, 6
    .byte 7, 7, 6, 7, 6, 6, 5, 6, 6, 6, 6, 7, 7, 6, 7
    .byte 7, 7, 4, 6, 6, 8, 6, 6, 7, 6, 6, 7, 7, 7, 6, 6
    .byte 6, 6, 8, 6, 5, 5, 5, 6, 6, 6, 5, 6, 6, 6, 7, 8
    .byte 5, 6, 6, 7, 6, 7, 7, 5, 6, 7, 6, 6, 5, 6, 5
    .byte 7, 5, 7, 6, 7, 6, 5, 7, 7, 6, 6, 8, 6, 6, 5, 6
    .byte 7, 7, 7, 7, 6, 6, 6, 7, 7, 5, 6, 6, 7, 7, 8, 6
    .byte 7, 7, 6, 6, 6, 6, 7, 7, 6, 5, 7, 7, 6, 6, 7
    .byte 7, 6, 5, 7, 6, 7, 6, 6, 6, 8, 5, 5, 7, 7, 6, 5
    .byte 6, 6, 7, 6, 4, 6, 7, 7, 7, 6, 7, 5, 6, 6, 8, 6
    .byte 6, 7, 7, 5, 6, 6, 7, 6, 7, 6, 5, 7, 6, 6, 7
    .byte 7, 7, 5, 8, 7, 6
    .byte 6, 5, 6, 6, 5, 7, 6, 6, 7, 6, 6, 6, 7, 7, 7
    .byte 7, 7, 8, 7, 6, 5, 4, 7, 6, 7, 6, 6, 6, 7, 6, 6
    .byte 6, 6, 4, 6, 6, 6, 7, 5, 5, 6, 7, 7, 5, 7, 6
    .byte 5, 5, 6, 7, 7, 7, 5, 7, 7, 7, 4, 6, 7, 8, 6, 6
    .byte 6, 6, 7, 5, 7, 6, 7, 7, 7, 6, 6, 6, 4, 6, 6
    .byte 6, 7, 7, 7, 5, 7, 5, 6, 6, 6, 6, 6, 8, 6, 6, 7
    .byte 7, 7, 7, 6, 6, 7, 6, 6, 5, 7, 6, 6, 6, 6, 6
    .byte 5, 7, 7, 8, 5, 7, 4, 4, 6, 6, 6, 7, 8, 6, 5, 7
    .byte 7, 7, 6, 6, 5, 4, 7, 6, 6, 7, 7, 7, 5, 7, 5
    .byte 7, 7, 7, 6, 7, 6, 6, 5, 7, 8, 7, 7, 6, 7, 7, 6
    .byte 6, 6, 6, 7, 6, 7, 7, 6, 6, 6, 6, 7, 6, 6, 7
    .byte 7, 7, 6, 5, 7, 6, 6, 8, 7, 7, 5, 7, 6, 6, 6, 6
    .byte 7, 5, 8, 6, 6, 7, 6, 6, 6, 6, 5, 6, 7, 7, 6, 6
    .byte 7, 6, 7, 7, 6, 7, 6, 4, 6, 6, 7, 5, 6, 7, 5
    .byte 6, 6, 6, 7, 7, 6, 7, 5, 6, 3, 7, 7, 7, 7, 7
    .byte 6, 6, 7, 7, 5, 7, 7, 7, 6, 7, 7, 6, 5, 6, 6
    .byte 6, 7, 7, 7, 5, 7, 7, 6, 7, 7, 6, 7, 7, 6, 6
    .byte 6, 7, 6, 6, 6, 7, 7, 6, 7, 7, 7, 6, 7, 6, 6
    .byte 5, 6, 6, 7, 6, 6, 7, 6, 7, 6, 7, 4, 7, 5, 5
    .byte 7, 5, 5, 6, 7, 6, 6, 6, 7, 7, 6, 6, 7, 6, 6
    .byte 5, 6, 6, 7, 7, 6, 7, 6, 6, 6, 6, 6, 7, 7, 7
    .byte 7, 5, 7, 4, 7, 6, 6, 6, 6, 7, 7, 6, 7, 7, 6
    .byte 6, 7, 6, 6, 6, 7, 8, 6, 6, 6, 6, 6, 7, 7, 6, 7
    .byte 6, 5, 6, 6, 6, 6, 6, 7, 7, 6, 6, 7, 7, 6, 5
    .byte 5, 6, 7, 7, 7, 6, 7, 7, 3, 7, 6, 7, 6, 6, 6
    .byte 7, 6, 5, 6, 4, 7, 6, 7, 7, 6, 7, 6, 6, 7, 6
    .byte 5, 7, 7, 7, 6, 6, 8, 6, 6, 7, 7, 6, 6, 7, 6, 7
    .byte 7, 7, 7, 6, 5, 7, 6, 7, 4, 6, 7, 7, 6, 7, 6
    .byte 7, 6, 6, 7, 7, 7, 6, 5, 7, 7, 6, 5, 6, 7, 7
    .byte 7, 6, 6, 7, 6, 4, 7, 6, 6, 7, 6, 7, 4, 7, 6
    .byte 4, 6, 6, 4, 7, 7, 6, 6, 6, 7, 7, 6, 7, 6, 8, 6
    .byte 6, 6, 7, 5, 7, 8, 6, 7, 8, 7, 7, 5, 7, 5, 5, 7
    .byte 6, 7, 7, 6, 6, 7, 7, 6, 6, 5, 6, 6, 6, 7, 5
    .byte 6, 6, 6, 7, 7, 6, 6, 7, 7, 7, 7, 6, 6, 3, 7
    .byte 7, 6, 7, 6, 5, 6, 7, 6, 4, 6, 6, 7, 8, 7, 6, 7
    .byte 5, 6, 5, 7, 5, 5, 4, 7, 7, 5, 6, 7, 7, 5, 6
    .byte 8, 7, 7, 4, 7, 7, 7, 7, 6, 7, 7, 7, 6, 7, 6, 5
    .byte 6, 7, 7, 6, 5, 7, 6, 7, 6, 7, 7, 7, 7, 7, 7
    .byte 4, 6, 7, 7, 7, 7, 5, 7, 6, 6, 7, 8, 6, 6, 6, 6
    .byte 6, 7, 6, 5, 7, 7, 5, 7, 7, 7, 6, 6, 4, 7, 7
    .byte 6, 6, 7, 7, 6, 5, 5, 7, 6, 6, 6, 6, 7, 6, 5
    .byte 6, 7, 7, 7, 5, 7, 7, 6, 6, 6, 6, 6, 5, 7, 6
    .byte 7, 6, 6, 6, 6, 8, 7, 6, 6, 7, 7, 7, 7, 7, 4, 6
    .byte 6, 6, 5, 6, 6, 7, 6, 6, 6, 6, 7, 6, 8, 7, 7, 6
    .byte 6, 7, 7, 6, 6, 5, 5, 6, 7, 7, 6, 7, 6, 6, 8, 6
    .byte 6, 6, 5, 5, 3, 6, 6, 7, 6, 6, 7, 8, 5, 4, 6, 7
    .byte 7, 6, 7, 7, 7, 6, 7, 7, 5, 7, 7, 5, 7, 6, 6
    .byte 7, 4, 7, 6, 6, 6, 8, 7, 7, 7, 7, 7, 7, 7, 7, 7
    .byte 5, 6, 5, 7, 6, 6, 7, 7, 6, 7, 6, 6, 7, 6, 8, 8
    .byte 8, 6, 7, 6, 6, 6, 6, 6, 7, 6, 7, 5, 7, 6, 7, 6
    .byte 7, 6, 7, 7, 7, 6, 4, 6, 7, 6, 7, 7, 6, 6, 7
    .byte 7, 6, 7, 6, 5, 7, 7, 5, 6, 6, 7, 7, 7, 7, 7
    .byte 7, 6, 7, 7, 6, 7, 6, 6, 5, 6, 7, 6, 7, 7, 6
    .byte 6, 6, 6, 6, 7, 6, 6, 6, 6, 7, 6, 6, 5, 5, 6
    .byte 5, 7, 7, 7, 7, 6, 7, 7, 6, 5, 7, 8, 7, 5, 6, 6
    .byte 8, 6, 5, 5, 8, 7, 6, 8, 5, 7, 5, 5, 6, 4, 7, 7
    .byte 6
    .byte 6, 6, 6, 5, 7, 7, 7, 5, 7, 7, 7, 6, 6, 7, 7
    .byte 7, 7, 7, 6, 7, 5, 6, 7, 7, 5, 7, 5, 7, 7, 7
    .byte 6, 7, 7, 7, 7, 7, 6, 6, 6, 6, 6, 7, 7, 6, 6
    .byte 6, 5, 6, 6, 6, 7, 7, 7, 7, 5, 6, 7, 8, 7, 6, 4
    .byte 6, 6, 7, 7, 7, 6, 7, 5, 7, 7, 5, 6, 6, 6, 4
    .byte 4, 5, 6, 7, 6, 6, 6, 6, 6, 7, 6, 6, 6, 7, 5
    .byte 4, 7, 6, 6, 7, 7, 7, 4, 7, 7, 7, 5, 7, 7, 7
    .byte 8, 7, 6, 7, 7, 6, 5, 6, 7, 7, 7, 7, 7, 7, 6, 7
    .byte 5, 4, 6, 7, 7, 5, 6, 7, 6, 7, 7, 6, 7, 7, 6
    .byte 7, 6, 6, 6, 6, 5, 7, 7, 6, 6, 8, 7, 5, 6, 6, 6
    .byte 7, 6, 7, 6, 7, 4, 6, 7, 6, 5, 6, 6, 6, 6, 5
    .byte 7, 6, 6, 7, 7, 5, 6, 7, 5, 6, 5, 7, 7, 7, 6
    .byte 7, 7, 6, 7, 7, 7, 5, 6, 7, 5, 6, 6, 6, 7, 6
    .byte 6, 7, 7, 4, 8, 6, 7, 6, 6, 6, 6, 5, 6, 7, 7, 6
    .byte 7, 7, 7, 6, 7, 6, 6, 4, 7, 5, 6, 7, 6, 7, 6
    .byte 6, 8, 5, 7, 5, 6, 7, 7, 6, 5, 7, 7, 5, 8, 5, 5
    .byte 5, 6, 6, 7, 7, 6, 7, 6, 7, 5, 7, 6, 6, 6, 6
    .byte 6, 7, 6, 8, 6, 7, 6, 7, 6, 6, 7, 6, 7, 6, 6, 6
    .byte 6, 8, 6, 7, 8, 7, 6, 6, 7, 6, 7, 6, 7, 7, 4, 6
    .byte 7, 6, 7, 7, 7, 7, 6, 7, 5, 6, 6, 5, 6, 7, 5
    .byte 8, 7, 5, 6, 6, 6, 7, 6, 6, 6, 7, 6, 7, 6, 7, 6
    .byte 6, 7, 5, 5, 6, 5, 7, 7, 6, 6, 5, 5, 7, 6, 7
    .byte 7, 6, 7, 6, 7, 7, 6, 4, 7, 6, 8, 8, 6, 7, 5, 7
    .byte 6, 6, 6, 7, 7, 7, 6, 6, 7, 7, 6, 6, 5, 6, 7
    .byte 7, 5, 6, 6, 6, 7, 7, 7, 7, 7, 6, 7, 6, 4, 5
    .byte 7, 6, 5, 6, 8, 7, 7, 6, 6, 7, 6, 4, 7, 7, 6, 7
    .byte 6, 6, 7, 6, 6, 4, 6, 6, 4, 5, 5, 7, 6, 7, 7
    .byte 7, 6, 6, 6, 7, 8, 7, 7, 6, 6, 6, 5, 7, 8, 6, 7
    .byte 6, 6, 7, 7, 8, 7, 7, 6, 5, 7, 5, 7, 6, 5, 7, 6
    .byte 6, 6, 5, 7, 7, 7, 8, 7, 7, 6, 6, 7, 6, 6, 7, 7
    .byte 6, 7, 6, 7, 6, 6, 5, 5, 6, 6, 5, 7, 7, 5, 6
    .byte 7, 6, 6, 6, 5, 5, 6, 5, 6, 6, 7, 6, 6, 5, 8, 5
    .byte 7, 7, 5, 6, 6, 7, 6, 7, 7, 8, 7, 6, 7, 7, 6, 6
    .byte 7, 6, 5, 6, 8, 5, 7, 7, 7, 6, 7, 6, 6, 7, 7, 6
    .byte 5, 7, 6, 7, 6, 7, 7, 6, 5, 8, 7, 7, 5, 7, 7, 7
    .byte 7, 7, 6, 7, 8, 6, 7, 6, 7, 4, 5, 5, 7, 7, 6, 8
    .byte 5, 7, 6, 5, 5, 6, 6, 7, 6, 7, 6, 7, 3, 6, 7
    .byte 7, 6, 7, 7, 7, 6, 7, 7, 3, 6, 6, 7, 7, 7, 7
    .byte 6, 6, 8, 7, 6, 6, 7, 7, 7, 8, 6, 7, 7, 6, 7, 8
    .byte 5
    .byte 7, 6, 7, 6, 6, 6, 6, 7, 7, 6, 7, 7, 7, 7, 7
    .byte 6, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6, 5, 6, 6
    .byte 6, 7, 7, 6, 7, 7, 6, 6, 6, 7, 5, 5, 6, 6, 7
    .byte 6, 6, 5, 6, 7, 7, 7, 7, 7, 7, 7, 6, 5, 7, 6
    .byte 7, 6, 7, 6, 6, 6, 6, 6, 6, 7, 7, 7, 6, 7, 6
    .byte 6, 6, 6, 7, 7, 6, 6, 5, 7, 7, 5, 6, 7, 7, 7
    .byte 7, 7, 6, 7, 7, 7, 5, 6, 6, 7, 5, 6, 7, 7, 6
    .byte 6, 6, 5, 6, 5, 6, 6, 7, 7, 6, 6, 7, 5, 5, 7
    .byte 7, 6, 5, 6, 7, 7, 5, 5, 7, 7, 7, 6, 7, 6, 5
    .byte 6, 8, 7, 7, 6, 7, 7, 6, 5, 7, 7, 7, 6, 7, 7, 8
    .byte 3, 7, 7, 7, 6, 6, 7, 7, 7, 8, 5, 6, 6, 7, 6, 7
    .byte 6, 7, 6, 6, 6, 7, 6, 8, 7, 6, 7, 6, 6, 6, 6, 5
    .byte 6, 7, 6, 7, 7, 7, 4, 6, 7, 6, 7, 5, 4, 6, 7
    .byte 6, 5, 7, 5, 7, 7, 7, 6, 6, 5, 5, 6, 6, 7, 6
    .byte 6, 7, 6, 6, 7, 7, 6, 6, 7, 7, 6, 6, 6, 8, 7, 7
    .byte 7, 7, 7, 7, 6, 7, 6, 7, 7, 6, 7, 7, 5, 7, 7
    .byte 6, 6, 6, 7, 7, 5, 6, 5, 7, 5, 6, 7, 7, 6, 8, 7
    .byte 7, 6, 7, 6, 6, 5, 6, 6, 7, 6, 6, 6, 6, 7, 5
    .byte 6, 7, 6, 7, 7, 6, 5, 6, 7, 6, 6, 6, 4, 7, 6
    .byte 6, 6, 6, 6, 7, 4, 6, 7, 7, 7, 7, 7, 6, 6, 7
    .byte 7, 5, 7, 6, 6, 6, 6, 7, 6, 7, 7, 7, 7, 5, 6
    .byte 6, 7, 8, 5, 6, 5, 7, 6, 6, 7, 6, 6, 5, 5, 7, 6
    .byte 6, 7, 7, 7, 7, 6, 7, 6, 7, 6, 6, 7, 6, 7, 5
    .byte 6, 6, 7, 6, 6, 6, 5, 8, 5, 6, 6, 7, 5, 4, 7, 7
    .byte 6, 4, 7, 6, 7, 7, 7, 6, 7, 6, 4, 6, 7, 7, 8, 6
    .byte 8, 6, 7, 4, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 5, 7
    .byte 6, 7, 7, 7, 7, 8, 7, 6, 5, 7, 6, 7, 6, 7, 6, 5
    .byte 7, 6, 6, 7, 7, 7, 6, 7, 6, 5, 7, 6, 4, 6, 7
    .byte 5, 7, 7, 6, 7, 7, 7, 5, 6, 6, 6, 7, 6, 8, 6, 7
    .byte 5, 6, 5, 6, 6, 5, 8, 6, 8, 8, 4, 6, 4, 7, 6, 7
    .byte 6
    .byte 5, 6, 6, 7, 6, 5, 6, 8, 7, 6, 7, 6, 5, 7, 7, 6
    .byte 6, 6, 6, 7, 7, 6, 7, 6, 6, 7, 7, 7, 7, 7, 7
    .byte 7, 8, 7, 6, 6, 6, 7, 6, 6, 7, 5, 7, 6, 6, 6, 3
    .byte 7, 6, 7, 6, 6, 7, 6, 6, 6, 7, 6, 6, 6, 6, 6
    .byte 7, 7, 6, 5, 7, 7
    .byte 6, 7, 7, 7, 7, 6, 7, 6, 5, 6, 7, 5, 6, 7, 6
    .byte 5, 6, 7, 6, 7, 7, 7, 6, 5, 7, 6, 7, 6, 6, 7
    .byte 5, 7, 5, 6, 7, 7, 6, 6, 6, 7, 7, 6, 6, 7, 7
    .byte 7, 7, 6, 6, 5, 6, 5, 6, 6, 7, 7, 5, 8, 5, 6, 4
    .byte 6, 6, 6, 7, 6, 6, 6, 7, 7, 6, 7, 6, 6, 6, 7
    .byte 4, 6, 6, 7, 7, 7, 7, 7, 7, 6, 8, 7, 6, 7, 6, 6
    .byte 7, 6, 5, 5, 6, 7, 7, 5, 7, 7, 6, 6, 6, 8, 7, 6
    .byte 7, 7, 6, 6, 7, 7, 7, 7, 6, 7, 7, 7, 8, 7, 7, 6
    .byte 7, 7, 7, 4, 7, 7, 7, 5, 6, 6, 6, 6, 6, 7, 6
    .byte 6, 5, 4, 7, 5, 5, 5, 7, 7, 5, 6, 7, 6, 7, 6
    .byte 7, 7, 7, 7, 4, 7, 7, 6, 6, 6, 6, 7, 7, 7, 7
    .byte 7, 6, 5, 6, 7, 5, 6, 5, 7, 7, 7, 7, 7, 8, 7, 6
    .byte 6, 7, 6, 6, 7, 5, 7, 6, 6, 6, 6, 7, 7, 6, 7
    .byte 7, 6, 6, 6, 7, 7, 7, 6, 7, 6, 5, 7, 5, 6, 4
    .byte 6, 7, 5, 6, 7, 7, 4, 6, 6, 6, 6, 6, 7, 6, 7
    .byte 7, 4, 7, 7, 5, 6, 6, 6, 4, 7, 6, 7, 7, 6, 7
    .byte 7, 7, 6, 7, 6, 6, 7, 7, 6, 6, 6, 6, 6, 6, 7
    .byte 7, 6, 6, 7, 6, 6, 6, 6, 7, 7, 6, 6, 7, 6, 7
    .byte 7, 8, 6, 6, 7, 6, 7, 7, 7, 7, 7, 7, 5, 5, 5, 5
    .byte 6, 7, 6, 7, 5, 6, 6, 4, 6, 6, 7, 6, 6, 7, 7
    .byte 5, 6, 6, 6, 6, 5, 6, 7, 7, 7, 6, 5, 6, 7, 7
    .byte 7, 7, 6, 5, 7, 7, 7, 6, 5, 6, 6, 6, 7, 6, 6
    .byte 6, 7, 6, 6, 7, 7, 6, 6, 7, 7, 6, 8, 7, 6, 6, 7
    .byte 7, 6, 7, 6, 6, 8, 6, 5, 6, 7, 7, 7, 7, 7, 7, 7
    .byte 7, 6, 6, 6, 6, 7, 6, 7, 6, 7, 4, 4, 5, 5, 6
    .byte 5, 7, 6, 6, 5, 6, 7, 6, 7, 5, 6, 7, 6, 6, 5
    .byte 6, 7, 6, 6, 7, 7, 7, 7, 4, 8, 8, 6, 6, 5, 7, 6
    .byte 8, 6, 6, 5, 5, 8, 7, 7, 6, 7, 7, 6, 8, 7, 6, 7
    .byte 6
    .byte 7, 8, 7, 6, 7, 7, 7, 7, 6, 7, 6, 7, 7, 7, 8, 7
    .byte 7, 6, 7, 7, 6, 7, 6, 6, 7, 7, 6, 6, 6, 7, 6
    .byte 4, 7, 7, 6, 6, 6, 7, 7, 7, 6, 6, 6, 5, 6, 7
    .byte 7, 6, 6, 7, 6, 7, 7, 7, 6, 6, 7, 7, 7, 6, 5
    .byte 6, 7, 7, 6, 5, 6, 7, 6, 6, 6, 6, 7, 6, 6, 7
    .byte 7, 7, 7, 7, 6, 7, 7, 7, 7, 6, 7, 7, 7, 6, 6
    .byte 6, 7, 7, 7, 7, 7, 6, 8, 7, 6, 6, 6, 7, 5, 5, 7
    .byte 6, 7, 4, 6, 5, 6, 6, 6, 6, 5, 5, 7, 7, 8, 5, 6
    .byte 6, 6, 7, 6, 6, 5, 8, 6, 6, 7, 7, 6, 5, 6, 3, 7
    .byte 8, 7, 6, 5, 7, 6, 8, 7, 6, 6, 5, 8, 7, 6, 5, 6
    .byte 7
    .byte 5, 8, 7, 6, 7, 6, 7, 8, 7, 5, 6, 7, 7, 8, 7, 6
    .byte 7
    .byte 8, 6, 6, 7, 7, 7, 7, 7, 8, 5, 7, 7, 6, 7, 7, 6
    .byte 7, 6, 7, 5, 4, 6, 7, 6, 6, 6, 7, 6, 7, 5, 6
    .byte 5, 6, 6, 7, 7, 6, 7, 7, 5, 7, 6, 7, 6, 5, 7
    .byte 7, 6, 7, 6, 6, 7, 7, 7, 6, 7, 6, 6, 5, 7, 7
    .byte 7, 7, 6, 7, 6, 7, 7, 7, 6, 6, 7, 7, 7, 7, 5
    .byte 6, 7, 7, 6, 7, 6, 7, 7, 6, 7, 7, 7, 8, 7, 5, 6
    .byte 6, 7, 6, 7, 7, 6, 4, 5, 5, 6, 6, 4, 7, 7, 6
    .byte 6, 6, 7, 6, 7, 6, 5, 6, 6, 6, 5, 6, 7, 6, 6
    .byte 7, 6, 6, 7, 6, 7, 6, 6, 6, 6, 6, 7, 6, 6, 6
    .byte 5, 6, 7, 6, 6, 8, 6, 7, 6, 6, 6, 7, 7, 7, 6, 7
    .byte 7, 7, 6, 6, 6, 7, 6, 7, 7, 5, 7, 7, 7, 6, 6
    .byte 7, 6, 6, 6, 4, 7, 7, 6, 6, 6, 7, 5, 5, 6, 5
    .byte 6, 5, 5, 7, 7, 5, 6, 7, 6, 6, 5, 6, 7, 7, 7
    .byte 5, 5, 7, 7, 6, 6, 7, 6, 6, 6, 6, 7, 7, 6, 6
    .byte 7, 7, 6, 5, 5, 7, 7, 7, 6, 7, 7, 6, 5, 7, 7
    .byte 7, 7, 7, 7, 7, 6, 7, 6, 5, 6, 6, 7, 6, 7, 7
    .byte 7, 7, 6, 7, 6, 5, 7, 7, 7, 7, 5, 6, 5, 6, 7
    .byte 7, 7, 5, 6, 5, 6, 7, 6, 5, 4, 6, 7, 7, 7, 5
    .byte 7, 6, 6, 7, 7, 5, 5, 7, 7, 6, 6, 7, 5, 6, 7
    .byte 6, 7, 7, 7, 7, 7, 5, 6, 6, 7, 6, 6, 6, 5, 7
    .byte 6, 7, 6, 7, 7, 5, 7, 7, 7, 6, 6, 7, 7, 6, 6
    .byte 6, 7, 7, 7, 6, 7, 7, 7, 7, 8, 7, 7, 7, 6, 6, 3
    .byte 7, 6, 7, 6, 6, 7, 7, 6, 6, 6, 5, 5, 5, 5, 7
    .byte 6, 5, 5, 6, 7, 6, 6, 7, 6, 6, 6, 7, 7, 6, 6
    .byte 5, 7, 7, 7, 5, 7, 7, 7, 6, 7, 7, 7, 6, 6, 7
    .byte 5, 7, 7, 6, 6, 7, 6, 5, 7, 6, 6, 7, 6, 7, 6
    .byte 7, 5, 6, 7, 6, 6, 5, 7, 6, 7, 7, 6, 6, 6, 7
    .byte 7, 6, 6, 7, 6, 6, 6, 6, 5, 7, 6, 5, 7, 7, 8, 4
    .byte 8, 5, 5, 5, 5, 6, 7, 8, 6, 6, 7, 7, 7, 6, 7, 5
    .byte 5, 6, 6, 5, 6, 6, 7, 6, 8, 5, 8, 7, 7, 7, 4, 5
    .byte 4, 7, 6, 6, 7, 6, 6, 6, 7, 7, 4, 7, 7, 7, 5
    .byte 7, 7, 6, 6, 7, 7, 6, 7, 6, 7, 6, 7, 7, 7, 7
    .byte 7, 7, 7, 6, 7, 7, 7, 7, 6, 5, 5, 7, 7, 6, 7
    .byte 6, 6, 7, 7, 5, 5, 4, 6, 7, 7, 7, 6, 7, 5, 7
    .byte 6, 7, 5, 6, 5, 5, 6, 6, 6, 7, 6, 7, 7, 6, 6
    .byte 7, 7, 7, 7, 6, 6, 6, 6, 6, 7, 6, 6, 6, 7, 6
    .byte 7, 6, 7, 7, 6, 6, 7, 8, 6, 6, 7, 6, 7, 6, 6, 7
    .byte 6, 7, 7, 6, 8, 7, 6, 7, 7, 7, 6, 7, 6, 6, 6, 5
    .byte 7, 5, 7, 5, 6, 6, 5, 6, 6, 6, 5, 7, 6, 6, 6
    .byte 6, 7, 6, 8, 8, 5, 6, 6, 5, 6, 6, 7, 5, 7, 7, 6
    .byte 7, 6, 6, 6, 6, 6, 7, 7, 5, 6, 7, 7, 7, 6, 7
    .byte 7, 6, 5, 6, 4, 7, 7, 7, 7, 6, 7, 6, 5, 7, 7
    .byte 5, 7, 6, 6, 7, 7, 6, 7, 6, 6, 7, 6, 7, 7, 8, 7
    .byte 7, 5, 6, 6, 6, 6, 7, 5, 6, 5, 5, 7, 6, 7, 5
    .byte 6, 7, 7, 4, 6, 7, 7, 5, 5, 6, 7, 7, 7, 6, 7
    .byte 5, 6, 6, 7, 6, 6, 6, 6, 6, 5, 6, 7, 5, 7, 7
    .byte 6, 7, 6, 8, 7, 6, 7, 7, 5, 5, 7, 8, 7, 7, 7, 7
    .byte 5, 7, 7, 6, 6, 8, 7, 6, 7, 5, 7, 6, 6, 7, 7, 7
    .byte 7, 7, 6, 7, 7, 6, 6, 6, 6, 6, 7, 6, 5, 6, 6
    .byte 6, 6, 6, 5, 7, 6, 4, 7, 7, 7, 7, 5, 6, 4, 7
    .byte 6, 7, 7, 6, 7, 6, 7, 7, 5, 5, 6, 6, 7, 6, 6
    .byte 7, 6, 6, 7, 6, 8, 7, 7, 7, 7, 7, 6, 5, 5, 7, 7
    .byte 7, 7, 7, 8, 5, 7, 7, 6, 7, 7, 7, 7, 6, 6, 6, 6
    .byte 6, 7, 6, 6, 7, 7, 7, 6, 7, 6, 6, 6, 6, 7, 7
    .byte 7, 4, 6, 6, 6, 5, 6, 6, 8, 7, 5, 7, 7, 7, 6, 6
    .byte 7, 4, 7, 6, 6, 7, 6, 7, 6, 7, 7, 6, 5, 5, 6
    .byte 7, 7, 6, 7, 7, 6, 7, 6, 7, 8, 7, 8, 6, 7, 5, 7
    .byte 4, 6, 7, 7, 7, 7, 8, 7, 4, 6, 7, 6, 7, 7, 7, 7
    .byte 6, 6, 6, 6, 7, 7, 6, 7, 8, 7, 6, 7, 6, 5, 7, 7
    .byte 5, 7, 6, 6, 5, 5, 6, 5, 8, 5, 6, 7, 7, 5, 6, 7
    .byte 8, 5, 5, 6, 6, 6, 7, 7, 7, 6, 6, 7, 6, 6, 6, 6
    .byte 6, 6, 7, 6, 6, 6, 7, 5, 6, 6, 7, 6, 6, 7, 6
    .byte 6, 6, 6, 6, 8, 7, 7, 8, 5, 7, 4, 6, 6, 6, 7, 6
    .byte 6, 7, 7, 7, 7, 6, 7, 6, 7, 7, 5, 7, 7, 6, 5
    .byte 6, 5, 5, 7, 8, 6, 6, 6, 6, 7, 6, 6, 6, 7, 7, 7
    .byte 6, 6, 7, 8, 6, 5, 4, 7, 6, 7, 7, 7, 6, 6, 4, 6
    .byte 6, 6, 5, 5, 7, 7, 6, 7, 6, 7, 7, 7, 8, 7, 8, 7
    .byte 7, 5, 6, 6, 7, 7, 6, 6, 7, 7, 7, 5, 7, 5, 6
    .byte 7, 7, 7, 7, 6, 5, 8, 8, 6, 6, 6, 7, 7, 6, 7, 5
    .byte 7, 5, 6, 6, 6, 5, 6, 6, 7, 7, 6, 6, 7, 4, 8, 6
    .byte 6, 8, 7, 6, 5, 7, 7, 4, 6, 7, 7, 8, 8, 6, 7, 6
    .byte 6
    .byte 4, 7, 6, 6, 5, 7, 7, 6, 6, 6, 7, 6, 7, 7, 7
    .byte 6, 5, 7, 7, 8, 6, 7, 6, 6, 7, 6, 7, 7, 4, 6, 7
    .byte 7, 7, 6, 7, 6, 7, 7, 7, 7, 7, 6, 7, 7, 5, 6
    .byte 7, 7, 7, 6, 5, 7, 6, 5, 8, 8, 5, 6, 5, 5, 7, 7
    .byte 6, 6, 7, 7, 6, 6, 7, 6, 6, 5, 3, 8, 7, 7, 6, 8
    .byte 7, 6, 5, 5, 7, 5, 6, 5, 7, 6, 5, 4, 6, 5, 7
    .byte 7, 7, 7, 7, 8, 7, 5, 7, 6, 6, 6, 6, 7, 7, 5, 8
    .byte 6, 6, 6, 7, 7, 7, 7, 7, 7, 8, 7, 7, 6, 5, 6, 5
    .byte 7, 5, 7, 7, 6, 6, 6, 6, 8, 7, 6, 7, 7, 6, 6, 5
    .byte 6, 6, 6, 6, 7, 6, 7, 6, 7, 7, 7, 6, 4, 7, 6
    .byte 6, 6, 7, 7, 4, 7, 6, 5, 6, 6, 6, 6, 6, 7, 6
    .byte 6, 8, 6, 7, 6, 7, 7, 7, 6, 5, 7, 7, 6, 7, 7, 7
    .byte 5, 6, 6, 6, 7, 6, 6, 7, 7, 8, 6, 7, 7, 5, 6, 6
    .byte 6, 6, 6, 6, 6, 6, 5, 7, 6, 6, 6, 7, 6, 7, 5
    .byte 5, 7, 6, 5, 7, 6, 5, 7, 7, 6, 7, 6, 6, 5, 7
    .byte 7, 7, 7, 6, 4, 4, 6, 5, 7, 7, 5, 6, 8, 6, 6, 5
    .byte 6, 6, 6, 7, 6, 6, 6, 7, 7, 6, 6, 7, 7, 8, 7, 7
    .byte 6, 7, 7, 7, 6, 4, 5, 7, 6, 7, 6, 7, 7, 7, 7
    .byte 7, 7, 7, 6, 7, 7, 7, 6, 6, 5, 6, 7, 5, 7, 7
    .byte 6, 6, 7, 6, 7, 5, 5
    .byte 7, 8, 6, 6, 6, 5, 7, 5, 5, 4, 7, 7, 6, 7, 6, 6
    .byte 5, 6, 6, 5, 6, 6, 7, 7, 6, 6, 6, 6, 6, 7, 6
    .byte 6, 7, 6, 7, 7, 7, 7, 7, 7, 6, 7, 7, 6, 6, 7
    .byte 7, 5, 7, 5, 7, 6, 7, 7, 6, 7, 7, 7, 7, 7, 5
    .byte 7, 6, 7, 6, 6, 7, 6, 7, 5, 7, 7, 6, 7, 7, 7
    .byte 7, 4, 6, 6, 7, 6, 6, 5, 6, 7, 7, 6, 7, 5, 7
    .byte 5, 7, 7, 6, 7, 6, 6, 5, 5, 5, 5, 7, 6, 6, 6
    .byte 6, 4, 5, 6, 6, 6, 7, 6, 6, 6, 8, 6, 5, 6, 6, 6
    .byte 8, 6, 7, 7, 4, 8, 6, 7, 6, 7, 6, 7, 8, 8, 7, 7
    .byte 7
    .byte 7, 7, 6, 6, 6, 7, 6, 7, 7, 6, 6, 6, 6, 7, 8, 6
    .byte 8, 7, 7, 5, 6, 6, 7, 7, 7, 6, 6, 7, 6, 6, 6, 7
    .byte 7, 5, 7, 5, 6, 6, 8, 6, 5, 7, 7, 5, 6, 6, 7, 7
    .byte 7, 5, 6, 5, 7, 7, 6, 7, 6, 6, 6, 6, 7, 7, 7
    .byte 6, 7, 6, 6, 5, 7, 7, 6, 6, 5, 6, 6, 7, 8, 7, 7
    .byte 6, 6, 8, 6, 6, 7, 6, 6, 6, 6, 7, 6, 7, 6, 7, 7
    .byte 6, 7, 7, 6, 6, 5, 6, 6, 7, 6, 6, 6, 6, 7, 6
    .byte 5, 6, 5, 7, 5, 7, 7, 5, 7, 7, 7, 6, 6, 5, 4
    .byte 6, 6, 6, 6, 6, 6, 6, 6, 7, 6, 7, 7, 6, 6, 6
    .byte 8, 6, 6, 8, 7, 7, 7, 6, 7, 7, 6, 7, 6, 4, 5, 7
    .byte 5, 6, 6, 8, 7, 8, 7, 7, 6, 7, 6, 6, 6, 6, 6, 7
    .byte 6, 7, 7, 4, 8, 7, 6, 6, 7, 6, 7, 6, 6, 7, 8, 7
    .byte 6, 7, 5, 7, 4, 4, 4, 6, 8, 6, 7, 6, 6, 6, 6, 5
    .byte 6, 5, 6, 6, 7, 6, 7, 5, 6, 7, 7, 7, 7, 7, 6
    .byte 7, 6, 6, 6, 7, 7, 6, 7, 8, 6, 7, 7, 7, 6, 5, 7
    .byte 6, 7, 6, 7, 7, 7, 7, 6, 7, 6, 6, 6, 5, 7, 6
    .byte 6, 7, 6, 7, 6, 7, 6, 5, 6, 6, 7, 6, 6, 5, 7
    .byte 6, 5, 7, 6, 5, 7, 7, 5, 7, 5, 6, 5, 7, 6, 7
    .byte 7, 7, 5, 5, 7, 6, 6, 6, 6, 7, 7, 6, 4, 5, 7
    .byte 6, 7, 7, 6, 7, 5, 7, 7, 4, 7, 5, 7, 8, 7, 7, 7
    .byte 5, 8, 6, 6, 7, 6, 6, 7, 7, 7, 6, 7, 6, 7, 7, 6
    .byte 7, 6, 6, 5, 7, 7, 6, 7, 6, 6, 7, 7, 6, 7, 6
    .byte 7, 6, 7, 6, 7, 6, 7, 7, 6, 7, 6, 6, 5, 7, 6
    .byte 5, 7, 6, 7, 6, 7, 7, 5, 7, 7, 4, 6, 5, 6, 8, 6
    .byte 5, 7, 7, 7, 6, 6, 7, 6, 7, 7, 7, 7, 6, 7, 7
    .byte 7, 5, 8, 6, 6, 6, 7, 7, 7, 3, 7, 7, 6, 6, 6, 7
    .byte 6, 7, 8, 6, 7, 6, 6, 7, 7, 6, 7, 6, 7, 7, 6, 6
    .byte 7, 7, 5, 8, 7, 6, 5, 5, 4, 6, 7, 6, 7, 7, 7, 5
    .byte 6, 7, 5, 6, 5, 4, 7, 7, 6, 6, 8, 6, 6, 6, 6, 6
    .byte 6, 5, 6, 6, 7, 7, 7, 6, 7, 6, 6, 8, 6, 7, 7, 7
    .byte 6, 6, 6, 6, 8, 7, 7, 6, 7, 6, 6, 7, 6, 6, 6, 7
    .byte 7, 8, 7, 6, 7, 8, 6, 7, 6, 7, 7, 5, 6, 6, 7, 4
    .byte 6, 6, 6, 6, 7, 7, 7, 7, 6, 6, 6, 5, 7, 6, 6
    .byte 7, 7, 6, 5, 6, 6, 5, 6, 6, 7, 7, 7, 5, 7, 6
    .byte 6, 5, 6, 5, 7, 5, 6, 7, 7, 6, 6, 7, 5, 6, 7
    .byte 7, 7, 7, 7, 7, 6, 5, 7, 6, 8, 7, 7, 7, 6, 7, 5
    .byte 6, 5, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 7, 6, 7
    .byte 6, 7, 6, 6, 6, 5, 5, 6, 6, 7, 6, 6, 6, 6, 7
    .byte 7, 5, 7, 7, 6, 7, 6, 7, 7, 7, 7, 4, 5, 6, 6
    .byte 7, 6, 7, 5, 6, 5, 6, 6, 5, 5, 5, 7, 6, 5, 5
    .byte 7, 5, 7, 7, 8, 7, 8, 7, 7, 5, 7, 6, 6, 7, 5, 6
    .byte 7, 5, 7, 5, 6, 7, 6, 6, 6, 7, 7, 7, 8, 6, 7, 6
    .byte 6, 5, 5, 7, 6, 7, 6, 5, 6, 6, 5, 7, 7, 6, 7
    .byte 6, 6, 5, 6, 6, 7, 7, 7, 7, 6, 7, 5, 7, 7, 7
    .byte 7, 5, 8, 5, 6, 6, 7, 6, 5, 7, 7, 5, 5, 6, 5, 6
    .byte 6, 7, 5, 7, 6, 5, 6, 5, 6, 6, 8, 6, 5, 8, 7, 7
    .byte 4, 6, 7, 7, 8, 6, 7, 6, 7, 7, 6, 6, 7, 6, 7, 7
    .byte 8, 7, 7, 6, 6, 4, 7, 7, 6, 6, 6, 7, 6, 7, 6, 5
    .byte 6, 7, 7, 6, 6, 5, 6, 6, 6, 7, 7, 6, 7, 8, 6, 5
    .byte 6, 6, 6, 7, 6, 6, 7, 7, 5, 6, 7, 6, 5, 6, 6
    .byte 6, 5, 5, 6, 6, 7, 6, 6, 6, 6, 6, 4, 7, 6, 7
    .byte 8, 7, 7, 6, 7, 5, 7, 7, 7, 6, 7, 7, 6, 7, 6, 6
    .byte 6, 7, 7, 7, 7, 5, 7, 7, 7, 7, 5, 6, 7, 5, 5
    .byte 7, 8, 5, 7, 7, 7, 6, 7, 6, 6, 5, 7, 6, 6, 7, 7
    .byte 6, 6, 6, 7, 5, 6, 6, 6, 7, 6, 6, 6, 8, 7, 5, 7
    .byte 5, 5, 5, 5, 6, 6, 6, 6, 7, 6, 6, 6, 6, 5, 5
    .byte 7, 6, 7, 8, 7, 7, 6, 7, 5, 7, 6, 7, 6, 6, 7, 6
    .byte 6, 7, 5, 7, 7, 7, 7, 7, 6, 6, 7, 6, 6, 5, 7
    .byte 7, 5, 6, 7, 7, 6, 7, 7, 7, 5, 7, 5, 6, 5, 6
    .byte 7, 7, 6, 7, 7, 6, 6, 7, 6, 6, 5, 7, 6, 7, 7
    .byte 6, 7, 7, 6, 7, 6, 6, 5, 6, 5, 6, 7, 6, 6, 6
    .byte 5, 7, 5, 7, 6, 7, 7, 6, 7, 8, 6, 4, 7, 6, 7, 8
    .byte 6, 7, 5, 7, 7, 6, 7, 7, 6, 6, 6, 7, 8, 7, 6, 7
    .byte 5, 6, 7, 6, 6, 6, 7, 6, 7, 7, 6, 6, 6, 6, 6
    .byte 6, 5, 5, 6, 6, 6, 7, 7, 6, 7, 5, 6, 6, 6, 5
    .byte 6, 7, 6, 7, 7, 6, 6, 6, 6, 5, 5, 6, 5, 7, 6
    .byte 7, 7, 7, 6, 6, 7, 7, 7, 7, 6, 5, 6, 6, 6, 6
    .byte 6, 5, 6, 6, 7, 7, 6, 7, 7, 4, 5, 6, 8, 7, 6, 7
    .byte 6, 7, 5, 7, 7, 6, 7, 6, 6, 7, 7, 6, 7, 6, 6
    .byte 7, 6, 6, 6, 6, 5, 6, 7, 7, 6, 7, 7, 7, 7, 5
    .byte 6, 6, 6, 6, 2, 6, 6, 7, 6, 7, 6, 6, 8, 7, 5, 7
    .byte 6, 5, 6, 7, 6, 7, 8, 7, 6, 6, 6, 7, 7, 6, 7, 7
    .byte 6, 6, 5, 6, 7, 6, 5, 7, 7, 6, 7, 6, 7, 6, 3
    .byte 6, 7, 7, 7, 6, 7, 6, 5, 7, 6, 5, 6, 6, 6, 7
    .byte 5, 6, 7, 6, 7, 8, 7, 6, 6, 6, 5, 7, 6, 5, 6, 6
    .byte 6, 7, 8, 6, 5, 5, 6, 6, 8, 6, 6, 6, 7, 7, 6, 7
    .byte 7, 6, 6, 5, 7, 7, 7, 6, 6, 7, 6, 6, 7, 6, 7
    .byte 7, 6, 6, 7, 5, 7, 5, 5, 6, 6, 7, 6, 7, 7, 6
    .byte 6, 7, 5, 4, 8, 5, 7, 8, 7, 6, 6, 6, 7, 7, 6, 6
    .byte 7, 7, 7, 7, 5, 7, 7, 7, 7, 7, 7, 6, 7, 6, 6
    .byte 6, 6, 7, 6, 7, 6, 6, 7, 5, 6, 2, 5, 6, 6, 5
    .byte 6, 7, 7, 5, 6, 7, 7, 5, 7, 5, 7, 6, 7, 7, 7
    .byte 7, 6, 7, 8, 6, 7, 6, 6, 6, 8, 5, 6, 6, 5, 6, 7
    .byte 6, 6, 6, 7, 7, 6, 4, 6, 6, 6, 7, 7, 7, 7, 7
    .byte 7, 5, 6, 7, 6, 7, 7, 5, 5, 8, 7, 8, 7, 8, 6, 7
    .byte 6
    .byte 7, 5, 6, 6, 6, 6, 5, 7, 7, 3, 6, 6, 5, 5, 5
    .byte 5, 7, 6, 7, 6, 7, 6, 7, 6, 7, 6, 5, 6, 6, 7
    .byte 6, 7, 8, 7, 5, 7, 5, 7, 7, 7, 7, 6, 6, 6, 5, 5
    .byte 6, 6, 6, 7, 6, 7, 6, 6, 7, 5, 4, 7, 6, 6, 7
    .byte 6, 7, 6, 6, 7, 6, 6, 5, 6, 6, 6, 5, 7, 6, 6
    .byte 7, 7, 7, 6, 7, 5, 6, 6, 6, 6, 7, 7, 6, 7, 7
    .byte 5, 4, 5, 6, 6, 7, 5, 5, 7, 7, 7, 6, 7, 7, 5
    .byte 5, 6, 7, 6, 6, 6, 6, 8, 7, 6, 7, 5, 7, 8, 7, 5
    .byte 7, 6, 7, 5, 4, 6, 7, 7, 6, 7, 7, 7, 6, 6, 5
    .byte 5, 7, 5, 7, 8, 7, 5, 6, 6, 7, 6, 7, 7, 7, 6, 6
    .byte 7, 6, 8, 6, 6, 7, 7, 7, 6, 6, 6, 6, 7, 6, 6, 7
    .byte 6, 7, 7, 7, 5, 5, 3, 5, 7, 6, 5, 6, 7, 7, 5
    .byte 7, 7, 6, 5, 7, 4, 8, 6, 7, 7, 7, 7, 7, 7, 6, 7
    .byte 8, 6, 6, 7, 7, 6, 7, 6, 6, 6, 7, 7, 7, 6, 7, 7
    .byte 5, 4, 6, 7, 7, 6, 6, 6, 7, 6, 6, 7, 7, 6, 7
    .byte 6, 7, 6, 7, 7, 7, 7, 8, 5, 7, 6, 7, 5, 7, 6, 7
    .byte 7, 7, 6, 7, 7, 6, 5, 6, 6, 6, 2, 6, 7, 7, 7
    .byte 7, 6, 7, 7, 7, 5, 6, 6, 6, 6, 6, 7, 7, 7, 7
    .byte 6, 7, 7, 6, 6, 5, 6, 6, 7, 6, 6, 6, 6, 5, 6
    .byte 7, 6, 6, 7, 7, 7, 5, 7, 6, 6, 6, 6, 6, 7, 8, 7
    .byte 6, 7, 6, 6, 6, 7, 4, 5, 7, 6, 7, 6, 7, 5, 7
    .byte 7, 6, 6, 7, 7, 6, 6, 6, 6, 6, 3, 7, 7, 6, 5
    .byte 5, 6, 7, 6, 6, 7, 7, 7, 7, 7, 7, 7, 4, 5, 7
    .byte 7, 7, 7, 6, 6, 7, 7, 7, 7, 7, 6, 6, 7, 6, 7
    .byte 7, 6, 6, 7, 7, 7, 7, 5, 6, 7, 5, 5, 6, 8, 6, 6
    .byte 7, 5, 8, 6, 7, 7, 7, 7, 7, 7, 6, 6, 7, 7, 7, 7
    .byte 7, 6, 6, 5, 7, 6, 7, 7, 6, 7, 7, 7, 6, 7, 6
    .byte 6, 6, 7, 6, 1, 7, 6, 7, 7, 7, 6, 7, 7, 7, 6
    .byte 7, 6, 7, 7, 7, 7, 6, 7, 6, 6, 7, 6, 7, 7, 7
    .byte 6, 8, 5, 7, 5, 5, 7, 7, 7, 6, 7, 6, 7, 5, 6, 5
    .byte 5, 7, 4, 7, 7, 7, 6, 5, 7, 6, 7, 7, 7, 6, 7
    .byte 6, 7, 6, 7, 7, 7, 6, 6, 7, 7, 6, 6, 7, 7, 6
    .byte 6, 7, 6, 7, 7, 6, 6, 5, 3, 4, 7, 5, 5, 6, 7
    .byte 7, 4, 7, 7, 6, 6, 7, 6, 7, 6, 6, 7, 8, 6, 6, 6
    .byte 6, 7, 6, 7, 7, 7, 5, 7, 5, 6, 6, 6, 6, 6, 6
    .byte 7, 6, 5, 7, 6, 4
    .byte 7, 6, 6, 7, 6, 7, 6, 6, 6, 7, 6, 6, 6, 5, 7
    .byte 5, 6, 6, 7, 7, 7, 7, 5, 7, 6, 6, 7, 5, 6, 7
    .byte 6, 6, 7, 7, 6, 5, 4, 5, 6, 7, 5, 6, 7, 7, 6
    .byte 6, 7, 6, 6, 5, 6, 6, 7, 7, 7, 6, 7, 7, 5, 7
    .byte 7, 5, 7, 6, 7, 7, 7, 6, 5, 6, 6, 6, 6, 6, 7
    .byte 6, 6, 6, 6, 5, 7, 5, 6, 7, 7, 7, 7, 7, 6, 5
    .byte 7, 7, 7, 7, 7, 5, 5, 7, 7, 7, 7, 7, 6, 6, 7
    .byte 7, 6, 6, 7, 5, 5, 6, 7, 6, 3, 7, 7, 6, 4, 4
    .byte 6, 6, 6, 7, 7, 7, 7, 7, 6, 6, 7, 5, 7, 7, 7
    .byte 7, 7, 7, 7, 5, 7, 6, 7, 7, 6, 6, 7, 6, 6, 4
    .byte 5, 6, 6, 7, 5, 7, 6, 7, 6, 7, 4, 5, 7, 5, 7
    .byte 7, 7, 6, 6, 6, 6, 7, 7, 7, 7, 6, 6, 6, 6, 7
    .byte 6, 7, 7, 7, 7, 7, 7, 5, 7, 6, 5, 7, 7, 7, 7
    .byte 6, 6, 5, 6, 3, 5, 6, 6, 4, 5, 7, 7, 5, 7, 6
    .byte 7, 6, 7, 6, 7, 7, 7, 6, 7, 6, 6, 6, 6, 6, 6
    .byte 7, 7, 7, 6, 6, 4, 6, 6, 6, 6, 6, 6, 7, 6, 6
    .byte 7, 6, 4, 6, 6, 6, 6, 5, 7, 5, 6, 6, 7, 6, 6
    .byte 5, 6, 7, 4, 7, 6, 7, 6, 8, 8, 6, 7, 6, 5, 7, 6
    .byte 6, 7, 6, 5, 7, 7, 5, 5, 5, 6, 6, 7, 5, 6, 6
    .byte 6, 7, 5, 7, 7, 6, 6, 6, 5, 7, 7, 7, 7, 7, 7
    .byte 6, 7, 6, 7, 7, 7, 6, 7, 6, 6, 6, 5, 6, 6, 7
    .byte 6, 6, 6, 7, 7, 5, 5, 5, 7, 7, 5, 6, 6, 7, 6
    .byte 6, 7, 7, 6, 7, 6, 7, 7, 7, 6, 7, 7, 8, 6, 7, 6
    .byte 7, 6, 6, 7, 7, 6, 6, 6, 6, 7, 5, 6, 5, 7, 7
    .byte 2, 7, 6, 6, 6, 6, 5, 6, 7, 7, 6, 7, 7, 6, 7
    .byte 7, 8, 7, 8, 7, 5, 6, 7, 6, 7, 6, 6, 7, 7, 6, 6
    .byte 5, 6, 6, 7, 6, 7, 7, 6, 6, 6, 5, 7, 6, 5, 7
    .byte 7, 7, 6, 7, 7, 6, 7, 7, 6, 7, 6, 5, 4, 7, 7
    .byte 8, 7, 7, 6, 7, 7, 7, 6, 7, 7, 6, 6, 6, 7, 7, 2
    .byte 7, 7, 6, 5, 5, 6, 7, 5, 7, 6, 6, 6, 6, 7, 6
    .byte 7, 5, 5, 6, 6, 7, 7, 7, 7, 6, 7, 6, 6, 6, 6
    .byte 7, 6, 5, 8, 6, 7, 6, 6, 6, 7, 7, 6, 6, 6, 6, 6
    .byte 6, 6, 6, 7, 6, 5, 6, 6, 6, 8, 6, 7, 5, 7, 6, 7
    .byte 8, 7, 7, 6, 7, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 5
    .byte 6, 7, 6, 5, 5, 6, 6, 6, 6, 6, 3, 6, 6, 6, 5
    .byte 7, 7, 5, 7, 7, 4, 6, 6, 8, 6, 7, 7, 5, 8, 6, 6
    .byte 5, 6, 7, 7, 6, 7, 6, 7, 6, 7, 6, 7, 7, 5, 6
    .byte 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 7, 7, 7, 6, 7
    .byte 5, 7, 6, 7, 7, 7, 8, 6, 6, 7, 6, 6, 6, 6, 6, 7
    .byte 7, 5, 7, 5, 6, 6, 5, 6, 6, 6, 5, 7, 7, 6, 3
    .byte 7, 7, 7, 6, 7, 7, 6, 7, 6, 5, 5, 6, 7, 7, 8, 6
    .byte 6, 8, 6, 7, 6, 6, 7, 7, 6, 8, 7, 7, 6, 7, 5, 6
    .byte 8, 6, 6, 6, 5, 7, 7, 7, 6, 7, 7, 6, 5, 7, 7, 8
    .byte 5, 6, 6, 7, 5, 8, 7, 8, 8, 7, 6, 7, 5, 5, 7, 6
    .byte 6
    .byte 7, 7, 5, 7, 5, 7, 7, 6, 6, 6, 5, 6, 7, 7, 7
    .byte 2, 6, 7, 7, 6, 6, 6, 6, 7, 6, 5, 6, 6, 7, 7
    .byte 8, 6, 6, 8, 5, 6, 6, 7, 6, 6, 6, 7, 7, 6, 5, 7
    .byte 6, 6, 7, 6, 6, 5, 5, 7, 7, 7, 6, 6, 7, 6, 6
    .byte 7, 6, 8, 5, 6, 6, 8, 6, 7, 7, 7, 7, 7, 6, 6, 6
    .byte 6, 6, 5, 7, 7, 6, 6, 6, 4, 7, 6, 5, 6, 6, 6
    .byte 5, 7, 6, 6, 3, 7, 6, 6, 6, 6, 7, 6, 6, 6, 6
    .byte 6, 6, 6, 5, 5, 6, 6, 7, 7, 7, 7, 5, 7, 7, 7
    .byte 7, 7, 7, 6, 7, 7, 6, 7, 6, 6, 7, 6, 5, 7, 6
    .byte 7, 6, 6, 6, 5, 7, 7, 7, 5, 5, 7, 6, 7, 6, 7
    .byte 6, 7, 7, 7, 6, 5, 6, 6, 5, 6, 5, 6, 7, 7, 6
    .byte 7, 6, 5, 7, 8, 6, 6, 4, 6, 6, 7, 6, 6, 7, 7, 4
    .byte 7, 6, 6, 5, 5, 7, 7, 4, 7, 6, 6, 5, 6, 7, 7
    .byte 8, 6, 5, 7, 7, 7, 7, 7, 8, 7, 6, 7, 5, 6, 7, 7
    .byte 6, 6, 5, 8, 5, 7, 5, 7, 7, 6, 7, 7, 6, 5, 6, 7
    .byte 5, 7, 7, 7, 7, 6, 6, 7, 7, 7, 5, 4, 6, 7, 7
    .byte 6, 6, 8, 7, 5, 6, 5, 7, 7, 6, 6, 6, 7, 6, 6, 7
    .byte 5, 7, 6, 6, 6, 6, 5, 6, 7, 7, 4, 6, 5, 5, 7
    .byte 6, 6, 7, 7, 6, 8, 7, 6, 7, 6, 7, 7, 7, 5, 6, 7
    .byte 7, 7, 7, 7, 7, 6, 7, 6, 7, 6, 5, 7, 6, 6, 7
    .byte 6, 6, 4, 7, 6, 5, 6, 7, 7, 6, 6, 8, 6, 7, 6, 5
    .byte 4, 6, 8, 7, 5, 7, 6, 6, 6, 7, 6, 6, 4, 6, 6, 8
    .byte 6, 6, 7, 7, 4, 6, 6, 6, 4, 6, 4, 7, 7, 7, 4
    .byte 7, 7, 7, 6, 7, 7, 7, 6, 6, 7, 7, 7, 7, 7, 7
    .byte 7, 7, 6, 6, 6, 7, 6, 6, 6, 6, 7, 7, 6, 7, 7
    .byte 5, 6, 7, 7, 7, 6, 6, 6, 7, 6, 7, 7, 7, 7, 6
    .byte 6, 7, 6, 6, 7, 5, 4, 4, 7, 7, 6, 6, 6, 6, 6
    .byte 6, 5, 6, 6, 6, 7, 6, 5, 6, 7, 5, 6, 7, 6, 6
    .byte 6, 6, 7, 5, 6, 6, 6, 7, 7, 6, 6, 7, 5, 7, 8, 7
    .byte 7, 6, 7, 6, 6, 7, 7, 7, 6, 6, 7, 7, 6, 7, 6
    .byte 5, 7, 5, 6, 5, 7, 6, 6, 6, 7, 6, 6, 7, 7, 6
    .byte 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 4, 7, 5, 6, 6
    .byte 6, 5, 7, 7, 5, 7, 8, 6, 7, 7, 6, 4, 4, 7, 6, 7
    .byte 4, 7, 6, 7, 5, 3, 7, 7, 7, 6, 7, 5, 7, 6, 6
    .byte 6, 8, 7, 7, 8, 7, 7, 6, 7, 6, 7, 7, 7, 6, 7, 7
    .byte 7, 7, 5, 8, 7, 7, 7, 6, 7, 7, 5, 5, 7, 6, 6, 7
    .byte 7, 7, 6, 7, 5, 6, 7, 6, 7, 7, 7, 6, 7, 7, 6
    .byte 3, 6, 5, 7, 7, 6, 7, 6, 6, 7, 5, 7, 5, 5, 7
    .byte 5, 6, 6, 7, 6, 5, 7, 7, 6, 5, 6, 7, 7, 6, 5
    .byte 6, 7, 7, 6, 7, 6, 6, 7, 7, 6, 6, 7, 6, 6, 7
    .byte 7, 7, 7, 7, 8, 8, 7, 6, 7, 6, 6, 5, 6, 5, 7, 7
    .byte 6, 6, 7, 7, 5, 5, 7, 7, 4, 6, 8, 7, 7, 7, 7, 7
    .byte 7, 7, 6, 6, 7, 6, 5, 6, 7, 6, 6, 6, 6, 6, 7
    .byte 5, 6, 7, 6, 5, 5, 6, 5, 7, 6, 4, 6, 7, 6, 6
    .byte 6, 6, 4, 6, 6, 5, 7, 7, 6, 7, 7, 7, 7, 6, 7
    .byte 6, 6, 7, 5, 8, 7, 7, 7, 6, 6, 7, 7, 5, 6, 5, 6
    .byte 5, 8, 6, 6, 6, 5, 7, 6, 7, 7, 5, 7, 6, 6, 6, 8
    .byte 7, 5, 7, 7, 7, 5, 7, 6, 6, 6, 7, 7, 7, 5, 5
    .byte 7, 7, 7, 7, 6, 5, 6, 5, 3, 5, 6, 6, 7, 7, 6
    .byte 6, 6, 6, 7, 5, 7, 7, 5, 6, 4, 6, 6, 6, 7, 7
    .byte 7, 7, 7, 7, 6, 7, 8, 7, 6, 7, 6, 5, 6, 7, 6, 6
    .byte 6, 7, 7, 7, 6, 6, 6, 5, 6, 6, 6, 6, 7, 6, 6
    .byte 6, 5, 6, 7, 7, 6, 7, 7, 7, 7, 7, 6, 7, 7, 4
    .byte 7, 7, 6, 4, 5, 5, 6, 7, 6, 6, 6, 6, 6, 6, 7
    .byte 6, 5, 6, 6, 6, 7, 5, 5, 7, 7, 7, 6, 7, 7, 6
    .byte 4, 6, 6, 6, 7, 6, 7, 6, 8, 7, 8, 8, 8, 7, 7, 7
    .byte 7
    .byte 7, 7, 6, 7, 6, 8, 6, 7, 4, 6, 7, 5, 7, 7, 7, 6
    .byte 6, 7, 7, 7, 7, 5, 6, 6, 6, 7, 8, 7, 7, 7, 7, 6
    .byte 4, 5, 6, 6, 6, 6, 6, 6, 5, 5, 6, 7, 5, 7, 7
    .byte 6, 6, 7, 5, 6, 5, 7, 6, 7, 5, 7, 6, 6, 7, 6
    .byte 5, 6, 5, 7, 7, 6, 6, 7, 7, 6, 7, 7, 6, 7, 7
    .byte 7, 7, 6, 6, 7, 7, 7, 5, 6, 6, 6, 8, 7, 6, 7, 6
    .byte 7, 6, 7, 6, 6, 6, 5, 7, 6, 7, 7, 7, 6, 7, 7
    .byte 6, 7, 8, 7, 6, 6, 7, 5, 7, 6, 6, 4, 7, 6, 7, 6
    .byte 6, 8, 6, 7, 7, 6, 6, 2, 7, 6, 7, 5, 7, 6, 6, 7
    .byte 6, 6, 7, 4, 5, 5, 6, 5, 6, 7, 7, 7, 7, 6, 7
    .byte 7, 7, 7, 6, 7, 7, 7, 7, 7, 6, 7, 4, 7, 7, 6
    .byte 6, 7, 7, 5, 6, 6, 6, 6, 6, 7, 7, 5, 7, 7, 6
    .byte 6, 7, 6, 7, 7, 6, 5, 6, 7, 4, 7, 6, 4, 6, 6
    .byte 6, 6, 6, 6, 6, 6, 6, 7, 6, 5, 8, 8, 6, 3, 5, 6
    .byte 7, 6, 5, 7, 5, 7, 8, 5, 5, 5, 7, 8, 7, 6, 6, 7
    .byte 6, 7, 7, 6, 7, 7, 6, 7, 7, 7, 5, 7, 7, 6, 6
    .byte 7, 5, 7, 7, 7, 7, 7, 4, 7, 4, 6, 6, 7, 6, 7
    .byte 7, 6, 7, 7, 8, 8, 7, 7, 5, 7, 6, 5, 6, 6, 3, 7
    .byte 7, 6, 7, 7, 5, 6, 6, 6, 5, 8, 7, 5, 6, 6, 5, 6
    .byte 7, 6, 5, 6, 6, 6, 6, 5, 6, 7, 6, 6, 5, 5, 7
    .byte 6, 6, 6, 6, 7, 6, 7, 6, 6, 7, 7, 7, 7, 8, 5, 6
    .byte 7, 6, 6, 6, 5, 7, 8, 7, 6, 7, 5, 7, 5, 6, 7, 6
    .byte 7, 6, 7, 7, 5, 6, 7, 7, 7, 6, 7, 7, 7, 6, 5
    .byte 6, 6, 5, 6, 5, 7, 5, 7, 7, 5, 7, 6, 7, 6, 7
    .byte 6, 5, 5, 6, 6, 7, 7, 3, 7, 5, 5, 7, 7, 7, 6
    .byte 3, 6, 7, 6, 7, 7, 7, 6, 6, 7, 6, 6, 6, 7, 7
    .byte 7, 7, 7, 6, 6, 6, 6, 6, 7, 7, 7, 6, 7, 5, 7
    .byte 6, 5, 7, 5, 7, 6, 7, 6, 7, 7, 6, 7, 8, 7, 7, 7
    .byte 7, 6, 5, 5, 5, 6, 6, 5, 5, 7, 6, 7, 6, 6, 6
    .byte 6, 5, 6, 6, 7, 7, 5, 4, 7, 7, 6, 5, 6, 6, 6
    .byte 6, 7, 7, 6
    .byte 7, 6, 6, 5, 6, 7, 7, 7, 7, 7, 7, 5, 6, 7, 6
    .byte 7, 8, 7, 8, 7, 6, 7, 6, 7, 6, 7, 6, 7, 7, 7, 5
    .byte 5, 5, 6, 6, 6, 7, 6, 8, 6, 6, 6, 6, 7, 7, 7, 5
    .byte 7, 7, 6, 7, 6, 6, 5, 6, 6, 7, 6, 4, 7, 7, 7
    .byte 6, 4, 7, 7, 6, 5, 6, 6, 6, 6, 7, 6, 5, 7, 4
    .byte 7, 7, 7, 6, 7, 7, 6, 4, 7, 7, 7, 7, 7, 6, 7
    .byte 7, 6, 6, 7, 7, 7, 7, 7, 6, 7, 6, 7, 7, 6, 7
    .byte 5, 7, 4, 7, 7, 6, 8, 7, 5, 6, 5, 7, 7, 5, 7, 7
    .byte 7, 6, 6, 7, 7, 6, 6, 7, 6, 7, 5, 6, 7, 7, 4
    .byte 5, 7, 6, 6, 7, 6, 6, 6, 6, 5, 4, 7, 6, 7, 7
    .byte 6, 5, 5, 7, 7, 6, 5, 6, 6, 6, 6, 4, 6, 6, 6
    .byte 7, 7, 7, 8, 7, 6, 7, 6, 7, 6, 7, 6, 6, 6, 6, 6
    .byte 6, 7, 7, 6, 6, 4, 6, 7, 7, 7, 6, 7, 7, 7, 7
    .byte 6, 6, 6, 7, 7, 7, 7, 6, 7, 7, 7, 7, 6, 6, 7
    .byte 6, 6, 7, 6, 7, 4, 6, 7, 7, 7, 6, 7, 3, 7, 7
    .byte 5, 7, 5, 7, 6, 6, 6, 4, 6, 5, 6, 5, 6, 6, 7
    .byte 6, 6, 7, 7, 5, 6, 7, 7, 8, 7, 6, 7, 7, 7, 6, 6
    .byte 7, 7, 6, 7, 7, 7, 6, 7, 5, 7, 6, 7, 6, 8, 6, 7
    .byte 7, 7, 6, 7, 6, 6, 6, 6, 7, 7, 7, 7, 5, 7, 5
    .byte 7, 6, 7, 5, 5, 6, 7, 5, 7, 6, 6, 7, 7, 7, 5
    .byte 5, 7, 5, 6, 6, 6, 7, 7, 5, 7, 7, 7, 3, 4, 5
    .byte 6, 7, 5, 7, 6, 6, 6, 7, 7, 5, 7, 7, 7, 7, 6
    .byte 6, 7, 7, 7, 6, 6, 6, 7, 7, 7, 7, 7, 7, 6, 6
    .byte 6, 7, 6, 7, 7, 7, 7, 7, 7, 5, 6, 5, 6, 7, 6
    .byte 7, 6, 7, 7, 6, 6, 6, 6, 6, 7, 7, 5, 6, 6, 6
    .byte 4, 6, 6, 7, 6, 6, 7, 6, 7, 6, 5, 7, 7, 5, 7
    .byte 7, 4, 5, 5, 6, 7, 7, 4, 7, 6, 7, 5, 7, 6, 7
    .byte 7, 7, 6, 7, 7, 7, 6, 6, 7, 7, 6, 7, 5, 7, 7
    .byte 6, 5, 7, 6, 7, 5, 7, 5, 6, 6, 7, 8, 7, 7, 6, 6
    .byte 7, 5, 7, 7, 7, 7, 6, 5, 7, 7, 7, 5, 3, 7, 6
    .byte 6, 5, 6, 7, 7, 5, 7, 6, 6, 6, 5, 6, 6, 6, 7
    .byte 7, 7, 6, 7, 6, 6, 7, 6, 6, 6, 7, 7, 5, 6, 6
    .byte 6, 7, 6, 5, 7, 7, 7, 7, 7, 7, 7, 5, 7, 7, 7
    .byte 4, 7, 7, 7, 6, 7, 8, 6, 7, 7, 5, 8, 5, 5, 7, 6
    .byte 7, 7, 7, 6, 5, 7, 7, 5, 6, 7, 6, 6, 7, 8, 5, 7
    .byte 6, 4, 5, 6, 8, 7, 6, 7, 7, 5, 6, 7, 7, 5, 5, 5
    .byte 6, 7, 7, 6, 6, 7, 5, 6, 6, 6, 5, 6, 5, 7, 6
    .byte 5, 6, 6, 6, 7, 7, 7, 6, 6, 5, 7, 7, 7, 7, 7
    .byte 8, 7, 7, 7, 6, 7, 6, 7, 6, 7, 4, 8, 7, 6, 6, 6
    .byte 6, 6, 7, 8, 7, 6, 6, 8, 6, 8, 7, 7, 6, 7, 7, 6
    .byte 6
    .byte 6, 6, 6, 6, 7, 4, 7, 7, 6, 6, 6, 6, 6, 7, 8, 6
    .byte 6, 3, 6, 6, 7, 6, 6, 7, 7, 5, 7, 6, 6, 6, 5
    .byte 7, 6, 7, 4, 6, 8, 7, 7, 6, 6, 7, 7, 6, 6, 6, 7
    .byte 7, 6, 7, 7, 6, 6, 5, 7, 7, 6, 6, 7, 7, 7, 6
    .byte 5, 7, 7, 4, 6, 8, 7, 6, 6, 6, 7, 7, 5, 6, 7, 7
    .byte 7, 6, 6, 6, 6, 5, 6, 4, 5, 4, 7, 7, 6, 5, 6
    .byte 7, 7, 6, 6, 5, 5, 6, 7, 5, 5, 7, 7, 5, 7, 7
    .byte 6, 7, 6, 7, 7, 5, 7, 7, 6, 6, 5, 6, 5, 6, 6
    .byte 8, 6, 7, 8, 7, 6, 7, 7, 6, 5, 6, 7, 6, 6, 7, 5
    .byte 6, 6, 7, 7, 6, 6, 7, 6, 5, 6, 6, 7, 6, 7, 6
    .byte 7, 6, 6, 5, 7, 7, 6, 7, 7, 7, 6, 6, 6, 7, 7
    .byte 3, 8, 6, 6, 4, 4, 6, 6, 7, 7, 5, 7, 6, 6, 6, 6
    .byte 6, 5, 6, 6, 6, 7, 6, 5, 7, 7, 6, 7, 7, 6, 5
    .byte 6, 7, 8, 6, 6, 7, 6, 5, 6, 6, 6, 7, 6, 7, 7, 7
    .byte 7, 7, 7, 7, 4, 7, 5, 6, 7, 6, 5, 7, 6, 7, 6
    .byte 7, 6, 7, 7, 6, 7, 5, 7, 7, 6, 7, 7, 7, 7, 7
    .byte 7, 6, 5, 6, 7, 6, 6, 5, 6, 4, 6, 5, 7, 7, 7
    .byte 7, 6, 7, 7, 7, 6, 3, 6, 6, 7, 6, 7, 5, 7, 6
    .byte 6, 7, 7, 6, 5, 5, 6, 6, 6, 6, 7, 8, 6, 7, 6, 7
    .byte 7, 7, 7, 6, 6, 6, 7, 6, 6, 6, 5, 7, 6, 7, 5
    .byte 7, 7, 6, 7, 7, 6, 7, 7, 7, 7, 7, 6, 4, 7, 6
    .byte 7, 7, 8, 7, 6, 7, 7, 5, 5, 4, 6, 6, 7, 5, 5, 6
    .byte 5, 6, 5, 7, 6, 7, 6, 6, 6, 6, 6, 5, 6, 6, 7
    .byte 7, 6, 6, 7, 7, 6, 7, 5, 6, 5, 7, 4, 6, 7, 7
    .byte 7, 7, 6, 7, 7, 7, 7, 6, 7, 6, 7, 6, 7, 7, 7
    .byte 3, 6, 7, 6, 6, 6, 6, 5, 5, 6, 6, 6, 7, 7, 7
    .byte 6, 7, 6, 7, 7, 6, 7, 7, 8, 7, 6, 5, 8, 5, 6, 5
    .byte 3, 6, 7, 6, 7, 6, 6, 7, 6, 7, 7, 6, 5, 7, 7
    .byte 5, 4, 6, 7, 7, 7, 5, 7, 5, 7, 8, 6, 6, 6, 6, 7
    .byte 7, 6, 6, 6, 7, 7, 7, 7, 8, 7, 7, 6, 7, 6, 5, 7
    .byte 6, 6, 5, 6, 6, 7, 7, 6, 7, 6, 4, 7, 5, 6, 6
    .byte 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6, 6
    .byte 7, 7, 2, 7, 6, 6, 7, 6, 5, 6, 5, 6, 6, 7, 7
    .byte 4, 6, 6, 6, 6, 7, 6, 6, 7, 6, 6, 5, 6, 7, 7
    .byte 6, 4, 7, 7, 7, 7, 7, 6, 6, 5, 7, 6, 7, 7, 7
    .byte 7, 7, 7, 7, 6, 7, 5, 6, 5, 7, 7, 6, 5, 7, 6
    .byte 7, 7, 6, 7, 6, 6, 6, 7, 6, 7, 7, 7, 6, 7, 7
    .byte 7, 6, 6, 6, 6, 6, 6, 5, 6, 4, 5, 6, 7, 6, 5
    .byte 7, 7, 6, 6, 5, 5, 6, 7, 5, 5, 6, 7, 5, 6, 6
    .byte 6, 7, 5, 5, 6, 7, 7, 6, 6, 6, 7, 7, 6, 6, 5
    .byte 7, 6, 8, 6, 6, 6, 7, 7, 7, 7, 6, 5, 6, 6, 6, 5
    .byte 6, 7, 7, 7, 5, 8, 6, 7, 6, 5, 7, 7, 7, 6, 8, 6
    .byte 5, 7, 6, 6, 6, 6, 6, 7, 7, 6, 6, 5, 6, 4, 7
    .byte 4, 7, 6, 7, 6, 5, 7, 7, 7, 5, 6, 6, 6, 5, 6
    .byte 5, 7, 8, 4, 7, 6, 6, 7, 7, 7, 7, 6, 5, 6, 7, 7
    .byte 7, 6, 6, 7, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7
    .byte 6, 6, 6, 6, 7, 6, 7, 8, 8, 4, 6, 6, 6, 6, 7, 7
    .byte 7, 7, 6, 6, 7, 6, 7, 6, 7, 5, 6, 7, 6, 7, 7
    .byte 6, 4, 6, 6, 6, 6, 5, 7, 7, 7, 6, 4, 7, 7, 5
    .byte 6, 7, 7, 6, 6, 6, 7, 6, 7, 7, 6, 5, 7, 7, 7
    .byte 6, 7, 6, 7, 6, 6, 8, 7, 7, 7, 6, 6, 7, 7, 6, 7
    .byte 8, 6, 6, 6, 7, 6, 6, 5, 4, 6, 6, 7, 6, 6, 6, 6
    .byte 7, 7, 7, 7, 6, 7, 6, 5, 6, 6, 7, 7, 8, 7, 7, 7
    .byte 7, 3, 7, 5, 6, 5, 5, 6, 7, 7, 6, 6, 7, 6, 7
    .byte 6, 5, 5, 5, 7, 5, 6, 4, 7, 7, 7, 6, 4, 7, 7
    .byte 6, 7, 6, 4, 6, 6, 7, 5, 7, 6, 7, 7, 7, 6, 5
    .byte 7, 7, 6, 6, 7, 7, 7, 6, 6, 6, 4, 7, 7, 6, 6
    .byte 7, 6, 6, 6, 5, 7, 7, 5, 8, 6, 7, 6, 6, 6, 5, 7
    .byte 7, 7, 7, 6, 7, 6, 7, 5, 3, 5, 6, 6, 7, 6, 7
    .byte 6, 6, 8, 4, 6, 5, 6, 6, 6, 7, 6, 8, 7, 6, 8, 6
    .byte 6
    .byte 5, 6, 7, 7, 7, 6, 6, 6, 6, 6, 6, 6, 7, 7, 6
    .byte 6, 6, 6, 6, 7, 7, 6, 8, 7, 6, 7, 7, 7, 6, 7, 7
    .byte 7, 6, 6, 6, 7, 8, 7, 6, 7, 7, 6, 5, 6, 7, 4, 6
    .byte 7, 7, 7, 7, 8, 7, 7, 6, 7, 5, 6, 6, 4, 6, 7, 6
    .byte 5, 6, 6, 6, 7, 5, 6, 6, 7, 6, 5, 5, 5, 7, 6
    .byte 5, 6, 7, 6, 6, 7, 6, 5, 6, 7, 5, 6, 6, 7, 7
    .byte 7, 7, 7, 6, 7, 6, 5, 6, 6, 7, 7, 7, 6, 7, 5
    .byte 6, 6, 4, 5, 6, 6, 6, 8, 5, 7, 6, 5, 7, 6, 7, 6
    .byte 6, 7, 5, 6, 7, 7, 7, 6, 6, 7, 7, 4, 7, 7, 6
    .byte 5, 7, 7, 7, 6, 4, 7, 7, 8, 6, 5, 6, 6, 4, 4, 6
    .byte 7, 6, 7, 7, 6, 7, 7, 4, 6, 6, 7, 6, 6, 7, 7
    .byte 5, 6, 6, 7, 7, 6, 7, 7, 7, 5, 5, 6, 7, 7, 7
    .byte 7, 7, 7, 5, 6, 7, 6, 6, 4, 6, 5, 8, 6, 6, 7, 6
    .byte 6, 7, 6, 7, 7, 6, 7, 7, 8, 6, 5, 7, 6, 7, 5, 6
    .byte 6, 6, 6, 6, 7, 7, 3, 6, 6, 7, 6, 6, 6, 5, 7
    .byte 7, 5, 5, 6, 7, 6, 7, 7, 5, 5, 6, 4, 6, 6, 6
    .byte 7, 7, 5, 6, 7, 7, 6, 7, 6, 7, 8, 6, 7, 6, 6, 6
    .byte 6, 7, 6, 7, 6, 7, 7, 7, 6, 7, 6, 6, 5, 7, 5
    .byte 7, 7, 7, 8, 7, 6, 8, 7, 6, 7, 7, 6, 7, 7, 8, 6
    .byte 6
    .byte 5, 7, 6, 7, 4, 6, 7, 7, 5, 6, 7, 7, 7, 8, 6, 5
    .byte 4, 7, 6, 7, 7, 7, 7, 7, 6, 7, 7, 7, 4, 5, 5
    .byte 6, 6, 6, 8, 6, 6, 7, 7, 7, 5, 7, 7, 7, 6, 7, 5
    .byte 7, 7, 6, 6, 7, 7, 6, 7, 7, 6, 6, 7, 6, 5, 6
    .byte 7, 6, 7, 7, 7, 7, 7, 7, 5, 6, 5, 6, 6, 6, 7
    .byte 6, 7, 6, 5, 6, 6, 6, 6, 6, 7, 6, 6, 7, 7, 3
    .byte 6, 7, 7, 5, 5, 6, 6, 7, 5, 6, 7, 7, 6, 7, 7
    .byte 5, 5, 5, 6, 7, 6, 6, 7, 6, 6, 5, 6, 5, 7, 6
    .byte 7, 7, 7, 6, 6, 6, 5, 7, 7, 8, 6, 7, 6, 6, 6, 5
    .byte 7, 6, 6, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7
    .byte 6, 6, 7, 6, 8, 7, 6, 6, 8, 6, 7, 5, 6, 6, 6, 5
    .byte 7, 7
    .byte 7, 4, 7, 6, 6, 6, 6, 7, 4, 7, 7, 6, 7, 6, 7
    .byte 7, 7, 6, 4, 6, 6, 7, 7, 6, 6, 5, 7, 7, 6, 7
    .byte 7, 7, 5, 6, 8, 8, 7, 7, 7, 7, 7, 7, 6, 7, 5, 7
    .byte 7, 7, 5, 8, 7, 7, 7, 7, 6, 6, 6, 7, 7, 6, 5, 7
    .byte 6, 7, 6, 7, 7, 7, 7, 6, 6, 6, 6, 7, 6, 7, 5
    .byte 7, 7, 7, 7, 7, 6, 5, 7, 8, 7, 7, 4, 7, 6, 7, 6
    .byte 6, 6, 7, 5, 7, 7, 6, 5, 6, 6, 6, 5, 5, 5, 6
    .byte 6, 6, 6, 7, 6, 7, 7, 6, 7, 7, 6, 6, 7, 7, 5
    .byte 7, 7, 7, 6, 7, 8, 7, 7, 7, 6, 7, 6, 6, 6, 6, 6
    .byte 7, 7, 6, 5, 7, 6, 4, 5, 8, 7, 5, 7, 7, 6, 6, 7
    .byte 5, 5, 7, 7, 7, 6, 7, 7, 6, 5, 6, 6, 6, 5, 5
    .byte 5, 7, 7, 6, 7, 7, 5, 5, 6, 6, 5, 5, 6, 6, 6
    .byte 5, 6, 5, 7, 5, 7, 7, 7, 8, 7, 6, 6, 7, 7, 7, 7
    .byte 7, 6, 7, 8, 5, 7, 7, 6, 6, 7, 6, 7, 6, 7, 4, 7
    .byte 7, 7, 7, 6, 7, 6, 5, 7, 5, 6, 7, 6, 7, 6, 6
    .byte 7, 6, 7, 6, 4, 6, 7, 6, 6, 7, 7, 7, 6, 6, 6
    .byte 6, 6, 6, 7, 6, 6, 7, 7, 7, 6, 7, 6, 5, 6, 5
    .byte 6, 5, 8, 6, 7, 3, 6, 7, 6, 7, 6, 7, 8, 7, 6, 6
    .byte 7, 7, 7, 6, 7, 7, 7, 7, 6, 7, 7, 7, 7, 7, 7
    .byte 7, 7, 6, 7, 6, 5, 5, 7, 7, 6, 6, 6, 6, 6, 5
    .byte 7, 7, 6, 7, 6, 6, 7, 6, 5, 7, 5, 5, 4, 7, 8, 7
    .byte 6, 6, 6, 6, 5, 6, 6, 6, 7, 7, 6, 5, 7, 7, 5
    .byte 6, 6, 6, 6, 6, 6, 7, 6, 7, 6, 7, 7, 7, 6, 7
    .byte 7, 5, 7, 7, 7, 6, 6, 6, 6, 6, 6, 7, 7, 6, 5
    .byte 6, 7, 5, 6, 6, 5, 6, 6, 7, 6, 7, 5, 5, 7, 7
    .byte 6, 6, 7, 7, 5, 6, 7, 6, 7, 6, 8, 7, 8, 6, 7, 4
    .byte 7, 5, 5, 6, 6, 6, 7, 7, 6, 6, 7, 6, 6, 7, 6
    .byte 5, 5, 7, 6, 6, 4, 6, 6, 7, 5, 6, 5, 7, 7, 6
    .byte 5, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 7, 7
    .byte 6, 7, 7, 7, 7, 7, 7, 7, 6, 7, 6, 7, 6, 7, 6
    .byte 8, 8, 6, 5, 8, 6, 6, 5, 7, 7, 3, 7, 8, 7, 8, 7
    .byte 7, 6
    .byte 8, 7, 7, 6, 6, 7, 5, 6, 7, 7, 5, 7, 6, 5, 7, 5
    .byte 6, 7, 7, 6, 4, 6, 5, 7, 6, 5, 6, 6, 4, 6, 6
    .byte 7, 6, 6, 5, 7, 6, 7, 6, 8, 6, 7, 8, 6, 6, 5, 7
    .byte 7, 7, 7, 7, 7, 6, 6, 6, 6, 5, 7, 6, 7, 7, 7
    .byte 7, 7, 6, 4, 6, 7, 6, 7, 7, 6, 6, 7, 6, 6, 7
    .byte 7, 7, 8, 7, 7, 6, 7, 6, 3, 6, 6, 7, 7, 7, 8, 7
    .byte 6, 7, 4, 7, 4, 6, 7, 5, 6, 6, 8, 6, 6, 8, 6, 5
    .byte 6, 5, 6, 5, 5, 6, 7, 5, 7, 7, 6, 7, 7, 7, 7
    .byte 5, 7, 6, 6, 6, 6, 8, 6, 7, 6, 6, 6, 6, 7, 5, 6
    .byte 6, 6, 6, 7, 6, 7, 5, 4, 6, 6, 6, 6, 6, 7, 6
    .byte 6, 6, 7, 8, 6, 7, 7, 6, 5, 7, 7, 6, 5, 6, 7, 7
    .byte 6, 5, 7, 7, 7, 7, 5, 6, 5, 5, 4, 5, 6, 5, 7
    .byte 7, 5, 7, 7, 4, 6, 5, 7, 7, 5, 6, 6, 6, 7, 7
    .byte 5, 6, 7, 6, 8, 7, 7, 7, 7, 7, 6, 6, 7, 6, 7, 7
    .byte 6, 6, 7, 6, 7, 7, 7, 7, 7, 4, 7, 5, 6, 5, 6
    .byte 7, 6, 7, 6, 8, 7, 7, 7, 7, 6, 6, 6, 6, 6, 7, 7
    .byte 3, 7, 7, 6, 7, 7, 4, 7, 6, 7, 6, 7, 6, 4, 5
    .byte 5, 6, 7, 6, 6, 5, 7, 6, 7, 5, 4, 6, 6, 7, 6
    .byte 6, 6, 6, 7, 7, 6, 6, 6, 7, 7, 7, 6, 6, 8, 7, 7
    .byte 7, 6, 6, 7, 7, 5, 6, 6, 7, 7, 7, 6, 7, 6, 6
    .byte 5, 6, 6, 6, 7, 6, 7, 7, 5, 6, 7, 7, 6, 5, 6
    .byte 6, 7, 7, 6, 6, 7, 5, 7, 5, 6, 6, 7, 6, 6, 7
    .byte 7, 6, 6, 6, 6, 5, 5, 5, 6, 8, 8, 4, 7, 6, 4, 6
    .byte 6, 7, 6, 4, 7, 7, 6, 7, 6, 6, 5, 6, 7, 7, 7
    .byte 6, 7, 7, 7, 7, 6, 6, 7, 6, 6, 6, 7, 6, 7, 6
    .byte 6, 6, 8, 7, 5, 6, 6, 6, 5, 6, 6, 7, 7, 7, 7, 7
    .byte 7, 7, 6, 6, 6, 6, 6, 6, 6, 7, 5, 5, 7, 7, 7
    .byte 6, 6, 7, 7, 6, 6, 5, 6, 6, 4, 5, 7, 6, 6, 6
    .byte 6, 6, 5, 5, 6, 6, 6, 7, 7, 6, 6, 7, 6, 6, 7
    .byte 7, 7, 7, 6, 7, 7, 6, 8, 7, 7, 7, 7, 7, 7, 7, 7
    .byte 7, 7, 7, 7, 7, 7, 5, 6, 6, 6, 5, 6, 7, 7, 7
    .byte 7, 6, 7, 5, 8, 6, 6, 4, 6, 6, 7, 7, 6, 7, 5, 7
    .byte 6, 6, 7, 5, 6, 7, 8, 6, 4, 6, 7, 5, 5, 7, 7, 6
    .byte 6, 7, 7, 6, 7, 7, 6, 4, 7, 7, 6, 5, 5, 7, 6
    .byte 6, 6, 8, 6, 6, 7, 7, 5, 7, 7, 6, 6, 6, 7, 6, 5
    .byte 7, 6, 7, 7, 7, 7, 7, 6, 6, 7, 5, 5, 5, 7, 7
    .byte 6, 5, 6, 7, 6, 6, 7, 7, 6, 6, 6, 7, 7, 7, 5
    .byte 7, 7, 4, 8, 6, 6, 4, 5, 6, 6, 8, 6, 5, 7, 5, 7
    .byte 6, 6, 6, 4, 6, 5, 6, 7, 6, 5, 7, 6, 7, 6, 7
    .byte 7, 6, 5, 7, 6, 7, 7, 7, 8, 6, 7, 6, 7, 7, 7, 7
    .byte 6, 7, 7, 6, 6, 7, 7, 6, 8, 7, 7, 5, 7, 7, 6, 6
    .byte 6, 7, 6, 7, 7, 6, 6, 7, 4, 7, 5, 7, 7, 7, 7
    .byte 6, 6, 7, 6, 5, 5, 7, 6, 7, 6, 6, 7, 5, 6, 5
    .byte 6, 6, 7, 6, 5, 5, 6, 6, 5, 6, 7, 7, 7, 5, 6
    .byte 6, 6, 7, 7, 6, 6, 6, 7, 7, 6, 6, 8, 6, 6, 6, 6
    .byte 6, 7, 7, 6, 7, 6, 6, 7, 7, 7, 5, 7, 6, 7, 8, 7
    .byte 5, 6, 6, 7, 5, 6, 6, 7, 7, 6, 8, 5, 7, 7, 6, 7
    .byte 6, 6, 7, 8, 8, 6, 6, 6, 7, 6, 6, 6, 6, 3, 6, 6
    .byte 7, 7, 7, 7, 5, 7, 7, 6, 6, 3, 6, 5, 7, 6, 7
    .byte 5, 6, 8, 7, 6, 7, 5, 6, 4, 7, 5, 6, 6, 6, 7, 7
    .byte 7, 7, 7, 6, 8, 6, 8, 6, 6, 7, 6, 7, 6, 4, 7, 6
    .byte 7, 6, 7, 7, 5, 6, 5, 7, 5, 7, 7, 6, 6, 7, 7
    .byte 6, 7, 7, 6, 7, 7, 7, 6, 6, 7, 5, 7, 6, 4, 6
    .byte 7, 6, 7, 6, 7, 6, 6, 7, 7, 6, 4, 8, 7, 5, 4, 6
    .byte 6, 7, 6, 4, 6, 7, 7, 5, 6, 6, 7, 5, 7, 7, 7
    .byte 7, 6, 7, 8, 8, 6, 5, 6, 6, 7, 7, 7, 7, 6, 6, 7
    .byte 7, 7, 7, 5, 7, 5, 7, 7, 5, 7, 7, 6, 6, 6, 6
    .byte 6, 6, 7, 7, 8, 5, 6, 6, 7, 7, 6, 7, 6, 6, 6, 7
    .byte 7, 7, 4, 6, 6, 6, 7, 6, 5, 6, 7, 6, 6, 5, 7
    .byte 6, 6, 6, 7, 4, 5, 6, 7, 6, 5, 6, 7, 7, 5, 5
    .byte 6, 5, 7, 7, 7, 7, 7, 6, 7, 7, 6, 7, 6, 7, 7
    .byte 7, 6, 6, 6, 6, 7, 7, 7, 6, 5, 6, 6, 7, 7, 6
    .byte 6, 6, 7, 6, 6, 5, 7, 8, 6, 7, 7, 6, 7, 7, 7, 7
    .byte 6, 6, 7, 6, 6, 7, 7, 7, 4, 7, 6, 6, 6, 6, 6
    .byte 4, 7, 6, 6, 6, 6, 7, 7, 6, 6, 3, 6, 5, 4, 6
    .byte 7, 5, 7, 6, 5, 7, 6, 7, 5, 6, 6, 7, 7, 6, 6
    .byte 6, 8, 6, 6, 7, 7, 7, 7, 7, 6, 7, 7, 6, 6, 7, 8
    .byte 6, 7, 6, 6, 7, 7, 6, 5, 6, 5, 5, 6, 6, 7, 5
    .byte 7, 6, 6, 7, 6, 7, 6, 6, 7, 6, 6, 6, 6, 4, 5
    .byte 7, 7, 6, 6, 6, 5, 7, 6, 6, 6, 7, 6, 6, 7, 5
    .byte 5, 4, 5, 6, 6, 7, 6, 7, 6, 6, 7, 6, 6, 7, 7
    .byte 7, 7, 7, 7, 6, 6, 7, 7, 7, 7, 8, 5, 7, 8, 7, 7
    .byte 7, 6, 7, 6, 6, 6, 8, 6, 7, 7, 7, 5, 7, 6, 5, 6
    .byte 7, 7, 8, 6, 7, 6, 7, 4, 7, 6, 7, 5, 6, 6, 7, 5
    .byte 7, 7, 6, 7, 7, 6, 5, 4, 7, 6, 7, 7, 6, 8, 8, 6
    .byte 7, 7, 7, 4, 5, 7, 7, 5, 6, 6, 6, 7, 5, 6, 6
    .byte 6, 6, 7, 7, 7, 6, 6, 7, 6, 8, 5, 7, 6, 7, 7, 7
    .byte 7, 6, 7, 6, 6, 8, 6, 6, 6, 5, 7, 7, 6, 5, 5, 6
    .byte 7, 5, 6, 7, 7, 6, 7, 7, 6, 6, 7, 5, 5, 7, 7
    .byte 6, 6, 7, 6, 6, 6, 7, 6, 6, 5, 6, 6, 7, 6, 5
    .byte 7, 7, 4, 6, 6, 6, 5, 6, 6, 7, 7, 5, 6, 6, 7
    .byte 4, 7, 7, 6, 7, 7, 6, 6, 7, 8, 7, 7, 7, 7, 7, 7
    .byte 4, 7, 8, 7, 6, 7, 6, 7, 6, 6, 4, 7, 6, 6, 7, 7
    .byte 7, 6, 6, 6, 4, 7, 7, 6, 7, 5, 6, 7, 7, 8, 6, 4
    .byte 7, 7, 6, 6, 7, 7, 6, 5, 7, 6, 6, 7, 6, 7, 5
    .byte 7, 6, 6, 7, 5, 7, 5, 6, 6, 6, 6, 6, 7, 7, 6
    .byte 6, 5, 6, 7, 7, 7, 7, 7, 5, 7, 7, 7, 8, 7, 7, 7
    .byte 6, 6, 5, 7, 6, 7, 7, 7, 5, 7, 7, 6, 7, 6, 5
    .byte 6, 7, 7, 6, 6, 5, 7, 5, 7, 6, 7, 7, 7, 7, 6
    .byte 5, 6, 7, 7, 6, 7, 5, 6, 7, 6, 6, 7, 5, 5, 7
    .byte 7, 7, 7, 4, 6, 5, 6, 5, 5, 7, 7, 4, 6, 7, 7
    .byte 5, 5, 7, 7, 7, 4, 6, 7, 7, 6, 7, 7, 7, 7, 7
    .byte 6, 7, 6, 6, 7, 6, 7, 6, 7, 6, 7, 7, 7, 7, 7
    .byte 6, 8, 7, 6, 6, 6, 5, 6, 7, 7, 6, 7, 5, 7, 6, 6
    .byte 7, 7, 7, 6, 5, 7, 7, 7, 6, 7, 5, 5, 3, 7, 7
    .byte 7, 6, 5, 7, 6, 5, 6, 6, 5, 6, 7, 6, 4, 6, 7
    .byte 6, 6, 6, 5, 7, 7, 5, 7, 6, 7, 7, 6, 5, 6, 6
    .byte 7, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 6, 7, 7, 7
    .byte 6, 6, 7, 5, 6, 6, 6, 7, 6, 7, 8, 7
    .byte 3, 7, 5, 7, 6, 7, 6, 6, 6, 6, 7, 6, 8, 7, 6, 7
    .byte 6, 7, 5, 5, 6, 6, 3, 6, 7, 6, 6, 6, 5, 7, 5
    .byte 6, 6, 7, 7, 5, 6, 6, 5, 6, 6, 7, 6, 6, 5, 6
    .byte 5, 7, 7, 7, 5, 4, 6, 6, 7, 6, 7, 6, 6, 6, 6
    .byte 7, 7, 7, 6, 6, 7, 7, 7, 5, 7, 6, 5, 6, 7, 7
    .byte 7, 6, 6, 6, 7, 6, 5, 6, 6, 7, 5, 7, 5, 6, 6
    .byte 7, 6, 7, 8, 8, 7, 7, 7, 6, 6, 6, 6, 6, 5, 4, 7
    .byte 7, 7, 6, 7, 6, 7, 5, 6, 6, 7, 7, 5, 5, 6, 7
    .byte 6, 6, 5, 5, 6, 6, 5, 5, 7, 7, 5, 5, 6, 6, 7
    .byte 7, 7, 6, 6, 6, 7, 6, 5, 7, 7, 7, 7, 7, 6, 6
    .byte 6, 6, 6, 6, 6, 6, 7, 8, 6, 7, 5, 6, 6, 5, 7, 7
    .byte 6, 7, 7, 7, 4, 7, 7, 7, 7, 6, 7, 7, 6, 6, 5
    .byte 6, 6, 5, 7, 5, 6, 6, 8, 6, 5, 6, 6, 7, 6, 7, 7
    .byte 6, 4, 6, 6, 7, 7, 4, 6, 6, 6, 7, 6, 7, 6, 6
    .byte 5, 6, 7, 6, 7, 6, 7, 6, 7, 6, 6, 6, 7, 7, 8, 6
    .byte 8, 6, 7, 7, 7, 6, 6, 7, 7, 7, 7, 7, 5, 6, 5, 5
    .byte 6, 7, 7, 6, 7, 7, 5, 6, 6, 7, 7, 7, 5, 7, 7
    .byte 6, 6, 7, 6, 5, 6, 5, 7, 7, 5, 7, 6, 7, 7, 3
    .byte 7, 7, 6, 6, 6, 6, 6, 7, 7, 6, 5, 7, 7, 7, 5
    .byte 6, 6, 6, 6, 5, 6, 6, 5, 7, 7, 7, 7, 7, 8, 6, 6
    .byte 7, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 5
    .byte 7, 7, 4, 6, 6, 7, 7, 6, 6, 7, 7, 6, 6, 8, 6, 6
    .byte 7, 7, 7, 7, 6, 5, 8, 7, 4, 7, 6, 7, 3, 5, 6, 7
    .byte 8, 6, 6, 6, 6, 6, 5, 6, 6, 5, 5, 6, 7, 7, 6, 4
    .byte 7, 6, 6, 7, 7, 6, 6, 6, 6, 7, 5, 5, 7, 7, 6
    .byte 7, 7, 5, 7, 7, 7, 7, 6, 7, 6, 8, 7, 5, 7, 6, 7
    .byte 7, 6, 5, 7, 5, 7, 5, 6, 5, 6, 6, 6, 7, 6, 6
    .byte 7, 7, 7, 6, 7, 7, 7, 7, 7, 5, 7, 7, 6, 6, 5
    .byte 7, 4, 6, 6, 7, 6, 6, 7, 6, 7, 6, 6, 6, 3, 7
    .byte 6, 6, 5, 7, 4, 7, 7, 7, 6, 7, 6, 6, 5, 7, 7
    .byte 7, 7, 7, 7, 5, 8, 7, 7, 7, 7, 6, 6, 7, 7, 7, 7
    .byte 7, 7, 6, 7, 6, 6, 5, 6, 6, 6, 7, 7, 7, 6, 6
    .byte 7, 7, 6, 6, 5, 7, 6, 6, 6, 8, 6, 7, 7, 7, 5, 5
    .byte 5, 6, 5, 6, 5, 6, 6, 4, 6, 6, 7, 6, 7, 7, 6
    .byte 6, 7, 6, 6, 6, 6, 6, 7, 6, 5, 7, 7, 5, 7, 5
    .byte 6, 5, 7, 5, 5, 7, 6, 6, 8, 7, 7, 6, 6, 7, 5, 7
    .byte 7, 7, 7, 7, 7, 7, 4, 7, 7, 7, 5, 6, 7, 4, 6
    .byte 6, 7, 6, 7, 6, 7, 6, 7, 7, 6, 6, 6, 6, 6, 7
    .byte 6, 6, 6, 7, 5, 7, 6, 4, 5, 7, 6, 6, 5, 7, 6
    .byte 6, 7, 7, 5, 5, 7, 7, 6, 4, 6, 7, 8, 6, 7, 7, 6
    .byte 6, 7, 6, 6, 6, 5, 7, 6, 6, 7, 7, 7, 6, 6, 7
    .byte 7, 7, 7, 8, 7, 5, 6, 6, 6, 5, 7, 6, 5, 7, 6, 6
    .byte 6, 7, 6, 6, 7, 6, 7, 6, 7, 6, 5, 6, 6, 5, 7
    .byte 7, 7, 7, 8, 7, 7, 4, 7, 4, 5, 6, 6, 6, 6, 6, 6
    .byte 7, 7, 5, 7, 6, 6, 5, 5, 7, 6, 7, 3, 7, 7, 6
    .byte 5, 6, 6, 7, 7, 7, 6, 5, 6, 6, 7, 7, 7, 6, 8, 7
    .byte 7, 7, 6, 7, 6, 7, 7, 7, 7, 6, 7, 7, 6, 6, 6
    .byte 7, 7, 6, 7, 6, 7, 7, 6, 6, 7, 6, 5, 4, 7, 7
    .byte 4, 7, 7, 7, 7, 7, 8, 6, 7, 7, 6, 6, 6, 6, 5, 5
    .byte 7, 7, 6, 7, 7, 6, 7, 4, 7, 7, 6, 6, 5, 6, 4
    .byte 7, 5, 5, 6, 7, 4, 7, 7, 7, 6, 7, 5, 7, 6, 7
    .byte 6, 8, 7, 6, 7, 7, 7, 6, 7, 7, 7, 7, 6, 7, 6, 7
    .byte 6, 6, 5, 7, 7, 6, 7, 6, 7, 7, 6, 5, 7, 7, 6
    .byte 7, 6, 7, 5, 7, 6, 6, 6, 6, 7, 7, 7, 7, 7, 6
    .byte 6, 2, 6, 6, 7, 6, 7, 7, 6, 7, 7, 5, 7, 5, 6
    .byte 7, 5, 7, 5, 7, 6, 6, 7, 6, 6, 5, 6, 7, 6, 5
    .byte 6, 7, 4, 7, 7, 7, 7, 6, 6, 7, 6, 7, 5, 6, 7
    .byte 6, 7, 7, 7, 6, 7, 6, 7, 6, 5, 6, 6, 5, 6, 7
    .byte 6, 7, 6, 5, 6, 5, 6, 6, 6, 6, 6, 7, 6, 7, 8, 6
    .byte 7, 7, 7, 5, 7, 7, 7, 5, 6, 6, 7, 6, 5, 7, 7
    .byte 7, 6, 5, 5, 6, 5, 4, 6, 6, 6, 7, 6, 6, 7, 6
    .byte 3, 6, 6, 8, 6, 7, 7, 7, 5, 7, 7, 7, 6, 6, 6, 7
    .byte 7, 6, 6, 6, 6, 7, 7, 8, 6, 7, 6, 7, 6, 7, 6, 5
    .byte 6, 5, 8, 7, 6, 7, 7, 6, 6, 6, 6, 7, 6, 7, 7, 8
    .byte 6, 6, 6, 7, 7, 6, 7, 5, 6, 5, 7, 6, 6, 4, 6
    .byte 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 6, 6, 7, 6, 7
    .byte 5, 4, 6, 5, 5, 5, 6, 6, 7, 5, 6, 7, 6, 7, 6
    .byte 7, 6, 7, 6, 7, 6, 7, 7, 7, 5, 7, 7, 7, 7, 6
    .byte 7, 7, 6, 5, 6, 7, 8, 5, 8, 7, 7, 7, 7, 7, 4, 5
    .byte 4, 6, 7, 5, 8, 6, 6, 7, 6, 7, 5, 7, 6, 7, 7, 6
    .byte 5, 7, 6, 4, 6, 7, 6, 6, 6, 6, 6, 7, 6, 6, 7
    .byte 7, 5, 7, 6, 5, 4, 5, 5, 6, 6, 7, 6, 7, 6, 5
    .byte 7, 6, 6, 6, 7, 7, 7, 7, 6, 7, 7, 7, 6, 7, 7
    .byte 7, 5, 7, 7, 6, 6, 7, 6, 7, 6, 6, 6, 7, 6, 6
    .byte 7, 6, 6, 7, 6, 6, 6, 7, 7, 7, 7, 7, 6, 7, 5
    .byte 6, 5, 7, 5, 5, 7, 8, 4, 6, 7, 7, 7, 7, 6, 4, 5
    .byte 6, 6, 6, 6, 7, 8, 8, 5, 7, 6, 7, 4, 6, 7, 6, 6
    .byte 6, 7, 6, 5, 7, 6, 7, 7, 7, 6, 7, 7, 7, 7, 6
    .byte 7, 7, 8, 7, 7, 5, 7, 5, 6, 6, 7, 7, 6, 5, 7, 6
    .byte 7, 7, 6, 7, 7, 6, 6, 6, 6, 6, 8, 7, 7, 8, 7, 7
    .byte 7, 7, 7, 6, 5, 7, 7, 6, 7, 7, 8, 3, 7, 7, 7, 6
    .byte 6, 6, 4, 8, 7, 5, 7, 5, 7, 7, 7, 6, 4, 6, 6, 6
    .byte 7, 6, 7, 6, 7, 7, 8, 6, 7, 6, 5, 5, 5, 7, 6, 7
    .byte 6, 6, 6, 5, 7, 6, 6, 7, 6, 6, 6, 7, 6, 7, 7
    .byte 7, 6, 7, 8, 7, 7, 6, 7, 6, 6, 6, 7, 6, 7, 7, 7
    .byte 5, 7, 4, 6, 4, 5, 7, 7, 6, 5, 5, 6, 6, 6, 7
    .byte 5, 7, 6, 6, 7, 6, 7, 5, 5, 7, 6, 7, 6, 5, 7
    .byte 6, 6, 5, 6, 7, 7, 7, 6, 8, 6, 7, 7, 6, 6, 4, 6
    .byte 5, 7, 7, 6, 7, 6, 7, 6, 6, 7, 6, 7, 7, 7, 7
    .byte 7, 7, 6, 7, 7, 6, 7, 7, 7, 7, 6, 7, 7, 7, 7
    .byte 6, 6, 7, 7, 6, 5, 6, 4, 6, 4, 6, 6, 7, 6, 4
    .byte 6, 7, 6, 6, 6, 6, 6, 7, 5, 7, 7, 7, 5, 5, 7
    .byte 7, 6, 7, 5, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7
    .byte 7, 6, 7, 7, 5, 6, 5, 7, 7, 7, 6, 7, 7, 5, 6
    .byte 7, 7, 6, 7, 6, 7, 7, 7, 6, 7, 7, 6, 7, 7, 7
    .byte 7, 6, 6, 7, 7, 6, 7, 7, 7, 7, 7, 4, 7, 3, 5
    .byte 5, 5, 6, 8, 6, 4, 6, 7, 7, 6, 7, 6, 6, 6, 6, 6
    .byte 7, 8, 4, 5, 7, 6, 6, 7, 4, 7, 7, 6, 6, 6, 7, 7
    .byte 6, 7, 7, 7, 8, 7, 7, 6, 5, 6, 4, 7, 6, 7, 7, 7
    .byte 7, 5, 7, 7, 7, 7, 7, 7, 7, 6, 7, 6, 7, 7, 5
    .byte 8, 8, 6, 7, 5, 6, 6, 7, 7, 6, 7, 6, 7, 7, 5, 6
    .byte 4, 6, 5, 6, 6, 7, 5, 5, 5, 7, 6, 7, 7, 6, 6
    .byte 6, 6, 6, 6, 7, 5, 4, 7, 6, 6, 7, 5, 7, 7, 6
    .byte 6, 7, 7, 8, 6, 7, 7, 6, 8, 7, 7, 6, 6, 6, 6, 6
    .byte 6, 6, 7, 7, 5, 6, 6, 6, 6, 7, 6, 6, 6, 7, 7
    .byte 7, 8, 6, 7, 7, 7, 6, 6, 7, 7, 6, 7, 8, 6, 2, 7
    .byte 6, 6, 7, 5, 6, 7, 7, 6, 6, 6, 7, 6, 6, 6, 7
    .byte 6, 4, 6, 7, 6, 5, 5, 7, 6, 6, 7, 6, 7, 6, 6
    .byte 7, 7, 5, 5, 6, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6
    .byte 6, 7, 6, 6, 6, 7, 6, 6, 6, 7, 7, 6, 6, 6, 6
    .byte 6, 5, 7, 6, 7, 6, 6, 6, 7, 7, 6, 7, 4, 8, 7, 7
    .byte 7, 7, 7, 6, 5, 6, 7, 5, 6, 7, 6, 6, 6, 4, 7
    .byte 7, 6, 5, 5, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 6
    .byte 6, 6, 6, 3, 7, 5, 6, 6, 7, 6, 8, 6, 7, 6, 7, 7
    .byte 6, 7, 6, 5, 6, 6, 6, 7, 6, 6, 7, 7, 6, 7, 7
    .byte 7, 7, 5, 6, 7, 6, 6, 7, 7, 7, 7, 7, 7, 6, 6
    .byte 7, 6, 7, 7, 7, 7, 8, 7, 6, 5, 6, 6, 6, 7, 7, 4
    .byte 7, 6, 6, 5, 6, 5, 7, 6, 4, 7, 6, 7, 6, 7, 7
    .byte 4, 7, 7, 6, 7, 7, 5, 5, 7, 7, 7, 6, 5, 6, 7
    .byte 8, 8, 6, 6, 6, 6, 7, 6, 5, 5, 7, 6, 7, 6, 7, 4
    .byte 5, 7, 7, 6, 5, 8, 6, 7, 6, 7, 6, 7, 7, 7, 7, 7
    .byte 7, 7, 6, 7, 5, 7, 7, 7, 7, 6, 7, 5, 4, 6, 7
    .byte 5, 6, 7, 5, 5, 6, 5, 6, 6, 4, 7, 7, 6, 6, 6
    .byte 7, 5, 6, 5, 6, 7, 7, 6, 6, 7, 6, 5, 5, 7, 6
    .byte 6, 6, 6, 6, 7, 7, 6, 7, 7, 6, 8, 6, 6, 5, 5, 7
    .byte 7, 7, 6, 6, 7, 8, 5, 7, 6, 6, 6, 6, 6, 7, 7, 7
    .byte 7, 6, 7, 6, 6, 6, 7, 6, 7, 7, 6, 5, 7, 7, 5
    .byte 3, 7, 6, 6, 6, 6, 5, 7, 6, 6, 6, 6, 7, 6, 7
    .byte 7, 7, 5, 5, 7, 7, 6, 6, 5, 6, 7, 6, 7, 5, 8, 7
    .byte 6, 7, 7, 5, 4, 5, 7, 7, 7, 7, 6, 6, 7, 8, 7, 6
    .byte 6, 6, 6, 6, 7, 5, 7, 6, 6, 7, 6, 7, 7, 5, 5
    .byte 7, 5, 6, 7, 6, 7, 7, 6, 6, 7, 7, 6, 7, 7, 6
    .byte 7, 6, 7, 7, 6, 6, 6, 5, 6, 6, 7, 4, 7, 6, 6
    .byte 4, 7, 6, 8, 6, 5, 8, 7, 7, 7, 7, 7, 4, 7, 7, 7
    .byte 7, 8, 6, 6, 7, 7, 6, 6, 4, 6, 6, 7, 7, 5, 7, 7
    .byte 7, 7, 5, 6, 6, 7, 5, 7, 6, 7, 5, 4, 7, 8, 6, 6
    .byte 7, 7, 7, 6, 7, 6, 6, 7, 7, 7, 7, 7, 6, 7, 6
    .byte 6, 6, 7, 7, 7, 6, 6, 6, 4, 7, 6, 4, 7, 7, 6
    .byte 5, 6, 4, 6, 6, 5, 7, 7, 5, 7, 7, 8, 5, 6, 5, 6
    .byte 8, 7, 7, 7, 8, 5, 5, 6, 7, 6, 6, 6, 6, 6, 7, 7
    .byte 7, 6, 7, 6, 7, 7, 7, 5, 7, 6, 6, 6, 7, 6, 5
    .byte 7, 6, 6, 7, 6, 6, 7, 6, 6, 7, 6, 7, 7, 7, 5
    .byte 6, 8, 7, 7, 5, 7, 7, 7, 7, 7, 6, 7, 5, 6, 7, 6
    .byte 5, 6, 6, 6, 5, 4, 6, 7, 6, 6, 6, 7, 6, 7, 5
    .byte 6, 6, 6, 6, 6, 6, 7, 7, 7, 6, 4, 7, 5, 5, 6
    .byte 6, 6, 6, 7, 8, 7, 7, 7, 5, 7, 6, 7, 6, 6, 6, 7
    .byte 7, 6, 5, 8, 7, 6, 7, 7, 6, 6, 6, 6, 7, 6, 7, 6
    .byte 6, 8, 6, 7, 7, 8, 7, 7, 7, 7, 6, 6, 8, 6, 3, 7
    .byte 5
    .byte 5, 7, 6, 6, 6, 6, 6, 6, 5, 7, 5, 7, 6, 7, 5
    .byte 5, 7, 7, 5, 5, 4, 7, 6, 7, 7, 6, 7, 6, 5, 7
    .byte 6, 5, 5, 7, 7, 7, 7, 7, 7, 7, 7, 6, 7, 6, 6
    .byte 7, 6, 6, 5, 7, 6, 6, 6, 7, 7, 7, 7, 5, 6, 5
    .byte 6, 7, 6, 6, 7, 6, 6, 6, 7, 7, 7, 5, 7, 7, 7
    .byte 7, 6, 7, 7, 4, 6, 7, 6, 6, 6, 6, 6, 5, 4, 6
    .byte 6, 6, 5, 6, 7, 6, 7, 6, 6, 5, 5, 6, 7, 6, 7
    .byte 7, 6, 6, 4, 6, 4, 6, 5, 6, 6, 6, 7, 7, 5, 6
    .byte 6, 7, 6, 6, 6, 6, 7, 5, 7, 6, 7, 5, 5, 7, 7
    .byte 7, 6, 8, 7, 7, 6, 6, 7, 7, 7, 6, 7, 7, 7, 7, 6
    .byte 7, 6, 6, 6, 7, 6, 6, 7, 6, 4, 6, 7, 5, 6, 7
    .byte 6, 5, 6, 4, 7, 7, 5, 7, 6, 5, 6, 7, 7, 6, 5
    .byte 5, 5, 7, 7, 7, 6, 7, 6, 4, 6, 6, 7, 6, 6, 6
    .byte 8, 7, 7, 7, 7, 7, 6, 7, 7, 6, 5, 6, 6, 7, 6, 6
    .byte 6, 7, 6, 7, 6, 7, 7, 5, 6, 7, 6, 7, 7, 6, 7
    .byte 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 7, 7, 7, 5, 6, 6
    .byte 6, 7, 7, 8, 3, 7, 6, 5, 5, 6, 6, 7, 7, 5, 8, 7
    .byte 7, 7, 6, 6, 3, 7, 7, 7, 7, 8, 6, 5, 7, 6, 7, 6
    .byte 5, 5, 6, 6, 7, 7, 7, 8, 6, 7, 7, 7, 5, 6, 6, 6
    .byte 7, 5, 6, 8, 7, 6, 7, 7, 6, 5, 7, 7, 7, 6, 7, 7
    .byte 7, 7, 5, 6, 7, 8, 7, 6, 6, 7, 6, 7, 7, 6, 3, 6
    .byte 6, 6, 7, 6, 6, 7, 7, 5, 5, 6, 7, 6, 6, 7, 7
    .byte 6, 5, 6, 6, 6, 6, 5, 7, 6, 7, 7, 6, 7, 6, 6
    .byte 7, 6, 4, 5, 5, 7, 7, 7, 6, 7, 6, 7, 7, 6, 6
    .byte 6, 7, 6, 6, 5, 7, 5, 5, 7, 7, 6, 6, 8, 7, 6, 5
    .byte 7, 7, 6, 6, 7, 8, 7, 7, 7, 6, 7, 6, 7, 7, 6, 6
    .byte 5, 7, 6, 3, 6, 7, 5, 7, 7, 6, 4, 5, 5, 6, 6
    .byte 5, 6, 7, 6, 6, 7, 7, 6, 6, 4, 6, 7, 8, 6, 7, 7
    .byte 6, 5, 6, 6, 6, 5, 6, 6, 7, 6, 7, 7, 7, 7, 6
    .byte 7, 6, 6, 6, 6, 5, 6, 6, 6, 7, 7, 5, 7, 7, 7
    .byte 7, 4, 6, 7, 6, 6, 7, 7, 7, 8, 7, 7, 7, 7, 7, 6
    .byte 6, 7, 7, 7, 7, 7, 6, 6, 5, 6, 7, 7, 8, 4, 6, 5
    .byte 6, 5, 7, 5, 7, 7, 5, 7, 6, 6, 7, 6, 6, 4, 7
    .byte 7, 6, 6, 7, 6, 5, 7, 7, 6, 5, 5, 6, 7, 7, 8, 7
    .byte 7, 6, 7, 7, 7, 6, 6, 7, 7, 5, 6, 6, 7, 6, 7
    .byte 7, 6, 7, 7, 5, 6, 5, 6, 6, 5, 7, 6, 7, 6, 7
    .byte 7, 7, 7, 5, 7, 6, 6, 7, 7, 7, 7, 5, 7, 6, 6
    .byte 6, 6, 7, 6, 6, 3, 7, 7, 7, 6, 5, 6, 7, 7, 6
    .byte 5, 6, 6, 6, 7, 7, 7, 7, 7, 5, 4, 7, 5, 6, 6
    .byte 6, 5, 5, 5, 7, 6, 7, 6, 6, 8, 4, 6, 6, 6, 6, 6
    .byte 6, 7, 6, 5, 7, 7, 5, 7, 7, 7, 6, 6, 6, 6, 7
    .byte 7, 6, 7, 7, 7, 7, 6, 6, 7, 7, 6, 3, 6, 6, 7
    .byte 7, 6, 7, 6, 7, 6, 5, 7, 7, 6, 7, 6, 7, 6, 6
    .byte 6, 6, 6, 8, 6, 6, 5, 5, 6, 6, 6, 5, 7, 5, 6, 6
    .byte 8, 6, 6, 7, 7, 6, 5, 5, 7, 5, 7, 7, 7, 7, 5, 7
    .byte 7, 6, 5, 7, 6, 6, 7, 6, 6, 7, 7, 7, 7, 5, 7
    .byte 6, 7, 6, 5, 6, 6, 6, 8, 6, 7, 7, 4, 6, 4, 5, 6
    .byte 7, 6, 6, 6, 7, 7, 7, 6, 7, 6, 7, 6, 6, 6, 7
    .byte 8, 6, 6, 6, 7, 5, 6, 7, 6, 6, 6, 6, 5, 7, 5, 6
    .byte 6, 5, 6, 7, 7, 7, 6, 6, 2, 6, 6, 7, 6, 7, 7
    .byte 6, 7, 7, 7, 4, 6, 7, 5, 8, 7, 6, 7, 6, 6, 8, 6
    .byte 7, 5, 7, 7, 7, 7, 5, 6, 7, 6, 7, 6, 7, 5, 7
    .byte 7, 6, 6, 5, 6, 8, 7, 7, 6, 7, 6, 7, 7, 6, 7, 6
    .byte 7, 5, 6, 7, 5, 7, 6, 7, 7, 6, 5, 7, 7, 6, 7
    .byte 6, 6, 5, 6, 6, 6, 7, 6, 7, 6, 7, 6, 5, 3, 6
    .byte 6, 7, 7, 6, 7, 7, 5, 7, 6, 5, 6, 6, 6, 7, 6
    .byte 5, 7, 6, 7, 8, 7, 6, 6, 7, 6, 7, 7, 7, 6, 7, 7
    .byte 6, 6, 6, 6, 6, 3, 6, 6, 7, 5, 7, 7, 8, 7, 6, 6
    .byte 6, 5, 6, 7, 6, 6, 6, 6, 6, 7, 7, 7, 6, 7, 6
    .byte 6, 6, 7, 6, 7, 6, 4, 5, 7, 6, 7, 6, 6, 6, 7
    .byte 6, 6, 6, 5, 6, 5, 7, 7, 7, 6, 7, 7, 7, 6, 6
    .byte 4, 7, 5, 6, 6, 6, 6, 6, 7, 8, 6, 6, 6, 6, 6, 6
    .byte 7, 7, 7, 8, 7, 7, 7, 6, 3, 5, 7, 7, 7, 5, 6, 6
    .byte 8, 6, 6, 7, 7, 6, 6, 7, 6, 5, 7, 5, 7, 7, 7, 5
    .byte 8, 4, 7, 7, 6, 6, 6, 7, 6, 6, 6, 6, 6, 5, 7, 6
    .byte 8, 5, 6, 7, 7, 5, 5, 7, 7, 8, 5, 6, 5, 7, 7, 6
    .byte 7, 6, 4, 6, 6, 5, 6, 7, 7, 7, 7, 7, 4, 7, 7
    .byte 6, 5, 7, 7, 6, 6, 7, 7, 6, 4, 6, 6, 6, 5, 7
    .byte 6, 7, 8, 5, 7, 7, 7, 7, 5, 7, 6, 6, 7, 6, 6, 7
    .byte 7, 7, 7, 7, 6, 7, 6, 7, 4, 6, 6, 7, 6, 6, 6
    .byte 6, 6, 5, 7, 7, 7, 6, 5, 6, 6, 6, 7, 6, 4, 7
    .byte 7, 8, 6, 6, 7, 5, 6, 6, 7, 5, 7, 6, 6, 7, 7, 6
    .byte 6, 7, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 5, 6, 7
    .byte 6, 6, 4, 6, 7, 7, 6, 7, 6, 7, 6, 7, 7, 6, 6
    .byte 5, 6, 7, 7, 6, 6, 7, 7, 6, 7, 5, 7, 6, 6, 4
    .byte 6, 5, 7, 7, 5, 6, 6, 7, 5, 5, 7, 8, 3, 6, 6, 7
    .byte 7, 7, 7, 6, 5, 6, 7, 6, 5, 7, 7, 7, 6, 5, 6
    .byte 7, 7, 7, 6, 7, 5, 6, 6, 7, 6, 4, 8, 8, 7, 7, 6
    .byte 7, 6, 6, 6, 7, 3, 6, 6, 6, 7, 7, 6, 7, 7, 7
    .byte 8, 6, 7, 6, 7, 5, 5, 7, 7, 6, 6, 7, 7, 7, 8, 6
    .byte 7, 6, 5, 6, 8, 6, 5, 7, 6, 7, 6, 7, 7, 6, 7, 6
    .byte 6, 7, 6, 5, 6, 7, 5, 7, 7, 7, 7, 6, 5, 7, 6
    .byte 6, 5, 6, 6, 7, 7, 6, 7, 5, 7, 6, 6, 6, 7, 6
    .byte 6, 6, 7, 6, 6, 6, 6, 4, 6, 5, 6, 7, 7, 6, 4
    .byte 7, 7, 7, 6, 7, 6, 8, 7, 6, 6, 7, 6, 6, 7, 7, 7
    .byte 7, 4, 7, 7, 6, 6, 6, 5, 6, 6, 6, 5, 5, 6, 7
    .byte 7, 7, 7, 6, 6, 5, 7, 6, 6, 5, 6, 7, 6, 6, 7
    .byte 7, 6, 7, 7, 5, 7, 4, 7, 6, 5, 7, 7, 7, 5, 6
    .byte 7, 6, 5, 7, 7, 6, 7, 7, 5, 7, 6, 5, 4, 5, 6
    .byte 7, 7, 5, 7, 6, 7, 6, 7, 7, 7, 7, 7, 8, 7, 6, 7
    .byte 4, 6, 6, 8, 7, 6, 7, 7, 5, 7, 5, 5, 5, 6, 6, 4
    .byte 6, 7, 7, 6, 6, 7, 7, 7, 4, 7, 7, 7, 4, 7, 7
    .byte 8, 6, 8, 7, 5, 7, 6, 6, 6, 5, 5, 7, 4, 6, 7, 7
    .byte 7, 7, 7, 6, 6, 6, 6, 7, 7, 6, 7, 7, 6, 3, 7
    .byte 6, 6, 6, 6, 6, 6, 6, 5, 7, 7, 7, 6, 7, 7, 7
    .byte 7, 7, 5, 7, 7, 6, 5, 7, 6, 8, 7, 6, 7, 7, 5, 7
    .byte 7, 6, 6, 5, 7, 5, 6, 6, 6, 7, 6, 6, 5, 6, 7
    .byte 6, 6, 6, 6, 6, 7, 5, 7, 7, 6, 7, 7, 6, 6, 4
    .byte 6, 7, 6, 6, 7, 6, 6, 6, 7, 7, 6, 5, 7, 7, 6
    .byte 6, 6, 7, 7, 4, 6, 7, 7, 5, 4, 7, 7, 6, 6, 7
    .byte 7, 7, 7, 6, 7, 7, 7, 7, 7, 6, 6, 6, 6, 7, 7
    .byte 7, 7, 7, 7, 7, 4, 6, 5, 7, 6, 5, 6, 5, 7, 7
    .byte 6, 7, 7, 6, 4, 7, 6, 6, 7, 7, 6, 5, 6, 5, 5
    .byte 6, 6, 7, 8, 6, 6, 6, 5, 7, 6, 6, 7, 6, 7, 7, 7
    .byte 6, 6, 7, 7, 7, 6, 7, 7, 6, 7, 6, 7, 6, 7, 6
    .byte 6, 2, 6, 7, 6, 7, 7, 7, 6, 7, 7, 6, 7, 6, 6
    .byte 6, 7, 7, 7, 6, 5, 7, 6, 7, 6, 6, 5, 7, 8, 5, 7
    .byte 6, 7, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 7, 3
    .byte 8, 6, 7, 6, 5, 7, 5, 6, 6, 7, 5, 7, 7, 6, 7, 6
    .byte 7, 7, 7, 7, 6, 6, 6, 7, 7, 6, 7, 7, 7, 6, 6
    .byte 6, 6, 6, 5, 4, 4, 6, 6, 6, 6, 7, 7, 5, 7, 7
    .byte 6, 6, 6, 7, 7, 7, 6, 7, 7, 6, 7, 5, 6
    .byte 6, 7, 7, 6, 7, 6, 7, 6, 6, 7, 7, 6, 5, 7, 6
    .byte 6, 7, 7, 6, 6, 7, 6, 5, 5, 6, 6, 4, 6, 6, 7
    .byte 7, 7, 6, 6, 6, 6, 5, 7, 6, 6, 8, 6, 5, 7, 6, 8
    .byte 7, 6, 7, 5, 6, 6, 6, 7, 4, 8, 5, 6, 4, 6, 6, 7
    .byte 7, 7, 6, 7, 7, 7, 6, 8, 5, 7, 7, 7, 6, 7, 7, 6
    .byte 7, 6, 7, 8, 4, 7, 6, 7, 7, 5, 5, 6, 6, 7, 7, 6
    .byte 6, 6, 6, 7, 6, 5, 7, 6, 5, 7, 5, 7, 6, 7, 6
    .byte 6, 7, 6, 6, 4, 7, 8, 6, 6, 5, 7, 7, 7, 7, 7, 6
    .byte 7, 7, 7, 7, 6, 6, 6, 7, 7, 7, 6, 7, 6, 5, 4
    .byte 5, 6, 7, 7, 6, 8, 7, 6, 6, 6, 5, 6, 6, 6, 7, 6
    .byte 7, 7, 6, 6, 5, 6, 5, 6, 7, 7, 6, 5, 6, 7, 6
    .byte 6, 7, 5, 7, 6, 6, 6, 6, 6, 6, 6, 8, 3, 6, 7, 6
    .byte 7, 6, 7, 5, 6, 5, 6, 7, 7, 6, 6, 6, 7, 5, 6
    .byte 7, 6, 5, 7, 7, 7, 7, 7, 6, 7, 6, 4, 6, 6, 7
    .byte 5, 7, 7, 5, 6, 7, 7, 7, 7, 7, 5, 6, 7, 7, 7
    .byte 6, 6, 5, 7, 6, 7, 6, 5, 7, 7, 7, 5, 4, 5, 7
    .byte 8, 6, 6, 7, 6, 6, 7, 6, 6, 5, 5, 7, 5, 7, 6, 7
    .byte 6, 5, 5, 6, 7, 7, 5, 7, 7, 5, 7, 5, 7, 7, 8, 8
    .byte 6, 8, 3, 7, 7, 7, 7, 6, 7, 6, 7, 7, 5, 7, 6, 6
    .byte 6, 6, 5, 6, 7, 4, 6, 6, 7, 7, 7, 7, 7, 6, 5
    .byte 6, 7, 6, 7, 6, 7, 7, 6, 6, 6, 6, 7, 7, 7, 6
    .byte 3, 7, 7, 6, 6, 7, 6, 7, 7, 7, 6, 6, 5, 7, 6
    .byte 4, 6, 7, 7, 6, 6, 6, 6, 7, 7, 6, 7, 5, 5, 6
    .byte 7, 7, 7, 7, 7, 7, 8, 6, 4, 6, 6, 8, 6, 7, 7, 7
    .byte 6, 7, 6, 6, 6, 5, 5, 6, 7, 7, 3, 7, 7, 6, 7
    .byte 6, 6, 8, 6, 6, 6, 7, 7, 7, 6, 7, 6, 7, 7, 6, 6
    .byte 7, 6, 5, 7, 7, 6, 6, 5, 7, 7, 7, 7, 6, 5, 7
    .byte 4, 6, 5, 7, 7, 6, 6, 7, 4, 6, 6, 7, 7, 6, 7
    .byte 5, 6, 7, 7, 5, 7, 6, 8, 7, 7, 7, 7, 7, 6, 7, 7
    .byte 6, 7, 5, 7, 7, 7, 7, 3, 6, 7, 6, 6, 6, 6, 6
    .byte 6, 7, 7, 6, 6, 7, 8, 6, 6, 6, 6, 7, 6, 7, 7, 7
    .byte 7, 6, 7, 6, 7, 7, 5, 5, 5, 8, 6, 7, 7, 7, 6, 6
    .byte 7, 6, 5, 6, 6, 6, 6, 7, 5, 7, 7, 5, 7, 6, 6
    .byte 7, 6, 6, 4, 6, 6, 7, 6, 6, 6, 7, 6, 7, 7, 6
    .byte 6, 6, 6, 6, 5, 7, 7, 7, 7, 7, 7, 6, 7, 7, 6
    .byte 7, 5, 6, 7, 7, 5, 7, 7, 7, 4, 7, 6, 6, 6, 6
    .byte 7, 6, 7, 6, 4, 7, 5, 6, 6, 7, 7, 4, 7, 7, 6
    .byte 7, 6, 7, 7, 7, 7, 5, 7, 7, 6, 7, 6, 6, 7, 7
    .byte 7, 7, 6, 6, 7, 7, 5, 6, 6, 6, 5, 5, 7, 7, 6
    .byte 7, 7, 5, 6, 7, 5, 6, 6, 5, 6, 5, 7, 4, 7, 6
    .byte 6, 7, 7, 7, 6, 6, 5, 6, 7, 7, 7, 7, 6, 7, 6
    .byte 6, 6, 6, 6, 7, 7, 4, 7, 6, 6, 4, 6, 6, 7, 8, 6
    .byte 7, 7, 7, 6, 6, 7, 6, 6, 7, 7, 5, 6, 6, 6, 6
    .byte 6, 4, 7, 6, 7, 8, 5, 7, 4, 7, 7, 7, 6, 5, 6, 5
    .byte 8, 7, 6, 7, 7, 7, 6, 7, 6, 4, 7, 7, 7, 5, 5, 6
    .byte 7, 7, 5, 7, 7, 6, 7, 6, 6, 7, 6, 6, 7, 8, 6, 6
    .byte 6, 5, 7, 7, 6, 7, 5, 7, 5, 7, 7, 3, 6, 6, 6
    .byte 6, 7, 7, 7, 6, 6, 6, 7, 7, 6, 6, 7, 7, 6, 6
    .byte 6, 7, 7, 6, 7, 5, 6, 6, 7, 7, 6, 7, 5, 5, 7
    .byte 6, 5, 4, 7, 6, 6, 7, 7, 7, 7, 6, 7, 7, 6, 5
    .byte 6, 4, 7, 6, 7, 5, 7, 7, 7, 6, 7, 7, 7, 5, 6
    .byte 6, 8, 6, 7, 7, 6, 6, 7, 5, 5, 4, 6, 6, 6, 6, 7
    .byte 6, 4, 5, 6, 7, 5, 7, 8, 7, 7, 7, 5, 7, 7, 5, 7
    .byte 7, 7, 5, 7, 6, 7, 7, 6, 6, 7, 7, 6, 7, 6, 6
    .byte 5, 7, 6, 7, 5, 7, 5, 7, 7, 7, 5, 6, 6, 6, 6
    .byte 7, 7, 6, 7, 6, 7, 5, 7, 5, 6, 7, 7, 6, 7, 7
    .byte 6, 7, 8, 7, 7, 7, 6, 5, 3, 7, 5, 7, 5, 6, 7, 7
    .byte 6, 6, 6, 5, 6, 6, 5, 7, 7, 6, 5, 7, 6, 6, 7
    .byte 7, 7, 6, 6, 7, 6, 6, 6, 6, 7, 7, 7, 6, 4, 8, 7
    .byte 7, 7, 5, 5, 4, 7, 6, 6, 6, 6, 7, 7, 8, 6, 4, 7
    .byte 7, 7, 4, 7, 8, 6, 7, 7, 7, 5, 7, 7, 7, 6, 6, 7
    .byte 7, 7, 6, 7, 7, 6, 7, 6, 6, 6, 6, 4, 4, 7, 6
    .byte 7, 7, 6, 7, 7, 6, 5, 5, 5, 5, 7, 7, 6, 7, 7
    .byte 5, 7, 6, 7, 6, 7, 6, 6, 7, 7, 7, 7, 7, 6, 7
    .byte 7, 7, 7, 6, 7, 7, 7, 6, 5, 6, 7, 4, 6, 7, 7
    .byte 6, 6, 7, 6, 7, 7, 5, 7, 7, 6, 6, 7, 6, 6, 7
    .byte 6, 5, 4, 6, 7, 7, 8, 6, 7, 6, 7, 7, 6, 7, 6, 5
    .byte 6, 5, 6, 6, 7, 6, 5, 7, 7, 7, 4, 7, 6, 6, 5
    .byte 5, 6, 8, 8, 7, 7, 7, 7, 7, 6, 7, 6, 6, 7, 6, 5
    .byte 6, 7, 7, 7, 8, 6, 6, 7, 7, 6, 5, 5, 7, 5, 5, 6
    .byte 7, 6, 6, 7, 6, 7, 6, 7, 7, 5, 7, 6, 8, 7, 6, 7
    .byte 6, 6, 6, 6, 6, 7, 7, 7, 6, 7, 7, 7, 7, 6, 7
    .byte 7, 7, 6, 5, 5, 6, 7, 6, 6, 6, 6, 5, 5, 7, 5
    .byte 5, 5, 7, 6, 6, 7, 6, 7, 6, 8, 7, 5, 5, 6, 5, 6
    .byte 6, 7, 6, 7, 7, 7, 8, 6, 4, 7, 7, 8, 7, 6, 8, 5
    .byte 7
    .byte 8, 7, 5, 6, 8, 7, 6, 5, 5, 8, 6, 7, 6, 7, 7, 6
    .byte 7
    .byte 8, 7, 5, 5, 7, 7, 8, 6, 6, 8, 7, 7, 6, 8, 6, 6
    .byte 7
    .byte 7, 7, 5, 6, 6, 5, 7, 7, 7, 7, 6, 7, 5, 5, 5
    .byte 6, 6, 7, 6, 7, 6, 8, 6, 7, 6, 7, 7, 7, 7, 7, 8
    .byte 7, 5, 7, 7, 8, 6, 6, 6, 6, 6, 5, 7, 7, 5, 6, 5
    .byte 6, 5, 6, 7, 6, 6, 6, 7, 6, 7, 7, 7, 7, 7, 7
    .byte 6, 6, 7, 7, 7, 5, 6, 7, 7, 7, 6, 7, 4, 7, 7
    .byte 6, 7, 6, 7, 6, 7, 6, 4, 6, 6, 6, 6, 7, 6, 5
    .byte 6, 5, 5, 6, 5, 4, 7, 6, 6, 6, 7, 6, 6, 5, 7
    .byte 6, 7, 7, 6, 6, 7, 6, 6, 6, 7, 6, 6, 7, 7, 6
    .byte 7, 6, 6, 6, 6, 6, 6, 6, 6, 7, 5, 7, 7, 7, 6
    .byte 6, 7, 6, 7, 7, 7, 5, 7, 7, 6, 6, 6, 6, 6, 8, 7
    .byte 6, 7, 7, 7, 6, 6, 7, 7, 6, 7, 6, 4, 6, 6, 7
    .byte 5, 7, 7, 6, 5, 6, 6, 6, 6, 4, 6, 7, 7, 6, 6
    .byte 7, 7, 6, 7, 5, 7, 6, 6, 6, 6, 8, 5, 7, 7, 7, 6
    .byte 7, 6, 6, 6, 7, 7, 7, 6, 6, 5, 5, 5, 6, 6, 7
    .byte 6, 6, 6, 7, 5, 7, 7, 7, 7, 7, 7, 6, 6, 6, 5
    .byte 5, 6, 7, 6, 6, 6, 7, 7, 6, 6, 7, 6, 6, 6, 7
    .byte 7, 6, 4, 5, 6, 6, 6, 6, 7, 5, 7, 5, 7, 6, 6
    .byte 4, 4, 7, 7, 7, 7, 6, 7, 5, 6, 7, 7, 6, 6, 7
    .byte 7, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 7, 5, 6, 6
    .byte 7, 6, 5, 5, 6, 7, 5, 7, 7, 6, 7, 7, 7, 6, 6
    .byte 6, 6, 6, 7, 7, 6, 5, 7, 7, 7, 6, 5, 7, 6, 7
    .byte 6, 6, 6, 6, 7, 6, 5, 5, 6, 6, 7, 7, 6, 5, 7
    .byte 7, 5, 5, 6, 6, 6, 6, 7, 7, 5, 6, 7, 5, 7, 6
    .byte 6, 7, 7, 7, 5, 6, 7, 7, 7, 7, 7, 6, 6, 3, 7
    .byte 7, 6, 7, 6, 7, 5, 7, 7, 6, 6, 4, 7, 6, 8, 6, 7
    .byte 8, 6, 7, 6, 6, 7, 6, 6, 7, 7, 6, 7, 7, 7, 6, 5
    .byte 6, 6, 6, 7, 8, 7, 7, 6, 6, 7, 7, 6, 6, 6, 6, 7
    .byte 7, 6, 6, 6, 7, 7, 5, 6, 6, 7, 7, 6, 8, 6, 8, 7
    .byte 6, 6, 5, 7, 7, 7, 7, 6, 8, 7, 7, 8, 7, 6, 6, 6
    .byte 7, 6, 5, 5, 7, 5, 6, 7, 5, 7, 6, 7, 5, 5, 7
    .byte 7, 6, 5, 8, 7, 5, 7, 7, 6, 5, 6, 6, 5, 7, 6, 5
    .byte 7, 6, 4, 7, 7, 6, 7, 7, 7, 6, 6, 7, 6, 6, 5
    .byte 6, 8, 6, 7, 5, 7, 4, 4, 5, 5, 7, 5, 7, 7, 7, 5
    .byte 7, 7, 6, 6, 6, 6, 7, 6, 7, 6, 7, 7, 6, 7, 7
    .byte 7, 7, 7, 6, 7, 7, 6, 6, 6, 7, 7, 6, 4, 7, 6
    .byte 6, 5, 7, 7, 7, 7, 6, 6, 7, 6, 7, 6, 5, 6, 7
    .byte 6, 6, 7, 6, 6, 7, 7, 6, 6, 6, 7, 8, 7, 7, 5, 7
    .byte 7, 6, 5, 6, 7, 6, 5, 8, 6, 7, 3, 6, 5, 5, 6, 5
    .byte 6, 6, 5, 7, 7, 7, 6, 6, 6, 7, 7, 7, 7, 6, 7
    .byte 5, 6, 7, 7, 7, 6, 7, 6, 6, 7, 6, 6, 6, 6, 5
    .byte 7, 6, 7, 6, 7, 7, 7, 5, 6, 3, 7, 7, 7, 7, 5
    .byte 7, 5, 6, 7, 6, 4, 7, 7, 6, 7, 7, 6, 7, 6, 7
    .byte 6, 7, 7, 6, 7, 6, 6, 5, 7, 6, 6, 6, 7, 5, 6
    .byte 5, 6, 7, 6, 6, 5, 7, 6, 7, 4, 6, 8, 6, 6, 6, 6
    .byte 7, 7, 7, 6, 7, 6, 5, 6, 7, 7, 6, 7, 5, 7, 7
    .byte 6, 6, 6, 5, 7, 6, 6, 7, 6, 7, 6, 7, 5, 6, 4
    .byte 7, 6, 7, 7, 6, 7, 6, 5, 5, 7, 6, 6, 6, 6, 7
    .byte 6, 6, 5, 5, 7, 6, 7, 7, 8, 6, 6, 7, 6, 5, 6, 7
    .byte 4, 7, 7, 5, 6, 5, 6, 6, 7, 5, 6, 6, 6, 5, 7
    .byte 7, 7, 6, 6, 6, 6, 6, 6, 7, 7, 7, 5, 7, 6, 7
    .byte 6, 6, 6, 7, 6, 5, 6, 6, 6, 6, 7, 7, 6, 6, 6
    .byte 7, 7, 6, 6, 4, 7, 6, 7, 7, 6, 7, 5, 7, 7, 7
    .byte 6, 6, 6, 6, 7, 7, 6, 7, 5, 7, 6, 7, 7, 7
    .byte 7, 5, 7, 6, 7, 5, 6, 7, 6, 6, 4, 6, 7, 7, 5
    .byte 6, 6, 7, 7, 6, 6, 7, 7, 7, 6, 7, 4, 8, 7, 7, 8
    .byte 7, 7, 6, 7, 7, 7, 6, 5, 6, 7, 6, 6, 6, 4, 7
    .byte 6, 6, 7, 5, 8, 8, 6, 7, 7, 6, 4, 6, 7, 6, 6, 6
    .byte 8, 6, 7, 6, 5, 7, 7, 7, 6, 8, 6, 6, 5, 5, 6, 6
    .byte 8, 7, 7, 5, 7, 7, 6, 6, 7, 7, 6, 6, 5, 6, 6, 6
    .byte 6, 6, 7, 4, 6, 6, 4, 6, 7, 8, 7, 5, 6, 5, 8, 5
    .byte 7, 7, 7, 7, 6, 7, 6, 6, 6, 7, 4, 6, 6, 6, 5
    .byte 7, 6, 6, 6, 7, 7, 8, 7, 6, 5, 7, 6, 7, 7, 7, 7
    .byte 7, 6, 7, 6, 7, 4, 4, 7, 6, 6, 6, 5, 7, 7, 6
    .byte 6, 7, 5, 7, 5, 7, 7, 6, 6, 7, 7, 7, 7, 6, 6
    .byte 7, 7, 7, 6, 6, 6, 3, 7, 7, 7, 6, 6, 6, 6, 8, 6
    .byte 5, 7, 7, 7, 7, 6, 7, 7, 6, 6, 5, 8, 6, 6, 6, 5
    .byte 7, 5, 6, 6, 3, 8, 6, 6, 6, 7, 7, 6, 5, 6, 6, 6
    .byte 7, 7, 6, 6, 7, 7, 6, 6, 6, 6, 6, 5, 7, 5, 8, 7
    .byte 6, 6, 6, 6, 7, 5, 7, 4, 5, 6, 7, 6, 6, 7, 7
    .byte 5, 7, 7, 7, 6, 6, 5, 7, 7, 7, 5, 6, 7, 7, 7
    .byte 7, 7, 7, 6, 5, 7, 7, 7, 7, 6, 7, 4, 6, 6, 5
    .byte 6, 7, 7, 7, 6, 7, 7, 5, 6, 4, 6, 7, 7, 7, 5
    .byte 7, 6, 6, 6, 7, 6, 7, 8, 7, 7, 6, 7, 5, 7, 6, 5
    .byte 6, 6, 8, 7, 6, 7, 7, 7, 6, 6, 5, 5, 5, 7, 7, 7
    .byte 7, 7, 6, 7, 6, 7, 7, 6, 6, 6, 6, 6, 6, 6, 6
    .byte 7, 7, 7, 7, 6, 8, 6, 6, 6, 5, 7, 7, 7, 7, 6, 6
    .byte 3, 7, 7, 7, 6, 3, 7, 7, 5, 5, 7, 6, 5, 5, 8, 8
    .byte 6, 5, 7, 7, 7, 7, 6, 7, 8, 7, 6, 7, 7, 5, 5, 7
    .byte 6, 5, 6, 7, 6, 7, 6, 6, 6, 7, 7, 7, 7, 3, 6
    .byte 6, 7, 7, 6, 6, 7, 6, 7, 7, 7, 7, 6, 6, 6, 5
    .byte 7, 6, 4, 7, 7, 5, 7, 7, 7, 6, 6, 5, 7, 7, 6
    .byte 6, 7, 7, 6, 6, 6, 7, 6, 7, 4, 6, 6, 7, 6, 6
    .byte 7, 7, 6, 6, 7, 7, 7, 6, 6, 6, 7, 5, 5, 6, 7
    .byte 6, 6, 7, 6, 7, 6, 7, 6, 7, 7, 4, 7, 5, 6, 5
    .byte 4, 7, 7, 7, 7, 5, 7, 7, 6, 7, 7, 6, 6, 7, 7
    .byte 6, 7, 7, 6, 7, 6, 6, 7, 7, 6, 5, 5, 6, 6, 5
    .byte 7, 7, 6, 7, 7, 7, 6, 7, 6, 5, 6, 6, 6, 7, 7
    .byte 2, 7, 7, 6, 6, 6, 7, 7, 6, 7, 6, 4, 6, 5, 7
    .byte 6, 6, 7, 6, 6, 7, 7, 7, 6, 7, 7, 7, 8, 6, 6, 6
    .byte 6, 7, 7, 4, 6, 6, 7, 6, 7, 6, 6, 7, 7, 7, 7
    .byte 6, 7, 7, 6, 5, 7, 7, 7, 7, 7, 6, 8, 7, 6, 6, 6
    .byte 6, 6, 7, 5, 8, 8, 7, 7, 6, 5, 7, 6, 7, 5, 6, 6
    .byte 6, 7, 6, 6, 6, 4, 7, 4, 6, 7, 5, 5, 5, 7, 7
    .byte 7, 6, 7, 7, 7, 7, 7, 5, 7, 7, 5, 6, 6, 7, 6
    .byte 6, 7, 7, 6, 7, 6, 6, 6, 6, 5, 4, 6, 6, 7, 7
    .byte 7, 7, 6, 6, 8, 8, 7, 4, 6, 7, 7, 6, 7, 6, 8, 7
    .byte 6
    .byte 7, 6, 7, 4, 6, 6, 7, 6, 7, 7, 5, 6, 7, 5, 6
    .byte 6, 7, 6, 7, 6, 6, 8, 6, 4, 6, 6, 6, 6, 6, 7, 6
    .byte 7, 6, 5, 7, 7, 6, 6, 7, 7, 5, 6, 6, 6, 7, 7
    .byte 7, 7, 7, 7, 6, 6, 5, 6, 6, 7, 5, 7, 5, 6, 6
    .byte 5, 6, 7, 7, 6, 7, 7, 6, 7, 6, 7, 5, 7, 7, 7
    .byte 6, 6, 6, 7, 7, 5, 5, 6, 6, 6, 6, 6, 7, 7, 6
    .byte 7, 7, 6, 6, 6, 7, 5, 5, 7, 7, 6, 5, 6, 7, 5
    .byte 5, 7, 6, 5, 3, 6, 6, 6, 6, 7, 7, 5, 7, 7, 7
    .byte 6, 7, 6, 7, 7, 7, 6, 6, 7, 6, 4, 7, 7, 7, 6
    .byte 7, 7, 7, 6, 7, 5, 5, 7, 6, 6, 6, 6, 6, 6, 7
    .byte 6, 6, 7, 6, 6, 8, 7, 7, 6, 5, 5, 6, 7, 6, 6, 7
    .byte 7, 6, 6, 7, 6, 7, 6, 7, 6, 7, 4, 5, 6, 7, 6
    .byte 6, 7, 6, 6, 7, 7, 5, 7, 6, 6, 4, 6, 5, 6, 6
    .byte 7, 7, 7, 6, 7, 7, 6, 6, 6, 7, 7, 6, 7, 6, 6
    .byte 7, 6, 6, 7, 5, 7, 8, 7, 6, 6, 7, 7, 6, 7, 7, 6
    .byte 4, 7, 7, 5, 7, 8, 7, 7, 7, 7, 6, 7, 7, 4, 6, 6
    .byte 5, 7, 7, 6, 6, 7, 7, 6, 6, 7, 7, 7, 6, 7, 6
    .byte 7, 6, 5, 7, 5, 6, 6, 7, 6, 7, 6, 6, 6, 7, 4
    .byte 6, 6, 4, 6, 6, 8, 6, 8, 7, 7, 6, 6, 7, 6, 6, 5
    .byte 7, 8, 4, 6, 6, 6, 6, 7, 5, 8, 7, 4, 7, 6, 7, 6
    .byte 6, 6, 5, 5, 6, 6, 6, 7, 7, 7, 8, 7, 7, 6, 6, 5
    .byte 6, 5, 6, 7, 5, 7, 6, 7, 8, 6, 7, 6, 7, 8, 7, 7
    .byte 5, 7, 6, 6, 7, 6, 5, 6, 5, 6, 7, 6, 5, 5, 5
    .byte 4, 6, 6, 6, 6, 7, 7, 6, 7, 7, 6, 5, 7, 7, 7
    .byte 7, 6, 6, 6, 7, 6, 5, 6, 7, 6, 6, 6, 6, 6, 7
    .byte 6, 5, 5, 6, 7, 6, 6, 6, 5, 6, 6, 7, 7, 7, 7
    .byte 7, 7, 6, 5, 6, 7, 6, 5, 6, 7, 6, 6, 7, 6, 7
    .byte 7, 4, 7, 8, 7, 7, 6, 6, 6, 6, 5, 5, 6, 7, 5, 6
    .byte 6, 6, 4, 5, 6, 7, 7, 6, 7, 7, 5, 7, 5, 6, 6
    .byte 6, 7, 6, 7, 7, 7, 7, 6, 7, 7, 7, 5, 7, 6, 7
    .byte 7, 7, 3, 6, 7, 7, 4, 6, 6, 7, 5, 6, 6, 6, 7
    .byte 6, 7, 6, 7, 6, 7, 7, 7, 6, 5, 5, 6, 6, 7, 7
    .byte 6, 7, 7, 6, 8, 7, 5, 7, 5, 6, 4, 6, 6, 7, 6, 7
    .byte 6, 7, 5, 7, 5, 6, 6, 4, 6, 7, 5, 5, 6, 7, 6
    .byte 7, 6, 7, 6, 7, 6, 6, 5, 7, 7, 6, 6, 6, 7, 6
    .byte 6, 7, 6, 6, 6, 6, 5, 7, 5, 5, 5, 6, 6, 6, 7
    .byte 6, 5, 6, 6, 7, 7, 7, 6, 6, 7, 7, 5, 5, 7, 7
    .byte 7, 6, 7, 6, 7, 6, 6, 6, 7, 8, 7, 7, 5, 6, 6, 5
    .byte 6, 4, 7, 7, 7, 6, 7, 7, 3, 7, 7, 6, 5, 6, 7
    .byte 7, 5, 7, 7, 6, 7, 7, 6, 6, 6, 6, 7, 5, 6, 5
    .byte 7, 6, 7, 7, 7, 7, 6, 7, 7, 7, 7, 7, 5, 5, 5
    .byte 7, 6, 7, 6, 7, 5, 7, 6, 6, 7, 7, 8, 7, 7, 7, 6
    .byte 7, 6, 6, 5, 6, 7, 5, 7, 6, 7, 7, 7, 7, 8, 7, 7
    .byte 7, 7, 7, 5, 7, 6, 6, 7, 7, 6, 6, 7, 4, 7, 7
    .byte 7, 5, 6, 7, 7, 6, 5, 8, 8, 8, 7, 6, 7, 6, 4, 5
    .byte 6
    .byte 7, 6, 7, 6, 7, 7, 7, 5, 7, 7, 7, 6, 6, 6, 5
    .byte 5, 5, 6, 7, 7, 6, 6, 6, 6, 6, 5, 6, 7, 7, 6
    .byte 7, 5, 7, 6, 7, 7, 5, 4, 6, 6, 7, 7, 6, 7, 6
    .byte 6, 8, 7, 6, 6, 6, 7, 4, 5, 6, 6, 7, 7, 6, 7, 7
    .byte 4, 7, 7, 7, 6, 6, 7, 5, 5, 8, 7, 7, 5, 6, 6, 7
    .byte 6, 6, 7, 7, 7, 8, 7, 7, 4, 7, 7, 6, 5, 6, 6, 6
    .byte 7, 8, 4, 6, 7, 7, 6, 7, 5, 6, 6, 6, 6, 6, 5, 7
    .byte 7, 7, 7, 6, 7, 6, 6, 6, 7, 6, 6, 6, 8, 6, 4, 7
    .byte 7, 7, 7, 6, 5, 6, 7, 6, 6, 7, 5, 7, 6, 7, 6
    .byte 6, 5, 6, 6, 6, 6, 6, 6, 6, 3, 6, 7, 6, 7, 5
    .byte 7, 6, 7, 5, 7, 7, 7, 6, 7, 7, 7, 6, 6, 6, 4
    .byte 6, 6, 6, 8, 7, 6, 8, 6, 7, 4, 7, 6, 7, 6, 7, 5
    .byte 5, 7, 7, 6, 7, 6, 7, 7, 7, 6, 5, 7, 7, 4, 6
    .byte 6, 5, 8, 7, 7, 7, 8, 7, 5, 6, 6, 6, 7, 7, 7, 6
    .byte 7, 5, 6, 6, 7, 5, 6, 6, 6, 5, 7, 7, 3, 6, 6
    .byte 7, 7, 7, 7, 5, 6, 6, 6, 6, 7, 7, 6, 6, 7, 7
    .byte 6, 6, 6, 7, 6, 5, 6, 6, 7, 8, 5, 7, 5, 7, 6, 5
    .byte 7, 6, 6, 4, 6, 7, 7, 6, 7, 7, 8, 7, 5, 7, 7, 7
    .byte 6, 5, 7, 5, 8, 6, 6, 6, 7, 7, 7, 6, 6, 8, 6, 7
    .byte 7, 7, 6, 4, 7, 7, 6, 4, 6, 5, 7, 6, 7, 5, 7
    .byte 7, 7, 5, 7, 7, 7, 6, 6, 7, 5, 7, 7, 7, 7, 7
    .byte 7, 7, 7, 7, 5, 6, 5, 7, 7, 7, 7, 6, 5, 6, 7
    .byte 6, 7, 6, 7, 6, 6, 6, 5, 6, 6, 6, 7, 7, 6, 7
    .byte 6, 6, 6, 6, 6, 6, 5, 6, 6, 6, 5, 7, 6, 7, 7
    .byte 6, 7, 6, 7, 7, 6, 6, 6, 7, 7, 6, 6, 7, 5, 7
    .byte 6, 6, 7, 7, 5, 7, 5, 6, 5, 7, 5, 6, 6, 6, 7
    .byte 7, 7, 7, 7, 7, 7, 5, 6, 7, 5, 7, 7, 6, 6, 5
    .byte 7, 6, 6, 6, 6, 7, 6, 7, 6, 7, 5, 5, 7, 6, 5
    .byte 7, 6, 7, 6, 6, 6, 6, 8, 6, 7, 6, 7, 4, 7, 6, 6
    .byte 7, 5, 7, 6, 6, 6, 7, 6, 6, 8, 7, 6, 7, 7, 5, 4
    .byte 6, 6, 6, 6, 5, 6, 7, 5, 6, 7, 5, 6, 3, 6, 7
    .byte 6, 6, 6, 7, 6, 7, 7, 7, 7, 8, 5, 6, 6, 6, 7, 7
    .byte 5, 6, 7, 7, 6, 6, 6, 6, 6, 6, 6, 7, 7, 4, 6
    .byte 7, 6, 7, 7, 6, 6, 6, 6, 7, 6, 7, 6, 7, 7, 8, 6
    .byte 6, 6, 6, 7, 7, 5, 7, 6, 7, 7, 5, 7, 6, 6, 6
    .byte 6, 6, 3, 6, 6, 7, 7, 6, 6, 7, 6, 7, 7, 4, 6
    .byte 2, 6, 7, 5, 7, 7, 8, 6, 6, 7, 7, 6, 8, 7, 7, 6
    .byte 5, 6, 7, 7, 6, 6, 6, 5, 6, 7, 5, 7, 6, 7, 6
    .byte 6, 6, 6, 5, 7, 6, 7, 6, 7, 7, 6, 7, 7, 5, 7
    .byte 7, 6, 7, 7, 7, 5, 7, 7, 7, 5, 7, 6, 6, 8, 6, 7
    .byte 6, 7, 7, 7, 6, 7, 6, 6, 5, 7, 6, 6, 5, 7, 7
    .byte 4, 6, 6, 5, 5, 5, 7, 6, 6, 6, 6, 7, 6, 8
    .byte 6, 5, 7, 7, 6, 6, 6, 7, 7, 6, 7, 6, 5, 8, 6, 6
    .byte 6, 6, 7, 6, 7, 7, 6, 5, 6, 6, 6, 6, 6, 6, 8, 5
    .byte 6, 5, 7, 6, 6, 7, 7, 6, 6, 7, 6, 6, 7, 6, 5
    .byte 7, 7, 6, 7, 6, 7, 7, 7, 6, 6, 7, 7, 3, 6, 7
    .byte 7, 6, 1, 7, 7, 7, 7, 5, 7, 7, 7, 7, 7, 7, 7
    .byte 7, 7, 7, 7, 7, 7, 5, 7, 8, 7, 7, 7, 7, 7, 7, 6
    .byte 7, 7, 7, 7, 7, 6, 6, 7, 6, 6, 7, 6, 6, 7, 7
    .byte 7, 5, 7, 7, 7, 6, 6, 7, 6, 6, 7, 7, 6, 5, 7
    .byte 7, 7, 6, 6, 7, 6, 6, 7, 6, 6, 7, 7, 7, 7, 7
    .byte 7, 7, 6, 6, 7, 6, 6, 5, 4, 5, 7, 5, 6, 6, 6
    .byte 7, 4, 7, 6, 7, 6, 7, 7, 7, 8, 6, 6, 5, 7, 7, 7
    .byte 6, 6, 7, 6, 6, 7, 4, 7, 6, 6, 6, 7, 7, 5, 7
    .byte 6, 7, 4, 6, 6, 7, 6, 6, 7, 7, 7, 8, 7, 7, 6, 7
    .byte 6, 7, 7, 7, 5, 6, 6, 6, 7, 7, 6, 7, 7, 7, 7
    .byte 7, 6, 6, 5, 7, 6, 7, 6, 5, 6, 6, 5, 5, 6, 7
    .byte 5, 6, 7, 6, 5, 6, 7, 5, 7, 6, 7, 7, 7, 6, 5
    .byte 7, 6, 6, 6, 8, 6, 7, 7, 6, 7, 7, 6, 6, 6, 6, 7
    .byte 7, 6, 6, 6, 6, 7, 5, 7, 6, 5, 6, 7, 8, 5, 7, 7
    .byte 6, 7, 6, 7, 6, 7, 7, 6, 8, 6, 6, 6, 7, 6, 7, 7
    .byte 6, 6, 6, 7, 5, 6, 6, 6, 7, 5, 7, 7, 6, 5, 5
    .byte 5, 4, 6, 5, 6, 4, 6, 7, 6, 7, 6, 6, 7, 6, 7
    .byte 8, 7, 7, 6, 5, 7, 7, 7, 7, 7, 6, 7, 7, 6, 6, 7
    .byte 5, 7, 6, 7, 6, 6, 6, 5, 6, 6, 7, 6, 7, 7, 5
    .byte 7, 6, 6, 7, 7, 7, 7, 6, 7, 6, 6, 7, 6, 7, 7
    .byte 5, 6, 7, 6, 7, 6, 7, 6, 7, 6, 4, 6, 7, 7, 8, 7
    .byte 6, 4, 7, 4, 7, 5, 6, 5, 6, 4, 6, 6, 7, 7, 7
    .byte 7, 7, 6, 6, 5, 5, 7, 5, 7, 7, 6, 6, 7, 7, 5
    .byte 6, 6, 8, 7, 6, 7, 6, 6, 5, 5, 5, 7, 6, 6, 7, 7
    .byte 7, 6, 6, 7, 6, 7, 7, 6, 7, 7, 6, 6, 7, 6, 6
    .byte 5, 7, 7, 7, 6, 7, 6, 7, 7, 5, 7, 7, 6, 7, 5
    .byte 6, 4, 5, 7, 6, 6, 7, 6, 7, 5, 6, 4, 5, 5, 7
    .byte 5, 6, 6, 6, 7, 6, 7, 6, 5, 7, 6, 6, 6, 6, 7
    .byte 6, 8, 6, 7, 7, 7, 7, 6, 6, 7, 7, 7, 6, 5, 6, 7
    .byte 4, 6, 7, 8, 7, 6, 7, 6, 7, 7, 7, 7, 5, 7, 6, 7
    .byte 6, 7, 7, 6, 6, 7, 6, 6, 8, 5, 8, 7, 7, 7, 5, 7
    .byte 7, 7, 6, 6, 6, 6, 7, 6, 7, 4, 7, 6, 5, 5, 6
    .byte 6, 3, 5, 7, 6, 7, 7, 7, 7, 7, 7, 5, 7, 6, 6
    .byte 7, 6, 7, 7, 8, 5, 7, 7, 6, 6, 7, 6, 6, 7, 6, 6
    .byte 6, 6, 6, 5, 7, 7, 6, 7, 6, 6, 4, 8, 7, 7, 6, 6
    .byte 7, 7, 7, 7, 5, 7, 7, 5, 6, 6, 6, 7, 7, 7, 6
    .byte 7, 7, 4, 7, 7, 7, 6, 5, 7, 7, 7, 6, 6, 6, 6
    .byte 4, 6, 7, 6, 5, 6, 6, 6, 6, 7, 7, 6, 7, 7, 8, 6
    .byte 7, 4, 7, 6, 7, 7, 7, 7, 7, 5, 6, 6, 7, 6, 6
    .byte 6, 5, 7, 6, 6, 5, 6, 5, 5, 7, 7, 6, 6, 7, 6
    .byte 5, 6, 7, 6, 7, 6, 7, 7, 7, 7, 6, 7, 6, 5, 7
    .byte 7, 5, 5, 7, 7, 6, 5, 6, 6, 8, 7, 7, 6, 6, 6, 6
    .byte 7, 6, 5, 7, 6, 6, 6, 4, 7, 4, 4, 7, 7, 7, 6
    .byte 7, 6, 6, 7, 7, 7, 7, 7, 7, 5, 8, 6, 6, 6, 7, 6
    .byte 6, 6, 6, 7, 6, 7, 5, 5, 7, 5, 6, 5, 6, 7, 5
    .byte 7, 5, 7, 7, 7, 7, 6, 7, 7, 6, 6, 5, 5, 7, 7
    .byte 7, 6, 7, 7, 7, 5, 7, 6, 7, 7, 5, 7, 7, 7, 7
    .byte 6, 6, 5, 7, 6, 6, 6, 6, 6, 6, 5, 5, 7, 3, 6
    .byte 7, 6, 7, 7, 5, 7, 7, 7, 6, 7, 7, 6, 6, 6, 7
    .byte 6, 6, 6, 6, 7, 6, 7, 6, 6, 7, 6, 7, 5, 6, 5
    .byte 6, 7, 5, 6, 5, 6, 7, 6, 6, 7, 6, 6, 7, 7, 7
    .byte 5, 6, 6, 5, 6, 6, 5, 7, 8, 6, 7, 7, 6, 8, 6, 7
    .byte 6, 6, 7, 7, 7, 5, 6, 6, 7, 6, 7, 7, 7, 6, 6
    .byte 6, 5, 5, 5, 6, 6, 5, 6, 6, 7, 7, 5, 7, 6, 6
    .byte 6, 7, 6, 6, 7, 6, 7, 7, 6, 5, 7, 7, 6, 7, 6
    .byte 7, 7, 5, 5, 5, 6, 5, 6, 6, 5, 6, 7, 6, 7, 7
    .byte 7, 8, 7, 7, 7, 5, 6, 5, 6, 6, 6, 6, 7, 7, 6, 7
    .byte 7, 5, 8, 5, 7, 5, 7, 7, 6, 6, 6, 7, 5, 5, 6, 7
    .byte 6, 4, 7, 2, 7, 7, 7, 6, 5, 7, 7, 6, 7, 7, 6
    .byte 6, 6, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 6, 7, 7, 7
    .byte 6, 7, 7, 7, 7, 7, 7, 6, 6, 7, 6, 6, 6, 7, 7
    .byte 7, 6, 7, 7, 7, 8, 7, 7, 7, 4, 6, 7, 7, 5, 6, 6
    .byte 6, 7, 7, 6, 5, 7, 6, 7, 7, 7, 7, 7, 7, 6, 6
    .byte 6, 6, 6, 7, 7, 6, 7, 5, 7, 6, 6, 7, 7, 4, 6
    .byte 6, 6, 6, 7, 6, 5, 7, 7, 6, 7, 6, 7, 6, 7, 6
    .byte 6, 7, 6, 6, 6, 6, 7, 6, 5, 6, 6, 6, 7, 6, 7
    .byte 7, 7, 7, 7, 6, 5, 5, 5, 6, 6, 7, 6, 7, 6, 7
    .byte 7, 7, 6, 7, 4, 7, 7, 7, 7, 6, 6, 7, 7, 7, 6
    .byte 7, 5, 5, 6, 6, 7, 7, 7, 5, 7, 7, 7, 4, 6, 6
    .byte 7, 6, 7, 4, 7, 2, 7, 7, 7, 7, 6, 6, 7, 7, 7
    .byte 6, 7, 7, 6, 5, 6, 7, 6, 6, 6, 6, 7, 7, 7, 6
    .byte 5, 7, 7, 6, 7, 6, 6, 6, 7, 5, 6, 6, 6, 6, 5
    .byte 6, 8, 8, 7, 7, 8, 6, 6, 7, 7, 7, 6, 6, 6, 8, 6
    .byte 7
    .byte 7, 7, 7, 7, 7, 4, 7, 6, 6, 7, 5, 6, 7, 6, 6
    .byte 6, 7, 5, 6, 6, 7, 5, 6, 6, 6, 4, 7, 7, 7, 6
    .byte 7, 7, 6, 6, 7, 6, 7, 7, 7, 6, 7, 6, 6, 6, 6
    .byte 7, 6, 6, 6, 6, 6, 6, 6, 7, 5, 6, 7, 6, 7, 5
    .byte 6, 6, 5, 7, 5, 7, 6, 7, 7, 5, 7, 7, 7, 6, 5
    .byte 6, 6, 7, 6, 6, 7, 7, 7, 7, 7, 6, 7, 7, 5, 6
    .byte 5, 7, 5, 7, 6, 5, 6, 6, 5, 7, 7, 7, 5, 7, 6
    .byte 6, 4, 7, 6, 6, 7, 7, 7, 5, 7, 5, 5, 7, 6, 6
    .byte 7, 7, 4, 7, 6, 6, 5, 6, 6, 6, 7, 6, 7, 8, 6, 6
    .byte 8, 6, 5, 7, 7, 6, 4, 6, 7, 7, 7, 6, 7, 6, 7, 7
    .byte 8, 6, 8, 4, 5, 6, 7, 6, 7, 7, 7, 6, 7, 7, 6, 6
    .byte 6, 6, 4, 7, 6, 7, 6, 7, 7, 6, 6, 6, 6, 6, 6
    .byte 5, 6, 6, 6, 7, 6, 6, 8, 7, 7, 7, 6, 7, 5, 5, 6
    .byte 7, 6, 4, 6, 6, 7, 6, 5, 7, 5, 7, 6, 6, 8, 6, 5
    .byte 6, 7, 6, 6, 7, 7, 7, 6, 7, 6, 6, 7, 8, 7, 4, 7
    .byte 7, 7, 6, 6, 7, 6, 6, 6, 5, 6, 7, 7, 7, 7, 6
    .byte 5, 4, 7, 6, 5, 7, 7, 6, 4, 7, 8, 8, 6, 7, 4, 8
    .byte 7
    .byte 5, 6, 7, 6, 7, 6, 7, 7, 7, 7, 6, 6, 6, 7, 5
    .byte 6, 5, 6, 7, 6, 6, 6, 7, 5, 5, 7, 6, 6, 5, 6
    .byte 6, 6, 5, 5, 6, 7, 7, 6, 7, 6, 7, 7, 6, 7, 6
    .byte 6, 6, 5, 6, 7, 6, 5, 7, 6, 6, 7, 7, 7, 6, 7
    .byte 7, 6, 6, 6, 4, 5, 7, 6, 6, 7, 8, 6, 7, 7, 6, 7
    .byte 7, 7, 5, 6, 7, 5, 6, 5, 4, 6, 7, 7, 6, 7, 6
    .byte 8, 6, 6, 7, 5, 6, 6, 7, 6, 6, 7, 6, 6, 7, 7, 5
    .byte 6, 7, 5, 6, 7, 6, 6, 6, 7, 6, 7, 5, 8, 7, 7, 6
    .byte 6, 7, 6, 6, 7, 6, 6, 6, 7, 7, 6, 6, 7, 6, 6
    .byte 6, 7, 6, 7, 6, 7, 6, 6, 2, 7, 6, 7, 7, 7, 7
    .byte 6, 7, 7, 7, 7, 7, 5, 7, 7, 6, 6, 7, 6, 6, 6
    .byte 7, 7, 7, 6, 7, 6, 7, 8, 3, 6, 6, 7, 5, 5, 7, 6
    .byte 6, 6, 6, 6, 7, 6, 5, 7, 6, 6, 6, 6, 7, 5, 7
    .byte 7, 6, 6, 7, 7, 6, 7, 7, 6, 7, 6, 7, 7, 7, 6
    .byte 6, 6, 7, 6, 6, 7, 6, 6, 5, 7, 7, 5, 4, 4, 6
    .byte 7, 7, 6, 7, 7, 6, 6, 6, 6, 7, 7, 6, 6, 6, 7
    .byte 5, 7, 7, 7, 6, 4, 7, 7, 6, 6, 7, 7, 7, 7, 4
    .byte 4, 7, 8, 6, 6, 6, 7, 6, 5, 7, 7, 6, 5, 6, 7, 7
    .byte 6, 7, 5, 7, 6, 6, 6, 7, 7, 7, 7, 7, 6, 7, 6
    .byte 6, 7, 7, 5, 6, 6, 6, 7, 7, 7, 5, 5, 6, 5, 7
    .byte 5, 6, 5, 6, 7, 7, 5, 7, 7, 6, 6, 7, 7, 6, 5
    .byte 7, 2, 7, 7, 7, 7, 7, 7, 6, 7, 7, 6, 7, 6, 7
    .byte 7, 7, 6, 8, 7, 5, 6, 7, 7, 7, 6, 7, 6, 7, 5, 7
    .byte 6, 6, 6, 5, 6, 7, 7, 6, 7, 7, 7, 6, 7, 7, 7
    .byte 6, 6, 6, 6, 7, 6, 7, 7, 7, 7, 7, 6, 7, 7, 7
    .byte 6, 6, 7, 7, 6, 7, 7, 6, 4, 7, 6, 7, 7, 7, 7
    .byte 8, 7, 7, 6, 7, 6, 5, 6, 5, 6, 6, 7, 5, 7, 7, 6
    .byte 7, 7, 7, 6, 6, 7, 7, 6, 3, 7, 6, 6, 6, 6, 7
    .byte 7, 6, 6, 5, 6, 6, 5, 6, 8, 6, 6, 7, 6, 7, 7, 7
    .byte 6, 7, 7, 7, 7, 5, 8, 6, 7, 7, 6, 7, 6, 6, 7, 6
    .byte 6, 7, 6, 7, 6, 5, 6, 5, 5, 6, 5, 6, 6, 7, 6
    .byte 6, 7, 7, 7, 7, 7, 5, 6, 6, 6, 5, 6, 6, 7, 6
    .byte 6, 7, 7, 6, 6, 5, 6, 7, 5, 6, 7, 6, 5, 6, 5
    .byte 6, 7, 7, 5, 6, 7, 6, 6, 6, 6, 5, 7, 5, 5, 8, 6
    .byte 7, 7, 6, 7, 4, 7, 6, 6, 6, 7, 7, 5, 7, 6, 7
    .byte 7, 5, 7, 7, 6, 7, 8, 7, 6, 6, 5, 5, 5, 5, 5, 5
    .byte 6, 7, 7, 6, 6
    .byte 7, 7, 7, 7, 7, 6, 6, 5, 6, 7, 7, 7, 7, 7, 6
    .byte 5, 5, 6, 5, 6, 6, 7, 7, 7, 7, 7, 5, 7, 6, 6
    .byte 4, 7, 6, 6, 6, 5, 4, 6, 7, 6, 6, 6, 7, 6, 5
    .byte 7, 7, 8, 4, 7, 8, 7, 7, 7, 5, 7, 7, 7, 7, 7, 7
    .byte 5, 7, 7, 6, 6, 5, 7, 6, 6, 6, 4, 6, 6, 6, 7
    .byte 4, 7, 7, 5, 7, 7, 5, 5, 7, 6, 7, 7, 7, 7, 6
    .byte 7, 6, 6, 6, 5, 5, 5, 6, 4, 6, 7, 7, 7, 7, 6
    .byte 6, 7, 6, 5, 6, 7, 7, 6, 6, 7, 6, 6, 4, 5, 6
    .byte 7, 7, 5, 7, 7, 6, 6, 6, 7, 6, 7, 6, 5, 6, 7
    .byte 7, 7, 7, 6, 7, 6, 7, 7, 6, 8, 6, 6, 7, 5, 6, 6
    .byte 7, 6, 5, 7, 6, 8, 7, 6, 7, 6, 7, 7, 5, 6, 7, 6
    .byte 7, 8, 5, 7, 7, 5, 7, 6, 6, 3, 6, 7, 7, 6, 7, 7
    .byte 7, 6, 6, 6, 6, 7, 5, 6, 5, 6, 7, 7, 6, 6, 6
    .byte 6, 6, 6, 6, 6, 7, 6, 6, 8, 7, 8, 7, 6, 7, 7, 7
    .byte 7, 6, 6, 5, 7, 6, 6, 7, 7, 8, 6, 6, 6, 6, 7, 7
    .byte 8, 6, 6, 5, 5, 7, 5, 6, 7, 7, 5, 7, 8, 6, 6, 7
    .byte 7, 7, 7, 7, 6, 7, 7, 6, 7, 7, 5, 5, 6, 7, 6
    .byte 5, 6, 6, 6, 7, 8, 5, 5, 6, 6, 7, 5, 6, 7, 7, 6
    .byte 5, 6, 6, 6, 6, 7, 6, 6, 6, 7, 6, 5, 8, 6, 6, 8
    .byte 7, 6, 5, 7, 7, 6, 7, 7, 6, 7, 7, 7, 8, 5, 7, 6
    .byte 6, 6, 7, 6, 3, 6, 6, 7, 7, 6, 7, 7, 5, 7, 7
    .byte 7, 5, 5, 6, 7, 7, 6, 6, 6, 6, 7, 7, 7, 6, 5
    .byte 5, 6, 7, 6, 6, 7, 6, 7, 6, 7, 6, 5, 7, 6, 6
    .byte 6, 6, 5, 7, 5, 6, 5, 5, 7, 6, 6, 5, 7, 7, 5
    .byte 7, 7, 6, 6, 7, 7, 7, 6, 6, 6, 7, 7, 7, 7, 6
    .byte 6, 7, 5, 6, 5, 6, 6, 6, 6, 7, 6, 7, 5, 5, 7
    .byte 7, 7, 5, 6, 7, 7, 7, 7, 6, 7, 6, 6, 6, 7, 6
    .byte 6, 8, 5, 7, 7, 5, 6, 6, 5, 7, 5, 6, 6, 7, 7, 6
    .byte 5, 5, 7, 7, 5, 7, 5, 7, 5, 5, 4, 5, 7, 6, 7
    .byte 7, 7, 6, 7, 7, 5, 7, 7, 7, 6, 7, 7, 5, 7, 7
    .byte 7, 6, 7, 6, 6, 6, 5, 6, 7, 5, 6, 6, 6, 7, 7
    .byte 4, 6, 7, 7, 5, 4, 7, 6, 6, 5, 6, 7, 6, 8, 7, 7
    .byte 7, 6, 6, 7, 7, 6, 7, 6, 4, 6, 7, 7, 6, 7, 5
    .byte 7, 6, 7, 7, 7, 6, 6, 6, 6, 6, 7, 6, 7, 5, 6
    .byte 5, 5, 6, 5, 7, 7, 6, 7, 6, 7, 5, 7, 7, 6, 7
    .byte 7, 7, 6, 6, 5, 6, 7, 7, 6, 7, 6, 6, 7, 6, 5
    .byte 7, 6, 6, 8, 7, 7, 6, 6, 6, 3, 7, 7, 6, 7, 6, 7
    .byte 6, 6, 8, 5, 7, 5, 7, 3, 7, 7, 8, 7, 6, 7, 6, 6
    .byte 7, 7, 5, 6, 7, 6, 8, 7, 6, 6, 6, 7, 6, 7, 6, 4
    .byte 6, 7, 7, 5, 7, 7, 8, 6, 6, 7, 8, 7, 8, 6, 7, 6
    .byte 6
    .byte 7, 7, 7, 6, 7, 6, 7, 8, 7, 6, 5, 6, 7, 7, 6, 6
    .byte 6, 6, 6, 8, 7, 5, 6, 6, 6, 6, 6, 6, 7, 7, 7, 6
    .byte 7, 6, 7, 7, 7, 6, 7, 7, 7, 6, 6, 7, 7, 5, 6
    .byte 6, 6, 7, 7, 6, 6, 6, 6, 7, 7, 7, 7, 7, 5, 5
    .byte 7, 6, 5, 4, 4, 6, 6, 7, 6, 7, 7, 5, 6, 6, 5
    .byte 7, 7, 6, 5, 7, 6, 7, 7, 7, 6, 8, 5, 7, 5, 6, 6
    .byte 6, 6, 7, 7, 4, 7, 7, 7, 5, 6, 7, 7, 5, 6, 6
    .byte 7, 6, 3, 7, 7, 6, 6, 7, 6, 6, 7, 7, 5, 7, 6
    .byte 7, 7, 6, 7, 3, 7, 7, 7, 7, 6, 6, 6, 7, 7, 5
    .byte 7, 5, 6, 7, 7, 6, 5, 6, 6, 7, 5, 6, 7, 7, 7
    .byte 6, 6, 5, 6, 6, 7, 7, 7, 7, 6, 7, 7, 7, 6, 7
    .byte 7, 8, 7, 7, 6, 5, 7, 6, 7, 7, 5, 6, 6, 7, 7, 6
    .byte 7, 7, 7, 5, 6, 5, 7, 5, 7, 8, 7, 6, 7, 7, 7, 7
    .byte 7, 5, 7, 6, 5, 8, 8, 4, 7, 7, 7, 7, 7, 7, 4, 6
    .byte 7, 6, 7, 6, 6, 7, 8, 6, 7, 7, 6, 5, 4, 6, 5, 7
    .byte 6, 6, 7, 5, 7, 6, 7, 7, 6, 7, 6, 7, 6, 7, 6
    .byte 7, 7, 8, 6, 7, 4, 6, 6, 5, 7, 6, 5, 7, 6, 5, 7
    .byte 7, 5, 6, 7, 6, 6, 6, 6, 5, 5, 7, 7, 6, 7, 6
    .byte 6, 7, 6, 6, 5, 6, 7, 7, 6, 6, 5, 7, 6, 7, 6
    .byte 6, 7, 6, 6, 5, 7, 5, 6, 7, 6, 6, 7, 7, 4, 6
    .byte 6, 6, 5, 4, 6, 6, 7, 7, 5, 7, 7, 6, 7, 6, 5
    .byte 6, 7, 6, 6, 7, 7, 7, 7, 8, 7, 6, 7, 7, 7, 6, 7
    .byte 5, 5, 6, 7, 6, 6, 7, 7, 5, 5, 6, 6, 7, 5, 5
    .byte 6, 7, 6, 6, 6, 7, 6, 6, 6, 4, 7, 7, 6, 4, 6
    .byte 5, 8, 6, 7, 7, 7, 7, 6, 6, 7, 5, 7, 6, 5, 7, 7
    .byte 5, 7, 7, 7, 5, 7, 7, 6, 7, 6, 6, 7, 7, 7, 5
    .byte 6, 7, 4, 7, 6, 7, 6, 7, 6, 6, 6, 7, 6, 6, 7
    .byte 6, 6, 7, 5, 6, 6, 7, 7, 7, 6, 7, 7, 7, 7, 6
    .byte 6, 5, 7, 7, 6, 5, 8, 7, 4, 6, 6, 6, 7, 5, 5, 6
    .byte 6, 7, 5, 6, 7, 5, 6, 7, 7, 6, 5, 7, 7, 7, 7
    .byte 7, 6, 7, 7, 6, 6, 7, 3, 6, 6, 7, 7, 6, 6, 6
    .byte 8, 6, 7, 7, 7, 7, 6, 7, 5, 6, 7, 6, 7, 5, 6, 7
    .byte 7, 6, 8, 7, 5, 5, 6, 6, 7, 6, 7, 6, 7, 7, 6, 7
    .byte 8, 7, 7, 6, 3, 8, 7, 8, 7, 7, 6, 6, 6, 6, 7, 4
    .byte 6
    .byte 6, 6, 6, 5, 7, 6, 7, 7, 6, 7, 6, 8, 6, 6, 4, 5
    .byte 6, 7, 6, 6, 6, 7, 7, 7, 6, 6, 5, 5, 8, 6, 6, 7
    .byte 6, 5, 7, 8, 7, 5, 6, 6, 6, 6, 7, 5, 7, 6, 6, 6
    .byte 7, 4, 7, 5, 6, 7, 6, 6, 7, 5, 7, 6, 7, 8, 7, 7
    .byte 6, 7, 7, 5, 7, 7, 7, 7, 8, 6, 6, 6, 7, 3, 6, 6
    .byte 6, 7, 6, 6, 7, 6, 5, 7, 4, 7, 7, 7, 6, 5, 7
    .byte 6, 7, 6, 6, 6, 7, 6, 6, 8, 6, 6, 5, 6, 7, 5, 8
    .byte 5, 6, 7, 7, 7, 6, 7, 6, 5, 6, 6, 4, 6, 7, 6
    .byte 5, 7, 6, 5, 7, 7, 6, 5, 7, 6, 7, 6, 7, 6, 7
    .byte 7, 7, 7, 6, 7, 7, 6, 6, 4, 7, 7, 7, 7, 6, 6
    .byte 6, 5, 7, 6, 6, 6, 4, 6, 6, 7, 5, 7, 6, 5, 5
    .byte 6, 6, 5, 7, 6, 6, 7, 6, 7, 4, 5, 7, 7, 7, 5
    .byte 7, 7, 7, 7, 6, 7, 6, 6, 7, 7, 7, 6, 6, 7, 5
    .byte 5, 6, 7, 7, 7, 5, 6, 6, 7, 5, 4, 6, 7, 7, 6
    .byte 6, 5, 6, 7, 6, 7, 7, 6, 7, 7, 7, 6, 7, 6, 7
    .byte 6, 7, 6, 6, 8, 6, 6, 6, 7, 5, 7, 5, 6, 6, 6, 7
    .byte 6, 5, 6, 4, 7, 6, 6, 5, 7, 7, 7, 7, 8, 7, 4, 7
    .byte 6, 7, 7, 6, 7, 6, 7, 7, 5, 7, 6, 7, 5, 6, 7
    .byte 8, 7, 5, 6, 6, 7, 6, 6, 6, 5, 7, 6, 7, 7, 6, 6
    .byte 5, 7, 7, 7, 6, 6, 6, 7, 7, 6, 7, 6, 6, 5, 6
    .byte 7, 7, 6, 5, 7, 7, 6, 6, 7, 6, 6, 5, 5, 5, 6
    .byte 5, 7, 6, 7, 6, 7, 7, 5, 6, 5, 4, 5, 6, 7, 8, 7
    .byte 6, 6, 5, 7, 6, 6, 6, 6, 6, 6, 7, 6, 6, 8, 4, 7
    .byte 7, 7, 7, 7, 6, 6, 7, 7, 6, 6, 7, 7, 5, 7, 6
    .byte 7, 6, 6, 6, 8, 5, 7, 6, 7, 5, 6, 7, 7, 6, 7, 7
    .byte 7, 6, 7, 7, 7, 5, 7, 6, 8, 7, 7, 6, 7, 6, 7, 7
    .byte 6, 4, 7, 5, 6, 7, 5, 7, 7, 5, 6, 6, 6, 3, 7
    .byte 7, 8, 7, 7, 7, 5, 6, 5, 7, 6, 6, 7, 7, 7, 6, 6
    .byte 7, 6, 6, 6, 7, 7, 7, 5, 7, 6, 7, 7, 6, 7, 7
    .byte 4, 5, 7, 7, 5, 6, 7, 7, 7, 6, 6, 6, 6, 7, 7
    .byte 7, 6, 7, 6, 6, 6, 7, 6, 7, 6, 7, 7, 6, 6, 6
    .byte 7, 8, 4, 7, 6, 6, 5, 4, 7, 6, 8, 7, 6, 7, 6, 6
    .byte 7, 7, 7, 5, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 4
    .byte 6, 7, 6, 5, 6, 7, 6, 7, 7, 6, 7, 6, 6, 6, 6
    .byte 5, 6, 7, 7, 6, 6, 6, 7, 7, 5, 8, 6, 6, 4, 6, 4
    .byte 6, 7, 6, 7, 7, 7, 6, 7, 8, 5, 6, 6, 5, 7, 7, 6
    .byte 6, 7, 6, 6, 6, 6, 6, 6, 5, 4, 6, 6, 6, 6, 6
    .byte 5, 7, 7, 7, 6, 7, 6, 6, 6, 7, 7, 7, 8, 5, 7, 7
    .byte 6, 6, 5, 5, 6, 5, 6, 6, 6, 6, 7, 7, 7, 7, 6
    .byte 6, 5, 4, 7, 6, 7, 5, 6, 7, 7, 4, 7, 7, 6, 7
    .byte 6, 6, 5, 6, 6, 6, 7, 7, 7, 6, 7, 5, 7, 8, 7, 7
    .byte 5, 7, 6, 7, 5, 7, 6, 5, 7, 6, 6, 6, 7, 5, 5
    .byte 6, 7, 7, 7, 7, 5, 7, 6, 7, 6, 6, 6, 6, 6, 6
    .byte 6, 5, 8, 7, 6, 7, 7, 6, 4, 6, 6, 6, 7, 6, 7, 7
    .byte 6, 7, 7, 7, 5, 6, 7, 7, 5, 7, 6, 7, 7, 5, 6
    .byte 7, 5, 8, 6, 5, 6, 6, 7, 6, 5, 7, 6, 7, 7, 7, 7
    .byte 7, 6, 7, 4, 6, 6, 6, 7, 7, 7, 4, 6, 6, 5, 6
    .byte 5, 6, 6, 5, 7, 7, 6, 6, 6, 6, 7, 7, 5, 6, 7
    .byte 7, 6, 6, 7, 6, 7, 7, 7, 5, 7, 6, 5, 6, 7, 5
    .byte 6, 7, 7, 7, 7, 6, 6, 7, 7, 6, 5, 6, 7, 6, 7
    .byte 6, 7, 4, 7, 6, 6, 6, 6, 6, 6, 7, 6, 6, 7, 6
    .byte 7, 7, 6, 6, 7, 6, 6, 6, 7, 6, 6, 7, 7, 7, 7
    .byte 4, 6, 6, 7, 5, 6, 5, 7, 6, 7, 5, 6, 6, 7, 7
    .byte 5, 7, 6, 6, 7, 6, 7, 7, 7, 7, 5, 6, 7, 7, 6
    .byte 6, 6, 6, 5, 7, 7, 6, 7, 7, 6, 7, 7, 6, 6, 6
    .byte 5, 6, 6, 7, 6, 6, 7, 7, 6, 5, 6
    .byte 7, 6, 6, 5, 6, 7, 7, 7, 6, 7, 6, 7, 7, 5, 6
    .byte 5, 7, 6, 7, 6, 5, 8, 7, 7, 7, 7, 5, 3, 5, 7, 7
    .byte 7, 6, 4, 5, 7, 7, 6, 7, 6, 8, 4, 7, 7, 5, 7, 4
    .byte 8, 7, 6, 7, 8, 4, 7, 7, 7, 7, 6, 6, 6, 7, 7, 6
    .byte 7, 6, 7, 7, 6, 6, 5, 5, 5, 7, 7, 7, 6, 7, 7
    .byte 6, 7, 5, 7, 6, 7, 7, 7, 5, 7, 6, 7, 6, 7, 7
    .byte 6, 6, 6, 7, 7, 6, 6, 7, 7, 6, 7, 7, 5, 7, 7
    .byte 4, 6, 4, 6, 7, 7, 5, 5, 7, 7, 7, 6, 6, 6, 7
    .byte 7, 5, 6, 7, 8, 6, 6, 7, 6, 6, 7, 6, 7, 5, 7, 5
    .byte 7, 6, 6, 7, 6, 7, 6, 8, 5, 5, 6, 5, 7, 5, 6, 7
    .byte 7, 8, 5, 7, 5, 5, 7, 6, 7, 6, 6, 6, 7, 7, 6, 7
    .byte 6, 5, 6, 7, 6, 7, 6, 7, 6, 7, 6, 6, 7, 7, 6
    .byte 6, 6, 6, 5, 6, 5, 7, 7, 7, 5, 6, 6, 7, 6, 6
    .byte 7, 6, 6, 7, 7, 7, 7, 7, 6, 7, 7, 6, 7, 7, 6
    .byte 7, 7, 5, 4, 7, 6, 6, 5, 8, 7, 7, 8, 7, 6, 6, 6
    .byte 6, 5, 6, 5, 7, 7, 7, 7, 4, 7, 7, 7, 6, 6, 7
    .byte 8, 7, 7, 7, 8, 7, 5, 7, 6, 7, 5, 4, 5, 6, 7, 6
    .byte 6, 7, 7, 6, 7, 6, 6, 5, 6, 6, 7, 6, 6, 6, 5
    .byte 5, 6, 6, 6, 7, 7, 7, 7, 7, 7, 6, 7, 4, 6, 7
    .byte 7, 6, 7, 7, 5, 6, 7, 6, 6, 5, 6, 6, 6, 7, 7
    .byte 7, 7, 5, 7, 6, 7, 5, 5, 6, 7, 6, 4, 7, 7, 6
    .byte 7, 7, 5, 7, 4, 6, 6, 6, 6, 7, 7, 5, 7, 8, 7, 7
    .byte 7, 6, 6, 7, 7, 7, 8, 7, 4, 5, 6, 4, 7, 7, 5, 5
    .byte 7, 7, 3, 6, 6, 7, 7, 6, 6, 6, 6, 7, 5, 6, 5
    .byte 6, 6, 7, 7, 7, 7, 5, 7, 7, 6, 5, 7, 7, 6, 8, 7
    .byte 6, 7, 7, 7, 7, 7, 5, 6, 6, 7, 7, 6, 7, 5, 7
    .byte 6, 6, 8, 6, 8, 7, 6, 5, 6, 5, 7, 6, 6, 7, 6, 7
    .byte 7, 7, 7, 6, 6, 6, 7, 5, 6, 7, 8, 6, 6, 6, 6, 6
    .byte 7, 6, 8, 6, 7, 5, 6, 5, 7, 6, 7, 7, 5, 8, 6, 7
    .byte 7, 7, 6, 5, 6, 6, 6, 6, 7, 7, 5, 6, 6, 7, 5
    .byte 6, 6, 6, 7, 7, 6, 7, 7, 5, 7, 7, 6, 6, 5, 6
    .byte 5, 7, 6, 7, 7, 5, 8, 7, 7, 7, 3, 6, 6, 6, 6, 6
    .byte 6, 7, 7, 8, 6, 7, 6, 7, 6, 6, 7, 7, 8, 6, 6, 5
    .byte 6, 6, 5, 7, 7, 7, 5, 6, 5, 5, 5, 6, 6, 7, 6
    .byte 7, 6, 6, 6, 6, 7, 6, 7, 7, 7, 7, 6, 7, 7, 6
    .byte 7, 5, 4, 6, 6, 6, 5, 6, 7, 6, 8, 6, 7, 7, 6, 6
    .byte 7, 6, 5, 7, 6, 7, 8, 6, 7, 8, 7, 6, 7, 6, 7, 5
    .byte 5, 7, 7, 6, 7, 7, 6, 7, 5, 6, 5, 7, 7, 7, 6
    .byte 7, 6, 6, 6, 6, 4, 7, 6, 7, 6, 7, 6, 6, 7, 5
    .byte 7, 7, 7, 5, 7, 7, 7, 6, 6, 6, 4, 6, 7, 7, 5
    .byte 7, 6, 6, 6, 8, 7, 6, 7, 7, 5, 6, 6, 7, 7, 7, 7
    .byte 6, 8, 5, 6, 6, 5, 7, 5, 6, 7, 7, 6, 7, 6, 6, 6
    .byte 7, 7, 6, 6, 6, 6, 7, 8, 5, 7, 6, 7, 6, 6, 6, 7
    .byte 7, 7, 3, 6, 5, 7, 7, 6, 7, 5, 8, 6, 5, 7, 7, 6
    .byte 7, 6, 6, 6, 7, 7, 6, 6, 5, 7, 7, 7, 6, 7, 5
    .byte 6, 5, 6, 6, 7, 7, 7, 7, 7, 5, 7, 6, 6, 4, 7
    .byte 6, 7, 7, 7, 7, 6, 5, 7, 7, 6, 5, 7, 6, 7, 7
    .byte 4, 7, 7, 7, 8, 6, 7, 5, 6, 6, 6, 6, 6, 6, 7, 7
    .byte 6, 6, 7, 5, 6, 3, 6, 6, 7, 5, 6, 6, 7, 6, 5
    .byte 7, 7, 6, 6, 5, 6, 6, 7, 6, 7, 8, 6, 6, 8, 6, 6
    .byte 5, 6, 5, 7, 4, 6, 7, 5, 7, 7, 7, 7, 5, 7, 7
    .byte 6, 5, 6, 6, 7, 7, 7, 7, 7, 7, 6, 4, 6, 7, 6
    .byte 7, 6, 6, 5, 7, 6, 7, 7, 7, 7, 6, 6, 7, 4, 6
    .byte 5, 6, 7, 6, 6, 7, 4, 6, 7, 5, 6, 5, 6, 6, 7
    .byte 6, 6, 6, 5, 7, 7, 7, 5, 6, 4, 6, 7, 6, 7, 8, 7
    .byte 7, 5, 6, 6, 7, 5, 7, 6, 6, 6, 6, 6, 7, 7, 6
    .byte 7, 7, 6, 6, 6, 7, 7, 3, 7, 7, 8, 7, 7, 7, 6, 5
    .byte 6, 7, 4, 7, 7, 7, 7, 6, 6, 7, 6, 7, 7, 6, 7
    .byte 6, 7, 4, 6, 7, 6, 5, 5, 7, 7, 7, 7, 5, 6, 6
    .byte 5, 7, 7, 6, 5, 7, 6, 6, 6, 7, 6, 6, 6, 7, 6
    .byte 7, 6, 7, 7, 7, 4, 7, 5, 7, 7, 6, 6, 5, 6, 7
    .byte 6, 6, 6, 7, 6, 7, 7, 7, 6, 7, 7, 6, 5, 7, 6
    .byte 7, 6, 6, 7, 7, 6, 6, 6, 7, 5, 6, 5, 5, 6, 6
    .byte 5, 7, 7, 7, 6, 6, 6, 5, 6, 5, 6, 6, 7, 7, 7
    .byte 6, 7, 6, 4, 5, 6, 7, 7, 5, 6, 7, 8, 6, 6, 7, 7
    .byte 6, 5, 6, 5, 7, 6, 7, 7, 6, 7, 7, 6, 6, 7, 7
    .byte 5, 6, 7, 7, 6, 7, 6, 6, 7, 7, 6, 7, 6, 7, 7
    .byte 6, 4, 7, 7, 8, 7, 6, 7, 6, 6, 6, 7, 7, 5, 7, 5
    .byte 7, 5, 7, 6, 6, 6, 7, 6, 7, 6, 7, 5, 7, 5, 6
    .byte 7, 8, 7, 6, 7, 6, 6, 6, 6, 7, 3, 7, 7, 6, 7, 6
    .byte 6, 7, 6, 7, 6, 6, 6, 7, 5, 6, 7, 6, 7, 7, 6
    .byte 6, 7, 5, 6, 5, 6, 7, 7, 7, 7, 7, 6, 6, 6, 7
    .byte 6, 7, 7, 7, 7, 6, 7, 7, 7, 6, 6, 7, 7, 7, 7
    .byte 6, 7, 6, 7, 6, 7, 3, 5, 6, 6, 7, 7, 7, 5, 7
    .byte 7, 6, 6, 6, 7, 5, 7, 7, 6, 5, 4, 7, 7, 7, 5
    .byte 6, 5, 7, 7, 6, 6, 7, 7, 6, 6, 7, 6, 5, 7, 7
    .byte 6, 7, 5, 7, 7, 6, 7, 4, 8, 7, 7, 5, 6, 6, 7, 6
    .byte 5, 6, 7, 7, 6, 6, 7, 7, 6, 7, 6, 5, 7, 6, 7
    .byte 7, 6, 5, 6, 6, 7, 6, 7, 7, 6, 5, 5, 6, 6, 8, 7
    .byte 5, 8, 7, 7, 5, 5, 5, 6, 6, 7, 7, 7, 6, 7, 6, 7
    .byte 5, 5, 4, 6, 7, 7, 6, 6, 7, 6, 6, 7, 7, 5, 6
    .byte 6, 6, 6, 7, 7, 6, 6, 6, 6, 6, 6, 6, 7, 6, 7
    .byte 7, 6, 6, 3, 6, 7, 6, 6, 6, 7, 6, 7, 7, 7, 4
    .byte 6, 7, 6, 7, 7, 6, 6, 6, 5, 5, 6, 6, 7, 7, 6
    .byte 6, 6, 6, 6, 7, 7, 7, 7, 6, 7, 7, 6, 6, 5, 5
    .byte 7, 7, 7, 6, 7, 7, 4, 6, 4, 6, 5, 6, 5, 4, 6
    .byte 6, 6, 7, 7, 7, 7, 7, 5, 7, 7, 7, 5, 7, 7, 7
    .byte 6, 7, 6, 5, 7, 6, 6, 7, 6, 4, 6, 5, 6, 7, 7
    .byte 6, 7, 7, 6, 6, 6, 5, 6, 6, 6, 7, 6, 7, 4, 7
    .byte 6, 6, 6, 7, 5, 7, 6, 4, 6, 7, 7, 7, 7, 7, 7
    .byte 7, 7, 4, 8, 7, 6, 6, 6, 6, 8, 7, 5, 6, 6, 6, 6
    .byte 7, 5, 6, 5, 6, 6, 5, 6, 6, 7, 7, 6, 7, 6, 7
    .byte 7, 6, 7, 7, 6, 6, 6, 6, 7, 7, 5, 7, 6, 6, 6
    .byte 5, 6, 7, 7, 7, 7, 6, 6, 7, 7, 6, 7, 6, 5, 7
    .byte 8, 7, 6, 7, 6, 5, 7, 6, 6, 7, 6, 6, 3, 7, 7, 7
    .byte 6, 6, 7, 8, 7, 6, 5, 6, 7, 6, 6, 7, 7, 7, 3, 7
    .byte 8, 6, 6, 6, 5, 7, 5, 6, 5, 5, 6, 7, 7, 6, 7, 6
    .byte 6, 6, 7, 6, 6, 6, 7, 7, 7, 5, 6, 7, 6, 6, 7
    .byte 5, 6, 5, 6, 7, 6, 7, 7, 6, 7, 7, 7, 6, 6, 5
    .byte 7, 7, 5, 7, 7, 7, 7, 5, 6, 6, 6, 6, 5, 7, 6
    .byte 7, 5, 7, 7, 7, 7, 7, 6, 7, 6, 7, 7, 6, 6, 7
    .byte 5, 6, 7, 6, 7, 6, 7, 8, 3, 6, 5, 6, 6, 5, 6, 6
    .byte 7, 7, 6, 7, 7, 6, 5, 6, 7, 7, 7, 6, 7, 7, 5
    .byte 6, 5, 6, 6, 5, 5, 8, 7, 6, 7, 7, 6, 7, 7, 7, 6
    .byte 6, 7, 6, 7, 7, 6, 7, 6, 6, 7, 6, 6, 8, 7, 6, 4
    .byte 7, 7, 8, 7, 6, 7, 6, 6, 5, 6, 7, 7, 6, 6, 7, 7
    .byte 5, 5, 6, 7, 7, 7, 5, 6, 6, 6, 6, 5, 6, 4, 6
    .byte 5, 7, 6, 8, 6, 5, 6, 7, 3, 6, 6, 8, 7, 6, 8, 6
    .byte 7
    .byte 6, 6, 4, 5, 7, 6, 7, 7, 5, 7, 6, 7, 7, 7, 6
    .byte 5, 7, 7, 7, 7, 6, 6, 7, 7, 7, 6, 7, 6, 8, 7, 6
    .byte 6, 5, 6, 7, 7, 7, 6, 7, 5, 6, 6, 6, 7, 5, 7
    .byte 5, 6, 8, 4, 7, 6, 6, 7, 5, 5, 7, 7, 5, 6, 7, 6
    .byte 4, 6, 7, 7, 7, 6, 7, 6, 8, 5, 6, 5, 5, 7, 6, 7
    .byte 7, 7, 8, 5, 7, 6, 7, 6, 6, 7, 6, 6, 7, 5, 7, 6
    .byte 7, 7, 6, 6, 6, 6, 7, 6, 6, 7, 6, 8, 6, 7, 7, 5
    .byte 7, 5, 6, 6, 7, 6, 6, 6, 7, 7, 7, 5, 6, 6, 7
    .byte 6, 5, 7, 7, 7, 5, 5, 5, 6, 6, 5, 7, 6, 6, 5
    .byte 7, 5, 7, 4, 7, 6, 6, 6, 6, 7, 7, 5, 7, 5, 4
    .byte 7, 6, 7, 7, 6, 7, 7, 5, 6, 6, 6, 6, 7, 6, 7
    .byte 6, 6, 7, 6, 6, 7, 8, 7, 6, 6, 5, 7, 7, 7, 5, 7
    .byte 7, 7, 5, 6, 6, 7, 4, 6, 7, 8, 5, 7, 7, 7, 7, 6
    .byte 5, 7, 4, 6, 7, 6, 5, 7, 7, 5, 6, 6, 7, 6, 7
    .byte 6, 7, 6, 6, 6, 7, 7, 3, 5, 7, 7, 6, 6, 6, 7
    .byte 6, 5, 6, 7, 6, 7, 6, 7, 7, 6, 6, 7, 7, 7, 6
    .byte 7, 7, 5, 6, 6, 7, 6, 7, 7, 7, 7, 4, 7, 7, 6
    .byte 6, 6, 8, 6, 6, 7, 5, 8, 7, 6, 6, 7, 6, 7, 7, 5
    .byte 6, 6, 7, 7, 7, 8, 7, 6, 4, 6, 7, 6, 6, 5, 6, 7
    .byte 7, 5, 6, 6, 6, 6, 7, 6, 2, 7, 7, 6, 6, 7, 7
    .byte 6, 7, 8, 6, 6, 5, 6, 7, 7, 7, 6, 6, 5, 7, 6, 6
    .byte 7, 7, 7, 6, 7, 6, 7, 5, 6, 7, 7, 7, 6
    .byte 8, 7, 7, 6, 7, 6, 6, 7, 4, 8, 7, 7, 7, 4, 7, 6
    .byte 7, 7, 7, 5, 7, 7, 6, 6, 7, 6, 7, 7, 6, 7, 6
    .byte 5, 6, 6, 7, 6, 7, 7, 5, 7, 6, 6, 7, 4, 4, 4
    .byte 8, 6, 6, 7, 7, 6, 5, 7, 7, 5, 6, 6, 7, 7, 5, 6
    .byte 7, 7, 7, 6, 5, 6, 7, 6, 6, 6, 6, 4, 7, 6, 7
    .byte 7, 7, 7, 6, 7, 7, 5, 6, 7, 7, 5, 7, 7, 6, 6
    .byte 6, 7, 6, 6, 6, 6, 6, 6, 6, 4, 7, 6, 5, 7, 7
    .byte 6, 8, 7, 5, 7, 6, 6, 6, 6, 6, 7, 7, 7, 6, 6, 7
    .byte 6, 4, 6, 6, 6, 5, 6, 7, 7, 6, 6, 6, 6, 7, 4
    .byte 5, 7, 6, 7, 7, 6, 7, 7, 4, 7, 7, 5, 7, 6, 7
    .byte 6, 6, 5, 5, 7, 7, 7, 7, 7, 7, 6, 6, 7, 7, 6
    .byte 7, 6, 6, 7, 7, 7, 7, 6, 5, 5, 7, 7, 6, 7, 7
    .byte 5, 5, 7, 6, 6, 7, 7, 6, 5, 6, 7, 7, 6, 6, 4
    .byte 6, 6, 6, 5, 4, 8, 8, 6, 4, 5, 5, 7, 7, 6, 6, 7
    .byte 6, 6, 7, 6, 6, 5, 7, 7, 5, 7, 6, 5, 6, 5, 6
    .byte 7, 7, 6, 5, 6, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6
    .byte 7, 5, 7, 6, 6, 7, 5, 7, 6, 6, 7, 6, 7, 7, 7
    .byte 5, 5, 6, 7, 7, 7, 7, 6, 7, 6, 7, 6, 6, 6, 6
    .byte 6, 6, 5, 6, 6, 7, 6, 7, 7, 6, 7, 7, 6, 6, 5
    .byte 5, 7, 6, 6, 7, 7, 7, 3, 8, 6, 7, 6, 6, 6, 6, 5
    .byte 6, 5, 4, 7, 6, 6, 7, 7, 6, 7, 6, 6, 7, 6, 7
    .byte 7, 7, 6, 6, 7, 6, 7, 7, 7, 6, 6, 6, 6, 7, 6
    .byte 6, 7, 7, 6, 7, 6, 6, 3, 6, 6, 6, 6, 6, 7, 7
    .byte 6, 7, 6, 7, 6, 6, 4, 6, 7, 7, 4, 6, 7, 6, 7
    .byte 7, 7, 6, 5, 5, 7, 7, 6, 7, 6, 7, 4, 6, 6, 5
    .byte 5, 7, 3, 7, 7, 7, 5, 6, 7, 7, 6, 7, 7, 8, 7, 6
    .byte 6, 8, 6, 7, 7, 6, 6, 7, 6, 6, 6, 7, 5, 5, 7, 6
    .byte 6, 7, 6, 7, 7, 6, 6, 7, 6, 6, 6, 6, 7, 6, 6
    .byte 7, 7, 7, 7, 7, 5, 7, 7, 6, 6, 5, 5, 3, 8, 7, 6
    .byte 6, 5, 6, 6, 7, 5, 5, 7, 7, 7, 7, 6, 7, 7, 6
    .byte 6, 6, 7, 6, 6, 4, 7, 6, 4, 6, 7, 6, 5, 6, 7
    .byte 7, 7, 5, 6, 7, 7, 7, 6, 7, 7, 7, 6, 7, 6, 6
    .byte 6, 6, 6, 6, 5, 7, 5, 6, 5, 7, 7, 7, 6, 7, 7
    .byte 4, 6, 7, 6, 7, 7, 6, 7, 7, 6, 6, 7, 7, 5, 5
    .byte 6, 6, 7, 6, 5, 7, 8, 4, 7, 6, 7, 7, 6, 5, 6, 8
    .byte 6, 5, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 6, 5
    .byte 6, 7, 7, 6, 6, 7, 6, 6, 7, 6, 7, 7, 6, 7, 5
    .byte 7, 6, 7, 7, 7, 8, 7, 6, 6, 6, 6, 7, 6, 6, 4, 7
    .byte 6, 7, 5, 7, 6, 7, 6, 7, 6, 7, 6, 5, 7, 7, 7
    .byte 7, 7, 7, 6, 5, 6, 4, 6, 7, 6, 6, 6, 7, 6, 7
    .byte 8, 7, 6, 6, 5, 5, 4, 6, 6, 8, 5, 7, 7, 8, 5, 4
    .byte 6
    .byte 7, 6, 6, 6, 7, 7, 6, 6, 7, 6, 6, 7, 6, 6, 6
    .byte 7, 6, 5, 7, 6, 7, 7, 7, 7, 7, 7, 7, 7, 6, 7
    .byte 6, 6, 4, 6, 6, 6, 5, 7, 7, 6, 6, 7, 6, 5, 7
    .byte 7, 8, 7, 7, 7, 7, 7, 6, 6, 5, 6, 6, 6, 6, 6, 6
    .byte 6, 7, 6, 7, 6, 6, 6, 6, 7, 5, 6, 6, 5, 7, 7
    .byte 5, 5, 7, 7, 6, 7, 6, 5, 6, 6, 5, 6, 7, 6, 7
    .byte 7, 7, 7, 7, 7, 7, 7, 6, 6, 7, 7, 6, 7, 7, 5
    .byte 7, 8, 5, 6, 5, 6, 5, 7, 6, 5, 6, 6, 7, 7, 7, 6
    .byte 5, 7, 6, 7, 7, 7, 7, 5, 7, 6, 6, 5, 7, 7, 7
    .byte 6, 7, 7, 8, 5, 6, 6, 8, 7, 6, 7, 5, 6, 6, 4, 5
    .byte 5, 7, 6, 6, 6, 7, 7, 4, 8, 8, 7, 6, 7, 6, 8, 6
    .byte 6
    .byte 7, 7, 7, 7, 7, 7, 7, 5, 6, 7, 7, 6, 6, 6, 7
    .byte 7, 8, 6, 6, 8, 7, 7, 7, 6, 6, 6, 5, 6, 8, 7, 5
    .byte 7
    .byte 7, 6, 5, 6, 5, 6, 7, 7, 8, 6, 6, 6, 7, 7, 6, 4
    .byte 5, 5, 7, 7, 7, 7, 7, 6, 7, 6, 6, 6, 5, 7, 4
    .byte 5, 6, 7, 7, 6, 7, 6, 6, 6, 7, 5, 6, 7, 6, 5
    .byte 4, 7, 7, 6, 7, 7, 7, 5, 7, 7, 6, 6, 7, 7, 7
    .byte 7, 7, 5, 7, 6, 6, 5, 7, 6, 7, 7, 7, 7, 6, 5
    .byte 7, 4, 5, 6, 7, 7, 6, 7, 6, 6, 7, 7, 7, 7, 7
    .byte 5, 7, 7, 6, 6, 5, 4, 7, 7, 6, 6, 7, 6, 6, 6
    .byte 7, 5, 7, 6, 6, 5, 7, 4, 6, 6, 6, 6, 5, 7, 5
    .byte 7, 6, 6, 7, 5, 6, 6, 5, 7, 7, 5, 6, 6, 7, 7
    .byte 7, 6, 7, 7, 6, 8, 6, 7, 4, 7, 7, 5, 7, 6, 5, 7
    .byte 7, 6, 7, 7, 4, 7, 5, 6, 7, 5, 7, 6, 6, 6, 6
    .byte 6, 7, 7, 8, 7, 7, 7, 6, 6, 5, 7, 5, 5, 6, 6, 7
    .byte 6, 7, 7, 5, 7, 5, 6, 7, 7, 7, 4, 6, 7, 6, 7
    .byte 6, 4, 6, 5, 7, 7, 7, 6, 7, 5, 6, 5, 7, 6, 7
    .byte 6, 7, 7, 7, 5, 7, 7, 6, 7, 7, 7, 7, 7, 7, 6
    .byte 5, 7, 7, 7, 7, 6, 7, 7, 6, 5, 5, 6, 7, 6, 7
    .byte 7, 7, 5, 7, 7, 6, 7, 7, 7, 6, 7, 7, 6, 7, 7
    .byte 5, 5, 7, 5, 7, 6, 5, 6, 7, 7, 6, 5, 7, 6, 6
    .byte 5, 7, 5, 7, 6, 6, 7, 5, 6, 5, 6, 7, 6, 6, 6
    .byte 4, 5, 7, 6, 7, 7, 7, 7, 7, 7, 6, 6, 5, 7, 7
    .byte 7, 8, 7, 6, 5, 7, 5, 6, 7, 7, 6, 7, 7, 5, 7, 6
    .byte 5, 6, 4, 7, 7, 7, 6, 7, 6, 5, 7, 8, 7, 6, 6, 7
    .byte 6, 6, 5, 6, 7, 6, 4, 6, 7, 7, 6, 7, 6, 6, 6
    .byte 4, 6, 7, 7, 7, 5, 5, 7, 7, 6, 5, 5, 7, 4, 6
    .byte 6, 7, 5, 7, 7, 6, 5, 7, 7, 6, 8, 7, 7, 6, 7, 6
    .byte 6, 7, 7, 7, 6, 7, 7, 7, 7, 8, 7, 6, 7, 5, 6, 4
    .byte 7, 6, 5, 7, 7, 6, 6, 4, 8, 7, 6, 7, 7, 7, 5, 6
    .byte 7, 7, 6, 7, 6, 7, 7, 5, 6, 7, 6, 5, 4, 7, 6
    .byte 5, 7, 7, 6, 7, 7, 6, 5, 7, 6, 6, 6, 6, 6, 6
    .byte 6, 7, 6, 5, 7, 5, 6, 7, 4, 6, 6, 6, 7, 7, 7
    .byte 7, 7, 7, 7, 6, 6, 7, 7, 6, 5, 7, 7, 6, 6, 8, 8
    .byte 6, 7, 5, 5, 7, 6, 6, 5, 6, 6, 7, 6, 7, 6, 7
    .byte 6, 7, 8, 6, 5, 7, 7, 7, 7, 6, 6, 7, 7, 6, 7, 7
    .byte 7, 4, 6, 6, 7, 7, 6, 8, 4, 7, 7, 5, 6, 6, 7, 6
    .byte 6, 7, 5, 7, 3, 6, 7, 6, 5, 7, 7, 6, 5, 7, 7
    .byte 4, 6, 6, 7, 7, 7, 7, 6, 7, 7, 7, 7, 5, 7, 7
    .byte 8, 7, 6, 7, 6, 5, 6, 7, 5, 7, 6, 7, 6, 7, 6, 5
    .byte 7, 6, 6, 7, 7, 7, 6, 7, 6, 7, 6, 7, 6, 6, 7
    .byte 7, 6, 5, 6, 6, 5, 6, 7, 6, 7, 7, 6, 7, 7, 6
    .byte 6, 6, 7, 4, 6, 7, 5, 6, 5, 5, 5, 6, 6, 6, 7
    .byte 6, 7, 6, 7, 5, 5, 7, 7, 7, 7, 7, 7, 6, 7, 6
    .byte 5, 6, 8, 6, 8, 7, 7, 7, 6, 6, 6, 6, 7, 5, 7, 5
    .byte 7, 7, 6, 6, 7, 6, 7, 7, 7, 7, 8, 7, 7, 4, 7, 6
    .byte 7, 6, 7, 6, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6
    .byte 6, 6, 6, 6, 5, 7, 7, 6, 4, 7, 7, 7, 4, 5, 7
    .byte 6, 7, 7, 6, 6, 4, 6, 7, 7, 7, 6, 7, 7, 7, 6
    .byte 6, 6, 7, 7, 7, 7, 7, 4, 7, 7, 6, 6, 6, 7, 7
    .byte 6, 7, 5, 5, 6, 7, 5, 7, 6, 6, 7, 6, 6, 6, 6
    .byte 7, 7, 6, 8, 7, 7, 7, 6, 6, 7, 7, 5, 7, 7, 6, 4
    .byte 6, 6, 6, 6, 6, 5, 5, 7, 5, 6, 6, 5, 6, 7, 6
    .byte 6, 6, 6, 5, 7, 7, 8, 6, 7, 7, 7, 5, 7, 6, 6, 6
    .byte 7, 7, 6, 7, 6, 7, 7, 7, 8, 7, 6, 6, 6, 7, 5, 7
    .byte 6, 7, 6, 7, 4, 7, 7, 5, 6, 7, 7, 7, 6, 7, 6
    .byte 6, 6, 6, 7, 7, 5, 8, 7, 7, 7, 7, 6, 6, 4, 5, 5
    .byte 7, 6, 7, 6, 7, 6, 6, 7, 7, 6, 7, 7, 5, 6, 6
    .byte 6, 6, 6, 7, 5, 7, 6, 7, 6, 6, 7, 6, 4, 5, 6
    .byte 7, 7, 7, 7, 6, 7, 7, 7, 6, 7, 7, 7, 6, 7, 7
    .byte 5, 7, 7, 6, 6, 6, 6, 7, 8, 8, 5, 7, 6, 6, 5, 6
    .byte 7, 6, 5, 5, 6, 6, 7, 7, 7, 6, 7, 7, 6, 7, 7
    .byte 7, 5, 5, 6, 6, 7, 6, 6, 5, 7, 7, 6, 6, 6, 7
    .byte 6, 6, 7, 7, 6, 3, 7, 7, 6, 4, 7, 6, 7, 7, 7
    .byte 6, 7, 5, 4, 5, 7, 6, 7, 6, 7, 7, 7, 5, 7, 7
    .byte 7, 7, 7, 7, 6, 6, 7, 7, 5, 7, 5, 7, 7, 6, 7
    .byte 7, 6, 6, 5, 7, 7, 7, 7, 7, 6, 4, 6, 7, 6, 6
    .byte 7, 7, 7, 7, 6, 5, 6, 7, 3, 7, 7, 5, 7, 6, 7
    .byte 6, 7, 7, 5, 7, 6, 6, 7, 6, 8, 7, 7, 4, 5, 6, 7
    .byte 5, 5, 7, 7, 4, 6, 7, 6, 6, 7, 6, 7, 8, 6, 6, 6
    .byte 7, 7, 6, 5, 6, 7, 6, 6, 6, 7, 7, 5, 5, 7, 6
    .byte 7, 4, 6, 6, 7, 5, 6, 7, 7, 6, 6, 6, 7, 6, 7
    .byte 7, 7, 7, 7, 6, 6, 7, 7, 5, 4, 7, 5, 5, 6, 6
    .byte 7, 7, 6, 6, 6, 6, 6, 4, 6, 6, 6, 7, 7, 7, 6
    .byte 7, 6, 6, 6, 6, 6, 4, 6, 6, 5, 7, 6, 5, 7, 8, 8
    .byte 7, 7, 6, 7, 7, 6, 8, 6, 7, 6, 7, 6, 7, 6, 6, 6
    .byte 6, 7, 4, 7, 6, 5, 6, 6, 7, 6, 7, 7, 7, 7, 6
    .byte 7, 6, 7, 7, 6, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6
    .byte 5, 7, 7, 6, 5, 7, 6, 7, 6, 8, 6, 7, 2, 6, 5, 7
    .byte 7, 6, 7, 6, 6, 6, 6
    .byte 7, 6, 6, 6, 5, 7, 5, 7, 7, 7, 7, 6, 7, 7, 7
    .byte 6, 7, 6, 7, 6, 5, 6, 7, 6, 5, 5, 7, 7, 6, 6
    .byte 7, 6, 6, 5, 5, 7, 7, 4, 7, 7, 7, 6, 6, 7, 7
    .byte 7, 6, 7, 7, 7, 7, 7, 5, 7, 7, 6, 6, 5, 6, 5
    .byte 7, 7, 6, 5, 6, 6, 7, 6, 6, 5, 4, 6, 6, 4, 6
    .byte 7, 6, 4, 8, 8, 7, 6, 7, 6, 6, 7, 5, 7, 7, 7, 7
    .byte 7, 6, 7, 7, 7, 7, 7, 7, 8, 4, 6, 7, 6, 4, 6, 7
    .byte 7, 6, 6, 7, 6, 7, 6, 5, 7, 5, 6, 7, 7, 8, 6, 7
    .byte 7, 6, 7, 6, 6, 6, 7, 7, 6, 7, 7, 6, 7, 7, 5
    .byte 6, 6, 8, 6, 6, 7, 7, 5, 5, 7, 7, 4, 4, 4, 7, 7
    .byte 6, 7, 6, 7, 6, 7, 6, 5, 6, 6, 7, 6, 6, 7, 6
    .byte 7, 7, 4, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 6, 6
    .byte 6, 5, 5, 7, 6, 7, 6, 5, 5, 5, 7, 6, 6, 7, 8, 5
    .byte 6, 7, 7, 8, 5, 7, 7, 8, 6, 6, 6, 8, 7, 6, 7, 7
    .byte 7
    .byte 6, 6, 6, 7, 7, 4, 7, 6, 6, 5, 3, 7, 6, 7, 6
    .byte 4, 8, 7, 5, 6, 7, 5, 5, 7, 7, 6, 8, 7, 6, 7, 6
    .byte 6, 7, 7, 6, 4, 6, 7, 7, 7, 6, 7, 7, 7, 7, 6
    .byte 6, 6, 6, 7, 5, 6, 6, 7, 5, 5, 5, 5, 7, 5, 7
    .byte 6, 7, 6, 6, 7, 7, 7, 7, 7, 7, 7, 8, 7, 5, 7, 6
    .byte 7, 7, 7, 8, 7, 7, 6, 6, 5, 5, 7, 6, 7, 5, 6, 5
    .byte 6, 7, 4, 6, 7, 6, 5, 7, 7, 5, 6, 6, 7, 7, 6
    .byte 7, 7, 5, 6, 7, 7, 7, 6, 6, 6, 7, 5, 7, 7, 7
    .byte 7, 7, 6, 6, 7, 6, 6, 6, 7, 6, 7, 5, 7, 6, 7
    .byte 3, 5, 7, 6, 7, 6, 7, 6, 5, 6, 6, 7, 7, 7, 7
    .byte 6, 6, 7, 7, 6, 7, 7, 8, 7, 7, 7, 5, 7, 6, 6, 6
    .byte 4, 5, 7, 7, 7, 5, 6, 6, 7, 6, 6, 6, 6, 7, 7
    .byte 5, 5, 6, 6, 7, 7, 5, 8, 7, 6, 7, 8, 6, 5, 7, 7
    .byte 7, 6, 6, 7, 5, 6, 7, 6, 5, 7, 6, 7, 6, 7, 6
    .byte 7, 6, 6, 5, 7, 5, 6, 7, 6, 5, 7, 7, 7, 6, 7
    .byte 6, 7, 7, 7, 7, 5, 8, 7, 6, 7, 7, 7, 7, 7, 7, 7
    .byte 6, 7, 7, 5, 6, 6, 6, 3, 5, 5, 7, 7, 6, 6, 7
    .byte 6, 7, 7, 6, 4, 5, 6, 7, 6, 6, 7, 5, 5, 7, 7
    .byte 7, 7, 6, 6, 7, 6, 7, 7, 8, 6, 7, 6, 6, 6, 6, 6
    .byte 6, 7, 6, 6, 5, 7, 6, 6, 4, 4, 7, 7, 7, 6, 6
    .byte 7, 6, 7, 7, 7, 7, 6, 7, 7, 5, 6, 7, 6, 7, 7
    .byte 7, 7, 7, 7, 4, 6, 6, 6, 6, 5, 5, 7, 7, 7, 5
    .byte 6, 6, 7, 6, 5, 6, 6, 7, 6, 6, 5, 6, 6, 6, 6
    .byte 5, 8, 7, 6, 7, 7, 5, 5, 6, 7, 6, 8, 6, 7, 7, 7
    .byte 6, 6, 6, 6, 6, 7, 6, 7, 6, 6, 5, 5, 4, 6, 7
    .byte 5, 7, 7, 7, 6, 7, 6, 6, 7, 6, 7, 6, 7, 7, 7
    .byte 6, 6, 7, 7, 7, 7, 7, 7, 6, 7, 6, 4, 6, 7, 6
    .byte 7, 6, 6, 5, 6, 7, 3, 7, 6, 6, 6, 7, 7, 5, 7
    .byte 7, 6, 7, 5, 7, 7, 6, 7, 7, 6, 7, 7, 4, 6, 7
    .byte 6, 7, 6, 7, 7, 7, 7, 7, 5, 5, 7, 6, 6, 7, 6
    .byte 7, 5, 5, 5, 4, 6, 7, 7, 7, 7, 5, 7, 7, 6, 7
    .byte 6, 7, 6, 7, 7, 6, 7, 7, 7, 7, 7, 7, 7, 6, 5
    .byte 6, 7, 6, 5, 7, 6, 7, 6, 3, 7, 7, 7, 5, 4, 7
    .byte 7, 5, 5, 7, 6, 6, 7, 8, 7, 7, 6, 4, 7, 7, 7, 7
    .byte 7, 7, 6, 6, 7, 7, 6, 7, 8, 5, 7, 6, 7, 5, 6, 7
    .byte 6, 7, 6, 5, 7, 6, 7, 5, 7, 6, 7, 6, 6, 6, 7
    .byte 8, 7, 6, 8, 6, 7, 6, 7, 7, 5, 7, 7, 7, 7, 7, 7
    .byte 6, 6, 7, 7, 6, 7, 7, 5, 6, 7, 7, 4, 5, 5, 6
    .byte 6, 6, 6, 7, 7, 7, 6, 6, 5, 6, 6, 6, 6, 7, 5
    .byte 6, 5, 7, 6, 7, 7, 7, 6, 5, 7, 7, 7, 7, 7, 7
    .byte 7, 6, 4, 5, 7, 7, 6, 6, 7, 7, 5, 6, 7, 6, 6
    .byte 4, 5, 6, 7, 5, 7, 6, 6, 7, 7, 6, 7, 7, 7, 8, 7
    .byte 7, 7, 6, 6, 7, 7, 6, 6, 6, 6, 6, 7, 7, 6, 4
    .byte 6, 6, 7, 5, 6, 5, 5, 7, 7, 4, 6, 6, 6, 5, 7
    .byte 7, 6, 6, 7, 3, 7, 7, 6, 7, 7, 6, 7, 7, 8, 7, 7
    .byte 7, 7, 7, 7, 7, 7, 7, 5, 6, 6, 6, 6, 6, 7, 6
    .byte 7, 5, 8, 6, 5, 5, 6, 6, 7, 7, 7, 7, 7, 7, 7, 6
    .byte 6, 7, 7, 7, 7, 7, 8, 6, 7, 6, 7, 6, 6, 5, 7, 8
    .byte 6, 5, 7, 7, 7, 6, 7, 7, 6, 3, 6, 5, 8, 7, 7, 7
    .byte 7, 6, 6, 6, 7, 5, 6, 7, 6, 5, 6, 7, 6, 6, 6
    .byte 5, 7, 7, 6, 7, 7, 7, 7, 7, 4, 7, 6, 7, 6, 6
    .byte 7, 7, 6, 5, 6, 6, 7, 4, 5, 7, 6, 5, 7, 7, 7
    .byte 6, 7, 7, 7, 7, 7, 7, 6, 8, 7, 7, 6, 7, 6, 6, 5
    .byte 7, 5, 5, 6, 7, 7, 7, 5, 6, 5, 5, 6, 5, 6, 5
    .byte 7, 6, 6, 7, 7, 7, 7, 7, 5, 5, 6, 6, 6, 6, 5
    .byte 7, 7, 6, 6, 7, 7, 6, 6, 7, 8, 6, 7, 8, 5, 6, 6
    .byte 5, 5, 7, 7, 6, 7, 7, 6, 6, 7, 6, 5, 6, 6, 6
    .byte 7, 7, 8, 7, 7, 8, 5, 7, 5, 6, 6, 7, 7, 6, 7, 6
    .byte 6, 6, 6, 6, 7, 6, 7, 7, 6, 6, 7, 4, 5, 6, 6
    .byte 4, 5, 5, 7, 7, 5, 6, 7, 7, 7, 7, 7, 5, 6, 5
    .byte 6, 7, 6, 7, 7, 7, 6, 5, 6, 7, 8, 6, 7, 6, 6, 6
    .byte 7, 7, 7, 7, 7, 5, 6, 6, 5, 6, 5, 5, 5, 6, 6
    .byte 7, 7, 6, 6, 5, 5, 6, 6, 7, 6, 6, 7, 7, 7, 7
    .byte 7, 7, 7, 6, 8, 6, 6, 7, 7, 6, 8, 6, 3, 6, 7, 6
    .byte 6, 6, 6, 7, 6, 6, 6, 6, 6, 3, 7, 7, 7, 6, 7
    .byte 6, 7, 8, 6, 6, 6, 7, 6, 7, 7, 5, 7, 7, 7, 7, 7
    .byte 6, 5, 6, 7, 7, 6, 6, 7, 7, 7, 7, 6, 6, 6, 5
    .byte 5, 5, 6, 7, 6, 5, 7, 5, 7, 7, 7, 6, 6, 7, 7
    .byte 7, 7, 7, 6, 7, 7, 7, 7, 7, 5, 6, 6, 5, 7, 7
    .byte 4, 6, 5, 5, 6, 7, 5, 6, 6, 6, 6, 7, 5, 4, 5
    .byte 7, 6, 6, 7, 6, 5, 7, 6, 6, 6, 5, 6, 7, 7, 7
    .byte 5, 7, 7, 7, 7, 7, 7, 6, 7, 6, 7, 5, 7, 6, 7
    .byte 7, 7, 6, 5, 5, 6, 6, 6, 5, 7, 7, 6, 7, 5, 7
    .byte 7, 7, 6, 5, 6, 6, 7, 6, 7, 7, 6, 7, 7, 7, 7
    .byte 6, 6, 7, 6, 7, 6, 4, 5, 5, 6, 5, 7, 6, 7, 5
    .byte 6, 6, 7, 6, 4, 5, 6, 7, 6, 6, 5, 6, 7, 5, 7
    .byte 6, 6, 6, 7, 7, 7, 7, 4, 7, 7, 8, 7, 7, 7, 6, 6
    .byte 7, 6, 7, 6, 7, 6, 7, 7, 6, 6, 6, 6, 6, 6, 6
    .byte 6, 7, 7, 7, 4, 6, 7, 7, 7, 6, 7, 7, 7, 7, 7
    .byte 7, 6, 7, 7, 8, 6, 6, 6, 7, 6, 7, 6, 4, 6, 7, 6
    .byte 6, 6, 6, 7, 7, 5, 5, 6, 6, 4, 7, 7, 7, 6, 7
    .byte 6, 7, 7, 6, 4, 7, 7, 5, 6, 7, 6, 6, 4, 7, 6
    .byte 5, 6, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 5, 6, 7, 7
    .byte 6, 6, 7, 7, 5, 7, 7, 6, 6, 5, 7, 7, 6, 5, 5
    .byte 6, 7, 6, 7, 7, 7, 6, 7, 7, 6, 6, 7, 6, 6, 7
    .byte 7, 6, 5, 6, 6, 6, 6, 7, 6, 7, 6, 5, 7, 7, 6
    .byte 5, 6, 7, 3, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 5
    .byte 7, 3, 7, 6, 6, 7, 7, 7, 7, 7, 7, 7, 6, 7, 7
    .byte 7, 7, 4, 7, 8, 7, 6, 7, 7, 6, 7, 6, 4, 7, 6, 6
    .byte 6, 6, 6, 6, 6, 7, 5, 7, 6, 7, 7, 5, 6, 7, 6
    .byte 8, 7, 5, 6, 7, 7, 5, 7, 7, 6, 4, 6, 6, 6, 7, 6
    .byte 7, 5, 7, 7, 6, 7, 6, 6, 5, 6, 7, 5, 6, 5, 6
    .byte 7, 7, 4, 6, 6, 6, 5, 7, 6, 6, 7, 6, 6, 7, 7
    .byte 7, 7, 7, 7, 6, 6, 7, 6, 7, 7, 7, 7, 5, 8, 6, 6
    .byte 5, 6, 6, 5, 7, 7, 7, 6, 4, 8, 6, 6, 7, 7, 7, 5
    .byte 5, 6, 7, 7, 6, 6, 6, 6, 4, 7, 6, 7, 6, 4, 7
    .byte 6, 5, 6, 7, 6, 6, 7, 6, 5, 7, 7, 5, 5, 6, 5
    .byte 7, 6, 6, 6, 7, 5, 6, 6, 5, 6, 6, 7, 6, 6, 6
    .byte 7, 7, 7, 8, 6, 6, 7, 6, 5, 5, 7, 7, 7, 7, 7, 6
    .byte 6, 7, 6, 6, 6, 5, 7, 6, 7, 7, 7, 5, 7, 5, 7
    .byte 7, 6, 7, 8, 6, 6, 4, 7, 7, 7, 7, 7, 6, 6, 7, 6
    .byte 6, 7, 6, 5, 7, 7, 6, 7, 5, 6, 6, 7, 5, 6, 8, 7
    .byte 3, 7, 8, 7, 5, 5, 7, 6, 6, 6, 7, 4, 6, 6, 7, 6
    .byte 7, 7, 7, 6, 6, 6, 6, 7, 6, 6, 8, 6, 7, 7, 7, 6
    .byte 5, 6, 7, 7, 6, 6, 7, 7, 6, 4, 6, 6, 7, 6, 7
    .byte 6, 6, 6, 6, 7, 6, 8, 7, 6, 7, 6, 7, 6, 6, 6, 5
    .byte 4, 7, 6, 7, 6, 6, 6, 7, 6, 5, 6, 8, 6, 6, 5, 7
    .byte 4, 6, 7, 7, 6, 6, 5, 5, 6, 6, 7, 7, 4, 5, 6
    .byte 5, 7, 7, 6, 6, 7, 7, 6, 7, 7, 7, 6, 6, 7, 6
    .byte 7, 4, 7, 7, 5, 6, 6, 6, 7, 7, 6, 7, 7, 5, 6
    .byte 6, 6, 7, 5, 7, 5, 7, 5, 7, 6, 7, 7, 7, 8, 7, 7
    .byte 7, 6, 6, 7, 5, 5, 5, 6, 7, 7, 6, 6, 6, 7, 4
    .byte 6, 7, 7, 7, 4, 6, 7, 7, 7, 6, 5, 5, 7, 6, 6
    .byte 5, 6, 6, 6, 5, 6, 7, 6, 7, 6, 7, 6, 6, 7, 6
    .byte 7, 7, 7, 8, 6, 8, 6, 7, 6, 7, 6, 6, 7, 7, 7, 7
    .byte 7, 6, 6, 6, 5, 6, 6, 7, 6, 6, 7, 5, 6, 6, 8, 8
    .byte 6, 6, 6, 7
    .byte 6, 6, 6, 5, 5, 7, 6, 6, 7, 6, 7, 6, 7, 7, 4
    .byte 7, 7, 7, 5, 7, 5, 6, 6, 6, 7, 4, 7, 5, 6, 6
    .byte 5, 6, 7, 5, 6, 6, 6, 7, 7, 8, 7, 7, 7, 7, 5, 6
    .byte 7, 7, 7, 7, 7, 6, 5, 7, 5, 6, 6, 7, 6, 6, 7
    .byte 6, 7, 5, 5, 6, 4, 7, 7, 6, 7, 7, 7, 4, 7, 7
    .byte 7, 6, 6, 7, 7, 7, 6, 6, 7, 6, 4, 7, 6, 6, 5
    .byte 7, 6, 6, 5, 5, 6, 7, 7, 7, 5, 5, 7, 7, 7, 6
    .byte 4, 7, 7, 6, 6, 5, 6, 5, 5, 6, 6, 7, 5, 7, 7
    .byte 6, 8, 8, 7, 7, 7, 7, 6, 7, 6, 6, 6, 7, 5, 6, 7
    .byte 6, 6, 6, 7, 5, 6, 6, 4, 7, 6, 7, 7, 6, 6, 6
    .byte 7, 6, 7, 7, 6, 7, 6, 7, 6, 6, 5, 6, 7, 7, 5
    .byte 7, 6, 7, 4, 6, 6, 7, 7, 5, 7, 6, 6, 6, 5, 5
    .byte 5, 6, 5, 6, 6, 7, 6, 5, 6, 6, 5, 6, 6, 6, 6
    .byte 7, 6, 7, 6, 6, 7, 6, 7, 7, 8, 6, 6, 8, 7, 7, 6
    .byte 7, 6, 7, 7, 6, 7, 7, 7, 7, 6, 4, 6, 5, 6, 5
    .byte 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 6, 7, 6
    .byte 7, 6, 5, 6, 7, 7, 7, 6, 6, 5, 7, 5, 7, 5, 7
    .byte 7, 6, 7, 6, 7, 6, 4, 7, 6, 6, 4, 7, 7, 5, 6
    .byte 7, 4, 6, 6, 6, 6, 7, 6, 6, 7, 6, 6, 7, 7, 7
    .byte 7, 5, 8, 5, 7, 7, 6, 7, 7, 7, 7, 5, 7, 7, 6, 5
    .byte 5, 6, 5, 7, 6, 6, 6, 7, 6, 7, 6, 8, 7, 5, 7, 6
    .byte 7, 6, 7, 6, 5, 6, 6, 4, 7, 7, 5, 6, 7, 6, 7
    .byte 6, 7, 6, 6, 6, 6, 6, 5, 6, 7, 7, 5, 7, 7, 7
    .byte 6, 3, 7, 7, 7, 6, 6, 6, 7, 6, 6, 7, 6, 6, 7
    .byte 7, 6, 8, 6, 7, 7, 7, 7, 6, 7, 6, 7, 8, 7, 6, 7
    .byte 7, 7, 6, 6, 6, 6, 6, 6, 7, 7, 5, 7, 7, 7, 5
    .byte 6, 6, 6, 7, 7, 7, 7, 5, 6, 7, 7, 5, 5, 5, 6
    .byte 6, 7, 6, 6, 7, 5, 7, 7, 7, 6, 6, 7, 5, 6, 7
    .byte 6, 6, 6, 6, 6, 7, 2, 6, 7, 7, 6, 6, 7, 7, 6
    .byte 7, 7, 8, 7, 6, 7, 7, 6, 7, 7, 5, 6, 8, 6, 7, 6
    .byte 8, 6, 6, 6, 7, 6, 6, 6, 6, 7, 7, 7, 7, 6, 6, 6
    .byte 6, 6, 7, 6, 6, 7, 7, 7, 7, 5, 7, 7, 7, 6, 6
    .byte 6, 4, 7, 7, 7, 5, 5, 7, 6, 6, 6, 5, 6, 7, 6
    .byte 7, 6, 7, 6, 6, 6, 6, 6, 5, 6, 5, 5, 5, 6, 6
    .byte 6, 5, 7, 7, 5, 7, 6, 7, 7, 6, 7, 7, 7, 6, 7
    .byte 6, 6, 7, 7, 7, 7, 7, 7, 6, 7, 5, 6, 6, 7, 5
    .byte 8, 7, 6, 7, 7, 7, 3, 5, 5, 7, 6, 5, 8, 7, 7, 7
    .byte 6, 8, 5, 7, 5, 6, 8, 7, 4, 6, 6, 5, 7, 7, 6, 6
    .byte 6, 6, 7, 8, 6, 6, 6, 7, 5, 6, 7, 5, 5, 6, 6, 6
    .byte 5, 7, 6, 6, 7, 6, 6, 6, 6, 5, 6, 6, 7, 8, 7, 7
    .byte 6, 7, 6, 6, 7, 7, 6, 6, 7, 6, 6, 7, 5, 6, 6
    .byte 7, 7, 7, 6, 7, 7, 5, 6, 6, 6, 6, 6, 7, 7, 7
    .byte 6, 7, 6, 7, 6, 6, 6, 6, 6, 6, 6, 7, 5, 6, 7
    .byte 7, 6, 7, 6, 5, 6, 5, 7, 5, 6, 7, 7, 8, 4, 8, 6
    .byte 7, 5, 5, 6, 5, 5, 5, 7, 5, 6, 7, 6, 7, 6, 6
    .byte 6, 7, 7, 8, 7, 6, 6, 6, 7, 7, 7, 6, 7, 5, 6, 6
    .byte 6, 6, 6, 5, 6, 7, 7, 7, 6, 7, 6, 5, 7, 7, 7
    .byte 6, 7, 6, 7, 7, 7, 6, 7, 8, 6, 6, 6, 6, 7, 7, 6
    .byte 7, 8, 4, 6, 7, 7, 7, 6, 6, 5, 7, 7, 4, 6, 6, 6
    .byte 7, 7, 6, 5, 6, 6, 8, 6, 6, 7, 7, 5, 5, 5, 7, 6
    .byte 7, 7, 6, 8, 7, 5, 8, 7, 7, 6, 8, 7, 5, 7, 6, 6
    .byte 6
    .byte 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 7, 7, 7, 7, 7
    .byte 6, 4, 5, 7, 5, 7, 7, 7, 7, 7, 6, 6, 5, 7, 3
    .byte 6, 7, 6, 7, 6, 6, 7, 8, 8, 5, 7, 6, 5, 6, 5, 7
    .byte 7, 7, 4, 6, 7, 7, 4, 5, 7, 7, 7, 6, 7, 5, 5
    .byte 5, 8, 7, 7, 7, 7, 8, 7, 6, 6, 7, 6, 7, 7, 7, 7
    .byte 5, 7, 7, 6, 6, 6, 7, 7, 7, 7, 6, 6, 7, 6, 5
    .byte 7, 7, 6, 4, 6, 6, 5, 7, 6, 7, 6, 7, 7, 6, 7
    .byte 7, 7, 5, 5, 6, 6, 6, 7, 6, 6, 7, 7, 6, 7, 5
    .byte 7, 6, 5, 6, 6, 7, 4, 7, 6, 5, 5, 7, 5, 7, 8, 7
    .byte 6, 7, 6, 7, 5, 7, 7, 7, 7, 7, 7, 6, 7, 5, 6
    .byte 7, 7, 7, 7, 6, 5, 7, 6, 5, 6, 7, 7, 6, 7, 5
    .byte 7, 8, 6, 6, 7, 6, 6, 7, 6, 7, 5, 7, 7, 6, 6, 5
    .byte 7, 6, 8, 7, 7, 6, 7, 3, 5, 5, 7, 6, 7, 7, 6, 6
    .byte 6, 6, 7, 6, 6, 6, 4, 6, 5, 7, 6, 7, 7, 5, 7
    .byte 6, 7, 7, 6, 6, 5, 6, 3, 7, 8, 7, 7, 7, 6, 7, 7
    .byte 7, 6, 6, 7, 7, 6, 7, 7, 5, 6, 7, 7, 6, 6, 7
    .byte 7, 5, 7, 6, 5, 7, 7, 5, 7, 6, 6, 6, 6, 6, 6
    .byte 6, 7, 7, 7, 7, 7, 7, 7, 6, 7, 7, 7, 5, 7, 7
    .byte 7, 5, 6, 7, 7, 6, 6, 6, 4, 7, 5, 5, 6, 5, 6
    .byte 7, 6, 6, 6, 6, 7, 6, 6, 6, 7, 6, 6, 8, 7, 5, 7
    .byte 6, 6, 5, 6, 7, 6, 6, 7, 6, 7, 5, 7, 7, 7, 6
    .byte 6, 6, 6, 6, 6, 7, 6, 7, 7, 8, 7, 6, 7, 6, 7, 6
    .byte 6, 7, 7, 5, 7, 7, 7, 5, 6, 5, 6, 5, 5, 7, 7
    .byte 7, 5, 4, 6, 5, 6, 6, 6, 7, 5, 6, 7, 5, 7, 5
    .byte 6, 7, 6, 7, 5, 6, 7, 5, 7, 4, 7, 6, 8, 7, 5, 7
    .byte 5, 7, 6, 7, 5, 4, 7, 6, 7, 7, 5, 7, 7, 7, 6
    .byte 7, 6, 5, 7, 7, 7, 6, 6, 6, 6, 7, 6, 7, 7, 6
    .byte 8, 7, 6, 7, 6, 6, 7, 7, 6, 6, 7, 5, 6, 6, 5, 7
    .byte 4, 7, 5, 6, 7, 3, 7, 6, 6, 7, 6, 6, 6, 6, 6
    .byte 6, 7, 6, 5, 5, 7, 7, 7, 7, 6, 6, 7, 5, 7, 6
    .byte 7, 7, 7, 8, 6, 6, 7, 6, 6, 5, 6, 7, 4, 6, 7, 7
    .byte 6, 7, 7, 6, 6, 8, 6, 7, 7, 6, 7, 6, 8, 5, 7, 7
    .byte 6, 7, 7, 6, 7, 6, 6, 5, 7, 7, 7, 7, 6, 7, 6
    .byte 5, 5, 5, 6, 6, 6, 5, 7, 6, 5, 4, 7, 6, 7, 8, 6
    .byte 6, 6, 6, 6, 5, 7, 5, 5, 6, 7, 5, 7, 6, 6, 6
    .byte 7, 6, 5, 7, 6, 7, 7, 7, 7, 6, 5, 6, 6, 6, 5
    .byte 6, 6, 7, 7, 7, 7, 6, 6, 7, 8, 7, 6, 7, 5, 7, 7
    .byte 7, 5, 7, 8, 7, 6, 7, 6, 7, 5, 6, 7, 8, 6, 7, 7
    .byte 7, 6, 6, 4, 6, 3, 6, 6, 6, 5, 8, 7, 4, 6, 6, 7
    .byte 6, 7, 7, 6, 7, 6, 5, 8, 7, 4, 6, 7, 7, 5, 7, 5
    .byte 7, 6, 5, 6, 7, 7, 7, 7, 7, 6, 6, 7, 6, 6, 6
    .byte 7, 5, 7, 6, 6, 6, 6, 7, 6, 6, 7, 7, 7, 6, 7
    .byte 7, 6, 7, 6, 6, 8, 7, 7, 6, 7, 6, 6, 8, 7, 6, 7
    .byte 7, 6, 2, 7, 6, 7, 6, 5, 7, 8, 7, 7, 5, 5, 6, 6
    .byte 5, 7, 7, 6, 4, 7, 7, 6, 6, 6, 6, 6, 5, 6, 6
    .byte 6, 6, 6, 7, 7, 6, 6, 6, 7, 7, 7, 6, 8, 7, 6, 7
    .byte 6, 5, 6, 7, 6, 7, 6, 7, 5, 6, 6, 6, 7, 7, 6
    .byte 7, 7, 6, 5, 7, 6, 6, 5, 7, 7, 7, 8, 5, 7, 5, 7
    .byte 7, 7, 6, 7, 6, 5, 5, 6, 6, 6, 6, 6, 6, 7, 7
    .byte 4, 8, 6, 6, 5, 5, 7, 7, 7, 6, 7, 6, 7, 7, 7, 6
    .byte 6, 6, 6, 6, 4, 6, 6, 6, 7, 7, 5, 7, 8, 8, 6, 5
    .byte 5, 5, 7, 6, 5, 6, 7, 7, 7, 7, 7, 3, 6, 7, 7
    .byte 5, 6, 8, 6, 7, 7, 7, 5, 7, 7, 7, 7, 7, 7, 7, 6
    .byte 6, 6, 7, 6, 7, 7, 7, 6, 5, 5, 5, 7, 6, 6, 7
    .byte 5, 6, 6, 6, 5, 5, 5, 6, 8, 7, 6, 7, 8, 4, 6, 5
    .byte 7, 6, 6, 6, 5, 7, 6, 6, 6, 7, 7, 7, 6, 7, 7
    .byte 7, 7, 6, 6, 6, 6, 6, 5, 6, 6, 6, 6, 7, 5, 6
    .byte 6, 6, 7, 6, 7, 7, 7, 6, 7, 7, 7, 6, 6, 6, 7
    .byte 6, 8, 7, 7, 7, 6, 6, 6, 7, 7, 6, 7, 6, 6, 5, 6
    .byte 6, 6, 7, 6, 5, 6, 5, 7, 6, 6, 5, 7, 5, 5, 7
    .byte 6, 7, 6, 8, 8, 4, 6, 6, 5, 6, 6, 6, 6, 7, 7, 7
    .byte 7, 6, 7, 6, 6, 7, 6, 6, 6, 7, 7, 6, 5, 5, 5
    .byte 6, 6, 7, 7, 6, 7, 7, 6, 6, 6, 7, 7, 7, 7, 7
    .byte 6, 6, 8, 7, 7, 7, 6, 6, 7, 6, 7, 7, 6, 6, 7, 6
    .byte 4, 4, 6, 6, 6, 6, 7, 5, 7, 7, 5, 6, 6, 7, 5
    .byte 7, 8, 6, 5, 5, 7, 6, 7, 6, 6, 6, 7, 7, 6, 6, 7
    .byte 7, 6, 6, 7, 6, 5, 4, 8, 7, 6, 7, 6, 7, 6, 7, 6
    .byte 7, 6, 5, 7, 6, 7, 5, 7, 7, 7, 7, 7, 7, 7, 6
    .byte 6, 8, 6, 5, 8, 7, 8, 7, 6, 7, 7, 7, 6, 7, 7, 6
    .byte 7
    .byte 5, 7, 6, 7, 6, 6, 5, 6, 6, 7, 5, 7, 6, 7, 5
    .byte 6, 7, 7, 7, 6, 8, 6, 7, 6, 6, 7, 4, 7, 7, 6, 7
    .byte 7, 7, 7, 7, 8, 6, 6, 5, 7, 6, 7, 6, 6, 6, 6, 5
    .byte 7, 6, 7, 6, 6, 6, 6, 6, 7, 6, 6, 7, 7, 6, 8, 7
    .byte 6, 6, 7, 6, 6, 6, 7, 6, 7, 5, 5, 7, 8, 6, 6, 6
    .byte 7, 6, 7, 6, 6, 7, 5, 5, 7, 6, 6, 6, 7, 5, 4
    .byte 5, 5, 6, 5, 7, 7, 7, 5, 7, 6, 5, 6, 6, 6, 7
    .byte 5, 7, 6, 7, 7, 5, 7, 6, 6, 6, 6, 7, 7, 7, 7
    .byte 5, 6, 7, 7, 7, 4, 7, 7, 7, 6, 7, 7, 7, 6, 5
    .byte 7, 7, 6, 7, 7, 6, 7, 6, 7, 6
    .byte 6, 7, 7, 7, 7, 6, 6, 7, 7, 7, 7, 8, 6, 7, 6, 6
    .byte 6, 5, 7, 6, 4, 7, 6, 6, 4, 5, 5, 6, 6, 6, 7
    .byte 6, 5, 7, 7, 8, 5, 5, 5, 6, 7, 7, 7, 6, 8, 6, 6
    .byte 7, 7, 6, 6, 7, 4, 6, 7, 7, 7, 6, 8, 6, 7, 7, 6
    .byte 5, 5, 7, 6, 6, 4, 6, 8, 6, 7, 7, 7, 7, 5, 7, 7
    .byte 7, 5, 6, 7, 7, 7, 6, 6, 7, 7, 7, 5, 7, 7, 6
    .byte 8, 7, 7, 4, 6, 6, 6, 7, 7, 7, 6, 7, 6, 4, 5, 6
    .byte 6, 6, 7, 6, 7, 5, 7, 6, 6, 6, 6, 7, 6, 7, 6
    .byte 7, 7, 5, 6, 7, 7, 5, 6, 5, 7, 7, 6, 7, 7, 6
    .byte 7, 6, 5, 6, 6, 7, 6, 6, 6, 7, 5, 6, 7, 7, 7
    .byte 7, 7, 7, 6, 6, 6, 7, 5, 7, 7, 8, 7, 7, 7, 5, 6
    .byte 7, 7, 7, 5, 6, 6, 7, 6, 3, 7, 7, 6, 7, 7, 7
    .byte 4, 6, 6, 5, 6, 5, 5, 7, 7, 6, 6, 7, 5, 6, 4
    .byte 7, 7, 7, 6, 6, 6, 7, 6, 6, 7, 7, 6, 6, 7, 7
    .byte 5, 7, 7, 6, 6, 7, 7, 6, 6, 6, 7, 4, 7, 6, 7
    .byte 6, 7, 6, 7, 7, 8, 7, 5, 7, 7, 6, 6, 7, 6, 7, 8
    .byte 7, 7, 7, 6, 7, 6, 5, 8, 6, 7, 7, 7, 5, 6, 5, 6
    .byte 6, 7, 7, 5, 5, 6, 6, 6, 7, 4, 7, 6, 6, 6, 6
    .byte 6, 7, 6, 7, 4, 6, 6, 6, 6, 6, 7, 5, 7, 7, 6
    .byte 6, 6, 5, 6, 7, 7, 7, 7, 7, 7, 6, 6, 5, 7, 6
    .byte 7, 5, 6, 6, 7, 6, 8, 8, 6, 8, 7, 6, 6, 5, 7, 6
    .byte 4
    .byte 7, 6, 7, 7, 7, 7, 7, 6, 5, 7, 5, 6, 7, 7, 7
    .byte 7, 5, 6, 6, 7, 6, 6, 7, 6, 7, 4, 7, 7, 7, 5
    .byte 4, 7, 7, 7, 7, 6, 7, 6, 6, 7, 8, 6, 6, 7, 6, 5
    .byte 6, 6, 6, 7, 6, 7, 6, 7, 7, 7, 7, 6, 5, 7, 7
    .byte 6, 6, 7, 6, 7, 6, 5, 4, 8, 7, 7, 7, 6, 6, 6, 6
    .byte 7, 7, 5, 7, 7, 6, 7, 7, 6, 7, 7, 6, 6, 7, 7
    .byte 7, 7, 7, 6, 4, 7, 5, 5, 7, 7, 5, 5, 6, 6, 7
    .byte 6, 7, 4, 7, 6, 6, 4, 5, 7, 7, 6, 5, 5, 6, 7
    .byte 7, 6, 6, 6, 6, 5, 7, 6, 6, 6, 6, 7, 6, 7, 7
    .byte 7, 6, 7, 5, 7, 7, 6, 7, 6, 7, 4, 7, 5, 6, 7
    .byte 8, 7, 7, 7, 6, 5, 6, 7, 7, 6, 7, 7, 7, 6, 6, 6
    .byte 6, 7, 6, 7, 6, 7, 6, 5, 7, 7, 4, 6, 7, 5, 7
    .byte 7, 6, 6, 5, 5, 6, 7, 5, 6, 7, 7, 5, 7, 7, 7
    .byte 5, 6, 6, 6, 5, 7, 7, 6, 7, 5, 6, 5, 7, 5, 5
    .byte 6, 6, 6, 7, 6, 5, 6, 7, 6, 6, 6, 7, 7, 5, 8, 6
    .byte 6, 5, 6, 7, 7, 7, 7, 8, 6, 7, 6, 6, 7, 7, 7, 5
    .byte 8, 6, 7, 6, 5, 7, 7, 7, 6, 8, 5, 7, 7, 6, 5, 6
    .byte 7, 6, 6, 6, 6, 6, 5, 5, 6, 7, 5, 7, 6, 4, 7
    .byte 7, 7, 7, 4, 5, 5, 7, 6, 7, 6, 7, 7, 5, 6, 6
    .byte 6, 6, 7, 6, 7, 7, 6, 6, 7, 6, 6, 7, 8, 7, 6, 7
    .byte 7, 7, 5, 6, 5, 7, 7, 7, 7, 7, 7, 5, 7, 8, 7, 6
    .byte 6, 7, 7, 7, 7, 6, 7, 6, 6, 6, 7, 7, 7, 7, 6
    .byte 7, 5, 7, 6, 7, 8, 7, 7, 3, 7, 7, 6, 5, 5, 6, 8
    .byte 7, 5, 7, 6, 7, 6, 6, 7, 3, 8, 7, 6, 7, 7, 7, 6
    .byte 7, 7, 6, 6, 5, 6, 7, 7, 7, 5, 5, 7, 6, 6, 7
    .byte 6, 6, 5, 7, 7, 8, 7, 7, 6, 7, 6, 6, 6, 7, 4, 6
    .byte 7, 7, 6, 7, 6, 7, 7, 7, 7, 6, 6, 7, 7, 6, 5
    .byte 7, 7, 7, 6, 6, 6, 7, 7, 6, 7, 7, 5, 6, 6, 6
    .byte 6, 7, 7, 6, 6, 7, 7, 6, 7, 7, 7, 6, 3, 7, 6
    .byte 8, 6, 7, 6, 6, 6, 6, 7, 5, 5, 7, 5, 7, 6, 5, 5
    .byte 7, 5, 6, 7, 8, 5, 6, 7, 7, 7, 7, 6, 6, 8, 6, 6
    .byte 7, 6, 7, 5, 6, 7, 6, 7, 6, 6, 7, 7, 7, 6, 7
    .byte 6, 6, 7, 6, 5, 7, 7, 5, 5, 7, 6, 4, 7, 8, 7, 6
    .byte 7, 5, 6, 6, 7, 6, 7, 7, 7, 6, 6, 7, 7, 5, 6
    .byte 4, 6, 7, 7, 6, 6, 7, 6, 5, 7, 5, 6, 5, 6, 6
    .byte 6, 5, 6, 5, 6, 6, 7, 7, 7, 7, 7, 6, 5, 6, 7
    .byte 7, 6, 6, 5, 6, 7, 6, 6, 7, 5, 6, 7, 7, 7, 6
    .byte 6, 4, 7, 7, 7, 6, 7, 6, 6, 5, 7, 6, 7, 6, 6
    .byte 7, 7, 5, 7, 6, 7, 7, 5, 6, 6, 5, 7, 6, 7, 7
    .byte 6, 7, 6, 7, 6, 5, 7, 6, 6, 7, 8, 7, 6, 6, 7, 4
    .byte 6, 5, 5, 5, 7, 7, 6, 3, 7, 6, 7, 7, 7, 7, 7
    .byte 7, 7, 6, 7, 6, 7, 5, 6, 6, 7, 6, 7, 7, 7, 6
    .byte 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6, 7, 5, 7, 6
    .byte 7, 7, 6, 7, 6, 6, 7, 6, 5, 7, 6, 5, 7, 5, 6
    .byte 5, 7, 7, 7, 5, 6, 7, 6, 6, 7, 6, 5, 7, 7, 5
    .byte 6, 7, 6, 4, 7, 7, 6, 6, 6, 5, 6, 6, 7, 6, 6
    .byte 6, 7, 6, 6, 7, 6, 6, 6, 7, 7, 6, 7, 6, 6, 7
    .byte 6, 7, 7, 4, 6, 7, 5, 6, 6, 6, 5, 7, 8, 7, 7, 5
    .byte 5, 6, 7, 6, 6, 7, 8, 6, 7, 6, 6, 7, 6, 7, 7, 7
    .byte 5, 6, 4, 7, 6, 6, 7, 6, 6, 6, 7, 7, 5, 6, 6
    .byte 5, 7, 7, 5, 5, 7, 6, 5, 5, 5, 6, 7, 6, 6, 6
    .byte 6, 7, 6, 5, 7, 5, 7, 7, 6, 7, 7, 7, 7, 7, 7
    .byte 5, 7, 7, 6, 6, 6, 6, 6, 7, 6, 6, 6, 7, 6, 8, 7
    .byte 6, 6, 8, 7, 6, 6, 7, 7, 6, 6, 7, 7, 3, 7, 7, 7
    .byte 7, 7, 6, 6, 7, 6, 6, 7, 6, 7, 6, 6, 7, 6, 5
    .byte 6, 5, 6, 6, 6, 7, 7, 7, 7, 5, 7, 5, 7, 6, 6
    .byte 5, 7, 4, 6, 6, 7, 6, 6, 6, 6, 6, 7, 7, 7, 7
    .byte 7, 7, 6, 6, 6, 6, 7, 7, 7, 6, 7, 6, 5, 5, 6
    .byte 6, 7, 6, 7, 7, 7, 7, 8, 6, 5, 6, 7, 7, 6, 7, 6
    .byte 6, 6, 5, 6, 6, 6, 8, 7, 6, 6, 6, 7, 6, 4, 6, 7
    .byte 6, 7, 7, 7, 6, 7, 7, 4, 6, 5, 7, 7, 6, 7, 5
    .byte 7, 6, 6, 7, 5, 5, 5, 6, 5, 6, 6, 7, 6, 6, 7
    .byte 7, 6, 7, 7, 7, 6, 6, 7, 6, 7, 5, 7, 8, 5, 7, 5
    .byte 6, 7, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 6, 4, 5
    .byte 7, 7, 7, 6, 6, 7, 6, 5, 7, 8, 5, 7, 6, 6, 5, 7
    .byte 6, 7, 6, 7, 6, 6, 6, 4, 7, 7, 7, 7, 5, 7, 6
    .byte 6, 5, 6, 6, 5, 7, 6, 6, 6, 7, 5, 6, 5, 7, 7
    .byte 5, 7, 6, 6, 7, 7, 6, 6, 7, 5, 7, 8, 7, 7, 6, 7
    .byte 5, 6, 7, 7, 6, 6, 7, 6, 6, 7, 7, 8, 7, 6, 6, 5
    .byte 7, 6, 6, 5, 7, 7, 5, 7, 7, 7, 6, 7, 6, 7, 5
    .byte 5, 6, 6, 6, 8, 7, 4, 7, 7, 7, 7, 7, 5, 6, 7, 6
    .byte 6, 7, 7, 4, 5, 5, 5, 7, 6, 5, 6, 8, 6, 6, 5, 5
    .byte 7, 6, 7, 6, 6, 7, 7, 7, 8, 6, 6, 6, 7, 7, 7, 6
    .byte 6, 8, 6, 7, 6, 6, 6, 7, 7, 5, 7, 7, 7, 8, 7, 5
    .byte 7, 7, 7, 5, 6, 7, 6, 6, 6, 7, 7, 6, 7, 7, 7
    .byte 7, 4, 6, 5, 6, 7, 7, 5, 7, 6, 7, 6, 6, 6, 6
    .byte 6, 6, 6, 7, 7, 5, 6, 5, 6, 5, 5, 6, 7, 7, 5
    .byte 7, 6, 4, 5, 6, 6, 7, 5, 7, 7, 7, 7, 7, 7, 6
    .byte 6, 7, 7, 8, 6, 7, 7, 7, 7, 5, 5, 7, 7, 6, 6, 7
    .byte 7, 7, 7, 6, 6, 7, 7, 6, 6, 6, 6, 6, 6, 7, 7
    .byte 6, 6, 8, 7, 7, 8, 5, 6, 5, 5, 7, 7, 5, 7, 6, 6
    .byte 7, 6, 6, 5, 7, 6, 6, 7, 7, 5, 6, 6, 5, 5, 6
    .byte 6, 6, 7, 6, 7, 4, 6, 5, 6, 7, 6, 7, 6, 7, 8, 6
    .byte 6, 6, 7, 6, 8, 7, 8, 7, 5, 7, 6, 7, 6, 8, 6, 7
    .byte 8
    .byte 7, 6, 8, 8, 7, 7, 7, 6, 6, 6, 7, 6, 6, 7, 6, 6
    .byte 7, 7, 7, 5, 8, 6, 6, 4, 5, 6, 7, 6, 7, 7, 5, 8
    .byte 7, 7, 7, 6, 6, 6, 8, 5, 5, 7, 8, 5, 6, 6, 6, 6
    .byte 6, 6, 7, 7, 6, 6, 7, 4, 7, 7, 7, 6, 6, 7, 6
    .byte 6, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6, 7, 5, 6, 6
    .byte 5, 7, 7, 6, 7, 7, 7, 8, 7, 6, 7, 6, 6, 5, 6, 7
    .byte 7, 6, 6, 7, 6, 6, 6, 7, 7, 5, 6, 6, 7, 6, 6
    .byte 6, 7, 5, 8, 6, 5, 5, 4, 7, 6, 8, 7, 5, 8, 6, 7
    .byte 6
    .byte 6, 5, 4, 6, 6, 7, 7, 6, 4, 6, 6, 7, 7, 7, 7
    .byte 6, 6, 7, 6, 6, 7, 8, 7, 7, 7, 6, 7, 7, 7, 7, 5
    .byte 7, 6, 6, 5, 7, 7, 6, 7, 7, 7, 6, 6, 7, 6, 6
    .byte 6, 7, 6, 7, 7, 6, 6, 6, 4, 7, 5, 6, 7, 7, 6
    .byte 6, 6, 6, 6, 5, 5, 7, 6, 6, 7, 6, 6, 6, 7, 5
    .byte 7, 6, 7, 6, 6, 6, 5, 6, 5, 6, 7, 6, 6, 6, 6
    .byte 6, 6, 6, 6, 7, 5, 6, 7, 7, 7, 7, 8, 7, 7, 7, 5
    .byte 6, 8, 6, 6, 6, 5, 5, 8, 6, 6, 6, 8, 7, 8, 7, 7
    .byte 5
    .byte 7, 7, 7, 6, 6, 6, 6, 7, 7, 7, 4, 8, 8, 6, 7, 7
    .byte 6, 7, 7, 7, 7, 7, 7, 6, 6, 6, 7, 5, 4, 5, 5
    .byte 7, 6, 7, 7, 6, 6, 7, 6, 7, 4, 6, 5, 7, 6, 7
    .byte 5, 6, 7, 7, 6, 6, 6, 7, 5, 6, 6, 5, 7, 5, 7
    .byte 7, 7, 7, 7, 5, 8, 6, 7, 7, 5, 6, 6, 6, 6, 5, 7
    .byte 5, 7, 7, 7, 7, 6, 6, 5, 7, 6, 7, 7, 7, 7, 7
    .byte 7, 6, 7, 6, 6, 7, 7, 6, 7, 5, 8, 6, 7, 7, 5, 6
    .byte 6, 7, 7, 6, 7, 6, 6, 7, 7, 6, 5, 7, 7, 4, 5
    .byte 5, 6, 8, 6, 5, 7, 7, 7
    .byte 4, 6, 7, 6, 6, 6, 7, 6, 7, 6, 6, 8, 7, 7, 4, 6
    .byte 6, 7, 7, 6, 7, 6, 6, 7, 7, 7, 7, 6, 7, 6, 7
    .byte 7, 6, 7, 6, 5, 6, 6, 7, 6, 6, 7, 6, 7, 6, 5
    .byte 5, 7, 6, 6, 7, 5, 6, 6, 7, 7, 8, 5, 6, 7, 6, 6
    .byte 7, 6, 6, 7, 7, 5, 6, 7, 6, 5, 6, 7, 5, 6, 6
    .byte 7, 6, 5, 6, 7, 6, 5, 5, 7, 6, 7, 6, 7, 6, 6
    .byte 6, 7, 7, 5, 7, 5, 6, 8, 6, 6, 6, 6, 6, 6, 7, 7
    .byte 6, 6, 5, 6, 7, 8, 6, 7, 6, 6, 6, 6, 6, 6, 7, 6
    .byte 7, 7, 6, 6, 6, 7, 7, 6, 6, 6, 5, 7, 7, 7, 7
    .byte 5, 7, 5, 6, 6, 6, 6, 5, 6, 7, 7, 6, 7, 6, 7
    .byte 5, 5, 4, 5, 6, 4, 6, 7, 6, 6, 7, 6, 6, 6, 7
    .byte 4, 7, 6, 8, 7, 7, 7, 6, 7, 5, 7, 7, 7, 7, 6, 6
    .byte 6, 6, 7, 7, 6, 7, 7, 7, 7, 6, 7, 7, 7, 7, 6
    .byte 7, 6, 5, 5, 7, 7, 4, 7, 7, 7, 7, 7, 6, 7, 6
    .byte 7, 7, 7, 6, 7, 5, 6, 7, 7, 5, 6, 5, 6, 7, 6
    .byte 6, 6, 8, 7, 5, 8, 5, 6, 5, 5, 7, 7, 7, 5, 6, 7
    .byte 6, 7, 6, 5, 6, 6, 7, 7, 8, 7, 7, 6, 7, 6, 6, 7
    .byte 7, 5, 6, 8, 6, 6, 8, 5, 7, 7, 6, 7, 7, 7, 7, 7
    .byte 7, 5, 6, 7, 6, 6, 7, 7, 7, 7, 6, 6, 8, 4, 7, 6
    .byte 6, 5, 7, 7, 6, 6, 7, 8, 7, 7, 8, 7, 6, 4, 7, 6
    .byte 7, 7, 7, 7, 7, 6, 6, 7, 6, 5, 5, 6, 6, 7, 6
    .byte 6, 7, 5, 7, 5, 7, 7, 6, 7, 6, 5, 6, 6, 6, 7
    .byte 7, 6, 7, 6, 7, 6, 6, 6, 5, 6, 7, 6, 7, 7, 6
    .byte 7, 6, 5, 6, 6, 6, 3, 6, 6, 6, 7, 7, 7, 6, 7
    .byte 7, 4, 7, 6, 6, 7, 6, 7, 7, 7, 6, 7, 7, 7, 7
    .byte 7, 6, 5, 5, 7, 7, 6, 7, 6, 5, 5, 7, 7, 7, 7
    .byte 7, 3, 7, 7, 7, 6, 6, 6, 7, 6, 7, 7, 5, 6, 7
    .byte 5, 7, 6, 6, 8, 6, 7, 8, 5, 6, 6, 7, 7, 7, 6, 5
    .byte 6, 6, 6, 7, 6, 6, 4, 7, 7, 6, 6, 5, 5, 7, 7
    .byte 7, 6, 7, 7, 7, 7, 6, 6, 6, 7, 5, 5, 8, 6, 6, 6
    .byte 7, 7, 6, 6, 7, 7, 6, 6, 6, 7, 6, 6, 5, 6, 7
    .byte 6, 7, 7, 7, 7, 6, 4, 6, 6, 7, 7, 7, 7, 7, 6
    .byte 7, 7, 6, 6, 6, 7, 7, 6, 5, 8, 7, 6, 8, 8, 7, 5
    .byte 6
    .byte 5, 7, 6, 7, 6, 7, 8, 5, 7, 7, 6, 5, 3, 6, 7, 7
    .byte 4, 7, 6, 8, 7, 6, 6, 6, 5, 6, 6, 7, 6, 7, 5, 7
    .byte 7, 7, 6, 7, 6, 7, 5, 7, 6, 6, 7, 6, 5, 5, 6
    .byte 6, 7, 6, 6, 6, 6, 7, 5, 6, 5, 7, 6, 7, 7, 7
    .byte 6, 5, 7, 7, 5, 6, 8, 6, 7, 6, 7, 6, 7, 7, 7, 6
    .byte 5, 7, 7, 7, 6, 5, 7, 6, 7, 7, 6, 7, 6, 4, 5
    .byte 5, 4, 6, 7, 6, 7, 6, 6, 7, 7, 6, 7, 6, 7, 5
    .byte 7, 6, 6, 7, 7, 7, 7, 8, 6, 6, 7, 6, 6, 6, 5, 6
    .byte 7, 5, 7, 7, 4, 7, 7, 7, 7, 6, 7, 7, 5, 5, 6
    .byte 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 5, 7, 6, 6, 6
    .byte 7, 6, 7, 8, 8, 7, 5, 7, 6, 7, 6, 7, 7, 8, 8, 6
    .byte 7
    .byte 6, 6, 4, 4, 7, 6, 8, 4, 6, 6, 8, 7, 5, 6, 7, 6
    .byte 6, 7, 7, 6, 7, 5, 7, 7, 8, 5, 8, 5, 6, 6, 7, 7
    .byte 6, 7, 7, 6, 6, 5, 6, 6, 6, 6, 7, 6, 7, 4, 7
    .byte 6, 6, 6, 6, 5, 7, 6, 8, 7, 5, 7, 6, 6, 6, 6, 6
    .byte 8, 6, 7, 7, 6, 6, 6, 6, 7, 6, 6, 5, 6, 7, 7, 7
    .byte 7, 6, 4, 6, 6, 5, 6, 4, 6, 6, 7, 7, 7, 6, 7
    .byte 6, 8, 7, 6, 6, 6, 6, 6, 7, 7, 6, 7, 7, 7, 7, 5
    .byte 8, 7, 7, 5, 6, 6, 7, 6, 5, 5, 7, 6, 6, 6, 6, 7
    .byte 4, 7, 6, 8, 7, 6, 7, 7, 6, 6, 7, 7, 5, 7, 7, 6
    .byte 6, 6, 6, 7, 6, 7, 6, 7, 5, 7, 7, 7, 6, 5, 8, 7
    .byte 7, 7, 6, 7, 6, 5, 5, 6, 3, 5, 7, 6, 6, 6, 7
    .byte 8, 6, 6, 7, 5, 7, 5, 8, 6, 5, 7, 7, 7, 7, 7, 7
    .byte 6, 8, 5, 7, 6, 5, 7, 7, 6, 6, 7, 5, 7, 7, 6, 7
    .byte 6, 7, 6, 6, 6, 6, 7, 6, 7, 5, 7, 5, 7, 8, 7, 8
    .byte 5, 4, 5, 6, 6, 6, 7, 7, 7, 7, 7, 5, 6, 6, 5
    .byte 6, 6, 7, 6, 6, 7, 7, 7, 4, 6, 6, 7, 4, 6, 6
    .byte 6, 7, 6, 7, 7, 6, 7, 5, 6, 6, 7, 7, 6, 7, 7
    .byte 6, 7, 8, 7, 7, 8, 6, 7, 5, 5, 7, 7, 7, 6, 6, 6
    .byte 5, 6, 6, 7, 7, 7, 6, 5, 7, 6, 6, 6, 7, 5, 6
    .byte 6, 6, 5, 6, 6, 6, 7, 6, 7, 5, 5, 6, 7, 7, 7
    .byte 7, 8, 7, 6, 6, 7, 6, 6, 6, 6, 7, 6, 6, 6, 7, 7
    .byte 5, 7, 6, 5, 2, 6, 6, 6, 6, 6, 7, 6, 8, 7, 7, 6
    .byte 6, 6, 7, 7, 7, 7, 7, 6, 6, 6, 8, 6, 6, 6, 6, 7
    .byte 5, 7, 7, 7, 5, 7, 7, 7, 7, 6, 6, 7, 7, 6, 5
    .byte 6, 4, 7, 6, 7, 6, 5, 7, 6, 7, 6, 7, 6, 6, 7
    .byte 7, 7, 7, 7, 8, 7, 7, 5, 7, 5, 7, 6, 7, 7, 6, 7
    .byte 6, 6, 7, 5, 7, 5, 4, 3, 6, 6, 6, 7, 6, 7, 5
    .byte 7, 7, 6, 6, 6, 7, 7, 7, 7, 7, 7, 6, 7, 6, 7
    .byte 7, 6, 6, 6, 7, 6, 7, 6, 6, 6, 6, 6, 6, 7, 5
    .byte 6, 7, 7, 5, 6, 6, 5, 7, 5, 7, 6, 6, 7, 5, 7
    .byte 5, 7, 5, 6, 7, 6, 7, 6, 7, 8, 8, 7, 6, 7, 6, 7
    .byte 7, 7, 7, 6, 6, 6, 6, 7, 5, 7, 6, 5, 3, 5, 6
    .byte 7, 7, 5, 8, 6, 7, 7, 7, 6, 6, 7, 6, 7, 7, 8, 7
    .byte 7, 6, 5, 7, 6, 6, 7, 6, 6, 6, 6, 7, 7, 6, 7
    .byte 6, 7, 7, 6, 6, 7, 6, 6, 6, 7, 5, 6, 6, 6, 6
    .byte 5, 7, 6, 6, 6, 8, 6, 6, 6, 6, 6, 7, 7, 7, 7, 6
    .byte 6, 7, 5, 7, 7, 6, 7, 5, 6, 5, 7, 7, 4, 8, 5, 5
    .byte 3, 6, 5, 6, 7, 6, 7, 6, 7, 7, 7, 7, 5, 6, 6
    .byte 7, 7, 8, 7, 6, 7, 6, 8, 7, 5, 7, 5, 7, 6, 6, 6
    .byte 7, 6, 7, 7, 7, 6, 6, 6, 7, 6, 7, 5, 7, 4, 6
    .byte 6, 6, 8, 6, 7, 6, 5, 6, 6, 7, 7, 7, 7, 7, 6, 6
    .byte 6, 7, 6, 4, 6, 6, 7, 6, 7, 6, 7, 7, 4, 6, 6
    .byte 7, 4, 6, 7, 5, 6, 7, 7, 6, 7, 6, 5, 6, 7, 7
    .byte 7, 7, 7, 6, 7, 7, 7, 7, 6, 7, 6, 7, 6, 4, 6
    .byte 7, 7, 7, 6, 6, 5, 6, 7, 6, 7, 6, 5, 7, 6, 7
    .byte 6, 7, 7, 6, 5, 6, 6, 7, 4, 7, 7, 5, 7, 6, 7
    .byte 7, 7, 8, 7, 7, 4, 7, 7, 7, 6, 6, 7, 6, 7, 7, 5
    .byte 7, 6, 5, 5, 6, 4, 6, 7, 5, 6, 6, 7, 7, 7, 7
    .byte 7, 6, 6, 6, 8, 6, 6, 7, 7, 7, 6, 7, 7, 6, 7, 6
    .byte 7, 6, 4, 7, 7, 6, 7, 7, 5, 7, 7, 7, 7, 5, 6
    .byte 4, 7, 7, 6, 6, 6, 5, 6, 6, 7, 7, 5, 7, 6, 6
    .byte 7, 6, 6, 7, 6, 7, 7, 6, 7, 7, 7, 6, 7, 6, 6
    .byte 7, 6, 7, 7, 7, 6, 3, 7, 7, 5, 6, 5, 6, 6, 6
    .byte 6, 7, 7, 7, 6, 7, 6, 5, 6, 7, 6, 6, 8, 7, 6, 7
    .byte 6, 7, 7, 6, 7, 6, 6, 6, 7, 6, 7, 6, 6, 6, 6
    .byte 6, 7, 6, 6, 6, 7, 5, 5, 5, 7, 7, 7, 7, 6, 7
    .byte 8, 7, 6, 6, 6, 6, 6, 6, 6, 8, 7, 6, 7, 8, 7, 4
    .byte 7
    .byte 5, 7, 5, 7, 6, 8, 7, 6, 6, 6, 5, 5, 4, 6, 6, 7
    .byte 3, 7, 6, 7, 7, 6, 5, 7, 6, 7, 6, 7, 7, 7, 5
    .byte 7, 6, 7, 6, 7, 6, 7, 6, 6, 6, 6, 7, 7, 6, 6
    .byte 6, 7, 6, 6, 5, 7, 5, 6, 5, 6, 6, 7, 6, 6, 7
    .byte 6, 6, 6, 7, 7, 5, 6, 7, 6, 7, 5, 7, 7, 7, 7
    .byte 7, 7, 5, 7, 6, 6, 6, 6, 7, 7, 7, 7, 6, 6, 6
    .byte 5, 4, 6, 4, 6, 7, 6, 7, 5, 7, 8, 6, 6, 7, 6, 7
    .byte 6, 7, 7, 6, 6, 6, 7, 7, 7, 7, 5, 7, 6, 6, 5
    .byte 5, 6, 7, 6, 7, 6, 5, 6, 7, 6, 6, 6, 7, 7, 5
    .byte 6, 6, 7, 6, 7, 7, 7, 7, 7, 7, 6, 7, 6, 6, 7
    .byte 5, 6, 7, 6, 7, 7, 8, 6, 5, 7, 6, 6, 6, 7, 6, 7
    .byte 7, 5, 7, 7, 6, 4, 4, 6, 7, 7, 4, 7, 5, 7, 6
    .byte 6, 6, 6, 6, 6, 7, 7, 6, 7, 4, 7, 6, 7, 6, 7
    .byte 6, 6, 6, 7, 6, 5, 6, 7, 6, 5, 6, 7, 7, 5, 6
    .byte 7, 6, 7, 4, 6, 7, 7, 5, 7, 6, 7, 5, 8, 8, 4, 7
    .byte 6, 6, 6, 5, 6, 8, 5, 6, 8, 6, 7, 7, 6, 6, 7, 6
    .byte 6, 7, 7, 6, 6, 6, 6, 3, 6, 7, 6, 7, 5, 6, 6
    .byte 7, 6, 7, 6, 6, 6, 7, 7, 6, 6, 7, 6, 6, 7, 6
    .byte 5, 7, 7, 8, 7, 6, 7, 7, 6, 6, 7, 7, 7, 6, 6, 6
    .byte 6, 7, 6, 7, 6, 7, 6, 6, 7, 7, 7, 6, 7, 5, 7
    .byte 6, 7, 8, 6, 8, 6, 5, 6, 5, 7, 7, 7, 7, 6, 7, 6
    .byte 6, 7, 7, 5, 5, 7, 6, 6, 6, 6, 7, 6, 4, 5, 7
    .byte 7, 4, 5, 7, 6, 6, 6, 7, 7, 7, 7, 5, 7, 7, 7
    .byte 7, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 6, 5, 7
    .byte 6, 7, 7, 6, 6, 4, 7, 7, 7, 8, 7, 6, 6, 7, 5, 6
    .byte 7, 5, 7, 6, 7, 8, 7, 6, 5, 7, 7, 7, 7, 6, 5, 8
    .byte 7, 7, 7, 6, 7, 5, 5, 5, 4, 7, 6, 7, 7, 6, 7
    .byte 5, 7, 7, 5, 6, 5, 6, 6, 7, 6, 6, 7, 7, 4, 7
    .byte 5, 6, 6, 6, 7, 6, 7, 6, 5
    .byte 7, 6, 7, 6, 7, 7, 5, 7, 6, 7, 7, 6, 6, 7, 8, 6
    .byte 5, 7, 7, 6, 6, 5, 7, 7, 7, 7, 4, 7, 4, 7, 8, 7
    .byte 7, 6, 7, 5, 7, 7, 6, 6, 7, 6, 7, 7, 5, 5, 7
    .byte 7, 6, 4, 6, 6, 6, 7, 5, 7, 7, 7, 6, 6, 6, 6
    .byte 5, 5, 7, 7, 6, 6, 6, 6, 7, 7, 6, 7, 6, 7, 5
    .byte 7, 7, 4, 7, 7, 7, 6, 8, 7, 6, 7, 6, 6, 6, 8, 7
    .byte 7, 7, 8, 6, 5, 7, 7, 7, 6, 6, 6, 7, 5, 6, 7, 6
    .byte 7, 5, 6, 7, 7, 6, 4, 6, 7, 6, 7, 7, 7, 6, 7
    .byte 7, 6, 7, 6, 6, 3, 7, 6, 7, 5, 7, 6, 7, 6, 7
    .byte 6, 7, 5, 5, 6, 8, 5, 7, 7, 7, 6, 7, 5, 5, 5, 6
    .byte 6, 7, 7, 7, 5, 5, 5, 7, 7, 5, 6, 8, 7, 7, 6, 6
    .byte 8, 7, 5, 7, 7, 7, 5, 8, 5, 7, 7, 7, 5, 6, 7, 7
    .byte 6, 7, 6, 6, 6, 7, 6, 7, 5, 7, 6, 6, 7, 7, 7
    .byte 6, 6, 6, 7, 7, 5, 7, 7, 5, 6, 4, 6, 4, 7, 6
    .byte 5, 7, 7, 7, 7, 7, 4, 6, 7, 7, 6, 6, 6, 6, 7
    .byte 6, 7, 5, 7, 6, 7, 4, 6, 6, 7, 5, 7, 7, 6, 8, 7
    .byte 6, 6, 6, 5, 7, 7, 7, 6, 8, 7, 6, 6, 6, 6, 5, 7
    .byte 5, 7, 7, 6, 7, 6, 5, 5, 6, 6, 7, 6, 7, 6, 6
    .byte 7, 6, 6, 6, 5, 6, 7, 6, 7, 7, 6, 7, 6, 5, 6
    .byte 5, 5, 7, 7, 6, 6, 6, 6, 6, 7, 7, 7, 6, 6, 5
    .byte 4, 6, 6, 7, 5, 7, 6, 7, 6, 7, 7, 6, 6, 6, 6
    .byte 8, 7, 7, 5, 6, 6, 7, 7, 6, 6, 7, 6, 7, 6, 6, 6
    .byte 6, 7, 6, 8, 6, 7, 7, 6, 8, 6, 6, 6, 6, 6, 7, 5
    .byte 5, 7, 7, 6, 6, 7, 6, 6, 7, 4, 8, 6, 7, 6, 7, 7
    .byte 5, 6, 6, 4, 4, 6, 7, 6, 8, 6, 7, 7, 6, 6, 6, 7
    .byte 5, 4, 6, 5, 6, 6, 8, 7, 6, 7, 7, 8, 4, 7, 6, 6
    .byte 6, 6, 6, 8, 7, 6, 6, 7, 6, 7, 6, 7, 7, 6, 6, 7
    .byte 6, 6, 7, 8, 7, 7, 7, 7, 7, 6, 6, 6, 5, 7, 6, 6
    .byte 6, 7, 7, 6, 8, 7, 7, 6, 6, 7, 5, 7, 6, 7, 7, 7
    .byte 7, 5, 6, 7, 5, 5, 6, 6, 7, 5, 7, 6, 7, 7, 5
    .byte 7, 7, 7, 5, 6, 6, 6, 7, 7, 6, 6, 7, 5, 6, 6
    .byte 5, 5, 6, 7, 7, 7, 7, 6, 7, 5, 7, 7, 6, 6, 6
    .byte 6, 6, 6, 7, 6, 6, 7, 7, 7, 6, 5, 7, 8, 7, 7, 4
    .byte 5, 4, 7, 6, 6, 7, 7, 8, 7, 7, 6, 5, 6, 6, 7, 5
    .byte 7, 7, 7, 6, 7, 7, 5, 7, 6, 7, 5, 6, 7, 7, 8, 6
    .byte 6, 7, 6, 7, 6, 6, 5, 6, 4, 5, 6, 7, 7, 6, 7
    .byte 7, 7, 7, 6, 6, 6, 5, 7, 7, 6, 7, 6, 6, 6, 7
    .byte 6, 6, 7, 7, 6, 7, 7, 7, 7, 6, 6, 7, 7, 7, 6
    .byte 6, 5, 6, 6, 6, 7, 7, 7, 6, 6, 6, 7, 6, 7, 7
    .byte 7, 6, 6, 6, 6, 6, 7, 7, 5, 7, 6, 5, 5, 6, 7
    .byte 7, 7, 4, 7, 6, 7, 5, 5, 6, 5, 7, 5, 6, 6, 7
    .byte 6, 6, 6, 6, 5, 7, 6, 6, 5, 7, 6, 7, 6, 7, 7
    .byte 6, 7, 6, 6, 6, 6, 7, 7, 6, 6, 5, 7, 6, 7, 8, 7
    .byte 7, 6, 7, 4, 7, 8, 6, 7, 5, 7, 6, 7, 8, 7, 7, 5
    .byte 7, 7, 8, 7, 7, 8, 7, 7, 7, 6, 6, 6, 6, 7, 7, 5
    .byte 7, 7, 6, 7, 5, 6, 6, 6, 7, 7, 7, 6, 6, 6, 7
    .byte 7, 7, 6, 7, 6, 6, 7, 6, 5, 6, 8, 7, 5, 6, 7, 7
    .byte 7, 7, 7, 7, 7, 7, 7, 5, 6, 7, 7, 6, 7, 6, 7
    .byte 7, 7, 8, 8, 6, 7, 6, 6, 7, 6, 6, 6, 7, 7, 5, 5
    .byte 7, 6, 7, 6, 7, 7, 7, 7, 5, 6, 7, 7, 7, 5, 6
    .byte 7, 7, 5, 6, 7, 6, 6, 7, 6, 6, 5, 5, 6, 7, 7
    .byte 6, 5, 7, 7, 7, 5, 6, 7, 7, 6, 7, 6, 7, 3, 5
    .byte 6, 5, 7, 6, 6, 6, 6, 7, 7, 6, 6, 7, 7, 7, 7
    .byte 7, 6, 6, 8, 5, 7, 7, 7, 7, 6, 7, 6, 6, 6, 5, 5
    .byte 6, 6, 7, 7, 5, 7, 7, 7, 5, 6, 6, 7, 6, 5, 7
    .byte 7, 6, 7, 6, 7, 6, 6, 5, 5, 6, 7, 4, 7, 6, 4
    .byte 6, 6, 5, 7, 6, 6, 5, 7, 7, 6, 6, 6, 7, 7, 6
    .byte 7, 4, 7, 4, 5, 5, 5, 6, 6, 7, 7, 7, 6, 6, 7
    .byte 5, 7, 6, 6, 7, 7, 7, 6, 7, 6, 6, 7, 7, 7, 7
    .byte 8, 5, 7, 7, 6, 7, 6, 6, 6, 7, 6, 7, 7, 7, 7, 7
    .byte 5, 7, 4, 7, 7, 8, 7, 4, 7, 6, 7, 6, 6, 4, 7, 8
    .byte 5, 7, 6, 6, 6, 5, 6, 6, 7, 7, 6, 7, 6, 6, 6
    .byte 6, 7, 6, 6, 6, 6, 7, 5, 7, 7, 6, 6, 5, 7, 6
    .byte 6, 5, 7, 7, 6, 7, 6, 5, 7, 7, 7, 7, 7, 6, 4
    .byte 7, 6, 7, 7, 7, 4, 6, 7, 6, 7, 7, 6, 7, 5, 7
    .byte 7, 5, 7, 6, 7, 5, 7, 5, 8, 6, 8, 6, 6, 7, 7, 6
    .byte 6, 7, 6, 6, 7, 6, 6, 6, 5, 4, 4, 6, 6, 7, 6
    .byte 7, 6, 7, 8, 7, 6, 6, 7, 4, 6, 7, 5, 6, 6, 7, 6
    .byte 7, 6, 6, 6, 6, 6, 7, 7, 6, 7, 6, 5, 6, 7, 6
    .byte 7, 7, 7, 5, 7, 6, 7, 7, 7, 7, 7, 6, 7, 6, 5
    .byte 6, 6, 5, 6, 5, 7, 7, 7, 6, 7, 7, 5, 7, 7, 7
    .byte 5, 6, 7, 6, 7, 6, 5, 6, 7, 6, 6, 8, 6, 6, 4, 5
    .byte 5, 5, 7, 6, 7, 6, 7, 7, 5, 7, 8, 7, 5, 5, 5, 7
    .byte 6, 7, 6, 7, 8, 4, 6, 6, 5, 6, 6, 7, 7, 6, 6, 5
    .byte 7, 6, 7, 7, 6, 7, 6, 7, 6, 7, 6, 6, 7, 6, 6
    .byte 6, 7, 6, 6, 6, 7, 6, 7, 7, 6, 7, 8, 7, 6, 5, 6
    .byte 7, 6, 6, 6, 6, 6, 7, 7, 7, 6, 6, 6, 5, 6, 6
    .byte 5, 6, 5, 7, 5, 6, 6, 7, 8, 5, 7, 6, 7, 6, 7, 6
    .byte 6, 6, 5, 7, 7, 6, 6, 6, 6, 7, 6, 6, 6, 6, 7
    .byte 7, 7, 7, 4, 8, 7, 7, 7, 7, 7, 7, 6, 6, 8, 6, 6
    .byte 3, 8, 7, 7, 8, 5, 7, 6, 6, 7, 8, 6, 6, 8, 7, 6
    .byte 6
    .byte 5, 7, 5, 6, 7, 7, 6, 5, 7, 8, 7, 4, 5, 6, 7, 7
    .byte 6, 5, 7, 6, 7, 6, 7, 5, 6, 6, 7, 7, 6, 6, 7
    .byte 5, 6, 7, 6, 6, 5, 7, 6, 5, 5, 7, 7, 8, 6, 6, 7
    .byte 7, 6, 6, 6, 7, 7, 8, 7, 7, 8, 7, 6, 7, 7, 7, 7
    .byte 7, 6, 7, 6, 5, 7, 7, 5, 7, 5, 7, 6, 7, 7, 6
    .byte 7, 7, 6, 7, 7, 6, 6, 7, 7, 7, 7, 6, 7, 6, 6
    .byte 5, 5, 7, 7, 7, 5, 7, 4, 7, 6, 5, 7, 6, 7, 5
    .byte 7, 7, 5, 6, 6, 7, 6, 7, 6, 6, 7, 5, 6, 7, 6
    .byte 5, 7, 6, 7, 6, 7, 7, 7, 5, 7, 7, 7, 7, 6, 7
    .byte 6, 5, 7, 6, 7, 5, 6, 7, 7, 6, 7, 6, 6, 7, 6
    .byte 6, 7, 7, 7, 6, 6, 7, 7, 7, 7, 6, 7, 6, 7, 7
    .byte 7, 5, 6, 7, 5, 5, 6, 6, 5, 7, 7, 6, 6, 6, 7
    .byte 6, 6, 6, 7, 6, 6, 6, 4, 6, 7, 6, 6, 7, 6, 7
    .byte 5, 7, 7, 7, 6, 5, 6, 7, 6, 7, 6, 7, 7, 6, 7
    .byte 4, 8, 7, 7, 6, 5, 7, 6, 7, 7, 7, 6, 7, 6, 6, 7
    .byte 7, 6, 6, 6, 5, 6, 6, 6, 7, 7, 7, 6, 6, 6, 8, 6
    .byte 6, 6, 6, 7, 7, 6, 6, 7, 5, 5, 6, 5, 7, 5, 6
    .byte 6, 7, 7, 5, 7, 7, 6, 6, 7, 7, 7, 6, 5, 5, 7
    .byte 6, 6, 6, 6, 5, 7, 6, 7, 6, 7, 4, 5, 7, 7, 6
    .byte 7, 7, 6, 5, 7, 7, 6, 6, 6, 7, 6, 7, 6, 6, 7
    .byte 6, 6, 5, 7, 7, 6, 5, 7, 6, 7, 5, 7, 7, 8, 7, 5
    .byte 6, 7, 6, 6, 7, 8, 7, 7, 6, 6, 7, 6, 5, 4, 7, 6
    .byte 6, 6, 6, 6, 7, 6, 6, 6, 6, 6, 5, 7, 7, 5, 6
    .byte 6, 7, 6, 7, 5, 6, 6, 7, 7, 6, 7, 6, 4, 6, 6
    .byte 7, 6, 6, 6, 7, 8, 7, 6, 6, 8, 6, 6, 6, 6, 7, 5
    .byte 7, 5, 7, 7, 6, 6, 7, 7, 7, 7, 4, 6, 4, 6, 7
    .byte 6, 7, 6, 8, 6, 6, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6
    .byte 7, 5, 5, 6, 6, 7, 6, 5, 8, 7, 8, 5, 7, 5, 5, 5
    .byte 6, 6, 7, 6, 6, 5, 7, 6, 6, 6, 6, 6, 6, 6, 7
    .byte 6, 5, 6, 6, 7, 6, 8, 6, 7, 7, 7, 6, 5, 7, 8, 7
    .byte 7, 7, 7, 4, 6, 7, 7, 5, 4, 7, 7, 6, 6, 6, 6
    .byte 6, 6, 7, 7, 7, 5, 7, 7, 7, 8, 7, 7, 7, 7, 7, 7
    .byte 7, 5, 6, 7, 6, 5, 5, 7, 5, 7, 7, 5, 6, 7, 7
    .byte 7, 7, 3, 5, 6, 7, 6, 5, 6, 7, 6, 6, 7, 6, 7
    .byte 5, 6, 5, 5, 6, 6, 5, 8, 7, 6, 7, 7, 7, 7, 7, 5
    .byte 7, 7, 7, 6, 8, 7, 6, 6, 7, 7, 5, 7, 6, 6, 6, 4
    .byte 6, 6, 4, 7, 6, 7, 7, 7, 7, 6, 6, 6, 7, 7, 7
    .byte 6, 7, 6, 7, 7, 6, 7, 6, 6, 5, 5, 7, 5, 7, 7
    .byte 6, 6, 5, 7, 7, 5, 6, 5, 5, 5, 7, 7, 6, 7, 7
    .byte 5, 7, 6, 6, 6, 6, 6, 7, 7, 7, 5, 7, 7, 7, 7
    .byte 7, 7, 6, 7, 6, 7, 7, 7, 6, 6, 7, 5, 5, 6, 6
    .byte 6, 6, 5, 6, 6, 6, 6, 5, 6, 7, 6, 6, 7, 7, 8, 6
    .byte 7, 6, 7, 5, 6, 6, 8, 7, 5, 7, 7, 7, 6, 6, 5, 7
    .byte 7, 4, 7, 6, 5, 5, 4, 6, 6, 7, 7, 5, 7, 7, 5
    .byte 6, 6, 6, 6, 7, 7, 5, 7, 6, 6, 6, 6, 6, 6, 7
    .byte 7, 5, 6, 6, 7, 6, 7, 6, 6, 7, 8, 7, 6, 7, 5, 4
    .byte 6, 7, 7, 7, 7, 7, 6, 5, 7, 5, 5, 6, 6, 4, 6
    .byte 6, 6, 7, 7, 7, 7, 7, 6, 7, 6, 8, 6, 6, 6, 6, 7
    .byte 7, 6, 6, 7, 5, 7, 7, 6, 6
    .byte 5, 4, 4, 6, 7, 6, 7, 7, 7, 7, 5, 8, 7, 7, 4, 6
    .byte 6, 8, 5, 6, 6, 7, 7, 5, 7, 6, 6, 5, 6, 6, 8, 6
    .byte 6, 6, 6, 6, 7, 6, 6, 6, 6, 7, 6, 7, 7, 7, 6
    .byte 5, 6, 6, 6, 6, 7, 6, 6, 7, 7, 6, 6, 7, 7, 7
    .byte 7, 6, 5, 7, 7, 6, 7, 6, 7, 7, 8, 7, 6, 7, 5, 6
    .byte 6, 7, 4, 6, 6, 6, 5, 5, 7, 6, 7, 6, 7, 6, 6
    .byte 6, 6, 7, 6, 6, 6, 7, 7, 5, 6, 6, 7, 6, 5, 6
    .byte 7, 6, 7, 7, 7, 8, 5, 8, 7, 7, 6, 6, 7, 6, 6, 6
    .byte 7, 6, 6, 3, 6, 7, 5, 6, 6, 7, 7, 5, 7, 6, 5
    .byte 7, 6, 7, 6, 7, 6, 7, 6, 7, 7, 7, 7, 7, 7, 7
    .byte 7, 6, 6, 6, 6, 6, 7, 4, 5, 5, 6, 6, 6, 5, 7
    .byte 6, 7, 7, 7, 6, 6, 7, 5, 5, 7, 6, 6, 7, 7, 6
    .byte 7, 7, 7, 6, 6, 7, 7, 7, 5, 7, 7, 6, 7, 7, 6
    .byte 6, 6, 7, 6, 6, 6, 7, 7, 6, 6, 6, 6, 5, 5, 6
    .byte 6, 6, 7, 7, 7, 6, 5, 7, 6, 7, 7, 7, 6, 7, 7
    .byte 6, 7, 6, 7, 6, 7, 6, 6, 6, 6, 7, 7, 7, 3, 7
    .byte 7, 7, 4, 5, 6, 6, 6, 5, 7, 7, 7, 6, 7, 6, 7
    .byte 5, 6, 6, 7, 5, 6, 6, 7, 6, 6, 7, 7, 6, 7, 6
    .byte 7, 7, 6, 7, 6, 6, 5, 6, 6, 7, 7, 7, 6, 6, 6
    .byte 7, 6, 6, 6, 5, 6, 7, 6, 4, 6, 7, 6, 7, 7, 7
    .byte 7, 7, 7, 6, 6, 7, 7, 7, 6, 6, 7, 7, 6, 6, 7
    .byte 5, 7, 7, 5, 6, 5, 4, 5, 6, 6, 6, 6, 7, 6, 7
    .byte 6, 7, 7, 7, 5, 6, 6, 7, 4, 5, 6, 6, 7, 6, 7
    .byte 6, 6, 6, 7, 6, 7, 7, 7, 7, 6, 6, 6, 6, 7, 5
    .byte 6, 7, 7, 7, 6, 7, 5, 7, 7, 6, 5, 5, 7, 7, 7
    .byte 6, 7, 8, 8, 6, 7, 6, 7, 5, 6, 7, 7, 6, 6, 7, 7
    .byte 7, 7, 5, 6, 7, 7, 5, 7, 6, 5, 5, 5, 6, 6, 6
    .byte 6, 5, 7, 7, 5, 5, 7, 7, 7, 6, 7, 4, 7, 5, 6
    .byte 6, 6, 5, 6, 7, 8, 6, 7, 7, 6, 6, 8, 6, 7, 6, 7
    .byte 7, 5, 6, 5, 5, 7, 7, 7, 7, 8, 4, 7, 7, 5, 6, 5
    .byte 7, 7, 6, 7, 7, 6, 6, 7, 7, 7, 7, 7, 7, 6, 7
    .byte 6, 6, 7, 7, 7, 7, 7, 6, 7, 7, 6, 7, 6, 5, 5
    .byte 5, 7, 6, 6, 5, 7, 5, 8, 6, 7, 6, 7, 7, 6, 6, 7
    .byte 5, 7, 7, 7, 5, 7, 7, 6, 7, 7, 7, 7, 7, 6, 8, 6
    .byte 7, 7, 7, 7, 6, 6, 7, 7, 6, 7, 7, 7, 7, 3, 7
    .byte 7, 6, 7, 5, 6, 6, 5, 7, 8, 7, 6, 7, 7, 7, 7, 6
    .byte 7, 6, 7, 8, 7, 7, 5, 7, 7, 6, 5, 6, 6, 6, 7, 7
    .byte 4, 7, 7, 7, 7, 7, 4, 5, 7, 7, 6, 5, 5, 7, 6
    .byte 6, 7, 6, 6, 5, 6, 6, 6, 6, 6, 6, 8, 6, 5, 7, 7
    .byte 6, 7, 7, 6, 7, 7, 7, 7, 8, 6, 6, 6, 7, 7, 6, 6
    .byte 7, 6, 7, 7, 7, 5, 6, 4, 7, 6, 6, 7, 6, 7, 6
    .byte 6, 6, 7, 6, 7, 6, 7, 7, 7, 6, 6, 6, 4, 6, 7
    .byte 5, 8, 6, 5, 7, 6, 7, 4, 7, 6, 6, 5, 7, 6, 6, 7
    .byte 6, 5, 7, 6, 6, 7, 6, 6, 6, 7, 7, 5, 6, 5, 5
    .byte 8, 6, 7, 7, 7, 7, 6, 6, 6, 6, 7, 6, 7, 6, 7, 5
    .byte 6, 7, 7, 5, 6, 7, 7, 6, 6, 6, 6, 7, 6, 7, 7
    .byte 7, 7, 6, 7, 6, 7, 6, 7, 8, 7, 7, 7, 6, 6, 5, 6
    .byte 4, 6, 7, 7, 6, 7, 6, 7, 6, 6, 7, 6, 6, 5, 7
    .byte 6, 5, 6, 5, 6, 6, 6, 6, 7, 6, 7, 6, 7, 7, 6
    .byte 5, 6, 7, 7, 5, 7, 6, 7, 8, 7, 7, 5, 7, 6, 7, 6
    .byte 5, 7, 6, 6, 6, 7, 6, 7, 6, 6, 6, 4, 7, 7, 4
    .byte 6, 6, 7, 7, 7, 8, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7
    .byte 8, 7, 6, 7, 6, 5, 6, 6, 6, 7, 7, 5, 7, 5, 7, 6
    .byte 5, 7, 6, 6, 4, 7, 8, 6, 6, 7, 6, 7, 7, 5, 6, 7
    .byte 6, 6, 6, 7, 5, 8, 7, 7, 7, 7, 7, 7, 6, 6, 7, 7
    .byte 7, 6, 7, 6, 5, 6, 7, 7, 5, 6, 5, 7, 6, 6, 7
    .byte 5, 5, 4, 6, 6, 7, 7, 7, 7, 6, 7, 6, 7, 6, 6
    .byte 6, 7, 7, 7, 7, 6, 7, 7, 4, 7, 6, 6, 6, 7, 7
    .byte 7, 7, 6, 5, 6, 7, 6, 5, 6, 5, 5, 6, 7, 6, 5
    .byte 7, 6, 7, 7, 7, 7, 6, 5, 5, 6, 8, 7, 7, 6, 7, 6
    .byte 6, 7, 6, 6, 7, 7, 7, 7, 5, 5, 6, 6, 6, 7, 6
    .byte 7, 6, 6, 7, 5, 7, 5, 6, 5, 7, 6, 6, 7, 7, 8, 7
    .byte 7, 7, 7, 6, 6, 7, 7, 7, 7, 8, 7, 5, 7, 7, 5, 6
    .byte 5, 6, 7, 6, 6, 6, 8, 7, 6, 7, 7, 6, 4, 6, 6, 5
    .byte 6, 7, 7, 7, 7, 6, 6, 6, 6, 4, 7, 6, 6, 7, 7
    .byte 7, 7, 6, 7, 6, 7, 7, 6, 7, 7, 6, 7, 6, 6, 6
    .byte 7, 6, 6, 7, 7, 6, 7, 5, 7, 5, 7, 5, 7, 6, 5
    .byte 7, 7, 7, 6, 7, 7, 6, 6, 5, 8, 7, 7, 6, 7, 8, 4
    .byte 6, 7, 5, 5, 6, 6, 7, 7, 5, 6, 7, 7, 6, 7, 6
    .byte 5, 4, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 5, 6, 5
    .byte 6, 6, 7, 6, 7, 6, 7, 7, 6, 6, 7, 7, 7, 7, 6
    .byte 6, 8, 6, 6, 6, 7, 6, 7, 6, 6, 7, 7, 6, 4, 5, 4
    .byte 7, 6, 7, 7, 7, 8, 7, 8, 7, 6, 6, 7, 7, 6, 7, 7
    .byte 7, 7, 8, 7, 5, 7, 6, 6, 6, 6, 7, 6, 8, 6, 5, 6
    .byte 6, 7, 5, 6, 5, 5, 5, 6, 7, 6, 7, 6, 8, 7, 6, 6
    .byte 6, 6, 5, 6, 7, 7, 6, 7, 7, 7, 7, 7, 5, 6, 8, 7
    .byte 7, 7, 6, 6, 7, 5, 6, 7, 7, 6, 7, 7, 6, 6, 6
    .byte 6, 6, 6, 6, 6, 7, 7, 8, 6, 7, 7, 5, 6, 7, 7, 5
    .byte 5, 7, 7, 7, 6, 5, 6, 6, 7, 6, 7, 7, 6, 4, 5
    .byte 6, 5, 7, 6, 7, 6, 7, 7, 5, 7, 8, 7, 6, 4, 6, 7
    .byte 7, 7, 6, 7, 7, 5, 7, 5, 6, 7, 7, 7, 7, 7, 6
    .byte 4, 7, 7, 6, 7, 7, 7, 5, 7, 7, 7, 7, 6, 5, 7
    .byte 7, 5, 7, 7, 6, 7, 6, 7, 7, 6, 7, 7, 7, 6, 7
    .byte 5, 7, 6, 7, 6, 5, 6, 7, 6, 5, 6, 6, 7, 6, 6
    .byte 7, 6, 6, 4, 4, 6, 6, 7, 6, 7, 7, 7, 7, 6, 6
    .byte 7, 6, 5, 5, 6, 6, 7, 6, 7, 7, 6, 6, 7, 6, 6
    .byte 6, 7, 6, 7, 6, 5, 4, 6, 6, 7, 7, 8, 6, 6, 7, 7
    .byte 7, 8, 7, 6, 8, 7, 6, 7, 7, 6, 6, 7, 7, 7, 7, 7
    .byte 7, 7, 6, 8, 4, 7, 7, 7, 6, 4, 7, 6, 7, 6, 6, 5
    .byte 7, 7, 5, 7, 6, 6, 5, 5, 7, 5, 7, 6, 6, 7, 7
    .byte 7, 6, 7, 7, 6, 6, 5, 7, 7, 6, 7, 6, 7, 7, 6
    .byte 7, 6, 6, 6, 6, 7, 7, 6, 5, 4, 6, 7, 7, 7, 7
    .byte 7, 5, 6, 6, 7, 8, 7, 6, 7, 7, 6, 7, 6, 5, 7, 7
    .byte 6, 7, 7, 7, 7, 7, 6, 7, 5, 7, 6, 6, 6, 5, 6
    .byte 6, 7, 6, 6, 6, 7, 6, 5, 6, 6, 5, 5, 5, 7, 5
    .byte 7, 5, 7, 7, 6, 6, 6, 7, 7, 6, 6, 5, 6, 6, 7
    .byte 7, 6, 6, 7, 6, 7, 6, 7, 6, 7, 6, 7, 7, 6, 3
    .byte 7, 7, 7, 8, 7, 7, 6, 7, 7, 8, 7, 7, 7, 6, 7, 6
    .byte 6, 7, 7, 7, 6, 5, 7, 7, 6, 6, 7, 7, 7, 7, 5
    .byte 5, 7, 7, 6, 5, 7, 7, 6, 4, 6, 7, 6, 5, 6, 7
    .byte 7, 5, 6, 5, 8, 6, 5, 6, 7, 7, 7, 6, 6, 6, 7, 7
    .byte 6, 6, 7, 4, 5, 7, 6, 6, 6, 6, 5, 6, 7, 6, 6
    .byte 6, 6, 6, 6, 7, 6, 5, 7, 8, 6, 7, 7, 7, 7, 6, 7
    .byte 3, 8, 8, 6, 8, 6, 6, 5, 7, 7, 7, 7, 5, 8, 7, 7
    .byte 7
    .byte 7, 7, 6, 6, 7, 6, 6, 6, 7, 7, 7, 5, 7, 6, 6
    .byte 6, 6, 6, 6, 7, 7, 7, 7, 7, 6, 6, 7, 7, 6, 6
    .byte 6, 6, 6, 6, 7, 6, 6, 8, 7, 5, 7, 6, 7, 7, 7, 7
    .byte 7, 6, 7, 7, 5, 5, 6, 6, 6, 7, 7, 7, 7, 7, 7
    .byte 7, 6, 6, 6, 6, 7, 6, 7, 7, 6, 7, 7, 6, 6, 6
    .byte 7, 8, 6, 6, 7, 7, 5, 6, 5, 7, 6, 7, 6, 5, 7, 6
    .byte 5, 5, 5, 6, 7, 6, 4, 8, 6, 7, 6, 6, 6, 4, 8, 6
    .byte 6, 7, 7, 7, 5, 7, 7, 6, 7, 5, 7, 6, 7, 7, 7
    .byte 7, 6, 6, 6, 6, 6, 5, 6, 5, 7, 7, 6, 6, 6, 7
    .byte 7, 6, 8, 6, 7, 6, 6, 6, 6, 6, 6, 6, 7, 6, 7, 7
    .byte 6, 7, 7, 7, 5, 7, 7, 7, 7, 4, 6, 6, 7, 6, 6
    .byte 7, 6, 6, 5, 5, 5, 6, 4, 7, 7, 5, 6, 7, 5, 6
    .byte 6, 7, 6, 7, 7, 7, 6, 5, 8, 6, 6, 7, 5, 7, 5, 6
    .byte 6, 6, 7, 7, 6, 7, 6, 6, 5, 6, 5, 7, 6, 5, 7
    .byte 7, 6, 6, 7, 7, 7, 7, 7, 6, 6, 7, 7, 7, 7, 6
    .byte 7, 7, 6, 6, 6, 6, 6, 7, 7, 6, 7, 8, 7, 6, 5, 6
    .byte 6, 7, 5, 6, 7, 6, 6, 4, 5, 6, 6, 5, 6, 6, 7
    .byte 5, 6, 6, 8, 7, 4, 6, 7, 7, 6, 7, 5, 7, 7, 7, 7
    .byte 6, 7, 5, 6, 6, 6, 6, 6, 6, 6, 7, 7, 5, 7, 5
    .byte 6, 7, 5, 7, 6, 5, 7, 7, 6, 6, 6, 6, 8, 7, 6, 7
    .byte 6, 7, 7, 7, 6, 5, 6, 6, 7, 5, 6, 7, 8, 7, 6, 6
    .byte 6, 6, 7, 4, 7, 6, 7, 6, 6, 7, 6, 6, 5, 4, 5
    .byte 7, 7, 5, 8, 6, 7, 6, 6, 6, 5, 7, 5, 5, 6, 6, 7
    .byte 6, 7, 7, 6, 6, 6, 7, 5, 7, 7, 6, 7, 6, 7, 7
    .byte 7, 6, 5, 6, 5, 7, 7, 7, 7, 6, 6, 7, 6, 7, 6
    .byte 7, 7, 7, 6, 7, 7, 7, 7, 7, 6, 6, 6, 7
    .byte 7, 6, 7, 6, 7, 7, 7, 6, 5, 5, 7, 7, 6, 7, 7
    .byte 6, 6, 5, 5, 5, 5, 5, 7, 7, 6, 6, 6, 6, 6, 7
    .byte 6, 6, 7, 7, 6, 5, 6, 7, 7, 6, 7, 5, 7, 6, 7
    .byte 7, 6, 6, 6, 7, 7, 7, 6, 4, 6, 6, 7, 7, 5, 7
    .byte 7, 5, 7, 7, 7, 6, 6, 7, 7, 7, 7, 4, 7, 8, 6, 8
    .byte 5, 5, 4, 6, 6, 7, 7, 6, 8, 7, 6, 6, 6, 7, 6, 6
    .byte 6, 6, 6, 6, 6, 7, 7, 5, 7, 7, 7, 5, 7, 7, 7
    .byte 7, 7, 7, 8, 6, 6, 6, 6, 6, 6, 5, 6, 5, 7, 6, 6
    .byte 6, 7, 8, 7, 6, 7, 6, 6, 8, 8, 7, 6, 5, 6, 6, 6
    .byte 6
    .byte 6, 7, 6, 7, 8, 7, 7, 7, 6, 7, 7, 7, 7, 7, 6, 5
    .byte 7, 7, 6, 7, 6, 6, 7, 8, 6, 5, 6, 7, 7, 7, 6, 6
    .byte 6, 6, 6, 6, 6, 6, 5, 3, 6, 6, 7, 6, 6, 7, 6
    .byte 6, 7, 5, 8, 6, 5, 5, 7, 6, 7, 7, 6, 6, 8, 6, 6
    .byte 5, 6, 5, 6, 6, 7, 6, 5, 6, 6, 7, 6, 6, 7, 6
    .byte 6, 6, 6, 7, 6, 4, 8, 7, 7, 6, 7, 6, 7, 7, 7, 4
    .byte 7, 7, 7, 7, 5, 6, 4, 7, 7, 8, 7, 6, 7, 6, 7, 7
    .byte 6, 6, 6, 6, 7, 7, 5, 6, 7, 7, 6, 4, 7, 7, 6
    .byte 6, 6, 6, 6, 6, 6, 7, 7, 7, 6, 5, 7, 7, 7, 6
    .byte 7, 6, 7, 7, 7, 6, 6, 7, 6, 6, 7, 5, 6, 7, 7
    .byte 7, 7, 6, 6, 7, 6, 6, 5, 7, 6, 8, 8, 8, 7, 6, 7
    .byte 7
    .byte 7, 7, 6, 7, 7, 6, 7, 7, 5, 7, 7, 7, 7, 7, 6
    .byte 5, 7, 7, 6, 7, 5, 5, 7, 7, 7, 7, 7, 7, 5, 4
    .byte 5, 4, 6, 5, 7, 8, 6, 7, 6, 6, 6, 6, 6, 6, 7, 7
    .byte 7, 6, 6, 7, 7, 5, 7, 4, 6, 6, 6, 7, 6, 6, 7
    .byte 6, 6, 7, 7, 5, 7, 6, 6, 6, 5, 6, 6, 6, 7, 7
    .byte 7, 7, 6, 6, 7, 7, 7, 6, 7, 7, 7, 6, 7, 6, 7
    .byte 7, 7, 6, 6, 6, 7, 7, 5, 7, 6, 6, 6, 5, 7, 7
    .byte 7, 5, 6, 7, 6, 5, 4, 5, 5, 8, 7, 5, 8, 6, 6, 6
    .byte 7, 5, 5, 8, 6, 6, 7, 7, 6, 6, 7, 8, 5, 7, 6, 7
    .byte 5, 7, 6, 6, 6, 7, 7, 6, 7, 7, 6, 5, 5, 6, 7
    .byte 6, 6, 7, 7, 6, 6, 7, 6, 6, 6, 6, 7, 7, 7, 6
    .byte 6, 7, 6, 6, 6, 6, 7, 7, 7, 6, 7, 7, 6, 7, 6
    .byte 6, 7, 6, 6, 6, 6, 6, 6, 4, 6, 6, 6, 6, 5, 6
    .byte 6, 6, 7, 5, 7, 7, 5, 6, 7, 7, 7, 7, 6, 6, 7
    .byte 7, 7, 6, 6, 5, 6, 6, 7, 5, 6, 5, 6, 7, 7, 6
    .byte 7, 6, 5, 6, 6, 7, 5, 5, 7, 8, 7, 7, 7, 6, 7, 7
    .byte 7, 7, 7, 7, 7, 6, 7, 6, 6, 6, 6, 6, 7, 6, 6
    .byte 7, 7, 7, 6, 5, 6, 6, 8, 6, 7, 6, 7, 6, 5, 4, 5
    .byte 6, 5, 7, 7, 6, 6, 6, 6, 5, 7, 7, 7, 6, 7, 6
    .byte 5, 6, 7, 6, 6, 7, 5, 7, 6, 6, 7, 7, 6, 6, 6
    .byte 7, 7, 7, 5, 6, 6, 7, 6, 4, 7, 7, 6, 6, 6, 8, 6
    .byte 7, 7, 7, 7, 7, 7, 7, 7, 6, 7, 7, 5, 7, 6, 7
    .byte 6, 7, 6, 7, 7, 6, 6, 7, 6, 6, 5, 7, 7, 7, 6
    .byte 6, 6, 6, 6, 5, 5, 6, 8, 7, 5, 8, 5, 7, 5, 6, 6
    .byte 5, 7, 6, 6, 6, 6, 6, 6, 7, 7, 6, 6, 6, 7, 6
    .byte 7, 6, 7, 6, 7, 7, 7, 6, 6, 6, 6, 4, 7, 8, 6, 7
    .byte 7, 7, 7, 5, 7, 5, 7, 6, 7, 4, 8, 8, 7, 8, 6, 6
    .byte 5
    .byte 6, 7, 8, 6, 6, 8, 7, 7, 7, 6, 6, 5, 6, 7, 7, 6
    .byte 5, 7, 8, 7, 4, 6, 6, 7, 6, 7, 6, 7, 6, 7, 6, 7
    .byte 6, 6, 6, 7, 7, 7, 6, 7, 6, 7, 7, 6, 5, 6, 7
    .byte 7, 6, 6, 6, 7, 7, 7, 7, 6, 6, 7, 6, 6, 6, 6
    .byte 7, 7, 7, 7, 7, 6, 7, 7, 8, 7, 7, 5, 7, 7, 5, 5
    .byte 6, 5, 7, 6, 7, 8, 6, 7, 6, 7, 7, 6, 6, 7, 6, 7
    .byte 7, 6, 7, 7, 7, 6, 6, 6, 5, 7, 6, 6, 7, 7, 6
    .byte 4, 7, 7, 4, 6, 6, 6, 6, 6, 6, 6, 7, 7, 5, 6
    .byte 6, 5, 6, 7, 6, 6, 7, 7, 6, 8, 7, 7, 7, 7, 7, 6
    .byte 7, 6, 7, 7, 7, 5, 7, 7, 5, 5, 7, 6, 7, 5, 5
    .byte 7, 7, 7, 6, 7, 6, 5, 6, 7, 6, 7, 4, 7, 7, 6
    .byte 8, 6, 7, 7, 7, 7, 7, 7, 4, 7, 7, 6, 6, 5, 7, 5
    .byte 7, 6, 6, 7, 6, 6, 6, 7, 4, 6, 7, 6, 6, 5, 7
    .byte 7, 7, 6, 8, 6, 6, 5, 7, 5, 6, 6, 7, 6, 7, 8, 7
    .byte 7, 8, 7, 7, 7, 4, 7, 7, 7, 6, 7, 6, 6, 6, 6, 7
    .byte 4, 6, 6, 7, 7, 6, 7, 4, 7, 4, 7, 7, 6, 7, 5
    .byte 7, 6, 6, 7, 7, 7, 8, 6, 7, 7, 6, 6, 6, 6, 6, 4
    .byte 7, 5, 7, 6, 6, 7, 6, 7, 5, 6, 6, 6, 4, 6, 7
    .byte 6, 6, 7, 6, 6, 7, 6, 6, 6, 7, 7, 6, 7, 7, 5
    .byte 7, 7, 8, 7, 7, 7, 6, 7, 6, 5, 6, 7, 7, 7, 6, 7
    .byte 6, 5, 7, 7, 6, 6, 6, 6, 6, 5, 6, 7, 6, 7, 5
    .byte 7, 7, 8, 7, 5, 5, 6, 6, 7, 6, 7, 7, 6, 7, 7, 6
    .byte 5, 6, 4, 8, 5, 6, 6, 7, 6, 7, 7, 7, 5, 6, 5, 5
    .byte 6, 7, 4, 7, 6, 7, 6, 7, 4, 6, 5, 7, 6, 7, 7
    .byte 7, 5, 6, 6, 7, 7, 6, 6, 7, 7, 6, 6, 6, 7, 7
    .byte 6, 7, 6, 7, 5, 7, 4, 6, 6, 6, 4, 7, 6, 7, 6
    .byte 6, 5, 5, 6, 5, 7, 6, 7, 7, 5, 8, 5, 7, 5, 6, 7
    .byte 7, 7, 6, 8, 7, 7, 7, 5, 7, 6, 6, 7, 7, 7, 6, 6
    .byte 7, 5, 6, 6, 7, 6, 6, 4, 5, 6, 7, 6, 4, 7, 7
    .byte 7, 7, 7, 6, 6, 6, 6, 7, 7, 7, 7, 6, 7, 5, 7
    .byte 7, 7, 6, 7, 6, 6, 7, 6, 6, 6, 7, 5, 7, 6, 6
    .byte 6, 7, 7, 7, 4, 6, 4, 7, 6, 7, 6, 6, 8, 7, 7, 7
    .byte 6, 5, 6, 7, 6, 7, 7, 7, 7, 8, 7, 5, 7, 5, 7, 5
    .byte 7, 7, 7, 7, 5, 6, 7, 6, 7, 5, 5, 4, 6, 5, 6
    .byte 7, 6, 6, 5, 7, 7, 7, 6, 7, 7, 6, 6, 7, 8, 7, 7
    .byte 6, 6, 7, 7, 6, 5, 7, 7, 6, 6, 6, 7, 7, 5, 5
    .byte 6, 6, 7, 6, 6, 7, 5, 7, 6, 6, 6, 7, 6, 4, 7
    .byte 6, 7, 6, 7, 7, 5, 6, 5, 7, 7, 7, 6, 8, 7, 5, 6
    .byte 7, 5, 5, 6, 7, 7, 7, 5, 7, 6, 7, 6, 7, 7, 6
    .byte 3, 6, 6, 6, 5, 7, 7, 6, 8, 6, 7, 5, 6, 6, 7, 7
    .byte 6, 7, 7, 6, 6, 6, 7, 6, 7, 7, 7, 6, 6, 6, 7
    .byte 7, 5, 7, 7, 6, 6, 6, 7, 6, 6, 6, 7, 6, 6, 6
    .byte 6, 5, 6, 6, 7, 7, 6, 6, 7, 6, 7, 6, 6, 7, 7
    .byte 6, 7, 7, 6, 6, 8, 4, 6, 6, 6, 7, 6, 6, 5, 7, 7
    .byte 5, 7, 6, 6, 4, 7, 5, 6, 7, 6, 6, 7, 6, 6, 7
    .byte 7, 6, 5, 6, 7, 7, 7, 7, 7, 7, 6, 8, 7, 6, 7, 5
    .byte 7, 6, 6, 6, 6, 6, 7, 7, 7, 5, 3, 7, 7, 7, 8, 5
    .byte 7, 7, 6, 7, 7, 7, 6, 7, 7, 7, 6, 6, 6, 6, 6
    .byte 7, 7, 7, 5, 7, 7, 6, 5, 6, 7, 6, 7, 7, 5, 7
    .byte 6, 6, 6, 6, 4, 5, 7, 7, 6, 6, 6, 8, 6, 5, 7, 5
    .byte 6, 4, 7, 5, 6, 6, 7, 7, 8, 7, 6, 7, 8, 5, 7, 7
    .byte 6, 7, 7, 6, 6, 7, 6, 6, 7, 6, 6, 6, 6, 5, 7
    .byte 6, 5, 6, 7, 5, 7, 6, 7, 7, 6, 7, 7, 7, 6, 7
    .byte 6, 8, 6, 7, 7, 7, 7, 6, 5, 7, 5, 6, 5, 6, 6, 7
    .byte 7, 6, 6, 5, 6, 6, 4, 7, 5, 7, 5, 7, 7, 6, 5
    .byte 7, 7, 7, 7, 6, 7, 6, 6, 6, 6, 7, 6, 7, 7, 7
    .byte 6, 6, 7, 7, 6, 6, 7, 7, 7, 5, 6, 5, 6, 6, 7
    .byte 7, 5, 7, 7, 6, 6, 6, 6, 6, 6, 7, 6, 7, 6, 6
    .byte 7, 7, 6, 7, 7, 6, 7, 8, 7, 6, 8, 7, 6, 6, 7, 5
    .byte 6, 7, 7, 6, 7, 7, 6, 7, 6, 6, 5, 5, 6, 6, 7
    .byte 5, 6, 5, 7, 7, 5, 6, 6, 6, 6, 6, 7, 7, 7, 6
    .byte 6, 7, 7, 6, 8, 6, 6, 7, 7, 7, 5, 8, 7, 7, 6, 4
    .byte 6, 7, 6, 6, 6, 6, 7, 6, 5, 7, 6, 7, 6, 7, 5
    .byte 7, 5, 7, 7, 7, 7, 5, 5, 5, 7, 5, 7, 6, 7, 8, 8
    .byte 7, 5, 6, 5, 5, 6, 5, 8, 6, 6, 7, 7, 7, 5, 7, 7
    .byte 7, 5, 7, 7, 7, 7, 6, 6, 7, 5, 7, 6, 5, 6, 6
    .byte 7, 6, 6, 7, 5, 6, 8, 7, 7, 7, 6, 7, 5, 6, 7, 7
    .byte 7, 6, 6, 5, 6, 6, 5, 6, 6, 6, 7, 5, 5, 5, 6
    .byte 6, 6, 7, 7, 6, 7, 7, 6, 7, 5, 7, 7, 7, 6, 7
    .byte 7, 6, 7, 7, 6, 6, 6, 5, 6, 6, 7, 6, 8, 7, 4, 7
    .byte 7, 7, 5, 4, 7, 6, 7, 4, 7, 7, 7, 7, 7, 5, 7
    .byte 4, 6, 6, 7, 6, 7, 6, 6, 7, 7, 7, 7, 7, 7, 5
    .byte 7, 6, 6, 8, 7, 5, 5, 6, 5, 7, 7, 6, 6, 6, 7, 4
    .byte 7, 7, 6, 7, 5, 7, 7, 6, 8, 6, 6, 5, 7, 6, 8, 7
    .byte 6, 8, 6, 7, 7, 5, 6, 7, 7, 7, 7, 6, 6, 7, 6, 7
    .byte 6, 6, 5, 5, 6, 7, 7, 6, 6, 5, 8, 6, 6, 7, 7, 7
    .byte 7, 6, 6, 5, 6, 7, 6, 5, 7, 7, 7, 7, 7, 8, 6, 7
    .byte 7, 7, 6, 7, 7, 7, 7, 6, 5, 6, 6, 7, 7, 8, 7, 7
    .byte 6, 6, 6, 6, 5, 6, 7, 6, 7, 6, 7, 8, 7, 6, 6, 5
    .byte 6, 6, 6, 7, 8, 6, 6, 6, 8, 6, 6, 6, 5, 6, 7, 5
    .byte 7, 6, 5, 6, 6, 6, 7, 5, 6, 4, 7, 7, 6, 6, 6
    .byte 8, 7, 7, 7, 3, 6, 5, 6, 6, 6, 6, 7, 8, 7, 7, 7
    .byte 6, 7, 6
    .byte 7, 6, 6, 7, 7, 7, 6, 6, 5, 5, 7, 7, 8, 6, 7, 6
    .byte 6, 6, 6, 6, 6, 7, 7, 5, 6, 7, 7, 6, 7, 7, 7
    .byte 7, 7, 6, 7, 7, 6, 7, 6, 5, 7, 7, 6, 5, 6, 6
    .byte 6, 8, 6, 7, 6, 5, 5, 6, 6, 5, 6, 7, 7, 7, 6, 6
    .byte 8, 8, 6, 7, 6, 7, 4, 6, 7, 6, 7, 7, 7, 7, 7, 6
    .byte 7, 6, 7, 7, 7, 6, 7, 7, 6, 6, 7, 4, 7, 6, 7
    .byte 6, 6, 6, 5, 6, 6, 6, 7, 6, 6, 6, 7, 7, 7, 7
    .byte 7, 7, 7, 6, 7, 5, 6, 7, 7, 7, 5, 7, 7, 6, 6
    .byte 7, 5, 6, 7, 5, 7, 6, 6, 6, 5, 5, 5, 6, 7, 5
    .byte 6, 7, 6, 6, 5, 6, 7, 6, 7, 5, 7, 6, 7, 7, 6
    .byte 7, 6, 7, 7, 6, 6, 6, 7, 7, 7, 6, 6, 8, 7, 7, 7
    .byte 6, 6, 3, 6, 7, 7, 7, 7, 4, 5, 7, 6, 6, 7, 7
    .byte 7, 4, 7, 7, 4, 7, 5, 7, 6, 6, 6, 8, 5, 7, 7, 7
    .byte 7, 6, 6, 7, 7, 7, 7, 7, 7, 6, 6, 5, 5, 4, 5
    .byte 6, 7, 6, 6, 6, 7, 7, 7, 7, 5, 6, 5, 6, 7, 6
    .byte 5, 7, 7, 7, 6, 7, 6, 7, 7, 7, 7, 6, 6, 7, 7
    .byte 6, 6, 7, 7, 6, 7, 7, 5, 6, 5, 7, 7, 7, 6, 6
    .byte 6, 6, 7, 6, 6, 6, 7, 7, 6, 7, 6, 8, 7, 6, 7, 6
    .byte 6, 7, 7, 7, 6, 7, 6, 6, 7, 6, 6, 6, 6, 6, 7
    .byte 6, 5, 6, 6, 7, 5, 5, 7, 7, 8, 5, 8, 5, 6, 6, 6
    .byte 7, 6, 6, 6, 7, 7, 6, 7, 5, 6, 6, 6, 6, 7, 6
    .byte 6, 7, 7, 7, 5, 7, 7, 7, 6, 6, 7, 6, 5, 6, 8, 6
    .byte 7, 6, 7, 6, 7, 6, 5, 6, 7, 5, 7, 6, 7, 6, 7
    .byte 7, 6, 7, 6, 7, 7, 7, 6, 7, 6, 5, 7, 7, 6, 5
    .byte 7, 6, 7, 8, 7, 6, 5, 5, 5, 5, 6, 5, 6, 7, 7, 7
    .byte 4, 8, 8, 6, 5, 6, 6, 8, 6, 7, 6, 7, 7, 5, 7, 7
    .byte 6
    .byte 6, 5, 6, 7, 7, 5, 6, 7, 7, 6, 7, 6, 6, 6, 6
    .byte 6, 6, 6, 6, 5, 7, 6, 7, 6, 6, 5, 6, 5, 7, 6
    .byte 6, 5, 7, 7, 6, 7, 7, 7, 7, 6, 6, 7, 7, 5, 7
    .byte 8, 5, 6, 5, 6, 5, 6, 7, 6, 7, 6, 7, 7, 7, 4, 5
    .byte 7, 6, 5, 6, 6, 6, 6, 7, 7, 6, 7, 6, 7, 5, 6
    .byte 5, 7, 6, 7, 7, 6, 7, 7, 7, 7, 7, 5, 7, 7, 8, 5
    .byte 8, 7, 6, 5, 6, 7, 5, 7, 6, 6, 6, 6, 6, 7, 5, 6
    .byte 4, 7, 7, 7, 6, 5, 6, 7, 7, 7, 7, 7, 7, 6, 7
    .byte 6, 7, 6, 6, 4, 7, 6, 6, 6, 6, 5, 7, 6, 7, 6
    .byte 7, 6, 4, 7, 7, 5, 6, 6, 7, 5, 7, 5, 6, 6, 7
    .byte 6, 7, 7, 7, 5, 6, 6, 6, 7, 6, 5, 7, 7, 7, 7
    .byte 6, 8, 6, 6, 7, 6, 6, 4, 7, 5, 7, 7, 6, 6, 7, 7
    .byte 7, 7, 3, 6, 3, 6, 8, 6, 8, 6, 8, 6, 7, 8, 7, 7
    .byte 8, 7
    .byte 7, 6, 6, 6, 7, 7, 6, 5, 7, 5, 6, 7, 6, 8, 7, 8
    .byte 6, 6, 6, 6, 5, 6, 7, 6, 5, 6, 6, 6, 7, 6, 5
    .byte 7, 7, 7, 6, 8, 7, 5, 7, 7, 8, 6, 8, 7, 6, 8, 7
    .byte 6
    .byte 6, 8, 8, 7, 6, 7, 6, 5, 6, 7, 7, 6, 6, 7, 7, 5
    .byte 6, 7, 5, 6, 5, 7, 7, 7, 6, 6, 7, 6, 7, 7, 6
    .byte 6, 7, 7, 6, 6, 7, 7, 6, 6, 6, 5, 7, 6, 6, 7
    .byte 7, 6, 5, 8, 7, 5, 5, 6, 6, 6, 6, 6, 5, 7, 6, 5
    .byte 6, 6, 6, 6, 7, 7, 7, 6, 7, 6, 7, 7, 7, 6, 8, 7
    .byte 6, 8, 7, 6, 7, 7, 6, 6, 7, 6, 4, 6, 7, 7, 6, 2
    .byte 8, 7, 7, 7, 4, 7, 7, 6, 7, 7, 7, 7, 7, 8, 7, 7
    .byte 6, 7, 6, 7, 8, 7, 7, 6, 7, 7, 7, 5, 6, 7, 7, 8
    .byte 7, 5, 6, 6, 6, 6, 6, 5, 6, 7, 8, 7, 5, 6, 8, 6
    .byte 6, 6, 6, 5, 5, 7, 6, 6, 6, 7, 7, 7, 7, 6, 7
    .byte 7, 6, 7, 6, 7, 7, 7, 7, 7, 7, 6, 7, 6, 7, 7
    .byte 7, 7, 6, 5, 6, 6, 6, 5, 7, 5, 6, 5, 6, 7, 7
    .byte 6, 6, 6, 6, 8, 6, 7, 5, 7, 7, 7, 7, 6, 7, 5, 6
    .byte 7, 4, 7, 6, 5, 7, 7, 6, 5, 8, 7, 6, 5, 6, 6, 7
    .byte 7, 6, 6, 7, 6, 7, 6, 6, 5, 6, 7, 7, 6, 7, 5
    .byte 6, 7, 7, 7, 8, 7, 7, 6, 7, 6, 7, 7, 5, 6, 6, 7
    .byte 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 5, 7, 7, 5, 7
    .byte 7, 6, 7, 7, 7, 7, 8, 7, 6, 7, 7, 7, 7, 7, 6, 6
    .byte 7, 5, 6, 7, 7, 6, 7, 6, 6, 6, 6, 6, 6, 6, 6
    .byte 6, 7, 6, 5, 5, 7, 7, 5, 7, 7, 5, 7, 6, 7, 7
    .byte 6, 6, 6, 7, 7, 6, 7, 7, 7, 7, 7, 7, 5, 7, 7
    .byte 6, 5, 5, 6, 7, 6, 7, 7, 6, 6, 5, 6, 5, 5, 6
    .byte 6, 5, 6, 6, 6, 6, 7, 7, 6, 7, 6, 7, 7, 7, 6
    .byte 6, 7, 6, 8, 6, 6, 7, 6, 6, 6, 6, 7, 6, 6, 5, 6
    .byte 5, 6, 5, 5, 7, 6, 7, 5, 8, 8, 5, 6, 6, 7, 7, 6
    .byte 6, 6, 7, 6, 6, 6, 7, 6, 7, 7, 6, 6, 7, 6, 7
    .byte 6, 7, 6, 8, 6, 5, 6, 6, 6, 7, 6, 7, 4, 7, 4, 7
    .byte 6, 5, 6, 6, 5, 6, 6, 7, 7, 6, 8, 7, 7, 6, 6, 5
    .byte 7, 6, 8, 8, 5, 6, 7, 7, 5, 7, 5, 7, 8, 5, 6, 6
    .byte 6
    .byte 5, 5, 6, 6, 7, 6, 6, 7, 7, 6, 6, 6, 7, 6, 6
    .byte 6, 6, 7, 6, 7, 7, 6, 7, 6, 6, 7, 6, 6, 7, 6
    .byte 7, 6, 6, 6, 7, 7, 8, 6, 6, 5, 4, 7, 7, 7, 7, 6
    .byte 7, 6, 5, 5, 6, 5, 6, 5, 6, 6, 6, 7, 7, 8, 7, 6
    .byte 6, 6, 6, 7, 7, 6, 7, 7, 6, 6, 7, 6, 7, 7, 6
    .byte 6, 7, 6, 5, 5, 6, 6, 5, 6, 7, 7, 7, 6, 7, 6
    .byte 7, 7, 6, 6, 5, 7, 6, 7, 7, 6, 7, 6, 6, 7, 6
    .byte 6, 7, 5, 7, 7, 7, 7, 5, 7, 7, 7, 7, 6, 7, 6
    .byte 6, 5, 7, 5, 7, 7, 6, 5, 6, 6, 4, 5, 6, 5, 7
    .byte 6, 7, 7, 8, 7, 6, 6, 6, 7, 7, 7, 6, 7, 7, 6, 6
    .byte 7, 6, 6, 8, 6, 6, 7, 6, 6, 5, 5, 5, 5, 7, 6, 6
    .byte 7, 7, 6, 5, 7, 7, 6, 5, 6, 6, 7, 6, 7, 5, 8, 7
    .byte 5, 7, 7, 6, 6, 6, 7, 7, 7, 6, 5, 7, 7, 7, 7
    .byte 5, 7, 7, 7, 5, 6, 6, 7, 4, 6, 7, 5, 6, 7, 6
    .byte 6, 5, 7, 7, 5, 7, 6, 8, 6, 7, 5, 7, 6, 8, 7, 6
    .byte 7, 7, 6, 6, 7, 6, 7, 7, 6, 5, 6, 5, 5, 5, 6
    .byte 5, 6, 6, 7, 7, 6, 7, 6, 6, 6, 6, 5, 6, 6, 6
    .byte 6, 7, 7, 6, 7, 7, 6, 7, 7, 6, 6, 6, 6, 6, 6
    .byte 6, 6, 8, 7, 7, 6, 6, 5, 7, 6, 7, 6, 6, 6, 6, 6
    .byte 4, 6, 5, 5, 6, 7, 7, 6, 7, 6, 6, 6, 6, 7, 7
    .byte 7, 7, 6, 7, 6, 7, 6, 6, 7, 6, 6, 6, 7, 7, 7
    .byte 6, 4, 6, 6, 7, 5, 5, 7, 6, 7, 5, 7, 7, 6, 7
    .byte 6, 6, 7, 5, 6, 5, 6, 6, 7, 7, 7, 7, 7, 7, 6
    .byte 6, 6, 6, 7, 6, 7, 7, 7, 6, 6, 6, 5, 7, 7, 6
    .byte 7, 5, 7, 6, 6, 6, 6, 4, 5, 7, 6, 6, 6, 6, 7
    .byte 7, 6, 7, 6, 7, 6, 6, 6, 8, 7, 7, 6, 7, 7, 7, 6
    .byte 6, 6, 8, 5, 7, 5, 5, 5, 6, 6, 6, 6, 5, 5, 7, 6
    .byte 6, 6, 6, 7, 6, 7, 7, 4, 6, 5, 6, 6, 6, 6, 7
    .byte 8, 7, 7, 7, 7, 7, 6, 7, 7, 6, 7, 7, 7, 5, 6, 6
    .byte 6, 6, 7, 7, 7, 7, 7, 6, 6, 6, 5, 5, 7, 6, 5
    .byte 6, 6, 7, 6, 7, 7, 7, 6, 8, 6, 7, 6, 6, 7, 6, 6
    .byte 6, 7, 6, 6, 7, 5, 7, 7, 5, 6, 6, 5, 5, 7, 6
    .byte 5, 6, 7, 6, 8, 6, 6, 7, 7, 6, 7, 5, 6, 4, 6, 7
    .byte 6, 6, 7, 6, 7, 7, 7, 6, 7, 6, 7, 6, 7, 6, 6
    .byte 6, 5, 7, 5, 6, 7, 7, 7, 5, 7, 3, 8, 8, 6, 7, 4
    .byte 8, 7, 7, 7, 7, 7, 6, 7, 7, 8, 8, 7, 7, 7, 7, 7
    .byte 6
    .byte 7, 7, 7, 8, 7, 6, 7, 8, 7, 8, 6, 6, 6, 6, 7, 7
    .byte 6
    .byte 6, 7, 6, 8, 6, 6, 7, 8, 7, 6, 7, 7, 4, 6, 7, 7
    .byte 6, 7, 7, 7, 8, 8, 7, 6, 8, 7, 8, 6, 7, 7, 8, 7
    .byte 7, 6
    .byte 6, 7, 6, 8, 7, 7, 7, 5, 8, 7, 6, 7, 6, 4, 5, 5
    .byte 6, 7, 7, 6, 6, 6, 7, 6, 7, 6, 6, 7, 8, 7, 7, 7
    .byte 7, 6, 6, 5, 6, 6, 5, 6, 7, 7, 6, 6, 7, 6, 6
    .byte 6, 7, 6, 5, 5, 5, 5, 6, 7, 5, 7, 6, 6, 7, 8, 7
    .byte 7, 5, 6, 7, 8, 7, 7, 6, 7, 6, 7, 7, 7, 5, 6, 7
    .byte 6, 7, 6, 6, 5, 6, 6, 7, 5, 6, 6, 8, 7, 7, 3, 6
    .byte 3, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 7, 6, 6
    .byte 6, 7, 6, 7, 7, 6, 6, 7, 6, 6, 6, 7, 7, 7, 7
    .byte 6, 6, 7, 7, 6, 6, 6, 5, 5, 5, 6, 7, 7, 6, 6
    .byte 7, 6, 7, 7, 7, 7, 6, 6, 6, 8, 7, 7, 7, 7, 7, 7
    .byte 6, 5, 8, 7, 7, 7, 6, 6, 6, 6, 6, 7, 7, 6, 6, 6
    .byte 7, 5, 6, 6, 6, 5, 7, 6, 7, 6, 6, 7, 7, 7, 7
    .byte 6, 7, 6, 7, 7, 6, 7, 7, 7, 5, 7, 7, 5, 6, 6
    .byte 5, 7, 6, 7, 5, 7, 6, 5, 7, 6, 6, 5, 6, 6, 5
    .byte 7, 6, 7, 7, 6, 6, 7, 7, 6, 5, 7, 7, 7, 6, 6
    .byte 6, 7, 6, 7, 7, 7, 7, 6, 6, 7, 5, 7, 5, 7, 6
    .byte 6, 7, 6, 6, 7, 6, 7, 6, 6, 6, 6, 5, 8, 6, 5, 6
    .byte 7, 7, 5, 7, 6, 6, 7, 5, 7, 7, 8, 5, 8, 7, 5, 5
    .byte 6, 5, 5, 7, 6, 7, 7, 6, 7, 7, 7, 5
    .byte 6, 7, 6, 4, 7, 6, 6, 6, 7, 8, 6, 8, 7, 8, 5, 7
    .byte 5
    .byte 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 7, 6, 7, 5
    .byte 7, 7, 7, 6, 6, 7, 6, 6
pdb_perm:
    .byte 0
    .byte 7, 7, 6, 6, 6, 7, 5, 6, 1, 6, 6, 6, 6, 6, 6
    .byte 1, 6, 1, 6, 6, 7, 6, 5, 7, 3, 3, 6, 6, 6, 5
    .byte 5, 6, 6, 4, 4, 4, 5, 5, 4, 6, 5, 6, 4, 5, 5
    .byte 3, 5, 5, 5, 4, 6, 5, 4, 6, 4, 6, 4, 4, 5, 6
    .byte 5, 3, 4, 5, 5, 5, 5, 6, 5, 5, 4, 6, 4, 5, 5
    .byte 6, 3, 6, 4, 7, 6, 4, 4, 3, 6, 4, 4, 6, 5, 5
    .byte 5, 6, 6, 4, 3, 6, 4, 4, 5, 5, 5, 4, 5, 6, 6
    .byte 4, 4, 4, 5, 4, 5, 6, 5, 5, 4, 5, 5, 3, 5, 7
    .byte 4, 5, 5, 5, 5, 4, 5, 5, 6, 4, 5, 5, 4, 5, 5
    .byte 6, 5, 6, 5, 5, 5, 5, 6, 5, 5, 5, 6, 3, 5, 6
    .byte 5, 3, 4, 4, 6, 6, 2, 4, 5, 5, 6, 5, 5, 6, 3
    .byte 6, 5, 3, 4, 4, 5, 6, 6, 6, 6, 6, 3, 5, 4, 5
    .byte 5, 5, 5, 3, 5, 2, 5, 6, 5, 5, 6, 6, 5, 5, 2
    .byte 5, 5, 1, 6, 6, 5, 5, 6, 6, 5, 6, 5, 5, 2, 6
    .byte 6, 2, 5, 5, 6, 6, 5, 5, 7, 3, 4, 6, 5, 3, 5
    .byte 4, 5, 5, 2, 5, 5, 5, 6, 5, 5, 6, 3, 6, 4, 5
    .byte 5, 5, 3, 6, 5, 3, 4, 6, 6, 5, 5, 4, 6, 5, 5
    .byte 5, 3, 5, 6, 2, 7, 5, 4, 6, 5, 4, 5, 5, 6, 6
    .byte 5, 4, 6, 4, 4, 4, 5, 6, 4, 5, 5, 6, 3, 5, 5
    .byte 4, 5, 6, 4, 5, 5, 4, 6, 4, 6, 5, 5, 4, 4, 4
    .byte 5, 5, 5, 5, 4, 5, 5, 5, 5, 3, 6, 5, 4, 5, 6
    .byte 4, 5, 6, 6, 4, 4, 5, 5, 5, 4, 5, 6, 5, 6, 4
    .byte 6, 6, 3, 5, 5, 5, 6, 6, 3, 5, 6, 3, 5, 5, 6
    .byte 5, 5, 5, 6, 6, 5, 5, 3, 6, 5, 2, 5, 6, 5, 6
    .byte 5, 6, 5, 2, 5, 6, 6, 1, 6, 6, 5, 5, 2, 6, 5
    .byte 6, 5, 5, 5, 5, 2, 6, 5, 6, 5, 4, 6, 5, 3, 7
    .byte 4, 6, 6, 3, 5, 4, 6, 4, 3, 5, 6, 6, 4, 6, 6
    .byte 5, 3, 4, 6, 6, 3, 6, 5, 3, 5, 6, 5, 6, 5, 5
    .byte 6, 5, 6, 5, 3, 5, 5, 2, 6, 6, 4, 4, 5, 5, 5
    .byte 4, 6, 5, 5, 3, 5, 5, 4, 5, 4, 6, 4, 4, 5, 5
    .byte 5, 4, 4, 5, 5, 5, 5, 4, 6, 6, 5, 6, 5, 6, 5
    .byte 3, 5, 4, 5, 5, 4, 5, 6, 5, 4, 6, 6, 5, 6, 3
    .byte 4, 4, 6, 5, 6, 6, 5, 6, 3, 5, 4, 5, 6, 6, 5
    .byte 2, 6, 3, 5, 5, 5, 5, 6, 4, 4, 6, 5, 5, 4, 6
    .byte 3, 6, 5, 6, 4, 4, 6, 4, 5, 5, 5, 5, 5, 5, 6
    .byte 5, 4, 5, 4, 4, 5, 5, 5, 6, 6, 6, 5, 4, 4, 3
    .byte 6, 6, 3, 6, 6, 5, 3, 5, 6, 4, 5, 5, 5, 5, 6
    .byte 6, 2, 5, 2, 6, 4, 5, 6, 6, 5, 1, 6, 5, 5, 4
    .byte 6, 6, 5, 5, 2, 5, 3, 5, 5, 5, 6, 5, 6, 6, 5
    .byte 4, 4, 4, 5, 5, 5, 5, 4, 5, 5, 5, 5, 4, 6, 4
    .byte 6, 5, 3, 6, 5, 3, 4, 5, 5, 6, 5, 5, 5, 5, 5
    .byte 5, 3, 5, 6, 2, 6, 6, 4, 6, 4, 4, 5, 5, 5, 6
    .byte 5, 5, 7, 4, 3, 3, 6, 5, 3, 6, 6, 6, 3, 5, 6
    .byte 4, 6, 5, 4, 4, 6, 5, 5, 5, 5, 5, 5, 4, 5, 5
    .byte 5, 4, 5, 5, 5, 4, 5, 6, 4, 4, 5, 5, 5, 6, 5
    .byte 3, 5, 6, 6, 3, 5, 6, 4, 4, 4, 6, 6, 5, 6, 4
    .byte 6, 5, 4, 5, 6, 4, 6, 6, 3, 5, 5, 3, 4, 6, 5
    .byte 5, 5, 5, 6, 5, 6, 4, 3, 5, 6, 2, 6, 6, 5, 7
    .byte 5, 4, 5, 5, 5, 5, 6, 5, 6, 5, 5, 5, 5, 5, 5
    .byte 6, 4, 6, 5, 5, 4, 4, 5, 3, 7, 5, 5, 5, 5, 5
    .byte 5, 5, 4, 4, 6, 6, 6, 5, 4, 4, 5, 4, 4, 6, 6
    .byte 6, 4, 5, 5, 6, 4, 6, 4, 4, 4, 6, 5, 5, 5, 4
    .byte 5, 4, 6, 4, 4, 5, 6, 3, 6, 5, 3, 5, 4, 5, 6
    .byte 4, 6, 6, 5, 4, 5, 6, 4, 4, 3, 5, 5, 5, 6, 4
    .byte 5, 5, 4, 5, 6, 4, 6, 4, 6, 5, 4, 5, 5, 5, 5
    .byte 4, 6, 6, 6, 5, 4, 4, 6, 4, 3, 6, 6, 6, 5, 6
    .byte 5, 4, 4, 4, 5, 4, 5, 5, 7, 4, 4, 4, 5, 6, 3
    .byte 6, 5, 6, 4, 5, 5, 4, 5, 5, 6, 5, 4, 6, 3, 4
    .byte 4, 5, 4, 5, 6, 6, 6, 4, 5, 5, 4, 5, 4, 3, 5
    .byte 5, 4, 6, 3, 5, 5, 4, 6, 4, 5, 4, 5, 4, 4, 4
    .byte 3, 6, 5, 6, 4, 6, 5, 5, 4, 4, 6, 5, 5, 2, 7
    .byte 5, 5, 6, 6, 5, 5, 3, 5, 5, 5, 5, 3, 4, 6, 4
    .byte 3, 6, 4, 6, 5, 4, 5, 5, 5, 6, 3, 4, 4, 5, 3
    .byte 6, 6, 6, 5, 4, 6, 4, 4, 4, 5, 4, 6, 5, 4, 4
    .byte 4, 6, 5, 5, 5, 4, 6, 5, 4, 6, 5, 5, 6, 5, 7
    .byte 4, 5, 3, 6, 5, 5, 4, 5, 6, 5, 6, 5, 2, 5, 6
    .byte 5, 3, 5, 6, 4, 5, 3, 4, 6, 5, 6, 6, 5, 6, 3
    .byte 4, 5, 5, 5, 2, 5, 6, 6, 5, 6, 6, 4, 3, 5, 6
    .byte 6, 5, 3, 5, 5, 4, 3, 4, 5, 6, 6, 5, 3, 5, 3
    .byte 5, 5, 2, 6, 5, 5, 4, 4, 4, 5, 5, 5, 5, 3, 4
    .byte 5, 3, 4, 4, 6, 6, 4, 5, 6, 6, 5, 6, 5, 6, 6
    .byte 4, 4, 4, 5, 5, 4, 6, 6, 5, 5, 6, 5, 5, 4, 6
    .byte 4, 3, 5, 6, 6, 4, 5, 6, 6, 4, 4, 5, 5, 6, 4
    .byte 5, 5, 6, 4, 4, 5, 4, 6, 1, 6, 6, 5, 6, 6, 6
    .byte 5, 6, 2, 5, 5, 5, 5, 6, 5, 2, 5, 2, 6, 5, 6
    .byte 5, 5, 6, 4, 5, 5, 5, 4, 6, 5, 5, 7, 4, 4, 3
    .byte 5, 5, 4, 6, 6, 6, 4, 6, 6, 4, 4, 5, 5, 6, 7
    .byte 3, 4, 6, 4, 4, 4, 5, 4, 5, 4, 3, 5, 5, 6, 5
    .byte 6, 6, 4, 4, 4, 3, 5, 6, 5, 4, 4, 5, 3, 5, 4
    .byte 6, 5, 4, 5, 4, 5, 4, 5, 4, 6, 4, 5, 5, 4, 6
    .byte 5, 5, 5, 4, 4, 5, 4, 3, 6, 5, 6, 6, 4, 5, 5
    .byte 6, 5, 5, 6, 4, 4, 6, 4, 6, 5, 5, 2, 5, 5, 3
    .byte 6, 5, 7, 5, 5, 4, 5, 5, 4, 6, 3, 6, 4, 3, 6
    .byte 5, 5, 2, 5, 6, 5, 4, 4, 6, 3, 5, 3, 6, 5, 4
    .byte 5, 4, 5, 3, 6, 3, 5, 5, 5, 5, 4, 5, 5, 6, 4
    .byte 4, 5, 4, 5, 3, 5, 6, 6, 5, 4, 6, 6, 5, 3, 4
    .byte 5, 4, 4, 6, 5, 5, 6, 3, 4, 5, 6, 5, 6, 5, 5
    .byte 4, 5, 6, 5, 5, 4, 5, 5, 4, 4, 4, 4, 6, 5, 5
    .byte 4, 6, 5, 6, 5, 4, 5, 5, 5, 6, 5, 5, 5, 4, 6
    .byte 4, 5, 4, 5, 5, 5, 4, 5, 5, 6, 6, 5, 2, 5, 5
    .byte 4, 3, 5, 6, 5, 6, 3, 5, 5, 4, 6, 5, 5, 6, 3
    .byte 5, 4, 6, 6, 3, 4, 6, 6, 4, 5, 6, 5, 4, 5, 5
    .byte 6, 6, 4, 5, 4, 5, 4, 4, 5, 6, 5, 4, 3, 5, 4
    .byte 6, 4, 3, 5, 6, 4, 5, 4, 4, 5, 5, 6, 4, 4, 3
    .byte 6, 4, 5, 4, 5, 5, 4, 4, 5, 6, 5, 6, 5, 5, 6
    .byte 4, 4, 4, 6, 5, 3, 5, 6, 6, 4, 5, 6, 5, 4, 6
    .byte 5, 4, 4, 4, 5, 4, 5, 4, 6, 5, 4, 5, 4, 6, 5
    .byte 6, 4, 7, 4, 3, 5, 5, 5, 4, 4, 6, 5, 5, 5, 6
    .byte 4, 6, 5, 5, 4, 3, 6, 5, 6, 4, 6, 5, 6, 5, 5
    .byte 4, 5, 4, 6, 5, 3, 6, 6, 4, 5, 5, 4, 4, 5, 5
    .byte 6, 6, 5, 5, 4, 5, 4, 4, 5, 6, 5, 5, 6, 5, 5
    .byte 4, 4, 6, 4, 3, 5, 5, 6, 6, 4, 5, 4, 4, 5, 5
    .byte 4, 6, 4, 6, 4, 4, 5, 7, 5, 5, 5, 6, 4, 6, 5
    .byte 6, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 5, 4, 5, 6
    .byte 5, 5, 5, 5, 4, 5, 4, 6, 5, 5, 5, 6, 5, 3, 6
    .byte 6, 5, 5, 5, 6, 5, 5, 4, 5, 6, 5, 3, 4, 6, 4
    .byte 6, 5, 4, 6, 5, 5, 5, 6, 6, 5, 4, 4, 5, 4, 5
    .byte 6, 6, 5, 6, 5, 5, 3, 4, 5, 5, 4, 5, 5, 5, 6
    .byte 4, 5, 4, 5, 5, 6, 5, 4, 4, 6, 5, 2, 5, 7, 5
    .byte 6, 5, 5, 4, 5, 3, 6, 5, 5, 5, 5, 6, 3, 4, 3
    .byte 6, 4, 5, 6, 5, 5, 5, 5, 3, 4, 6, 4, 5, 5, 5
    .byte 5, 5, 5, 5, 6, 5, 4, 4, 5, 4, 4, 5, 6, 6, 5
    .byte 5, 4, 6, 6, 5, 5, 6, 5, 5, 4, 5, 5, 5, 6, 5
    .byte 5, 5, 4, 5, 6, 5, 4, 6, 3, 6, 5, 4, 6, 5, 5
    .byte 6, 6, 4, 4, 6, 6, 5, 5, 4, 4, 5, 4, 4, 5, 6
    .byte 5, 5, 4, 3, 6, 4, 5, 5, 5, 4, 6, 5, 6, 3, 2
    .byte 6, 5, 5, 5, 5, 5, 5, 4, 6, 3, 5, 5, 5, 6, 5
    .byte 3, 4, 5, 4, 4, 4, 5, 5, 6, 4, 3, 6, 5, 5, 5
    .byte 6, 5, 4, 5, 4, 6, 4, 4, 6, 5, 4, 5, 5, 5, 6
    .byte 5, 5, 5, 4, 5, 5, 6, 5, 5, 5, 5, 5, 5, 5, 5
    .byte 6, 5, 4, 5, 5, 4, 6, 5, 4, 5, 6, 6, 5, 5, 6
    .byte 5, 5, 5, 6, 4, 4, 6, 6, 6, 4, 6, 4, 5, 4, 4
    .byte 4, 6, 5, 6, 4, 5, 6, 3, 6, 6, 5, 5, 5, 5, 6
    .byte 4, 4, 5, 4, 3, 6, 5, 4, 5, 5, 5, 5, 4, 5, 5
    .byte 4, 5, 4, 5, 5, 4, 4, 6, 5, 5, 5, 4, 3, 5, 4
    .byte 5, 5, 3, 6, 6, 4, 6, 4, 4, 6, 5, 6, 4, 4, 3
    .byte 6, 4, 5, 4, 6, 5, 6, 4, 4, 6, 5, 5, 4, 5, 4
    .byte 5, 5, 6, 5, 5, 5, 5, 5, 5, 5, 4, 5, 6, 5, 5
    .byte 4, 6, 6, 5, 4, 5, 5, 5, 5, 5, 5, 5, 4, 4, 6
    .byte 6, 5, 5, 6, 6, 5, 5, 5, 5, 4, 5, 5, 4, 6, 4
    .byte 6, 4, 5, 5, 5, 5, 3, 6, 5, 5, 5, 6, 6, 5, 4
    .byte 4, 7, 6, 6, 4, 4, 5, 4, 5, 5, 4, 5, 5, 5, 6
    .byte 5, 5, 5, 6, 5, 6, 4, 4, 5, 6, 5, 3, 6, 5, 4
    .byte 4, 6, 5, 5
    .byte 5, 4, 5, 6, 5, 5, 5, 4, 4, 5, 4, 5, 5, 5, 6
    .byte 5, 4, 4, 5, 5, 4, 5, 6, 4, 5, 5, 5, 4, 3, 5
    .byte 5, 4, 5, 6, 5, 5, 5, 5, 4, 5, 5, 5, 5, 5, 5
    .byte 6, 4, 6, 5, 6, 5, 6, 6, 4, 6, 6, 5, 5, 5, 6
    .byte 5, 5, 5, 7, 4, 6, 4, 5, 5, 4, 5, 5, 5, 5, 4
    .byte 6, 5, 4, 5, 5, 5, 5, 4, 5, 6, 5, 6, 5, 4, 4
    .byte 5, 5, 5, 5, 6, 4, 6, 5, 6, 4, 3, 6, 5, 5, 5
    .byte 6, 5, 6, 5, 6, 4, 5, 6, 6, 6, 4, 4, 5, 5, 5
    .byte 4, 5, 5, 5, 5, 5, 4, 5, 6, 4, 6, 6, 4, 5, 6
    .byte 5, 5, 4, 4, 7, 5, 3, 6, 4, 4, 5, 4, 5, 5, 4
    .byte 4, 4, 5, 6, 4, 5, 6, 5, 5, 4, 5, 6, 5, 6, 4
    .byte 3, 6, 3, 5, 4, 5, 5, 5, 4, 2, 5, 5, 6, 5, 6
    .byte 7, 5, 5, 3, 6, 5, 6, 2, 5, 5, 1, 6, 6, 5, 5
    .byte 6, 6, 6, 5, 6, 5, 2, 5, 6, 2, 5, 5, 5, 5, 5
    .byte 5, 6, 3, 4, 6, 4, 2, 6, 5, 6, 5, 3, 5, 4, 5
    .byte 5, 5, 5, 5, 3, 6, 4, 2, 6, 5, 5, 5, 6, 5, 5
    .byte 6, 3, 4, 6, 6, 6, 6, 5, 3, 4, 3, 4, 4, 6, 5
    .byte 6, 5, 6, 3, 6, 5, 5, 5, 4, 5, 4, 4, 6, 7, 5
    .byte 4, 4, 4, 5, 4, 4, 5, 4, 6, 5, 5, 6, 5, 4, 3
    .byte 6, 5, 6, 2, 5, 5, 5, 5, 3, 7, 5, 6, 4, 5, 4
    .byte 5, 3, 5, 6, 7, 4, 4, 6, 6, 4, 6, 5, 6, 6, 3
    .byte 4, 3, 5, 5, 3, 6, 5, 6, 4, 5, 6, 4, 4, 5, 6
    .byte 5, 4, 5, 5, 4, 4, 6, 6, 5, 5, 6, 6, 5, 5, 5
    .byte 4, 6, 4, 3, 5, 6, 4, 5, 5, 5, 5, 4, 5, 5, 4
    .byte 3, 5, 5, 4, 5, 4, 5, 4, 4, 5, 5, 4, 4, 4, 5
    .byte 5, 4, 5, 5, 5, 5, 6, 6, 5, 5, 5, 4, 5, 4, 5
    .byte 5, 4, 4, 6, 4, 5, 5, 6, 5, 6, 3, 6, 5, 6, 4
    .byte 5, 6, 4, 5, 4, 4, 6, 6, 5, 5, 4, 4, 5, 4, 4
    .byte 5, 5, 6, 4, 4, 5, 5, 5, 5, 6, 6, 5, 5, 4, 6
    .byte 4, 4, 4, 5, 6, 4, 6, 3, 5, 6, 5, 4, 5, 5, 5
    .byte 4, 6, 4, 4, 5, 4, 4, 4, 3, 6, 6, 3, 3, 4, 5
    .byte 5, 4, 4, 6, 4, 5, 4, 6, 3, 5, 6, 5, 4, 6, 4
    .byte 6, 5, 4, 3, 2, 6, 5, 4, 6, 6, 6, 5, 5, 6, 3
    .byte 5, 4, 6, 6, 6, 3, 4, 5, 3, 4, 5, 6, 5, 6, 4
    .byte 4, 5, 4, 6, 5, 5, 6, 4, 5, 4, 4, 3, 5, 6, 5
    .byte 4, 5, 4, 6, 4, 6, 4, 4, 5, 3, 6, 4, 5, 3, 6
    .byte 6, 6, 4, 4, 5, 5, 6, 4, 3, 6, 3, 6, 4, 4, 5
    .byte 5, 5, 4, 6, 6, 4, 4, 5, 5, 4, 4, 4, 7, 5, 5
    .byte 5, 5, 4, 5, 6, 4, 3, 5, 5, 4, 4, 4, 5, 5, 4
    .byte 6, 5, 4, 5, 4, 5, 5, 6, 5, 5, 4, 6, 5, 5, 4
    .byte 6, 6, 5, 6, 6, 5, 5, 4, 6, 5, 6, 4, 4, 5, 5
    .byte 4, 5, 4, 6, 6, 6, 4, 5, 5, 5, 5, 6, 4, 4, 6
    .byte 5, 6, 5, 5, 4, 5, 6, 5, 3, 5, 6, 5, 6, 4, 3
    .byte 5, 3, 5, 4, 5, 5, 5, 5, 4, 5, 6, 5, 4, 5, 6
    .byte 4, 4, 4, 5, 4, 4, 5, 6, 5, 3, 5, 3, 5, 4, 4
    .byte 5, 5, 4, 2, 5, 4, 5, 3, 5, 6, 5, 5, 3, 5, 4
    .byte 5, 5, 4, 6, 5, 6, 4, 5, 5, 5, 5, 3, 6, 6, 5
    .byte 5, 4, 6, 6, 4, 4, 6, 5, 6, 6, 4, 4, 6, 3, 5
    .byte 5, 4, 6, 6, 5, 5, 6, 5, 4, 4, 4, 6, 4, 5, 5
    .byte 6, 6, 6, 4, 5, 5, 4, 6, 5, 5, 5, 5, 7, 6, 4
    .byte 4, 5, 6, 5, 6, 5, 5, 4, 6, 5, 4, 5, 5, 6, 4
    .byte 4, 6, 4, 4, 5, 4, 5, 4, 4, 4, 4, 5, 7, 5, 5
    .byte 6, 5, 5, 3, 6, 4, 6, 6, 4, 4, 5, 5, 4, 5, 5
    .byte 5, 4, 3, 5, 6, 6, 5, 5, 6, 6, 4, 4, 5, 5, 5
    .byte 5, 3, 6, 5, 2, 5, 5, 4, 6, 6, 6, 6, 4, 6, 5
    .byte 3, 4, 6, 3, 6, 5, 5, 4, 6, 4, 5, 5, 5, 6, 5
    .byte 4, 5, 4, 5, 6, 5, 5, 4, 4, 6, 5, 3, 5, 5, 6
    .byte 4, 5, 4, 6, 5, 4, 7, 6, 6, 3, 5, 6, 4, 3, 4
    .byte 6, 5, 6, 6, 5, 5, 5, 4, 4, 6, 4, 4, 6, 5, 6
    .byte 4, 4, 5, 6, 4, 6, 4, 4, 6, 5, 6, 4, 4, 3, 5
    .byte 5, 5, 3, 5, 6, 5, 5, 6, 3, 5, 6, 5, 3, 5, 6
    .byte 4, 5, 2, 4, 6, 6, 5, 5, 6, 5, 3, 4, 5, 5, 6
    .byte 2, 6, 6, 5, 6, 5, 6, 4, 3, 5, 6, 5, 4, 3, 5
    .byte 6, 4, 3, 5, 5, 6, 5, 6, 4, 4, 4, 4, 5, 3, 6
    .byte 4, 5, 3, 5, 5, 4, 5, 4, 6, 4, 5, 4, 4, 3, 4
    .byte 6, 6, 3, 5, 5, 5, 5, 5, 4, 5, 6, 5, 4, 4, 5
    .byte 4, 5, 5, 6, 6, 6, 5, 6, 4, 4, 4, 6, 5, 4, 5
    .byte 5, 5, 5, 5, 4, 4, 5, 6, 6, 5, 5, 3, 5, 4, 5
    .byte 5, 5, 6, 4, 6, 5, 3, 6, 5, 4, 6, 5, 5, 5, 4
    .byte 5, 6, 5, 4, 4, 5, 5, 5, 4, 6, 4, 5, 4, 4, 4
    .byte 5, 6, 4, 5, 6, 5, 5, 4, 5, 5, 5, 5, 4, 5, 4
    .byte 5, 3, 6, 6, 5, 4, 5, 6, 6, 5, 4, 5, 4, 5, 3
    .byte 6, 6, 5, 5, 5, 5, 4, 4, 5, 5, 6, 5, 4, 6, 6
    .byte 4, 6, 4, 4, 5, 4, 5, 5, 6, 4, 5, 4, 5, 5, 4
    .byte 5, 5, 6, 4, 5, 5, 5, 3, 5, 6, 5, 6, 6, 4, 5
    .byte 4, 4, 4, 4, 5, 6, 5, 5, 5, 5, 5, 6, 4, 6, 5
    .byte 3, 4, 6, 5, 6, 5, 4, 3, 4, 5, 4, 6, 5, 6, 4
    .byte 5, 4, 5, 6, 3, 6, 4, 5, 4, 4, 5, 5, 6, 3, 6
    .byte 5, 5, 3, 5, 6, 4, 4, 4, 5, 5, 5, 4, 5, 4, 4
    .byte 6, 4, 5, 6, 4, 6, 5, 5, 5, 5, 4, 3, 5, 5, 5
    .byte 2, 6, 5, 5, 5, 3, 6, 5, 6, 4, 5, 4, 4, 3, 6
    .byte 6, 4, 5, 4, 3, 5, 6, 4, 6, 5, 4, 5, 4, 5, 6
    .byte 6, 5, 4, 4, 3, 5, 4, 5, 5, 5, 5, 4, 5, 5, 4
    .byte 5, 5, 5, 5, 6, 5, 4, 3, 5, 5, 5, 6, 6, 6, 4
    .byte 5, 5, 4, 4, 5, 4, 6, 5, 4, 3, 6, 4, 3, 6, 6
    .byte 5, 5, 4, 4, 5, 6, 5, 5, 6, 5, 4, 5, 4, 6, 4
    .byte 5, 2, 6, 5, 1, 6, 6, 5, 5, 5, 5, 5, 5, 6, 6
    .byte 2, 5, 6, 2, 5, 4, 6, 5, 5, 3, 6, 6, 6, 6, 6
    .byte 5, 4, 4, 4, 5, 5, 6, 4, 4, 6, 4, 4, 5, 6, 5
    .byte 5, 4, 5, 5, 5, 5, 6, 6, 6, 4, 5, 5, 5, 4, 5
    .byte 6, 4, 5, 5, 5, 4, 5, 5, 5, 5, 2, 5, 6, 5, 5
    .byte 5, 5, 4, 6, 3, 6, 5, 4, 6, 5, 5, 3, 5, 3, 5
    .byte 4, 6, 5, 4, 6, 4, 2, 6, 6, 5, 5, 4, 6, 6, 3
    .byte 5, 5, 5, 5, 3, 5, 6, 5, 3, 6, 6, 4, 5, 4, 5
    .byte 5, 6, 4, 4, 5, 5, 5, 3, 4, 5, 6, 5, 4, 5, 4
    .byte 6, 4, 5, 6, 5, 5, 5, 6, 4, 5, 6, 6, 3, 5, 4
    .byte 6, 6, 5, 5, 4, 6, 4, 5, 6, 6, 5, 4, 5, 5, 4
    .byte 4, 6, 4, 4, 5, 6, 5, 4, 5, 6, 6, 5, 5, 5, 5
    .byte 4, 5, 6, 5, 5, 5, 5, 5, 4, 5, 6, 5, 4, 4, 6
    .byte 5, 4, 4, 5, 6, 4, 6, 6, 5, 5, 5, 5, 4, 6, 5
    .byte 5, 6, 5, 5, 3, 4, 6, 4, 5, 5, 4, 5, 5, 4, 6
    .byte 4, 3, 6, 5, 5, 4, 4, 4, 5, 3, 6, 4, 4, 4, 4
    .byte 3, 6, 6, 6, 5, 6, 6, 5, 3, 5, 5, 6, 6, 4, 5
    .byte 5, 5, 4, 6, 6, 4, 5, 5, 6, 5, 5, 4, 4, 5, 5
    .byte 4, 4, 5, 6, 6, 4, 4, 6, 5, 6, 5, 6, 6, 3, 6
    .byte 5, 4, 5, 6, 3, 5, 5, 4, 4, 6, 5, 6, 5, 4, 6
    .byte 5, 5, 4, 4, 5, 5, 4, 6, 5, 5, 5, 5, 4, 3, 5
    .byte 5, 4, 4, 5, 5, 3, 6, 6, 5, 5, 4, 6, 4, 6, 4
    .byte 4, 4, 6, 5, 3, 6, 4, 6, 5, 4, 6, 5, 5, 3, 5
    .byte 6, 6, 5, 5, 5, 3, 6, 2, 5, 6, 4, 5, 5, 6, 3
    .byte 5, 6, 4, 4, 5, 4, 5, 6, 6, 4, 4, 5, 3, 6, 5
    .byte 5, 5, 6, 6, 5, 4, 4, 5, 4, 5, 5, 3, 6, 5, 6
    .byte 4, 6, 5, 4, 3, 4, 6, 5, 5, 5, 6, 4, 4, 4, 4
    .byte 5, 5, 6, 5, 6, 4, 5, 6, 4, 3, 5, 5, 6, 5, 4
    .byte 5, 4, 5, 5, 4, 5, 6, 4, 6, 5, 5, 6, 6, 4, 5
    .byte 6, 4, 5, 5, 5, 6, 5, 5, 4, 5, 6, 4, 4, 5, 6
    .byte 3, 4, 6, 6, 6, 3, 5, 5, 6, 4, 5, 4, 7, 5, 6
    .byte 4, 4, 6, 3, 5, 6, 5, 5, 5, 6, 6, 3, 4, 6, 5
    .byte 3, 5, 5, 4, 5, 5, 5, 5, 4, 6, 6, 4, 5, 4, 6
    .byte 4, 5, 4, 5, 4, 5, 5, 5, 3, 5, 5, 4, 5, 4, 6
    .byte 5, 4, 5, 4, 4, 5, 6, 6, 5, 5, 4, 5, 5, 5, 4
    .byte 6, 5, 6, 4, 4, 5, 5, 4, 4, 6, 5, 5, 5, 5, 6
    .byte 5, 5, 6, 5, 6, 5, 4, 5, 6, 5, 6, 4, 5, 5, 4
    .byte 5, 6, 6, 4, 5, 5, 4, 3, 5, 6, 5, 5, 6, 6, 4
    .byte 5, 5, 4, 6, 5, 6, 5, 6, 4, 4, 5, 4, 3, 6, 5
    .byte 6, 6, 4, 5, 4, 5, 5, 6, 5, 5, 4, 7, 4, 4, 5
    .byte 5, 4, 4, 5, 3, 6, 5, 4, 6, 5, 6, 5, 5, 6, 4
    .byte 4, 3, 6, 4, 5, 6, 6, 6, 4, 2, 5, 6, 6, 4, 5
    .byte 6, 6, 3, 5, 5, 5, 6, 3, 5, 5, 6, 3, 5, 5, 4
    .byte 6, 4, 4, 4, 6, 5, 4, 6, 5, 5, 5, 3, 5, 5, 4
    .byte 4, 4, 5, 6, 4, 4, 7, 5, 5, 4, 6, 6, 4, 5, 5
    .byte 5, 5, 4, 4, 6, 5, 6, 6, 5, 5, 4, 5, 4, 6, 5
    .byte 5, 5, 5, 4, 4, 3, 6, 4, 4, 6, 4, 5, 5, 5, 6
    .byte 3, 2, 5, 6, 5
    .byte 5, 4, 5, 5, 3, 5, 3, 5, 3, 5, 4, 5, 5, 6, 6
    .byte 5, 6, 4, 4, 6, 5, 6, 6, 3, 4, 5, 4, 3, 6, 6
    .byte 5, 5, 6, 5, 5, 4, 5, 3, 5, 4, 4, 5, 6, 6, 6
    .byte 4, 4, 5, 6, 5, 6, 6, 5, 4, 6, 4, 5, 6, 6, 4
    .byte 5, 6, 4, 5, 6, 5, 7, 5, 5, 5, 6, 6, 4, 5, 5
    .byte 6, 5, 5, 6, 5, 5, 4, 3, 5, 5, 5, 5, 6, 5, 5
    .byte 4, 5, 5, 5, 5, 4, 5, 4, 4, 4, 5, 4, 5, 6, 3
    .byte 6, 5, 4, 5, 6, 5, 6, 5, 4, 4, 6, 6, 6, 6, 4
    .byte 4, 4, 4, 4, 5, 5, 7, 5, 5, 5, 6, 4, 6, 3, 5
    .byte 2, 6, 6, 6, 5, 4, 6, 3, 5, 5, 5, 6, 6, 5, 6
    .byte 5, 3, 5, 5, 6, 5, 4, 6, 6, 6, 4, 4, 6, 4, 4
    .byte 4, 5, 5, 5, 6, 4, 5, 5, 5, 4, 6, 4, 6, 4, 5
    .byte 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 5, 4, 5, 6, 5
    .byte 4, 6, 6, 6, 4, 5, 3, 5, 6, 5, 5, 5, 5, 6, 5
    .byte 6, 4, 4, 5, 4, 6, 5, 5, 4, 6, 6, 6, 4, 5, 5
    .byte 5, 6, 4, 3, 5, 4, 6, 4, 5, 6, 6, 6, 4, 5, 6
    .byte 5, 4, 6, 5, 4, 4, 5, 6, 4, 5, 5, 5, 4, 5, 6
    .byte 4, 4, 5, 5, 4, 4, 5, 5, 5, 5, 6, 5, 4, 5, 5
    .byte 5, 5, 6, 5, 4, 4, 6, 6, 4, 5, 6, 6, 4, 6, 6
    .byte 5, 5, 5, 7, 4, 6, 4, 5, 5, 5, 5, 5, 3, 5, 6
    .byte 6, 4, 5, 5, 6, 5, 6, 4, 4, 6, 4, 6, 5, 5, 4
    .byte 5, 6, 6, 4, 5, 4, 6, 5, 5, 4, 4, 5, 4, 5, 3
    .byte 5, 6, 5, 4, 3, 6, 4, 6, 4, 6, 6, 4, 5, 4, 5
    .byte 4, 6, 3, 6, 5, 2, 5, 7, 5, 5, 5, 5, 6, 4, 5
    .byte 6, 3, 5, 5, 3, 6, 5, 4, 4, 5, 5, 6, 4, 4, 7
    .byte 4, 3, 5, 5, 5, 4, 4, 5, 4, 5, 6, 4, 5, 6, 4
    .byte 5, 4, 3, 5, 5, 4, 4, 5, 4, 6, 5, 4, 5, 5, 5
    .byte 5, 6, 6, 4, 3, 4, 5, 4, 5, 4, 6, 5, 6, 3, 6
    .byte 6, 4, 6, 4, 6, 4, 4, 5, 6, 5, 3, 4, 5, 6, 4
    .byte 4, 5, 5, 5, 4, 4, 5, 6, 5, 4, 6, 5, 5, 3, 5
    .byte 5, 5, 4, 4, 6, 5, 5, 5, 5, 5, 4, 4, 5, 6, 6
    .byte 4, 3, 6, 5, 4, 5, 5, 5, 6, 4, 5, 4, 4, 5, 4
    .byte 6, 5, 5, 4, 5, 5, 4, 5, 6, 5, 5, 5, 4, 5, 4
    .byte 5, 5, 6, 6, 6, 6, 5, 4, 6, 5, 4, 5, 5, 4, 5
    .byte 5, 5, 5, 5, 4, 4, 4, 6, 5, 5, 4, 6, 4, 5, 4
    .byte 5, 6, 4, 5, 5, 6, 3, 5, 5, 5, 5, 4, 4, 5, 6
    .byte 5, 6, 5, 5, 4, 4, 5, 5, 5, 4, 5, 5, 5, 5, 4
    .byte 6, 6, 5, 5, 6, 4, 6, 4, 6, 5, 5, 5, 4, 5, 5
    .byte 5, 6, 6, 6, 5, 5, 4, 5, 5, 4, 5, 5, 7, 5, 4
    .byte 4, 6, 5, 6, 5, 6, 5, 6, 5, 6, 4, 3, 5, 4, 6
    .byte 4, 6, 4, 6, 5, 6, 4, 5, 4, 5, 4, 5, 5, 5, 6
    .byte 5, 5, 5, 3, 6, 6, 4, 4, 4, 5, 6, 5, 4, 6, 5
    .byte 6, 5, 6, 4, 5, 6, 5, 4, 5, 4, 5, 5, 5, 4, 3
    .byte 5, 4, 5, 6, 5, 6, 6, 5, 6, 4, 5, 4, 7, 5, 5
    .byte 3, 5, 5, 4, 4, 4, 5, 6, 6, 4, 4, 5, 4, 6, 5
    .byte 4, 5, 4, 6, 5, 5, 3, 4, 6, 5, 5, 5, 5, 5, 5
    .byte 5, 4, 4, 4, 4, 5, 5, 5, 4, 5, 6, 5, 4, 5, 4
    .byte 6, 5, 5, 3, 5, 4, 5, 4, 5, 5, 6, 6, 4, 6, 5
    .byte 5, 4, 5, 4, 5, 4, 5, 6, 5, 4, 5, 4, 5, 6, 5
    .byte 5, 4, 5, 6, 4, 3, 5, 6, 5, 5, 5, 5, 5, 5, 5
    .byte 4, 6, 6, 5, 4, 5, 5, 5, 4, 5, 5, 5, 5, 6, 6
    .byte 4, 4, 5, 6, 5, 6, 5, 5, 4, 5, 5, 6, 4, 6, 5
    .byte 7, 4, 4, 5, 6, 6, 5, 5, 5, 6, 4, 5, 6, 5, 5
    .byte 5, 5, 6, 4, 5, 5, 6, 6, 5, 4, 5, 4, 5, 5, 5
    .byte 5, 6, 6, 5, 4, 5, 4, 4, 5, 5, 5, 5, 5, 5, 4
    .byte 4, 4, 5, 6, 4, 4, 4, 6, 4, 5, 5, 5, 5, 3, 5
    .byte 4, 5, 3, 5, 5, 6, 5, 4, 5, 4, 6, 6, 4, 6, 6
    .byte 5, 3, 5, 6, 5, 5, 4, 5, 5, 5, 6, 5, 6, 6, 4
    .byte 5, 5, 4, 6, 5, 4, 5, 5, 4, 4, 5, 5, 6, 5, 5
    .byte 6, 5, 6, 5, 5, 5, 5, 4, 6, 6, 5, 5, 5, 5, 5
    .byte 4, 4, 6, 5, 4, 4, 5, 6, 5, 3, 5, 6, 5, 6, 5
    .byte 6, 6, 4, 6, 5, 5, 5, 5, 5, 4, 5, 5, 5, 5, 6
    .byte 5, 5, 4, 5, 5, 4, 6, 6, 6, 5, 5, 5, 5, 4, 5
    .byte 4, 6, 6, 5, 4, 6, 5, 4, 6, 6, 5, 4, 4, 5, 5
    .byte 6, 6, 6, 5, 6, 5, 4, 5, 6, 5, 5, 3, 6, 5, 2
    .byte 6, 5, 5, 5, 6, 6, 5, 5, 6, 6, 3, 5, 5, 3, 5
    .byte 5, 6, 5, 5, 4, 6, 5, 6, 6, 5, 5, 5, 5, 5, 6
    .byte 6, 6, 5, 4, 7, 5, 4, 6, 6, 5, 5, 4, 5, 6, 4
    .byte 5, 6, 5, 5, 4, 5, 5, 5, 4, 5, 6, 5, 5, 5, 5
    .byte 5, 4, 5, 5, 6
