module c3learning;
import c3learning::linear_models::perceptron, c3learning::utils::vectorarray;
import std::io;

fn int main(String[] args)
{
	float[] data = {4.6, 3.2, 1.4, 0.2, 5.5};
	float[] label = {1, 0, 1, 0, 0};
	Vector{float} train_dataset = @newVector{float}(data)!!;
	Vector{float} train_label = @newVector{float}(label)!!;
	Perceptron model = perceptron::new_perceptron(50, 0.0001, 1, train_dataset);
	defer model.freePointers();
	model.fit(train_label);
	return 0;
}