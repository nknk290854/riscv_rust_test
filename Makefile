GCC_HEAD=riscv32-unknown-elf
OBJDUMP=${GCC_HEAD}-objdump
OBJCOPY=${GCC_HEAD}-objcopy

PROJECT_ROOT = poyov
TOOLS_ROOT = $(PROJECT_ROOT)/software/software_tools
HEX_CONVERTER = \
	python3 $(TOOLS_ROOT)/hex_converter.py
MEM_INIT = $(TOOLS_ROOT)/mem_init.hex

TARGET=target/riscv32i-unknown-none-elf/debug/hello
all: build lst


build:
	env CC=riscv32-unknown-elf-gcc cargo build --target riscv32i-unknown-none-elf

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
	rm -f *.hex *.img *.o c/*.o *.bin *.dump *.lst 


app.bin: ${TARGET}
	$(OBJDUMP) -D $< > app.dump
	$(OBJCOPY) -O binary $< $@

# バイナリファイルから.hex形式ファイルを生成
app.hex: app.bin
	hexdump -v -e '1/4 "%08x" "\n"' $< > app_im.hex
	cp app_im.hex app.hex
#	cat $(MEM_INIT) app_im.hex > $@
#	rm -f app_im.hex

# .hex形式ファイルを命令メモリ用ファイルとデータメモリ用ファイルへと分割
code.hex data.hex: app.hex
	$(HEX_CONVERTER) $<

deploy: code.hex data.hex
	cp *.hex ${PROJECT_ROOT}/software/rust
