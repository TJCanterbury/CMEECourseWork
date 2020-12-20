########## Load data and packages ##########
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")
head(MyDF)
library(ggplot2
library(tidyverse)
library(broom)

########## Analysis ###########
Pred <- MyDF %>%
    group_by(Type.of.feeding.interaction, Predator.lifestage) %>%
    mutate(Log10.predator.mass=log10(Predator.mass), Log10.prey.mass = log10(Prey.mass)) %>%
    do(fitPred = glance(lm(Log10.predator.mass~Log10.prey.mass, data= .))) %>%
    unnest(fitPred)
head(Pred)
write.csv(Pred, "../Results/PP_Regress_Results.csv")

########## Print ggplot ###########
p <- ggplot(MyDF, aes(x = log10(Prey.mass), y = log10(Predator.mass), colour = Predator.lifestage)) +
geom_point(shape=I(3))+ facet_grid( Type.of.feeding.interaction ~.)  + geom_smooth(method=lm, fullrange =TRUE)+
theme(legend.position = "bottom") + xlab("Prey mass in grams") + ylab("Predator mass in grams")+
guides(colour = guide_legend(nrow = 1)) + theme(aspect.ratio=1/3)
pdf("../Results/PP_Regress.pdf")
print(p)
dev.off()