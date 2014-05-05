library(randomForest)
library(predcomps)
library(ggplot2)
theme_set(theme_gray(base_size = 18))

credit <- read.csv("~/Downloads/cs-training.csv")[,-1]

credit2 <- credit
credit2 <- subset(credit2, !is.na(MonthlyIncome) &
                    NumberOfTime30.59DaysPastDueNotWorse < 5 & 
                    RevolvingUtilizationOfUnsecuredLines <= 2 &
                    NumberOfTime30.59DaysPastDueNotWorse <= 5 &
                    NumberOfTime60.89DaysPastDueNotWorse <= 5 &
                    NumberOfTimes90DaysLate <= 5 &
                    MonthlyIncome < 5e4 &
                    DebtRatio < 2 &
                    NumberRealEstateLoansOrLines <= 12 &
                    NumberOfDependents < 10                  
)

for (col in names(credit2)) {
  print(qplot(credit2[[col]]) + ggtitle(col))
}

credit2$SeriousDlqin2yrs <- factor(credit2$SeriousDlqin2yrs)
rfFit <- randomForest(SeriousDlqin2yrs ~ ., data=credit2, ntree=10)

credit2Small <- credit2[sample.int(nrow(credit2), size = 1000), ]


X1 <- credit2[sample.int(nrow(credit2), size = 50), ]
X2 <- credit2

dim(X1)

u="age"
v = c("RevolvingUtilizationOfUnsecuredLines", "NumberOfTime30.59DaysPastDueNotWorse", 
      "DebtRatio", "MonthlyIncome", "NumberOfOpenCreditLinesAndLoans", 
      "NumberOfTimes90DaysLate", "NumberRealEstateLoansOrLines", "NumberOfTime60.89DaysPastDueNotWorse", 
      "NumberOfDependents")
mahalanobisConstantTerm = 1
renormalizeWeights=TRUE
removeDiagonal=TRUE
onlyIncludeNearestN=500

X1 <- X1[c(v,u)]
X2 <- X2[c(v,u)]

X1$OriginalRowNumber <- 1:nrow(X1)
X2$OriginalRowNumber.B <- 1:nrow(X2)

vMatrix1 <- as.matrix(X1[,v])
vMatrix2 <- as.matrix(X2[,v])


covV=cov(vMatrix2)

distMatrix <- apply(vMatrix1, 1, function(row) mahalanobis(vMatrix2, row, covV))
dim(distMatrix)

colnames(distMatrix) <- 1:ncol(distMatrix)
rownames(distMatrix) <- 1:nrow(distMatrix)
distDF <- as.data.frame(as.table(distMatrix))
names(distDF) <- c("OriginalRowNumber.B", "OriginalRowNumber", "MahalanobisDistance")

distDF <- distDF %.% group_by(OriginalRowNumber) %.% filter(rank(MahalanobisDistance) < onlyIncludeNearestN)
pairs <- merge(X1, distDF, by = "OriginalRowNumber")
pairs <- merge(X2, pairs, by = "OriginalRowNumber.B", suffixes = c(".B", ""))
pairs$Weight <- 1/(mahalanobisConstantTerm + pairs$MahalanobisDistance)
if (removeDiagonal) {
  pairs <- subset(pairs, OriginalRowNumber != OriginalRowNumber.B) #remove pairs where both elements are the same
}


if (renormalizeWeights) {
  #     pairs <- pairs %.% group_by(OriginalRowNumber) %.% mutate(Weight = Weight/sum(Weight))
  #     browser()
  pairs <- mutate(group_by(pairs, OriginalRowNumber),
                  Weight = Weight/sum(Weight))
  pairs <- data.frame(pairs)
} #normalizing AFTER removing pairs from same row as each other


# pairs <- pairs[c("OriginalRowNumber",u,v,paste0(u,".B"),"Weight")]


PlotPairCumulativeWeights(pairs)

pairs$OriginalRowNumber
ggplot(pairs) + geom_histogram(aes(x=MahalanobisDistance)) + 
  #scale_x_log10(limits=c(1e-3,1e3)) + 
  facet_wrap(~ OriginalRowNumber)
ggplot(pairs) + geom_histogram(aes(x=MahalanobisDistance, weight = Weight)) + 
  #scale_x_log10(limits=c(1e-3,1e3)) + 
  facet_wrap(~ OriginalRowNumber)

library(dplyr)

  
PlotPairCumulativeWeights(GetPairs(credit2Small, u=u, v=v, mahalanobisConstantTerm=0))
