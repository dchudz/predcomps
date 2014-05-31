all: root examples more bar.html

root: index.html apc.html impact.html

examples: examples-diamonds.html examples-simulated-linear-model-interactions.html  \
	examples-wine-logistic-regression.html examples-overview.html examples-loan-defaults.html

more: more-compared-with-paper.html more-future-work.html more-pairs-and-weights.html

### Presentations
###
bar.html: ../predcomps/notes/presentations/Bar.Rmd
	Rscript -e " \
	library(knitr); \
	knit('../predcomps/notes/presentations/Bar.Rmd', output='markdown/Bar.md'); \
	system(paste('pandoc -s -S -t slidy --mathjax', 'markdown/Bar.md', '-o', 'presentation-bar.html'))"



### Root
###

index.html: ../predcomps/notes/index.Rmd
	Rscript -e "library(knitr); knit2html('../predcomps/notes/index.Rmd', template='../predcomps/notes/template', output='index.html')"

apc.html: ../predcomps/notes/apc.Rmd
	Rscript -e "library(knitr); knit2html('../predcomps/notes/apc.Rmd', template='../predcomps/notes/template', output='apc.html')"

impact.html: ../predcomps/notes/impact.Rmd
	Rscript -e "library(knitr); knit2html('../predcomps/notes/impact.Rmd', template='../predcomps/notes/template', output='impact.html')"

### Examples
###

examples-overview.html: ../predcomps/notes/examples/overview.Rmd
	Rscript -e "library(knitr); knit2html('../predcomps/notes/examples/overview.Rmd', template='../predcomps/notes/template', output='examples-overview.html');"

examples-wine-logistic-regression.html: ../predcomps/notes/examples/wine-logistic-regression.Rmd
	Rscript -e "library(knitr); knit2html('../predcomps/notes/examples/wine-logistic-regression.Rmd', template='../predcomps/notes/template', output='examples-wine-logistic-regression.html');"

examples-diamonds.html: ../predcomps/notes/examples/diamonds.Rmd
	Rscript -e "library(knitr); knit2html('../predcomps/notes/examples/diamonds.Rmd', template='../predcomps/notes/template', output='examples-diamonds.html');"

examples-simulated-linear-model-interactions.html: ../predcomps/notes/examples/simulated-linear-model-interactions.Rmd
	Rscript -e "library(knitr); knit2html('../predcomps/notes/examples/simulated-linear-model-interactions.Rmd', template='../predcomps/notes/template', output='examples-simulated-linear-model-interactions.html');"

examples-loan-defaults.html: ../predcomps/notes/examples/loan-defaults.Rmd
	Rscript -e "library(knitr); knit2html('../predcomps/notes/examples/loan-defaults.Rmd', template='../predcomps/notes/template', output='examples-loan-defaults.html');"

### More
###
more-compared-with-paper.html: ../predcomps/notes/more/compared-with-paper.Rmd
	Rscript -e "library(knitr); knit2html('../predcomps/notes/more/compared-with-paper.Rmd', template='../predcomps/notes/template', output='more-compared-with-paper.html')"

more-future-work.html: ../predcomps/notes/more/future-work.Rmd
	Rscript -e "library(knitr); knit2html('../predcomps/notes/more/future-work.Rmd', template='../predcomps/notes/template', output='more-future-work.html')"

more-pairs-and-weights.html: ../predcomps/notes/more/pairs-and-weights.Rmd
	Rscript -e "library(knitr); knit2html('../predcomps/notes/more/pairs-and-weights.Rmd', template='../predcomps/notes/template', output='more-pairs-and-weights.html')"






