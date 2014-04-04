\name{TransitionPlot}
\alias{TransitionPlot}
\title{ArrowPlot}
\usage{
TransitionPlot(predictionFunction, df, u, v, plot = TRUE)
}
\arguments{
  \item{predictionFunction}{}

  \item{df}{data frame with data}

  \item{u}{input of interest}

  \item{v}{other inputs}
}
\description{
Sampled transitions in
}
\examples{
N <- 100
df <- data.frame(u=rnorm(N), v=rnorm(N))
df$y1 = 2*df$u + 2*df$v + rnorm(N)
lm1 <- lm(y1 ~ u + v, data=df)
print(lm1)
TransitionPlot(function(df) predict(lm1, df), df, "u", "v") + ylab("y1")
df$y2 = df$u + df$v + 2*df$v*df$u + rnorm(N)
lm2 <- lm(y2 ~ u*v, data=df)
print(lm2)
TransitionPlot(function(df) predict(lm2, df), df, "u", "v") + ylab("y2")
}

