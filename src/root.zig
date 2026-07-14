const ZIML = @This();

const Patterns = @import("utils/Patterns.zig");
pub const LinearModel = Patterns.LinearModel;
pub const Layer = Patterns.Layer;

// StepFunctions
const Activation = @import("utils/ActivationFunctions.zig");
pub const ActivationFunction = Activation.ActivationFunction;
pub const ActivationArgs = Activation.ActivationArgs;
pub const ActivationKind = Activation.ActivationKind;

// Math
pub const Vector = @import("math/Vector.zig").Create;

pub const Perceptron = @import("linear_classifiers/Perceptron.zig").Perceptron;