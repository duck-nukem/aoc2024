const std = @import("std");
const input = @embedFile("day_01.txt");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var left = std.ArrayList(i32).init(allocator);
    var right = std.ArrayList(i32).init(allocator);

    defer left.deinit();
    defer right.deinit();

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    while (it.next()) |token| {
        var parts = std.mem.split(u8, token, " ");

        var index: usize=0;
        while (parts.next()) |part| {
            if (part.len == 0) {
                continue;
            }

            const value = try std.fmt.parseInt(i32, part, 10);

            if (index == 0) {
                try left.append(value);
            } else {
                try right.append(value);
            }

            index +=1;
        }
    }

    std.mem.sort(i32, left.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, right.items, {}, comptime std.sort.asc(i32));

    var total: u32 = 0;
    for (left.items, right.items) |leftItem, rightItem| {
        std.debug.print("{d} {d} {d}\n", .{leftItem, rightItem, @abs(leftItem - rightItem)});
        total += @abs(leftItem - rightItem);
    }
    std.debug.print("Solution: {d}\n", .{total});
}
