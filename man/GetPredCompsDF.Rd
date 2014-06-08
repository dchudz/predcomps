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
\examples{
n <- 200
x1 <- runif(n = n, min = 0, max = 1)
x2 <- runif(n = n, min = 0, max = 1)
x3 <- runif(n = n, min = 0, max = 10)
y <- 2 * x1 + (-2) * x2 + 1 * x3 + rnorm(n, sd = 0.1)
df <- data.frame(x1, x2, x3, y)
fittedLm <- lm(y ~ ., data = df)
apcDF <- GetPredCompsDF(fittedLm, df = df)
apcDF
}

