# Load packages
require(openxlsx)
require(pacman)
require(data.table)

# Load data
fileData <- "02_data/Unctad.xlsx"

dataInwardFlow <- read.xlsx(fileData, sheet = 'Inward_Flow')
dataGDP <- read.xlsx(fileData, sheet = 'GDP')

#data table
dataInwardFlow <- setDT(dataInwardFlow)
dataGDP <- setDT(dataGDP)

## =========================
## UNCTAD: Aggregates Script
## =========================

library(data.table)

## You already have:
## dataGDP <- read.xlsx(fileData, sheet = 'GDP')
## dataInwardFlow <- read.xlsx(fileData, sheet = 'Inward_Flow')
## dataGDP <- setDT(dataGDP); dataInwardFlow <- setDT(dataInwardFlow)

# 1) Prep helper: keep first 3 columns, rename, coerce numeric
prep_dt <- function(dt){
  dt <- copy(dt)[, 1:3]                          # first 3 columns only
  setnames(dt, c("Country","Year","Indicator"))  # rename to standard
  dt[, Year := as.integer(Year)]
  # remove thousands separators and coerce numeric
  dt[, Indicator := as.numeric(gsub(",", "", Indicator))]
  setcolorder(dt, c("Year","Country","Indicator"))
  dt
}

gdp         <- prep_dt(dataGDP)
inward_flow <- prep_dt(dataInwardFlow)

# 2) Country name harmonization
name_map <- c(
  "Federal Republic of Germany"        = "Germany",
  "Union of Soviet Socialist Republics"= "Russia",   # or drop; see drop_labels
  "Tanganyika"                         = "Tanzania",
  "Zanzibar and Pemba Island"          = "Tanzania",
  "French Guiana"                      = "France",
  "Reunion"                            = "France",
  "Mayotte"                            = "France"
)

# Non-countries / micro-states / aggregates to drop (adjust as needed)
drop_labels <- c(
  "Pacific Islands",
  "Andorra","Liechtenstein","Monaco","San Marino","Nauru","Greenland","Puerto Rico","Kosovo",
  # If you mapped French territories to France above and they also appear separately,
  # keep them here to avoid double-counting:
  "French Guiana","Reunion","Mayotte"
)

harmonize_names <- function(dt){
  dt <- copy(dt)
  dt[, Country := trimws(Country)]
  dt[Country %in% names(name_map), Country := name_map[Country]]
  dt <- dt[!Country %in% drop_labels]
  dt <- dt[!is.na(Country) & Country != ""]
  dt
}

gdp_clean         <- harmonize_names(gdp)
inward_flow_clean <- harmonize_names(inward_flow)

# 3) Define your two groups (edit to your needs)
group_A <- c("Austria","Germany","France","Italy")            # e.g., Core EU-4
group_B <- c("Poland","Czech Republic","Hungary","Slovakia")  # e.g., Visegrád

# 4) Aggregate function
make_aggregate <- function(dt, countries, agg_name){
  out <- dt[Country %in% countries,
            .(Indicator = sum(Indicator, na.rm = TRUE)),
            by = Year]
  out[, Country := agg_name]
  setcolorder(out, c("Year","Country","Indicator"))
  out
}

# 5) Build the aggregates for both indicators
aggA_gdp  <- make_aggregate(gdp_clean,         group_A, "Group_A")
aggB_gdp  <- make_aggregate(gdp_clean,         group_B, "Group_B")
aggA_if   <- make_aggregate(inward_flow_clean, group_A, "Group_A")
aggB_if   <- make_aggregate(inward_flow_clean, group_B, "Group_B")

# Two new data.tables (per the exercise)
agg_GDP        <- rbindlist(list(aggA_gdp, aggB_gdp))
agg_InwardFlow <- rbindlist(list(aggA_if,  aggB_if))

setnames(agg_GDP,        "Indicator", "GDP")
setnames(agg_InwardFlow, "Indicator", "Inward_Flow")

# 6) Combine into one table with Date, Country, Indicator1, Indicator2
combined <- merge(agg_GDP, agg_InwardFlow, by = c("Year","Country"), all = TRUE)
setnames(combined, c("Year","Country","GDP","Inward_Flow"),
                    c("Date","Country","Indicator1","Indicator2"))

# 7) Optional: NA-free overlap panel (years where both indicators exist)
yrs_overlap <- intersect(
  combined[!is.na(Indicator1), unique(Date)],
  combined[!is.na(Indicator2), unique(Date)]
)
combined_overlap <- combined[Date %in% yrs_overlap][order(Country, Date)]

# 8) Quick sanity peeks
combined[order(Country, Date)][1:10]
combined_overlap[order(Country, Date)][1:10]
summary(combined[, .(Indicator1, Indicator2)])
summary(combined_overlap[, .(Indicator1, Indicator2)])

# 9) (Optional) Save results
# fwrite(agg_GDP,        "02_data/agg_GDP.csv")
# fwrite(agg_InwardFlow, "02_data/agg_InwardFlow.csv")
# fwrite(combined,       "02_data/combined_fullspan.csv")
# fwrite(combined_overlap,"02_data/combined_overlap.csv")

