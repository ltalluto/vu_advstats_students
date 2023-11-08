data {
	int <lower = 1> n_obs;
	int <lower = 0> k [n_obs];
	int <lower = 0> n [n_obs];
	real <lower = 0> a;
	real <lower = 0> b;
}
parameters {
	real <lower = 0, upper = 1> p;
}
model {
	k ~ binomial(n, p);
	p ~ beta(a, b);
}
