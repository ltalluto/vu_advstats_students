data {
	int <lower = 0> k;
	int <lower = k> n;
}
parameters {
	real <lower = 0, upper = 1> p;
}
model {
	k ~ binomial(n, p);
}

