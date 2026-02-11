module c3ml::linear::perceptron;
import c3ml::linear::patterns, c3ml::collections;
import std::io, std::core::mem;

typedef Perceptron = inline LinearModel;

fn void Perceptron.model(&self, ZString version = "0.1.0", ZString name = "Perceptron", int epochs = 10, float learning_rate = 0.01, float bias) @dynamic
{
    self.version = version;
    self.name = name;
    self.epochs = epochs;
    self.learning_rate = learning_rate;
    self.bias = bias;
}