
#' GetApcDF
#' 
#' @export
GetApcDF <- function(outputGenerationFunction, df, inputVars, ...) {
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

