# TimeSeriesDates
Fills in missing time series values in R.

The function currently only works on the year, month, and day levels.  I plan to add functionality down to the second level (but need to find some suitable test data).

## Purpose of the Function
When performing time series analysis, it is important to make sure every time period is represented.  For example, if you select a minute as your time granualrity, every minute in your date range of interest must be represented in the data.  Consider a real world example: if you are looking at homicides over time for a small city with a day granularity, you will likely have many observations over a year, but you will (hopefully) not have a homicide every day.  It is a common mistake to analyze/visualize data without filling in every time period.

I found myself often trying to fill in these gaps in time series data in R, so wrote this function to help.

## Using the Function
The data for the function must be a dataframe with at least a date column.  This column must be able to be coerced into a date object using the as.POSIXct() function.  If you think this could be an issue, try converting your date using as.POSIXct().  If you find that you need to provide the as.POSIXct() function a specific format, please convert your dates before running the dateFill() function.

With no other options specified, the function will assume there is a row for every "event" in the time series.  For example, if you are building a time series of crimes, every row will have a date that represents when a single crime is committed.  The function is built to aggregate events into the specified time granularity (day, month, year, etc.), then fill in any missing holes.  

If your data is already aggregated (i.e. a row represents a time period with some count of events that occured in that time period), you will need to specify the column name where the counts are held.  This will cause the function to do any further aggregation by summing this column instead of counting a row as a single event.   
