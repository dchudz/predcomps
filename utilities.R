requireInstall <- function(packageName) {
  if(!packageName %in% rownames(installed.packages())) install.packages(packageName)
  base::require(packageName, character.only=TRUE)
}


mahalanobis <- function(matrix1, matrix2, covariance) {
  #rows of matrix1, matrix2 are observations; columns are features
  #I'll convert to matrices so that we can use data frames as arguments if we want:
  matrix1 <- as.matrix(matrix1)
  matrix2 <- as.matrix(matrix2)
  covarianceInv <- solve(covariance)
  apply(matrix1-matrix2, 1, function(oneRowDiff) t(oneRowDiff) %*% covarianceInv %*% oneRowDiff)
}

getPairs <- function(X,u,v) {
  pairs <- merge(X,X,by=c(), suffixes=c("",".B"))
  covV=cov(as.matrix(X[,v]))
  pairs$mahalanobis <- mahalanobis(pairs[,v], pairs[,paste(v,".B",sep="")], covV)
  pairsNoId <- subset(pairs, mahalanobis!=0)
  pairsNoId[,c(v,u,paste(u,".B",sep=""), "mahalanobis")]
}


getXAndResampledXMerged <- function(X, u, v, samplingProbsAsFunctionOfMahalanobis = function(x) 1/(1+x)) {
  pairs <- getPairs(X,u,v)
  newX <- pairs[sample(1:nrow(pairs), nrow(X), prob=samplingProbsAsFunctionOfMahalanobis(pairs$mahalanobis),replace=FALSE), 
                c(v,paste(u,"B",sep="."))]
  names(newX) <- c(v,u)
  newX$type <- "resampled"
  X$type <- "original"
  rbind(X,newX)
}