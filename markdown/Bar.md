


## An R Package to Help Interpret Predictive Models: 

### (Average) Predictive Comparisons

Refactorings Hangout

David Chudzicki


## Related concepts

- sensitivity analysis
- elasticity
- variable importance
- partial dependence
- etc.

## Distinguishing features of **this** approach:

- treats model as a black box
- **tries to properly account for relationships among the inputs of interest**

- based on Gelman & Pardoe (2007)


## Plan

1. Motivating fake example
2. Predictive comparisons definitions: what we want 
4. Applying average predictive comparisons to (1)
5. An example with real data: credit scoring

- Discussion!
- (Appendix) Estimation & Computation: how to get what we want
- (Appendix) Comparison with other approaches


## Silly Example

- We sell wine
- Wine varies in: price, quality
- Customers randomly do/don't buy, depending on price and quality

## Logistic Regression

- $P$: price ($)
- $Q$: quality (score on arbitrary scale)
- **Model**: $P(\text{wine is purchased}) = logit^{-1}(\beta_0 + \beta_1 Q + \beta_2 P)$

![](figure/unnamed-chunk-2.png) 


- difficulty: interpreting coefficients on logit scale


**True model**: $P(\text{wine is purchased}) = logit^{-1}(0.1 Q - 0.12 P)$

## Distribution of Inputs (variation 1):

Price and quality are (noisily) related:

![](figure/unnamed-chunk-3.png) 


## We don't really need a model to understand this...

(A random subset of the data. For clarity, showing only a discrete subset of prices.)

![](figure/unnamed-chunk-4.png) 


## We don't really need a model to understand this...

For each individual price, quality vs. purchase probability forms a portion of a shifted inverse logit curve:

![](figure/unnamed-chunk-5.png) 


- how changes in price/quality affect $P(\text{wine is purchased})$ depends a lot on where you are in input space

## Variation 2

In another possible world, mid-range wines are more common:

![](figure/unnamed-chunk-6.png) 


- input distribution is changed
- ... but model is not changed

## In this world, quality matters more....

- (more precisely, cases where quality matters are more common)

![](figure/unnamed-chunk-7.png) 


## Variation 3

In a third possible world, price varies more strongly with quality:

![](figure/unnamed-chunk-8.png) 


Again:

- input distribution is changed
- ... but model is not changed, still $P(\text{wine is purchased}) = logit^{-1}(\beta_0 + \beta_1 Q + \beta_2 P)$

## In this world, quality matters even more...

- (more precisely, quality matters in all cases that we actually see)

![](figure/unnamed-chunk-9.png) 


## Now quality matters more

... across all price ranges (for the kinds of variation **that we see in the data**)

![](figure/unnamed-chunk-10.png) 


## Lessons from this example

1. We want to interpret things on the scale we care about (probability in this case)
2. Relationships among the inputs matter

## Goal is single-number summaries

These concepts are vague, but keep them in mind as we try to formalize things in the next few slides:

- **For each input, what is the average change in output per unit change in input?**
(generalizes linear regression, units depend on units for input)

- **How important is each input in influencing the output?**
(units should be consistent across inputs -- think of standardized regression coefficients)

## Some notation

**$u$**: the variable under consideration

**$v$**: the vector of other variables (the "all else held equal")

**$f(u,v)$**: a function that makes predictions, e.g. maybe $f(u,v) = \mathcal{E}[y \mid u, v, \theta]$

* We consider transitions in $u$ holding $v$ constant, e.g. $$\frac{f(u_2, v) - f(u_1, v)}{u_2-u_1}$$
* To get one-point summaries we'll take an average
* All of the subtlety lies in the choice of $v$, $u_1$, $u_2$


## What average do we take?

The APC is defined as

$$\frac{\mathcal{E}[\Delta_f]}{\mathcal{E}[\Delta_u]}$$

where

* $\Delta_f = f(u_2,v) - f(u_1,v)$
* $\Delta_u = u_2 - u_1$
* $\mathcal{E}$ is expectation under the following process:

1. sample $v$ from the (marginal) distribution of the corresponding inputs
2. sample $u_1$ and $u_2$ independently from the distribution of $u$ conditional on $v$


## Variations

- "Impact" (my idea; help me with naming!) is just the expected value of $\Delta_f = f(u_2,v) - f(u_1,v)$
- Absolute versions (of both impact and APC) use $\mathcal{E}[|\Delta_f|]$ and $\mathcal{E}[|\Delta_u|]$

## Computation

- Once we've said what we want, computing/estimating it isn't trivial
- More on this in the discussion (depending on time/interest)

## Returning to the wines...

![](figure/unnamed-chunk-111.png) ![](figure/unnamed-chunk-112.png) 


Exercise for the reader: Make an example where APC is larger than in Variation 1 but "Impact" is much smaller.

## Credit Scoring Example




- **SeriousDlqin2yrs** (target variable, 7% "yes"):  Person experienced 90 days past due delinquency or worse 
- **RevolvingUtilizationOfUnsecuredLines**:  Total balance on credit cards and personal lines of credit except real estate and no installment debt like car loans divided by the sum of credit limits
- **age**:	Age of borrower in years
- **NumberOfTime30-59DaysPastDueNotWorse**:	Number of times borrower has been 30-59 days past due but no worse in the last 2 years.
- **NumberOfTime60-89DaysPastDueNotWorse**:	Number of times borrower has been 60-89 days past due but no worse in the last 2 years.
- **NumberOfTimes90DaysLate**:	Number of times borrower has been 90 days or more past due.
- **DebtRatio**:	Monthly debt payments, alimony,living costs divided by monthy gross income
- **MonthlyIncome**:	Monthly income
- **NumberOfOpenCreditLinesAndLoans**:	Number of Open loans (installment like car loan or mortgage) and Lines of credit (e.g. credit cards)
- **NumberRealEstateLoansOrLines**:	Number of mortgage and real estate loans including home equity lines of credit
- **NumberOfDependents**:	Number of dependents in family excluding themselves (spouse, children etc.)


## Input Distribution

![](figure/unnamed-chunk-13.png) 


Note: previous lateness (esp. 90+) days is rare.

## Model Building

We'll use a random forest for this example:


```r
set.seed(1)
# Turning the response to type 'factor' causes the RF to be build for
# classification:
credit$SeriousDlqin2yrs <- factor(credit$SeriousDlqin2yrs)
rfFit <- randomForest(SeriousDlqin2yrs ~ ., data = credit, ntree = ntree)
```


## Aggregate Predictive Comparisons


```r
set.seed(1)
apcDF <- GetPredCompsDF(rfFit, credit, numForTransitionStart = numForTransitionStart, 
    numForTransitionEnd = numForTransitionEnd, onlyIncludeNearestN = onlyIncludeNearestN)
```



```
## |Input                                 |  Apc.Signed|  Apc.Absolute|  Impact.Signed|  Impact.Absolute|
## |:-------------------------------------|-----------:|-------------:|--------------:|----------------:|
## |RevolvingUtilizationOfUnsecuredLines  |   8.265e-02|     1.590e-01|       0.024470|          0.04707|
## |age                                   |  -3.263e-04|     2.496e-03|      -0.004750|          0.03633|
## |NumberOfTime30.59DaysPastDueNotWorse  |   3.873e-02|     7.057e-02|       0.014864|          0.02708|
## |DebtRatio                             |   8.705e-03|     1.888e-01|       0.001614|          0.03500|
## |MonthlyIncome                         |   3.270e-07|     9.794e-06|       0.001104|          0.03307|
## |NumberOfOpenCreditLinesAndLoans       |   1.634e-03|     7.746e-03|       0.007147|          0.03387|
## |NumberOfTimes90DaysLate               |   1.511e-01|     1.889e-01|       0.021397|          0.02676|
## |NumberRealEstateLoansOrLines          |   2.855e-03|     2.294e-02|       0.002085|          0.01675|
## |NumberOfTime60.89DaysPastDueNotWorse  |   9.203e-02|     1.853e-01|       0.007781|          0.01567|
## |NumberOfDependents                    |   4.221e-03|     1.849e-02|       0.004173|          0.01828|
```


## Impact Plot

(Showing +/- the absolute impact, since signed impact is bounded between those numbers)

(Showing impact rather than APC b/c the different APC units wouldn't be comparable, shouldn't go on one chart)

![](figure/LoanDefaultImpact.png) 


Summaries like this can guide questions that push is to dig deeper, like: 

- What's going on with age? (To get the cancellation we see, it must have strong effects that vary in sign)
- Why don't instances of previous lateness always increase your probability of a 90-days-past-due incident? (cancellation?)


## Goals for sensitivity analysis

- want something that properly accounts for relationships among variables of interest
- want something that emphasizes the values that are plausible given the other values (two reasons: this is what we care about, and this is what our model has better estimates of)


![](figure/unnamed-chunk-17.png) 


## How we'll do sensitivity analysis

- choose a few random values for $v$ (the "all else held equal")
- sample from $u$ conditional on $v$
- plot $u$ vs. the prediction for each $v$

![](figure/unnamed-chunk-18.png) 


## Zooming in...

![](figure/unnamed-chunk-19.png) 


- shows off some weird behavior of the model!
- we should dig deeper, get more comfortable with the model
- try other models


## Sensitivity: Number of Time 30-35 Days Past Due

- Mostly we see the increasing probability that we'd expect...

![](figure/unnamed-chunk-20.png) 


## Sensitivity: Number of Time 30-35 Days Past Due

... but in one case, probability of default *decreases* with the 0-to-1 transition

![](figure/unnamed-chunk-21.png) 


## Can we explain it?


```
## |  RevolvingUtilizationOfUnsecuredLines|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|
## |-------------------------------------:|----:|----------:|--------------:|--------------------------------:|
## |                                     1|   27|     0.1543|           4800|                                4|
```

```
## |  NumberOfTimes90DaysLate|  NumberRealEstateLoansOrLines|  NumberOfTime60.89DaysPastDueNotWorse|
## |------------------------:|-----------------------------:|-------------------------------------:|
## |                        1|                             0|                                     0|
```

```
## |  NumberOfDependents|  NumberOfTime30.59DaysPastDueNotWorse|
## |-------------------:|-------------------------------------:|
## |                   0|                                     0|
```



## A Cruder Approach

As an example, this is the [approach](http://beckmw.wordpress.com/2013/10/07/sensitivity-analysis-for-neural-networks/#ref1) linked in that BAR thread ("Algorithms are simple mathematical formulas that nobody understands.”)

- (by default) determine a 6 representative values for "all else" according to percentiles: one for minimum of each, one for 20th percentile, 40th percentile, etc.
- vary the input of interest, holding "all else" at those values

## A Cruder Approach Can Give Wrong Results

E.g. $x_1$, $x_2$ related like this, independent of $x_3$: 

![](figure/unnamed-chunk-23.png) 


With  $y = x_1 x_2 x_3$

- maybe this isn't a horrible issue in practice? my example required a 3-way interaction. 
- but I think the point still holds in practice (though maybe less extreme) that this isn't how we want to look at things

## "Partial Plots"

- e.g. `partialPlot` function in `randomForest` library in R


This accounts for relationships among the "all else held equal" but **not** between those and the input under consideration

Make predictions on a new data set constructed as follows:




One row:


```
## |  v1|v2  |   v3|  u|
## |---:|:---|----:|--:|
## |   1|a   |  2.3|  6|
```


Repeat the row varying $u$ across its whole range:


```
## |id    |  v1|v2  |   v3|   u|
## |:-----|---:|:---|----:|---:|
## |1     |   1|a   |  2.3|   1|
## |1.1   |   1|a   |  2.3|   2|
## |1.2   |   1|a   |  2.3|   3|
## |1.3   |   1|a   |  2.3|   4|
## |1.4   |   1|a   |  2.3|   5|
## |1.5   |   1|a   |  2.3|   6|
## |1.6   |   1|a   |  2.3|   7|
## |1.7   |   1|a   |  2.3|   8|
## |1.8   |   1|a   |  2.3|   9|
## |1.9   |   1|a   |  2.3|  10|
## |1.10  |   1|a   |  2.3|  11|
## |1.11  |   1|a   |  2.3|  12|
## |1.12  |   1|a   |  2.3|  13|
## |1.13  |   1|a   |  2.3|  14|
## |1.14  |   1|a   |  2.3|  15|
## |1.15  |   1|a   |  2.3|  16|
## |1.16  |   1|a   |  2.3|  17|
## |1.17  |   1|a   |  2.3|  18|
## |1.18  |   1|a   |  2.3|  19|
## |1.19  |   1|a   |  2.3|  20|
```


- Then average predictions grouping by $u$ (or not)

## Partial Plot Method Applied to Wines


```
## Warning: Removed 110 rows containing missing values (stat_summary).
## Warning: Removed 110 rows containing missing values (geom_point).
```

![](figure/unnamed-chunk-27.png) 




## Comparison with other approaches

Things that vary

- Units - depend on input or consistent across inputs
- Sensitive to univariate distribution of inputs
- Sensitive to dependence between inputs
- Shows shape of non-linearity
- Signed
- Model
- Based on holdout performance


## Computing the APC

- sampling a $v$ is easy (take a row from your data)
- sampling $u_1$ given $v$ is easy (take the $u$ in that row)
- sampling *another* $u$ ($u_2$) is harder
- would be easy if you had a lot of data with the same $v$
- so take $u$'s from rows of data where the correspinding $v$ is close to your $v$

## In Practice

- Gelman & Pardoe look at all pairs of rows and assign weights $$\frac{1}{1 + d}$$
- I think this was giving too much weight to faraway points (volume of $n$-spheres grows much faster than linearly in $d$)
- I use Gelman's weights, but only looking at a fixed number of the closest points
- Computational advantage: fewer points to deal with
- A few example 

```
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |25   |                  1|   24|          0|            200|                                0|                                     0|                                       0|   0.01|   0.01|   7e-04|
## |47   |                  1|   24|          0|            200|                                0|                                     0|                                       0|   0.01|   0.01|   9e-04|
## |48   |                  1|   24|          0|            200|                                0|                                     0|                                       0|   0.01|   0.01|   8e-04|
## |79   |                  1|   24|          0|            200|                                0|                                     0|                                       0|   0.01|   0.01|   8e-04|
## |119  |                  1|   24|          0|            200|                                0|                                     0|                                       0|   0.01|   0.01|   6e-04|
## |128  |                  1|   24|          0|            200|                                0|                                     0|                                       0|   0.01|   0.01|   8e-04|
## 
## 
## |id  |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:---|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |5   |                  2|   48|     0.4852|           3317|                                4|                                     0|                                       0|   0.03|   0.03|  0.0009|
## |22  |                  2|   48|     0.4852|           3317|                                4|                                     0|                                       0|   0.03|   0.03|  0.0019|
## |29  |                  2|   48|     0.4852|           3317|                                4|                                     0|                                       0|   0.03|   0.03|  0.0014|
## |31  |                  2|   48|     0.4852|           3317|                                4|                                     0|                                       2|   0.03|   0.53|  0.0009|
## |78  |                  2|   48|     0.4852|           3317|                                4|                                     0|                                       1|   0.03|   0.11|  0.0008|
## |86  |                  2|   48|     0.4852|           3317|                                4|                                     0|                                       0|   0.03|   0.03|  0.0010|
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |43   |                  3|   63|     0.1954|           6335|                                5|                                     0|                                       0|      0|      0|  0.0009|
## |58   |                  3|   63|     0.1954|           6335|                                5|                                     0|                                       0|      0|      0|  0.0011|
## |64   |                  3|   63|     0.1954|           6335|                                5|                                     0|                                       0|      0|      0|  0.0013|
## |74   |                  3|   63|     0.1954|           6335|                                5|                                     0|                                       0|      0|      0|  0.0009|
## |106  |                  3|   63|     0.1954|           6335|                                5|                                     0|                                       0|      0|      0|  0.0010|
## |121  |                  3|   63|     0.1954|           6335|                                5|                                     0|                                       0|      0|      0|  0.0011|
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |21   |                  4|   67|     0.1387|           7900|                                5|                                     0|                                       0|      0|   0.00|  0.0012|
## |42   |                  4|   67|     0.1387|           7900|                                5|                                     0|                                       0|      0|   0.00|  0.0009|
## |72   |                  4|   67|     0.1387|           7900|                                5|                                     0|                                       0|      0|   0.00|  0.0012|
## |131  |                  4|   67|     0.1387|           7900|                                5|                                     0|                                       0|      0|   0.00|  0.0009|
## |158  |                  4|   67|     0.1387|           7900|                                5|                                     0|                                       0|      0|   0.00|  0.0008|
## |165  |                  4|   67|     0.1387|           7900|                                5|                                     0|                                       2|      0|   0.02|  0.0008|
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |3    |                  5|   49|     0.2847|          10112|                                9|                                     0|                                       0|      0|    0.0|  0.0008|
## |24   |                  5|   49|     0.2847|          10112|                                9|                                     0|                                       1|      0|    0.1|  0.0012|
## |38   |                  5|   49|     0.2847|          10112|                                9|                                     0|                                       0|      0|    0.0|  0.0009|
## |75   |                  5|   49|     0.2847|          10112|                                9|                                     0|                                       1|      0|    0.1|  0.0010|
## |84   |                  5|   49|     0.2847|          10112|                                9|                                     0|                                       0|      0|    0.0|  0.0012|
## |111  |                  5|   49|     0.2847|          10112|                                9|                                     0|                                       0|      0|    0.0|  0.0008|
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |18   |                  6|   47|     0.1326|           9102|                                8|                                     0|                                       0|      0|   0.00|  0.0009|
## |23   |                  6|   47|     0.1326|           9102|                                8|                                     0|                                       1|      0|   0.08|  0.0012|
## |83   |                  6|   47|     0.1326|           9102|                                8|                                     0|                                       0|      0|   0.00|  0.0012|
## |97   |                  6|   47|     0.1326|           9102|                                8|                                     0|                                       0|      0|   0.00|  0.0008|
## |129  |                  6|   47|     0.1326|           9102|                                8|                                     0|                                       0|      0|   0.00|  0.0010|
## |142  |                  6|   47|     0.1326|           9102|                                8|                                     0|                                       0|      0|   0.00|  0.0011|
## 
## 
## |id  |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:---|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |7   |                  7|   62|     0.4984|           4770|                                6|                                     1|                                       0|      0|      0|  0.0011|
## |11  |                  7|   62|     0.4984|           4770|                                6|                                     1|                                       0|      0|      0|  0.0008|
## |16  |                  7|   62|     0.4984|           4770|                                6|                                     1|                                       1|      0|      0|  0.0010|
## |57  |                  7|   62|     0.4984|           4770|                                6|                                     1|                                       0|      0|      0|  0.0010|
## |59  |                  7|   62|     0.4984|           4770|                                6|                                     1|                                       0|      0|      0|  0.0008|
## |73  |                  7|   62|     0.4984|           4770|                                6|                                     1|                                       0|      0|      0|  0.0009|
## 
## 
## |id  |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:---|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |10  |                  8|   26|     0.4321|           2880|                                5|                                     0|                                       0|   0.03|   0.03|  0.0011|
## |19  |                  8|   26|     0.4321|           2880|                                5|                                     0|                                       0|   0.03|   0.03|  0.0008|
## |34  |                  8|   26|     0.4321|           2880|                                5|                                     0|                                       0|   0.03|   0.03|  0.0008|
## |35  |                  8|   26|     0.4321|           2880|                                5|                                     0|                                       0|   0.03|   0.03|  0.0009|
## |46  |                  8|   26|     0.4321|           2880|                                5|                                     0|                                       0|   0.03|   0.03|  0.0011|
## |62  |                  8|   26|     0.4321|           2880|                                5|                                     0|                                       0|   0.03|   0.03|  0.0008|
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |30   |                  9|   33|     0.0648|            400|                                6|                                     0|                                       0|   0.01|   0.01|  0.0010|
## |40   |                  9|   33|     0.0648|            400|                                6|                                     0|                                       0|   0.01|   0.01|  0.0017|
## |41   |                  9|   33|     0.0648|            400|                                6|                                     0|                                       0|   0.01|   0.01|  0.0015|
## |51   |                  9|   33|     0.0648|            400|                                6|                                     0|                                       0|   0.01|   0.01|  0.0010|
## |71   |                  9|   33|     0.0648|            400|                                6|                                     0|                                       0|   0.01|   0.01|  0.0009|
## |114  |                  9|   33|     0.0648|            400|                                6|                                     0|                                       0|   0.01|   0.01|  0.0010|
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |76   |                 10|   60|     0.6538|           5383|                               15|                                     0|                                       0|   0.01|   0.01|   9e-04|
## |150  |                 10|   60|     0.6538|           5383|                               15|                                     0|                                       0|   0.01|   0.01|   9e-04|
## |152  |                 10|   60|     0.6538|           5383|                               15|                                     0|                                       0|   0.01|   0.01|   9e-04|
## |187  |                 10|   60|     0.6538|           5383|                               15|                                     0|                                       0|   0.01|   0.01|   9e-04|
## |188  |                 10|   60|     0.6538|           5383|                               15|                                     0|                                       0|   0.01|   0.01|   9e-04|
## |208  |                 10|   60|     0.6538|           5383|                               15|                                     0|                                       0|   0.01|   0.01|   8e-04|
## 
## 
## |id  |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:---|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |14  |                 11|   59|     0.6017|           2000|                                4|                                     3|                                       0|   0.81|   0.65|  0.0010|
## |26  |                 11|   59|     0.6017|           2000|                                4|                                     3|                                       0|   0.81|   0.65|  0.0008|
## |32  |                 11|   59|     0.6017|           2000|                                4|                                     3|                                       0|   0.81|   0.65|  0.0016|
## |45  |                 11|   59|     0.6017|           2000|                                4|                                     3|                                       2|   0.81|   0.74|  0.0008|
## |54  |                 11|   59|     0.6017|           2000|                                4|                                     3|                                       2|   0.81|   0.74|  0.0010|
## |60  |                 11|   59|     0.6017|           2000|                                4|                                     3|                                       1|   0.81|   0.57|  0.0008|
## 
## 
## |id  |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:---|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |6   |                 12|   57|     0.5949|           5808|                                8|                                     0|                                       0|   0.04|   0.04|   1e-03|
## |27  |                 12|   57|     0.5949|           5808|                                8|                                     0|                                       0|   0.04|   0.04|   1e-03|
## |33  |                 12|   57|     0.5949|           5808|                                8|                                     0|                                       0|   0.04|   0.04|   9e-04|
## |56  |                 12|   57|     0.5949|           5808|                                8|                                     0|                                       0|   0.04|   0.04|   1e-03|
## |93  |                 12|   57|     0.5949|           5808|                                8|                                     0|                                       0|   0.04|   0.04|   1e-03|
## |96  |                 12|   57|     0.5949|           5808|                                8|                                     0|                                       0|   0.04|   0.04|   8e-04|
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |1    |                 13|   46|     0.3383|           9900|                               13|                                     1|                                       0|   0.03|   0.03|  0.0008|
## |67   |                 13|   46|     0.3383|           9900|                               13|                                     1|                                       0|   0.03|   0.03|  0.0009|
## |94   |                 13|   46|     0.3383|           9900|                               13|                                     1|                                       0|   0.03|   0.03|  0.0011|
## |103  |                 13|   46|     0.3383|           9900|                               13|                                     1|                                       3|   0.03|   0.25|  0.0009|
## |107  |                 13|   46|     0.3383|           9900|                               13|                                     1|                                       1|   0.03|   0.03|  0.0010|
## |108  |                 13|   46|     0.3383|           9900|                               13|                                     1|                                       0|   0.03|   0.03|  0.0008|
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |2    |                 14|   65|     0.0565|           7650|                                9|                                     0|                                       0|      0|   0.00|  0.0010|
## |39   |                 14|   65|     0.0565|           7650|                                9|                                     0|                                       1|      0|   0.17|  0.0009|
## |52   |                 14|   65|     0.0565|           7650|                                9|                                     0|                                       0|      0|   0.00|  0.0010|
## |65   |                 14|   65|     0.0565|           7650|                                9|                                     0|                                       0|      0|   0.00|  0.0011|
## |105  |                 14|   65|     0.0565|           7650|                                9|                                     0|                                       0|      0|   0.00|  0.0009|
## |125  |                 14|   65|     0.0565|           7650|                                9|                                     0|                                       0|      0|   0.00|  0.0009|
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |12   |                 15|   59|     0.4117|           2863|                               17|                                     1|                                       0|   0.02|   0.02|   1e-03|
## |115  |                 15|   59|     0.4117|           2863|                               17|                                     1|                                       0|   0.02|   0.02|   1e-03|
## |138  |                 15|   59|     0.4117|           2863|                               17|                                     1|                                       0|   0.02|   0.02|   9e-04|
## |185  |                 15|   59|     0.4117|           2863|                               17|                                     1|                                       0|   0.02|   0.02|   1e-03|
## |189  |                 15|   59|     0.4117|           2863|                               17|                                     1|                                       0|   0.02|   0.02|   8e-04|
## |240  |                 15|   59|     0.4117|           2863|                               17|                                     1|                                       0|   0.02|   0.02|   8e-04|
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |9    |                 16|   33|     0.7151|           3600|                                7|                                     1|                                       0|   0.02|   0.04|   9e-04|
## |17   |                 16|   33|     0.7151|           3600|                                7|                                     1|                                       0|   0.02|   0.04|   8e-04|
## |36   |                 16|   33|     0.7151|           3600|                                7|                                     1|                                       0|   0.02|   0.04|   9e-04|
## |50   |                 16|   33|     0.7151|           3600|                                7|                                     1|                                       0|   0.02|   0.04|   8e-04|
## |63   |                 16|   33|     0.7151|           3600|                                7|                                     1|                                       0|   0.02|   0.04|   8e-04|
## |136  |                 16|   33|     0.7151|           3600|                                7|                                     1|                                       0|   0.02|   0.04|   1e-03|
## 
## 
## |id  |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:---|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |4   |                 17|   32|     0.2983|           4038|                                3|                                     3|                                       1|   0.06|   0.16|  0.0012|
## |53  |                 17|   32|     0.2983|           4038|                                3|                                     3|                                       0|   0.06|   0.06|  0.0009|
## |55  |                 17|   32|     0.2983|           4038|                                3|                                     3|                                       0|   0.06|   0.06|  0.0011|
## |70  |                 17|   32|     0.2983|           4038|                                3|                                     3|                                       0|   0.06|   0.06|  0.0010|
## |77  |                 17|   32|     0.2983|           4038|                                3|                                     3|                                       0|   0.06|   0.06|  0.0009|
## |82  |                 17|   32|     0.2983|           4038|                                3|                                     3|                                       1|   0.06|   0.16|  0.0008|
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |15   |                 18|   27|     0.1543|           4800|                                4|                                     0|                                       3|   0.62|   0.39|  0.0005|
## |37   |                 18|   27|     0.1543|           4800|                                4|                                     0|                                       0|   0.62|   0.62|  0.0012|
## |49   |                 18|   27|     0.1543|           4800|                                4|                                     0|                                       0|   0.62|   0.62|  0.0005|
## |66   |                 18|   27|     0.1543|           4800|                                4|                                     0|                                       0|   0.62|   0.62|  0.0019|
## |89   |                 18|   27|     0.1543|           4800|                                4|                                     0|                                       1|   0.62|   0.47|  0.0005|
## |132  |                 18|   27|     0.1543|           4800|                                4|                                     0|                                       0|   0.62|   0.62|  0.0005|
## 
## 
## |id   |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:----|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |8    |                 19|   63|     0.6629|           3455|                               11|                                     0|                                       1|   0.02|   0.06|  0.0010|
## |28   |                 19|   63|     0.6629|           3455|                               11|                                     0|                                       1|   0.02|   0.06|  0.0010|
## |80   |                 19|   63|     0.6629|           3455|                               11|                                     0|                                       0|   0.02|   0.02|  0.0018|
## |87   |                 19|   63|     0.6629|           3455|                               11|                                     0|                                       0|   0.02|   0.02|  0.0008|
## |104  |                 19|   63|     0.6629|           3455|                               11|                                     0|                                       0|   0.02|   0.02|  0.0009|
## |118  |                 19|   63|     0.6629|           3455|                               11|                                     0|                                       0|   0.02|   0.02|  0.0011|
## 
## 
## |id  |  OriginalRowNumber|  age|  DebtRatio|  MonthlyIncome|  NumberOfOpenCreditLinesAndLoans|  NumberOfTime30.59DaysPastDueNotWorse|  NumberOfTime30.59DaysPastDueNotWorse.B|  yHat1|  yHat2|  Weight|
## |:---|------------------:|----:|----------:|--------------:|--------------------------------:|-------------------------------------:|---------------------------------------:|------:|------:|-------:|
## |13  |                 20|   78|     0.6022|           7344|                               11|                                     0|                                       0|   0.05|   0.05|  0.0008|
## |20  |                 20|   78|     0.6022|           7344|                               11|                                     0|                                       0|   0.05|   0.05|  0.0010|
## |44  |                 20|   78|     0.6022|           7344|                               11|                                     0|                                       0|   0.05|   0.05|  0.0009|
## |61  |                 20|   78|     0.6022|           7344|                               11|                                     0|                                       0|   0.05|   0.05|  0.0009|
## |69  |                 20|   78|     0.6022|           7344|                               11|                                     0|                                       0|   0.05|   0.05|  0.0008|
## |98  |                 20|   78|     0.6022|           7344|                               11|                                     0|                                       0|   0.05|   0.05|  0.0011|
```


