M <- matrix(runif(1000000),1000,1000)

SumAllElements <- function(M){
  Dimensions <- dim(M)
  Tot <- 0
  for (i in 1:Dimensions[1]){
    for (j in 1:Dimensions[2]){
      Tot <- Tot + M[i,j]
    }
  }
  return (Tot)
}

print(paste("Using loops, the time taken for Vectorise1 in R is ", round(system.time(res1<-SumAllElements(M))[[3]], 2), " seconds", sep=""))

print(paste("Using the in-built vectorized function for Vectorize1 in R, the time taken is ", round(system.time(res1<-sum(M))[[3]], 2), " seconds", sep=""))
