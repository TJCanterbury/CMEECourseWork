library('tidyverse')

Data <- read.csv('../Data/ThermRespData.csv')
head(Data)
table(Data)

Res_Data <- read.csv('../Results/res.csv') %>%
    filter(Schoolfield + Briere + Quadratic > 0) %>%
    select(B0, E, El, Eh, Tl, Th)
summary(Res_Data) 

Res_Data_Skew <- Res_Data %>%
    summarise(Tl_skew = (3*(mean(Tl) - median(Tl)))/sd(Tl),
    Th_skew = (3*(mean(Th) - median(Th)))/sd(Th),
    E_skew = (3*(mean(E) - median(E)))/sd(E),
    El_skew = (3*(mean(El) - median(El)))/sd(El),
    Eh_skew = (3*(mean(Eh) - median(Eh)))/sd(Eh),
    B0_skew = (3*(mean(B0) - median(B0)))/sd(B0),)
Res_Data_Skew

library(xtable)


