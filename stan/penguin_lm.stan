data {
	int <lower = 1> n;
	vector [n] bill_depth;
	vector [n] bill_len;
}
parameters {
	real <lower = 0> s;
	real a;
	real b;
}
transformed parameters {
	vector [n] eta;
	eta = a + b * bill_len;
}
model {
	bill_depth ~ normal(eta, s);
	s ~ exponential(0.1);
	a ~ normal(0, 10);
	b ~ normal(0, 5);
}
