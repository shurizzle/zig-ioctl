const std = @import("std");

const syscall = std.build.Pkg{
    .name = "syscall",
    .path = .{ .path = "./deps/syscall/src/main.zig" },
};

const ioctl = std.build.Pkg{
    .name = "ioctl",
    .path = .{ .path = "./src/main.zig" },
    .dependencies = &[_]std.build.Pkg{
        syscall,
    },
};

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const download_syscall = GitClone.create(b, "https://github.com/shurizzle/zig-syscall", "deps/syscall");

    const main_tests = b.addTest("__tests__/main.zig");
    main_tests.addPackage(syscall);
    main_tests.addPackage(ioctl);
    main_tests.setBuildMode(mode);
    main_tests.step.dependOn(&download_syscall.step);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}

const GitClone = struct {
    const Self = @This();

    step: std.build.Step,
    builder: *std.build.Builder,
    repository: []const u8,
    path: []const u8,

    pub fn create(builder: *std.build.Builder, repository: []const u8, path: []const u8) *Self {
        const self = builder.allocator.create(Self) catch unreachable;
        self.* = Self{
            .step = std.build.Step.init(.custom, "Git clone", builder.allocator, make),
            .builder = builder,
            .repository = repository,
            .path = path,
        };
        return self;
    }

    fn make(step: *std.build.Step) !void {
        const self = @fieldParentPtr(Self, "step", step);

        const repo_dir = self.builder.pathFromRoot(self.path);

        defer self.builder.allocator.free(repo_dir);

        const upper_dir = std.fs.path.dirname(repo_dir) orelse unreachable;

        try std.fs.cwd().makePath(upper_dir);

        if (!isDirAndExists(repo_dir)) {
            const child = std.ChildProcess.init(&.{ "git", "clone", "--depth", "1", self.repository, repo_dir }, self.builder.allocator) catch unreachable;
            defer child.deinit();
            _ = try child.spawnAndWait();
        }
    }
};

fn isDirAndExists(path: []const u8) bool {
    if (std.fs.openDirAbsolute(path, .{ .access_sub_paths = false, .iterate = false, .no_follow = false })) |*dir| {
        dir.close();
        return true;
    } else |_| {
        return false;
    }
}
