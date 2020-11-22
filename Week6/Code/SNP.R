library(tidyverse)
bears <- read.csv("../Data/bears.csv",
stringsAsFactors=F, header=F, colClasses=rep("character", 10000))

#SNPs
SNPS <- rep(NA,10000)
for (i in 1:ncol(bears)){
    if(length(unique(bears[,i])) > 1){
        SNPS[i] <- i
    }
}
SNPS<- SNPS[!is.na(SNPS)]
head(SNPS)
SNPs <- bears[,SNPS]
head(SNPs)
s<-matrix(NA, ncol = 9, nrow = 100)
colnames(s) <- c("Allele 1", "p", "Allele 2", "q", "p^2", "2pq", "q^2", "E_Homozygosity", "E_Heterozygosity")
for ( i in 1:ncol(SNPs) ){
    s[i, 1] <- sort(unique(SNPs[,i]))[1]
    s[i,2] <- as.numeric(sum(str_count(SNPs[,i], s[i,1]))/nrow(SNPs))
    s[i,3] <- sort(unique(SNPs[,i]))[2]
    s[i,4] <- 1-as.numeric(s[i,2])
    s[i,5] <- as.numeric(s[i,2])^2
    s[i,6] <- 2 * as.numeric(s[i,2]) * as.numeric(s[i,4])
    s[i,7] <- as.numeric(s[i,4])^2
    s[i,8] <- as.numeric(s[i,5]) + as.numeric(s[i,7])
    s[i,9] <- 1 - as.numeric(s[i,8])
}
head(s)

##genotypes
#paste together chromosomes from the same bears
even_indexes <- seq(2, 40, 2)
odd_indexes <- seq(1,39, 2)

b1 <- subset(bears[odd_indexes,])
b2 <- subset(bears[even_indexes,])

bs<-matrix(NA, ncol = ncol(b1), nrow = nrow(b1))
for (i in 1:20){
    bs[i,]<-c(paste(b1[i,], b2[i,], sep = ""))
}
head(bs)

#find frequencies of genotypes
GenS <- rep(NA,10000)
for (i in 1:ncol(bs)){
    if(length(unique(bs[,i])) > 1){
        GenS[i] <- i
    }
}
GenS<- GenS[!is.na(GenS)]
head(GenS)
Gens <- bs[,GenS]
head(Gens)
g<-matrix(NA, ncol = 10, nrow = 100)
colnames(g) <- c("Genoptype 1", "freq1", "Genotype 2", "freq2", "Genotype 3", "freq3", "Genotype 4", "freq4", "Homozygosity", "Heterozygosity")
for ( i in 1:ncol(Gens) ){
    ho1 = 0
    ho2 = 0
    ho3 = 0
    ho4 = 0
    g[i,1] <- sort(unique(Gens[,i]))[1]
    g[i,2] <- as.numeric(sum(str_count(Gens[,i], g[i,1]))/nrow(Gens))
    try(if (substring(g[i,1], 1,1)==substring(g[i,1], 2, 2)){
        ho1 <- g[i,2]
    })
    g[i,3] <- sort(unique(Gens[,i]))[2]
    g[i,4] <- as.numeric(sum(str_count(Gens[,i], g[i,3]))/nrow(Gens))
    try(if (substring(g[i,3], 1,1)==substring(g[i,3], 2, 2)){
        ho2 <- g[i,4]
    })
    g[i,5] <- sort(unique(Gens[,i]))[3]
    g[i,6] <- as.numeric(sum(str_count(Gens[,i], g[i,5]))/nrow(Gens))
    try(if (substring(g[i,5], 1,1)==substring(g[i,5], 2, 2)){
        ho3 <- g[i,6]
    })
    g[i,7] <- sort(unique(Gens[,i]))[4]
    g[i,8] <- as.numeric(sum(str_count(Gens[,i], g[i,7]))/nrow(Gens))
    try(if (substring(g[i,7], 1,1)==substring(g[i,7], 2, 2)){
        ho4 <- g[i,8]
    })
    g[i,9] <- as.numeric(ho1)+as.numeric(ho2)+as.numeric(ho3)+as.numeric(ho4)
    g[i,10] <- 1 - as.numeric(g[i,9])
}
head(g)
head(s)
data <- cbind(g,s) 
head(data)
d<- as.data.frame(data, stringsAsFactors = F) 
d$Heterozygosity<- as.numeric(d$Heterozygosity)
d$E_Heterozygosity<- as.numeric(d$E_Heterozygosity)
d$Homozygosity<- as.numeric(d$Homozygosity)
d$E_Homozygosity<- as.numeric(d$Homozygosity)


d <- d%>%
    mutate(F = (as.numeric(E_Heterozygosity) - as.numeric(Heterozygosity))/as.numeric(E_Heterozygosity)) 
head(d)
str(data)