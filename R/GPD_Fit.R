#' Fits a single generalized Pareto distribution - Fit
#'
#' Fit a Generalized Pareto Distribution (GPD) to a declustered dataset.
#'
#' @param Data Numeric vector containing the declusted data.
#' @param Data_Full Numeric vector containing the non-declustered data.
#' @param u GPD threshold; as a quantile \code{[0,1]} of \code{Data} vector. Default is \code{0.95}.
#' @param mu Numeric vector of length one specifying (average) occurrence frequency of events in the \code{Data_Full} input. Default is \code{365.25}.
#' @param min.RI Numeric vector of length one specifying the minimum return period in the return level plot. Default is \code{1}.
#' @param Plot Logical; indicating whether to plot diagnostics. Default is \code{FALSE}.
#' @param xlab_hist Character vector of length one. Histogram x-axis label. Default is \code{"Data"}.
#' @param y_lab Character vector of length one. Histogram x-axis label. Default is \code{"Data"}.
#' @section Details:
#' For excesses of a variable X over a suitably high threshold u the fitted GPD model is parameterized as follows: \deqn{P( X > x| X > u) = \left[1 + \xi \frac{(x-u)}{\sigma}\right]^{-\frac{1}{\xi}}_{+}}
#' where \eqn{\xi} and \eqn{\sigma>0} are the shape and scale parameters  of the GPD and \eqn{[y]_{+}=max(y,0)}.
#' @return List comprising the GPD \code{Threshold}, shape parameter \code{xi} and scale parameters \code{sigma} along with their standard errors \code{sigma.SE} and \code{xi.SE}.
#' @export
#' @examples
#' Decluster(Data=S20_T_MAX_Daily_Completed_Detrend$Detrend)
GPD_Fit<-function(Data,Data_Full,u=0.95,mu=365.25,min.RI=1,PLOT=FALSE,xlab_hist="Data",y_lab="Data"){
  gpd<-evm(na.omit(Data), th=quantile(Data_Full,u),penalty = "gaussian",priorParameters = list(c(0, 0), matrix(c(100^2, 0, 0, 0.25), nrow = 2)))
  if(PLOT==TRUE){
  GPD_diag_HT04(Data=na.omit(Data),
                Data_Full=Data_Full,
                model=gpd,
                param=c(exp(summary(gpd)$coef[[1]]), summary(gpd)$coef[[2]]),
                thres=quantile(Data_Full,u),
                mu=mu,
                min.RI=min.RI,
                xlab.hist=xlab_hist,
                y.lab=y_lab)
  }
  res<-list("Threshold"=quantile(Data_Full,u),"sigma" = exp(summary(gpd)$coef[[1]]), "xi" = summary(gpd)$coef[[2]],"sigma.SE" = summary(gpd)$coef[[3]],"xi.SE" = summary(gpd)$coef[[4]])
  return(res)
}

