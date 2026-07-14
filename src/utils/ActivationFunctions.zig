const std = @import("std");

pub const ActivationKind = enum {
  BinaryStep,
  LinearFn,
  Sigmoid,
  Tanh,
  ReLU,
};

pub const ActivationArgs = struct {
  linear_a: f32 = 1.0,
};

pub const ActivationFunction = struct {
  pub fn run(comptime in_out: type, yhat: in_out, kind: ActivationKind, args: ActivationArgs) in_out {
    switch (kind) {
      .BinaryStep => {
        if (yhat >= 0) {return @as(in_out, 1);}
        return @as(in_out, 0);
      },
      .LinearFn => {
        return @as(in_out, @floatCast(args.linear_a)) * yhat;
      },
      .Sigmoid => {
        return @as(in_out, 1) / (@as(in_out, 1) + std.math.pow(in_out, @as(in_out, std.math.e), -yhat));
      },
      .Tanh => {
        return @as(in_out, 2) / ((@as(in_out, 1) + std.math.pow(in_out, @as(in_out, std.math.e), -(2*yhat))) * @as(in_out, -1));
      },
      .ReLU => {
        return @as(in_out, @max(0, yhat));
      },
    }
  }
};