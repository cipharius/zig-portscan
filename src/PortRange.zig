const std = @import("std");

const PortRange = @This();

from: u16,
to: u16,

pub fn parse(input: []const u8) ?PortRange {
    var result = PortRange{ .from = undefined, .to = undefined };

    const max_port_len = 5;
    var i: u8 = 0;
    while (i < max_port_len + 1) : (i += 1) {
        if (i < input.len and input[i] != '-') continue;
        result.from = std.fmt.parseInt(u16, input[0..i], 10) catch return null;
        break;
    } else {
        // Port too long
        return null;
    }

    result.to = result.from;
    if (i == input.len) return result;

    i += 1;
    if (i >= input.len or input.len - i > max_port_len) return null;
    result.to = std.fmt.parseInt(u16, input[i..], 10) catch return null;

    return result;
}

test "parse" {
    const expectEqual = std.testing.expectEqual;

    try expectEqual(PortRange{ .from = 123, .to = 123 }, parse("123").?);
    try expectEqual(PortRange{ .from = 123, .to = 456 }, parse("123-456").?);
    try expectEqual(PortRange{ .from = 65535, .to = 65535 }, parse("65535").?);
    try expectEqual(PortRange{ .from = 1, .to = 65535 }, parse("1-65535").?);

    try expectEqual(@as(?PortRange, null), parse(""));
    try expectEqual(@as(?PortRange, null), parse("123-"));
    try expectEqual(@as(?PortRange, null), parse("65536"));
    try expectEqual(@as(?PortRange, null), parse("655355"));
    try expectEqual(@as(?PortRange, null), parse("65535-655356"));
    try expectEqual(@as(?PortRange, null), parse("65535-6553555"));
}
