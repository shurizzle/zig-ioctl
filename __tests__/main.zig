test "basic functionality" {
    const std = @import("std");
    const ioctl = @import("ioctl");

    var info: ioctl.termios = undefined;
    try std.testing.expect(ioctl.ioctl(ioctl.termios, 0, ioctl.TCGETS, &info) == 0);
    std.debug.print("{}\n", .{info});
}
