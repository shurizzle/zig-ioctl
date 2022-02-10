const builtin = @import("builtin");
const syscall = @import("syscall");

const impl = switch (builtin.target.os.tag) {
    .linux => @import("./linux.zig"),
    .macos => @import("./apple.zig"),
    else => @compileError("OS not supported"),
};

pub usingnamespace impl;

/// Shorthand for ioctl(void, fd, cmd, {})
pub inline fn ioctl0(fd: usize, cmd: impl.CMD) usize {
    return syscall.syscall2(syscall.SYS.ioctl, fd, @enumToInt(cmd));
}

inline fn _cast(comptime T: type, arg: T) usize {
    if (@sizeOf(T) == 0) {
        @compileError("Invalid zero bit type");
    }

    switch (@typeInfo(T)) {
      .Pointer => {
          // TODO: check if child type is packed?
          return @ptrToInt(arg);
      },
      .Int => {
        if (@sizeOf(T) == @sizeOf(usize)) {
          return @bitCast(usize, arg);
        } else if (@sizeOf(T) < @sizeOf(usize)) {
          return @as(usize, arg);
        } else {
          @compileError("Invalid integer");
        }
      },
      else => @compileError("Invalid type"),
    }
}

pub inline fn ioctl(comptime T: type, fd: usize, cmd: impl.CMD, arg: T) usize {
    if (T == void) {
      return ioctl0(fd, cmd);
    }
    return syscall.syscall3(syscall.SYS.ioctl, fd, @enumToInt(cmd), _cast(T, arg));
}
