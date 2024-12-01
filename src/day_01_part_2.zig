const std = @import("std");
const input = @embedFile("day_01.txt");

pub fn main() !void {
    const start = std.time.nanoTimestamp();
    var occurrences = std.ArrayList(i32).init(std.heap.page_allocator);
    defer occurrences.deinit();

    var similarityCounter = std.AutoHashMap(i32, u8).init(
        std.heap.page_allocator,
    );
    defer similarityCounter.deinit();

    var rows = std.mem.tokenizeScalar(u8, input, '\n');
    while (rows.next()) |row| {
        var parts = std.mem.split(u8, row, "   ");
        const occurrence = try std.fmt.parseInt(i32, parts.next().?, 10);
        const similarityKey = try std.fmt.parseInt(i32, parts.next().?, 10);

        const count = similarityCounter.get(similarityKey) orelse 0;
        try similarityCounter.put(similarityKey, count + 1);
        try occurrences.append(occurrence);
    }

    var similarityScore: i32 = 0;
    for (occurrences.items) |occurrence| {
        const counter = similarityCounter.get(occurrence) orelse 0;
        similarityScore += occurrence * counter;
    }

    const end = std.time.nanoTimestamp();
    const elapsedTimeMs = @divFloor(end - start, 1_000_000);
    std.debug.print("Solution: {d} (completed in: {d} ms)\n", .{ similarityScore, elapsedTimeMs }); // 1660292
}
