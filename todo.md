# Todo

- demonstrate on simulated logistic regression example
	- should see effect of shape of logistic curve... ie, if one feature only varies at high values of another, less effect than if it varies at middle values of the other

- make it work for categorical variables

- write down my ideas about APC "variable importance" -- essentially APC without the denominator. instead of expected change in y per unit change in u conditonal on a u transition, this is just expected change in y given two draws from u (which needed be a "transition" -- the two could be the same value, in which case) -- make example for where random forest variable importance can go wrong

- improve README to say:
	- what this does so far -- high-level description of APCs, link to paper and better description
	- differences between my version and what's described in [Gelman & Pardoe 2007]
		- categorical inputs (say what I decided to do)
		- normalizing of weights in pairs (link to my note on this)
		- describe variable importance
	- warning that it's not very polished -- e.g. slow, not much checking that inputs are appropriate
	- next 

## Uncertainty

- it would be pretty easy to allow for multiple samples of parameters and plot uncertainties as in the paper
- I'm also interested in the uncertainty that arises from the density estimation as. I'm not that excited about displaying one source of uncertainty without at least having a sense for the other.

## Tests

- test get_pairs
- more tests on get_apc


## Technical debt

- deal with potential column name conflicts in data frames (e.g. what if "weight" is already a column of X, but I try to use it...)
- make it faster -- with large N, we should make distance matrix (much faster than I am now) and only keep a smaller number of the closest points

