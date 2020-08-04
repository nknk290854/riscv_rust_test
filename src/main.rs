#![no_main]
#![no_std]

#[link(name="foo", kind="static")]
extern {
    fn notmain();
    fn uart_put(c: u8);
    fn delay(t : u32);
    fn digital_write(pin : u32, vol: u32);
}

#[no_mangle]
pub extern "C" fn __start_rust() -> ! {
    loop{
	hello_main();
	unsafe{
		delay(1000);
		digital_write(0, 0);
                digital_write(1, 1);
	};
	hello_main();
	unsafe{
		delay(1000);
        	digital_write(0, 1);
		        digital_write(1, 0);
			}
    }
}

pub fn putc(c : u8) {
    unsafe {
        uart_put(c);
    }
}

pub fn hello_main() {
    for c in b"Hello from Rust!\n".iter() {
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
