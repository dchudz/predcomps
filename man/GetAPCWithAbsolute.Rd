\name{GetAPCWithAbsolute}
\alias{GetAPCWithAbsolute}
\title{GetAPCWithAbsolute}
\usage{
GetAPCWithAbsolute(predictionFunction, X, u, v, ...)
}
\arguments{
  \item{predictionFunction}{}

  \item{X}{}

  \item{u}{input of interest}

  \item{v}{other inputs}

  \item{k}{weights are (1 / (k + Mahalanobis distance))}
}
\value{
a list with: \code{signed} (the usual APC) and
\code{absolute} (APC applied to the absolute value of the
differences)
}
\description{
makes average predictive comparison (based on
Gelman/Pardoe) by forming pairs with two versions of the
input of interest and averaging the predictive difference
using weights. I think weights should be an approximation
of the density p(u1,u2|v) or something like that... I need
to look back at this. At present, I believe this is
probably implementing the version in the Gelman/Pardoe
paper. returns a list with the APC and the APC applied to
the absolute value of the prediction function Only works
fore continuous inputs right now
}

