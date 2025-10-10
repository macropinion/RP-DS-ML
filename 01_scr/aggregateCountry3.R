
# ================================================================
# bulid country groups
# ================================================================
# By  predefined country aggregates (using parallel computing)

aggregateCountry2 <- function(Config,DataPool,numCores){
  
  # get Inputs
  countyGroupName <- names(Config$Input$CountryGroup)
  countyGroupList <- Config$Input$CountryGroup
  
  # calculate aggregates and store in DataPool 
  numData <- length(DataPool)
  numCountryGroup <- length(countyGroupName)
  for (iD in 1:numData){
    # get data.table
    data <- DataPool[[iD]]
    
    cl <- makeCluster(min(numCores,length(numCountryGroup)))
    registerDoParallel(cl)
    matDataPoolStart <- foreach (iP = 1:numCountryGroup,.export = c(), .packages=c()) %dopar% {
    }
    stopCluster(cl)
  }
  
  # return output
  DataPool
}




