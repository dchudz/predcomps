# should be executed from package root
library(testthat)
library(devtools)

document()
load_all()

test_package("predcomps")
