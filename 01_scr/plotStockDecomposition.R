# ================================================================
# plot StockChange
# ================================================================

plotStockChange <- function(data, country = 'Austria',indicator = 'Inward',years = 2007:2023,plot = "interactive") {
  
  # get Flow and Stock Colum names
  flowCol  <- paste0(indicator, "Flow")
  stockCol <- paste0(indicator, "Stock")
 
  # get data
  dataplot <- data[Economy == country & Year %in% years]
  
  # Calculations
  dataplot[, Flow        := get(flowCol)]
  dataplot[, Stock       := get(stockCol)]
  dataplot[, StockChange := Stock - shift(Stock)]
  dataplot[, OtherChange := StockChange - Flow]
  
  # use long format
  bars <- melt(
    dataplot[!is.na(StockChange)],
    id.vars = c("Year"),
    measure.vars = c("Flow","OtherChange"),
    variable.name = "Component",
    value.name = "Value"
  )
  
  title_txt <- paste0(country, " — ", indicator, " decomposition (StockChange = Flow + OtherChange)")
  
  if (plot == "interactive") {
    plot_ly(bars, x = ~Year, y = ~Value, color = ~Component,
            type = "bar") %>%
      add_trace(data = dataplot[!is.na(StockChange)],
                x = ~Year, y = ~StockChange,
                type = "scatter", mode = "lines+markers",
                name = "StockChange", inherit = FALSE) %>%
      layout(
        title  = title_txt,
        barmode = "stack",
        xaxis  = list(title = "Year"),
        yaxis  = list(title = paste0(indicator, " (flow/stock change)")),
        legend = list(orientation = "h", x = 0.5, xanchor = "center",
                      y = -0.15, yanchor = "top"),
        margin = list(b = 90),
        shapes = list(list(type = "line", xref = "paper", x0 = 0, x1 = 1,
                           yref = "y", y0 = 0, y1 = 0, line = list(width = 1)))
      )
  } else {
    ggplot() +
      geom_col(data = bars, aes(x = Year, y = Value, fill = Component)) +
      geom_hline(yintercept = 0, linewidth = 0.3) +
      geom_line(data = dataplot[!is.na(StockChange)],
                aes(x = Year, y = StockChange), linewidth = 0.8) +
      geom_point(data = dataplot[!is.na(StockChange)],
                 aes(x = Year, y = StockChange), size = 2) +
      scale_x_continuous(breaks = sort(unique(dataplot$Year))) +
      labs(title = title_txt,
           x = "Year",
           y = paste0(indicator, " (flow/stock change)"),
           fill = "Component") +
      theme_minimal(base_size = 12) +
      theme(panel.grid.minor = element_blank(),
            legend.position = "bottom")
  }
}
