#!/usr/bin/env Rscript
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

# Takes argument
args = commandArgs(trailingOnly=TRUE)
x= args[1]

# Measures height of a single tree
TreeHeight <- function(degrees, distance){
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    return (height)
}

#
TreeHeights <- function(x){
    y= tools::file_path_sans_ext(basename(x))
    x = read.csv(x, sep = ",")
    Tree.Height.m <- c()
    for( i in 1:nrow(x)){
        Tree.Height.m <-  c(Tree.Height.m, TreeHeight(x[i,3], x[i,2]))
    }
    x = cbind(x, Tree.Height.m)
    write.csv(x, paste("../Results/", y, "_treeHts_R.csv", sep = ""), row.names=FALSE)
    print(x)
    return(paste("You will find your results, with an added tree heights column at ", "../Results/", y, "_treeHts.csv", sep = ""))
}
TreeHeights(x)
