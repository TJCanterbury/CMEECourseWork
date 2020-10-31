require(WebPower)
y <- rnorm(51, mean = 1, sd = 1.3)
x <- seq(from=0, to=5, by=0.1)

plot(hist(y, breaks=10))
mean(y)
sd(y)
segments(x0=(mean(y)), y0=(0), x1=(mean(y)), y1=40, lty=1, col="blue")
segments(x0=(mean(y)+0.25*sd(y)), y0=(0), x1=(mean(y)+0.25*sd(y)), y1=40, lty=1, col="red")

?wp.t
q
wp.t(d=0.25, power=0.8, type="two.sample", alternative="two.sided")

res.1<-wp.t(n1=seq(20,300,20), n2=seq(20,300, 20), d = 0.5, type="two.sample.2n", alternative="two.sided")
res.1
plot(res.1, xvar='n1', yvar='power')

wp.t(d=0.11, power=0.8, type="two.sample", alternative="two.sided")

#Linear modelling
x <- c(1,2,3,4,8)
y <- c(4,3,5,7,9)
mean(x)
var(x)
mean(y)
var(y)
mod <- lm(y~x)
summary(mod)
plot(y~x, pch = 19, xlim = c(0,8.5), ylim = c(0, 9.5))
segments(0,-30,0,30, lty=3)
segments(-30,0,30,0,lty=3)
coefficients(mod)
abline(2.62, 0.83)

#part2
wsdgsd

#Wed, Correlations and such
y1 <- rnorm(10, mean=0, sd=sqrt(1))
var(y1)
y2 <- rnorm(10, mean=0, sd=sqrt(10))
var(y2)
y3 <- rnorm(10, mean=0, sd=sqrt(100))
x<-rep(0,10)
par(mfrow = c(1, 3))
plot(x, y1, xlim=c(-0.1, 0.1), ylim=c(-12,12), pch=19, cex=0.8, col="red")
abline(v=0)
abline(h=0)
plot(x, y2, xlim=c(-0.1,0.1), ylim=c(-12,12), pch=19,cex=0.8, col="blue")
abline(v=0)
abline(h=0)
plot(x, y3, xlim=c(-0.1,0.1), ylim=c(-12, 12), pch=19, cex=0.8, col="darkgreen")
abline(v=0)
abline(h=0)
?polygon()
par(mfrow=c(1,3))
plot(x, y1,xlim=c(-12,12), ylim=c(-12,12), pch=19, cex=0.8, col="red")
polygon(x=c(0,0,y1[1], y1[1]), y=c(0,y1[1], y1[1], 0), col=rgb(1,0,0,0.2))
polygon(x=c(0,0,y1[2], y1[2]), y=c(0,y1[2], y1[2], 0), col=rgb(1,0,0,0.2))
polygon(x=c(0,0,y1[3],y1[3]),y=c(0,y1[3],y1[3],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[4],y1[4]),y=c(0,y1[4],y1[4],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[4],y1[4]),y=c(0,y1[4],y1[4],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[5],y1[5]),y=c(0,y1[5],y1[5],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[6],y1[6]),y=c(0,y1[6],y1[6],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[7],y1[7]),y=c(0,y1[7],y1[7],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[8],y1[8]),y=c(0,y1[8],y1[8],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[9],y1[9]),y=c(0,y1[9],y1[9],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[10],y1[10]),y=c(0,y1[10],y1[10],0), col=rgb(1, 0, 0,0.2))

# lets plot this again, this time with the squares.
?polygon()
par(mfrow = c(1, 3))
plot(x, y1, xlim=c(-12,12), ylim=c(-12,12) ,pch=19, cex=0.8, col="red")
abline(v=0)
abline(h=0)
polygon(x=c(0,0,y1[1],y1[1]),y=c(0,y1[1],y1[1],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[2],y1[2]),y=c(0,y1[2],y1[2],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[3],y1[3]),y=c(0,y1[3],y1[3],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[4],y1[4]),y=c(0,y1[4],y1[4],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[4],y1[4]),y=c(0,y1[4],y1[4],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[5],y1[5]),y=c(0,y1[5],y1[5],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[6],y1[6]),y=c(0,y1[6],y1[6],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[7],y1[7]),y=c(0,y1[7],y1[7],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[8],y1[8]),y=c(0,y1[8],y1[8],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[9],y1[9]),y=c(0,y1[9],y1[9],0), col=rgb(1, 0, 0,0.2))
polygon(x=c(0,0,y1[10],y1[10]),y=c(0,y1[10],y1[10],0), col=rgb(1, 0, 0,0.2))
# that was hard work and I'm lazy, so I'll write a for loop for the next two:
plot(x, y2, xlim=c(-12,12), ylim=c(-12,12), pch=19, cex=0.8, col="blue")

abline(v=0)
abline(h=0)
for (i in 1:length(y2)) {
polygon(x=c(0,0,y2[i],y2[i]),y=c(0,y2[i],y2[i],0), col=rgb(0, 0, 1,0.2))
}
plot(x, y3, xlim=c(-12,12), ylim=c(-12,12), pch=19, cex=0.8,, col="darkgreen"
)
abline(v=0)
abline(h=0)
for (i in 1:length(y3)) {
polygon(x=c(0,0,y3[i],y3[i]),y=c(0,y3[i],y3[i],0), col=rgb(0, 1, 0,0.2))
}
rm(list = ls())
par(mfrow = c(1, 3))
x<-c(-10:10)
var(x)
## [1] 38.5
y1<-x*1 + rnorm(21, mean=0, sd=sqrt(1))
# here the association is 1:1
cov(x, y1)
## [1] 39.42318
plot(x, y1, xlim=c(-10,10), ylim=c(-20, 20), col="red", pch=19, cex=0.8, main=paste("Cov=",round(cov(x,y1),digits=2)))
y2<-rnorm(21, mean=0, sd=sqrt(1))
# Here, there is no association
cov(x, y2)
## [1] 1.572258
plot(x, y2, xlim=c(-10,10), ylim=c(-20, 20), col="blue", pch=19, cex=0.8, main=paste("Cov=",round(cov(x,y2),digits=2)))
y3<- x* (-1) +rnorm(21, mean=0, sd=sqrt(1))
# Here, the association is negative
cov(x, y3)
## [1] -34.6899
plot(x, y3, xlim=c(-10,10), ylim=c(-20, 20), col="darkgreen", pch=19, cex=0.8, main=paste("Cov=",round(cov(x,y3),digits=2)))

#More linear modelling
daphnia<- read.delim("daphnia.txt")
summary(daphnia)
head(daphnia)
par(mfrow=c(1,2))
plot(Growth.rate~Detergent, data=daphnia)
plot(Growth.rate~Daphnia, data=daphnia)
require(dplyr)
daphnia%>%
    group_by(Detergent) %>%
    summarise(variance=var(Growth.rate))
daphnia%>%
    group_by(Daphnia) %>%
    summarise(variance=var(Growth.rate))
dev.off()
hist(daphnia$Growth.rate)
seFun <- function(x){
    sqrt(var(x)/length(x))
}
seFun(daphnia$Growth.rate)
detergentMean <- with(daphnia, tapply(Growth.rate, INDEX = Detergent, FUN = mean))
detergentSEM <- with(daphnia, tapply(Growth.rate, INDEX = Detergent, FUN = seFun))
cloneMean <- with(daphnia, tapply(Growth.rate, INDEX = Daphnia, FUN = mean))
cloneSem <- with(daphnia, tapply(Growth.rate, INDEX = Daphnia, FUN = seFun))
?tapply
q
?with
q
par(mfrow=c(2,1), mar = c(4,4,1,1))
barMids <- barplot(detergentMean, xlab = "Detergent type", ylab = "Population growth rate", ylim=c(0,5))
arrows(barMids, detergentMean - detergentSEM, barMids, detergentMean + detergentSEM, code = 3, angle = 90)
barMids <- barplot(cloneMean, xlab = "Daphnia clone", ylab = "Population growth rate", ylim = c(0,5))
arrows(barMids, cloneMean - cloneSem, barMids, cloneMean + cloneSem, code = 3, angle = 90)
daphniaMod <- lm(Growth.rate~Detergent+Daphnia, data = daphnia)
summary(daphniaMod)


































