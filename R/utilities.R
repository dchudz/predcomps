#' mahal
#'
#' Computes mahalanobis distance between pairs of observations. I'm using this rather than stats::mahalanobis because I want just the distances between corresponding rows of each matrix, not all pair-wise distances
#'
#' @param matrix1 nxm matrix or data frame representing 1st set of observations -- each row is an observation; each column is an input feature
#' @param matrix2 nxm matrix or data frame representing 2nd set of observations
#' @param input string representing the name of the input feature you want an APC for
#' @param covariance covariance to be used for mahalanobis computation
#' @return a vector of mahalanobis distances between row i of matrix1 and row i of matrix2
mahal <- function(matrix1, matrix2, covariance) {
  stopifnot(dim(matrix1)==dim(matrix2))
  matrix1 <- as.matrix(matrix1)
  matrix2 <- as.matrix(matrix2)
  covarianceInv <- solve(covariance) #invert covariance matrix
  return(
    apply(matrix1-matrix2, 1, function(oneRowDiff) t(oneRowDiff) %*% covarianceInv %*% oneRowDiff)
  )
}

#' get_pairs
#'
#' @param covariance covariance to be used for mahalanobis computation
#' @param high high value of input feature
#' @return a vector of mahalanobis distances between row i of matrix1 and row i of matrix2
#' @example

# library("mvtnorm")
# sigma <- matrix(c(1,.5,-.5,
#                   .5,1,.5,
#                   -.5,.5,1), ncol=3)
# X <- data.frame(rmvnorm(n=10, sigma=sigma))
# get_pairs(X, u="X3", v=c("X1","X2"))
# 
# get_pairs <- function(X,u,v) {
#   pairs <- merge(X,X,by=c(), suffixes=c("",".B"))
#   covV=cov(as.matrix(X[,v]))
#   pairs$mahalanobis <- mahal(pairs[,v], pairs[,paste(v,".B",sep="")], covV)
#   pairsNoId <- subset(pairs, mahalanobis!=0)
#   pairsNoId[,c(v,u,paste(u,".B",sep=""), "mahalanobis")]
# }

getXAndResampledXMerged <- function(X, u, v, samplingProbsAsFunctionOfMahalanobis = function(x) 1/(1+x)) {
  pairs <- getPairs(X,u,v)
  newX <- pairs[sample(1:nrow(pairs), nrow(X), prob=samplingProbsAsFunctionOfMahalanobis(pairs$mahalanobis),replace=FALSE), 
                c(v,paste(u,"B",sep="."))]
  names(newX) <- c(v,u)
  newX$type <- "resampled"
  X$type <- "original"
  rbind(X,newX)
}