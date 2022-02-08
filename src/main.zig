const builtin = @import("builtin");

pub usingnamespace switch (builtin.target.os.tag) {
    .linux => @import("./linux.zig"),
    else => @compileError("OS not supported"),
};
