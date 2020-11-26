library('tidyverse')
library('ggplot2')

CompareAIC <- read.csv('../Results/res.csv')
boxmodsAIC <- boxplot(CompareAIC, ylim = c(-100, 100), ylab = "AIC")

ComAIC <- CompareAIC %>% 
        as.data.frame %>% 
        gather(Model, AIC, X.Briere.:X.Cubic.)

pdf("../Results/Kiteplot.pdf")
Kiteplot <- ggplot(ComAIC, aes(x = Model, y = AIC))+
    geom_violin(aes(fill = Model)) +
    geom_boxplot(width = 0.2) + 
    scale_fill_manual(values = c('#aaff65', '#9e74ff', '#ff7474', 'orange', 'grey')) +
    theme_bw()+
    theme(legend.position = "none")+
    ylim(-200, 200)
print(Kiteplot)
dev.off()