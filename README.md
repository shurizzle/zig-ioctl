# zig-ioctl

Example:

```zig
const std = @import("std");
const builtin = @import("builtin");
const ioctllib = @import("ioctl");
const ioctl = ioctllib.ioctl;
const winsize = ioctllib.termios;
const CMD = ioctllib.CMD;

pub fn isatty(fd: i32) bool {
    var size: winsize = undefined;
    return ioctl(@bitCast(usize, @as(isize, fd)), .tiocgwinsz, &size) == 0;
}

std.debug.print("STDIN is", .{});
if (!isatty(std.io.getStdIn().handle)) {
    std.debug.print(" not", .{});
}
std.debug.print(" a tty\n", .{});
```
