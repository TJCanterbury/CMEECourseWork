# load old data
load("../Data/KeyWestAnnualMeanTemperature.RData")         

#find the autocorrelation by cor of misalligned by 1 copies of vector
t0 <- ats[1:(nrow(ats)-1),2]
t1 <- ats[2:(nrow(ats)),2]
corTrue <- cor(t0,t1)


# add to number_bigger whenever a a random permutation of the data gives a stronger correlation
number_bigger <- 0
for ( i in 1:100000 ){ 
    t0 <- sample(ats[,2], size = nrow(ats)-1)
    t1 <- sample(ats[,2], size = nrow(ats)-1)
    corFalse <- cor(t0,t1)
    #print(paste("corFalse: ", corFalse))
    if (corFalse > corTrue ){
        number_bigger = number_bigger + 1
    }
    }

# Calculate p value
p = number_bigger/100000
print(paste( "The p value for this correlation = ", p))