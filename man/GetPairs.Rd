\name{GetPairs}
\alias{GetPairs}
\title{GetPairs}
\usage{
GetPairs(X, u, v, mahalanobisConstantTerm = 1, renormalizeWeights = TRUE,
  removeDiagonal = TRUE)
}
\arguments{
  \item{X}{data frame}

  \item{u}{input of interest}

  \item{v}{other inputs}

  \item{mahalanobisConstantTerm}{Weights are (1 /
  (mahalanobisConstantTerm + Mahalanobis distance))}

  \item{renormalizeWeights}{whether to renormalize the
  Weights to that they sum to 1 within each group (groups
  based on the first element of the pair). If I'm right,
  there's no reason to use \code{FALSE} ever; I'm only
  leaving the option in so I can compare with the paper.}
}
\value{
a data frame with the inputs \code{v} from the first of
each pair, \code{u} from each half (with ".B" appended to
the second), and the Mahalanobis distances between the
pairs.
}
\description{
Form all pairs of rows in X and compute Mahalanobis
distances based on \code{v}.
}
\examples{
library("mvtnorm")
sigma <- matrix(c(1,.5,-.5,
                  .5,1,.5,
                  -.5,.5,1), ncol=3)
X <- data.frame(rmvnorm(n=10, sigma=sigma))
GetPairs(X, u="X3", v=c("X1","X2"))
}

