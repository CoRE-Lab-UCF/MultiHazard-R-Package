#' Creates a dataframe containing up to five time series
#'
#' Combines up to five time series, detrended where necessary, into a single dataframe.
#'
#' @param data.1:5 Dataframes with two columns containing in column \itemize{
#' \item 1 - Continuous sequence of times spaning from the first to the final recorded observations.
#' \item 2 - Corresponding values detrended where necessary.
#' }
#' @param n Integer \code{1-5} specifying the number of time series. Default is \code{3}.
#' @return A dataframe containing all times from the first to the most up to date reading of any of the variables.
#' @seealso \code{\link{Detrend}}
#' @export
#' @examples
#' #Reading in data for site S22
#' Miami_Airport_df<-read.csv("C:\\Users\\ro327497\\Documents\\SFWMD\\SFWMD Data\\S22\\Miami_Airport_df.csv")[,-1]
#' S22_T_MAX_Daily_Completed_Detrend_Declustered<-read.csv("C:\\Users\\ro327497\\Documents\\SFWMD\\SFWMD Data\\S22\\S22_T_MAX_Daily_Completed_Detrend_Declustered.csv")[,-1]
#' G580A_GWValueFilled_Detrend_Declustered<-read.csv("C:\\Users\\ro327497\\Documents\\SFWMD\\SFWMD Data\\S22\\G580A_GWValueFilled_Detrend_Declustered.csv")[,-1]
#Apply Detrend.Declustered.Combine function
#' S22.Detrend.Declustered.df<-Dataframe_Combine(data.1<-Miami_Airport_df,data.2<-S22_T_MAX_Daily_Completed_Detrend_Declustered[,c(1,4)],data.3<-G580A_GWValueFilled_Detrend_Declustered[,c(1,4)],names=c("Rainfall","OsWL","Groundwater"))
#' S22.Detrend.df<-Dataframe_Combine(data.1<-Miami_Airport_df,data.2<-S22_T_MAX_Daily_Completed_Detrend_Declustered[,c(1,3)],data.3<-G580A_GWValueFilled_Detrend_Declustered[,c(1,3)],names=c("Rainfall","OsWL","Groundwater"))
Dataframe_Combine<-function(data.1,data.2,data.3,data.4=0,data.5=0,n=3,names){

  data_Detrend_1_df<-data.frame(data.1[,1],data.1[,2])
  colnames(data_Detrend_1_df)<-c("Date",colnames(data.1)[2])

  data_Detrend_2_df<-data.frame(data.2[,1],data.2[,2])
  colnames(data_Detrend_2_df)<-c("Date",colnames(data.2)[2])

  if(n==2){
   Detrend_df<-full_join(data.Detrend_1_df, data_Detrend_2_df, by="Date")
  }

  if(n==3){
   data_Detrend_3_df<-data.frame(data.3[,1],data.3[,2])
   colnames(data_Detrend_3_df)<-c("Date",colnames(data.3)[2])

   data.Detrend_df1<-full_join(data_Detrend_1_df, data_Detrend_2_df, by="Date")
   Detrend_df<-full_join(data.Detrend_df1, data_Detrend_3_df, by="Date")
  }

  if(n==4){
   data_Detrend_3_df<-data.frame(data.3[,1],data.3[,2])
   colnames(data_Detrend_3_df)<-c("Date",colnames(data.3)[2])

   data_Detrend_4_df<-data.frame(data.4[,1],data.4[,2])
   colnames(data_Detrend_4_df)<-c("Date",colnames(data.4)[2])

   data.Detrend_df1<-full_join(data_Detrend_1_df, data_Detrend_2_df, by="Date")
   data.Detrend_df2<-full_join(data_Detrend_df1, data_Detrend_3_df, by="Date")
   Detrend_df<-full_join(data_Detrend_df2, data_Detrend_4_df, by="Date")
  }

  if(n==5){
    data_Detrend_3_df<-data.frame(data.3[,1],data.3[,2])
    colnames(data_Detrend_3_df)<-c("Date",colnames(data.3)[2])

    data_Detrend_4_df<-data.frame(data.4[,1],data.4[,2])
    colnames(data_Detrend_4_df)<-c("Date",colnames(data.4)[2])

    data_Detrend_5_df<-data.frame(data.5[,1],data.5[,2])
    colnames(data_Detrend_5_df)<-c("Date",colnames(data.5)[2])

    data.Detrend_df1<-full_join(data_Detrend_1_df, data_Detrend_2_df, by="Date")
    data.Detrend_df2<-full_join(data_Detrend_df1, data_Detrend_3_df, by="Date")
    data.Detrend_df3<-full_join(data_Detrend_df2, data_Detrend_4_df, by="Date")
    Detrend_df<-full_join(data_Detrend_df3, data_Detrend_5_df, by="Date")
  }

Detrend_df[order(as.Date(Detrend_df$Date, format="%d/%m/%Y")),]
colnames(Detrend_df)<-c("Date",names)
return(Detrend_df)
}

