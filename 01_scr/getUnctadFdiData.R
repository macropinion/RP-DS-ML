# getUnctadFdiData()
# Downloads UNCTADstat FDI Data
#
# Iput:
# - years e.g: 2000:2024
# - economies: c('Austria','Germany','Asia'), NULL: All Countries
# - clientId: from UNCAD website
# - clientSecret: from UNCAD website
# - direction: 1:inward, 1:outward
# - flowStock: "08": Flow, "09": Stock
# Output:
# - data.table with the selected inputs

# ------------------------------------------------------------------------------
getUnctadFdiData <- function(years = 2000:2024,economies = NULL,clientId,clientSecret,direction=1,flowStock='08') {
  
  # temp csv gz file 
  tmpFile = tempfile(fileext = ".csv.gz")
  
  # build filter String
  filterString <- sprintf("Year in (%s)", paste(years, collapse = ","))
  
  # Economy if not all (NULL)
  if (!is.null(economies) && length(economies) > 0) {
    filterString <- paste(filterString, paste0("Economy/Code in ('%s')", paste(unique(as.character(economies)), collapse = "','")), sep = ' and ')
  }
  
  # direction
  filterString <- paste(filterString, sprintf("Direction/Code in (%s)", direction), sep = ' and ')
  
  # flowStock
  filterString <- paste(filterString, sprintf("Flow/Code in ('%s')", paste(flowStock, collapse = "','")), sep = ' and ')
  
  # select String (default)
  selectString  <- "Economy/Label ,Year ,US_at_current_prices_in_millions_Value ,US_at_current_prices_Footnote ,US_at_current_prices_MissingValue"
  
  # compute String (default)
  computeString <- "round(M0100/Value div 1000000, 0) as US_at_current_prices_in_millions_Value, M0100/Footnote/Text as US_at_current_prices_Footnote, M0100/MissingValue/Label as US_at_current_prices_MissingValue"
  
  # url String (default)
  urlString <- "https://unctadstat-user-api.unctad.org/US.FdiFlowsStock/cur/Facts?culture=en"
  
  # save results to gz-csv
  handleString <- curl::new_handle() |> 
    curl::handle_setform("$select"  = selectString,"$filter"  = filterString,"$orderby" = "Economy/Order asc ,Year asc","$compute" = computeString,"$format"  = "csv","compress" = "gz") |> 
    curl::handle_setheaders("ClientId" = clientId,"ClientSecret" = clientSecret)
  
  curl::curl_download(urlString, tmpFile, handle = handleString)
  
  # Read back into R
  data <- utils::read.csv(gzfile(tmpFile),header=TRUE,na.strings = "",encoding   = "UTF-8",colClasses = c("character","integer","double","character","character"))
  
}
