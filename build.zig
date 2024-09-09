const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const dll = b.addSharedLibrary(.{
        .name = "lightwm_dll",
        // .root_source_file = b.path("wm_dll.c"),
        .target = target,
        .optimize = optimize,
    });
    dll.addCSourceFiles(.{ .files = &.{
        "wm_dll.c",
        "shared_mem.c",
        "error.c",
    }, .flags = &.{
        "-Wall",
        "-W",
        "-Wstrict-prototypes",
        "-Wwrite-strings",
        "-Wno-missing-field-initializers",
    } });

    dll.linkLibC();
    // dll.force_pic = true;
    b.installArtifact(dll);

    const exe = b.addExecutable(.{
        .name = "lightwm",
        // .root_source_file = b.path("wm.c"),
        .target = target,
        .optimize = optimize,
    });

    exe.addCSourceFiles(.{ .files = &.{
        "wm.c",
        "tiling.c",
        "error.c",
        "keyboard.c",
        "shared_mem.c",
    }, .flags = &.{
        "-Wall",
        "-W",
        "-Wstrict-prototypes",
        "-Wwrite-strings",
        "-Wno-missing-field-initializers",
    } });
    exe.mingw_unicode_entry_point = true;
    exe.linkLibC();

    b.installArtifact(exe);
}
