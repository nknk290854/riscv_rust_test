.option norvc
.section .boot, "ax",@progbits
.global _start
.global abort
_start:
	/* Set up stack pointer. */

        li t0,0x20000000
	li sp,0
	li sp,0x80010000
	/*
    lui     sp, %hi(stacks + 0xFF00)
    ori     sp, sp, %lo(stacks + 0xFF00)
  lui     sp, %hi(stacks + 1024)
   ori     sp, sp, %lo(stacks + 1024)	
   lui x2,0x80004
   lui x2,0x80004
	*/

    /* Now jump to the rust world; __start_rust.  */
    j       __start_rust


.globl dummy
dummy:
    ret

.globl PUT32
PUT32:
    sw x11,(x10)
    ret

.globl GET32
GET32:
    lw x10,(x10)
    ret

.globl MCYCLE
MCYCLE:
    csrr x10,mcycle
    ret

.section .stack
stacks:
	
