
# Practical on population structure from genomic data of turtles

### Read genotype data (as binary matrix, like done for the killer whale data)
len <- 2000
data <- as.matrix(read.csv("../Data/turtle.genotypes.csv", stringsAsFactors=F, header=F, colClasses=rep("numeric", len)))
dim(data)

### you may wish to assign a name (A,B,C,D) for each location; create a variable that contains this information
locations <- .... # hint: use "rep", type ?rep for help

## 1) Population subdivision

### To test whether there is population subdivision we can do several things
# A: build a tree, B: do a PCA, C: calculate FST
# pick one, here some suggestions for the related code with functions to use

# option A:
### we can build a tree of all samples and check whether we observe some cluster
### we can do this by first constructing a genetic distance matrix and then a tree
# genetic distance: https://en.wikipedia.org/wiki/Genetic_distance

distance <- dist(data)
tree <- hclust(distance)

plot(tree, labels=locations)

## option B:
### alternatively we can do a PCA (principal component analysis)
# https://en.wikipedia.org/wiki/Principal_component_analysis

colors <- rep(c("blue","red","yellow","green"), each=10)

index <- which(apply(FUN=sum, X=data, MAR=2)/(nrow(data)*2)>0.05)

pca <- prcomp(data[,index], center=T, scale=T)

summary(pca)

plot(pca$x[,1], pca$x[,2], col=colors, pch=1)
legend("right", legend=sort(unique(locations)), col=unique(colors), pch=1)

## option C:
### we can calculate FST between locations from haplotype
data2 <- as.matrix(read.csv("../Data/turtle.csv", stringsAsFactors=F, header=F, colClasses=rep("numeric", len)))

calcFST <- function(pop1, pop2) {

	# only for equal sample sizes!

	fA1 <- as.numeric(apply(FUN=sum, X=pop1, MAR=2)/nrow(pop1))
	fA2 <- as.numeric(apply(FUN=sum, X=pop2, MAR=2)/nrow(pop2))

	FST <- rep(NA, length(fA1))

	for (i in 1:length(FST)) {

		HT <- 2 * ( (fA1[i] + fA2[i]) / 2 ) * (1 - ((fA1[i] + fA2[i]) / 2) )
		HS <- fA1[i] * (1 - fA1[i]) + fA2[i] * (1 - fA2[i]) 

		FST[i] <- (HT - HS) / HT

	}
	FST
}

snps <- which(apply(FUN=sum, X=data2, MAR=2)/(nrow(data2))>0.05)

cat("\nFST value (average):",
"\nA vs B", mean(calcFST(data2[1:20,snps], data2[21:40,snps]), na.rm=T),
"\nA vs C", mean(calcFST(data2[1:20,snps], data2[41:60,snps]), na.rm=T),
"\nA vs D", mean(calcFST(data2[1:20,snps], data2[61:80,snps]), na.rm=T),
"\nB vs C", mean(calcFST(data2[21:40,snps], data2[41:60,snps]), na.rm=T),
"\nB vs D", mean(calcFST(data2[21:40,snps], data2[61:80,snps]), na.rm=T),
"\nC vs D", mean(calcFST(data2[41:60,snps], data2[61:80,snps]), na.rm=T),"\n")

