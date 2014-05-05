# should be executed from package root
library(testthat)
library(devtools)

setwd("~/github/predcomps")
document(".")
install(".")
test_package("predcomps")
