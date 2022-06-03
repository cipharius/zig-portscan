const std = @import("std");
const PortRange = @import("PortRange.zig");

const Address = std.x.net.ip.Address;
const Stream = std.net.Stream;
const TcpClient = std.x.net.tcp.Client;

pub fn scanPorts(template: std.x.os.IPv4, port_range: PortRange, timeout: u32) void {
    var port = port_range.from;
    while (port <= port_range.to) : (port += 1) {
        var address = std.x.net.ip.Address.initIPv4(template, port);

        if (checkPort(address, timeout)) {
            std.debug.print("{d}\topen\n", .{port});
        } else |err| {
            switch (err) {
                error.ConnectionRefused => std.debug.print("{d}\tclosed\n", .{port}),
                error.WouldBlock => std.debug.print("{d}\ttimeout\n", .{port}),
                else => std.debug.print("{d}\texception: {}\n", .{port, err}),
            }
        }
    }
}

pub fn checkPort(addr: Address, timeout_ms: u32) !bool {
    var client = try TcpClient.init(.ip, .{});
    defer client.deinit();

    try client.setWriteTimeout(timeout_ms);
    try client.connect(addr);

    return true;
}
