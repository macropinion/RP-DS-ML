
# ================================================================
# join fdi and gdp data
# ================================================================

joinData <- function(DataPool){
  
  # get Parameters
  indicatorName <- names(DataPool)
  numData <- length(indicatorName)
  
  # join data using left_join
  data <- copy(DataPool[[1]]) %>% setnames(old = 'Value', new = indicatorName[1])
  for (iD in 2:numData){
    # get data.table
    dataI <- copy(DataPool[[iD]]) %>% setnames(old = 'Value', new = indicatorName[iD])
    
    # join data
    data <- left_join(data,dataI, by = c('Economy','Year') )
  }
  
  data[, (indicatorName) := lapply(.SD, fillLocfNocb), by = Economy, .SDcols = indicatorName]
  
  # return output
  data
}




