module c3learning::utils::interfaces{Type};

interface DynamicArray {
    fn void? push(Type item);
    fn void? updateAt(usz index, Type item);
    fn Type? get(usz index);
    fn usz len();
    fn void? removeAt(usz index);
    fn Type? pop();
    fn bool? has(Type item);
    fn void printAll();
    fn bool free();
}