library('tidyverse')
library('ggplot2')

#read
CompareAIC <- read.csv('../Results/res.csv')%>%
    mutate(n = Range/Density)

#clean
row_sub = apply(CompareAIC, 1, function(row) all(row !=0))
CompareAIC <- CompareAIC[row_sub,]
CompareAIC <- CompareAIC[complete.cases(CompareAIC), ]
#Prep
ComAIC <- CompareAIC %>% 
    as.data.frame %>% 
    gather(Model, AIC, Schoolfield:Quadratic)

pdf("../Results/piechart.pdf")
n <- length(CompareAIC$Briere)
slices <- round(c(sum(CompareAIC$Schoolfield == 1) / n, sum(CompareAIC$Briere == 1) / n, sum(CompareAIC$Quadratic == 1) / n), 3) * 100
lbls <- c("Sharpe-Schoolfield", "Briere", "Quadratic")
lbls <- paste(lbls, slices)
lbls <- paste(lbls,"%",sep="")
piech <- pie(slices,labels = lbls, col=c('#6820a3', '#649417', '#747474'),
   main=paste("Number of IDs modelled = ", n))
print(piech)
dev.off()

#Plot Range
pdf("../Results/Rangeplot.pdf")
Range <- qplot(Range, AIC, data = ComAIC, geom = c("point", "smooth"), 
      colour = Model, ylab = 'Prob(min vs. i)', xlab = 'Temperature Range (K)', ylim = c(0,1)) 
print(Range)
dev.off()

group_parameter <- function(a, b, param){
    a <- data.frame('Value' = a, 'Group' = rep('Mathematically Estimated', length(a)))
    b <- data.frame('Value' = b, 'Group' = rep('Best Fit', length(b)))
    c <- rbind(a, b)
    c <- data.frame(c, 'Parameter' = param)
    return(c)
}

# make data.frame for parameter values
B0 <- group_parameter(CompareAIC$B01, CompareAIC$B0, 'B0')
El <- group_parameter(CompareAIC$El1, CompareAIC$El, 'El')
Eh <- group_parameter(CompareAIC$Eh1, CompareAIC$Eh, 'Eh')
Tl <- group_parameter(CompareAIC$Tl1, CompareAIC$Tl, 'Tl')
Th <- group_parameter(CompareAIC$Th1, CompareAIC$Th, 'Th')
E <- group_parameter(CompareAIC$E1, CompareAIC$E, 'E')
data <- rbind(B0, El, Eh, Tl, Th, E)

#plot parameter values, both those mathematically estimated and those that gave the best fit
pdf("../Results/Params.pdf", onefile=FALSE)
p <- ggplot(data, aes(x = Value, fill = Group )) +  geom_density(alpha=0.5) + facet_wrap( .~ Parameter, scales = "free")
print(p)
dev.off()