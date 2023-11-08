data {
	int <lower = 1> n_obs; // number of data points
	int <lower = 0> k [n_obs];
	int <lower = 0> n [n_obs]; // number of trials for each data point
}
parameters {
	real <lower = 0, upper = 1> p;
}
model {
	k ~ binomial(n, p);
}
