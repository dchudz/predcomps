library(predcomps)
library(ggplot2)
library(boot)

N=500
v1 <- rnorm(N)*3
v2 <- rnorm(N) * (abs(v1) > 2)
v3 <- rnorm(N) * (abs(v1) < .5)

# should we remove the points with the condition false instead of setting to 0?
# no, it's good how we have it. since we're conditioning on (e.g.) v1 and v3 when we draw v2, 
# setting v2 to 0 in those cases means there really is no variation in v2 for those v1/v3 combos

qplot(v2, v1 + v3)
qplot(v3, v1 + v3)

# plot we want:
# v2 curve at various v1 + v3 values. sample from the real data to draw this
# (get random rows and then fill in the whole curve.)
# thicken the rows where v2 isn't 0, ie, does vary, or maybe use alpha to make the other ones lighter.
x = v2, color = v1 + v3 + 

table(v2==0)
table(v3==0)
df <- data.frame(v1,v2,v3)
df$y <- rbinom(n=nrow(df), size=1, prob=with(df, inv.logit(v1+v2+v3)))

fittedLogit <- glm(y ~ v1 + v2 + v3, data = df, family = "binomial")

apcDF <- GetPredCompsDF(function(df) with(df, inv.logit(v1+v2+v3)), df, c("v1","v2","v3"))

PlotPredCompsDF(apcDF)
PlotPredCompsDF(apcDF, variant="Apc")


GetPredCompsDF(fittedLogit, 
               data.frame(v1, v2, v3), 
               c("v1","v2","v3"))



GetPredCompsDF