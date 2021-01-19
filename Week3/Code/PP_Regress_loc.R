########## Load data and packages ##########
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")
head(MyDF)
library(ggplot2)
library(broom)
library(tidyverse)

########## Analysis ###########
Pred <- MyDF %>%
    group_by(Type.of.feeding.interaction, Predator.lifestage, Location) %>%
    mutate(Log10.predator.mass=log10(Predator.mass), Log10.prey.mass = log10(Prey.mass)) %>%
    do(fitPred = glance(lm(Log10.predator.mass~Log10.prey.mass, data= .))) %>%
    unnest(fitPred)
head(Pred)
print(paste("Results for PP_Regress_loc.R can be found at", location <- "../Results/PP_Regress_loc_Results.csv"))
write.csv(Pred, location)