library('tidyverse')
library('ggplot2')
library('lme4')
library(gridExtra)
library(grid)
library(ggpubr)
#read
CompareAIC <- read.csv('../Results/res.csv')%>%
    mutate(n = Range/Density) %>%
    filter(n < 200)

#clean
row_sub = apply(CompareAIC, 1, function(row) all(row !=0 |row !='nan'|row !='inf'))
CompareAIC <- CompareAIC[row_sub,]

#Prep for kite
ComAIC <- CompareAIC %>% 
    as.data.frame %>% 
    gather(Model, AIC, Schoolfield:Quadratic)

#Prep fpr range
LargeRan<-subset(ComAIC, Range > 30)
SmallRan<-subset(ComAIC, Range < 30)

i1<-subset(ComAIC, Range <= 10)
i2<-subset(ComAIC, 10 < Range & Range <= 20)
i3<-subset(ComAIC, 20 < Range & Range <= 30)
i4<-subset(ComAIC, 30 < Range & Range <= 40)
i5<-subset(ComAIC, 40 < Range & Range <= 50)
i6<-subset(ComAIC, Range > 50)
#HnL ranges
pdf("../Results/Rangesby10.pdf", onefile=FALSE)
p1 <- ggplot(i1, aes(x = AIC, fill = Model)) + geom_density(alpha=0.5)+
    geom_vline(xintercept=mean(AIC), size=1.5) + xlim(-150, 150) + ggtitle('Range <= 10')+
    theme(panel.grid = element_blank(), axis.title.x = element_blank())
p2 <- ggplot(i2, aes(x = AIC, fill = Model)) + geom_density(alpha=0.5)+
    geom_vline(xintercept=mean(AIC), size=1.5) + xlim(-150, 150)+ ggtitle('10 < Range <= 20')+
    theme( panel.grid = element_blank(), axis.title.x = element_blank())
p3 <- ggplot(i3, aes(x = AIC, fill = Model)) + geom_density(alpha=0.5)+
    geom_vline(xintercept=mean(AIC), size=1.5) + xlim(-150, 150)+ ggtitle('20 < Range <= 30')+
    theme(panel.grid = element_blank(), axis.title.x = element_blank())
p4 <- ggplot(i4, aes(x = AIC, fill = Model)) + geom_density(alpha=0.5)+
    geom_vline(xintercept=mean(AIC), size=1.5) + xlim(-150, 150)+ ggtitle('30 < Range <= 40')+
    theme(panel.grid = element_blank(), axis.title.x = element_blank())
p5 <- ggplot(i5, aes(x = AIC, fill = Model)) + geom_density(alpha=0.5)+
    geom_vline(xintercept=mean(AIC), size=1.5) + xlim(-150, 150)+ ggtitle('40 < Range <= 50')+
    theme(panel.grid = element_blank(), axis.title.x = element_blank())
p6 <- ggplot(i6, aes(x = AIC, fill = Model)) + geom_density(alpha=0.5)+
    geom_vline(xintercept=mean(AIC), size=1.5) + xlim(-150, 150)+ ggtitle('50 < Range')+
    theme(panel.grid = element_blank())
Ranges <- ggarrange(p1, p2, p3, p4, p5, p6, nrow=6, common.legend = TRUE, legend="bottom")
print(Ranges)
dev.off()

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
t.test(LRan$Briere, LRan$Schoolfield)
t.test(LRan$Quadratic, LRan$Schoolfield)
t.test(LRan$Quadratic, LRan$Briere)
t.test(SRan$Briere, SRan$Schoolfield)
t.test(SRan$Quadratic, SRan$Schoolfield)
t.test(SRan$Quadratic, SRan$Briere)
t.test(CompareAIC$Briere,CompareAIC$Schoolfield)
t.test(CompareAIC$Quadratic, CompareAIC$Schoolfield)
t.test(CompareAIC$Quadratic, CompareAIC$Briere)

#Plot Range
pdf("../Results/Rangeplot.pdf")
Range <- qplot(Range, AIC, data = ComAIC, geom = c("point", "smooth"), 
      colour = Model, xlab = 'Temperature Range (K)') 
print(Range)
dev.off()

#plot sample sizes
pdf("../Results/Samplesplot.pdf")
sam <- qplot(Density, AIC, data = ComAIC, geom = c("point", "smooth"), 
      colour = Model, xlab = 'Sample Size') 
print(sam)
dev.off()

#Plot Kite
pdf("../Results/Kiteplot.pdf")
Kiteplot <- ggplot(ComAIC, aes(x = Model, y = AIC))+
    geom_violin(aes(fill = Model)) +
    geom_boxplot(width = 0.2) + 
    scale_fill_manual(values = c('#aaff65', '#9e74ff', 'orange')) +
    theme_bw()+
    theme(legend.position = "none")
print(Kiteplot)
dev.off()

#HnL ranges
pdf("../Results/RangesHnL.pdf")
Large <- qplot(AIC, data = LargeRan, geom =  "density", 
      fill = Model, 
      alpha = I(0.5), xlim = c(-100, 100),
      main = 'Ranges Greater than 30 Kelvin')
Small <- qplot(AIC, data = SmallRan, geom =  "density", 
      fill = Model, 
      alpha = I(0.5), xlim = c(-100, 100),
      main = 'Ranges less than 30 Kelvin')
Ranges <- grid.arrange(Small, Large, nrow=2)
print(Ranges)
dev.off()

#Highn
HighnAIC <- read.csv('../Results/res.csv')%>%
    mutate(n = Range/Density) %>%
    filter(n > 200)
row_sub = apply(HighnAIC, 1, function(row) all(row !=0 |row !='nan'|row !='inf'))
HighnAIC <- HighnAIC[row_sub,]
Highn <- HighnAIC %>% 
    as.data.frame %>% 
    gather(Model, AIC, Schoolfield:Quadratic)

pdf("../Results/LargeSample.pdf")
Hn <- qplot(AIC, data = Highn , geom =  "density", 
      fill = Model, 
      alpha = I(0.5),
      main = 'For n > 200')
print(Hn)
dev.off()
