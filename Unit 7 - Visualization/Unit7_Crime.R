# Unit 7 - Lecture 2, Predictive Policing


# VIDEO 3 - A Basic Line Plot to visualize crime trends.

# Load our data:
mvt = read.csv("mvt.csv", stringsAsFactors=FALSE) #since we have a text field

str(mvt)

# Variables: the date of the crime, and the location of the crime, in terms of latitude and longitude.

# Convert the Date variable to a format that R will recognize:
mvt$Date = strptime(mvt$Date, format="%m/%d/%y %H:%M") #format that the date is in

    #In this format, we can extract the hour and the day
    #of the week from the Date variable,
    #and we can add these as new variables to our data frame.

# Extract the hour and the day of the week:
mvt$Weekday = weekdays(mvt$Date)
mvt$Hour = mvt$Date$hour
    #This only exists because we converted the Date variable

# Let's take a look at the structure of our data again:
str(mvt)

# Create a simple line plot - need the total number of crimes on each day of the week. 
#We can get this information by creating a table:
table(mvt$Weekday)

# Save this table as a data frame:
WeekdayCounts = as.data.frame(table(mvt$Weekday))

str(WeekdayCounts) 


# Load the ggplot2 library:
library(ggplot2)

# Create our plot
ggplot(WeekdayCounts, aes(x=Var1, y=Freq)) + geom_line(aes(group=1))  #This just groups all of our data into one line,
#since we want one line in our plot.

  #What ggplot did was it put the days of the week in alphabetical order.
  #But we actually want the days of the week in chronological order
  #to make this plot a bit easier to read.

#We can do this by making the Var1 variable an ordered factor variable.
#This signals to ggplot that the ordering is meaningful.

# Make the "Var1" variable an ORDERED factor variable
WeekdayCounts$Var1 = factor(WeekdayCounts$Var1, ordered=TRUE, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday","Saturday"))

#a vector of the days of the week in the order we want them to be in.

# Try again:
ggplot(WeekdayCounts, aes(x=Var1, y=Freq)) + geom_line(aes(group=1))

# Change our x and y labels:
ggplot(WeekdayCounts, aes(x=Var1, y=Freq)) + geom_line(aes(group=1)) + xlab("Day of the Week") + ylab("Total Motor Vehicle Thefts")



# VIDEO 4 - Adding the Hour of the Day to create a heatmap

#We can do this by creating a line for each day of the week
#and making the x-axis the hour of the day.


# Create a counts table for the weekday and hour:
table(mvt$Weekday, mvt$Hour)

# Save this to a data frame:
DayHourCounts = as.data.frame(table(mvt$Weekday, mvt$Hour))

str(DayHourCounts)

# Convert the second variable, Var2, to numbers and call it Hour:
DayHourCounts$Hour = as.numeric(as.character(DayHourCounts$Var2))
    #This is how we convert a factor variable to a numeric variable.
  

# Create out plot:
ggplot(DayHourCounts, aes(x=Hour, y=Freq)) + geom_line(aes(group=Var1)) #group to Var1

# Change the colors
ggplot(DayHourCounts, aes(x=Hour, y=Freq)) + geom_line(aes(group=Var1, color=Var1), size=2)

# Separate the weekends from the weekdays:
DayHourCounts$Type = ifelse((DayHourCounts$Var1 == "Sunday") | (DayHourCounts$Var1 == "Saturday"), "Weekend", "Weekday")

# Redo our plot, this time coloring by Type:
ggplot(DayHourCounts, aes(x=Hour, y=Freq)) + geom_line(aes(group=Var1, color=Type), size=2) 
  

# Make the lines a little transparent:
ggplot(DayHourCounts, aes(x=Hour, y=Freq)) + geom_line(aes(group=Var1, color=Type), size=2, alpha=0.5) 

    ##While we can get some information from this plot, it's still quite hard to interpret.
    ##Seven lines is a lot. Let's instead visualize the same information with a heat map.

    ##To make a heat map, we'll use our data in our data frame DayHourCounts.

    ##First, though, we need to fix the order of the days so that they'll show up in 
    ##chronological order instead of in alphabetical order.

# Fix the order of the days:
DayHourCounts$Var1 = factor(DayHourCounts$Var1, ordered=TRUE, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# Make a heatmap:
ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill = Freq))

# Change the label on the legend, and get rid of the y-label:

ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill = Freq)) + scale_fill_gradient(name="Total MV Thefts") + theme(axis.title.y = element_blank())
                                                                                #This defines properties of the legend,      #to get rid of one of the axis labels.

# Change the color scheme
ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill = Freq)) + scale_fill_gradient(name="Total MV Thefts", low="white", high="red") + theme(axis.title.y = element_blank())

#It's often useful to change the color scheme depending
#on whether you want high values or low values
#to pop out, and the feeling you want the plot to portray.


# VIDEO 5 - Adding data to geographical maps

# Install and load two new packages:
install.packages("maps")
install.packages("ggmap")
library(maps)
library(ggmap)

# Load a map of Chicago into R
chicago = get_map(location = "chicago", zoom = 11)

# Look at the map
ggmap(chicago)

# Plot the first 100 motor vehicle thefts:
ggmap(chicago) + geom_point(data = mvt[1:100,], aes(x = Longitude, y = Latitude))
#This is instead of using ggplot to load the map of chicago

    #If we plotted all 190,000 motor vehicle thefts, we would just see a big black box,
    #which wouldn't be helpful at all. We're more interested in whether or not
    #an area has a high amount of crime,


# Round our latitude and longitude to 2 digits of accuracy, and create a crime counts data frame for each area:
LatLonCounts = as.data.frame(table(round(mvt$Longitude,2), round(mvt$Latitude,2)))

str(LatLonCounts)

# Convert our Longitude and Latitude variable to numbers:
LatLonCounts$Long = as.numeric(as.character(LatLonCounts$Var1))
LatLonCounts$Lat = as.numeric(as.character(LatLonCounts$Var2))

  ##plot these points on our map,making the size and color of the points
  ##depend on the total number of motor vehicle thefts.

# Plot these points on our map:
ggmap(chicago) + geom_point(data = LatLonCounts, aes(x = Long, y = Lat, color = Freq, size=Freq))
#to load the map of chicago

# Change the color scheme:
ggmap(chicago) + geom_point(data = LatLonCounts, aes(x = Long, y = Lat, color = Freq, size=Freq)) + scale_colour_gradient(low="yellow", high="red")

# We can also use the geom_tile geometry to make it look like a traditional heatmap
ggmap(chicago) + geom_tile(data = LatLonCounts, aes(x = Long, y = Lat, alpha = Freq), fill="red") #defining our color scheme.
                                                                       #This will define how to scale
                                                                       #the colors on the heat map
                                                                       #according to the crime counts.

  #We've created a geographical heat map, which in our case shows a visualization of the data,
  #but it could also show the predictions of a model.


# VIDEO 6 - Geographical Map on US

# Load our data:
murders = read.csv("murders.csv") #total number of murders in the United States by state.

str(murders)
#A map of the United States is included in R. 
# Load the map of the US
statesMap = map_data("state")

str(statesMap)
#This is just a data frame summarizing how to draw the United States.

#To plot the map, we'll use the polygons geometry of ggplot.

# Plot the map:
ggplot(statesMap, aes(x = long, y = lat, group = group)) + geom_polygon(fill = "white", color = "black") #fill all states in white and color="black" 
                                         #This is the variable defining how                              #to outline the states in black.
                                         #to draw the United States into groups by state.                                            

#Before we can plot our data on this map, we need to make sure that the state names are
#the same in the murders data frame and in the statesMap data frame.

# Create a new variable called region with the lowercase names to match the statesMap:
murders$region = tolower(murders$State)

  ## we can join the statesMap data frame with the murders
  ##data frame by using the merge function, which
  ##matches rows of a data frame based on a shared identifier.

# Join the statesMap data and the murders data into one dataframe:
murderMap = merge(statesMap, murders, by="region") #matched up based on the region variable.
str(murderMap)

# Plot the number of murder on our map of the United States:
ggplot(murderMap, aes(x = long, y = lat, group = group, fill = Murders)) + geom_polygon(color = "black") + scale_fill_gradient(low = "black", high = "red", guide = "legend")
                                                        #so that the states      #add the polygon geometry                                                  #to make sure we get a legend
                                                        #will be colored         #to outline the states in black                                            #on our plot.
                                                        #according to the
                                                        #Murders variable.


    ##So it looks like California and Texas
    ##have the largest number of murders.
    ##But is that just because they're the most populous states?
    #Let's create a map of the population of each state to check.

# Plot a map of the population:
ggplot(murderMap, aes(x = long, y = lat, group = group, fill = Population)) + geom_polygon(color = "black") + scale_fill_gradient(low = "black", high = "red", guide = "legend")

#So we need to plot the murder rate instead
#of the number of murders to make sure we're not just
#plotting a population map. 

# Create a new variable that is the number of murders per 100,000 population:
murderMap$MurderRate = murderMap$Murders / murderMap$Population * 100000

# Redo our plot with murder rate:
ggplot(murderMap, aes(x = long, y = lat, group = group, fill = MurderRate)) + geom_polygon(color = "black") + scale_fill_gradient(low = "black", high = "red", guide = "legend")

  #There aren't really any red states.
  #Why?    
#It turns out that Washington, DC is an outlier with a very high murder rate,
#but it's such a small region on the map that we can't even see it.

#So let's redo our plot, removing any observations with murder rates above 10, which
#we know will only exclude Washington, DC.
#Keep in mind that when interpreting and explaining the resulting plot, you should always
#note what you did to create it: removed Washington, DC from the data.

# Redo the plot, removing any states with murder rates above 10:
ggplot(murderMap, aes(x = long, y = lat, group = group, fill = MurderRate)) + geom_polygon(color = "black") + scale_fill_gradient(low = "black", high = "red", guide = "legend", limits = c(0,10))


