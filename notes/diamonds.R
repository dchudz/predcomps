library(randomForest)
library(plyr)
library(predcomps)
library(ggplot2)
diamonds <- transform(diamonds, clarity = 
                        factor(clarity, levels =c("SI1", "SI2", "VS1", "VS2", "VVS1", "VVS2", "IF")))
diamonds2 <- transform(diamonds,
                       clarity = as.integer(clarity),
                       cut = as.integer(cut),
                       color = as.integer(color),
                       volume = x*y*z)
diamonds3 <- subset(diamonds2, !is.na(clarity))

rf <- randomForest(price ~ carat + cut + color + clarity, data=diamonds3, ntree=20)
diamondsSmall <- diamonds3[sample.int(nrow(diamonds3), size=200), ]


apcDf <- GetApcDF(function(df) predict(rf, df), diamondsSmall, inputVars=row.names(rf$importance))
PlotApcDF(apcDf)
  PlotApcDF(apcDf, variant="Apc")



p <- ArrowPlot(function(df) predict(rf, df), diamondsSmall, "carat", c("cut", "color", "clarity"))


partialPlot(rf, diamonds3, "clarity")


?diamonds


hist(diamonds$price)



