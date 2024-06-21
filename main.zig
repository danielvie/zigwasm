const std = @import("std");
const allocator = std.heap.wasm_allocator;

// We export the following functions to JS land.

/// Add a to b, wrapping on overflow.
pub export fn add(a: i32, b: i32) i32 {
    return a +% b;
}

/// Subtract b from a, wrapping on overflow.
pub export fn sub(a: i32, b: i32) i32 {
    return a -% b;
}

/// Allocate `len` bytes in WASM memory. Returns
/// many item pointer on success, null on error.
pub export fn alloc(len: usize) ?[*]u8 {
    return if (allocator.alloc(u8, len)) |slice|
        slice.ptr
    else |_|
        null;
}

/// Free `len` bytes in WASM memory pointed to by `ptr`.
pub export fn free(ptr: [*]u8, len: usize) void {
    allocator.free(ptr[0..len]);
}

/// Called from JS but turns around and calls back to JS
/// in order to log to the JS console.
pub export fn zlog(ptr: [*]const u8, len: usize) void {
    jsLog(ptr, len);
}

// We import this function from JS land.

/// Log to the JS console.
extern "env" fn jsLog(ptr: [*]const u8, len: usize) void;

// adding stuff
export fn fibonacci(n: u32) u32 {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

export fn fib(n: u32) u32 {
    return fibonacci(n);
}

export fn writeArray(array: [*]i32, tam: u32) void {
    for (0..tam) |i| {
        array[i] = @intCast(fib(i));
    }
}

pub fn main() void {}
