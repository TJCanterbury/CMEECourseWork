rm(list = ls())
while (!is.null(dev.list()))  dev.off()
source("~/tcanterbury_HPC_2020_main.R", encoding = "UTF-8")
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

set.seed(iter)
wall_time <- 11.5 * 60

if ((iter - 1) %% 4 == 0) {
    size = 500
}
if ((iter - 2) %% 4 == 0) {
    size = 1000
}
if ((iter - 3) %% 4 == 0) {
    size = 2500
}
if ((iter - 4) %% 4 == 0) {
    size = 5000
}
interval_oct = size / 10
burn_in_generations = 8 * size
output_file_name <- paste("Result_file_", iter, ".rda", sep = "")
cluster_run(speciation_rate = 0.003926, size = size, wall_time = wall_time, interval_rich = 1, 
    interval_oct = interval_oct, burn_in_generations = burn_in_generations, output_file_name = output_file_name)