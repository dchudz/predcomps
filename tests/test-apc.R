library(testthat)
library(predcomps)

test_that("APC matches coefficient exactly for linear model", {
  
  df <- data.frame(X = rep(c(1,2),2),
                   Y = c(1,2,3,4))
  
  predictionFunction <- function(df) 2*df$X + 3*df$Y
  result <- GetSingleInputPredComps(predictionFunction, df, u="X", v="Y")
  expect_that(result$Apc.Signed, equals(2)) 
})