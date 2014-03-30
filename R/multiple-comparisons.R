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
    GetAPCWithAbsolute(predictionFunction, 
                       df, 
                       currentVar, 
                       c(setdiff(inputVars, currentVar)),
                       ...)},
    inputVars
  )
  apcDF <- rename(ldply(apcList, data.frame), c(".id"="Input"))
  
  apcDF$Input <- reorder(factor(apcDF$Input), apcDF$Absolute, FUN = function(x) mean(abs(x))) 
  
  return(apcDF)
}

#' PlotApcDF
#' 
#' plots the output of GetApcDF -- this is my preferred display for now
#' 
#' @param apcDF the output of GetApcDF
#' @export
PlotApcDF <- function(apcDF) {
  maxAPC <- max(abs(apcDF$Absolute))  
  longAPCs <- melt(apcDF, id="Input", value.name = "APC", variable.name = "Type")
  longAPCs2 <- rbind(
    longAPCs,
    transform(subset(longAPCs, Type=="Absolute"), APC=-APC)
  )
  longAPCs2 <- longAPCs2[order(factor(longAPCs2$Type, levels=c("Absolute", "Signed"))), ]  
  print(
    ggplot(longAPCs2) +
      geom_point(aes(y = Input, x=APC, color=Type, shape=Type, size=Type)) +
      scale_x_continuous(limits=c(-maxAPC, maxAPC)) +
      scale_size_discrete(range=c(3,4)) +
      ggtitle("APCs") +
      geom_vline(aes(xintercept=0), alpha=.5)
  )  
}


#' PlotApcDF
#' 
#' plots the output of GetApcDF -- this is not my preferred display but may be more self-explanatory
#' 
#' @param apcDF the output of GetApcDF
#' @export
PlotApcDF2 <- function(apcDF) {
  maxAPC <- max(abs(apcDF$Absolute))
  longAPCs <- melt(apcDF, id="Input", value.name = "APC", variable.name = "Type")
  apcDFList <- split(longAPCs, longAPCs$Type)
  p <- arrangeGrob(
    ggplot(apcDFList$Signed) + 
      geom_point(aes(y = Input, x=APC)) + 
      ggtitle("Signed APC") +  
      scale_x_continuous(limits=c(-maxAPC, maxAPC)) +
      geom_vline(aes(xintercept=0), alpha=.5),
    ggplot(apcDFList$Absolute) + geom_point(aes(y = Input, x=APC)) + ggtitle("Absolute APC") + scale_x_continuous(limits=c(-maxAPC, maxAPC)),
    ncol=2,nrow=1
  ) 
  print(p)
}