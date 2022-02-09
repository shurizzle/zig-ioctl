const builtin = @import("builtin");

pub usingnamespace switch (builtin.target.os.tag) {
    .linux => @import("./linux.zig"),
    .macos => @import("./apple.zig"),
    else => @compileError("OS not supported"),
};
