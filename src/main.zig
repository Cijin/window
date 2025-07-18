const std = @import("std");

// X11 C bindings
const c = @cImport({
    @cInclude("X11/Xlib.h");
});

pub fn createBlankWindow() !void {
    // Open connection to X server
    const display = c.XOpenDisplay(null);
    if (display == null) {
        std.log.err("Cannot open X display", .{});
        return error.CannotOpenDisplay;
    }
    defer _ = c.XCloseDisplay(display);

    const screen = c.XDefaultScreen(display);
    const root = c.XRootWindow(display, screen);

    // Create a simple window
    const window = c.XCreateSimpleWindow(display, root, 10, 10, // x, y position
        400, 300, // width, height
        1, // border width
        c.XBlackPixel(display, screen), // border color
        c.XWhitePixel(display, screen) // background color
    );

    // Set window title
    _ = c.XStoreName(display, window, "Blank Window");

    // Select input events we want to receive
    _ = c.XSelectInput(display, window, c.ExposureMask | c.KeyPressMask);

    // Make the window visible
    _ = c.XMapWindow(display, window);

    std.log.info("Blank window created! Press any key to close it.", .{});

    // Event loop
    var event: c.XEvent = undefined;
    while (true) {
        _ = c.XNextEvent(display, &event);

        switch (event.type) {
            c.Expose => {
                // Window needs to be redrawn (already blank)
            },
            c.KeyPress => {
                // Any key press closes the window
                break;
            },
            else => {},
        }
    }

    _ = c.XDestroyWindow(display, window);
}

pub fn main() !void {
    std.log.info("Creating a blank window...", .{});
    try createBlankWindow();
    std.log.info("Window closed.", .{});
}
