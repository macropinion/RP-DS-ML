

# ================================================================
# # Help function: first LOCF (search backward, Last Observation Carried Forward), then NOCB (search forward, Next Observation Carried Backward)
# ================================================================
# By  predefined country aggregates (using parallel computing)


fillLocfNocb <- function(data) {
  
  # backward
  data <- nafill(data, type = "locf")  
  # forward
  data <- nafill(data, type = "nocb") 
  
  # return output
  data
}