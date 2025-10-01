
## Dataset
- **Source**: Kaggle - Monthly Household Electricity Consumption in Singapore
- **Time Period**: January 2005 - December 2019
- **Variables**: Monthly electricity consumption (GWh) across various dwelling types
- **Preprocessing**: Removed partial 2020 data, sorted by time, used 'overall' consumption column

## Key Features
- **Exploratory Data Analysis**: Identified strong upward trend and annual seasonality
- **Stationarity Transformation**: Applied first differencing and seasonal differencing (lag-12)
- **Model Development**: Implemented three approaches:
  - Box-Jenkins Method
  - Dynamics Method
  - Textbook Method (Time Series Analysis With Applications in R)
- **Model Validation**: Residual diagnostics, ACF/PACF analysis, Ljung-Box test
- **Forecasting**: 5-year out-of-sample validation using train-test split

## Final Models
Three candidate models were evaluated:
1. **Model 1**: ARIMA(1,0,1)(1,1,0)₁₂ (Selected as final parsimonious model)
2. **Model 2**: ARIMA(1,0,1)(0,1,1)₁₂
3. **Model 3**: ARIMA(0,1,2)(0,1,1)₁₂ (Complex model for comparison)

## Technologies Used
- **Programming Language**: R
- **Key Libraries**: `forecast`, `tseries`, `ggplot2`, `stats`
- **Methods**: SARIMA modelling, ACF/PACF analysis, seasonal differencing, residual diagnostics

## Key Findings
- Strong upward trend and consistent annual seasonality observed
- Summer months (June-July) show highest consumption due to Singapore's tropical climate
- Seasonal differencing effectively removed seasonality patterns
- Model 1 (ARIMA(1,0,1)(1,1,0)₁₂) provided the best balance of performance and simplicity

## How to Run
1. Clone this repository
2. Install required R packages: `install.packages(c("forecast", "tseries", "ggplot2"))`
3. Run scripts in numerical order from the `scripts/` directory
4. View generated plots in the `output/` folder

## Results
The selected model successfully captures the seasonal patterns and provides reliable 5-year forecasts, demonstrating practical application of time series analysis for energy consumption forecasting.

## Authors
- Nishat Islam , Si Chen, Yanjin Chen, Joshua Gagnier

## Course Context
This project was completed as part of STAT 485 - Time Series Analysis at Simon Fraser University, Fall 2023.

## References
- Cryer, J.D. & Chan, K.S. (2008). Time Series Analysis With Applications in R
- Hyndman, R.J. & Athanasopoulos, G. (2018). Forecasting: Principles and Practice
- Original dataset: [Kaggle - Singapore Electricity Consumption](https://www.kaggle.com/datasets/...)
