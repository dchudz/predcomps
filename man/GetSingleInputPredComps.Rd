\name{GetSingleInputPredComps}
\alias{GetSingleInputPredComps}
\title{GetComparisonDF}
\usage{
GetSingleInputPredComps(predictionFunction, X, u, v, ...)
}
\arguments{
  \item{predictionFunction}{}

  \item{X}{}

  \item{u}{input of interest}

  \item{v}{other inputs}

  \item{k}{Weights are (1 / (k + Mahalanobis distance))}
}
\value{
a list with: \code{signed} (the usual Apc) and
\code{absolute} (Apc applied to the absolute value of the
differences)
}
\description{
makes average predictive comparison (based on
Gelman/Pardoe) by forming pairs with two versions of the
input of interest and averaging the predictive difference
using Weights. I think Weights should be an approximation
of the density p(u1,u2|v) or something like that... I need
to look back at this. At present, I believe this is
probably implementing the version in the Gelman/Pardoe
paper. returns a list with the Apc and the Apc applied to
the absolute value of the prediction function Only works
fore continuous inputs right now
}

