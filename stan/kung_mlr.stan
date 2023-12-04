data {
	int <lower = 1> n;
	vector [n] height;
	vector [n] weight;
	vector [n] age;
	vector [n] is_male;
	// priors
	real <lower = 0> lam_sig;
	real <lower = 0> sig_a;
	real <lower = 0> sig_b;
}
parameters {
	real a;
	real b_weight;
	real b_age;
	real b_interaction;
	real b_male;
	real <lower = 0> sigma;
}
transformed parameters {
	vector [n] eta;
	eta = a + b_weight * weight + b_age * age + b_interaction * weight .* age + b_male * is_male;
}
model {
	height ~ normal(eta, sigma);
	sigma ~ exponential(lam_sig);
	a ~ normal(0, sig_a);
	b_weight ~ normal(0, sig_b);
	b_age ~ normal(0, sig_b);
	b_interaction ~ normal(0, sig_b);
	b_male ~ normal(0, sig_b);
}
generated quantities {
	// prediction, for part 3c
	// 41 is the hypothetical weight for this example
	// 24 is the age
	// the subject is female, so is_male=0
	real prediction_3c = normal_rng(a + b_weight * 41 + b_age * 24 + b_interaction*24*41 + b_male * 0, sigma);
}
