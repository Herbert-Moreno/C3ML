
pub fn Matrix(comptime T: type, comptime Row: usize, comptime Col: usize) type {
	return [Col][Row]T;
}