% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Mean_Excess_Plot.R
\name{Mean_Excess_Plot}
\alias{Mean_Excess_Plot}
\title{Mean excess plot - GPD threshold selection}
\usage{
Mean_Excess_Plot(Data)
}
\arguments{
\item{data}{A vector comprising a declustered and if necessary detrended time series to be modelled.}
}
\value{
Plot of the empirical mean excess function (black line), average of all observations exceeding a threshold decreased by the threshold, for thresholds spanning the range of the observations. Also provided are \code{95\%} confidence intervals (blue dotted lines) and the observations (black dots).
}
\description{
The empirical mean excess function is linear in the case of a GPD.
}
\examples{
Mean_Excess_Plot(Data=S20_Detrend_Declustered_df$Rainfall)
}
\seealso{
\code{\link{Decluster}} \code{\link{Detrend}}
}
