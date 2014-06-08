\name{GetPairs}
\alias{GetPairs}
\title{GetPairs}
\usage{
GetPairs(X, u, v, numForTransitionStart = NULL, numForTransitionEnd = NULL,
  onlyIncludeNearestN = NULL, mahalanobisConstantTerm = 1)
}
\arguments{
  \item{X}{data frame}

  \item{u}{input of interest}

  \item{v}{other inputs}

  \item{mahalanobisConstantTerm}{Weights are (1 /
  (mahalanobisConstantTerm + Mahalanobis distance))}

  \item{numForTransitionStart}{number of rows to use as the
  start points of transitions (defaulting to `NULL`, we use
  all rows)}

  \item{numForTransitionEnd}{number of rows to use as
  potential end points of transitions (defaulting to
  `NULL`, we use all rows)}

  \item{onlyIncludeNearestN}{for each transition start, we
  only include as transition end points the nearest
  `onlyIncludeNearestN` rows (defaulting to `NULL`, we use
  all rows)}
}
\value{
a data frame with the inputs \code{v} from the first of
each pair, \code{u} from each half (with ".B" appended to
the second), and the Mahalanobis distances between the
pairs.
}
\description{
Form all pairs of rows in \code{X} and compute Mahalanobis
distances based on \code{v}.
}
\details{
To help with computational constraints, you have the option
to not form pairs between all rows of \code{X} but instead
of specify a certain number (\code{numForTransitionStart})
to randomly be selected as rows from which transitions
start, and another number (\code{numForTransitionEnd}) to
be randomly selected as where transitions end. We then form
all pairs between transition-start rows and transition-end
rows.

In order to get a smaller data frame for later
manipulations (and maybe just because it's a good idea),
you can also specify \code{onlyIncludeNearestN}, in which
case we return only the nearest \code{onlyIncludeNearestN}
transition ends for each transition start (instead of all
pairs).
}
\examples{
v <- rnorm(100)
u <- v + 0.3*rnorm(100)
qplot(v,u)
X = data.frame(v=v,u=u)
pairsDF <- GetPairs(X, "v", "u")
pairsDFRow1 <- subset(pairsDF, OriginalRowNumber==1)
# When we subset to one "original row number", all of the v's are the same:
print(pairsDFRow1$v)
# ... and u's corresponding to closer v.B (the v in the second element of the pair) have higher weight:
qplot(u.B, Weight, data=pairsDFRow1)
}

