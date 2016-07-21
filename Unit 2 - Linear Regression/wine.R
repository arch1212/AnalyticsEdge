#Read in the data
wine = read.csv("wine.csv")

#look at the structure of the data
str(wine)

#look at the statistical summary of the data
summary(wine)

#Create a one variable linear regression model using AGST to predict Price
model1 = lm(Price ~ AGST, data = wine)

#Take a look at the summary of the model1
summary(model1)

#Observe the value of Multiple R-squared and Adjusted R-squared

##multiple R-squared will alwayys increase if you add more independent variables 
##Adjusted R-squared will descrease if you add an independent variable that
##doesn't help the model

#compute the SSE for model1
SSE = sum(model1$residuals^2)
SSE

#add another variable to our regression model, HarvestRain
model2 = lm(Price ~ AGST + HarvestRain, data = wine)

#Pull out its summary and observe the value of R-squared and adjusted R-squared
summary(model2)

#Compute the SSE for model2
SSE = sum(model2$residuals^2)
SSE

#Build a model with all of the independent variables in the dataset
model3 = lm(Price ~ AGST + HarvestRain + WinterRain + Age + FrancePop, data = wine)

#Pull out its summary
summary(model3)

#Calculate SSE
SSE = sum(model3$residuals^2)
SSE

#Start with FrancePop
model4 = lm(Price ~ AGST + HarvestRain + WinterRain + Age, data = wine)

#pull out the summary for model4 and observe the significance level of the independent variables
summary(model4)

#we observe such a change because of multicollinearity

#Check for correlation between all independent variables
cor(wine)
plot(wine)

#we remove variables one at a time and observe the change in R squared
#stick with model4

#checking the predictive ability

#Load in the test set 
wineTest = read.csv("wine_test.csv")

#checkout its structure
str(wineTest)

#make prediction
predictTest = predict(model4, newdata = wineTest)
predictTest

#Calculate the R squared value
SSE = sum((wineTest$Price - predictTest)^2)
SST = sum((wineTest$Price - mean(wine$Price))^2)
R_squared = 1 - (SSE/SST)
R_squared









