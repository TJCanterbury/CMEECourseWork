############# Import and cleanup data ################
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")

MyDF$Type.of.feeding.interaction <- as.factor(MyDF$Type.of.feeding.interaction)
MyDF$Location <- as.factor(MyDF$Location)

library(tidyverse)
glimpse(MyDF)

############# Stats summary ###############

Pred <- MyDF %>%
    group_by(Type.of.feeding.interaction) %>%
    mutate(Log10.predator.mass=log10(Predator.mass), Log10.prey.mass = log10(Prey.mass)) %>%
    mutate(Log10.pred.prey.ratio = log10(Predator.mass/Prey.mass))
PredSumm <- Pred %>%
    summarise(Mean.log10.predator.Mass = mean(Log10.predator.mass), Median.log10.predator.Mass = median(Log10.predator.mass), 
        Mean.log10.prey.Mass = mean(Log10.prey.mass), Median.log10.prey.mass = median(Log10.prey.mass), Mean.log10.ratio = mean(Log10.pred.prey.ratio), 
        Median.log10.ratio = median(Log10.pred.prey.ratio))
head(PredSumm)
write.csv(PredSumm, "../Results/PP_Results.csv")

############# Make sub plots ##################
# Open pdf for exporting Predator sub plots
pdf("../Results/Pred_Subplots.pdf", 11.7, 8.3)
par(mfrow = c(2,3))
for (i in 1:nlevels(Pred$Type.of.feeding.interaction)){
    Ins <- subset(Pred, Type.of.feeding.interaction == levels(Pred$Type.of.feeding.interaction)[i])
    hist(Ins$Log10.predator.mass, xlab = "Predator Mass (g)", main = levels(Pred$Type.of.feeding.interaction)[i])
}
plot(Pred$Log10.predator.mass~Pred$Type.of.feeding.interaction, ylab = "log10 Predator Mass (g)", xlab = "Type of feeding interaction", col = "#ff6f6f")
graphics.off(); 

# Open pdf for exporting Predator sub plots
pdf("../Results/Prey_Subplots.pdf", 11.7, 8.3)
par(mfrow = c(2,3))
for (i in 1:nlevels(Pred$Type.of.feeding.interaction)){
    Ins <- subset(Pred, Type.of.feeding.interaction == levels(Pred$Type.of.feeding.interaction)[i])
    hist(Ins$Log10.prey.mass, xlab = "Predator Mass (g)", main = levels(Pred$Type.of.feeding.interaction)[i])
}
plot(Pred$Log10.prey.mass~Pred$Type.of.feeding.interaction, ylab = "log10 Prey Mass (g)", xlab = "Type of feeding interaction", col = "#d0ff93")
graphics.off();

# Open pdf for exporting Predator sub plots
pdf("../Results/SizeRatio_Subplots.pdf", 11.7, 8.3)
par(mfrow = c(2,3))
plot(Pred$Log10.pred.prey.ratio~Pred$Type.of.feeding.interaction, ylab = "log10 Predator:Prey Mass (g)", xlab = "Type of feeding interaction", col = "#d598fd")
for (i in 1:nlevels(Pred$Type.of.feeding.interaction)){
    Ins <- subset(Pred, Type.of.feeding.interaction == levels(Pred$Type.of.feeding.interaction)[i])
    plot(Ins$Log10.predator.mass,Ins$Log10.prey.mass, xlab = "Predator Mass (g)", ylab = "Prey Mass (g)", pch = 20, main = levels(Pred$Type.of.feeding.interaction)[i])
}
graphics.off();
