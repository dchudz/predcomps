#' GetSingleInputApcs
#' 
#' makes predictive comparison summaries (APC and impact, absolute and signed) by forming an data frame of pairs with appropriate weights and then calling `ComputeApcFromPairs`. 
#' Only works fore continuous inputs right now
#' 
#' @param predictionFunction this could be a function (which takes data frame and makes returns a vector of predictions) or an object of class `lm`, `glm`, or `randomForest`
#' @param X a data frame with all inputs
#' @param u a string naming the input of interest
#' @param v a string naming the other inputs
#' @param ... other arguments to be passed to `GetPairs`
#' @return a list with: \code{signed} (the usual Apc) and \code{absolute} (Apc applied to the absolute value of the differences)
#' 
#' @export
#' 
#' @examples
#' n <- 200
#' x1 <- runif(n = n, min = 0, max = 1)
#' x2 <- runif(n = n, min = 0, max = 1)
#' x3 <- runif(n = n, min = 0, max = 10)
#' y <- 2 * x1 + (-2) * x2 + 1 * x3 + rnorm(n, sd = 0.1)
#' df <- data.frame(x1, x2, x3, y)
#' fittedLm <- lm(y ~ ., data = df)
#' fittedLm
#' GetSingleInputApcs(fittedLm, df, "x2", c("x1", "x3"))
GetSingleInputApcs <- function(predictionFunction, X, u, v, ...) {
  pairs <- GetPairs(X, u, v, ...)
  return(
    list(PerUnitInput.Signed = ComputeApcFromPairs(predictionFunction, pairs, u, v),
         PerUnitInput.Absolute = ComputeApcFromPairs(predictionFunction, pairs, u, v, absolute=TRUE),
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
