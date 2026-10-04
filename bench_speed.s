# constants
.equ N_RV32_ISS, 5000            # 2,048,0000 loop for RV32_ISS
.equ N_RV32_5S,  100             # 40,9600 loop for RV32_5S

# variables
.data
a:    .word 1
b:    .word 2

# code
.text
main:
        lui  t0, N_RV32_5S     # real N = 4k * N
        la   a1, a              # pseudo: 2
        la   a2, b              # pseudo: 2
loop:
        lw   t1, 0(a1)
        lw   t2, 0(a2)
        sw   t1, 0(a2)
        sw   t2, 0(a1)
        addi t0, t0, -1
        bnez t0, loop

        li a7, 10               # exit
        ecall
