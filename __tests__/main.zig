test "basic functionality" {
    const std = @import("std");
    const builtin = @import("builtin");
    const ioctllib = @import("ioctl");
    const ioctl = ioctllib.ioctl;
    const termios = ioctllib.termios;
    const CMD = ioctllib.CMD;

    const what: CMD = switch (builtin.target.os.tag) {
        .linux => .tcgets,
        .macos => .tiocgeta,
        else => unreachable,
    };

    var info: termios = undefined;
    const res = ioctl(*termios, 0, what, &info);
    try std.testing.expect(res == 0);
    std.debug.print("{}\n", .{info});
}
