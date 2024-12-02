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
            const lowerThreshold = @intFromEnum(ReportSafeStepThreshold.Lower);
            const upperThreshold = @intFromEnum(ReportSafeStepThreshold.Upper);
            const isWithinBounds = lowerThreshold <= diff and diff <= upperThreshold;

            if (!isWithinBounds) {
                continue :outer; // if any point is invalid, the whole row becomes invalid and can be discarded
            }
        }

        if (try hasConsistentOrdering(i32, original.items)) {
            safeReportsCount += 1;
        }
    }

    std.debug.print("Safe reports in total: {}\n", .{safeReportsCount});
}

const Direction = enum(i8) { Descending = -1, Ascending = 1 };

fn computeDirection(a: i32, b: i32) Direction {
    return if (a - b > 0) Direction.Ascending else Direction.Descending;
}

/// returns false if the ordering direction is not the same throughout all the elements
fn hasConsistentOrdering(comptime T: type, slice: []const T) !bool {
    if (slice.len <= 2) {
        // any collection with 2 items or less can be deemed as ordered
        return true;
    }

    const initialDirection: Direction = computeDirection(slice[1], slice[0]);

    for (slice[1..], 0..) |current, i| {
        const previous = slice[i];
        const diff = current - previous;

        if (diff == 0) continue;

        const currentDirection: Direction = computeDirection(current, previous);

        if (initialDirection != currentDirection) {
            return false;
        }
    }

    return true;
}

const expect = std.testing.expect;

test "isSorted should return true for small collections" {
    const slice = [_]i32{ 1, 2 };

    const isOrdered = try hasConsistentOrdering(i32, &slice);

    try expect(isOrdered);
}

test "isSorted should return true for elements sorted ascending" {
    const slice = [_]i32{ 1, 2, 3 };

    const isOrdered = try hasConsistentOrdering(i32, &slice);

    try expect(isOrdered);
}

test "isSorted should return true for elements sorted descending" {
    const slice = [_]i32{ 3, 2, 1 };

    const isOrdered = try hasConsistentOrdering(i32, &slice);

    try expect(isOrdered);
}

test "isSorted should return false for unordered elements" {
    const slice = [_]i32{ 2, 1, 3 };

    const isOrdered = try hasConsistentOrdering(i32, &slice);

    try expect(!isOrdered);
}
