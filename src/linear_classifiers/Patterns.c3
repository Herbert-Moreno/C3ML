module c3ml::linear_models::linear_pattern;
import c3ml::utils::vector;

struct LinearModel (LinearMethods)
{
    ZString version;
    ZString name;
    int epochs;
    float learning_rate;
    float bias;
}

interface LinearMethods {
    fn void model(ZString version = "0.0.1", ZString name = "", int epochs = 10, float learning_rate = 0.01, float bias);
    fn void fit(VectorF input, VectorF weights);
    fn VectorF predict();
}