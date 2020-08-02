GCC_HEAD=riscv32-unknown-elf
OBJDUMP=${GCC_HEAD}-objdump
OBJCOPY=${GCC_HEAD}-objcopy
#BSP=riscv32i-unknown-none-elf
BSP=riscv32i-unknown-none-elf
MODE=release
TARGET=target/${BSP}/${MODE}/hello
#MACHINE=sifive_e
MACHINE=sifive_x
QEMU=/opt/my_qemu/bin/qemu-system-riscv32

all: build lst


build:
	env CC=${GCC_HEAD}-gcc cargo build  --verbose --target=${BSP}  --release

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

add_target:
	rustup target add   ${BSP}
