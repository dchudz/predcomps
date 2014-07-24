[Documentation etc.](http://www.davidchudzicki.com/predcomps/)

Interested in getting involved? Here are some ways to help:

- Trying out the package in examples, write about the results. Does it help you better understand your complicated models? If not, what should be different? You can add examples to the documentation here via pull requests, or write in your own space.
- Clarifying the language in the documentation - what can be made clearer?
- Working on any of the "future work" below


## Future Work

(Unsure about the priority of the rest, but the top one is definitely most important.)

### Explicit model for p(u|v)

Currently [the way we assign weights](http://0.0.0.0:4000/more-pairs-and-weights.html) to sample for p(u|v) (roughly as described in the paper) requires a bit of hand-tweaking to work well in individual examples. It's also hard to generalize to categorical inputs. This may be the biggest barrier to widespread adoption.

As an alternative, perhaps we can explicitly build a model for the desired conditional distribution, e.g. maybe by using something like [BART](https://github.com/kapelner/bartMachine).

Todo:

- implement
- see how well it works


### Categorical inputs

Once we've done "Explicit model for p(u|v)", allowing categorical inputs should be much easier, but there's still some thought required.

### Sensivity Analysis

Some of the examples show how to do sensitivity analysis in the spirit of this package, but it'd be great to have that do it for you.

### "Variable Importance"

Implement something like [conditional variable importance](http://www.biomedcentral.com/1471-2105/9/307) in the spirit of this package. (Like "permutation importance", but instead of taking a permutation, you'd sample from the conditional distribution p(u|v).)

### Other tools/methods for understanding complicated models

I'd like to compile a list of other work in this direction, maybe comparing them with this.

I should add a page discussing other methods people have used to get at somewhat the same idea.

- [conditional variable importance](http://www.biomedcentral.com/1471-2105/9/307) - out of everything I've seen, conditional variable importance is the most similar in spirit to this package 
- randomForest package in R (partial plots, variable importance)
- earth package in R (variable importance)


