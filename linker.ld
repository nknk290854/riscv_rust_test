ENTRY(_start);
EXTERN(abort);
MEMORY
{
/*

    ram :   ORIGIN = 0x80000000, LENGTH = 0x3000
    stack : ORIGIN = 0x80003000, LENGTH = 0x1000
*/
/*    rom :   ORIGIN = 0x20400000, LENGTH = 0x400000 */
    rom  :  ORIGIN = 0x20000000, LENGTH = 0x10000000
    ram :   ORIGIN = 0x80000000, LENGTH = 0x30000
    stack : ORIGIN = 0x80030000, LENGTH = 0x10000
}

SECTIONS
{
    /* text: Program code section */
    .init : { KEEP(*(.init)) } >rom
    .text :
    {
    	*(.boot);
        *(.text. text.*);
	*(.comment);
    } >rom

    /* rodata: Read-only data */
    .rodata :
    {
        *(.rdata .rodata. rodata.*);
    } >ram
    .eh_frame :
    {
        *(.eh_frame .eh_frame.*);
    } >ram

    /* data: Writable data */
    .data :
    {
        *(.data .data.* .sdata);
    } >ram
    _bss_start = .;
    .bss :
    {
        *(.bss .bss.*);
    } >ram
    _bss_end = .;
    _heap_start = .;
    .stack : {
    	    _stack_start = .;
	    . += 0x1000;
    	    _stack_end = .;
    } >stack
}
