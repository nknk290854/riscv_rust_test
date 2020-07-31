ENTRY(_start);
EXTERN(abort);
MEMORY
{
/*

    ram :   ORIGIN = 0x80000000, LENGTH = 0x3000
    stack : ORIGIN = 0x80003000, LENGTH = 0x1000
*/
/*    rom :   ORIGIN = 0x20400000, LENGTH = 0x400000 */
    rom :   ORIGIN = 0x000000,   LENGTH = 0x400000
    ram :   ORIGIN = 0x80000000, LENGTH = 0x002000
    stack : ORIGIN = 0x80002000, LENGTH = 0x002000
}

SECTIONS
{
    /* text: Program code section */
    .init : { KEEP(*(.init)) } >rom
    .text :
    {
        *(.text. text.*);
	*(.comment);
    } >rom

    /* rodata: Read-only data */
    .rodata :
    {
        *(.rdata .rodata. rodata.*);
    } >rom
    .eh_frame :
    {
        *(.eh_frame .eh_frame.*);
    } >rom

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
