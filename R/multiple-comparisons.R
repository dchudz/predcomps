#' GetApcDF
#' 
#' makes average predictive comparison for all specified inputs
#' 
#' @param predictionFunction
#' @param df data frame with data
#' @param inputVars inputs to the model
#' @param ... extra parguments passed to GetPairs used to control Weight function
#' @export
GetApcDF <- function(predictionFunction, df, inputVars, ...) {
  apcList <-  Map(function(currentVar) {
    cat(paste("Working on:", currentVar, "\n"))
    GetAPCWithAbsolute(outputGenerationFunction, 
                       df, 
                       currentVar, 
                       c(setdiff(inputVars, currentVar)),
                       ...)},
    inputVars
  )
  apcDF <- rename(ldply(apcList, data.frame), c(".id"="Input"))
  return(apcDF)
}

