#' Mahal
#'
#' Computes Mahalanobis distance between pairs of observations. I'm using this rather than stats::Mahalanobis because I want just the distances between corresponding rows of each matrix, not all pair-wise distances
#'
#' @param matrix1 nxm matrix or data frame representing 1st set of observations -- each row is an observation; each column is an input feature
#' @param matrix2 nxm matrix or data frame representing 2nd set of observations
#' @param input string representing the name of the input feature you want an APC for
#' @param covariance covariance to be used for Mahalanobis computation
#' @return a vector of Mahalanobis distances between row i of matrix1 and row i of matrix2
Mahal <- function(matrix1, matrix2, covariance) {
  stopifnot(dim(matrix1)==dim(matrix2))
  matrix1 <- as.matrix(matrix1)
  matrix2 <- as.matrix(matrix2)
  covarianceInv <- solve(covariance) #invert covariance matrix
  
  # making this a matrix multication instead of an apply would be the next optimization after removing ddply, I think
  # 
  browser()
  return(
    apply(matrix1-matrix2, 1, function(oneRowDiff) t(oneRowDiff) %*% covarianceInv %*% oneRowDiff)
  )
}

#' GetPairs
#'
#' Form all pairs of rows in X and compute Mahalanobis distances based on \code{v}. 
#' 
#' @param X data frame
#' @param u input of interest
#' @param v other inputs
#' @param mahalanobisConstantTerm Weights are (1 / (mahalanobisConstantTerm + Mahalanobis distance))
#' @param renormalizeWeights whether to renormalize the Weights to that they sum to 1 within each group (groups based on the first element of the pair). If I'm right, there's no reason to use \code{FALSE} ever; I'm only leaving the option in so I can compare with the paper.
#' @return a data frame with the inputs \code{v} from the first of each pair, \code{u} from each half (with ".B" appended to the second), and the Mahalanobis distances between the pairs.
#' @examples
#' library("mvtnorm")
#' sigma <- matrix(c(1,.5,-.5,
#'                   .5,1,.5,
#'                   -.5,.5,1), ncol=3)
#' X <- data.frame(rmvnorm(n=10, sigma=sigma))
#' GetPairs(X, u="X3", v=c("X1","X2"))
#' 
#' @export
GetPairs <- function(X, u, v,
                     mahalanobisConstantTerm=1, 
                     renormalizeWeights=TRUE,
                     removeDiagonal=TRUE) {
  X <- X[c(v,u)]
  X$OriginalRowNumber <- 1:nrow(X)
  pairs <- merge(X,X,by=c(), suffixes=c("",".B"))
  covV=cov(as.matrix(X[,v]))
  mahalanobis <- Mahal(pairs[,v], pairs[,paste0(v,".B")], covV)
  pairs$Weight <- 1/(mahalanobisConstantTerm + mahalanobis)
  if (removeDiagonal) {
    pairs <- subset(pairs, OriginalRowNumber != OriginalRowNumber.B) #remove pairs where both elements are the same
  }
  if (renormalizeWeights) {
    pairs <- ddply(pairs, "OriginalRowNumber", transform, Weight = Weight/sum(Weight))
  } #normalizing AFTER removing pairs from same row as each other
  return(pairs[c("OriginalRowNumber",u,v,paste0(u,".B"),"Weight")]) 
}
