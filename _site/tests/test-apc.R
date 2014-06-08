test_that("APC matches coefficient exactly for linear model", {
  
  df <- data.frame(X = rep(c(1,2),2),
                   Y = c(1,2,3,4))
  
  predictionFunction <- function(df) 2*df$X + 3*df$Y
  result <- GetSingleInputApcs(predictionFunction, df, u="X", v="Y")
  expect_that(result$PerUnitInput.Signed, equals(2)) 
})
