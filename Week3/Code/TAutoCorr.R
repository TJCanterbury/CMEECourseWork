load("../Data/KeyWestAnnualMeanTemperature.RData")                                            
head(ats)                                                                                     
str(ats)
plot(ats)

corts <- rep(NA, (nrow(ats)-1))
for ( i in 2:nrow(ats) ){
    print(i)
    corts[i-1] <- cor(ats[i-1:i,2], ats[i-1:i,1])
    print(corts)
}
corts[1]
corts
?cor
cor(ats[1:2,2], ats[1:2,1])
ats[1:2,2]