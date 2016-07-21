# Unit 7 - Recitation


# VIDEO 3 - Bar Charts
#barplot of mit international student data

# Load ggplot library
library(ggplot2)

# Load our data, which lives in intl.csv
intl = read.csv("intl.csv")
str(intl)

# We want to make a bar plot with region on the X axis
# and Percentage on the y-axis.
ggplot(intl, aes(x=Region, y=PercentOfIntl)) +
  geom_bar(stat="identity")#use the value of the y variable as is So, the height of the bar is the value of the y variable.
+ geom_text(aes(label=PercentOfIntl))
  
  #stat = "identity" :Geometry bar has multiple modes of operation,

  #(1)The values are between zero and one, which looks kind of strange. 
  #(2)The labels are actually lying over the top of the columns, which isn't very nice, 
  #(3)and the regions aren't really ordered in any way that's useful. They're actually ordered 
    #in alphabetical order, but I think it would be much more interesting to have them in descending order.

  #ggplot defaults to alphabetical order for the x-axis. What we need to do is make Region an ordered factor
  #instead of an unordered factor.

#(1)  
# Make Region an ordered factor
# We can do this with the re-order command and transform command. 
intl = transform(intl, Region = reorder(Region, -PercentOfIntl)) #decreasing order

# Look at the structure
str(intl)

#(3)
# Make the percentages out of 100 instead of fractions
intl$PercentOfIntl = intl$PercentOfIntl * 100


#(2) text overlying the bar tops and the x-axis being all bunched up
#like that, fixing that in a new ggplot command.

#Tip: shift  + enter to move to next lines

# Make the plot
ggplot(intl, aes(x=Region, y=PercentOfIntl)) +
geom_bar(stat="identity", fill="dark blue") +
geom_text(aes(label=PercentOfIntl), vjust=-0.4) + #moves the label up with a negative value
ylab("Percent of International Students") +
theme(axis.title.x = element_blank(), axis.text.x = element_text(angle = 45, hjust = 1))
#rotate the text and remove the word regions

#SLIDE 9

# VIDEO 5 - World map

# Load the ggmap package
library(ggmap)

# Load in the international student data with number of international students from each country
intlall = read.csv("intlall.csv",stringsAsFactors=FALSE)

# Lets look at the first few rows
head(intlall)

# Those NAs are really 0s, and we can replace them easily
intlall[is.na(intlall)] = 0

# Now lets look again
head(intlall) 

#the NA's are basically 0
intlall[is.na(intlall)] = 0
head(intlall)

# Load the world map
world_map = map_data("world")
str(world_map)
#group for each country, using a different number for each country
#subregion is sometimes used for some countries to describe
#islands and other things like that.

# Lets merge intlall into world_map using the merge command
world_map = merge(world_map, intlall, by.x ="region", by.y = "Citizenship")
str(world_map)

#to plot a map, we use the geom_polygon geometry

# Plot the map
ggplot(world_map, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white", color="black") +
  coord_map("mercator")

  #Well, sometimes the merge can reorder the data.

#world_map data frame really is is actually a list of latitude and longitude points
#that define the border of each country. 

#So if we accidentally reorder the data frame they no longer make any sense. And as it goes from point to point,
#the points might be on the other side of the country as it defines the polygon.

#So, we have to reorder the data in the correct order.

# Reorder the data
world_map = world_map[order(world_map$group, world_map$order),]

# Redo the plot
ggplot(world_map, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white", color="black") +
  coord_map("mercator")

#The reason China is missing is that it has a different name in the MIT data frame
#than in the world_map data frame. So when we merged them, it was dropped
#from the data set because it didn't match up.

# Lets look for China
table(intlall$Citizenship) 
#it's called China (People's Republic Of) in mit dataframe

# Lets "fix" that in the intlall dataset
intlall$Citizenship[intlall$Citizenship=="China (People's Republic Of)"] = "China"

# We'll repeat our merge and order from before
world_map = merge(map_data("world"), intlall, 
                  by.x ="region",
                  by.y = "Citizenship")
world_map = world_map[order(world_map$group, world_map$order),]

ggplot(world_map, aes(x=long, y=lat, group=group)) +
  geom_polygon(aes(fill=Total), color="black") +
  coord_map("mercator")

#orthographic projection that allows you to sort of view the map in 3D, like a globe.
# We can try other projections - this one is visually interesting
ggplot(world_map, aes(x=long, y=lat, group=group)) +
  geom_polygon(aes(fill=Total), color="black") +
  coord_map("ortho", orientation=c(20, 30, 0))

ggplot(world_map, aes(x=long, y=lat, group=group)) +
  geom_polygon(aes(fill=Total), color="black") +
  coord_map("ortho", orientation=c(-37, 175, 0))

##SLIDE 11


# VIDEO 7 - Line Charts

# First, lets make sure we have ggplot2 loaded
library(ggplot2)

# Now lets load our dataframe
households = read.csv("households.csv")
str(households)

# Load reshape2
library(reshape2)

# Lets look at the first two columns of our households dataframe
households[,1:2]

# First few rows of our melted households dataframe
head(melt(households, id="Year"))
#that each value of MarriedWChild has turned into its own row in the new data frame.

households[,1:3]

melt(households, id="Year")[1:10,]

# Plot it
ggplot(melt(households, id="Year"),       
       aes(x=Year, y=value, color=variable)) + #  color of the line will depend on the group, which is called variable
  geom_line(size=2) + geom_point(size=5) +  
  ylab("Percentage of Households")
