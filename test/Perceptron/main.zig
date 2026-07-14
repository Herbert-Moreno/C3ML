const std = @import("std");
const ZIML = @import("ZIML");

pub fn main(init: std.process.Init) void {
	var X = ZIML.Vector(f32).init(init.gpa, @constCast(&[5]f32{0.0, 1.0, 1.0, 0.0, 1.0}));
	defer X.deinit();

	var model = ZIML.Perceptron(f32, init.gpa, 30, 0.01);
	defer model.deinit();
	const result = model.predict(
		X,
		.BinaryStep
	);

	std.debug.print("{}", .{result});
}