const builtin = @import("builtin");
const syscall = @import("syscall");
const std = @import("std");

const impl = switch (builtin.target.os.tag) {
    .linux => @import("./linux.zig"),
    .macos => @import("./apple.zig"),
    else => @compileError("OS not supported"),
};

pub usingnamespace impl;

/// Shorthand for ioctl(fd, cmd, {})
pub inline fn ioctl0(fd: usize, cmd: impl.CMD) usize {
    return syscall.syscall(syscall.SYS.ioctl, .{ fd, @enumToInt(cmd) });
}

inline fn _cast(arg: anytype) usize {
    const T = @TypeOf(arg);

    return switch (@typeInfo(T)) {
        .Pointer => |typ| if (switch (@typeInfo(typ.child)) {
            .Int, .ComptimeInt => true,
            .Struct => |s| s.layout == .Packed,
            .Union => |u| u.layout == .Packed,
            .Enum => |e| e.layout == .Packed,
            else => false,
        })
            @ptrToInt(arg)
        else
            @compileError("Argument must me a pointer to an integer or a packed struct"),
        .Int => if (@sizeOf(T) == @sizeOf(usize))
            @bitCast(usize, arg)
        else if (@sizeOf(T) < @sizeOf(usize))
            @as(usize, arg)
        else
            @compileError("Invalid integer"),
        else => @compileError("Invalid type"),
    };
}

pub inline fn ioctl(fd: usize, cmd: impl.CMD, arg: anytype) usize {
    const T = @TypeOf(arg);

    return if (@sizeOf(T) == 0)
        syscall.syscall(syscall.SYS.ioctl, .{ fd, @enumToInt(cmd) })
    else
        syscall.syscall(syscall.SYS.ioctl, .{ fd, @enumToInt(cmd), _cast(arg) });
}
