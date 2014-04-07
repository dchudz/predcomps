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

- pages to write
	- Introduction to APCs
	- Impact (scale-insensitive version of APCs)
	- Transition Plots 

- examples
	- make make diamonds presentable
	- another example give me some credit nice b/c it's logistic

- common functions should work on RF and GLM objects. Shouldn't need to specify inputs (should be inferred from the object)

- document every function other people would use, with example