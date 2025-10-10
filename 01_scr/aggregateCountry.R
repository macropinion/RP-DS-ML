
# ================================================================
# bulid country groups
# ================================================================
# By  predefined country aggregates

aggregateCountry <- function(Config,DataPool){
  
  # get Inputs
  countyGroupName <- names(Config$Input$CountryGroup)
  countyGroupList <- Config$Input$CountryGroup
  
  # calculate aggregates and store in DataPool
  numData <- length(DataPool)
  numCountryGroup <- length(countyGroupName)
  for (iD in 1:numData){
    # get data.table
    data <- DataPool[[iD]]
    
    # calc aggregate for each country group
    for (iG in 1:numCountryGroup){
      groupData <- data[Economy %chin% countyGroupList[[iG]], .(Value = sum(Value)), by = Year][, Economy := countyGroupName[iG]]
      data <- rbind(data,groupData)
    }
    
    # stor new data in DataPool
    DataPool[[iD]] <- data
  }
  
  # return output
  DataPool
}




