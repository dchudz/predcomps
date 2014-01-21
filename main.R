library("devtools")
setwd("./average-predictive-comparisons")
getwd()
document()
load_all()



titanic <- read.csv("http://lib.stat.cmu.edu/S/Harrell/data/ascii/titanic.txt", stringsAsFactors=FALSE)

titanicLogit <- glm (survived ~ pclass + age + sex, family=binomial(link="logit"), data=titanic)
titanicLogit
?glm
summary(titanic)
titanic$sex

predict(titanicLogit, titanic)
titanic$age

mean(is.na(titanic$age))

average_specified_comparison(titanicLogit, titanic, input="age", low=10, high=40)
average_specified_comparison(titanicLogit, titanic, input="sex", low="male", high="female")

library(help = "datasets")
