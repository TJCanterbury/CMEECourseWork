# Generate two stacked plots with narrow margins 
    par(mfrow=c(2,1)) 
     
    # The first plot is easy 
    plot(ne_110['GDP_MD_EST'],  asp=1, main='Global GDP', logz=TRUE, key.pos=4) 
     
    # Then for the second we need to merge the data 
    ne_110 <- merge(ne_110, life_exp, by.x='ISO_A3_EH', by.y='COUNTRY', all.x=TRUE) 
    # Create a sequence of break values to use for display 
    bks <- seq(50, 85, by=0.25) 
    # Plot the data 
    plot(ne_110['Numeric'], asp=1, main='Global 2016 Life Expectancy (Both sexes)', 
          breaks=bks, pal=hcl.colors) 