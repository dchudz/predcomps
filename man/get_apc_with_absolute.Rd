\name{get_apc_with_absolute}
\alias{get_apc_with_absolute}
\title{get_apc_with_absolute}
\usage{
get_apc_with_absolute(predictionFunction, X, u, v,
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

