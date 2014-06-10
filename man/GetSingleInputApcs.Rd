\name{GetSingleInputApcs}
\alias{GetSingleInputApcs}
\title{GetSingleInputApcs}
\usage{
GetSingleInputApcs(predictionFunction, X, u, v, ...)
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
makes predictive comparison summaries (both per unit input
and impact, both absolute and signed) by forming an data
frame of pairs with appropriate weights and then calling
`ComputeApcFromPairs`. Only works fore continuous inputs
right now
}
\examples{
n <- 200
x1 <- runif(n = n, min = 0, max = 1)
x2 <- runif(n = n, min = 0, max = 1)
x3 <- runif(n = n, min = 0, max = 10)
y <- 2 * x1 + (-2) * x2 + 1 * x3 + rnorm(n, sd = 0.1)
df <- data.frame(x1, x2, x3, y)
fittedLm <- lm(y ~ ., data = df)
fittedLm
GetSingleInputApcs(fittedLm, df, "x2", c("x1", "x3"))
}

