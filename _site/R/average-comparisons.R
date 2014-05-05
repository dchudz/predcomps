#' GetComparisonDF
#' 
#' makes average predictive comparison (based on Gelman/Pardoe) by forming pairs with two versions of the input of interest and averaging the predictive difference using Weights. I think Weights should be an approximation of the density p(u1,u2|v) or something like that... I need to look back at this. At present, I believe this is probably implementing the version in the Gelman/Pardoe paper.
#' returns a list with the Apc and the Apc applied to the absolute value of the prediction function
#' Only works fore continuous inputs right now
#' 
#' @param predictionFunction
#' @param X 
#' @param u input of interest
#' @param v other inputs
#' @param k Weights are (1 / (k + Mahalanobis distance))
#' @return a list with: \code{signed} (the usual Apc) and \code{absolute} (Apc applied to the absolute value of the differences)
#' @export
GetSingleInputPredComps <- function(predictionFunction, X, u, v, ...) {
  pairs <- GetPairs(X, u, v, ...)
  return(
    list(Apc.Signed = ComputeApcFromPairs(predictionFunction, pairs, u, v),
         Apc.Absolute = ComputeApcFromPairs(predictionFunction, pairs, u, v, absolute=TRUE),
         Impact.Signed = ComputeApcFromPairs(predictionFunction, pairs, u, v, impact=TRUE),
         Impact.Absolute = ComputeApcFromPairs(predictionFunction, pairs, u, v, absolute=TRUE, impact=TRUE))
  )
}


#' ComputeApcFromPairs
#' 
#' @export
ComputeApcFromPairs <- function(predictionFunction, pairs, u, v, absolute=FALSE, impact=FALSE) {
  uNew <- paste(u,".B",sep="")
  ComparisonDF <- GetComparisonDFFromPairs(predictionFunction, pairs, u, v)
  absoluteOrIdentity <- if (absolute) abs else identity
  uDiff <- ComparisonDF[[uNew]] - ComparisonDF[[u]]
  denom <- if (impact) sum(ComparisonDF$Weight) else sum(ComparisonDF$Weight * uDiff * sign(uDiff))
  Apc <- sum(absoluteOrIdentity(ComparisonDF$Weight * (ComparisonDF$yHat2 - ComparisonDF$yHat1) * sign(uDiff))) / denom
  return(Apc)
}


#' GetComparisonDFFromPairs
#' 
#' (abstracted this into a separate function from \code{GetApc} so we can more easily do things 
#' like \code{GetApcWithAbsolute})
#' @export
GetComparisonDFFromPairs <- function(predictionFunction, pairs, u, v) UseMethod("GetComparisonDFFromPairs")



# Two methods:
#  one for predictionFunction (df |--> predictions)
#  another for a glm object

#' @export
GetComparisonDFFromPairs.function <- function(predictionFunction, pairs, u, v) {
  uNew <- paste(u,".B",sep="")
  pairs$yHat1 <- predictionFunction(pairs)
  pairsNew <- structure(pairs[,c(v,uNew)], names=c(v,u)) #renaming u in pairsNew so we can call predictionFunction
  pairs$yHat2 <- predictionFunction(pairsNew)  
  return(pairs)
}

#' @export
GetComparisonDFFromPairs.glm <- function(glmFit, pairs, u, v) {
  predictionFunction <- function(df) predict.glm(glmFit, newdata=df, type="response")
  return(
    GetComparisonDFFromPairs.function(predictionFunction, pairs, u, v)
  ) 
}

#' @export
GetComparisonDFFromPairs.lm <- function(lmFit, pairs, u, v) {
  predictionFunction <- function(df) predict.glm(lmFit, newdata=df)
  return(
    GetComparisonDFFromPairs.function(predictionFunction, pairs, u, v)
  ) 
}

#' @export
GetComparisonDFFromPairs.randomForest <- function(rfFit, pairs, u, v) {
  # For classification, we need to specify that the predictions should be probabilties (not classes)
  if (rfFit$type == "classification") { 
    if (length(rfFit$classes) > 2) {
      stop("Sorry, I don't know what to do when there are more than 2 classes.")
    }
    predictionFunction <- function(df) predict(rfFit, newdata=df, type="prob")[,2]
  } else
  {
    predictionFunction <- function(df) predict(rfFit, newdata=df)
  }
  return(
    GetComparisonDFFromPairs.function(predictionFunction, pairs, u, v)
  ) 
}


#' @export
GetComparisonDF <- function(predictionFunction, df, u, v=NULL, ...) {
  if (is.null(v)) {
    inputNames <- GetInputVarsFromModel(predictionFunction)
    v <- setdiff(inputNames, u)
  }
  pairs <- GetPairs(df, u, v, ...)
  ComparisonDF <- GetComparisonDFFromPairs(predictionFunction, pairs, u, v)
}