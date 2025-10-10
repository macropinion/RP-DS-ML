# --- Helper: per-vector Hampel outlier flags (centered rolling window) ---
hampelOutlier <- function(x, k = 3, tau = 3, c = 1.4826) {
  w   <- 2 * k + 1
  
  # calc med and mad
  med <- zoo::rollapply(x, width = w, align = "center", partial = TRUE,
                        fill = NA_real_, FUN = function(v) median(v, na.rm = TRUE))
  mad <- zoo::rollapply(x, width = w, align = "center", partial = TRUE,
                        fill = NA_real_, FUN = function(v) {
                          m <- median(v, na.rm = TRUE)
                          median(abs(v - m), na.rm = TRUE)
                        })
  # calc Outlier parameters
  sigma <- c * mad
  z     <- (x - med) / sigma
  flag  <- !is.na(z) & is.finite(z) & abs(z) > tau
  
  # Outlier test
  flag[is.na(sigma) | sigma == 0] <- FALSE
  flag
}
