library("devtools")
setwd("~/predcomps")
document()
load_all()


library(ggplot2)
library(reshape2)
library(plyr)
# Want a simple linear model demo with v and u1, u2, ... , u7.
# Model has an interactions between each u and v (same for each)
# Each u has same marginal distribution
# Only variation is in its correlation with v

N <- 100
vValues <- (-3):3
v <- sample(vValues, N, replace=TRUE)


df <- data.frame(v)
for (i in seq_along(vValues)) {
  df[[paste0("u",i)]] <- ifelse(v==vValues[i], 
                                sample(c(0,10), N, replace=TRUE),
                                rep(0, N)
                                )
}
df$u8 <- ifelse(v %in% c(-3,3),
                sample(c(0,10), N, replace=TRUE),
                rep(0, N)
                )


ggplot(melt(df, id="v")) +
  geom_bar(aes(x=factor(v), fill=factor(value)), position=position_fill()) +
  facet_grid(variable ~ .) +
  scale_fill_discrete("u_i value") + 
  scale_x_discrete("v") +
  ggtitle("Distributions of each u conditional on v")


outputGenerationFunction <- function(df) {
  with(df, v*u1 + v*u2 + v*u3 + v*u4 + v*u5 + v*u6 + v*u7 + v*u8)
}

df$y <- outputGenerationFunction(df)


inputVars <- c("v",paste0("u",1:8))


apcDF <- GetApcDF(outputGenerationFunction, df, inputVars)







longAPCs <- melt(apcDF, id="Input", value.name = "APC", variable.name = "Type")


maxAPC <- max(abs(longAPCs$APC))
by the

longAPCs2 <- rbind(
  longAPCs,
  transform(subset(longAPCs, Type=="Absolute"), APC=-APC)
)
longAPCs2$Input <- reorder(factor(longAPCs2$Input), longAPCs2$APC, FUN = function(x) mean(abs(x))) 

longAPCs2 <- longAPCs2[order(factor(longAPCs2$Type, levels=c("Absolute", "Signed"))), ]

ggplot(longAPCs2) +
  geom_point(aes(y = Input, x=APC, color=Type, shape=Type, size=Type)) +
  #facet_grid(. ~ Type) + 
  theme_grey(base_size=20) +
  scale_x_continuous(limits=c(-maxAPC, maxAPC)) +
  scale_size_discrete(range=c(3,4))

## I like this way of plotting APCs!



