#' average_specified_comparison
#'
#' Makes an average predictive comparison for two specified values of the input variable of interest
#'
#' @param fit fitted glm object
#' @param df data frame for evaluating predictions
#' @param input string representing the name of the input feature you want an APC for
#' @param low low value of input feature
#' @param high high value of input feature
#' @examples
#' print("hi")
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


#X is a data frame with all of the inputs
#predictionFunction is a function that can predict the output from a data frame with all inputs
#u is the input to vary
#v are the inputs not to vary
#weights default to 1/(1+(squared mahalanobis distance)) -- but you can specify some other function of mahalanobis
getAPC <- function(predictionFunction, X, u, v, weightAsFunctionOfMahalanobis = function(x) 1/(1+x)) {
  uNew <- paste(u,".B",sep="")
  pairs <- getPairs(X,u,v)  
  yHat1 <- predictionFunction(pairs)
  pairsNew <- pairs[,c(v,uNew)]
  names(pairsNew)[which(names(pairsNew)==uNew)] = u
  yHat2 <- predictionFunction(pairsNew)
  uDiff <- pairs[[uNew]] - pairs[[u]]
  w <- weightAsFunctionOfMahalanobis(pairs$mahalanobis)
  APC <- sum(w * (yHat2 - yHat1) * sign(uDiff)) / sum(w * uDiff * sign(uDiff))
  list(APC=APC, pairsDF=pairs, weights=w)
}
