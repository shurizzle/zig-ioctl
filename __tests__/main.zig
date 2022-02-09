test "basic functionality" {
    const std = @import("std");
    const builtin = @import("builtin");
    const ioctl = @import("ioctl");

    const what = switch (builtin.target.os.tag) {
        .linux => ioctl.TCGETS,
        .macos => ioctl.TIOCGETA,
        else => unreachable,
    };

    var info: ioctl.termios = undefined;
    const res = ioctl.ioctl(ioctl.termios, 0, what, &info);
    try std.testing.expect(res == 0);
    std.debug.print("{}\n", .{info});
}
