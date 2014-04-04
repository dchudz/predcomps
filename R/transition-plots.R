#' ArrowPlot
#' 
#' Sampled transitions in 
#' 
#' @param predictionFunction
#' @param df data frame with data
#' @param u input of interest
#' @param v other inputs
#' @export
#' @examples
#' N <- 100
#' df <- data.frame(u=rnorm(N), v=rnorm(N))
#' df$y1 = 2*df$u + 2*df$v + rnorm(N)
#' lm1 <- lm(y1 ~ u + v, data=df)
#' print(lm1)
#' TransitionPlot(function(df) predict(lm1, df), df, "u", "v") + ylab("y1")
#' df$y2 = df$u + df$v + 2*df$v*df$u + rnorm(N)
#' lm2 <- lm(y2 ~ u*v, data=df)
#' print(lm2)
#' TransitionPlot(function(df) predict(lm2, df), df, "u", "v") + ylab("y2")
TransitionPlot <- function(predictionFunction, df, u, v, plot=TRUE) {
  pairs <- GetPairs(df, u, v)
  
  pairsToPlot <- ddply(pairs[pairs[[paste0(u,".B")]] > pairs[[u]], ], 
                       "OriginalRowNumber", function(df) {
                         df[sample.int(nrow(df), size=1, prob=df$Weight), ]
                       })
  
  pairsToPlot$output <- predictionFunction(pairsToPlot)
  pairsToPlot2 <- pairsToPlot
  pairsToPlot2[[u]] <- pairsToPlot2[[paste0(u,".B")]]
  pairsToPlot$outputNew <- predictionFunction(pairsToPlot2)  
  
  p <- ggplot(pairsToPlot) +
    geom_segment(aes_string(x = u, y = "output", xend = paste0(u,".B"), yend = "outputNew"),  arrow = arrow()) + 
    ggtitle(sprintf("Transitions in %s holding %s constant", u, Reduce(paste, v)))
  if(plot) print(p)
  return(p)
}
