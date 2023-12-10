data {
	// we split the dataset into zeros and not-zeros
	// we also allow two sets of covariates, one for presence-absence and one for nonzero counts
	int <lower = 0> n_zeros;
	int <lower = 0> n_counts;
	int <lower = 1> k_pa;
	int <lower = 1> k_pois;

	// four covariate matrices:
	// 		observed zeros, presence-absence process
	// 		observed nonzeros, presence-absence process
	// 		observed zeros, poisson (count) process
	// 		observed nonzeros, poisson process
	matrix [n_zeros, k_pa] X_zeros_pa; // binomial process, observed zeros
	matrix [n_counts, k_pa] X_count_pa; // binomial process, observed nonzeros
	matrix [n_zeros, k_pois] X_zeros_pois; // poisson process, observed zeros
	matrix [n_counts, k_pois] X_count_pois; // poisson process, observed zeros

	// the observed nonzero counts
	int <lower = 1> counts [n_counts];

	// prior hyperparams
	real a_pa_scale;
	real B_pa_scale;
	real a_pois_scale;
	real B_pois_scale;
}
parameters {
	// one set of linear parameters for determining the probability of presence
	real a_pa;
	vector [k_pa] B_pa;

	// a second set of parameters for determining the count if present
	real a_count;
	vector [k_pois] B_count;
}
transformed parameters {
	// first, we have a probability of presence and an expected count for each observed zero
	vector <lower = 0, upper = 1> [n_zeros] prob_pres_zeros;
	vector <lower = 0> [n_zeros] lam_zeros;

	// then we have the same for each observed (nonzero) count
	vector <lower = 0, upper = 1> [n_counts] prob_pres_counts;
	vector <lower = 0> [n_counts] lam_counts;
	
	prob_pres_zeros = inv_logit(a_pa + X_zeros_pa * B_pa);
	lam_zeros = exp(a_count + X_zeros_pois * B_count);

	prob_pres_counts = inv_logit(a_pa + X_count_pa * B_pa);
	lam_counts = exp(a_count + X_count_pois * B_count);
}
model {
	for(i in 1:n_zeros) {
		// on the probability scale, just to see
		// in the end we must work on the log scale, so it's a bit more complicated
		//      target *= (1 - prob_pres[i]) + prob_pres[i] * poisson_pmf(0 | lam_zeros[i]);

		// log_sum_exp performs the computation above, but keeping all values on the log scale
		// log_sum_exp(x1, x2) is equivalent to log(e^x1 + e^x2), but it never performs exponentiation
		// x1 and x2 are kept on the log scale, so we avoid numerical problems
		// see: https://mc-stan.org/docs/stan-users-guide/log-sum-of-exponentials.html
		target += log_sum_exp(
			// first term, the binomial term, now on the log scale
			log(1 - prob_pres_zeros[i]),
			// second term, the poisson term, on the log scale
			log(prob_pres_zeros[i]) + poisson_lpmf(0 | lam_zeros[i])
		);
	}

	// for the nonzero counts, we use a poisson likelihood as usual, with the added complication
	// that we must account for the probability of presence!
	for(i in 1:n_counts) {
		target += log(prob_pres_counts[i]) + poisson_lpmf(counts[i] | lam_counts[i]);
	}


	a_pa ~ normal(0, a_pa_scale);
	B_pa ~ normal(0, B_pa_scale);

	a_count ~ normal(0, a_pois_scale);
	B_count ~ normal(0, B_pois_scale);
}
generated quantities {
	// capture model deviance and lppd
	real deviance = 0;
	vector [n_zeros + n_counts] lppd;

	// simulate to get the PPD
	int ppd_counts [n_zeros + n_counts];

	// first simulate for all observed zeros
	for(i in 1:n_zeros) {
		// first term simulates the presence-absence part
		// then we multiply by a simulated poisson
		ppd_counts[i] = binomial_rng(1, prob_pres_zeros[i]) * poisson_rng(lam_zeros[i]);
		lppd[i] = log_sum_exp(log(1 - prob_pres_zeros[i]), 
			log(prob_pres_zeros[i]) + poisson_lpmf(0 | lam_zeros[i]));
		deviance += lppd[i];
	}

	// next simulate all observed nonzeros
	for(j in 1:n_counts) {
		ppd_counts[j + n_zeros] = binomial_rng(1, prob_pres_counts[j]) * poisson_rng(lam_counts[j]);
		lppd[j + n_zeros] = log(prob_pres_counts[j]) + poisson_lpmf(counts[j] | lam_counts[j]);
		deviance += lppd[j + n_zeros];
	}
	deviance *= -2;
}
