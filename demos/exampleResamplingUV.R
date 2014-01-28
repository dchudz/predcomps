library("devtools")
setwd("~/Github/predcomps")
load_all()

library("mvtnorm")
sigma <- matrix(c(1,.5,-.5,
                  .5,1,.5,
                  -.5,.5,1), ncol=3)
X <- data.frame(rmvnorm(n=10, sigma=sigma))
get_pairs(X, u="X3", v=c("X1","X2"))


plot(X[,1:3])

XOriginalAndResampled <- getXAndResampledXMerged(X, u="X3", c("X1","X2"))


get_pairs(X, u="X3", v=c("X1","X2"))

ggplot(data=XOriginalAndResampled) + geom_point(aes(x=X1,y=X3,color=type)) + coord_equal()
ggplot(data=XOriginalAndResampled) + geom_point(aes(x=X2,y=X3,color=type)) + coord_equal()

XOriginalAndResampled2 <- getXAndResampledXMerged(X, "X3", c("X1","X2"), function(x) 1/x)
ggplot(data=XOriginalAndResampled2) + geom_point(aes(x=X1,y=X3,color=type)) + coord_equal()
ggplot(data=XOriginalAndResampled2) + geom_point(aes(x=X2,y=X3,color=type)) + coord_equal()

