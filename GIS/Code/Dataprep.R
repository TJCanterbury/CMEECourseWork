radian
library(rgdal)
library(raster)
library(sf)
library(sp)
library(dismo)

tapir_IUCN <- st_read('../Data2/iucn_mountain_tapir/data_0.shp')

# Load teh data frame
tapir_GBIF <- read.delim('../Data2/gbif_mountain_tapir.csv', stringsAsFactors = T)
# Drop rows with missing coordinates
tapir_GBIF <- subset(tapir_GBIF, ! is.na(decimalLatitude) | ! is.na(decimalLongitude))
str(tapir_GBIF)
# Convert to an sf object
tapir_GBIF <- st_as_sf(tapir_GBIF, coords=c('decimalLongitude', 'decimalLatitude'))
st_crs(tapir_GBIF) <- 4326
print(tapir_GBIF)

# Load some (coarse) country background data
ne110 <- st_read('../Data2/ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp')

# Create a modelling extent for plotting and cropping the global data
model_extent <- extent(c(-85, -70, -5, 12))

# Plot the species data over a basemap
plot(st_geometry(ne110), xlim = model_extent[1:2], ylim = model_extent[3:4], bg='lightblue', col='ivory')
plot(st_geometry(tapir_IUCN), add = T, col = 'grey', border = F)
plot(st_geometry(tapir_GBIF), add = T, col = 'red', pch = 4, cex = 0.6)

# Load the data
bioclim_hist <- getData('worldclim', var='bio', res=10, path='../Data2')
bioclim_2050 <- getData('CMIP5', var='bio', res=10, rcp=60, model='HD', year=50, path='../Data2')

# Relabel the future variables to match the historical ones
names(bioclim_2050) <- names(bioclim_hist)

# Look at the data structure
print(bioclim_hist)

par(mfrow=c(3,1), mar=c(1,1,1,1))
# Create a shared colour scheme
breaks <- seq(-300, 350, by=20)
cols <- hcl.colors(length(breaks) - 1)
# Plot the historical and projected data
plot(bioclim_hist[[1]], breaks=breaks, col=cols)
plot(bioclim_2050[[1]], breaks=breaks, col=cols)
# Plot the temperature difference
plot(bioclim_2050[[1]] - bioclim_hist[[1]], col=hcl.colors(20, palette='Inferno'))

bioclim_hist_local <- crop(bioclim_hist, model_extent)
bioclim_2050_local <- crop(bioclim_2050, model_extent)

# Create a simple land mask
land <- bioclim_hist_local[[1]] >= 0
# How many points to create? We'll use the same as number of observations
n_pseudo <- nrow(tapir_GBIF)
# Sample the points
pseudo_dismo <- randomPoints(mask=land, n=n_pseudo, p=st_coordinates(tapir_GBIF))
# Convert this data into an sf object, for consistency with the
# next example.
pseudo_dismo <- st_as_sf(data.frame(pseudo_dismo), coords=c('x','y'), crs=4326)

# Create buffers around the observed points
nearby <- st_buffer(tapir_GBIF, dist=1)
too_close <- st_buffer(tapir_GBIF, dist=0.2)
# merge those buffers
nearby <- st_union(nearby)
too_close <- st_union(too_close)
# Find the area that is nearby but _not_ too close
nearby <- st_difference(nearby, too_close)
# Get some points within that feature in an sf dataframe
pseudo_nearby <- st_as_sf(st_sample(nearby, n_pseudo))

par(mfrow=c(1,2), mar=c(1,1,1,1))
# Random points on land
plot(land, col='grey', legend=FALSE)
plot(st_geometry(tapir_GBIF), add=TRUE, col='red')
plot(pseudo_dismo, add=TRUE)
# Random points within ~ 100 km but not closer than ~ 20 km
plot(land, col='grey', legend=FALSE)
plot(st_geometry(tapir_GBIF), add=TRUE, col='red')
plot(pseudo_nearby, add=TRUE)

# Use kfold to add labels to the data, splitting it into 5 parts
tapir_GBIF$kfold <- kfold(tapir_GBIF, k=5)
# Do the same for the pseudo-random points
pseudo_dismo$kfold <- kfold(pseudo_dismo, k=5)
pseudo_nearby$kfold <- kfold(pseudo_nearby, k=5)


# Get the coordinates of 80% of the data for training 
train_locs <- st_coordinates(subset(tapir_GBIF, kfold != 1))
# Fit the model
bioclim_model <- bioclim(bioclim_hist_local, train_locs)

par(mfrow = c(1,2))
plot(bioclim_model, a = 1, b = 2, p = 0.9)
plot(bioclim_model, a = 1, b = 5, p = 0.9)

bioclim_pred <- predict(bioclim_hist_local, bioclim_model)
# Create a copy removing zero scores to focus on within envelope locations
bioclim_non_zero <- bioclim_pred
bioclim_non_zero[bioclim_non_zero == 0] <- NA
plot(land, col='grey', legend=FALSE)
plot(bioclim_non_zero, col=hcl.colors(20, palette='Blue-Red'), add=TRUE)

test_locs <- st_coordinates(subset(tapir_GBIF, kfold == 1))
test_pseudo <- st_coordinates(subset(pseudo_nearby, kfold == 1))
bioclim_eval <- evaluate(p=test_locs, a=test_pseudo, model= bioclim_model, x = bioclim_hist_local)
print(bioclim_eval)

par(mfrow=c(1,2))
# Plot the ROC curve
plot(bioclim_eval, 'ROC', type='l')
# Find the maximum kappa and show how kappa changes with the model threshold
max_kappa <- threshold(bioclim_eval, stat='kappa')
plot(bioclim_eval, 'kappa', type='l')
abline(v=max_kappa, lty=2, col='blue')

# Apply the threshold to the model predictions
tapir_range <- bioclim_pred >= max_kappa
plot(tapir_range, legend=FALSE, col=c('grey','red'))
plot(st_geometry(tapir_GBIF), add=TRUE, pch=4, col='#00000022')

# Predict from the same model but using the future data
bioclim_pred_2050 <- predict(bioclim_2050_local, bioclim_model)
# Apply the same threshold
tapir_range_2050 <- bioclim_pred_2050 >= max_kappa

par(mfrow=c(1,3))
plot(tapir_range, legend=FALSE, col=c('grey','red'))
plot(tapir_range_2050, legend=FALSE, col=c('grey','red'))

# This is a bit of a hack - adding 2 * hist + 2050 gives:
# 0 + 0 - present in neither model
# 0 + 1 - only in future
# 2 + 0 - only in hist
# 2 + 1 - in both
tapir_change <- 2 * (tapir_range) + tapir_range_2050
cols <- c('lightgrey', 'blue', 'red', 'grey30')
plot(tapir_change, col=cols, legend=FALSE)
legend('topleft', fill=cols, legend=c('Absent','Future','Historical', 'Both'), bg='white')

# Create a single sf object holding presence and pseudo-absence data.
# - reduce the GBIF data and pseudo-absence to just kfold and a presence-absence value
present <- subset(tapir_GBIF, select='kfold')
present$pa <- 1
absent <- pseudo_nearby
absent$pa <- 0
# - rename the geometry column of absent to match so we can stack them together.
names(absent) <- c('geometry','kfold','pa')
st_geometry(absent) <- 'geometry'
# - stack the two dataframes
pa_data <- rbind(present, absent)
head(pa_data)

envt_data <- extract(bioclim_hist_local, pa_data)
pa_data <- cbind(pa_data, envt_data)
head(pa_data)

glm_model <- glm(pa ~ bio2 + bio4 + bio3 + bio1 + bio12, data=pa_data, 
                 family=binomial(link = "logit"),
                 subset=kfold != 1)

# Look at the variable significances - which are important
summary(glm_model)
# Response plots
response(glm_model, fun=function(x, y, ...) predict(x, y, type='response', ...))

glm_pred <- predict(bioclim_hist_local, glm_model, type='response')

# Extract the test presence and absence
test_present <- st_coordinates(subset(pa_data, pa == 1 & kfold == 1))
test_absent <- st_coordinates(subset(pa_data, pa == 0 & kfold == 1))
glm_eval <- evaluate(p=test_present, a=test_absent, model=glm_model, 
                     x=bioclim_hist_local)
print(glm_eval)
max_kappa <- plogis(threshold(glm_eval, stat='kappa'))
print(max_kappa)

par(mfrow=c(1,2))
# ROC curve and kappa by model threshold
plot(glm_eval, 'ROC', type='l')
plot(glm_eval, 'kappa', type='l')
abline(v=max_kappa, lty=2, col='blue')

par(mfrow=c(2,2))
# Modelled probability
plot(glm_pred, col=hcl.colors(20, 'Blue-Red'))
# Threshold map
glm_map <- glm_pred >= max_kappa
plot(glm_map, legend=FALSE, col=c('grey','red'))
# Future predictions
glm_pred_2050 <- predict(bioclim_2050_local, glm_model, type='response')
plot(glm_pred_2050, col=hcl.colors(20, 'Blue-Red'))
# Threshold map
glm_map_2050 <- glm_pred_2050 >= max_kappa
plot(glm_map_2050, legend=FALSE, col=c('grey','red'))

table(values(glm_map), values(glm_map_2050), dnn=c('hist', '2050'))

# Check the species without downloading - this shows the number of records
gbif('Tapirus', 'pinchaque', download=FALSE)

# Download the data
locs <- gbif('Tapirus', 'pinchaque')
locs <- subset(locs, ! is.na(lat) | ! is.na(lon))
# Convert to an sf object 
locs <- st_as_sf(locs, coords=c('lon', 'lat'))

# 1. Create the new dataset
present <- subset(tapir_GBIF, select='kfold')
present$pa <- 1
absent <- pseudo_dismo
absent$pa <- 0
# - rename the geometry column of absent to match so we can stack them together.
names(absent) <- c('geometry','kfold','pa')
st_geometry(absent) <- 'geometry'
# - stack the two dataframes
pa_data_bg2 <- rbind(present, absent)
# - Add the envt.
envt_data <- extract(bioclim_hist_local, pa_data_bg2)
pa_data_bg2 <- cbind(pa_data_bg2, envt_data)

# 2. Fit the model
glm_model_bg2 <-glm(pa ~ bio2 + bio4 + bio3 + bio1 + bio12, data=pa_data_bg2, 
                  family=binomial(link = "logit"),
                  subset=kfold != 1)

# 3. New predictions
glm_pred_bg2 <- predict(bioclim_hist_local, glm_model_bg2, type='response')

# 4. Plot modelled probability using the same colour scheme and using
# axis args to keep a nice simple axis on the legend
par(mfrow=c(1,3))
bks <- seq(0, 1, by=0.01)
cols <- hcl.colors(100, 'Blue-Red')
plot(glm_pred, col=cols, breaks=bks, main='Buffered Background',
     axis.args=list(at=c(0, 0.5, 1)))
plot(glm_pred_bg2, col=cols, breaks=bks, main='Extent Background',
     axis.args=list(at=c(0, 0.5, 1)))
plot(glm_pred - glm_pred_bg2, col= hcl.colors(100), main='Difference')