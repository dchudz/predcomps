\name{get_apc}
\alias{get_apc}
\title{get_apc}
\usage{
get_apc(predictionFunction, X, u, v,
  weightAsFunctionOfMahalanobis = function(x) 1/(1 + x),
  renormalizeWeights = TRUE)
}
\arguments{
  \item{predictionFunction}{}

  \item{X}{}

  \item{u}{input of interest}

  \item{v}{other inputs}

  \item{weightAsFunctionOfMahalanobis}{weights to use,
  expressed as a function of mahalanobis distance}
}
\value{
a list with:
}
\description{
makes average predictive comparison (based on
Gelman/Pardoe) by forming pairs with two versions of the
input of interest and averaging the predictive difference
using weights. I think weights should be an approximation
of the density p(u1,u2|v) or something like that... I need
to look back at this. At present, I believe this is
probably implementing the version in the Gelman/Pardoe
paper.
}
\details{
Only works fore continuous inputs right now
}

