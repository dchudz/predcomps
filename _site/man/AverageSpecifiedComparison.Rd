\name{AverageSpecifiedComparison}
\alias{AverageSpecifiedComparison}
\title{AverageSpecifiedComparison}
\usage{
AverageSpecifiedComparison(fit, df, input, low, high)
}
\arguments{
  \item{fit}{fitted glm object}

  \item{df}{data frame for evaluating predictions}

  \item{input}{string representing the name of the input
  feature you want an APC for}

  \item{low}{low value of input feature}

  \item{high}{high value of input feature}
}
\description{
Makes an average predictive comparison for two specified
values of the input variable of interest, as in section 5.7
of ARM
}

