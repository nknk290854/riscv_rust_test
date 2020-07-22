ENTRY(_start);
EXTERN(abort);
MEMORY
{

    rom : ORIGIN = 0x20400000, LENGTH = 0x4000
    ram : ORIGIN = 0x80000000, LENGTH = 0x4000
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

    /* data: Writable data */
    .data :
    {
        *(.data .data.*);
    } >ram

    _bss_start = .;
    .bss :
    {
        *(.bss .bss.*);
    } >ram
}
