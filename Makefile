GCC_HEAD=riscv32-unknown-elf
OBJDUMP=${GCC_HEAD}-objdump
OBJCOPY=${GCC_HEAD}-objcopy
BSP=riscv32i-unknown-none-elf
#BSP=riscv32imac-unknown-none-elf
#OUT=release
OUT=release
relase=--release
TARGET=target/${BSP}/${OUT}/hello
#MACHINE=sifive_e
MACHINE=sifive_x
QEMU=/opt/my_qemu/bin/qemu-system-riscv32
TOOLS_ROOT = ../tools
TARGET_DIR = ../hex
#HEX_CONVERTER = python3 $(TOOLS_ROOT)/hex_converter.py
HEX_CONVERTER = perl $(TOOLS_ROOT)/split.pl

all: build lst


build: ${TARGET}

${TARGET}:
	env CC=${GCC_HEAD}-gcc cargo build  --verbose --target=${BSP}  ${relase}

app.bin code.bin data.bin app.srec app.dump: ${TARGET}
	$(OBJDUMP) -D $< >app.dump
	$(OBJCOPY) -g -S --srec-forceS3 -O srec $< app.srec
	$(OBJCOPY) -j .init -j .text -g -S --srec-forceS3 -O srec $< code.srec
	$(OBJCOPY) -j .rodata -j .eth_frame -j .data -g -S --srec-forceS3 -O srec $< data.srec
	$(OBJCOPY) -j .init -j .text -g -S -O binary $< code.bin
	$(OBJCOPY) -j .rodata -j .eth_frame -j .data -g -S -O binary $< data.bin

code.hex data.hex: app.srec
	${HEX_CONVERTER} <app.srec code.hex data >hex.log


deploy: code.hex data.hex
	cp  *.hex ${TARGET_DIR}


lst:
	${OBJCOPY} -g ${TARGET} hello.img
	${OBJDUMP} -D hello.img >aaa.lst

qemu:
	${QEMU} -nographic -machine ${MACHINE} -kernel ${TARGET}
# -bios /opt/qemu-riscv/share/qemu/opensbi-riscv32-sifive_u-fw_jump.bin
qemu2:
	${QEMU} -nographic -machine ${MACHINE} -kernel ${TARGET} -S -s

gdb:
	$(GCC_HEAD)-gdb ${TARGET}

clean:
	cargo clean
	rm -f *.hex *.dump *.lst *.img *.bin *.srec

add_target:
	rustup target add   ${BSP}
