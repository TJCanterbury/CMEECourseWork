t <- seq(0, 22, 2)
N <- c(32500, 33000, 38000, 105000, 445000, 1430000, 3020000, 4720000, 5670000, 5870000, 5930000, 5940000)

set.seed(1234) # set seed to ensure you always get the same random sequence  

data <- data.frame(t, N + rnorm(length(time),sd=.1)) # add some random error

names(data) <- c("Time", "N")

head(data)

library(ggplot2)
ggplot(data, aes(x = Time, y = N)) + 
    geom_point(size = 3) +
    labs(x = "Time (Hours)", y = "Population size (cells)")
data$LogN <- log(data$N)

# visualise
ggplot(data, aes(x = t, y = LogN)) + 
    geom_point(size = 3) +
    labs(x = "Time (Hours)", y = "log(cell number)")

(data[data$Time == 10,]$LogN - data[data$Time == 4,]$LogN)/(10-4)

lm_growth <- lm(LogN ~ Time, data = data[data$Time > 2 & data$Time < 12,])
summary(lm_growth)
logistic_model <- function(t, r_max, N_max, N_0){ # The classic logistic equation
  return(N_0 * N_max * exp(r_max * t)/(N_max + N_0 * (exp(r_max * t) - 1)))
}
# first we need some starting parameters for the model
N_0_start <- min(data$N) # lowest population size
N_max_start <- max(data$N) # highest population size
r_max_start <- 0.62 # use our linear estimate from before

fit_logistic <- nlsLM(N ~ logistic_model(t = Time, r_max, N_max, N_0), data,
                      list(r_max=r_max_start, N_0 = N_0_start, N_max = N_max_start))

summary(fit_logistic)

# plot it:
timepoints <- seq(0, 22, 0.1)

logistic_points <- logistic_model(t = timepoints, r_max = coef(fit_logistic)["r_max"], N_max = coef(fit_logistic)["N_max"], N_0 = coef(fit_logistic)["N_0"])
df1 <- data.frame(timepoints, logistic_points)
df1$model <- "Logistic equation"
names(df1) <- c("Time", "N", "model")

ggplot(data, aes(x = Time, y = N)) +
  geom_point(size = 3) +
  geom_line(data = df1, aes(x = Time, y = N, col = model), size = 1) +
  theme(aspect.ratio=1)+ # make the plot square 
  labs(x = "Time", y = "Cell number")

ggplot(data, aes(x = Time, y = LogN)) +
  geom_point(size = 3) +
  geom_line(data = df1, aes(x = Time, y = log(N), col = model), size = 1) +
  theme(aspect.ratio=1)+ 
  labs(x = "Time", y = "log(Cell number)")