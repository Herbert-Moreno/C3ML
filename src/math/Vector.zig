pub fn Create(comptime T: type) type {
    return struct {
        data: []T,
        size: usize,
        allocator: std.mem.Allocator,

        const Self = @This();

        pub const empty = Self{
            .data = &.{},
            .size = 0,
            .allocator = undefined,
        };

        pub fn init(allocator: std.mem.Allocator, data: []T) Self {
            const d = allocator.alloc(T, data.len) catch |err| {
                std.debug.print("Error {}", .{err});
                @panic("");
            };
            @memcpy(d, data);
            return .{
                .data = d,
                .size = data.len,
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            self.allocator.free(self.data);
            self.size = 0;
        }

        pub fn zeroes(allocator: std.mem.Allocator, size: usize) Self {
            const d = allocator.alloc(T, size) catch |err| {
                std.debug.print("Error {}", .{err});
            };
            @memset(d, @as(T, 0));
            return .{
                .data = d,
                .size = size,
                .allocator = allocator,
            };
        }

        pub fn random(allocator: std.mem.Allocator, size: usize) Self {
            var thread = std.Io.Threaded.init_single_threaded;
            defer thread.deinit();

            const io = thread.io();
            const seed = std.Io.Clock.real.now(io).toNanoseconds();

            var prng: std.Random.DefaultPrng = .init(@as(u64, @intCast(seed)));
            const rand = prng.random();

            const d = allocator.alloc(T, size) catch |err| {
                std.debug.print("Error {}", .{err});
                @panic("");
            };

            for (d) |*item| {
                switch (@typeInfo(T)) {
                    .int, .comptime_int => {
                        item.* = rand.int(T);
                    },
                    .float, .comptime_float => {
                        switch (@typeInfo(T).float.bits) {
                            16 => item.* = rand.float(32),
                            else => item.* = rand.float(T),

                        }
                    },
                    .bool => {
                        item.* = rand.boolean();
                    }
                }
            }
            return .{
                .data = d,
                .size = size,
                .allocator = allocator,
            };
        }
        pub fn randomRange(allocator: std.mem.Allocator, size: usize, min: T, max: T) Self {
            var thread = std.Io.Threaded.init_single_threaded;
            defer thread.deinit();

            const io = thread.io();
            const seed = std.Io.Clock.real.now(io).toNanoseconds();

            var prng: std.Random.DefaultPrng = .init(@as(u64, @intCast(seed)));
            const rand = prng.random();

            const d = allocator.alloc(T, size) catch |err| {
                std.debug.print("Error {}", .{err});
                @panic("");
            };

            for (d) |*item| {
                switch (@typeInfo(T)) {
                    .int, .comptime_int => {
                        item.* = rand.intRangeLessThan(T, min, max);
                    },
                    .float, .comptime_float => {
                        switch (@typeInfo(T).float.bits) {
                            16 => item.* = min + rand.float(32) * (max - min),
                            else => item.* = min + rand.float(T) * (max - min),
                        }
                    },
                    .bool => {
                        item.* = rand.boolean();
                    },
                    else => @compileError("Unsupported type"),
                }
            }

            return .{
                .data = d,
                .size = size,
                .allocator = allocator,
            };
        }
        pub fn append(self: *Self, item: T) void {
            const new_sz = self.size +% 1;
            self.data = self.allocator.realloc(self.data, new_sz) catch |err| {
                std.debug.print("Error {}", .{err});
            };
            self.data[self.size] = item;
            self.size = new_sz;
        }

        pub fn dot(self: *Self, other: Self) ?T {
            if (self.size != other.size) {
                std.debug.print("Incompatible size", .{});
                return null;
            }
            var sum: T = std.mem.zeroes(T);
            for (self.data, other.data) |*x, *y| {
                sum += x.* * y.*;
            }
            return sum;
        }

        pub fn toSlice(self: *Self) []T {
            return self.data[0..self.size];
        }
    };
}

const std = @import("std");