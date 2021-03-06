% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/HighFreq.R
\name{price_jumps}
\alias{price_jumps}
\title{Identify isolated price jumps in a single-column \code{xts} time series of
prices, based on pairs of large neighboring returns of opposite sign.}
\usage{
price_jumps(x_ts, win_dow = 51, vol_mult = 2)
}
\arguments{
\item{x_ts}{single-column \code{xts} time series of prices.}

\item{win_dow}{number of data points for estimating rolling volatility.}

\item{vol_mult}{volatility multiplier.}
}
\value{
\code{Boolean} vector with the same number of rows as input time
  series.
}
\description{
Identify isolated price jumps in a single-column \code{xts} time series of
prices, based on pairs of large neighboring returns of opposite sign.
}
\details{
Isolated price jumps are single prices that are very different from 
  neighboring values.  Price jumps create pairs of large neighboring returns 
  of opposite sign. The function \code{price_jumps()} first calculates simple
  returns from prices. Then it calculates the rolling volatility of returns 
  as a quantile of returns over a rolling window. Jump prices are identified 
  as those where neighboring returns both exceed a multiple of the rolling 
  volatility, but the sum of those returns doesn't exceed it.
}
\examples{
# create local copy of SPY TAQ data
ta_q <- SPY_TAQ
# calculate mid prices
mid_prices <- 0.5 * (ta_q[, "Bid.Price"] + ta_q[, "Ask.Price"])
# replace whole rows containing suspect price jumps with NA, and perform locf()
ta_q[price_jumps(mid_prices, win_dow=31, vol_mult=1.0), ] <- NA
ta_q <- na.locf(ta_q)
}

