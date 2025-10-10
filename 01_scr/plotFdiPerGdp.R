
# ================================================================
# plot fdi/gdp data by Config Parameters
# ================================================================

plotFdiPerGdp <- function(Config,data,indicator,plot = 'interactive'){
  
  # get Parameters
  countries <- Config$Input$Indicator$countries
  years <- Config$Input$Indicator$years
  
  # get data 
  dataplot <- data[Economy %in% countries & Year %in% years,.(Economy, Year, Value = get(indicator))]
  dataplot[, Economy := factor(Economy, levels = countries)]
  
  # plot data
  if (plot == "interactive") {
    plot_ly(dataplot, x = ~Year, y = ~Value, color = ~Economy,
            type = "scatter", mode = "lines+markers") %>%
      layout(
        title = paste0(indicator, " (", min(years), "–", max(years), ")"),
        xaxis = list(title = "Year"),
        yaxis = list(title = indicator),
        legend = list(
          orientation = "h", 
          x = 0.5, xanchor = "center",
          y = -0.15, yanchor = "top" 
        ),
        margin = list(b = 90) 
      )
  } else {
    ggplot(dataplot, aes(Year, Value, color = Economy)) +
      geom_line(size = 1) +
      geom_point(size = 2) +
      scale_x_continuous(breaks = years) +
      scale_y_continuous(labels = label_number()) +
      labs(
        title = paste0(indicator, " (", min(years), "–", max(years), ")"),
        x = "Year",
        y = indicator,
        color = "Country/Group"
      ) +
      theme_minimal(base_size = 12) +
      theme(panel.grid.minor = element_blank(),
            legend.position = "bottom")
    
  }
}




