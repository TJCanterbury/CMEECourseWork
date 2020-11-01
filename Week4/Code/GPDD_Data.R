require(maps)
require(ggplot2)
load("../../../TheMulQuaBio/content/data/GPDDFiltered.RData") 

map() + points(gpdd$long,gpdd$lat,col=2,pch=18)
map.axes()
map.scale()

# This data mostly comes from temperate regions, 
# particularly Europe and North America and even 
# more especially the data comes from points at 
# a latitude of about 50 on the west coast of North
# America and the UK. So not representative of 
# global biodiversity.