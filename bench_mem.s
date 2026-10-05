# constants
.equ N_BYTE_SMALL, 1                # 4KB
.equ N_BYTE_LARGE, 0x101            # 1MB + 4KB

# variables
.data
b:    .byte 2

# code
.text
main:
        lui  s0, N_BYTE_LARGE   # real N = 4k * N
        add  t0, s0, x0         # the i
        la   a1, b
        add  s1, a1, x0         # store origin address
        addi t1, x0, 1          # just a value to write
loop:
        sb   t1, 0(a1)
        addi a1, a1, 1
        addi t0, t0, -1
        bnez t0, loop
reset:
        add t0, s0, x0          # reset i
        add a1, s1, x0          # reset address
        j loop                  # loop forever
