// ポインタを増加するだけのアロケータ実装
use core::alloc::GlobalAlloc;
use core::alloc::Layout;
use core::ptr::NonNull;
use linked_list_allocator::Heap;
use my_puts;
use print_decimal;

pub struct MyHeap {
    heap: Heap
}

impl MyHeap {

    pub const fn empty() -> MyHeap {
	MyHeap {
	    heap: Heap::empty()
	}
    }
    pub unsafe fn init(&mut self, start_addr: usize, size: usize) {
	self.heap.init(start_addr, size);
    }
    pub unsafe fn new(heap_bottom: usize, heap_size: usize) -> MyHeap {
	MyHeap{
	    heap: Heap::new(heap_bottom, heap_size)
	}
    }

    pub unsafe fn alloc(&mut self, layout: Layout) -> *mut u8 {
	self.heap.allocate_first_fit(layout)
	    .ok()
	    .map_or(0 as *mut u8, |allocation| allocation.as_ptr())
    }

    pub unsafe fn dealloc(&mut self, ptr: *mut u8, layout: Layout) {
	self.heap
	    .deallocate(NonNull::new_unchecked(ptr), layout);
    }

}

use spin;

pub struct LockedMyHeap {
    inner: spin::Mutex<MyHeap>,
}

impl LockedMyHeap {
    pub const fn new(inner: MyHeap) -> Self {
	LockedMyHeap {
	    inner: spin::Mutex::new(inner),
	}
    }

    pub const fn empty() -> Self {
	LockedMyHeap {
	    inner: spin::Mutex::new(MyHeap::empty()),
	}
    }
    pub fn init(& self, start_addr: usize, size: usize) {
	unsafe {
	    let mut bump = self.lock(); // get a mutable reference

	    bump.init(start_addr, size);
	}
    }

    pub fn lock(&self) -> spin::MutexGuard<MyHeap> {
	self.inner.lock()
    }
}

unsafe impl GlobalAlloc for LockedMyHeap {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
	my_puts("alloc\n");
	let mut heap = self.lock(); // get a mutable reference
	let r = heap.alloc(layout);
	print_decimal(r as u64);
	my_puts("\ndone\n");
	r
    }

    unsafe fn dealloc(&self, _ptr: *mut u8, _layout: Layout) {
	my_puts("dealloc\n");
	let mut heap = self.lock(); // get a mutable reference
	heap.dealloc(_ptr, _layout);
	my_puts("\ndone\n");
    }
}
