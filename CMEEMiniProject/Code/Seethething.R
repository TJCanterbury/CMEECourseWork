library('tidyverse')
library('ggplot2')

B <- read.csv('../Results/Briere.csv')
Q <- read.csv('../Results/Quadratic.csv')
S <- read.csv('../Results/Schoolfield.csv')
Sless <- S[apply(S[,-1], 1, function(x) !all(x==0)),]
Qless <- Q[apply(Q[,-1], 1, function(x) !all(x==0)),]
Bless <- B[apply(B[,-1], 1, function(x) !all(x==0)),]
CompareAIC <- cbind(Sless$AIC, Bless$AIC, Qless$AIC)
boxmodsAIC <- boxplot(CompareAIC, ylim = c(-100, 100))
boxmodsAIC$stats
CompareRSq <- cbind(Sless$RSq, Bless$RSq, Qless$RSq)
boxmodsRSq <- boxplot(Compare, ylim = c(-100, 100))
boxmodsRSq$stats
