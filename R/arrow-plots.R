#' ArrowPlot
#' 
#' Sampled transitions in 
#' 
#' @param predictionFunction
#' @param df data frame with data
#' @param u input of interest
#' @param v other inputs
#' @export
ArrowPlot <- function(predictionFunction, df, u, v) {
  #browser()
  pairs <- GetPairs(df, u, v)
  
  pairsToPlot <- ddply(pairs[pairs[[paste0(u,".B")]] > pairs[[u]], ], 
                       "OriginalRowNumber", function(df) {
                         df[sample.int(nrow(df), size=1, prob=df$Weight), ]
                       })
  
  pairsToPlot$yOld <- predict(rf, pairsToPlot)
  pairsToPlot2 <- pairsToPlot
  pairsToPlot2[[u]] <- pairsToPlot2[[paste0(u,".B")]]
  
  pairsToPlot$yNew <- predict(rf, pairsToPlot2)
  
  
  
  p <- ggplot(pairsToPlot) +
    geom_segment(aes_string(x = u, y = "yOld", xend = paste0(u,".B"), yend = "yNew"), 
                 arrow = arrow(length = unit(0.5, "cm")) )
  print(p)
  return(p)
}
