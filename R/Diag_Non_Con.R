#' Goodness of fit of non-extreme marginal distributions
#'
#' Fits two (unbounded) non-extreme marginal distributions to a dataset and returns three plots demonstrating their relative goodness of fit.
#'
#' @param Data Numeric vector containing realizations of the variable of interest.
#' @param x_lab Character vector of length one specifying the label on the x-axis of histogram and cumulative distribution plot.
#' @param y_lim_min Numeric vector of length one specifying the lower y-axis limit of the histogram. Default is \code{0}.
#' @param y_lim_max Numeric vector of length one specifying the upper y-axis limit of the histogram. Default is \code{1}.
#' @return Dataframe \code{$AIC} giving the AIC associated with each distribution and the name of the best fitting distribution \code{$Best_fit}. Panel consisting of three plots. Upper plot: Plot depicting the AIC of the two fitted distributions. Middle plot: Probability Density Functions (PDFs) of the fitted distributions superimposed on a histogram of the data. Lower plot: Cumulative Distribution Functions (CDFs) of the fitted distributions overlaid on a plot of the empirical CDF.
#' @seealso \code{\link{Copula_Threshold_2D}}
#' @export
#' @examples
#' S20.Rainfall<-Con_Sampling_2D(Data_Detrend=S20.Detrend.df[,-c(1,4)],
#'                               Data_Declust=S20.Detrend.Declustered.df[,-c(1,4)],
#'                               Con_Variable="Rainfall",Thres=0.97)
#' Diag_Non_Con(Data=S20.Rainfall$Data$OsWL,x_lab="O-sWL (ft NGVD 29)",
#'              y_lim_min=0,y_lim_max=1.5)
Diag_Non_Con<-function(Data,x_lab,y_lim_min=0,y_lim_max=1){

  par(mfrow=c(3,1))
  par(mar=c(4.2,4.2,1,1))

  #AIC
  fit<-fitdistr(Data,"logistic")
  AIC.Logistic<-2*length(fit$estimate)-2*fit$loglik

  fit<-fitdistr(Data, "normal")
  AIC.Normal<-2*length(fit$estimate)-2*fit$loglik

  mypalette<-brewer.pal(9,"Set1")

  plot(0,xlim=c(0,2),ylim=c(min(0,AIC.Normal,AIC.Logistic),max(0,AIC.Normal,AIC.Logistic)),type='n',xlab="Probability Distribution",ylab="AIC",xaxt='n',cex.axis=1,cex.lab=1,las=1)
  axis(1,seq(0.5,1.5,1),c("Gaus","Logis"),cex.axis=0.71)
  rect(0.25,0,0.75,AIC.Normal,col=mypalette[4])
  rect(1.25,0,1.75,AIC.Logistic,col=mypalette[6])

  hist(Data, freq=FALSE,xlab=x_lab,col="white",main="",cex.lab=1,cex.axis=1,ylim=c(y_lim_min,y_lim_max),las=1)
  x<-seq(min(Data),max(Data),0.01)
  #text(5.35,0.1,"(f)",font=2,cex=1.75)

  fit<-fitdistr(Data, "normal")
  lines(x,dnorm(x,fit$estimate[1],fit$estimate[2]),col=mypalette[4],lwd=2)

  fit<-fitdistr(Data,"logistic")
  lines(x,dlogis(x,fit$estimate[1],fit$estimate[2]),col=mypalette[6],lwd=2)

  plot(sort(Data),seq(1,length(Data),1)/(length(Data)),ylim=c(0,1),xlab=x_lab,ylab="P(X<x)",main="",pch=16,cex.lab=1,cex.axis=1,las=1)
  x<-seq(min(Data),max(Data),0.01)
  eta<-sqrt((1/(2*length(Data)))*log(2/0.95))
  lines(sort(Data),ifelse(seq(1,length(Data),1)/(length(Data))+eta>1,1,seq(1,length(Data),1)/(length(Data))+eta),col=1,lty=2)
  lines(sort(Data),ifelse(seq(1,length(Data),1)/(length(Data))-eta<0,0,seq(1,length(Data),1)/(length(Data))-eta),col=1,lty=2)
  legend("bottomright",c("95% Conf. Interval","Fitted distributions."),lty=c(2,1),col=c(1,1),cex=1,bty='n',border = "white")
  #text(2,1,"(g)",font=2,cex=1.75)

  fit<-fitdistr(Data,"normal")
  lines(x,pnorm(x,fit$estimate[1],fit$estimate[2]),col=mypalette[4],lwd=2)

  fit<-fitdistr(Data,"logistic")
  lines(x,plogis(x,fit$estimate[1],fit$estimate[2]),col=mypalette[6],lwd=2)

  AIC<-data.frame(c("Gaus","Logis"),c(AIC.Normal,AIC.Logistic))
  colnames(AIC)<-c("Distribution","AIC")
  Best_fit<-AIC$Distribution[which(AIC$AIC==min(AIC$AIC))]
  res<-list("AIC"=AIC,"Best_fit"=Best_fit)
  return(res)
}

