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

  \item{numForTransitionStart}{}

  \item{numForTransitionEnd}{}
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
# Should put unit test example here
}

