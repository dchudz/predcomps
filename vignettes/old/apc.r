

#I'll use this prediction function for the next few examples:
predictionFunction <- function(df) inv.logit(10*df$X1 + 10*df$X2)

#APC for two uncorrelated variables
sigma <- matrix(c(1,0,
                  0,1), ncol=2)
X <- data.frame(rmvnorm(n=600, sigma=sigma))
v="X1"
u="X2"
APC1 <- getAPC(predictionFunction, X, u, v)
APC1$APC

#when X1,X2 vary on smaller scale, linear predictor is closer to 0, so APC is larger
sigma <- matrix(c(.1,0,
                  0,.1), ncol=2)
X <- data.frame(rmvnorm(n=600, sigma=sigma))
APC2 <- getAPC(predictionFunction, X, u, v)
APC2$APC


#when X1,X2 are negatively correlated, linear predictor is closer to 0, APC is smaller
sigma <- matrix(c(1,-.9,
                  -.9,1), ncol=2)
X <- data.frame(rmvnorm(n=600, sigma=sigma))
APC3 <- getAPC(predictionFunction, X, u, v)
APC3$APC


#when X1,X2 are positively correlated, linear predictor is farher from 0, APC is smaller
sigma <- matrix(c(1,.9,
                  .9,1), ncol=2)
X <- data.frame(rmvnorm(n=600, sigma=sigma))
APC4 <- getAPC(predictionFunction, X, u, v)
APC4$APC

#We can resample from the new u's, and compare old/new distribution. Our new X2|X1 does not look so much like our old one!
XOriginalAndResampled <- getXAndResampledXMerged(X, u, v)
ggplot(data=XOriginalAndResampled) + geom_point(aes(x=X1,y=X2,color=type)) + coord_equal()

#conditional on v, u is N( 0 + .9 * v, 1-.9^2)
XResampledOptimally <- transform(X, X2=rnorm(nrow(X), .9*X1, sqrt(1-.9**2)))
ggplot(data=rbind(
  transform(X,type="original"),
  transform(XResampledOptimally, type="resampled optimally"))) + 
  geom_point(aes(x=X1,y=X2,color=type)) + coord_equal()

yHat1 <- predictionFunction(X)
yHat2 <- predictionFunction(XResampledOptimally)
uDiff <- XResampledOptimally[[u]] - X[[u]]
w <- rep(1,nrow(X))
APC <- sum(w * (yHat2 - yHat1) * sign(uDiff)) / sum(w * uDiff * sign(uDiff))
APC

#or we can find the optimal weights:
pairs <- APC4$pairsDF
w <- dnorm(pairs$X2.B, .9*pairs$X1, sqrt(1-.9**2))
yHat1 <- predictionFunction(pairs)
pairsNew <- pairs[,c(v,uNew)]
names(pairsNew)[which(names(pairsNew)==uNew)] = u
yHat2 <- predictionFunction(pairsNew)
uDiff <- pairs[[uNew]] - pairs[[u]]
APC <- sum(w * (yHat2 - yHat1) * sign(uDiff)) / sum(w * uDiff * sign(uDiff))
APC

newX <- pairs[sample(1:nrow(pairs), nrow(X), prob=w,replace=FALSE), 
              c(v,paste(u,"B",sep="."))]
names(newX) <- c(v,u)
newX$type <- "resampled"
X$type <- "original"
ggplot(rbind(X,newX)) + geom_point(aes(x=X1,y=X2,color=type)) + coord_equal()

plot(X$X2, newX$X2)
## hmm... sampling from appropriate weights for X2|X1 changes the distribution of X1. (less spread)
## this causes APC to be larger...
## in the data set of u/v pairs, do we need to be renormalizing weights to sum to a constant across each v? 

## now I'm confused. are the weights w_ij meant to approximate p(u_i|v_j)?  seems like this would result in (u_i,v_j,weight) triples 
##that don't necessarily reflect p(u,v) very well -- since u's are coming from a "proposal distribution" that isn't uniform



##Let's look at it a similar way, but for many inputs:

X <- data.frame(rmvnorm(n=600, sigma=diag(rep(1,100))))

predictionFunction <- function(df) inv.logit(1*df$X1 + 1*df$X2 + 1*df$X3 + 1*df$X4 + 1*df$X5 + 1*df$X6 + 1*df$X7 + 1*df$X8 + 1*df$X9 + 1*df$X10)
v <- paste("X",1:99,sep="")
u <- "X100"
APC5 <- getAPC(predictionFunction, X, u, v)
APC5$APC

#lower weights for v's with larger norms:
qplot(rowSums(as.matrix(APC5$pairsDF[,1:99])*as.matrix(APC5$pairsDF[,1:99])), APC5$weights, alpha=I(.1))


nrow(APC$pairsDF)
requireInstall("clusterGeneration")
genPositiveDefMat(5, rangeVar=c(1,1), covMethod="unifcorrmat")