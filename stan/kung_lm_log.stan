data {
	int <lower = 1> n;
	vector [n] height;
	vector [n] weight;
	// priors
	real <lower = 0> lam_sig;
	real <lower = 0> sig_a;
	real <lower = 0> sig_b;
}
parameters {
	real a;
	real b;
	real <lower = 0> sigma;
}
transformed parameters {
	vector [n] eta;
	eta = a + b * log(weight);
}
model {
	height ~ normal(eta, sigma);
	sigma ~ exponential(lam_sig);
	a ~ normal(0, sig_a);
	b ~ normal(0, sig_b);
}
generated quantities {
	// prediction, for part 3c
	// 41 is the hypothetical weight for this example
	real prediction_3c = normal_rng(a + b * log(41), sigma);
}
