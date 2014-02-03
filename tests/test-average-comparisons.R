test_that("get_apc returns expected answer on small example", {
  set.seed(89890)
  exampleDF <- data.frame(
    v=c(3,3,7,7),  
    u=c(10,20,12,22) 
  )[rep(c(1,2,3,4),c(40,40,10,10)),]
  exampleDF2 <- transform(exampleDF, v = v + rnorm(nrow(exampleDF), sd=.001))
  apc <- get_apc(function(df) return(df$u * df$v), exampleDF2, u="u", v="v")
  expect_that(apc, equals(3.854473, tol=1e-6)) 
})


test_that("get_apc_with_absolute returns expected answer on small example", {
  exampleDF <- data.frame(
    v=c(-5,-5,5,5),  
    u=c(10,20,10,20) 
  )[rep(c(1,2,3,4),rep(50,4)),]
  apcList <- get_apc_with_absolute(function(df) return(df$u * df$v), exampleDF, u="u", v="v")
  expect_that(apcList$Signed, equals(0)) # for signed version, positives should cancel negatives
  expect_that(apcList$Absolute, equals(5)) # for unsigned version, each predictive comparison has abs value 5
})
