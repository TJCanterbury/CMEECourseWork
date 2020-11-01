insect <- read.csv("../Data/InsData.csv")
abunsect<-sort(table(insect$SPECIES), decreasing = T ) 
plot(abunsect)
library(dplyr)
str(insect)
library(stringr)
ErisData<-insect
ErisData$Date<-as.Date(ErisData$DATE) 
ErisData$Species <- as.character(ErisData$SPECIES)
Eris<-droplevels(ErisData)%>%
    group_by(Date) %>%
    summarise(Species_Richness = length(unique(Species)))
str(Eris)
lm(Eris$Species_Richness~Eris$Date) 
plot(Eris)
Eris