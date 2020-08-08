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
    . = ALIGN( 0x10 );
    .text :
    {
        *(.text. text.*);
	*(.comment);
    } >rom
    . = ALIGN( 0x10 );
    /* rodata: Read-only data */
    .rodata :
    {
        *(.rdata .rodata. rodata.*);
    } >rom
    . = ALIGN( 0x10 );
    .eh_frame :
    {
        *(.eh_frame .eh_frame.*);
    } >rom
    . = ALIGN( 0x10 );
    /* data: Writable data */
    .data :
    {
        *(.data .data.* .sdata);
    } >ram
   . = ALIGN( 0x10 );
    _bss_start = .;
    .bss :
    {
        *(.bss .bss.*);
    } >ram
    _bss_end = .;
   . = ALIGN( 0x10 );
    _heap_start = .;
    .stack : {
    	    _stack_start = .;
	    . += 0x1000;
    	    _stack_end = .;
    } >stack
}
