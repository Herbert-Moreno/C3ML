module c3ml;
import std;

fn int main(String[] args)
{
	float[] data = {4.6, 3.2, 1.4, 0.2, 5.5};
	float[] label = {1, 0, 1, 0, 0};
	Vectorf train_dataset = newVector{float}(data)!!;
	Vectorf train_label = newVector{float}(label)!!;
	Perceptron model = perceptron::newPerceptron(50, 0.0001, 1, train_dataset);
	defer model.free();
	model.fit(train_label);
	return 0;
}