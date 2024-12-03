const std = @import("std");

fn isDigit(c: u8) bool {
    return c >= '0' and c <= '9';
}

fn parseInteger(slice: []u8, start: usize, end: usize) !i32 {
    var num: i32 = 0;

    for (slice[start..end]) |digit| {
        num = num * 10 + (digit - '0');
    }

    return num;
}

pub fn main() !void {
    const file = try std.fs.cwd().openFile("src/day_03.txt", .{});
    defer file.close();
    const file_size = try file.getEndPos();

    const allocator = std.heap.page_allocator;
    const buffer = try allocator.alloc(u8, @intCast(file_size));
    defer allocator.free(buffer);

    _ = try file.readAll(buffer);

    const pattern = "mul(";
    var i: usize = 0;

    var total: i32 = 0;
    while (i < buffer.len) : (i += 1) {
        // look ahead for "mul(" to find valid beginnings
        if (i + pattern.len < buffer.len and std.mem.eql(u8, buffer[i .. i + pattern.len], pattern)) {
            var current_offset = i + pattern.len;

            const first_num_start = current_offset;
            // keep consuming digits
            while (current_offset < buffer.len and isDigit(buffer[current_offset])) current_offset += 1;

            // separator "," between the two numbers to multiply
            if (current_offset >= buffer.len or buffer[current_offset] != ',') continue;

            const first_num = try parseInteger(buffer, first_num_start, current_offset);
            current_offset += 1;

            const second_num_start = current_offset;
            // keep consuming digits
            while (current_offset < buffer.len and isDigit(buffer[current_offset])) current_offset += 1;

            // find a valid ending; completing mul({d}, {d})
            if (current_offset >= buffer.len or buffer[current_offset] != ')') continue;

            const second_num = try parseInteger(buffer, second_num_start, current_offset);

            total += first_num * second_num;
        }
    }

    std.debug.print("Total: {d}", .{total});
}
