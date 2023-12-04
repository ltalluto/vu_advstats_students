data {
	int <lower = 1> n;
	int <lower = 1> n_counties;
	int <lower = 0> deaths [n];
	int <lower = 0> population [n];
	int <lower = 0, upper = n_counties> county_id [n];

	// hyper-hyper parameters, for the hyperprior
	real <lower = 0> a_alpha;
	real <lower = 0> a_beta;
	real <lower = 0> b_alpha;
	real <lower = 0> b_beta;
}
transformed data {
	// cancer is rare, lets make the numbers more reasonable
	vector <lower = 0> [n] exposure;
	for(i in 1:n)
		exposure[i] = population[i] / 1000.0;
}
parameters {
	vector <lower = 0> [n_counties] lambda;
	
	// prior hyperparameters for lambda are now parameters we will estimate!
	real <lower = 0> alpha;
	real <lower = 0> beta;
	
}
model {
	for(i in 1:n) {
		int j = county_id[i];
		deaths[i] ~ poisson(exposure[i] * lambda[j]);
	}
	
	// prior for lambda
	lambda ~ gamma(alpha, beta);
	
	// hyperpriors for alpha and beta
	alpha ~ gamma(a_alpha, a_beta);
	beta ~ gamma(b_alpha, b_beta);
}
generated quantities {
	// save the overal mean and variance in cancer rate
	real lambda_mu = alpha/beta;
	real lambda_var = alpha/beta^2;
}
