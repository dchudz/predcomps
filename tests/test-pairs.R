library(testthat)
library(predcomps)

MakeComparable <- function(df) {
  df <- round(df, digits = 5)
  return(df[do.call(order, df), ])
}

test_that("GetPairs works right in a small example", {
  
  df <- data.frame(X = rep(c(1,2),2),
                   Y = rep(c(2,4),2))
  pairsActual <- GetPairs(df, "X", "Y")
  pairsExpected <- data.frame(OriginalRowNumber = c(1L, 1L, 1L, 2L, 2L, 2L, 3L, 3L, 3L, 4L, 4L, 4L), 
                              X = c(1, 1, 1, 2, 2, 2, 1, 1, 1, 2, 2, 2), 
                              Y = c(2, 2, 2, 4, 4, 4, 2, 2, 2, 4, 4, 4), 
                              X.B = c(2, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 1), 
                              Weight = c(0.166666666666667, 0.666666666666667, 0.166666666666667, 0.166666666666667, 0.166666666666667, 0.666666666666667, 0.666666666666667, 0.166666666666667, 0.166666666666667, 0.166666666666667, 0.666666666666667, 0.166666666666667))
  pairsActual <- pairsActual[names(pairsExpected)]
  expect_that(all.equal(MakeComparable(pairsActual), MakeComparable(pairsExpected)), is_true()) 
})
