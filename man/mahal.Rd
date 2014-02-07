\name{Mahal}
\alias{Mahal}
\title{Mahal}
\usage{
Mahal(matrix1, matrix2, covariance)
}
\arguments{
  \item{matrix1}{nxm matrix or data frame representing 1st
  set of observations -- each row is an observation; each
  column is an input feature}

  \item{matrix2}{nxm matrix or data frame representing 2nd
  set of observations}

  \item{input}{string representing the name of the input
  feature you want an APC for}

  \item{covariance}{covariance to be used for Mahalanobis
  computation}
}
\value{
a vector of Mahalanobis distances between row i of matrix1
and row i of matrix2
}
\description{
Computes Mahalanobis distance between pairs of
observations. I'm using this rather than stats::Mahalanobis
because I want just the distances between corresponding
rows of each matrix, not all pair-wise distances
}

