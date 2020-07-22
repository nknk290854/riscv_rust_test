#![no_main]
#![no_std]

#[link(name="foo", kind="static")]
extern {
    fn notmain();
    fn uart_put(c: u8);
}

#[no_mangle]
pub extern "C" fn __start_rust() -> ! {
    unsafe { notmain();};
    hello_main();
    loop{}
}

pub fn putc(c : u8) {
    unsafe {
        uart_put(c);
    }
}

pub fn hello_main() {
    for c in b"Hello from Rust!".iter() {
	putc(*c);
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
