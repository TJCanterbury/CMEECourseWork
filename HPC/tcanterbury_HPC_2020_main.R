#Question1
species_richness <- function(community) {
    richness <- length(unique(community))
    return(richness)
}

#Question2
init_community_max <- function(size) {
    Start <- seq.int(1, size)
    return(Start)
}

#Question3
init_community_min <- function(size) {
    Alt_S <- rep.int(1, size)
    return(Alt_S)
}

#Question4
choose_two <- function(max_value) {
    x <- init_community_max(max_value)
    Ran <- sample(x, 2, replace = FALSE)
    return(Ran)
}

#Question5
neutral_step <- function(community) {
    TheChosen <- choose_two(length(community))
    community[TheChosen[1]] <- community[TheChosen[2]]
    return(community)
}

#Question6
neutral_generation <- function(community) {
    x <- length(community)
    if (x %% 2 != 0) {
        x <- x + sample(c(-1, 1), 1)
    }
    GenTime <- x / 2
    for (i in 1:GenTime) {
        community <- neutral_step(community)
    }
    return(community)
}

#Question7
neutral_time_series <- function(community, duration) {
    timeSeries <- seq.int(1, duration + 1)
    timeSeries[1] <- species_richness(community)
    for (i in 1:duration) {
        community <- neutral_generation(community)
        timeSeries[i + 1] <- species_richness(community)
    }
    return(timeSeries)
}

#Question8
question_8 <- function() {
    print("Each time an individual of the population is replaced there is a chance that that individual is the last of it's species",
    ", and so there is a chance of species richness (the lime line) going down. As there is no speciation, species richness can only",
    " stay the same or go down unitl inevitably the system converges on the absorbing state of 1 species, as indicated but the grey ",
    "dashed line.")

    Species_Richness <- neutral_time_series(community = init_community_max(100), duration = 200)

    plot(Species_Richness, xlab = "Generation", ylab = "Species Richness", type = "l", col = "#3d5d00")
    abline(h = 1, col = "#808080", lty = 2)
}

#Question9
neutral_step_speciation <- function(community, speciation_rate) {
    if (runif(1, 0, 1) <= speciation_rate) {
        TheChosen <- choose_two(length(community))
        community[TheChosen[1]] <- max(community) + 1
    }
    else{
        community <- neutral_step(community)
    }
    return(community)
}

#Question10
neutral_generation_speciation <- function(community, speciation_rate) {
    x <- length(community)
    if (x %% 2 != 0) {
        x <- x + sample(c(-1, 1), 1)
    }
    GenTime <- x / 2
    for (i in 1:GenTime) {
        community <- neutral_step_speciation(community, speciation_rate)
    }
    return(community)
}

#Question11
neutral_time_series_speciation <- function(community, duration, speciation_rate) {
    timeSeries <- seq.int(1, duration + 1)
    timeSeries[1] <- species_richness(community)
    for (i in 1:duration) {
        community <- neutral_generation_speciation(community, speciation_rate)
        timeSeries[i + 1] <- species_richness(community)
    }
    return(timeSeries)
}

#Question12
question_12 <- function(community=100, duration=200, speciation_rate=0.1) {
    print("Despite having different initial conditions both communities converge on the same equilibrium species richness because they have the same speciation rate and community size.",
    " At lower species richnesses the probability of a species going extinct decreases because there are more individuals per species.",
    " When the proportion of individuals that are the only ones of their species (extinction rate) equals the speciation rate, species richness reaches equilibrium.")

    MaxR <- neutral_time_series_speciation(init_community_max(community), duration, speciation_rate)
    MinR <- neutral_time_series_speciation(init_community_min(community), duration, speciation_rate)

    plot(MaxR, xlab = "Generation", ylab = "Species Richness", type = "l", col = "#426600", ylim = c(1, 100))
    lines(MinR, col = "#a332ff")
    legend(10, 95, legend = c("Maximum Starting Species Richness", "Minimum Starting Species Richness"),
       col = c("#426600", "#a332ff"), lty = 1, cex = 0.8)
}

#Question13
species_abundance <- function(community) return(as.vector(sort(table(community), decreasing = TRUE)))

#Question14
octaves <- function(abundances) {
    tabulate(floor(
        (log(abundances) / log(2)) + 1
    ))
}

#Question15
sum_vect <- function(x, y) {
    dif <- length(x) - length(y)
    if (dif > 0) {
        y <- c(y, rep(0, dif))
    }
    if (dif < 0) {
        x <- c(x, rep(0, abs(dif)))
    }
    return(x + y)
}

#Question16
question_16 <- function() {
    communitymin <- init_community_min(100)
    communitymax <- init_community_max(100)
    for (i in 1:200) {

        communitymax <- neutral_generation_speciation(communitymax, 0.1)
        communitymin <- neutral_generation_speciation(communitymin, 0.1)

    }

    octax <- octaves(species_abundance(communitymax))
    octin <- octaves(species_abundance(communitymin))
    n <- 1

    for (i in 1:2000) {

        communitymax <- neutral_generation_speciation(communitymax, 0.1)
        communitymin <- neutral_generation_speciation(communitymin, 0.1)

        if (i %% 20 == 0) {

            n <- n + 1
            octax <- sum_vect(octax, octaves(species_abundance(communitymax)))
            octin <- sum_vect(octin, octaves(species_abundance(communitymin)))

        }
    }

    meanoctax <- octax / n
    meanoctin <- octin / n
    dif <- length(meanoctin) - length(meanoctax)
    if (dif > 0) {
        meanoctax <- c(meanoctax, rep(0, dif))
    }
    if (dif < 0) {
        meanoctin <- c(meanoctin, rep(0, abs(dif)))
    }
    sim16 <- data.frame(Max_Starting_R = meanoctax, Min_Starting_R = meanoctin, row.names = seq_len(length(meanoctax)))
    color.names <- c("green", "purple")
    barplot(t(sim16), beside = TRUE, col = color.names, xlab = "Octaves", ylab = "Abundance", ylim = c(0, 12))
    legend("top", rownames(t(sim16)), cex = 0.8, fill = color.names, title = "Simulation")

    print("The starting values do not matter in this simulation because each state is only informed by the previous one, with no memory of the starting state of the system. So after the 200 gen burn-in the 2 simulations are at roughly equal starting positions near equilibrium, having converged, and will continue to converge at this equilibrium. So we should not expect the results of these 2 simulations to be significantly different.")
}

#Challenge_A
Challenge_A <- function(size = 100, duration = 200, repeats = 20, speciation_rate = 0.1) {
    z <- -2.197
    Min_Richness_data <- matrix(data = NA, nrow = duration + 1, ncol = repeats)
    Max_Richness_data <- matrix(data = NA, nrow = duration + 1, ncol = repeats)
    for ( i in 1:repeats) {
        Min_Richness_data[,i] <- neutral_time_series_speciation(init_community_min(size), duration, speciation_rate)
        Max_Richness_data[,i] <- neutral_time_series_speciation(init_community_max(size), duration, speciation_rate)
    }
    Generations <- 1:(duration+1)
    Min_means <- rowMeans(Min_Richness_data)
    Min_lower <- Min_means - apply(Min_Richness_data, 1, sd) * z
    Min_upper <- Min_means + apply(Min_Richness_data, 1, sd) * z

    Max_means <- rowMeans(Max_Richness_data)
    Max_lower <- Max_means - apply(Max_Richness_data, 1, sd) * z
    Max_upper <- Max_means + apply(Max_Richness_data, 1, sd) * z

    #plot graph
    Plot_title <- paste("Community size = ", size, ", Duration = ", duration, ", Repeats = ", repeats, ", Speciation rate = ", speciation_rate, sep = "")
    par(mar=c(5, 5, 5, 5))

    #Min starting richness Sim:
    plot(Generations, Min_means, main = Plot_title, type = "l", ylim = c(0,100), ylab = "Species Richness")
    polygon(c(Generations, rev(Generations)),c(Min_lower, rev(Min_upper)),col = rgb(1, 0, 0,0.5), border = FALSE)
    lines(Generations, Min_means, lwd = 2)
    lines(Generations, Min_upper, col="red",lty=2)
    lines(Generations, Min_lower, col="red",lty=2)

    #Max starting richness Sim:
    lines(Generations, Max_means, type = "l")
    polygon(c(Generations, rev(Generations)),c(Max_lower, rev(Max_upper)),col = rgb(0, 1, 0,0.5), border = FALSE)
    lines(Generations, Max_means, lwd = 2)
    lines(Generations, Max_upper, col=rgb(0, 1, 0,0.5),lty=2)
    lines(Generations, Max_lower, col=rgb(0, 1, 0,0.5),lty=2)
    
    #annotate
    abline(v=50, col = "grey", lty = 3, lwd = 2)
    equilibrium <- format(round(mean(c(Min_means[51:201], Min_means[51:201])),2), nsmall = 3)
    abline(h=equilibrium, col = "grey", lty = 3, lwd = 2)
    text(x=55, y=45, labels="50 generations \ntill dynamic equilibrium", col = "#464646")
    text(x = 125, y = (as.integer(equilibrium) - 15), labels = paste("Dynamic equilibrium\n Species Richness = ", equilibrium, sep = ""), col = "#464646")
    legend("top", c("1", "100"), bty = "n", cex = 0.8, fill = c(rgb(1, 0, 0,0.5), rgb(0, 1, 0,0.5)), title = "Starting species richness")
}

#Challenge_B
init_community <- function(Number_of_species, size) {
    community <- init_community_min(size)
    index <- sample(1:size, Number_of_species)

    for (i in index){
        community[i] <- i + 1
    }
    return(community)
}

colours <- function(j, alpha = 0.5) {
    red <- alpha * j
    green <- 1 - red
    blue <- (red*green)*4
    colour <- rgb(red, green, blue, 1)
    return(colour)
}

Challenge_B <- function(size = 100, duration = 200, repeats = 20, speciation_rate = 0.1, Number_of_Communities = 10) {
    #starting parameters
    Richness_data <- matrix(data = NA, nrow = duration + 1, ncol = repeats)
    mean_results <- matrix(data = NA, nrow = duration + 1, ncol = Number_of_Communities)
    Number_of_species <- rep(0, Number_of_Communities)
    alpha <- 1 / Number_of_Communities
    legend_cols <- rep(0, Number_of_Communities)
    legend_cols[1] <- colours(1, alpha)
    Generations <- 1:(duration + 1)
    seeds <- 1

    #run simulations
    for (j in 1:Number_of_Communities) {
        Number_of_species[j] <- floor(((j / Number_of_Communities) * size) - ((1/Number_of_Communities)*size)/2)
        for (i in 1:repeats) {
            set.seed(seeds)
            seeds <- seeds + 1
            Richness_data[, i] <- neutral_time_series_speciation(init_community(Number_of_species[j], size), duration, speciation_rate)
        }
        mean_results[, j] <- rowMeans(Richness_data)
    }
    #plot graph
    Plot_title <- paste("Community size = ", size, ", Duration = ", duration, ", Repeats = ", repeats, ", Speciation rate = ", speciation_rate, ", Number of Communities = ", Number_of_Communities, sep = "")
    par(mar = c(5, 5, 5, 5))

    #plot all the lines
    plot(Generations, mean_results[,1], col = colours(1, alpha), lwd = 2, main = Plot_title, type = "l", ylim = c(0,100), ylab = "Species Richness")

    for (j in 2:Number_of_Communities) {
        lines(Generations, mean_results[,j], col = colours(j, alpha), lwd = 2)
        legend_cols[j] <- colours(j, alpha)
    }

    #annotate
    equilibrium <- format(round(mean(mean_results[50:(duration + 1), ]), 2), nsmall = 3)
    abline(h = equilibrium, col = "grey", lty = 3, lwd = 2)
    text(x = 125, y = (as.integer(equilibrium) - 15), labels = paste("Dynamic equilibrium\n Species Richness = ", equilibrium, sep = ""), col = "#464646")
    legend("top", legend = Number_of_species, bty = "n", cex = 0.8, fill = legend_cols, title = "Starting Species Richness")

}

#Question17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name) {
    #Record start time
    start_time <- proc.time()

    #Starting values and preallocations:
    community <- init_community_min(size)
    time <- proc.time()[3] + (wall_time * 60)
    generation <- 0
    richness <- rep(0, burn_in_generations / interval_rich)
    burn_in_index <- 0
    abundance_data <- c()
    n = 0
    oct <- rep(0, 10)

    #Run simulation:
    repeat {
        if (proc.time()[3] >= time) {break}
        community <- neutral_generation_speciation(community, speciation_rate)
        generation <- generation + 1

        #Record species richness
        if (generation <= burn_in_generations && generation %% interval_rich == 0) {
            burn_in_index <- burn_in_index + 1
            richness[burn_in_index] <- species_richness(community)
        }

        #Record abundances of octaves
        if (generation %% interval_oct == 0) {
            n <- n + 1
            oct <- sum_vect(oct, octaves(species_abundance(community)))
        }
    }
    abundance_data <- oct / n
    #Make results list:
    richness_data <- data.frame(Generation = seq.int(1, burn_in_generations, interval_rich), 'Species Richness' = richness)
    time_elapsed <- proc.time() - start_time
    parameters <- c(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations)
    results <- list(richness_data, abundance_data, community, time_elapsed, parameters)

    #write results to file
    save(results, file = output_file_name)
}

#Question20
process_cluster_results <- function(num = 100) {
    Octaves_500 <- rep(0, 10)
    Octaves_1000 <- rep(0, 10)
    Octaves_2500 <- rep(0, 10)
    Octaves_5000 <- rep(0, 10)
    n500 <- 0
    n1000 <- 0
    n2500 <- 0
    n5000 <- 0
    for (i in 1:num){
        load(paste("Result_file_", i, ".rda", sep = ""))
        if ((i - 1) %% 4 == 0) {
            n500 <- n500 + 1
            Octaves_500 <- sum_vect(Octaves_500, results[[2]])
        }
        if ((i - 2) %% 4 == 0) {
            n1000 <- n1000 + 1
            Octaves_1000 <- sum_vect(Octaves_1000, results[[2]])
        }
        if ((i - 3) %% 4 == 0) {
            n2500 <- n2500 + 1
            Octaves_2500 <- sum_vect(Octaves_2500, results[[2]])
        }
        if ((i - 4) %% 4 == 0) {
            n5000 <- n5000 + 1
            Octaves_5000 <- sum_vect(Octaves_5000, results[[2]])
        }
    }
    #results
    Octaves_500  <- Octaves_500 / n500
    Octaves_1000<- Octaves_1000 / n1000
    Octaves_2500 <- Octaves_2500 / n2500
    Octaves_5000 <- Octaves_5000 / n5000
    results <- list(Octaves_500, Octaves_1000, Octaves_2500, Octaves_5000)
    save(results, file = 'Final_results.rda')
}

plot_cluster_results <- function() {
    load('Final_results.rda')
    par(mfrow=c(2,2))
    
    for (i in 1:4){
        means <- results[[i]]
        names(means) <- 1:length(means)
        if (i == 1){ title = "Comminity size = 500" }
        if (i == 2){ title = "Comminity size = 1000" }
        if (i == 3){ title = "Comminity size = 2500" }
        if (i == 4){ title = "Comminity size = 5000" }
        #plot
        barplot(means, xlab = "Species Richness Octaves", ylab = "Abundance", ylim = c(0, max(means)*1.4), main = title)
    }
}

#ChallengeC
Challenge_C <- function() {

}

#ChallengeD
Challenge_D <- function() {
    
}

#Question21
question_21 <- function(width = 3, size =  8) {
    x = log(size)/log(width)
    a <- paste("I can recreate the same fractal by taking this object and stacking ", size, " of itself together. The new width would be ", width, " times the old one.",
    " The change in width to the power of the dimensions for an object should give the change in size so if we take the log of eitehr side of the equation",
    " we can rearrange the equation and find the dimensionality of the object for a given width and size change. Using this method tells me that the object has ",
    x, " dimensions.", sep = "")
    return(list(x, a))
}

#Question22
question_22 <- function() {
    question_21(3, 20)
}

#Question23
chaos_game <- function(X = c(0, 0), time=30) {
    t0 <- proc.time()
    s <- 1 / (time*0.25)
    z <- matrix(c(0,3,4,0,4,1), ncol = 2, nrow = 3)
    plot(X[1], X[2], cex = s, ylim = c(0, 4), xlim = c(0,4), pch = 17)
    num_of_moves = 0
    
    repeat {
        if(proc.time()[3] - t0[3] >= time) {break}
        num_of_moves = num_of_moves + 1
        j <- sample(1:3, 1)
        X <- X + (z[j,] - X)/2
        points(X[1], X[2], cex = s, ylim = c(0, 4), xlim = c(0,4), pch = 17)
    }
    
    print(paste("Number of moves made = ", num_of_moves, sep = ""))
    t1 <- proc.time()[3] - t0[3]
    print(paste("Time taken =", t1, "seconds"))
    print(paste("X moves between points A, B and C at random. There are only 3",
    "directions that it can move in and it can only move in half distances",
    "and so the inbetween distances are missed, creating the empty triangles."))
}

#ChallengeE
Challenge_E <- function(X = c(0, 0), time=29.9) {
    t0 <- proc.time()
    s <- 1 / (time*0.1)
    z <- matrix(sample(0:4, 6, replace = TRUE), ncol = 2, nrow = 3)
    plot(X[1], X[2], cex = s, ylim = c(0, 4), xlim = c(0,4), pch = 17)
    Directions <- c(paste("A (", z[1,1], ",", z[1,2], ")"), 
    paste("B (", z[2,1], ",", z[2,2], ")"), paste("C (", z[3,1], ",", z[3,2], ")"))
    colours <- c("green", "red", "blue")
    legend("top", legend = Directions, bty = "n", cex = 0.8, fill = colours, title = "X travelled towards:")
    num_of_moves = 0
    
    repeat {
        if(proc.time()[3] - t0[3] >= time) {break}
        num_of_moves = num_of_moves + 1
        j <- sample(1:3, 1)
        X <- X + (z[j,] - X)/2
        points(X[1], X[2], cex = s, ylim = c(0, 4), xlim = c(0,4), pch = 17, col = colours[j])
    }
    text(x = z[1,1], y = z[1,2], labels = "A")
    text(x = z[2,1], y = z[2,2], labels = "B")
    text(x = z[3,1], y = z[3,2], labels = "C")

    print(paste("Number of moves made = ", num_of_moves, sep = ""))
    t1 <- proc.time()[3] - t0[3]
    print(paste("Time taken =", t1, "seconds"))
    print("Once X falls between A, B or C it will move between them in the same pattern as before.")
    print("By colouring it's movements we can see more clearly how the shape is made.")
    print("(Each time you run this function you will get a different random position for A, B, C and X)")
}

#Question24
turtle <- function(start_position, direction, length) {
    vector <- c(length * cos(direction), length * sin(direction))
    end_position <- start_position + vector
    segments(x0 = start_position[1], y0 = start_position[2], x1 = end_position[1], y1 = end_position[2])
    return(end_position)
}

#Question25
elbow <- function(start_position, direction, length) {
    turtle(turtle(start_position, direction, length), direction - pi / 4, length * 0.95)
}

#Question26
spiral <- function(start_position, direction, length) {
    start_position <- spiral(turtle(start_position, direction, length), direction - pi / 4, length * 0.95)
    return("With each iteration the spiral curls in on itself because the distance shortens, preventing overlap, and the change in direction is always the same.")
}

#Question27
draw_spiral <- function(start_position = c(2,10), direction = 0, length = 1) {
    if (length > 0){
        plot(1, type="n", xlab="", ylab="", xlim=c(0, max(start_position)), ylim=c(0, max(start_position)))
        pr <- spiral(start_position, direction, length)
        return(pr)
    }
    else {
        return("No good, I demand a positive number for length argument")
    }
}

#Question28
tree <- function(start_position, direction, length, duration = 1) {
    t0 <- proc.time()
    repeat {
        start_position  <- turtle(start_position, direction, length)
        direction <- direction + pi / 4
        length <- length * 0.65
        start_position  <- turtle(start_position, direction, length)
        direction <- direction - pi / 4
        length <- length * 0.65
        if ((proc.time()[3] - t0[3]) >= duration){break}
    }
}

draw_tree <- function(start_position = c(2,10), direction, length) {
    if (length > 0){
        plot(1, type="n", xlab="", ylab="", xlim=c(0, max(start_position)*2), ylim=c(0, length*4))
        pr <- tree(start_position, direction, length)
        return(pr)
    }
    else {
        return("No good, I demand a positive number for length argument")
    }
}

