Todo

- change fxn of mahabolanonis to k (force 1/(k+m))
- make apc function take *either* a function to compute yHat, *or* a glm object
- demonstrate on simulated linear regression example
- demonstrate on simulated logistic regression example

Learn about

- vignettes (this should be the form my examples take)


## Some features a nice simulated example will illustrate:

- Linear regression:
	- difference between signed and absolute APC (one can be large while the other is 0, if effects can have opposite signs)
	- given two inputs, each interacting with another (in the same way), the an input has larger APC if it's more likely to occur with values of the other that faciliate the interaction

- Logistic regression
	- should see effect of shape of logistic curve... ie, if one feature only varies at high values of another, less effect than if it varies at middle values of the other

## Tests

- test get_pairs
- more tests on get_apc


## Further away

- deal with potential column name conflicts in data frames (e.g. what if "weight" is already a column of X)

