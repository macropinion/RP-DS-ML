
# ================================================================
# Read UNCTAD Data via openxlsx
# ================================================================
#  - Read sheets with openxlsx::read.xlsx
#  - long tables: Economy, Year, Value

loadData <- function(Config){
  
  # get Parameters
  inputFile <- Config$Input$inputFile
  unit <- Config$Input$unit
  
  # read data
  DataRaw <- list()
  DataRaw$InwardFlow <- openxlsx::read.xlsx(inputFile, sheet = 'Inward_Flow')
  DataRaw$OutwardFlow <- openxlsx::read.xlsx(inputFile, sheet = 'Outward_Flow')
  DataRaw$InwardStock <- openxlsx::read.xlsx(inputFile, sheet = 'Inward_Stock')
  DataRaw$OutwardStock <- openxlsx::read.xlsx(inputFile, sheet = 'Outward_Stock')
  DataRaw$Gdp <- openxlsx::read.xlsx(inputFile, sheet = 'GDP')
  
  # Prepare data
  numData <- length(DataRaw)
  for (iD in 1:numData){
    # convert to data.table
    data <- setDT(DataRaw[[iD]])
    data <- data %>% .[,1:3] %>% setnames(c('Economy','Year','Value')) %>%  .[, `:=`(Year  = as.numeric(Year),Value = as.numeric(Value) / unit)]
    # store in DataPool
    DataRaw[[iD]] <- data
  }
  
  # return output
  DataRaw
}




