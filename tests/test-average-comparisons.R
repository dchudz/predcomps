test_that("get_apc returns expected answer on small example", {
  set.seed(89890)
  exampleDF <- data.frame(
    v=c(3,3,7,7),  
    u=c(10,20,12,22) 
  )[rep(c(1,2,3,4),c(40,40,10,10)),]
  exampleDF2 <- transform(exampleDF, v = v + rnorm(nrow(exampleDF), sd=.001))
  apc <- get_apc(function(df) return(df$u * df$v), exampleDF2, u="u", v="v")
  expect_that(apc, equals(3.854473, tol=1e-6)) #check that all 30 features (including missingness indicators were used)
})
