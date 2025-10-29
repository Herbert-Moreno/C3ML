module c3ml::linear_models::perceptron;
import c3ml::linear_models::linear_pattern;
import c3ml::utils::vectorarray, std::io;

struct Perceptron (linear_pattern::LinearMethods)
{
    inline linear_pattern::LinearModel options;
    float bias;
    Vector{float} weights;
    Vector{float} inputs;
    Vector{int} errors;
}

macro Perceptron new_perceptron(
    int epochs, 
    float learning_rate, 
    float bias,
    Vector{float} i,
    )
{
    float[] new_weigths = mem::new_array(float, i.size);
    int[] new_err;

    Vector{float} w = @newVector{float}(new_weigths)!!;

    Vector{int} e = @newVector{int}(new_err)!!;

    Perceptron model = {
        .version = "0.0.1",
        .name = "Percepetron",
        .epochs = epochs,
        .learning_rate = learning_rate,
        .bias = bias,
        .weights = w,
        .inputs = i,
        .errors = e,
    };

    return model;
}

fn void Perceptron.fit(&self, Vector{float} y) @dynamic
{
    io::print("Weights:\n[");
    for (int idx = 0; idx < self.inputs.size; idx++) {
        float w_ = 1 + self.inputs[idx]!!;
        self.weights.updateAt(idx, w_)!!;
        io::printf("%f ", w_);
    }
    io::print("]\n");

    for (int ep = 0; ep < self.epochs; ep++) {
        int error;

        for (int idx = 0; idx < self.inputs.size; idx++) {
            char y_pred = self.predict(self.inputs);
            float update = self.learning_rate * (y[idx]!! - y_pred);

            self.weights.updateAt(idx, (self.weights[idx]!! + update * self.inputs[idx]!!))!!;
            io::printf("Updated Weights: %f\n", self.weights[idx]!!);

            self.bias += update;
            io::printf("Updated Bias: %f\n", self.bias);

            error += (int) (update != 0.0);
            io::printf("Erros: %d\n", error);

        }

        self.errors.push(error)!!;
    }
}

fn char Perceptron.predict(&self, Vector{float} x) @dynamic
{
    if (self.activationFunc(x) >= 0) {
        return 1;
    } else {
        return 0;
    }
}

fn float Perceptron.activationFunc(&self, Vector{float} x) @dynamic
{
    float out = x + self.weights;
    out + self.bias;
    return out;
}

fn void Perceptron.freePointers(&self) {
    bool w_freed = self.weights.free();
    bool i_freed = self.inputs.free();
    bool e_freed = self.errors.free();
    if (w_freed && i_freed && e_freed) {
        io::print("[INFO] All Pointers Were Freed!\n");
    } else {
        io::print("[WARNING] One Pointer Not Freed!\n");
        io::print("Pointers Allocated:\n");
        io::print("----------------------------\n");
        io::printf("Weigths Freed?: %s\n", w_freed);
        io::printf("Inputs Freed?: %s\n", i_freed);
        io::printf("Errors Freed?: %s\n", e_freed);
        io::print("----------------------------\n");
    }
}