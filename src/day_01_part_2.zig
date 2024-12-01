const std = @import("std");
const input = @embedFile("day_01.txt");

pub fn main() !void {
    // need a counter for the right: {3: Count(3), 2: Count(0)}
    const start = std.time.nanoTimestamp();
    var left = std.ArrayList(i32).init(std.heap.page_allocator);
    defer left.deinit();

    var right = std.AutoHashMap(i32, u8).init(std.heap.page_allocator,);
    defer right.deinit();

    var rows = std.mem.tokenizeScalar(u8, input, '\n');
    while (rows.next()) |row| {
        var parts = std.mem.split(u8, row, "   ");
        const leftDistance = try std.fmt.parseInt(i32, parts.next().?, 10);
        const rightValue = try std.fmt.parseInt(i32, parts.next().?, 10);

        try left.append(leftDistance);

        const count = right.get(rightValue) orelse 0;
        try right.put(rightValue, count + 1);
    }

    var total: i32 = 0;
    for (left.items) |leftValue| {
        const counter = right.get(leftValue) orelse 0;
        total += leftValue * counter;
    }

    const end = std.time.nanoTimestamp();
    const elapsedTimeMs = @divFloor(end - start, 1_000_000);
    std.debug.print("Solution: {d} (completed in: {d} ms)\n", .{ total, elapsedTimeMs }); // 1660292
}
