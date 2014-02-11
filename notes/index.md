## Average Predictive Comparisons 

This is an R package implementing some of the ideas in [Gelman and Pardoe 2007](http://onlinelibrary.wiley.com/doi/10.1111/j.1467-9531.2007.00181.x/abstract). **The package is not ready to use.** But if you want it anyway, you can install it with:


```r
library(devtools)  # first install devtools if you haven't
install_github("predcomps", user = "dchudz")
```

```
## Installing github repo predcomps/master from dchudz
## Downloading predcomps.zip from https://github.com/dchudz/predcomps/archive/master.zip
## Installing package from /var/folders/b9/f420rh1x69ldvhcpk8g1ssjw0000gn/T//Rtmp7rqT06/predcomps.zip
## arguments 'minimized' and 'invisible' are for Windows only
## Installing predcomps
## '/Library/Frameworks/R.framework/Resources/bin/R' --vanilla CMD INSTALL  \
##   '/private/var/folders/b9/f420rh1x69ldvhcpk8g1ssjw0000gn/T/Rtmp7rqT06/devtools47c4f79a06d/predcomps-master'  \
##   --library='/Library/Frameworks/R.framework/Versions/3.0/Resources/library'  \
##   --install-tests
```


**The package is not ready to use.**

When the package is ready to use, a short explanation of the ideas will go here. Until then, you'll have to read the paper to have any idea what's going on.

### Differences from the paper

There are plenty of ideas in the paper not implemented yet, but as far as what is implemented, there are only a couple differences from the paper (unless I've messed up):

- [renormalizing weights](renormalize-weights.html)
- absolute average predictive comparisons: as well as the usual APCs, I'm computing an "absolute" version that operates on the absolute value of the predictive comparison rather than the (signed) predictive comparison itself. This will show you if effects with different signs are canceling out in the signed version. Here's [an example](simulated-linear-model-interactions.html)

## Contact

If you're interested in trying this out, send me a note: dchudz@gmail.com
