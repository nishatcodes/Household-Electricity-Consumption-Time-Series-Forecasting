## STAT 485 Project
## Title: Monthly Household Electricity Consumption
## Team 3

library(tidyverse)
library(dplyr)
library(forecast)
library(MLmetrics)
library(backtest)
library(fpp)
library(fpp2)
library(tseries)
library(TSA)
library(ggplot2)
library(gridExtra)
pacman::p_load(zoo, fpp3, astsa)  


elec <- read.csv("total_household_electricity_consumption_2005_2020.csv", 
                        header = TRUE, sep = ",", na.strings = " ") 

elec <- elec[order(elec$month), ] 
row.names(elec) <- NULL

# Create the time series objects
elec_ts<- ts(elec$overall, frequency=12, start=c(2005,1), end = c(2019, 12))


###############################
# Exploratory Data Analysis 
###############################

# time series plot and fitted linear trend 
plot.ts(elec_ts,
        xlab="Year", ylab="Electricity Consumption (in GWh)",
        main="Monthly Household Electricity Consumption",
        type='l')

model1=lm(elec_ts~time(elec_ts))   #Fit a linear model
abline(model1,col="red",lwd=3)    #plot the fitted linear trend


# raw data 
acf(as.vector(elec_ts),lag.max=72, 
    main="Sample ACF of Electrcity Consumption")
pacf(as.vector(elec_ts), lag.max=72, 
     main="Sample PACF of Electrcity Consumption")   

# seasonal plot 
# First, we create a tsibble object
elec_tsibble = as_tsibble(elec_ts) %>% rename(month=index)

p1 = elec_tsibble |>
  gg_season(value, labels = "both") +
  labs(y = "Electricity Consumption (in GWh)", x = "Month",
       title = "Seasonal plot: Monthly Electricity Consumption") +
  theme(plot.title = element_text(hjust = 0.5))
p2 = elec_tsibble |>
  gg_subseries(value) +
  labs(y = "Consumption", x = "Month",
       title = "Monthly Plot: Electricity Consumption")
grid.arrange(p2, p1, nrow=2, ncol=1)



###############################
# Differencing 
###############################
elec_ts<- ts(elec$overall, frequency=12, start=c(2005,1), end = c(2019, 12))

# first difference 
plot(diff(elec_ts),
     main="Time Series Plot of the First Differences of Electricity Consumption",
     ylab='First Difference of Eelectricity Consumption', xlab='Time')
acf(as.vector(diff(elec_ts)),lag.max=72,
    main="Sample ACF of First Differences")
pacf(as.vector(diff(elec_ts)),lag.max=72,
     main='Sample PACF of First Differences')


# seasonal difference 
plot(diff(elec_ts,lag=12),xlab='Time',
     ylab='Seasonal Difference of Electrcity Consumption',
     main='Time Series Plot of Seasonal Differences of Electrcity Consumption')
acf(as.vector(diff(elec_ts,lag=12)),lag.max=72,ci.type='ma',
    main='Sample ACF of Seasonal Differences')
pacf(as.vector(diff(elec_ts,lag=12)),lag.max=72,
     main='Sample PACF of Seasonal Differences')


# both first and seasonal difference 
plot(diff(diff(elec_ts),lag=12),xlab='Time',
     ylab='Seasonal Difference of Electrcity Consumption',
     main='Time Series Plot of First and Seasonal Differences of Electrcity Consumption')
acf(as.vector(diff(diff(elec_ts),lag=12)),lag.max=72,ci.type='ma',
    main='Sample ACF of First and Seasonal Differences')
pacf(as.vector(diff(diff(elec_ts),lag=12)),lag.max=72,
     main='Sample PACF of First and Seasonal Differences')
adf.test(diff(elec_ts,lag=12))


###############################
# Fitting the Model 
###############################

# model 1
sarima(elec_ts,1,0,0,1,1,0,12) 

# model 2
sarima(elec_ts,2,0,1,1,1,0,12) 

# model 3 - candidate 
sarima(elec_ts,1,0,1,1,1,0,12) 

# model 4 - candidate 
sarima(elec_ts,1,0,1,0,1,1,12) 

# model 5
sarima(elec_ts,0,1,1,0,1,1,12) 

# model 6 - candidate 
sarima(elec_ts,0,1,2,0,1,1,12) 


###############################
# Model diagnosis 
###############################

mod1 <- sarima(elec_ts,1,0,1,1,1,0,12) 
mod2 <- sarima(elec_ts,1,0,1,0,1,1,12) 
mod3 <- sarima(elec_ts,0,1,2,0,1,1,12) 

# model 1 
print(residuals(mod1$fit))
model_residuals <- residuals(mod1$fit)

par(mfrow = c(2, 2))
plot(time(elec_ts), model_residuals, 
     type = "l", main = "Residuals Against Time", xlab = "Time", 
     ylab = "Residuals")

hist(model_residuals, main = "Histogram of Residuals", 
     xlab = "Residuals", col = "lightblue", border = "black")

plot(model_residuals, type = "l", main = "Residual Time Series", 
     xlab = "Time", ylab = "Residuals")

plot(elec_ts, model_residuals, main = "Residual Scatter Plot", 
     xlab = "Time Series", ylab = "Residuals")


# model 2
print(residuals(mod2$fit))
model_residuals2 <- residuals(mod2$fit)

par(mfrow = c(2, 2))
plot(time(elec_ts), model_residuals2, 
     type = "l", main = "Residuals Against Time", xlab = "Time", 
     ylab = "Residuals")

hist(model_residuals2, main = "Histogram of Residuals", 
     xlab = "Residuals", col = "lightblue", border = "black")

plot(model_residuals2, type = "l", main = "Residual Time Series", 
     xlab = "Time", ylab = "Residuals")

plot(elec_ts, model_residuals2, main = "Residual Scatter Plot", 
     xlab = "Time Series", ylab = "Residuals")


# model 3
print(residuals(mod3$fit))
model_residuals3 <- residuals(mod3$fit)

par(mfrow = c(2, 2))
plot(time(elec_ts), model_residuals3, 
     type = "l", main = "Residuals Against Time", xlab = "Time", 
     ylab = "Residuals")

hist(model_residuals3, main = "Histogram of Residuals", 
     xlab = "Residuals", col = "lightblue", border = "black")

plot(model_residuals3, type = "l", main = "Residual Time Series", 
     xlab = "Time", ylab = "Residuals")

plot(elec_ts, model_residuals3, main = "Residual Scatter Plot", 
     xlab = "Time Series", ylab = "Residuals")



###############################
# Prediction - use SEASONAL arima
###############################

fit1 = sarima(window(elec_ts,end=c(2014,12)), 1,0,1,1,1,0, S = 12)
fit2 = sarima(window(elec_ts,end=c(2014,12)), 1,0,1,0,1,1, S = 12)
fit3 = sarima(window(elec_ts,end=c(2014,12)), 0,1,2,0,1,1, S = 12)

fit1.for = sarima.for(window(elec_ts,end=c(2014,12)), n.ahead = 60, 1,0,1,1,1,0, S = 12)
fit2.for = sarima.for(window(elec_ts,end=c(2014,12)), n.ahead = 60, 1,0,1,0,1,1, S = 12)
fit3.for = sarima.for(window(elec_ts,end=c(2014,12)), n.ahead = 60, 0,1,2,0,1,1, S = 12)

# Plot forecasts and test set
autoplot(elec_ts) + autolayer(fit1.for$pred) + 
  autolayer(fit2.for$pred) + autolayer(fit3.for$pred)

