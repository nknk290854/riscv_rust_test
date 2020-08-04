EXTERN(abort);
MEMORY
{
    rom  :  ORIGIN = 0x20000000, LENGTH = 0x80000
    ram :   ORIGIN = 0x80000000, LENGTH = 0xC000
    stack : ORIGIN = 0x8000C000, LENGTH = 0x4000
}

SECTIONS
{
    /* text: Program code section */
    .init : {
       KEEP(*(.init))
       *(.boot);

    } >rom
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
	    . += 0x4000;
    	    _stack_end = .;
    } >stack
}
