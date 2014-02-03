\name{get_pairs}
\alias{get_pairs}
\title{get_pairs}
\usage{
get_pairs(X, u, v, weightAsFunctionOfMahalanobis = function(x) 1/(1 + x),
  renormalizeWeights = TRUE)
}
\arguments{
  \item{X}{data frame}

  \item{u}{input of interest}

  \item{v}{other inputs}

  \item{weightAsFunctionOfMahalanobis}{weights to use,
  expressed as a function of mahalanobis distance}

  \item{renormalizeWeights}{whether to renormalize the
  weights to that they sum to 1 within each group (groups
  based on the first element of the pair). If I'm right,
  there's no reason to use \code{FALSE} ever; I'm only
  leaving the option in so I can compare with the paper.}
}
\value{
a data frame with the inputs \code{v} from the first of
each pair, \code{u} from each half (with ".B" appended to
the second), and the mahalanobis distances between the
pairs.
}
\description{
Form all pairs of rows in X and compute mahalanobis
distances based on \code{v}.
}
\examples{
library("mvtnorm")
sigma <- matrix(c(1,.5,-.5,
                  .5,1,.5,
                  -.5,.5,1), ncol=3)
X <- data.frame(rmvnorm(n=10, sigma=sigma))
get_pairs(X, u="X3", v=c("X1","X2"))
}

