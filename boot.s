.section .init
.global _start
.global abort
_start:
    /* Set up stack pointer. */
    lui     sp, %hi(stacks + 0x3FF0)
    ori     sp, sp, %lo(stacks + 0x3FF0)	
/*    lui     sp, %hi(stacks + 1024)
   ori     sp, sp, %lo(stacks + 1024)	
   lui x2,0x80004
	*/
    lui x2,0x80004
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

.bss
stacks:
    .skip 0x3000
