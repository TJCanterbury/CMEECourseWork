# Runs the stochastic Ricker equation with gaussian fluctuations

rm(list=ls())

stochrick<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100) {
  
   #initialize
  M<-matrix(NA,numyears,length(p0))
  M[1,]<-p0
  
  for (pop in 1:length(p0)){ #loop through the populations
    
    for (yr in 2:numyears){ #for each pop, loop through the years

      M[yr,pop] <- M[yr-1,pop] * exp(r * (1 - M[yr - 1,pop] / K) + rnorm(1,0,sigma))
    
    }
  
  }
 return(M)

}

# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 

stochrickvect <- function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100) {
  
#initialise
  N<-matrix(NA,numyears,length(p0))
  N[1,]<-p0
  
  for (yr in 2:numyears) {
  
  N[yr,] <- N[yr-1,] * exp(r * (1 - N[yr-1,] / K) + rnorm(1,0,sigma))
  #N[3, pop] <- N[2, pop] * exp(r * (1 - N[2, pop] / K) + rnorm(1,0,sigma))
  
  }

  return(N)
  
}

#check if they look OK
#plot(N[,1], type="l", col="red")
#lines(M[,1], type="l", col="blue")

print(paste("Stochastic Ricker model in R takes ", round(system.time(res2<-stochrick())[[3]], 2), " seconds", sep=""))

print(paste("Vectorized Stochastic Ricker model in R takes ", round(system.time(res2<-stochrickvect())[[3]], 2), " seconds", sep=""))
