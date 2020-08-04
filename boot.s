.section .init
.global _start
.global abort
_start:
    /* Set up stack pointer. */
	li sp, 0
	li sp, 0x20000
    /*lui x2,0x80004	 */
    /* Now jump to the rust world; __start_rust.  */
	j      __start_rust
