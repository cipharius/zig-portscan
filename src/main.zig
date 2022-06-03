const std = @import("std");
const builtin = @import("builtin");
const argsParser = @import("zig-args");
const PortRange = @import("PortRange.zig");
const scanner = @import("scanner.zig");

const stderr = std.io.getStdErr().writer();

pub fn main() !u8 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const args = try argsParser.parseForCurrentProcess(struct {
        address: []const u8 = "127.0.0.1",
        timeout: u32 = 200,

        pub const shorthands = .{
            .a = "address",
            .t = "timeout",
        };
    }, allocator, .print);
    defer args.deinit();

    const template_address = try std.x.os.IPv4.parse(args.options.address);

    for (args.positionals) |arg| {
        if (PortRange.parse(arg)) |port_range| {
            try scanner.scanPorts(template_address, port_range, args.options.timeout);
        } else {
            try stderr.print("Invalid port range: {s}\n", .{arg});
        }
    }

    return 0;
}
