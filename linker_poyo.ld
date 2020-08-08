ENTRY(_start)
EXTERN(abort);

_Min_heap_size  = 0x8000;
_Min_stack_size = 0x8000;

MEMORY
{
    rom   : ORIGIN = 0x00000000, LENGTH = 0x80000
    ram   : ORIGIN = 0x80000000, LENGTH = 0x10000
}

SECTIONS
{
    /* text: Program code section */
    .init : {
       KEEP(*(.init))
       *(.boot);

    } >rom
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
    } >ram
    . = ALIGN( 0x10 );
    .eh_frame :
    {
        *(.eh_frame .eh_frame.*);
    } >ram
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
    _heap_start = . ;
    . += _Min_heap_size;
    _heap_end = .;
    . = ALIGN( 0x10 );
    .riscv.attributes 0: { *(.riscv.attributes) }
}
