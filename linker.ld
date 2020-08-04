OUTPUT_FORMAT("elf32-littleriscv");
OUTPUT_ARCH("riscv")

ENTRY(_start);
MEMORY {
/*  ROM : ORIGIN = 0x08000, LENGTH = 32k*/
  ROM : ORIGIN = 0x00000, LENGTH = 64k
  RAM : ORIGIN = 0x10000, LENGTH = 32k
}

SECTIONS
{
  .init : { KEEP(*(.init)) } >ROM
  .text : { *(.text) } > ROM
  .rodata : { *(.rodata) } > RAM
  .data : { *(.data) } > RAM
  . = ALIGN(4);
  __bss_start = .;
  .bss : {*(.bss)} > RAM
  __bss_end = . ;
}
