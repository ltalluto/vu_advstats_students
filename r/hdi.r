#' Computes a multivariate highest posterior density interval
#' 
#' Assumes a unimodal posterior distribution
#' @param samples A matrix of mcmc samples
#' @param lp Optional, vector of log posterior density of each sample, see details
#' @param density The (minimum) probability density contained in the interval
#' @details If a multivariate interval is desired, you must also pass the log probability of the model at
#' each sample. If the posterior is univariate, then this parameter is optional.
#' 
#' @return The highest density interval with the desired coverage
hdi = function(samples, lp, density = 0.9) {
	if(!is.matrix(samples))
		samples = matrix(samples, ncol = 1)
	
	# compute the indices of all possible intervals
	n = nrow(samples)
	n_include = ceiling(density * n)
	lower = 1:(n - n_include)
	upper = lower + n_include
	
	# sort the samples by their posterior density if provided, or by the samples for univariate problems
	if(!missing(lp)) {
		ind = order(lp)
		lp = lp[ind]
		samples = samples[ind, ]
	} else if(ncol(samples) == 1) {
		ind = order(samples[,1])
		samples = samples[ind,,drop = FALSE]
	}
	
	# compute the width for each variable, then the area in the parameter dimension
	f = function(l, u, samp) prod(apply(samp, 2, function(x) x[u] - x[l]))
	area = mapply(f, l = lower, u = upper, MoreArgs = list(samp = samples))
	
	i = which.min(area)
	res = cbind(samples[lower[i], ], samples[upper[i], ])
	colnames(res) = c("lower", "upper")
	res
}
