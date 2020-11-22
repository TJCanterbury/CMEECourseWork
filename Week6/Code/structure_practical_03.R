
## Practical on coalescence theory

## first thing, read genomic data for each population
## since the alleles are encoded as 0 and 1 in this case, it's better to store the data as a matrix

# set the length of the region
len <- 50000

# read data from North and south

data_S <- as.matrix(read.csv("../Data/killer_whale_South.csv", stringsAsFactors=F, header=F, colClasses=rep("numeric", len)))
data_N <- as.matrix(read.csv("../Data/killer_whale_North.csv", stringsAsFactors=F, header=F, colClasses=rep("numeric", len))) # reuse previous codes
dim(data_N) # check for dimensions
dim(data_S)


## 1) We wish to estimate of effective population size

### I suggest to use the Tajima's estimator for theta as seen in class (equation 15): this is a relationship between theta (see equation 14, an estimator of genetic diversity) and Ne (population size) and mu (mutation rate)

# therefore you need to write a script that calculates the average number of pairwise differences (or Pi, equation 15).

# start from one population (e.g. North)
n <- nrow(data_N) # nr of samples (chromosomes)
pi_N <- 0 # initialise pi
# the easiet thing will be to loop over all pairs of sequences (you need two nested for loops)
# for instance, if you have 4 sequences, how can you loop over these unique pairs:
# 1 vs 2
# 1 vs 3
# 1 vs 4
# 2 vs 3
# 2 vs 4
# 3 vs 4.
# You have two indexes for the loop. The first index (let's call it i) goes from 1 to 3 (while you have 4 sequences), and the second index (let's call it j) starts from 2 when i=1, starts from 3 when i=2, etc etc, and finished at 4. 
# How can you create these two nested loops?
for (i in 1:(n - 1)) { # loop of i
	for (j in (i+1):n) { # loop of j  
		# count the number of differences between sequence i and j and add it to the variable pi_N
		pi_N <- pi_N + sum(abs(data_N[i,]-data_N[j,]))
	}
}
# divide by the nr of comparisons done
pi_N <- pi_N / ((n*(n-1))/2)
# you obtained a Tajima's estimator of theta for the Northern population

# repeat the same procedure to calculate pi_S (Tajima's estimator of theta for the Northern population)
# start from one population (e.g. North)
n <- nrow(data_S) # nr of samples (chromosomes)
pi_S <- 0 # initialise pi
# the easiet thing will be to loop over all pairs of sequences (you need two nested for loops)
# for instance, if you have 4 sequences, how can you loop over these unique pairs:
# 1 vs 2
# 1 vs 3
# 1 vs 4
# 2 vs 3
# 2 vs 4
# 3 vs 4.
# You have two indexes for the loop. The first index (let's call it i) goes from 1 to 3 (while you have 4 sequences), and the second index (let's call it j) starts from 2 when i=1, starts from 3 when i=2, etc etc, and finished at 4. 
# How can you create these two nested loops?
for (i in 1:(n - 1)) { # loop of i
	for (j in (i+1):n) { # loop of j  
		# count the number of differences between sequence i and j and add it to the variable pi_N
		pi_S <- pi_S + sum(abs(data_S[i,]-data_S[j,]))
	}
}
# divide by the nr of comparisons done
pi_S <- pi_S / ((n*(n-1))/2)
# you obtained a Tajima's estimator of theta for the Northern population


## now that you have theta you can estimate Ne using equation 14 on the slides
# remember to multiple the mutation rate 1e-8 with the length your sequence before plugging it into the equation
Ne_N_pi <- pi_N / (4 * 1e-8 * len)
Ne_S_pi <- pi_S / (4 * 1e-8 * len)

### you can also calculate theta using Watterson's estimator (equation 20)

# first we need to calculate the nr of SNPs
# try to use apply function
# type ?apply to understand how it works
# for instance the following code (when completed) will calculate the allele frequencies
freqs <- apply(X=data_N, MAR=2, FUN=sum)/nrow(data_N)
# why am I using the function "sum"?

# then SNPs are simply sites where the allele frequency freqs is different from 0 or 1
snps_N <- length(which(freqs < 1 & freqs > 0))

# use equation 20 calculate watterson estimator
watt_N <- snps_N / sum(1/seq(1,n-1))

# repeat the same procedure for S population
freqs <- apply(X=data_S, MAR=2, FUN=sum)/nrow(data_N)
# why am I using the function "sum"?

# then SNPs are simply sites where the allele frequency freqs is different from 0 or 1
snps_S <- length(which(freqs < 1 & freqs > 0))

# use equation 20 calculate watterson estimator
watt_S <- snps_S / sum(1/seq(1,n-1))

### estimates of Ne from Wattersons' estimator
Ne_N_watt <- watt_N / (4 * 1e-8 * len)
Ne_S_watt <- watt_S / (4 * 1e-8 * len)

cat("\nThe North population has estimates of effective population size of", Ne_N_pi, "and", Ne_N_watt)
cat("\nThe South population has estimates of effective population size of", Ne_S_pi, "and", Ne_S_watt)


## 2) Site Frequency Spectra

### North population
sfs_N <- rep(0,(n-1)) # initialise a vector from 0 to n-1
### calculate allele frequencies using the apply functions as previously shown
derived_freqs <- apply(X=data_N, MAR=2, FUN=sum)
### the easiest (but slowest) thing to do would be to loop over all possible allele frequencies and count the occurrences of each possible allele frequency
freq_N <- table(derived_freqs)[-1]
for(i in 1:length(sfs_N)) sfs_N[i] <- length(which(derived_freqs==i))

### South population
# repeat as above
sfs_S <- rep(0,(n-1)) # initialise a vector from 0 to n-1
### calculate allele frequencies using the apply functions as previously shown
derived_freqs <- apply(X=data_S, MAR=2, FUN=sum)
freq_S <- table(derived_freqs)[-1]
for (i in 1:length(sfs_S)) sfs_S[i] <- length(which(derived_freqs==i))


### plot
par(mfrow = c(2,1))
barplot(freq_N) # or use any other plotting functions
barplot(freq_S)

barplot(t(cbind(sfs_N, sfs_S)), beside=T, names.arg=seq(1,nrow(data_S)-1,1), legend=c("North", "South"))
