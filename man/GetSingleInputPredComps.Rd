\name{GetSingleInputPredComps}
\alias{GetSingleInputPredComps}
\title{GetSingleInputPredComps}
\usage{
GetSingleInputPredComps(predictionFunction, X, u, v, ...)
}
\arguments{
  \item{predictionFunction}{this could be a function (which
  takes data frame and makes returns a vector of
  predictions) or an object of class `lm`, `glm`, or
  `randomForest`}

  \item{X}{a data frame with all inputs}

  \item{u}{a string naming the input of interest}

  \item{v}{a string naming the other inputs}

  \item{...}{other arguments to be passed to `GetPairs`}
}
\value{
a list with: \code{signed} (the usual Apc) and
\code{absolute} (Apc applied to the absolute value of the
differences)
}
\description{
makes predictive comparison summaries (APC and impact,
absolute and signed) by forming an data frame of pairs with
appropriate weights and then calling `ComputeApcFromPairs`.
Only works fore continuous inputs right now
}

