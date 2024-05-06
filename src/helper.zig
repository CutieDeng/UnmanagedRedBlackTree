const std = @import("std"); 
const assert = std.debug.assert; 

pub fn peek(self: anytype, node: anytype, indent: usize ) void {
    if (node.red) {
        std.log.info("\x1b[31;1m", .{}); 
    }
    for (0..indent) |_| {
        std.log.info("-   ", .{});
    }
    std.log.info("val: {}", .{ node.key }); 
    std.log.info("\x1b[0m\n", .{});
    if (node.children[0]) |c| {
        self.peek(c, indent + 1);
    } 
    if (node.children[1]) |c| {
        self.peek(c, indent + 1);
    }
}

pub fn check(node: anytype) void {
    for (node.children) |c| {
        if (c) |c2| {
            assert(c2 != node); 
            assert(c2.parent == node); 
        }
    }
}