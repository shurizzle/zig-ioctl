test "basic functionality" {
    const std = @import("std");
    const termios = @import("ioctl");

    var info: termios.termio = undefined;
    try std.testing.expect(termios.ioctl(termios.termio, 0, termios.TCGETS, &info) == 0);
    std.debug.print("{}\n", .{info});
}
