#![no_main]
#![no_std]
#![feature(alloc_error_handler)]

extern crate blisp;
extern crate linked_list_allocator;
use linked_list_allocator::LockedHeap;

//use blisp;
use blisp::LispErr;

extern crate alloc;
use alloc::prelude::v1::Vec;
use alloc::string::String;
use alloc::vec;

//mod my_heap;
    
#[link(name="foo", kind="static")]
extern {
    fn notmain();
    fn uart_put(c: u8);
    fn uart_get() ->u32;
}

fn send(c : u32){
    unsafe {
	uart_put(c as u8);
    }
}

fn recv() ->u32{
    let c;
    unsafe {
	c = uart_get();
	uart_put(c as u8);
    }
    return c;
}

fn read_line() -> String{

    let mut v: Vec<u8>  = Vec::new();

    let mut c = recv();
    while c!= 13  {
	if c == 127 {
	    v.pop();
	}else{
	    v.push(c as u8);
	}
	c = recv();
    }
    
    let line = String::from_utf8(v).unwrap();
    line
}

pub fn my_puts(s : &str) {
    for c in s.bytes() {
	send(c as u32);
	if c == '\n' as u8 {
	    send('\r' as u32);
	}
    }
}

pub fn my_puts_string(s : &String) {
    for c in s.bytes() {
	send(c as u32);
	if c == '\n' as u8 {
	    send('\r' as u32);
	}
    }
}

pub fn print_decimal(mut h: u64) {
    let mut num = [0; 32];

    if h == 0 {
	send('0' as u32);
	return;
    }

    let mut i = 0;
    while h > 0 {
	let n = h % 10;
	h /= 10;
	num[i] = n + 0x30;
	i += 1;
    }
    while i > 0 {
	send(num[i - 1] as u32);
	i -= 1;
    }
}

fn print_err (e: LispErr) {
    my_puts("error:");
    print_decimal((e.pos.line + 1) as u64);
    my_puts(":");
    print_decimal((e.pos.column + 1) as u64);
    my_puts(":'");
    let msg = e.msg.as_str();
    my_puts(&msg);
    my_puts("'\n");
}

fn run_lisp(code: &String) {
    // initialize
    match blisp::init(&code) {
	Ok(exprs) => {
	    // typing
	    match blisp::typing(&exprs) {
		Ok(ctx) => {
		    my_puts("init code");
		    my_puts(&code);
		    my_puts("\n");
		    run_repl(code, &ctx);
		}
		Err(e) => {
		    print_err(e);
		}
	    }
	}
	Err(e) => {
	    print_err(e);
	}
    }
}

fn run_repl(code: &String, ctx: &blisp::semantics::Context) {
    my_puts("CTRL-D to exit\n");
    loop {
	my_puts(">>");
	let line = read_line();
	my_puts("'");
	my_puts(&line);
	my_puts("'\n");
	let result = blisp::eval(&line, ctx);
	match result {
	    Ok(rs) => {
		for r in &rs {
		    my_puts("input:\n");
		    my_puts(&line);
		    my_puts("\nresult:\n");
		    my_puts(&r);
		    my_puts("\n");
		}
	    }
	    Err(e) => {
		print_err(e);
	    }
	}
    }
}
#[no_mangle]
pub extern "C" fn __start_rust() -> ! {
    unsafe { notmain();};
    hello_main();
    init_heap();
    let init = String::from("");
    run_lisp(&init);
    
    loop{}
}

pub fn hello_main() {
    my_puts("Hello rust world\n");
}

#[global_allocator]
static ALLOCATOR: LockedHeap = LoockedHeap::empty();

pub fn init_heap() {
    let heap_start = 0x80001000;
    let heap_end =   0x80003000;
    let heap_size = heap_end - heap_start;
    unsafe {
	ALLOCATOR.init(heap_start, heap_size);
    }
}

use core::panic::PanicInfo;
#[panic_handler]
#[no_mangle]
pub fn panic(_info: &PanicInfo) -> ! {
        unsafe { notmain();};
    loop{}
}

#[no_mangle]
pub extern "C" fn abort() -> ! {
    loop{}
}

use core::alloc::Layout;

#[alloc_error_handler]
fn on_oom(_layout: Layout) -> ! {
    loop {}
}
