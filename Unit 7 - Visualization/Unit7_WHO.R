# Unit 7 - Lecture 1


# VIDEO 4 - A BASIC SCATTERPLOT

# Read in data

WHO = read.csv("WHO.csv")

str(WHO)
#the fertility rate or average number of children per woman
#the child mortality rate, which is the number of children who die by age five per 1,000 births
#the literacy rate among adults older than 15,


# Scatterplot from Week 1: between Gross national income and fertility rate

plot(WHO$GNI, WHO$FertilityRate)

#This plot shows us that a higher fertility rate is correlated with a lower income.

# Let's redo this using ggplot 

# Install and load the ggplot2 library:
install.packages("ggplot2")
library(ggplot2)

#we need at least three things to create a plot using ggplot-- data, an aesthetic mapping
#of variables in the data frame to visual output, and a geometric object.


#(1)Create the ggplot object 
  
  #Create the ggplot object with the data and the aesthetic mapping:

scatterplot = ggplot(WHO, aes(x = GNI, y = FertilityRate))

  #the first argument is the name of our data setthe second argument is the aesthetic mapping, aes.
  #In parentheses, we have to decide what we want on the x-axis and what we want on the y-axis.
 
#(2)what geometric objects to put in the plot.
  
  #We could use bars, lines, points, or something else. This is a big difference between ggplot and regular plotting
  #in R. You can build different types of graphs by using the same ggplot object.
  #There's no need to learn one function for bar graphs, a completely different function for line graphs, etc.

# Add the geom_point geometry
scatterplot + geom_point()

# Make a line graph instead:
scatterplot + geom_line()

# Switch back to our points:
scatterplot + geom_point()

#(3) aesthetics of geometric objects
#In addition to specifying that the geometry we want is points,
#we can add other options, like the color, shape, and size of the points.

# Redo the plot with blue triangles instead of circles:
scatterplot + geom_point(color = "blue", size = 3, shape = 17) 

# Another option:
scatterplot + geom_point(color = "darkred", size = 3, shape = 8) 

# Add a title to the plot:
scatterplot + geom_point(colour = "blue", size = 3, shape = 17) + ggtitle("Fertility Rate vs. Gross National Income")

# Save our plot:

#saving our plot to a variable
fertilityGNIplot = scatterplot + geom_point(colour = "blue", size = 3, shape = 17) + ggtitle("Fertility Rate vs. Gross National Income")

#create a file we want to save our plot to
pdf("MyPlot.pdf") #name you want your file to have.

#print our plot to that file with the print function
print(fertilityGNIplot) #name of the plot

#to close the file
dev.off()

#Now, if you look at the folder where WHO.csv is, you should see another file called MyPlot.pdf,
#containing the plot we made.


# VIDEO 5 - MORE ADVANCED SCATTERPLOTS 

#how to color our points by region
#and how to add a linear regression line to our plot.

#This time, we want to add a color option to our aesthetic,
#since we're assigning a variable in our data set to the colors.

# Color the points by region: 
ggplot(WHO, aes(x = GNI, y = FertilityRate, color = Region)) + geom_point() 

#which will color the points by the Region variable.

    ##This really helps us see something that we didn't see before. 
    ##The points from the different regions are really located in different areas on the plot.

# Color the points according to life expectancy:
ggplot(WHO, aes(x = GNI, y = FertilityRate, color = LifeExpectancy)) + geom_point()

  #Notice that before, we were coloring by a factor variable, Region.
  #So we had exactly seven different colors corresponding to the seven different regions.
  #Here, we're coloring by LifeExpectancy instead, which is a numerical variable, so we get a gradient of colors,
  #like this.


# Is the fertility rate of a country was a good predictor of the percentage of the population under 15?
ggplot(WHO, aes(x = FertilityRate, y = Under15)) + geom_point()


  #It looks like the variables are certainly correlated, but as the fertility rate increases, the variable,
  #Under15 starts increasing less. So this doesn't really look like a linear relationship.
  #But we suspect that a log transformation of FertilityRate will be better.


# Let's try a log transformation:
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point()

# Simple linear regression model to predict the percentage of the population under 15, using the log of the fertility rate:
mod = lm(Under15 ~ log(FertilityRate), data = WHO)
summary(mod)


  #Visualization was a great way for us to realize that the log transformation would be better.
  #If we instead had just used the FertilityRate, the R-squared would have been 0.87. 
  #That's a pretty significant decrease in R-squared.


##add another layer

# Add this regression line to our plot:
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method = "lm")

    ##By default, ggplot will draw a 95% confidence interval shaded around the line.
    ##We can change this by specifying options within the statistics layer.

# 99% confidence interval
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method = "lm", level = 0.99)

# No confidence interval in the plot
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method = "lm", se = FALSE)

# Change the color of the regression line:
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method = "lm", colour = "orange")

    ##As we've seen in this lecture, scatterplots are great for exploring data.
    ##However, there are many other ways to represent data visually, such as box plots, line charts,
    ##histograms, heat maps, and geographic maps.

    ##In some cases, it may be better to choose one of these other ways of visualizing your data.
    ##Luckily, ggplot makes it easy to go from one type of visualization to another, simply
    ##by adding the appropriate layer to the plot.