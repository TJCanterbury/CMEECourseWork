TempResp<- read.csv("../Data//ThermRespData.csv", stringsAsFactors = F, header = T) 
plot(TempResp$OriginalTraitValue~ TempResp$ConTemp )
library(lme4)

#Quadratic lm model of id 110
data_subset = subset(TempResp, TempResp$ID==110)
data_subset$ConTemp2 <- data_subset$ConTemp^2
mod <- lm(OriginalTraitValue ~ ConTemp + ConTemp2, data = data_subset)
summary(mod)
#plot summary of model and predicted vs actual
par(mfrow = c(3,5))
plot(mod)
plot(data_subset$OriginalTraitValue~ data_subset$ConTemp)
lines(data_subset$ConTemp, predict(mod), type = "l")
#cubic
data_subset$ConTemp3 <- data_subset$ConTemp^3
mod <- lm(OriginalTraitValue ~ ConTemp + ConTemp2 + ConTemp3, data = data_subset)
summary(mod)
#plot summary of model and predicted vs actual
plot(mod)
plot(data_subset$OriginalTraitValue~ data_subset$ConTemp)
lines(data_subset$ConTemp, predict(mod), type = "l")

## Attempt to standardize response curves so that all data can be used (Sucks)
library(tidyverse)
Tem <- TempResp %>%
    filter(StandardisedTraitName == "net photosynthesis rate")%>%
    group_by(ID) %>%
    mutate(StaVal = OriginalTraitValue/mean(OriginalTraitValue), ConTemp = ConTemp/mean(ConTemp), ConTemp2 = ConTemp^2, ConTemp3 = ConTemp^3) 

head(Tem)
mod <- lm(StaVal ~ ConTemp + ConTemp2, data = Tem)
summary(mod)
#plot summary of model and predicted vs actual
plot(mod)
plot(Tem$StaVal~Tem$ConTemp)
lines(Tem$ConTemp, predict(mod), col = "red")

#Briere Model (Sucks)
Briere <- TempResp %>%
    filter(ID == 110) %>%
    mutate(Bri = ConTemp * (ConTemp - min(ConTemp))*(max(ConTemp)- ConTemp)^(1/2))

mod <- lm(OriginalTraitValue ~ Bri, data = Briere)
plot(Briere$OriginalTraitValue~Briere$ConTemp)
lines(Briere$ConTemp, predict(mod), col = "red")
max(Briere$ConTemp)

##Schoolfield model

scho <- TempResp %>%
    filter(ID == 110) %>%
    mutate(Bri = exp((
mod <- lm(OriginalTraitValue ~ Bri, data = scho)
plot(scho$OriginalTraitValue~scho$ConTemp)
lines(scho$ConTemp, predict(mod), col = "red")
max(scho$ConTemp)

 



