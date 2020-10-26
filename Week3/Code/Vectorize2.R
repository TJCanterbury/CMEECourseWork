# Runs the stochastic Ricker equation with gaussian fluctuations

rm(list=ls())

stochrick<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100)
{
  #initialize
  N<-matrix(NA,numyears,length(p0))
  N[1,]<-p0
  
  for (pop in 1:length(p0)){#loop through the populations
    
    for (yr in 2:numyears){ #for each pop, loop through the years

      N[yr,pop] <- N[yr-1,pop] * exp(r * (1 - N[yr - 1,pop] / K) + rnorm(1,0,sigma))
    
    }
  
  }
 return(N)

}

# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 

stochrickvect <- function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100)
{
  #initialize
  N<-matrix(NA,numyears,length(p0))
  N[1,]<-p0
  
  raN<- matrix(rnorm(100000,0,sigma), numyears, length(p0))
  
  for (yr in 2:numyears){ #for each pop, loop through the years
    N[yr,] <- N[yr-1,] * exp(r * (1 - N[yr - 1,] / K) + raN[yr,])
    
    }

  return(N)
}

print("Stochastic Ricker takes:")
print(system.time(res1<-stochrick(K=10000)))
print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect(K=10000)))
plot(res2[,1],type='l', col = 'red', ylim=c(0,20000), ylab="Population") 
par(new = TRUE)
plot(res1[,1], type = 'l', col = 'green', ylim=c(0,20000), ylab="Population") 