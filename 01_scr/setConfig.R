# ================================================================
# Setup & Packages
# ================================================================
# Goals:
#  - Load and (if needed) install required packages with pacman::p_load
#  - Set global options and project paths

setConfig <- function(Config){
  
  #Global options
  options(stringsAsFactors = FALSE, scipen = 999)
  
  # ---- Package management ----
  if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
  pacman::p_load(openxlsx, data.table, dplyr, tidyr, stringr, janitor, purrr, lubridate,ggplot2, plotly, imputeTS, zoo, scales, readr,foreach,doParallel)
  
  #Project paths
  mainPath <- Config$Path$mainPath
  Config$Path$scrPath <- scrPath <- paste0(mainPath, "/01 scr/")
  Config$Path$dataPath   <- paste0(mainPath, "/02 data/")
  Config$Path$outPath    <- paste0(mainPath, "/03 outputs/")
  
  #Input Parameters
  Config$Input$inputFile <- paste0(Config$Path$dataPath,"Unctad.xlsx")
  Config$Input$unit <- 1000 # millions
  
  #Source Functions
  if(!exists("foo", mode="function")) {
    source(paste0(scrPath,"loadData.R"))
    source(paste0(scrPath,"fillMissing.R"))
    source(paste0(scrPath,"fillMissing2.R"))
    source(paste0(scrPath,"hampelOutlier.R"))
    source(paste0(scrPath,"fillOutlier.R"))
    source(paste0(scrPath,"aggregateCountry.R"))
    source(paste0(scrPath,"joinData.R"))
    source(paste0(scrPath,"fillLocfNocb.R"))
    source(paste0(scrPath,"plotIndicator.R"))
    source(paste0(scrPath,"plotFdiPerGdp.R"))
    source(paste0(scrPath,"plotStockChange.R"))
  }
  
  # Country groups (names as UNCTAD 'Economy' values)
  
  # EU-15 (pre-2004 members; includes UK by definition)
  eu15 <- c(
    "Austria","Belgium","Denmark","Finland","France","Germany","Greece",
    "Ireland","Italy","Luxembourg","Netherlands","Portugal","Spain","Sweden",
    "United Kingdom","UK" # include common alias just in case
  )
  
  # CESEE — split into useful buckets you can mix & match
  # EU member states in CEE
  cesee_eu <- c(
    "Bulgaria","Croatia","Czechia","Czech Republic",  # include both variants
    "Estonia","Hungary","Latvia","Lithuania","Poland","Romania",
    "Slovakia","Slovak Republic","Slovenia"
  )
  
  # Western Balkans
  wb <- c(
    "Albania",
    "Bosnia and Herzegovina","Bosnia & Herzegovina",
    "Kosovo","Kosovo (UNSCR 1244/99)",
    "Montenegro",
    "North Macedonia","TFYR Macedonia"  # old naming included for robustness
  )
  
  # CESEE core = EU-CEE + Western Balkans
  cesee_core <- unique(c(cesee_eu, wb))
  
  # CESEE extended (add frequently used non-EU neighbors)
  cesee_extended <- unique(c(
    cesee_core,
    "Belarus",
    "Moldova","Republic of Moldova",
    "Ukraine",
    "Russia","Russian Federation",
    "Turkey","Türkiye"
  ))
  
  # BRICS (classic 5)
  brics <- c("Brazil","Russia","Russian Federation","India","China","South Africa")
  
  # Optional: BRICS+ (2024 expansion; include if you need it)
  brics_plus_2024 <- c(
    "Brazil","Russia","Russian Federation","India","China","South Africa",
    "Egypt","Ethiopia","Iran","United Arab Emirates","UAE","Saudi Arabia"
  )
  
  # Attach to your Config
  Config$Input$CountryGroup <- list(
    EU15            = eu15,
    CESEE_EU        = cesee_eu,
    Western_Balkans = wb,
    CESEE_Core      = cesee_core,
    CESEE_Extended  = cesee_extended,
    BRICS_Plus_2024 = brics_plus_2024
  )
  
  # Parameters for the analyses
  Config$Input$Indicator$countries <- c("EU15","CESEE_Extended","BRICS","United States")
  Config$Input$Indicator$years <- 2007:2023
  
  Config$Input$FdiPerGdp$countries <- c("EU15","CESEE_Extended","BRICS","United States")
  Config$Input$FdiPerGdp$years <- 2007:2023 
  
  #Return Output
  Config
  
}





