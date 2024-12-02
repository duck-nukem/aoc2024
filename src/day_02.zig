const std = @import("std");
const input = @embedFile("day_02.txt");
const numbers = @import("numbers.zig");

const ReportSafeStepThreshold = enum(u8) { Lower = 1, Upper = 3 };

pub fn main() !void {
    var rows = std.mem.tokenizeScalar(u8, input, '\n');
    var safeReportsCount: usize = 0;

    outer: while (rows.next()) |row| {
        var parts = std.mem.split(u8, row, " ");
        var original = std.ArrayList(i32).init(std.heap.page_allocator);
        defer original.deinit();

        while (parts.next()) |part| {
            const current = try std.fmt.parseInt(i32, part, @intFromEnum(numbers.Base.Ten));
            const last = original.getLastOrNull();
            const isFirstElement = last == null;
            try original.append(current);

            if (isFirstElement) {
                // no previous value to compare it against
                continue;
            }

            const diff = @abs(current - last.?);
            if (diff < @intFromEnum(ReportSafeStepThreshold.Lower) or diff > @intFromEnum(ReportSafeStepThreshold.Upper)) {
                continue :outer;
            }
        }

        if (try isCollectionSorted(i32, original.items)) {
            safeReportsCount += 1;
        }
    }

    std.debug.print("Safe reports in total: {}\n", .{safeReportsCount});
}

/// clones the original data, then sorts it ascending first, descending second to check for equality
fn isCollectionSorted(comptime T: type, slice: []const T) !bool {
    var copy = std.ArrayList(i32).init(std.heap.page_allocator);
    defer copy.deinit();
    try copy.appendSlice(slice);

    std.mem.sort(i32, copy.items, {}, comptime std.sort.asc(i32));
    var isSorted = std.mem.eql(i32, slice, copy.items);

    if (!isSorted) {
        std.mem.sort(i32, copy.items, {}, comptime std.sort.desc(i32));
        isSorted = std.mem.eql(i32, slice, copy.items);
    }

    return isSorted;
}

const expect = std.testing.expect;

test "isSorted should return true for elements sorted ascending" {
    const slice = [_]i32{ 1, 2 };

    const isOrdered = try isCollectionSorted(i32, &slice);

    try expect(isOrdered);
}

test "isSorted should return true for elements sorted descending" {
    const slice = [_]i32{ 2, 1 };

    const isOrdered = try isCollectionSorted(i32, &slice);

    try expect(isOrdered);
}

test "isSorted should return false for unordered elements" {
    const slice = [_]i32{ 2, 1, 3 };

    const isOrdered = try isCollectionSorted(i32, &slice);

    try expect(!isOrdered);
}
