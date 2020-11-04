library(rgdal)
library(raster)
library(sf)
library(sp)
library(units)

#Ocean vector data
so_data <- read.csv('../data/Southern_Ocean.csv', header=TRUE)

# Convert the data frame to an sf object
so_data <- st_as_sf(so_data, coords=c('long', 'lat'), crs=4326)
#raster data for ocean
etopo_25 <- raster('../data/etopo_25.tif')

so_extent <- extent(-60, -20, -65, -45)
# The crop function for raster data...
so_topo <- crop(etopo_25, so_extent)
# ... and the st_crop function to reduce some higher resolution coastline data
ne_10 <- st_read('../data/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp')
st_agr(ne_10) <- 'constant'
so_ne_10 <- st_crop(ne_10, so_extent)

par(mfrow=c(2,1))
sea_pal <- colorRampPalette(c('grey30', 'grey50', 'grey70'))
plot(so_topo, col=sea_pal(100), asp=1, legend=FALSE)
contour(so_topo, levels=c(-2000, -4000, -6000), add=TRUE, col='grey80')
plot(st_geometry(so_ne_10), add=TRUE, col='grey90', border='grey40')
plot(so_data['chlorophyll'], add=TRUE, logz=TRUE, pch=20, cex=2, pal=hcl.colors, border='white', reset=FALSE)
.image_scale(log10(so_data$chlorophyll), col=hcl.colors(18), key.length=0.8, key.pos=4, logz=TRUE)