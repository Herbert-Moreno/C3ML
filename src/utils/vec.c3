module c3ml::utils::vectorarray {Type};
import c3ml::utils::interfaces, c3ml::utils::enums;
import std::core::mem, std::io;

struct Vector(interfaces::DynamicArray{Type}) 
{
    usz size;
    Type* items;
}

macro Vector? @newVector(Type[] array)
{
    /*
    Create and return an Vector of length and items
    @param Type[] array: `input array.`
    @require array.len > 0
    */
    Vector new_Vector;

    Type* new_items;
    usz new_size_bytes;
    usz array_size = array.len;

    if (array_size > 0) {
        new_size_bytes = array_size * Type.sizeof;

        new_items = mem::malloc(new_size_bytes);

        if (new_items == null) {
            return enums::MEMORY_ALLOC_FAILED?;
        }

        if (array_size > 0) {
            foreach (int index, item : array) {
                new_items[index] = item;
            }
        }

        new_Vector.size = new_size_bytes / Type.sizeof;
        new_Vector.items = new_items;
        new_items = null;
    } else {
        new_Vector.size = 0;
        new_Vector.items = null;
    }

    return new_Vector;
}

fn void? Vector.push(&self, Type item) @dynamic
{
    /*
    Expands the Vector +1 size every item pushed into the Vector,
    and inserts the item at the end of the vector
    @param Type item: `input item.`
    @require item != null.
    */
    Type* new_items;
    usz new_size_bytes;
    usz new_size = self.size + 1;

    new_size_bytes = new_size * Type.sizeof;

    new_items = mem::malloc(new_size_bytes);

    if (new_items == null) {
        return enums::MEMORY_ALLOC_FAILED?;
    }

    if (self.size > 0) {
        for (int i=0; i < new_size; i++) {
            new_items[i] = self.items[i];
        }
    }
    new_items[new_size - 1] = item;

    self.free();
    self.size = new_size;
    self.items = new_items;
    new_items = null;
}

fn void? Vector.updateAt(&self, usz index, Type item) @dynamic
{
    /*
    Updates an item at the index.
    @param usz index: `index of the item to update.`
    @param Type item: `item to push into the index.`
    @require self.size > 0
    */
    if (self.size > 0) {
        for (int i=0; i < self.size; i++) {
            if (i == index) {
                self.items[index] = item;
            }
        }
    } else {
        return enums::OUT_OF_RANGE?;
    }
}

fn usz Vector.len(&self) @dynamic @operator(len)
{
    return self.size;
}

fn Type? Vector.get(&self, usz index) @dynamic @operator([])
{
    /*
    Iterates over the items and gets an item from certain index,
    if item not found returns 0;
    @param usz index: `index of the item.`
    @require index < self.size
    */
    if (index < self.size) {
        return self.items[index];
    } else {
        return enums::OUT_OF_RANGE?;
    }
}

fn void? Vector.removeAt(&self, usz index) @dynamic
{
    /*
    Removes an item from certain index, does not decrease the Vector Size
    @param usz index: `index of the item.`
    @require self.size > 0
    */
    if (self.size > 0) {
        for (int i=0; i < self.size; i++) {
            if (i == index) {
                self.items[index] = 0;
            }
        }
    } else {
        return enums::OUT_OF_RANGE?;
    }
}

fn Type? Vector.pop(&self) @dynamic
{
    /*
    Removes the last item of the vector and returns it;
    @param : ``
    @require self.size > 0
    */
    Type last_item;
    Type* new_items;
    usz new_size_bytes;
    usz new_size = self.size - 1;

    if (self.size > 0) {
        last_item = self.items[new_size];

        new_size_bytes = new_size * Type.sizeof;

        new_items = mem::malloc(new_size_bytes);

        if (new_items == null) {
            return enums::MEMORY_ALLOC_FAILED?;
        }

        for (int i=0; i < new_size; i++) {
            new_items[i] = self.items[i];
        }

        self.free();
        self.size = new_size;
        self.items = new_items;
        new_items = null;
    } else {
        self.size = 0;
        self.items = null;
    }
    return last_item;
}

fn bool? Vector.has(&self, Type item) @dynamic
{
    /*
    Iterates over the Vector and Checks if the item is in the Vector
    @param usz item: `item to search.`
    @require self.size > 0
    */
    if (self.size > 0) {
        for (int i=0; i < self.size; i++) {
            if (self.items[i] == item) {
                return true;
            }
        }
        return false;
    } else {
        return enums::OUT_OF_RANGE?;
    }
}

fn void Vector.printAll(&self) @dynamic
{
    /*
    Prints all data in the vector,
    do a lil bit of witchery to discover the type format of the data.
    @param : ``
    @require 
    */
    for (int i = 0; i < self.size; i++) {
        switch(Type) {
            case int.typeid:
                io::printfn("%d ", self.items[i]);
            case float.typeid:
                io::printfn("%f ", self.items[i]);
            case double.typeid:
                io::printfn("%f ", self.items[i]);
            case String.typeid:
                io::printfn("%s ", self.items[i]);
            case char.typeid:
                io::printfn("%c ", (char)self.items[i]);
            default:
                io::printfn("%d ", self.items[i]);
        }
    }
}

fn bool Vector.free(&self) @dynamic
{
    /*
    Free the items pointer.
    @param : ``
    @require self.items != null
    */
    if (self.items != null) {
        mem::free(self.items);
        self.items = null;
        return true;
    } else {
        self.items = null;
        return false;
    }
}

fn Type Vector.dotprod(&self, Vector{Type} other) @operator(+)
{
    if (self.size == other.size) {
        Type sum;
        for (usz idx; idx < self.size; idx++) {
            sum += self.get(idx)!! * other.get(idx)!!;
        }
        return sum;
    } else {
        return 0;
    }
}