#' Goodness of fit of non-extreme marginal distributions
#'
#' Fits seven (truncated) non-extreme marginal distributions to a dataset and returns three plots demonstrating their relative goodness of fit.
#'
#' @param Data Numeric vector containing realizations of the variable of interest.
#' @param x_lab Character vector of length one specifying the label on the x-axis of histogram and cumulative distribution plot.
#' @param y_lim_min Numeric vector of length one specifying the lower y-axis limit of the histogram. Default is \code{0}.
#' @param y_lim_max Numeric vector of length one specifying the upper y-axis limit of the histogram. Default is \code{1}.
#' @return Name of the best fitting distribution \code{Best_fit}. Panel consisting of three plots. Upper plot: Plot depicting the AIC of the eight fitted distributions. Middle plot: Probability Density Functions (PDFs) of the fitted distributions superimposed on a histogram of the data. Lower plot: Cumulative Distribution Functions (CDFs) of the fitted distributions overlaid on a plot of the empirical CDF.
#' @seealso \code{\link{Copula_Threshold_2D}}
#' @export
#' @examples
#' S20.OsWL<-Con_Sampling_2D(Data_Detrend=S20.Detrend.df[,-c(1,4)],
#'                          Data_Declust=S20.Detrend.Declustered.df[,-c(1,4)],
#'                          Con_Variable="OsWL",Thres=0.97)
#' Diag_Non_Con_Trunc(Data=S20.OsWL$Data$Rainfall,x_lab="Rainfall (Inches)",
#'                    y_lim_min=0,y_lim_max=2)
Diag_Non_Con_Trunc<-function(Data,x_lab,y_lim_min=0,y_lim_max=1){
  mypalette<-brewer.pal(9,"Set1")
  par(mfrow=c(3,1))
  par(mar=c(4.2,4.2,1,1))

  #AIC

  bdata2 <- data.frame(shape = exp(-0.5), scale = exp(0.5))
  bdata2 <- transform(bdata2, y = Data)
  fit <- vglm(y ~ 1, bisa, data = bdata2, trace = FALSE)
  AIC.BS<-2*length(coef(fit))-2*logLik(fit)

  fit<-fitdistr(Data,"exponential")
  AIC.Exp<-2*length(fit$estimate)-2*fit$loglik

  fit<-fitdistr(Data, "gamma")
  AIC.Gamma<-2*length(fit$estimate)-2*fit$loglik

  #fit<-fitdist(Data, "invgauss", start = list(mean = 5, shape = 1))
  #AIC.InverseNormal<-2*length(fit$estimate)-2*fit$loglik

  fit<-fitdistr(Data,"lognormal")
  AIC.logNormal<-2*length(fit$estimate)-2*fit$loglik

  fit <- fitdistr(Data, "normal")
  AIC.TNormal <- 2 * length(fit$estimate) - 2 * fit$loglik

  fit <- tweedie.profile(Data ~ 1,
                         p.vec=seq(1.5, 2.5, by=0.2), do.plot=FALSE)
  AIC.Tweedie<-2*3-2*fit$L.max

  fit<-fitdistr(Data,"weibull")
  AIC.Weib<-2*length(fit$estimate)-2*fit$loglik

  plot(0,xlim=c(0,7),ylim=c(min(0,AIC.BS,AIC.Exp,AIC.Gamma,AIC.logNormal,AIC.TNormal,AIC.Tweedie,AIC.Weib),max(0,AIC.BS,AIC.Exp,AIC.Gamma,AIC.TNormal,AIC.logNormal,AIC.Tweedie,AIC.Weib)),type='n',xlab="Probability Distribution",ylab="AIC",xaxt='n',cex.axis=1,cex.lab=1,las=1)
  axis(1,seq(0.5,6.5,1),c("Birn-S","Exp","Gam","LogN","TNorm","Twe","Weib"),cex.axis=0.71)
  rect(0.25,0,0.75,AIC.BS,col=mypalette[1])
  rect(1.25,0,1.75,AIC.Exp,col=mypalette[2])
  rect(2.25,0,2.75,AIC.Gamma,col=mypalette[3])
  rect(3.25,0,3.75,AIC.logNormal,col=mypalette[4])
  rect(4.25,0,4.75,AIC.TNormal,col=mypalette[5])
  rect(5.25,0,5.75,AIC.Tweedie,col=mypalette[6])
  rect(6.25,0,6.75,AIC.Weib,col=mypalette[7])

  hist(Data, freq=FALSE,xlab=x_lab,col="white",main="",cex.lab=1,cex.axis=1,ylim=c(y_lim_min,y_lim_max),las=1)
  x<-seq(min(Data),max(Data),0.01)
  #text(5.35,0.1,"(f)",font=2,cex=1.75)

  bdata2 <- data.frame(shape = exp(-0.5), scale = exp(0.5))
  bdata2 <- transform(bdata2, y = Data)
  fit <- vglm(y ~ 1, bisa, data = bdata2, trace = FALSE)
  lines(x,dbisa(x,Coef(fit)[1],Coef(fit)[2]),col=mypalette[1],lwd=2)

  fit<-fitdistr(Data,"exponential")
  lines(x,dexp(x,fit$estimate[1]),col=mypalette[2],lwd=2)

  fit<-fitdistr(Data, "gamma")
  lines(x,dgamma(x,fit$estimate[1],fit$estimate[2]),col=mypalette[3],lwd=2)

  fit<-fitdistr(Data,"lognormal")
  lines(x,dlnorm(x,fit$estimate[1],fit$estimate[2]),col=mypalette[4],lwd=2)

  fit <- fitdistr(Data, "normal")
  lines(x, dtruncnorm(x, a = min(Data), mean = fit$estimate[1],
                        sd = fit$estimate[2]), col = mypalette[5], lwd = 2)

  fit <- tweedie.profile(Data ~ 1,
                           p.vec=seq(1.5, 2.5, by=0.2), do.plot=FALSE)
  lines(x,dtweedie(x,  power=fit$p.max, mu=mean(Data), phi=fit$phi.max),col=mypalette[6],lwd=2)

  fit<-fitdistr(Data,"weibull")
  lines(x,dweibull(x,fit$estimate[1],fit$estimate[2]),col=mypalette[7],lwd=2)

  plot(sort(Data),seq(1,length(Data),1)/(length(Data)),ylim=c(0,1),xlab=x_lab,ylab="P(X<x)",main="",pch=16,cex.lab=1,cex.axis=1,las=1)
  x<-seq(min(Data),max(Data),0.01)
  eta<-sqrt((1/length(Data))*log(2/0.95))
  lines(sort(Data),ifelse(seq(1,length(Data),1)/(length(Data))+eta>1,1,seq(1,length(Data),1)/(length(Data))+eta),col=1,lty=2)
  lines(sort(Data),ifelse(seq(1,length(Data),1)/(length(Data))-eta<0,0,seq(1,length(Data),1)/(length(Data))-eta),col=1,lty=2)
  legend("bottomright",c("95% Conf. Interval","Fitted distributions"),lty=c(2,1),col=c(1,4),cex=1,bty='n',border = "white")
  #text(2,1,"(g)",font=2,cex=1.75)

  bdata2 <- data.frame(shape = exp(-0.5), scale = exp(0.5))
  bdata2 <- transform(bdata2, y = Data)
  fit <- vglm(y ~ 1, bisa, data = bdata2, trace = FALSE)
  lines(x,pbisa(x,Coef(fit)[1],Coef(fit)[2]),col=mypalette[1],lwd=2)

  fit<-fitdistr(Data,"exponential")
  lines(x,pexp(x,fit$estimate[1]),col=mypalette[2],lwd=2)

  fit<-fitdistr(Data,"gamma")
  lines(x,pgamma(x,fit$estimate[1],fit$estimate[2]),col=mypalette[3],lwd=2)

  fit<-fitdistr(Data,"lognormal")
  lines(x,plnorm(x,fit$estimate[1],fit$estimate[2]),col=mypalette[4],lwd=2)

  fit <- fitdistr(Data,"normal")
  lines(x, ptruncnorm(x, a = min(Data), mean = fit$estimate[1],
                      sd = fit$estimate[2]), col = mypalette[5], lwd = 2)

  fit <- tweedie.profile(Data ~ 1,
                           p.vec=seq(1.5, 2.5, by=0.2), do.plot=FALSE)
  lines(x,ptweedie(x,  power=fit$p.max, mu=mean(Data), phi=fit$phi.max),col=mypalette[6],lwd=2,pch=16,ylab="P(X<x)")

  fit<-fitdistr(Data,"weibull")
  lines(x,pweibull(x,fit$estimate[1],fit$estimate[2]),col=mypalette[7],lwd=2)

  Best_fit<-c("BS","Exp","Gam","LogN","TNorm","Twe","Weib")[which(c(AIC.BS,AIC.Exp,AIC.Gamma,AIC.logNormal,AIC.TNormal,AIC.Tweedie,AIC.Weib)==min(AIC.BS,AIC.Exp,AIC.Gamma,AIC.logNormal,AIC.TNormal,AIC.Tweedie,AIC.Weib))]
  return(Best_fit)
}

