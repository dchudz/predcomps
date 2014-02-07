#' AverageSpecifiedComparison
#'
#' Makes an average predictive comparison for two specified values of the input variable of interest, as in section 5.7 of ARM
#'
#' @param fit fitted glm object
#' @param df data frame for evaluating predictions
#' @param input string representing the name of the input feature you want an APC for
#' @param low low value of input feature
#' @param high high value of input feature
#' @export
AverageSpecifiedComparison <- function(fit, df, input, low, high) {
  dfHigh <- df
  dfLow <- df
  dfHigh[[input]] <- rep(high, nrow(df))
  dfLow[[input]] <- rep(low, nrow(df))
  return( 
    mean(predict.glm(fit, dfHigh, type="response") - predict(fit, dfLow, type="response"))
  )
}


#' GetAPC
#' 
#' makes average predictive comparison (based on Gelman/Pardoe) by forming pairs with two versions of the input of interest and averaging the predictive difference using weights. I think weights should be an approximation of the density p(u1,u2|v) or something like that... I need to look back at this. At present, I believe this is probably implementing the version in the Gelman/Pardoe paper.
#' 
#' Only works fore continuous inputs right now
#' 
#' 
#' @param predictionFunction
#' @param X 
#' @param u input of interest
#' @param v other inputs
#' @param ... extra parguments passed to GetPairs used to control weight function
#' @export
GetAPC <- function(predictionFunction, X, u, v, ...) {
  pairs <- GetPairs(X, u, v, ...)
  return(ComputeAPCFromPairs(predictionFunction, pairs, u, v))
}

#' GetAPCWithAbsolute
#' 
#' makes average predictive comparison (based on Gelman/Pardoe) by forming pairs with two versions of the input of interest and averaging the predictive difference using weights. I think weights should be an approximation of the density p(u1,u2|v) or something like that... I need to look back at this. At present, I believe this is probably implementing the version in the Gelman/Pardoe paper.
#' returns a list with the APC and the APC applied to the absolute value of the prediction function
#' Only works fore continuous inputs right now
#' 
#' @param predictionFunction
#' @param X 
#' @param u input of interest
#' @param v other inputs
#' @param k weights are (1 / (k + Mahalanobis distance))
#' @return a list with: \code{signed} (the usual APC) and \code{absolute} (APC applied to the absolute value of the differences)
#' @export
GetAPCWithAbsolute <- function(predictionFunction, X, u, v, ...) {
  pairs <- GetPairs(X, u, v)
  return(
    list(Signed = ComputeAPCFromPairs(predictionFunction, pairs, u, v),
         Absolute = ComputeAPCFromPairs(predictionFunction, pairs, u, v, absolute=TRUE))
  )
}

#' ComputeAPCFromPairs
#' 
#' (abstracted this into a separate function from \code{GetAPC} so we can more easily do things 
#' like \code{GetAPCWithAbsolute})
#' @export
ComputeAPCFromPairs <- function(predictionFunction, pairs, u, v, absolute=FALSE) UseMethod("ComputeAPCFromPairs")
  
# Two methods:
#  one for predictionFunction (df |--> predictions)
#  another for a glm object

ComputeAPCFromPairs.function <- function(predictionFunction, pairs, u, v, absolute=FALSE) {
  uNew <- paste(u,".B",sep="")
  yHat1 <- predictionFunction(pairs)
  pairsNew <- structure(pairs[,c(v,uNew)], names=c(v,u)) #renaming u in pairsNew so we can call predictionFunction
  yHat2 <- predictionFunction(pairsNew)
  uDiff <- pairs[[uNew]] - pairs[[u]]
  w <- pairs$Weight
  absoluteOrIdentity <- if (absolute) abs else identity
  APC <- sum(absoluteOrIdentity(w * (yHat2 - yHat1) * sign(uDiff))) / sum(w * uDiff * sign(uDiff))
  return(APC)
}

ComputeAPCFromPairs.glm <- function(glmFit, pairs, u, v, absolute=FALSE) {
  predictionFunction <- function(df) predict.glm(glmFit, df)
  return(
    ComputeAPCFromPairs.function(predictionFunction, pairs, u, v, absolute=FALSE)
    ) 
}
