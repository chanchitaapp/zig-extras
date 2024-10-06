const std = @import("std");

pub const pkg = std.build.Pkg{
    .name = "extras",
    .path = .{ .path = "src/lib.zig" },
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mode = b.option(std.builtin.Mode, "mode", "") orelse .Debug;

    _ = b.addModule(
        "extras",
        .{ .root_source_file = b.path("src/lib.zig"), .target = target, .optimize = optimize },
    );

    const lib = b.addStaticLibrary(.{ .name = "extras", .root_source_file = b.path("src/lib.zig"), .target = target, .optimize = optimize });

    b.installArtifact(lib);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = mode,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "dummy test step to pass CI checks");
    test_step.dependOn(&run_exe_unit_tests.step);
}
