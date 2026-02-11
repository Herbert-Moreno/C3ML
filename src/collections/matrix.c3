module c3ml::collections::matrix <Type, Row, Col>;

typedef Matrix = Type[Col][Row];
/*
fn usz~ Matrix.to_format(&self, Formatter* formatter)
{
	switch (self.len)
	{
		case 0:
			return formatter.print("[]")!;
		default:
			usz n = formatter.print("[")!;
			foreach (idx, element : self)
			{
				if (i != 0) formatter.print(", ")!;
				n += formatter.printf("%s", element)!;
			}
			n += formatter.print("]")!;
			return n;
	}
}*/