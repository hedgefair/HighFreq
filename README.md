---
title: HighFreq Package for High Frequency Time Series Data Management
author: Jerzy Pawlowski (algoquant)
abstract: Functions for chaining and joining time series, scrubbing bad data, managing time zones and alligning time indices, converting TAQ data to OHLC format, aggregating data to lower frequency, estimating volatility, skew, and higher moments.
tags: high frequency, time series, volatility
---

[![Build Status](https://travis-ci.org/algoquant/HighFreq.svg?branch=master)](https://travis-ci.org/algoquant/HighFreq)


### Overview

The motivation for the *HighFreq* package is to create a library of functions designed for managing trade and quote (*TAQ*) and *OHLC* data, and for efficiently estimating various statistics, like volatility, skew, Hurst exponent, and Sharpe ratio, from that data.  

The are several other packages which offer much of this functionality, like for example:

+ package [xts](https://cran.r-project.org/web/packages/xts/index.html)  

+ package [TTR](https://cran.r-project.org/web/packages/TTR/index.html)  

+ package [PerformanceAnalytics](https://cran.r-project.org/web/packages/PerformanceAnalytics/index.html)  

+ package [highfrequency](https://cran.r-project.org/web/packages/highfrequency/index.html)  

Unfortunately many of the functions in these packages are either too slow, or lack some critical functionality, or produce data in inconsistent formats (with *NA* values, etc.)  The *HighFreq* package aims to create a unified framework, with consistent data formats and naming conventions. 

The *HighFreq* package relies on *OHLC* price and volume data formatted as *xts* time series, because the *OHLC* data format provides an efficient way of compressing *TAQ* data, while preserving information about price levels, volatility (range), and trading volumes.  Most existing packages don't rely on *OHLC* data, so their statistical estimators are much less efficient than those in package *HighFreq*. 


### Running and Rolling Statistics Over Time Series Data

Definitions of running and rolling statistics (aggregations):

+ A statistic is some function of *OHLC* data, for example the difference between
*high* minus *low* prices is a simple statistic.  Estimators of volatility, skew, and higher moments are also statistics.

+ So-called running statistics are based on individual bars of *OHLC* data, while rolling statistics are based on multiple bars of *OHLC* data taken from a lookback window.
Rolling statistics can be calculated from running statistics by calculating weighted averages.

+ The functions called *run_\** estimate running statistics based on each bar of *OHLC* data, and produce a single-column *xts* time series with the same number of rows as the *OHLC* time series.

+ The functions called *roll_\** estimate rolling statistics based on multiple bars of *OHLC* data taken from a lookback window, and often produce a single-column *xts* time series with the same number of rows as the *OHLC* time series.

+ Running and rolling statistics also represent a form of data aggregations, and can include many standard technical indicators, like *VWAP*, *Bollinger Bands*, etc.

<br>


### Functions for data scrubbing, formatting, and aggregation

The *HighFreq* package contains several categories of functions designed for:

+ managing *TAQ* and *OHLC* time series, 

+ estimating running and rolling statistics over time series, 


The *HighFreq* package contains functions for:

+ chaining and joining time series, 

+ scrubbing bad data from time series, 

+ managing time zones and alligning time indices, 

+ converting *TAQ* data to *OHLC* format, 

+ aggregating data to lower frequency (periodicity), 

+ estimating running statistics from *OHLC* data, such as volatility, skew, and higher moments (functions called *run_\**), 

+ calculating rolling aggregations (VWAP, Hurst exponent, Sharpe ratio, etc.), 

+ calculating seasonality aggregations, 

+ creating random *TAQ* and *OHLC* time series, 


### Installation and loading

Install package *HighFreq* from github:  

```r
install.packages("devtools")
devtools::install_github(repo="algoquant/HighFreq")
library(HighFreq)
```
<br>

Install package *HighFreq* from source on local drive:  

```r
install.packages(pkgs="C:/Develop/R/HighFreq", repos=NULL, type="source")
# Install package from source on local drive using R CMD
R CMD INSTALL C:\Develop\R\HighFreq
library(HighFreq)
```
<br>

Build reference manual for package *HighFreq* from *.Rd* files:  

```r
system("R CMD Rd2pdf C:/Develop/R/HighFreq")
R CMD Rd2pdf C:\Develop\R\HighFreq
```
<br>


### Data

The *HighFreq* package includes three *xts* time series called *SPY*, *TLT*, and *VXX*, containing intraday 1-minute *OHLC* data for the *SPY*, *TLT*, and *VXX* ETFs.  The *HighFreq* package also includes an *xts* time series called *SPY_TAQ* with a single day of *TAQ* data for the *SPY*ETF.  The data is set up for lazy loading, so it doesn't require calling `data(hf_data)` to load it before being able to call it.

The data source is the 
[Wharton Research Data Service](https://wrds-web.wharton.upenn.edu/wrds/)  


### Examples

Aggregate *TAQ* data into a 1-minute bar *OHLC* time series:  

```r
# aggregate TAQ data to 1-min OHLC bar data, for a single symbol, and save to file
sym_bol <- "SPY"
save_scrub_agg(sym_bol, 
               data_dir="E:/mktdata/sec/", 
               output_dir="E:/output/data/")
```
<br>

Calculate daily trading volume:  

```r
daily_volume <- apply.daily(x=Vo(SPY), FUN=sum)
colnames(daily_volume) <- paste0(na_me(SPY), ".Volume")
chart_Series(x=daily_volume, name="daily trading volumes for SPY")
```
<br>

Calculate daily volume-weighted variance (volatility):  

```r
daily_var <- apply.daily(x=SPY, FUN=agg_regate, mo_ment="run_variance")
colnames(daily_var) <- paste0(na_me(SPY), ".Var")
chart_Series(x=daily_var, name="daily variance for SPY")
```
<br>

Calculate daily skew:  

```r
daily_skew <- apply.daily(x=SPY, FUN=agg_regate, mo_ment="run_skew")
daily_skew <- daily_skew/(daily_var)^(1.5)
colnames(daily_skew) <- paste0(na_me(SPY), ".Skew")
chart_Series(x=daily_skew, name="daily skew for SPY")
```
<br>

Calculate rolling prices:  

```r
roll_prices <- rutils::roll_sum(Op(SPY), win_dow=10)/10
colnames(roll_prices) <- paste0("SPY", ".Rets")
# plot candle chart
chart_Series(SPY["2013-11-12", ], name=paste("SPY", "Prices"))
add_TA(roll_prices["2013-11-12"], on=1, col="red", lwd=2)
```
<br>

Calculate rolling volume-weighted variance:  

```r
roll_var <- roll_moment(oh_lc=SPY["2012"], mo_ment="run_variance", win_dow = 10)
# plot without overnight jump
chart_Series(roll_var["2012-11-12", ][-(1:11)], name=paste("SPY", "rolling volume-weighted variance"))
```
<br>

Calculate daily seasonality of variance:  

```r
var_seasonal <- season_ality(run_variance(oh_lc=SPY))
colnames(var_seasonal) <- "SPY.var_seasonal"
chart_Series(x=var_seasonal, name="SPY variance daily seasonality")
```
