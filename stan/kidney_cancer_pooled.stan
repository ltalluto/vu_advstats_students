data {
	int <lower = 1> n;
	int <lower = 0> deaths [n];
	int <lower = 0> population [n];
	real <lower = 0> alpha;
	real <lower = 0> beta;
}
transformed data {
	// cancer is rare, lets make the numbers more reasonable
	vector <lower = 0> [n] exposure;
	for(i in 1:n)
		exposure[i] = population[i] / 1000.0;
}
parameters {
	real <lower = 0> lambda;
}
model {
	deaths ~ poisson(exposure * lambda);
	lambda ~ gamma(alpha, beta);
}
