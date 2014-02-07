Todo

- clean up naming -- casing convention's should match Kaggle's or else I'll go crazy -- probably use a recursive find/replace

- FINISH EXAMPLE: demos/SimpleSimulatedLinearModelInteractionsDemo.R
	- add a feature with high absolute but zero signed APC -- e.g. its only transitions are at -3 OR 3
	- absolute and signed on different charts? 
	- show that more data & get_pairs(mahalanobisConstantTerm=SMALL) get us closer to theoretical values
	- generalize plotting to function ()
	- what would partial plots say about about this example?

- demonstrate on simulated logistic regression example
	- should see effect of shape of logistic curve... ie, if one feature only varies at high values of another, less effect than if it varies at middle values of the other

- email to ask for advice about unsigned APCs -- (1) absolute value and (2) a way to make them comparable between numeric and categorical inputs

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
- ... BUT I'm interested in the uncertainty that arises from the density estimation as well. I'm not sure how much I like displaying one source of uncertainty without the other. (understates the overall uncertainty, and people may get confused)


## Better format for demos

- learn about vignettes (this should be the form my examples take)

## Tests

- test get_pairs
- more tests on get_apc


## Technical debt

- deal with potential column name conflicts in data frames (e.g. what if "weight" is already a column of X, but I try to use it...)
- make it faster -- with large N, we should make distance matrix (much faster than I am now) and only keep a smaller number of the closest points

