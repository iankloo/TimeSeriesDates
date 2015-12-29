
##Function to fill in holes in time series data
dateFill <- function(data, aggLevel = c('year','month','day'), sumvar= 'none'){
  require(stringr)
  cnames <- colnames(data)
  data$Date <- as.POSIXct(data$Date)
  data$Count <- rep.int(1,nrow(data))
  if(aggLevel=='year'){
    data$Year <- as.numeric(format(data$Date,'%Y'))
    if(sumvar == 'none'){
      data.sub <- aggregate(Count ~ Year, data, FUN = sum)
    } else{
      data.sub <- aggregate(eval(parse(text=sumvar)) ~ Year, data, FUN=sum)
      colnames(data.sub)[2] <- 'Sum'
    }
    full.time <- data.frame(Year=as.numeric(format(seq(min(data$Date), max(data$Date), by='year'),'%Y')))
    merged.data <- merge(full.time, data.sub, by='Year',all=TRUE)
    merged.data[is.na(merged.data)] <- 0
  } else if(aggLevel=='month'){
    data$Month <- paste(str_sub(data$Date, start=1, end=7),'-01',sep='')
    if(sumvar == 'none'){
      data.sub <- aggregate(Count ~ Month, data, FUN = sum)
    } else{
      data.sub <- aggregate(eval(parse(text=sumvar)) ~ Month, data, FUN=sum)
      colnames(data.sub)[2] <- 'Sum'
    }
    data.sub$Month <- as.POSIXct(data.sub$Month)
    data$Month <- as.POSIXct(data$Month)
    full.time <- data.frame(Month=seq(min(data$Month), max(data$Month), by='month'))
    merged.data <- merge(full.time, data.sub, by='Month',all=TRUE)
    merged.data[is.na(merged.data)] <- 0
  } else if(aggLevel=='day'){
    data$Day <- as.Date(data$Date)
    if(sumvar == 'none'){
      data.sub <- aggregate(Count ~ Day, data, FUN = sum)
    } else{
      data.sub <- aggregate(eval(parse(text=sumvar)) ~ Day, data, FUN=sum)
      colnames(data.sub)[2] <- 'Sum'
    }
    full.time <- data.frame(Day=seq(min(data$Day), max(data$Day), by='day'))
    merged.data <- merge(full.time, data.sub, by='Day',all=TRUE)
    merged.data[is.na(merged.data)] <- 0
  } else if(aggLevel=='hour'){
    data$Hour <- paste(str_sub(data$Date, start=1, end=14),'00:00',sep='')
    if(sumvar == 'none'){
      data.sub <- aggregate(Count ~ Hour, data, FUN = sum)
    } else{
      data.sub <- aggregate(eval(parse(text=sumvar)) ~ Hour, data, FUN=sum)
      colnames(data.sub)[2] <- 'Sum'
    }
    data.sub$Hour <- as.POSIXct(data.sub$Hour)
    data$Hour <- as.POSIXct(data$Hour)
    full.time <- data.frame(Hour=seq(min(data$Hour), max(data$Hour), by='hour'))
    merged.data <- merge(full.time, data.sub, by='Hour',all=TRUE)
    merged.data[is.na(merged.data)] <- 0
  } else if(aggLevel=='minute'){
    data$Minute <- paste(str_sub(data$Date, start=1, end=17),'00',sep='')
    if(sumvar == 'none'){
      data.sub <- aggregate(Count ~ Minute, data, FUN = sum)
    } else{
      data.sub <- aggregate(eval(parse(text=sumvar)) ~ Minute, data, FUN=sum)
      colnames(data.sub)[2] <- 'Sum'
    }
    data.sub$Minute <- as.POSIXct(data.sub$Minute)
    data$Minute <- as.POSIXct(data$Minute)
    full.time <- data.frame(Minute=seq(min(data$Minute), max(data$Minute), by='min'))
    merged.data <- merge(full.time, data.sub, by='Minute', all=TRUE)
    merged.data[is.na(merged.data)] <- 0
  } else if(aggLevel=='second'){
    data$Second <- str_sub(data$Date, start=1, end=19)
    if(sumvar == 'none'){
      data.sub <- aggregate(Count ~ Second, data, FUN = sum)
    } else{
      data.sub <- aggregate(eval(parse(text=sumvar)) ~ Second, data, FUN=sum)
      colnames(data.sub)[2] <- 'Sum'
    }
    data.sub$Second <- as.POSIXct(data.sub$Second)
    data$Second <- as.POSIXct(data$Second)
    full.time <- data.frame(Second=seq(min(data$Second), max(data$Second), by='sec'))
    merged.data <- merge(full.time, data.sub, by='Second',all=TRUE)
    merged.data[is.na(merged.data)] <- 0
  }
  dataFull <- merged.data
  colnames(dataFull) <- cnames
  return(dataFull)
}




###Testing
#df <- read.csv('Chiraq_Subset.csv')
#df <- subset(df,select=c('Date','Arrest'))
#df <- df[df$Arrest==TRUE,]
#df$Arrest <- as.numeric(df$Arrest)

#df$Date <- as.POSIXct(df$Date, format='%m/%d/%y')
#dateFill(df,'month')


#df$Num <- round(rnorm(nrow(df),10,2))
#df$Arrest <- NULL

#dateFill(df,'month','Num')

