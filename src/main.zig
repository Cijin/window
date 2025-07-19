const std = @import("std");
const stdout = std.io.getStdOut().writer();

const clear_and_reset = "\x1B[2J\x1B[H";
const toggle_cursor = "\x1B[?25l";
const w = 60;
const h = 20;
const sleep_time = 100 * 1_000_000;

pub fn main() !void {
    var x: i32 = 0;
    var dx: i32 = 1;
    var y: i32 = 0;
    var dy: i32 = 1;

    try stdout.print(toggle_cursor, .{});

    while (true) {
        try stdout.print(clear_and_reset, .{});

        var row: i32 = 0;
        while (row < h) : (row += 1) {
            var col: i32 = 0;
            while (col < w) : (col += 1) {
                if (row == y and col == x) {
                    try stdout.print("0", .{});
                    continue;
                }

                try stdout.print(" ", .{});
            }
            try stdout.print("\n", .{});
        }

        x += dx;
        y += dy;

        if (x >= w - 1 or x <= 0) {
            dx = -dx;
        }

        if (y >= h - 1 or y <= 0) {
            dy = -dy;
        }

        std.time.sleep(sleep_time);
    }
}
