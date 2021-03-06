% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/HighFreq.R
\name{run_returns}
\alias{run_returns}
\title{Calculate single period returns from either \code{TAQ} or \code{OHLC} prices.}
\usage{
run_returns(x_ts)
}
\arguments{
\item{x_ts}{\code{xts} time series of either \code{TAQ} or \code{OHLC} data.}
}
\value{
A single-column \code{xts} time series of returns.
}
\description{
Calculate single period returns from either \code{TAQ} or \code{OHLC} prices.
}
\details{
Calculates single period returns as the ratio of differenced mid
  prices divided by the time index differences.
}
\examples{
# create random TAQ prices
ta_q <- HighFreq::random_TAQ()
re_turns <- HighFreq::run_returns(ta_q)
}

