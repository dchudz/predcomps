\name{GetAPC}
\alias{GetAPC}
\title{GetAPC}
\usage{
GetAPC(predictionFunction, X, u, v, ...)
}
\arguments{
  \item{predictionFunction}{}

  \item{X}{}

  \item{u}{input of interest}

  \item{v}{other inputs}

  \item{...}{extra parguments passed to GetPairs used to
  control Weight function}
}
\description{
makes average predictive comparison (based on
Gelman/Pardoe) by forming pairs with two versions of the
input of interest and averaging the predictive difference
using Weights. I think Weights should be an approximation
of the density p(u1,u2|v) or something like that... I need
to look back at this. At present, I believe this is
probably implementing the version in the Gelman/Pardoe
paper.
}
\details{
Only works fore continuous inputs right now
}

