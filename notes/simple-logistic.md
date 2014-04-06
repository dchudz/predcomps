# APCs in a simple logistic regression example





```r
library(predcomps)
library(ggplot2)
```


## Input Generation

```


## Outcome Generation


```r
N <- 200
logit <- function(x) 1/(1+exp(-x))
outcomeGenerationFunction <- function(df) {
  with(df, logit(v1 + v2*2))
  }
```


## Computing and Plotting the APC


```r

GetPredCompsDF(outcomeGenerationFunction, data.frame(v1=rnorm(N)*.1, v2=rnorm(N)*.1), c("v1","v2"))
```

```
## Working on: v1 
## Working on: v2
```

```
##   Input Apc.Signed Apc.Absolute Impact.Signed Impact.Absolute
## 1    v1     0.2469       0.2469       0.03016         0.03016
## 2    v2     0.4937       0.4937       0.05766         0.05766
```

```r

GetPredCompsDF(outcomeGenerationFunction, data.frame(v1=rnorm(N), v2=rnorm(N)), c("v1","v2"))
```

```
## Working on: v1 
## Working on: v2
```

```
##   Input Apc.Signed Apc.Absolute Impact.Signed Impact.Absolute
## 1    v1     0.1516       0.1516        0.1544          0.1544
## 2    v2     0.2947       0.2947        0.3495          0.3495
```

```r

GetPredCompsDF(outcomeGenerationFunction, data.frame(v1=rnorm(N)*10, v2=rnorm(N)*10), c("v1","v2"))
```

```
## Working on: v1 
## Working on: v2
```

```
##   Input Apc.Signed Apc.Absolute Impact.Signed Impact.Absolute
## 1    v1    0.02144      0.02144        0.2390          0.2390
## 2    v2    0.04098      0.04098        0.4104          0.4104
```

```r

GetPredCompsDF(outcomeGenerationFunction, data.frame(v1=rnorm(N)*100, v2=rnorm(N)*100), c("v1","v2"))
```

```
## Working on: v1 
## Working on: v2
```

```
##   Input Apc.Signed Apc.Absolute Impact.Signed Impact.Absolute
## 1    v1   0.001960     0.001960        0.2117          0.2117
## 2    v2   0.003775     0.003775        0.4397          0.4397
```

```r


set.seed(889)
(GetPredCompsDF(outcomeGenerationFunction, data.frame(v1=rnorm(N)*1000, v2=rnorm(N)*1000), c("v1","v2"), 
          mahalanobisConstantTerm = .1))
```

```
## Working on: v1 
## Working on: v2
```

```
##   Input Apc.Signed Apc.Absolute Impact.Signed Impact.Absolute
## 1    v1  0.0001873    0.0001873        0.2291          0.2291
## 2    v2  0.0003820    0.0003820        0.4414          0.4414
```

```r

# something is wrong. shouldn't these APCs become similar for v1 and v2 as the 
# no b/c the one with the larger effect can better overcome, more likely to cause a 1/-1 flip


N=500
v1 <- rnorm(N)*3
v2 <- rnorm(N) * (abs(v1) > 2)
v3 <- rnorm(N) * (abs(v1) < .5)

df <- data.frame(v1,v2,v3)
df$y <- rbinom(n=nrow(df), size=1, prob=with(df, logit(v1+v2+v3)))

fittedLogit <- glm(y ~ v1 + v2 + v3, data = df, family = "binomial")

GetPredCompsDF(function(df) with(df, logit(v1+v2+v3)), 
         data.frame(v1, v2, v3), 
         c("v1","v2","v3"))
```

```
## Working on: v1 
## Working on: v2 
## Working on: v3
```

```
##   Input Apc.Signed Apc.Absolute Impact.Signed Impact.Absolute
## 1    v1     0.1200       0.1200       0.39392         0.39392
## 2    v2     0.0728       0.0728       0.04801         0.04801
## 3    v3     0.1660       0.1660       0.03661         0.03661
```

```r

GetPredCompsDF(fittedLogit, 
         data.frame(v1, v2, v3), 
         c("v1","v2","v3"))
```

```
## Working on: v1 
## Working on: v2 
## Working on: v3
```

```
##   Input Apc.Signed Apc.Absolute Impact.Signed Impact.Absolute
## 1    v1    0.12068      0.12068       0.12068         0.12068
## 2    v2    0.06334      0.06334       0.06334         0.06334
## 3    v3    0.19817      0.19817       0.19817         0.19817
```

```r



GetPredCompsDF
```

```
## function (predictionFunction, df, inputVars, ...) 
## {
##     apcList <- Map(function(currentVar) {
##         cat(paste("Working on:", currentVar, "\n"))
##         GetSingleInputPredComps(predictionFunction, df, currentVar, 
##             c(setdiff(inputVars, currentVar)), ...)
##     }, inputVars)
##     apcDF <- rename(ldply(apcList, data.frame), c(.id = "Input"))
##     return(apcDF)
## }
## <environment: namespace:predcomps>
```

```r


apcDf
```

```
## Error: object 'apcDf' not found
```

```r
PlotApcDF(apcDf)
```

```
## Error: could not find function "PlotApcDF"
```

```r
PlotApcDF2(apcDf)
```

```
## Error: could not find function "PlotApcDF2"
```

```r

## plot the curves
```

