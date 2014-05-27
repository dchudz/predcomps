\name{GetPredCompsDF}
\alias{GetPredCompsDF}
\title{GetApcDF}
\usage{
GetPredCompsDF(model, df, inputVars = NULL, ...)
}
\arguments{
  \item{model}{Either a function (from a data frame to
  vector of predictions) or a model we know how to deal
  with (lm, glm)}

  \item{df}{data frame with data}

  \item{inputVars}{inputs to the model}

  \item{...}{extra parguments passed to GetPairs used to
  control Weight function}
}
\description{
makes average predictive comparison for all specified
inputs
}

