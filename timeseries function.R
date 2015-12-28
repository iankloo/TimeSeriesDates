
##Function to fill in holes in time series data

dateFill <- function(data, aggLevel = c('year','month','day')){
  cnames <- colnames(data)
  data$Date <- as.Date(data$Date)
  data$Year <- as.numeric(format(data$Date,'%Y'))
  data$Month <- as.numeric(format(data$Date, '%m'))
  data$Day <- as.numeric(format(data$Date, '%d'))
  data$Count <- rep.int(1,nrow(data))
  
  if(aggLevel=='year'){
    data.sub <- aggregate(Count ~ Year, data, FUN = sum)
    full.time <- data.frame(Year=as.numeric(format(seq(min(data$Date), max(data$Date), by='year'),'%Y')))
    merged.data <- merge(full.time, data.sub, by='Year',all=TRUE)
    merged.data[is.na(merged.data)] <- 0
  } else if(aggLevel=='month'){
    data$yearmonth <- as.Date(as.yearmon(paste(data$Year, data$Month),'%Y %m'))
    data.sub <- aggregate(Count ~ yearmonth, data, FUN = sum)
    full.time <- data.frame(yearmonth=seq(min(data$yearmonth), max(data$yearmonth), by='month'))
    merged.data <- merge(full.time, data.sub, by='yearmonth',all=TRUE)
    merged.data[is.na(merged.data)] <- 0
    warning('When aggregating data to month scale, all dates are set to the first day of the month')
  } else if(aggLevel=='day'){
    data.sub <- aggregate(Count ~ Date, data, FUN = sum)
    full.time <- data.frame(Date=seq(min(data$Date), max(data$Date), by='day'))
    merged.data <- merge(full.time, data.sub, by='Date',all=TRUE)
    merged.data[is.na(merged.data)] <- 0
  }
  dataFull <- merged.data
  colnames(dataFull) <- cnames
  return(dataFull)
}

###Testing
#df <- read.csv('ChicagoHomicides.csv')
#df <- subset(df,select=c('Date','Arrest'))
#df <- df[df$Arrest==TRUE,]
#df$Arrest <- as.numeric(df$Arrest)

#newdata <- dateFill(df,aggLevel='year')
