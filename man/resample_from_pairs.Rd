\name{resample_from_pairs}
\alias{resample_from_pairs}
\title{resample_from_pairs}
\usage{
resample_from_pairs(X, u, v,
  samplingProbsAsFunctionOfMahalanobis = function(x) 1/(1 + x))
}
\description{
form pairs with \code{get_pairs} and resample \code{v} and
\code{u} according to a function of the mahalanobis
distances (used diagnostics / understanding how things are
working)
}

