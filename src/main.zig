const std = @import("std");
const builtin = @import("builtin");
const argsParser = @import("zig-args");
const PortRange = @import("PortRange.zig");
const scanner = @import("scanner.zig");

pub fn main() u8 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const args = argsParser.parseForCurrentProcess(struct {
        address: []const u8 = "127.0.0.1",
        timeout: u32 = 200,

        pub const shorthands = .{
            .a = "address",
            .t = "timeout",
        };
    }, allocator, .print) catch return 1;
    defer args.deinit();

    const template_address = std.x.os.IPv4.parse(args.options.address) catch |err| {
        std.debug.print("Error: {any}", .{err});
        return 1;
    };

    for (args.positionals) |arg| {
        if (PortRange.parse(arg)) |port_range| {
            scanner.scanPorts(template_address, port_range, args.options.timeout);
        } else {
            std.debug.print("Invalid port range: {s}\n", .{arg});
        }
    }

    return 0;
}
