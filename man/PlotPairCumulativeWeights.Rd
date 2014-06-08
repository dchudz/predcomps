\name{PlotPairCumulativeWeights}
\alias{PlotPairCumulativeWeights}
\title{PlotPairCumulativeWeights}
\usage{
PlotPairCumulativeWeights(pairs, numOriginalRowNumbersToPlot = 20)
}
\description{
For a sample of transition start rows, we plot rank of
transition end (by increasing weight) vs. cumulative
weight. This gives a sense of how much weight is going into
the nearest points vs. further ones.
}
\examples{
v <- rnorm(100)
u <- v + 0.3*rnorm(100)
X = data.frame(v=v,u=u)
pairsDF <- GetPairs(X, "v", "u")
pairsDFRow1 <- subset(pairsDF, OriginalRowNumber==1)
# For most original rows, we get 75\% of the weight in 50\% of the pairs:
PlotPairCumulativeWeights(pairsDF)
}

