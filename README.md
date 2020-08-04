# riscv-rust-hello

Hello world program for RISC-V Rust.

How to run target binary.

```
$ env CC=riscv32-unknown-linux-gnu-gcc  cargo run
```

To build for poyo-v, C flag "-march=rv32i" is nessesary to generete 32bit code set.
"target.riscv32i-unknown-none-elf"
