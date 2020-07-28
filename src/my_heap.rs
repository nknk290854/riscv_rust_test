// ポインタを増加するだけのアロケータ実装
use core::ptr;
use core::cell::UnsafeCell;
use core::alloc::GlobalAlloc;
use core::alloc::Layout;

extern crate linked_list_allocator;
#[global_allocator]
static HEAP_ALLOCATOR: LockedHeap = LockedHeap::empty();
