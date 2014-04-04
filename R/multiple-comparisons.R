#' GetApcDF
#' 
#' makes average predictive comparison for all specified inputs
#' 
#' @param predictionFunction
#' @param df data frame with data
#' @param inputVars inputs to the model
#' @param ... extra parguments passed to GetPairs used to control Weight function
#' @export
GetPredCompsDF <- function(predictionFunction, df, inputVars, ...) {
  apcList <-  Map(function(currentVar) {
    cat(paste("Working on:", currentVar, "\n"))
    GetSingleInputPredComps(predictionFunction, 
                       df, 
                       currentVar, 
                       c(setdiff(inputVars, currentVar)),
                       ...)},
    inputVars
  )
  apcDF <- rename(ldply(apcList, data.frame), c(".id"="Input"))  
  return(apcDF)
}

#' PlotApcDF
#' 
#' plots the output of GetApcDF -- this is my preferred display for now
#' 
#' @param apcDF the output of GetApcDF
#' @export
PlotPredCompsDF <- function(apcDF, variant="Impact") {
  
  apcDF <- apcDF[c("Input", grep(paste0("^",variant,"\\."), names(apcDF), value=TRUE))]
  names(apcDF) <- gsub(paste0("^",variant,"\\."), "", names(apcDF))
  
  maxAPC <- max(abs(apcDF$Absolute))  
  apcDF$Input <- reorder(apcDF$Input, apcDF$Absolute)
  longAPCs <- melt(apcDF, id="Input", value.name = "Value", variable.name = "Type")
  longAPCs2 <- rbind(
    longAPCs,
    transform(subset(longAPCs, Type=="Absolute"), Value=-Value)
  )
  longAPCs2 <- longAPCs2[order(factor(longAPCs2$Type, levels=c("Absolute", "Signed"))), ]  
  print(
    ggplot(longAPCs2) +
      geom_point(aes(y = Input, x=Value, color=Type, shape=Type, size=Type)) +
      scale_x_continuous(limits=c(-maxAPC, maxAPC)) +
      scale_size_discrete(range=c(3,4)) +
      ggtitle(variant) +
      geom_vline(aes(xintercept=0), alpha=.5)
  )  
}