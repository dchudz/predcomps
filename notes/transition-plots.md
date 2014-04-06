



```r
library(predcomps)
library(ggplot2)
```



# Transition Plots: A new way to visualize models

Transition plots are a way of looking at looking at the comparisons behind APCs in a less aggregated form.

Instead of computing an average (one-point summary), we directly show the predictive comparisons. Since showing all of the pairs would cause overplotting (and not reflect the weights), we consider each original data point $(u_{orig},v)$ (where $u_{orig}$ is the input of interest and $v$ the other inputs) with only one resampled $u$ (sampled from all of the pairs between that data point and the others, with the same weights as used in APCs).

We  predict the output $y_{orig}$ at $(u_{orig},v)$ with the original $u$, and $y_{new}$ at $(u_{new},v)$ at the resampled $u$, and draw an arrow from $(u_{orig},y_{orig})$ to $(u_{new},y_{new})$. As in APCs, $v$ is held constant for each transition.

I will consider a small example with two inputs, first with no interaction and then with an interaction. (In this simple model with only two independent inputs, the transition plot is probably not the best way to visualize the model, but it serves as an example to illustrate a technique that will be useful for more complicated models. For example, the varying size of the arrows in this case is just a distraction, as the value of $v$ does not in this case affect the distribution of $u$-transitions.)

The simulated examples here will have $u$ and $v$ independent, and the first model will have:

$$\mathcal{E}[y_1] = 2v_1 + 2v_2$$


```r
N <- 100
df <- data.frame(u=rnorm(N), v=rnorm(N))
df$y1 = 2*df$u + 2*df$v + rnorm(N)
lm1 <- lm(y1 ~ u + v, data=df)
print(lm1)
```

```
## 
## Call:
## lm(formula = y1 ~ u + v, data = df)
## 
## Coefficients:
## (Intercept)            u            v  
##     -0.0712       1.9311       1.7189
```

```r
TransitionPlot(function(df) predict(lm1, df), df, "u", "v") + ylab("y1")
```

<img src="figure/CreateInputFeatures1.png" title="plot of chunk CreateInputFeatures" alt="plot of chunk CreateInputFeatures" style="display: block; margin: auto;" /><img src="figure/CreateInputFeatures2.png" title="plot of chunk CreateInputFeatures" alt="plot of chunk CreateInputFeatures" style="display: block; margin: auto;" />


Here is an example with an interaction:

$$\mathcal{E}[y_1] v_1 + v_2 + 2u_1v_1$$


```r
df$y2 = df$u + df$v + 2*df$v*df$u + rnorm(N)
lm2 <- lm(y2 ~ u*v, data=df)
print(lm2)
```

```
## 
## Call:
## lm(formula = y2 ~ u * v, data = df)
## 
## Coefficients:
## (Intercept)            u            v          u:v  
##      0.0639       0.9620       1.0303       1.7846
```

```r
TransitionPlot(function(df) predict(lm2, df), df, "u", "v") + ylab("y2")
```

<img src="figure/unnamed-chunk-31.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" /><img src="figure/unnamed-chunk-32.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />


Since the plot object returned by `TransitionPlot` includes its data, we can examine things in more detail by drawing our own arrows:


```r
p <- TransitionPlot(function(df) predict(lm2, df), df, "u", "v", plot=FALSE)

ggplot(p$data) +
  geom_segment(aes(x = u, y = output, xend = u.B, yend = outputNew, color=v), arrow = arrow()) +
  ylab("y2")
```

<img src="figure/unnamed-chunk-4.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" />

