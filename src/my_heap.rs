// ポインタを増加するだけのアロケータ実装
use core::ptr;
use core::cell::UnsafeCell;
use core::alloc::GlobalAlloc;
use core::alloc::Layout;

// Bump pointer allocator for *single* core systems
struct BumpPointerAlloc {
    head: UnsafeCell<usize>,
    end: usize,
}

unsafe impl Sync for BumpPointerAlloc {}

unsafe impl GlobalAlloc for BumpPointerAlloc {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
	    let head = self.head.get();
	    let size = layout.size();
	    let align = layout.align();
	    let align_mask = !(align - 1);

	    // move start up to the next alignment boundary
	    let start = (*head + align - 1) & align_mask;

	    if start + size > self.end {
		// a null pointer signal an Out Of Memory condition
		ptr::null_mut()
	    } else {
		*head = start + size;
		start as *mut u8
	    }
    }

    unsafe fn dealloc(&self, _: *mut u8, _: Layout) {
	// this allocator never deallocates memory
    }
}

// Declaration of the global memory allocator
// NOTE the user must ensure that the memory region `[0x2000_0100, 0x2000_0200]`
// is not used by other parts of the program
#[global_allocator]
static HEAP: BumpPointerAlloc = BumpPointerAlloc {
    head: UnsafeCell::new(0x80001000),
    end: 0x80003000
};

#[alloc_error_handler]
fn on_oom(_layout: Layout) -> ! {
    loop {}
}
