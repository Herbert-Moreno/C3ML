pub fn LinearModel(comptime Input: type, comptime Output: type) type {
    return struct {
        allocator: std.mem.Allocator,
        version: []const u8,
        name: []const u8,
        layers: Vector(Layer),
        epochs: usize,
        w: ZIML.Vector(Input),
        predictfn: ?*const fn (self: *anyopaque, X: Vector(Input), activationFn: ZIML.ActivationKind) Output,
        fitfn: ?*const fn (self: *Self) void,

        const Self = @This();

        pub fn predict(self: *Self, X: Vector(Input), activationFn: ZIML.ActivationKind) Output {
            if (self.predictfn) |predictfn| {
                return predictfn(self, X, activationFn);
            }
            std.debug.print("Not Implemented Yet", .{});
            @panic("error");
        }

        pub fn fit(self: *Self) void {
            if (self.fitfn) |fitfn| {
                fitfn(self);
                return;
            }
            std.debug.print("Not Implemented Yet", .{});
            @panic("error");
        }

        pub fn deinit(self: *Self) void {
            self.layers.deinit();
            self.w.deinit();
        }
    };
}

pub const Layer = struct {
    bias: f32,
    learning_rate: f32,

    pub fn randomBias() f32 {
        var thread = std.Io.Threaded.init_single_threaded;
        defer thread.deinit();

        const io = thread.io();
        const seed = std.Io.Clock.real.now(io).toNanoseconds();

        var prng: std.Random.DefaultPrng = .init(@as(u64, @intCast(seed)));
        const rand = prng.random();

        return rand.float(f32);
    }
};

const ZIML = @import("../root.zig");
const Vector = ZIML.Vector;
const std = @import("std");