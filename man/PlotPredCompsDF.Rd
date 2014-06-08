\name{PlotPredCompsDF}
\alias{PlotPredCompsDF}
\title{PlotApcDF}
\usage{
PlotPredCompsDF(apcDF, variant = "Impact")
}
\arguments{
  \item{apcDF}{the output of GetApcDF}
}
\description{
plots the output of GetApcDF -- this is my preferred
display for now
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
PlotPredCompsDF(apcDF, variant = "PerUnitInput") + theme_gray(base_size = 18)
}

