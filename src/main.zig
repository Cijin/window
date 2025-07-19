const std = @import("std");
const stdout = std.io.getStdOut().writer();

const clear_and_reset = "\x1B[2J\x1B[H";
const toggle_cursor = "\x1B[?25l";
const spinee = [_][]const u8{
    "⠋",
    "⠙",
    "⠹",
    "⠸",
    "⠼",
    "⠴",
    "⠦",
    "⠧",
    "⠇",
    "⠏",
};
const w = 60;
const h = 20;
const sleep_time = 100 * 1_000_000;

pub fn main() !void {
    try stdout.print(toggle_cursor, .{});

    var idx: u64 = 0;
    while (idx >= 0 and idx <= spinee.len) : (idx += 1) {
        try stdout.print(clear_and_reset, .{});
        try stdout.print("{s}", .{spinee[idx]});

        if (idx + 1 >= spinee.len) {
            idx = (idx + 1) % spinee.len;
        }

        std.time.sleep(sleep_time);
    }
}
