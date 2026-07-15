pub fn Perceptron(comptime T: type, allocator: std.mem.Allocator, epochs: usize, learning_rate: f32) LinearModel(T, u1) {

    const gen = struct {
        pub fn predict(self: *anyopaque, X: Vector(T), activationFn: ZIML.ActivationKind) u1 {
            const super: *LinearModel(T, u1) = @alignCast(@ptrCast(self));
            var x_mutable = X;
            super.w = .randomRange(super.allocator, X.size, -1, 1);
            var z: T = std.mem.zeroes(T);
            const b = @as(T, @floatCast(super.layers.toSlice()[0].bias));

            z = x_mutable.dot(super.w) orelse 0 + b;
            return @as(u1, @intFromFloat(ZIML.ActivationFunction.run(T, z, activationFn, .{.linear_a = 0.0})));
        }
    };

    return .{
        .allocator = allocator,
        .version = "0.0.2",
        .name = "Perceptron",
        .epochs = epochs,
        .layers = .init(allocator, @constCast(&[1]Layer{
            .{
                .bias = Layer.randomBias(),
                .learning_rate = learning_rate,
            },
        })),
        .w = .empty,
        .predictfn = gen.predict,
        .fitfn = null
    };
}

const std = @import("std");
const ZIML = @import("../root.zig");
const LinearModel = ZIML.LinearModel;
const Layer = ZIML.Layer;
const Vector = ZIML.Vector;