const std = @import("std");
const input = @embedFile("day_01.txt");

pub fn main() !void {
    const start = std.time.nanoTimestamp();
    var left = std.ArrayList(i32).init(std.heap.page_allocator);
    defer left.deinit();

    var right = std.ArrayList(i32).init(std.heap.page_allocator);
    defer right.deinit();

    var rows = std.mem.tokenizeScalar(u8, input, '\n');
    while (rows.next()) |row| {
        var parts = std.mem.split(u8, row, "   ");
        const leftDistance = try std.fmt.parseInt(i32, parts.next().?, 10);
        const rightDistance = try std.fmt.parseInt(i32, parts.next().?, 10);

        try left.append(leftDistance);
        try right.append(rightDistance);
    }

    std.mem.sort(i32, left.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, right.items, {}, comptime std.sort.asc(i32));

    var total: u32 = 0;
    for (left.items, right.items) |leftItem, rightItem| {
        total += @abs(leftItem - rightItem);
    }

    const end = std.time.nanoTimestamp();
    const elapsedTimeMs = @divFloor(end - start, 1_000_000);
    std.debug.print("Solution: {d} (completed in: {d} ms)\n", .{total, elapsedTimeMs}); // 1660292
}
