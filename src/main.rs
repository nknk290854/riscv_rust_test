#![no_main]
#![no_std]
#![feature(alloc_error_handler)]
extern crate alloc;
use linked_list_allocator;
use alloc::prelude::v1::Vec;
#[link(name="foo", kind="static")]
extern {
    fn notmain();
    fn uart_put(c: u8);
}

fn print_vec( v : &Vec<u64>){
    for i in v {
	print_decimal(*i);
	my_puts("\n");
    }
}

#[no_mangle]
pub extern "C" fn __start_rust() -> ! {
 
    unsafe { notmain();};
    hello_main();

    let HEAP_START : usize = 0x80001000;
    let HEAP_SIZE  : usize = 0x1000;
    unsafe {
	HEAP_ALLOCATOR.lock().init(HEAP_START, HEAP_START + HEAP_SIZE);
    }
    
    my_puts("Memofy test\n");
    let mut vec: Vec<u64> = Vec::new();
    for i in 0..10 {
	vec.push(i);
	print_vec(&vec);
    }
    
    loop{}
}

pub fn putc(c : u8) {
    unsafe {
        uart_put(c);
    }
}

pub fn print_decimal(mut h: u64) {
    let mut num = [0; 32];

    if h == 0 {
	putc('0' as u8);
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
	putc(num[i - 1] as u8);
	i -= 1;
    }
}

pub fn my_puts(s : &str) {
    for c in s.bytes() {
	putc(c as u8);
	if c == '\n' as u8 {
	    putc('\r' as u8);
	}
    }
}

pub fn hello_main() {
    my_puts("Hello rust world\n");
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

use linked_list_allocator::LockedHeap;

#[global_allocator]
static ALLOCATOR: LockedHeap = LockedHeap::empty();

pub fn init_heap() {
    let heap_start = 0x80001000;
    let heap_end   = 0x80002000;
    let heap_size = heap_end - heap_start;
    unsafe {
	ALLOCATOR.lock().init(heap_start, heap_size);
    }
}
