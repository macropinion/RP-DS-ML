# ================================================================
# Slide: runMain – Orchestrate Modules
# ================================================================
# Goals:
#  - Source modules in order
#  - Provide a single entry point to run everything

# Run this file from the project root.
# You can comment/uncomment modules to run a subset.



# Clear environment
rm(list = ls())

# Config
#-----------------------------------------------------------------------------------
Config <- list()
Config$Path$mainPath <- "~/RP-DS-ML"

# set config parameter 
source(paste(Config$Path$mainPath,'/01_scr/setConfig.R',sep = ""))
Config <- setConfig(Config)

# load Data
#-----------------------------------------------------------------------------------
DataRaw <- loadData(Config)

# Data processing
#-----------------------------------------------------------------------------------

# fill missing entries
DataPool <- fillMissing(DataRaw)

# fill outlier entries
DataPool <- fillOutlier(DataPool)

# Data aggregation
DataPool <- aggregateCountry(Config,DataPool)

# Join data
data <- joinData(DataPool)

# Calculations and plottings
#-----------------------------------------------------------------------------------

# Indicator
plotIndicator(Config,data,'OutwardFlow',plot = 'interactive')
plotIndicator(Config,data,'OutwardFlow',plot = 'notinteractive')

# FdiPerGdp
plotFdiPerGdp(Config,data,'OutwardFlow',plot = 'static')
plotFdiPerGdp(Config,data,'InwardStock',plot = 'interactive')

plotStockChange(data,'World','Inward',2007:2023,"static") 
plotStockChange(data,'Germany','Inward',2007:2023,"static") 
