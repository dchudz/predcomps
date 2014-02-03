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
#' Form all pairs of rows in X and compute mahalanobis distances based on \code{v}. 
#' 
#' @param X data frame
#' @param u input of interest
#' @param v other inputs
#' @param weightAsFunctionOfMahalanobis weights to use, expressed as a function of mahalanobis distance
#' @param renormalizeWeights whether to renormalize the weights to that they sum to 1 within each group (groups based on the first element of the pair). If I'm right, there's no reason to use \code{FALSE} ever; I'm only leaving the option in so I can compare with the paper.
#' @return a data frame with the inputs \code{v} from the first of each pair, \code{u} from each half (with ".B" appended to the second), and the mahalanobis distances between the pairs.
#' @examples
#' library("mvtnorm")
#' sigma <- matrix(c(1,.5,-.5,
#'                   .5,1,.5,
#'                   -.5,.5,1), ncol=3)
#' X <- data.frame(rmvnorm(n=10, sigma=sigma))
#' get_pairs(X, u="X3", v=c("X1","X2"))
#' 
get_pairs <- function(X, u, v,
                      samplingProbsAsFunctionOfMahalanobis = function(x) 1/(1+x), 
                      renormalizeWeights=TRUE) {
  X$OriginalRowNumber <- 1:nrow(X)
  pairs <- merge(X,X,by=c(), suffixes=c("",".B"))
  covV=cov(as.matrix(X[,v]))
  pairs$mahalanobis <- mahal(pairs[,v], pairs[,paste0(v,".B")], covV)
  pairsNoId <- subset(pairs, mahalanobis!=0)
  pairsNoId$weight <- samplingProbsAsFunctionOfMahalanobis(pairsNoId$mahalanobis)
  return(pairsNoId) 
}

#' resample_from_pairs
#'
#' form pairs with \code{get_pairs} and resample \code{v} and \code{u} according to a function of the mahalanobis distances (used diagnostics / understanding how things are working)
resample_from_pairs <- function(X, u, v, samplingProbsAsFunctionOfMahalanobis = function(x) 1/(1+x)) {
  pairs <- pairs(X,u,v)
  newX <- get_pairs[sample(1:nrow(pairs), nrow(X), prob=samplingProbsAsFunctionOfMahalanobis(pairs$mahalanobis),replace=FALSE), 
                    c(v,paste(u,"B",sep="."))]
  names(newX) <- c(v,u)
  newX$type <- "resampled"
  X$type <- "original"
  rbind(X,newX)
}