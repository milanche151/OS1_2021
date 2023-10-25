.extern handleSupervisorTrap
.align 4
.global supervisorTrap
.type supervisorTrap, @function
supervisorTrap:
    # push all registers to stack
    addi sp, sp, -256
    .irp index, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index, \index * 8(sp)
    .endr
    addi sp, sp, -32
    sd a0, 0*8(sp)
    sd a1, 1*8(sp)
    sd a2, 2*8(sp)
    sd a3, 3*8(sp)
    mv a0,sp
    call handleSupervisorTrap



    addi sp, sp, 32
    # pop all registers from stack
    .irp index, 0,1,2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\index, \index * 8(sp)
    .endr
    addi sp, sp, 256

    sret
