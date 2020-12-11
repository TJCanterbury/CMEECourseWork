library('tidyverse')
library('ggplot2')
library('lme4')

#read
CompareAIC <- read.csv('../Results/res.csv')%>%
    mutate(n = Range/Density)

#clean
row_sub = apply(CompareAIC, 1, function(row) all(row !=0))
CompareAIC <- CompareAIC[row_sub,]
CompareAIC <- CompareAIC[complete.cases(CompareAIC), ]
#Prep for kite
ComAIC <- CompareAIC %>% 
    as.data.frame %>% 
    gather(Model, AIC, Schoolfield:Quadratic)

#Prep fpr range
LargeRan<-subset(ComAIC, Range > 30)
SmallRan<-subset(ComAIC, Range < 30)

#range mixed linear models
lmmH<-lm(AIC~ as.factor(Model) + 1 + (1|n), data=LargeRan)
summary(lmmH)
RepR = 2153.7/(2153.7+436.6)
RepR
lmmL<-lmer(AIC~ Model + 1 + (1|n), data=SmallRan)
summary(lmmL)
RepL <- 2304/(2304+465)
RepL

LRan<-subset(CompareAIC, Range > 30)
SRan<-subset(CompareAIC, Range < 30)

LTBS.test <- t.test(LRan$Briere, LRan$Schoolfield)

t.test(LRan$Quadratic, LRan$Schoolfield)
t.test(LRan$Quadratic, LRan$Briere)
t.test(SRan$Briere, SRan$Schoolfield)
t.test(SRan$Quadratic, SRan$Schoolfield)
t.test(SRan$Quadratic, SRan$Briere)
t.test(CompareAIC$Quadratic, CompareAIC$Schoolfield)
t.test(CompareAIC$Quadratic, CompareAIC$Briere)
t.test(CompareAIC$Briere,CompareAIC$Schoolfield)

#plot Habitat
pdf("../Results/Hab.plot.pdf")
hab <- qplot(AIC, colour = Model, facets = ConTempMethod ~., data = ComAIC, geom =  "density")
print(hab)
dev.off()

#Plot Range
pdf("../Results/Rangeplot.pdf")
Range <- qplot(Range, AIC, data = ComAIC, geom = c("point", "smooth"), 
      colour = Model, xlab = 'Temperature Range (K)', ylim = c(0,1)) 
print(Range)
dev.off()

#plot sample sizes
pdf("../Results/Samplesplot.pdf")
sam <- qplot(Density, AIC, data = ComAIC, geom = c("point", "smooth"), 
      colour = Model, xlab = 'Sample Size', ylim = c(0,1)) 
print(sam)
dev.off()

#plot all the Data ungrouped
pdf("../Results/AICs.pdf", onefile=FALSE)
boopp <- ggplot(ComAIC, aes(x = AIC, fill = Model)) + geom_density(alpha=0.5)+
    geom_vline(xintercept=mean(AIC), size=1.5) + xlim(0, 1) +
    theme(panel.grid = element_blank(), axis.title.x = element_blank())
print(boopp)
dev.off()