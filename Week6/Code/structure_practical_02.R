
### Practical on genetic drift, mutation and divergence

## the first thing you need to do is to read genomics data for each species from .csv files
# you should reuse the first command you used yesteday

# western
len <- 20000
data_w <- read.csv("../Data/western_banded_gecko.csv", stringsAsFactors=F, header=F, colClasses=rep("character", len))
dim(data_w) # it is always good to check the dimensions of your data frame

# bent-toed
data_b <- read.csv("../Data/bent-toed_gecko.csv", stringsAsFactors=F, header=F, colClasses=rep("character", len))
dim(data_b)

# leopard
data_l <- read.csv("../Data/leopard_gecko.csv", stringsAsFactors=F, header=F, colClasses=rep("character", len))
dim(data_l)

## then you want to calculate the divergence between sequences of bent-toed and leopard

# my suggestion would be to initiliase two variables that work as counters and set them to zero; these variables will count the total number of sites analysed and the total number of diveregent sites
sites_total <- 0
sites_divergent <- 0 

# then one possibility would be to interate across the columns (genomic positions) of data_b (bent-toed) or data_l (leopard) with a for loop
for (i in 1:ncol(data_l)) {

	## you need to discard SNPs within each species! these sites won't be analysed as they can't be assigned as either fixed or diverged; I suggest to have an "if" statement to test the statement of both species not having a SNP at this position (indexed as i)
	if (length(unique(data_l[,i])) == 1 & length(unique(data_b[,i]))) {
		
		sites_total <- sites_total + 1 # increment the counter of sites to analyse

		### with another "if" statement, test if allele are different in the two species; if true, that this is a divergent site and you should increment the corresponding counter
		if (data_b[1,i] != data_l[1,i]) sites_divergent <- sites_divergent + 1

	}
}

## now you have everything to calculate the divergence rate between bent-toed (B) and leopard (L)
div_rate_BL <- sites_divergent/sites_total
div_rate_BL

## redo the above procedure to calculate the divergence rate between all other pairs of species
# remember to reinitialise the counters to zero every time!
sites_total <- 0
sites_divergent <- 0 

# then one possibility would be to interate across the columns (genomic positions) of data_b (bent-toed) or data_l (leopard) with a for loop
for (i in 1:ncol(data_l)) {

	## you need to discard SNPs within each species! these sites won't be analysed as they can't be assigned as either fixed or diverged; I suggest to have an "if" statement to test the statement of both species not having a SNP at this position (indexed as i)
	if (length(unique(data_l[,i])) == 1 & length(unique(data_w[,i]))) {
		
		sites_total <- sites_total + 1 # increment the counter of sites to analyse

		### with another "if" statement, test if allele are different in the two species; if true, that this is a divergent site and you should increment the corresponding counter
		if (data_w[1,i] != data_l[1,i]) sites_divergent <- sites_divergent + 1

	}
}

div_rate_WL <- sites_divergent/sites_total # west vs leopard

sites_total <- 0
sites_divergent <- 0 

# then one possibility would be to interate across the columns (genomic positions) of data_b (bent-toed) or data_l (leopard) with a for loop
for (i in 1:ncol(data_l)) {

	## you need to discard SNPs within each species! these sites won't be analysed as they can't be assigned as either fixed or diverged; I suggest to have an "if" statement to test the statement of both species not having a SNP at this position (indexed as i)
	if (length(unique(data_b[,i])) == 1 & length(unique(data_w[,i]))) {
		
		sites_total <- sites_total + 1 # increment the counter of sites to analyse

		### with another "if" statement, test if allele are different in the two species; if true, that this is a divergent site and you should increment the corresponding counter
		if (data_w[1,i] != data_b[1,i]) sites_divergent <- sites_divergent + 1

	}
}

div_rate_WB <- sites_divergent/sites_total # west vs banded


## from these divergence rates you can infer which pair represents the closes species; the other specie will the the outgroup in our topology

## use the equation shown in class to estimate the mutation rate per site per year using the divergence rate and the divergence time
mut_rate <- div_rate_BL / (2 * 3e7)

## now estimate the divergence time using the just calculated mutation rate and divergence rate of the close pair
div_time <- div_rate_WB / (2 * mut_rate)

cat("\nThe two species have a divergence time of", div_time, "years.")
cat("\nThe most likely species tree is l:(w:b)")







