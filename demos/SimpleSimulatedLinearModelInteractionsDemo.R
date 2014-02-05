library(ggplot2)
library(reshape2)

# Want a simple linear model demo with v and u1, u2, ... , u7.
# Model has an interactions between each u and v (same for each)
# Each u has same marginal distribution
# Only variation is in its correlation with v

N <- 200
vValues <- (-3):3
v <- sample(vValues, N, replace=TRUE)
v


df <- data.frame(v)
for (i in seq_along(vValues)) {
  df[[paste0("u",i)]] <- ifelse(v==vValues[i], 
                                sample(c(0,10), N, replace=TRUE),
                                rep(0, N)
                                )
}

ggplot(melt(df, id="v")) +
  geom_bar(aes(x=factor(v), fill=factor(value)), position=position_fill()) +
  facet_grid(variable ~ .) +
  scale_fill_discrete("u_i value") + 
  scale_x_discrete("v") +
  ggtitle("Distributions of each u conditional on v")


# Todo: 
#   make prediction function
#   make linear model with interactions only
#   compute APCs (may need to tweak parameter for 1/(1+m))
#   plot APCs (hopefully they look at expected)
#   generalize plotting function

#get_apc_with_absolute(function(df) return(df$u * df$v), exampleDF, u="u", v="v")
