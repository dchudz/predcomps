This README is mainly for people developing the project (which is just me, at the moment). Everything for users is at the [Project Page](http://dchudz.github.io/predcomps/).

# Motivation

Lots of people are using complicated/non-parametric models for lots of things, but it’s hard to understand what complicated models are telling you telling you. This may be a general-purpose way to extract understanding from a very large class of complicated models.

# Risks

What could make this fail? Some possibilities:

- the problem isn't really important (people don't need to understand their models in this kind of way, or they can just use simple models when they want understanding and that's good enough)
- people already have good ways to understand complicated models (e.g. "partial plot" and "variable importance" as commonly used with random forests -- I don't think these are good enough, but maybe I'm wrong)
- technical risk: maybe this approach won't really work (biggest risk here is: automatically getting the weights reasonably right in practical problems)
- maybe it'll be too hard to use, or I won't communicate it well, etc.
- maybe I'll lose interest for it's launchable


# Todo

## Must be done before releasing to the world

### Impact plots with arrows

- start with example based on GetPairs applied to y = v1*v2, with and without v2 & v2 correlated


### Examples Needed

- demonstrate on simulated logistic regression example
	- (todo) plot the curves for better intuition

- a motivating real data example -- can get data sets with data()


### Other documentation needed

- explanation of Gelman & Pardoe paper (or at least the parts of it that are necessary to understand the package)

- a page isolating differences and/or extensions from what's described in the Gelman/Pardoe paper

- a general overview of how to use the package 
  - include warning that it's not very polished -- e.g. slow, not much checking that inputs are appropriate, etc. It's mainly a proof of concept and will stay that way until I see other people being interested.



### More functionality

- APC "variable importance" -- essentially APC without the denominator. instead of expected change in y per unit change in u conditonal on a u transition, this is just expected change in y given two draws from u (which needed be a "transition" -- the two could be the same value, in which case). 
  - this is a natural way to combine change in output per unit change in input with how much the inputs are actually going to change
  - it's not completely clear that this needs to be done before launch (it's not in the paper after), but I suspect this will be important to the package's usefulness, so maybe it does. for example, this is the only thing I can think of that that can naturally put categorical and continuous variables on the same scale. (using the absolute value version of this)

- add an example function that would just show off the functionality.  For example, try running > library(glmnet), > example(glmnet)


## Maybe should be done before releasing it to the world


- make it work if categorical variables are includes in the inputs that aren't of interest
- make it work for categorical variables as input of interest

### Better unit testing


## Doesn't need to be done before releasing it to the world


### Uncertainty

- it would be pretty easy to allow for multiple samples of parameters and plot uncertainties as in the paper
- I'm also interested in the uncertainty that arises from the density estimation as. I'm not that excited about displaying one source of uncertainty without at least having a sense for the other.


## Some other stuff

- deal with potential column name conflicts in data frames (e.g. what if "weight" is already a column of X, but I try to use it...)
- make it faster -- with large N, we should make distance matrix (much faster than I am now) and only keep a smaller number of the closest points

