data {
	int <lower=0> n; // number of data points
	int <lower=0> k; // number of x-variables
	int <lower=0> richness [n];
	matrix [n,k] X;
	
	// prior hyperparams
	real mu_a;
	real mu_b;
	real <lower=0> sigma_a;
	real <lower=0> sigma_b;
}
parameters {
	real a;
	vector [k] B;
}
transformed parameters {
	vector <lower=0> [n] lambda;
	lambda = exp(a + X * B);
}
model {
	richness ~ poisson(lambda);
	a ~ normal(mu_a, sigma_a);
	B ~ normal(mu_b, sigma_b);
}
generated quantities {
	int r_predict [n];
	for(i in 1:n)
		r_predict[i] = poisson_rng(lambda[i]);
	r_predict = poisson_rng(lambda);
}
