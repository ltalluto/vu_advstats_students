#' Computes a multivariate hpdi interval
#' 
#' Assumes a unimodal posterior distribution
#' @param samples A matrix of mcmc samples
#' @param posterior A function returning the log unnormalized posterior density
#' @param data The data used to compute the samples
#' @param density The (minimum) probability density contained in the interval
hdi = function(samples, posterior, data, density = 0.9) {
	
	# compute the indices of all possible intervals
	n = nrow(samples)
	n_include = ceiling(density * n)
	lower = 1:(n - n_include)
	upper = lower + n_include
	
	# sort the samples by their posterior density
	dens = apply(samples, 1, posterior, data = data)
	ind = order(dens)
	dens = dens[ind]
	samples = samples[ind, ]
	
	# compute the width for each variable, then the area in the parameter dimension
	area = mapply(function(l, u, samp) 
		prod(apply(samp, 2, function(x) x[u[i]] - x[l[i]])), 
		l = lower, u = upper, moreArgs = list(samp = samples))
	
	i = which.min(area)
	cbind(samples[lower[i], ], samples[upper[i], ])
}
