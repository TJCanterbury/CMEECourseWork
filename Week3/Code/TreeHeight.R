# This function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using  the trigonometric formula 
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

# Calculates tree height for a given tree
TreeHeight <- function(degrees, distance){
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    return (height)
}


# Add column for tree heights, going row by row, outputs to TreeHts.csv
TreeHeights <- function(x="../Data/trees.csv"){
    x = read.csv(x, sep = ",")
    Tree.Height.m <- c()
    for( i in 1:nrow(x)){
        Tree.Height.m <-  c(Tree.Height.m, TreeHeight(x[i,3], x[i,2]))
    }
    x = cbind(x, Tree.Height.m)
    write.csv(x, "../Results/TreeHts.csv", row.names=FALSE)
    return(x)
}
TreeHeights()
