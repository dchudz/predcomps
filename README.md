This README is mainly for people developing the project (which is just me, at the moment). Everything for users is at the [Project Page](http://www.davidchudzicki.com/predcomps/).

Lots of people are using complicated/non-parametric models for lots of things, but it’s hard to understand what complicated models are telling you. This is general-purpose way to extract understanding from a very large class of complicated models.

# Todo 

## Must be done before releasing to the world

Finishing pages:
- add example in quickstart section to index.
- make make diamonds presentable 
	- including maybe transition curves? (arrow plots are not so nice)
- another example, e.g. give me some credit (nice b/c it's logistic)
- document every function other people would use, with example
- Transition Plots -- maybe add another way to visualize the same effect, e.g. input vs. delta output? and/or improve the original one (opacity?)
	- something like this?: make 30 pairings for each of 100 original points. Draw lines instead of arrows. (include the original point for this! current pairs DF excludes original point.) maybe very thin lines with large and somewhat transparent points? for a sense of the density. 

## Todo later

See the [future work](http://www.davidchudzicki.com/predcomps/more-future-work.html) section of the documentation.

## Documentation

The [documentation](http://www.davidchudzicki.com/predcomps/) is hosted on Github pages using a theme by [orderedlist](https://github.com/orderedlist).


-----

Next steps for me:

- Check on interactions (9 inputs) example.
- More work on credit example, including:
	- Visualizing distribution of transition-tos (as compared with original distribution)
	- Predictive comparison curves
	- Finding the interactions that the absolute/signed differences suggest are there
 - document weights situation better
	 - explain more concisely about renormalizing (it's obvious enough not to need long explanation)
	 - explain about why 1/distance doesn't weight nearby points enough (sphere's surphace grows as distance^n)
	 - explain my "closest n only" heuristic
	 - explain bias/variance tradeoff in nearness vs. more points -- replace the "limit as n-->infty" page with a section on this page
