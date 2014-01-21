
source(file.path(Sys.getenv("GITHUB_PATH"),"average-predictive-comparisons","utilities.R"))
requireInstall("mvtnorm")
requireInstall("ggplot2")




sigma <- matrix(c(1,.5,-.5,
                  .5,1,.5,
                  -.5,.5,1), ncol=3)
X <- data.frame(rmvnorm(n=800, sigma=sigma))
plot(X[,1:3])

XOriginalAndResampled <- getXAndResampledXMerged(X, u="X3", c("X1","X2"))
ggplot(data=XOriginalAndResampled) + geom_point(aes(x=X1,y=X3,color=type)) + coord_equal()
ggplot(data=XOriginalAndResampled) + geom_point(aes(x=X2,y=X3,color=type)) + coord_equal()

XOriginalAndResampled2 <- getXAndResampledXMerged(X, "X3", c("X1","X2"), function(x) 1/x)
ggplot(data=XOriginalAndResampled2) + geom_point(aes(x=X1,y=X3,color=type)) + coord_equal()
ggplot(data=XOriginalAndResampled2) + geom_point(aes(x=X2,y=X3,color=type)) + coord_equal()

