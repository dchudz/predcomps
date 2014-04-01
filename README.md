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

- add to all examples


### Examples Needed

- demonstrate on simulated logistic regression example
	- (todo) plot the curves for better intuition

- real world examples
	- (to finish) diamonds
	- look at give me some credit or another?

### Other documentation needed

- explanation of Gelman & Pardoe paper (or at least the parts of it that are necessary to understand the package)

- a page isolating differences and/or extensions from what's described in the Gelman/Pardoe paper

- a general overview of how to use the package 
  - include warning that it's not very polished -- e.g. slow, not much checking that inputs are appropriate, etc. It's mainly a proof of concept and will stay that way until I see other people being interested.



### More functionality

- make the plots work again
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

