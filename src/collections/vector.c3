module c3ml::collections::vector <Type>;
import c3ml::collections::interfaces, c3ml::collections::enums;
import std::core::mem, std::io;

struct Vector (Printable) {
    usz size;
    Allocator alloc;
    Type* items;
}

fn usz~ Vector.to_format(&self, Formatter* formatter) @dynamic
{
	switch (self.size)
	{
		case 0:
			return formatter.print("()")!;
		default:
			usz n = formatter.print("(")!;
			for (int i; i < self.size; i++)
			{
				if (i != 0) formatter.print(", ")!;
				n += formatter.printf("%s", self.items[i])!;
			}
			n += formatter.print(")")!;
			return n;
	}
}

fn void~ Vector.init(&self, Allocator alloc, Type[] init_values = {})
{
    Vector new_Vector;

    Type*? new_items;
    usz new_size_bytes;
    usz array_size = array.len;

    if (array_size > 0) {
        new_size_bytes = array_size * Type.sizeof;

        new_items = (Type*) allocator::malloc_try(allocator::mem , new_size_bytes);

        if (catch new_items) {
            io::printn("[ERROR] Malloc_try Failed");
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

<*
 Expands the Vector +1 size every item pushed into the Vector,
 and inserts the item at the end of the vector
*>
fn void? Vector.push(&self, Type item) @dynamic
{
    Type*? new_items;
    usz new_size_bytes;
    usz new_size = self.size + 1;

    new_size_bytes = new_size * Type.sizeof;

    new_items = (Type*)allocator::realloc_try(allocator::mem, self.items, new_size_bytes);

    if (catch new_items) {
        io::printn("[ERROR] Realloc_try Failed");
        return enums::MEMORY_ALLOC_FAILED?;
    }

    new_items[new_size - 1] = item;
    self.free();
    self.items = new_items;
    self.size = new_size;
    new_items = null;
}

<*
 Updates an item at the index.
*>
fn void? Vector.update_at(&self, usz index, Type item) @dynamic
{
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

<*
 Returns the current size of the vector
*>
fn usz Vector.len(&self) @dynamic
{
    return self.size;
}

<*
 Iterates over the items and gets an item from certain index,
 if item not found returns 0;
*>
fn Type? Vector.get(&self, usz index) @dynamic @operator([])
{
    if (index < self.size) {
        return self.items[index];
    } else {
        return enums::OUT_OF_RANGE?;
    }
}

<*
 Removes an item from certain index, does not decrease the Vector Size
*>
fn void? Vector.remove_at(&self, usz index) @dynamic
{
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

<*
 Removes the last item of the vector and returns it;
*>
fn Type? Vector.pop(&self) @dynamic
{
    Type last_item;
    Type*? new_items;
    usz new_size_bytes;
    usz new_size = self.size - 1;

    if (self.size > 0) {
        last_item = self.items[new_size];

        new_size_bytes = new_size * Type.sizeof;

        new_items = (Type*) allocator::realloc_try(allocator::mem, self.items, new_size_bytes);

        if (catch new_items) {
            io::printn("[ERROR] Realloc_try Failed");
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

<*
 Iterates over the Vector and Checks if the item is in the Vector
*>
fn bool? Vector.has(&self, Type item) @dynamic
{
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

<*
 Prints all data in the vector,
 do a lil bit of witchery to discover the type format of the data.
*>
fn void Vector.print_all(&self) @dynamic
{
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

<*
 Free the items pointer.
*>
fn bool Vector.free(&self) @dynamic
{
    if (self.items != null) {
        free(self.items);
        self.items = null;
        return true;
    } else {
        self.items = null;
        return false;
    }
}

<*
 Returns the dot product of two vectors of same type
*>
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