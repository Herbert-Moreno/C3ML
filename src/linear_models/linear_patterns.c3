module c3ml::linear_models::linear_pattern;
import c3ml::utils::vectorarray;

struct LinearModel {
    String version;
    String name;
    int epochs;
    float learning_rate;
}

interface LinearMethods {
    fn float activationFunc(Vector{float} x);
    fn void fit(Vector{float} y);
    fn char predict(Vector{float} x);
}