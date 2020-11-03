library(sf)
# Read in Southern Ocean example data
so_data <- read.csv('../data/Southern_Ocean.csv', header=TRUE)
head(so_data)
# Convert the data frame to an sf object
so_data <- st_as_sf(so_data, coords=c('long', 'lat'), crs=4326)
head(so_data)