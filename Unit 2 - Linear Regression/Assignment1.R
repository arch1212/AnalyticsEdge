#To study the relationship between average global temperature
#and several other factors

##Information about the Data

#The file climate_change.csv contains climate data from May 1983 to December 2008. 
#The available variables include:

#Year: the observation year.
#Month: the observation month.
#Temp: the difference in degrees Celsius between the average global temperature in that period and a reference value.
#CO2, N2O, CH4, CFC.11, CFC.12: atmospheric concentrations of carbon dioxide (CO2), 
#nitrous oxide (N2O), methane  (CH4), trichlorofluoromethane (CCl3F; commonly referred to as CFC-11) 
#and dichlorodifluoromethane (CCl2F2; commonly referred to as CFC-12), respectively. This data comes from the ESRL/NOAA Global Monitoring Division.
#CO2, N2O and CH4 are expressed in ppmv (parts per million by volume  -- 
i.e., 397 ppmv of CO2 means that CO2 constitutes 397 millionths of the total volume of the atmosphere)
#CFC.11 and CFC.12 are expressed in ppbv (parts per billion by volume). 
#Aerosols: the mean stratospheric aerosol optical depth at 550 nm. This variable is linked to volcanoes, 
as volcanic eruptions result in new particles being added to the atmosphere, 
which affect how much of the sun's energy is reflected back into space. 
This data is from the Godard Institute for Space Studies at NASA.
#TSI: the total solar irradiance (TSI) in W/m2 (the rate at which the sun's energy is deposited per unit area). 
Due to sunspots and other solar phenomena, the amount of energy that is given off by the sun varies substantially with time. 
This data is from the SOLARIS-HEPPA project website.
#MEI: multivariate El Nino Southern Oscillation index (MEI), 
a measure of the strength of the El Nino/La Nina-Southern Oscillation (a weather effect in the Pacific Ocean that affects global temperatures). 
This data comes from the ESRL/NOAA Physical Sciences Division.

##We are interested in how changes in these variables affect future temperatures, 
##as well as how well these variables explain temperature changes so far.

##Reading in the data
ClimateChange = read.csv("climate_change.csv")

##Looking at the data
str(ClimateChange)

##split the data into a training set, consisting of all the observations up to and including 2006, 
##and a testing set consisting of the remaining years
CC_train = subset(ClimateChange, Year <= 2006)
CC_test = subset(ClimateChange, Year > 2006)

## build a linear regression model to predict the dependent variable Temp, 
using MEI, CO2, CH4, N2O, CFC.11, CFC.12, TSI, and Aerosols as independent variables
TempReg = lm(Temp ~ MEI + CO2 + CH4 + N2O + CFC.11 + CFC.12 + TSI + Aerosols, data = CC_train)

##Pull out summary to have a look at the multiple R-squared and significant variables
##signficant only if the p-value is below 0.05
summary(TempReg)

##Current scientific opinion is that nitrous oxide and CFC-11 are greenhouse gases: 
##gases that are able to trap heat from the sun and contribute to the heating of the Earth. 
##However, the regression coefficients of both the N2O and CFC-11 variables are negative, 
##indicating that increasing atmospheric concentrations of either of these two compounds is 
##associated with lower global temperatures

##Possible Explanation for this contradiction: All of the gas concentration variables reflect human development - 
N2O and CFC.11 are correlated with other variables in the data set

##correlations between all the variables in the training set
cor(CC_train)

#N20 is highly correlated with CO2, CH4, CFC.12
#CFC.11 is highly correlated with CH4, CFC.12

##Given that the correlations are so high, let us focus on the N2O variable and build a 
##model with only MEI, TSI, Aerosols and N2O as independent variables
TempReg2 = lm(Temp ~ MEI + N2O + TSI + Aerosols, data = CC_train)
summary(TempReg2)

##When we remove many variables the sign of N2O flips. The model has not lost a lot of explanatory power
##(the model R2 is 0.7261 compared to 0.7509 previously) despite removing many variables. 
##this type of behavior is typical when building a model where many of the independent variables are highly 
##correlated with each other. Here, many of the variables (CO2, CH4, N2O, CFC.11 and CFC.12) 
##are highly correlated, since they are all driven by human industrial development.