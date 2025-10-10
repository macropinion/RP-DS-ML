
# ================================================================
# Fill missing entries
# ================================================================
# Middle/end: carry over last observation (LOCF)
# Beginning: fill remaining leading NAs with next observation (NOCB)

fillMissing2 <- function(DataRaw){
  
  # Create DataPool
  DataPool <- DataRaw
  
  # Fill missing Values
  numData <- length(DataRaw)
  for (iD in 1:numData){
    # get data.table
    data <- DataPool[[iD]]
    
    # delete NA Years
    data <- data %>% filter(!is.na(Year))
    
    # make sure data is sorted
    setorder(data, Economy, Year)
    
    # remove countries where Value is NA for all years (using for, if, else)
    # ...
    
    # Fill missing values per country (using for, if, else):
    # 1) LOCF: fill internal/trailing NAs with the previous known value (search backward)
    # 2) NOCB: fill remaining leading NAs with the next known value (search forward)
    # ...
    
    # store in DataPool
    DataPool[[iD]] <- data
  }
  
  # return output
  DataPool
}




