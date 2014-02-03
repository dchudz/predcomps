#' average_specified_comparison
#'
#' Makes an average predictive comparison for two specified values of the input variable of interest, as in section 5.7 of ARM
#'
#' @param fit fitted glm object
#' @param df data frame for evaluating predictions
#' @param input string representing the name of the input feature you want an APC for
#' @param low low value of input feature
#' @param high high value of input feature
#' @export
average_specified_comparison <- function(fit, df, input, low, high) {
  dfHigh <- df
  dfLow <- df
  dfHigh[[input]] <- rep(high, nrow(df))
  dfLow[[input]] <- rep(low, nrow(df))
  return( 
    mean(predict.glm(fit, dfHigh, type="response") - predict(fit, dfLow, type="response"))
  )
}


#' get_apc
#' 
#' makes average predictive comparison (based on Gelman/Pardoe) by forming pairs with two versions of the input of interest and averaging the predictive difference using weights. I think weights should be an approximation of the density p(u1,u2|v) or something like that... I need to look back at this. At present, I believe this is probably implementing the version in the Gelman/Pardoe paper.
#' 
#' Only works fore continuous inputs right now
#' 
#' @param predictionFunction
#' @param X 
#' @param u input of interest
#' @param v other inputs
#' @param weightAsFunctionOfMahalanobis weights to use, expressed as a function of mahalanobis distance
#' @export
get_apc <- function(predictionFunction, X, u, v, 
                    weightAsFunctionOfMahalanobis = function(x) 1/(1+x),
                    renormalizeWeights=TRUE) {
  pairs <- get_pairs(X,u,v,
                     weightAsFunctionOfMahalanobis=weightAsFunctionOfMahalanobis,
                     renormalizeWeights=renormalizeWeights)
  return(compute_apc_from_pairs(predictionFunction, pairs, u, v))
}

#' get_apc_with_absolute
#' 
#' makes average predictive comparison (based on Gelman/Pardoe) by forming pairs with two versions of the input of interest and averaging the predictive difference using weights. I think weights should be an approximation of the density p(u1,u2|v) or something like that... I need to look back at this. At present, I believe this is probably implementing the version in the Gelman/Pardoe paper.
#' returns a list with the APC and the APC applied to the absolute value of the prediction function
#' Only works fore continuous inputs right now
#' 
#' @param predictionFunction
#' @param X 
#' @param u input of interest
#' @param v other inputs
#' @param weightAsFunctionOfMahalanobis weights to use, expressed as a function of mahalanobis distance
#' @return a list with: \code{signed} (the usual APC) and \code{absolute} (APC applied to the absolute value of the differences)
#' @export
get_apc_with_absolute <- function(predictionFunction, X, u, v, 
                    weightAsFunctionOfMahalanobis = function(x) 1/(1+x),
                    renormalizeWeights=TRUE) {
  pairs <- get_pairs(X,u,v,
                     weightAsFunctionOfMahalanobis=weightAsFunctionOfMahalanobis,
                     renormalizeWeights=renormalizeWeights)
  return(
    list(Signed = compute_apc_from_pairs(predictionFunction, pairs, u, v),
         Absolute = compute_apc_from_pairs(predictionFunction, pairs, u, v, absolute=TRUE))
  )
}


#' compute_apc_from_pairs
#' 
#' (abstracted this into a separate function from \code{get_apc} so we can more easily do things 
#' like \code{get_apc_with_absolute})
compute_apc_from_pairs <- function(predictionFunction, pairs, u, v, absolute=FALSE) {
  uNew <- paste(u,".B",sep="")
  yHat1 <- predictionFunction(pairs)
  pairsNew <- structure(pairs[,c(v,uNew)], names=c(v,u)) #renaming u in pairsNew so we can call predictionFunction
  yHat2 <- predictionFunction(pairsNew)
  uDiff <- pairs[[uNew]] - pairs[[u]]
  w <- pairs$weight
  absoluteOrIdentity <- if (absolute) abs else identity
  APC <- sum(absoluteOrIdentity(w * (yHat2 - yHat1) * sign(uDiff))) / sum(w * uDiff * sign(uDiff))
}