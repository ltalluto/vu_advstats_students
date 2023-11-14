data {
	int <lower=0> n;
	vector [n] x;
	vector [n] y;
}
parameters {
	real intercept;
	real slope;
	real <lower = 0> s;
}
model {
	y ~ normal(intercept + slope * x, s);
}
