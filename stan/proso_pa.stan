data {
	int <lower = 1> n;
	int <lower = 1> k;
	int <lower = 0, upper = 1> pa [n];
	matrix [n, k] X;
}
parameters {
	real a;
	vector [k] B;
}
transformed parameters {
	vector <lower = 0, upper = 1> [n] prob_pres;
	prob_pres = inv_logit(a + X * B);
}
model {
	pa ~ binomial(1, prob_pres);
	a ~ normal(0, 10);
	B ~ normal(0, 5);
}
