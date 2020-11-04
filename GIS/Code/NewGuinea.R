library(rgdal)
library(raster)
library(sf)
library(sp)
library(units)

#coords of transect
transect_long <- c(132.3, 135.2, 146.4, 149.3)
transect_lat <- c(-1, -3.9, -7.7, -9.8)

# load data
ne_10 <- st_read('../data/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp')
# Get the precipitation data
ng_prec <- getData("worldclim", var = "prec", res = 0.5, lon = 140, lat = -10, path = "../data")
# Reduce to the extent of New Guinea - crop early to avoid unnecessary processing!
ng_extent <- extent(130, 150, -10, 0)
ng_prec <- crop(ng_prec, ng_extent)
# Calculate annual precipitation
ng_annual_prec <- sum(ng_prec)

# Now reproject to UTM 54S. The code here is using reprojecting the extent of the
# raster data to get sensible values for the UTM 54S extent. We are picking extent
# values here that create a neat 1000m grid with sensible cell edges
ng_extent_poly <- st_as_sfc(st_bbox(ng_extent, crs = 4326))
st_transform(ng_extent_poly, crs = 32754)
ng_extent_utm <- extent(-732000, 1506000, 8874000, 10000000)

# Create the raster and reproject the data
ng_template_utm <- raster(ng_extent_utm, res = 1000, crs = "+init=EPSG:32754")
ng_annual_prec_utm <- projectRaster(ng_annual_prec, ng_template_utm)

# Create and reproject the transect and then segmentize it to 1000m
transect <- st_linestring(cbind(x = transect_long, y = transect_lat))
transect <- st_sfc(transect, crs = 4326)
transect_utm <- st_transform(transect, crs = 32754)
transect_utm <- st_segmentize(transect_utm, dfMaxLength = 1000)

transect_data <- extract(ng_annual_prec_utm, as(transect_utm, "Spatial"),
     along = TRUE, cellnumbers = TRUE
)

# Get the first item from the transect data
transect_data <- transect_data[[1]]
transect_data <- data.frame(transect_data)

# Get the cell coordinates
transect_data_xy <- xyFromCell(ng_annual_prec_utm, transect_data$cell)
transect_data <- cbind(transect_data, transect_data_xy)

# Now we can use Pythagoras to find the distance along the transect
transect_data$dx <- c(0, diff(transect_data$x))
transect_data$dy <- c(0, diff(transect_data$y))
transect_data$distance_from_last <- with(transect_data, sqrt(dx^2 + dy^2))
transect_data$distance <- cumsum(transect_data$distance_from_last)

# Get the natural earth high resolution coastline.
ne_10_ng <- st_crop(ne_10, ng_extent_poly)
ne_10_ng_utm <- st_transform(ne_10_ng, crs = 32754)

par(mfrow = c(2, 1), mar = c(3, 3, 1, 1), mgp = c(2, 1, 0))
plot(ng_annual_prec_utm)
plot(ne_10_ng_utm, add = TRUE, col = NA, border = "grey50")
plot(transect_utm, add = TRUE)

par(mar = c(3, 3, 1, 1))
plot(layer ~ distance,
     data = transect_data, type = "l",
     ylab = "Annual precipitation (mm)", xlab = "Distance (m)"
)