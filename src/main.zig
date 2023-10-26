const std = @import("std");
const testing = std.testing;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}

const rbt = @import("rbt.zig"); 

pub usingnamespace rbt; 

pub const I64Tree = rbt.RedBlackTree(i64, std.math.order); 

pub fn display(t: I64Tree) void {
    var root = t.root;  
    if (root) |r| {
        display_node(r); 
    } else {
        std.debug.print("empty", .{}); 
    } 
    std.debug.print("\n", .{});
}

pub fn display_node(n: anytype) void {
    I64Tree.check(n); 
    if (n.children[0]) |l| {
        I64Tree.check(l); 
        display_node(l); 
    } 
    std.debug.print("{} ", .{n.key}); 
    if (n.children[1]) |r| {
        I64Tree.check(r); 
        display_node(r); 
    } 
    return ; 
}

pub fn calculate_height(n: anytype) usize {
    var maximize : usize = 0; 
    inline for (n.children) |d| {
        if (d) |d2| {
            var h = calculate_height(d2); 
            if (h > maximize) {
                maximize = h;  
            }
        }
    }
    return maximize + 1; 
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){}; 
    const alloca = gpa.allocator(); 
    var t: I64Tree = .{}; 
    var list = std.ArrayList(*I64Tree.Node).init(alloca);
    defer list.deinit();  
    defer {
        for (list.items) |i| {
            alloca.destroy(i); 
        }
    }
    var stdin = std.io.getStdIn();
    var reader = stdin.reader();
    _ = reader;
    var buffer : []u8 = try alloca.alloc(u8, 1024); 
    var rand = std.rand.DefaultPrng.init(3);
    _ = rand; 
    defer alloca.free(buffer);   
    var index : i64 = 0; 
    while (true) {
        var val: i64 = index; 
        index += 1; 
        // val = @bitCast(rand.next()); 
        var entry = t.getEntryFor(val); 
        if (entry.node != null) {
            std.debug.print("Already existed. \n", .{}); 
            continue ; 
        } 
        const node = try alloca.create(I64Tree.Node); 
        errdefer alloca.destroy(node); 
        try list.append(node); 
        entry.set(node); 
        if (list.items.len > 20) {
            break; 
        }
    } 
    t.peek(t.root.?, 0);
    const h = calculate_height(t.root.?); 
    std.debug.print("height: {}\n", .{h}); 
    index = 10; 
    while (true) {
        var val: i64 = index; 
        index += 1; 
        // val = t.getMax().?.key; 
        var entry = t.getEntryFor(val); 
        if (t.root == null) break; 
        t.peek(t.root.?, 0); 
        if (entry.node == null) break; 
        entry.set(null); 
        // t.peek(t.root.?, 0);
        // std.debug.print("\n", .{});
        display(t); 
    }
    std.debug.print("End \n", .{});
}

pub fn _main2() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){}; 
    const alloca = gpa.allocator(); 
    var t: I64Tree = .{}; 
    var list = std.ArrayList(*I64Tree.Node).init(alloca);
    defer list.deinit();  
    defer {
        for (list.items) |i| {
            alloca.destroy(i); 
        }
    }
    var stdin = std.io.getStdIn();
    var reader = stdin.reader();
    _ = reader;
    var buffer : []u8 = try alloca.alloc(u8, 1024); 
    var rand = std.rand.DefaultPrng.init(23);
    _ = rand; 
    defer alloca.free(buffer);   
    var index : i64 = 0; 
    while (true) {
        var val: i64 = index; 
        index += 1; 
        // val = @bitCast(rand.next()); 
        var entry = t.getEntryFor(val); 
        if (entry.node != null) {
            std.debug.print("Already existed. \n", .{}); 
            continue ; 
        } 
        const node = try alloca.create(I64Tree.Node); 
        errdefer alloca.destroy(node); 
        try list.append(node); 
        entry.set(node); 
        // std.debug.print("insert successfully\n", .{});
        if (list.items.len > 1000000) {
            break; 
        }
    } 
    display(t); 
    const h = calculate_height(t.root.?); 
    std.debug.print("height: {}\n", .{h}); 
    index = 10; 
    while (true) {
        var val: i64 = index; 
        index += 1; 
        std.debug.print("Attempt to rm {}\n", .{ val }); 
        var entry = t.getEntryFor(val); 
        entry.set(null); 
    }
    std.debug.print("Attempt to remove all! \n", .{} );
    display(t); 
}