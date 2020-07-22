GCC_HEAD=riscv32-unknown-linux-gnu
OBJDUMP=${GCC_HEAD}-objdump
OBJCOPY=${GCC_HEAD}-objcopy

TARGET=target/riscv32imac-unknown-none-elf/debug/hello
all: build lst


build:
	env CC=riscv32-unknown-linux-gnu-gcc cargo build

lst:
	${OBJCOPY} -g ${TARGET} hello.img
	${OBJDUMP} -D ${TARGET} >aaa.lst

qemu:
	qemu-system-riscv32 -nographic -machine sifive_e -kernel ${TARGET}

qemu2:
	qemu-system-riscv32 -nographic -machine sifive_e -kernel ${TARGET} -S -s

gdb:
	$(GCC_HEAD)-gdb ${TARGET}

clean:
	cargo clean
