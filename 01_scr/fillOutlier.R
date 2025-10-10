
# ================================================================
# Fill outlier entries
# ================================================================
# Outlier: hampel score
# Middle/end: carry over last observation (LOCF)
# Beginning: fill remaining leading NAs with next observation (NOCB)

fillOutlier <- function(DataPool){
  
  # Fill outlier Values
  numData <- length(DataRaw)
  for (iD in 1:numData){
    # get data.table
    data <- DataPool[[iD]]
    
    # Detect outliers per country (rolling Hampel)
    data[, outlier := hampelOutlier(Value), by = Economy]
    
    # Replace outliers with NA (to be filled like missing values)
    data[, c("Value","outlier") := .(fifelse(fcoalesce(outlier, FALSE), NA_real_, Value),NULL)]
    
    # Fill missing values per country:
    # 1) LOCF: fill internal/trailing NAs with the previous known value (search backward)
    # 2) NOCB: fill remaining leading NAs with the next known value (search forward)
    data[, Value := {
      v <- as.numeric(Value)
      v <- nafill(v, type = "locf")  # carry last observation forward
      nafill(v, type = "nocb")       # carry next observation backward for leading NAs
    }, by = Economy]
    
    # store in DataPool
    DataPool[[iD]] <- data
  }
  
  # return output
  DataPool
}




