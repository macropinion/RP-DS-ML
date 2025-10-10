# ================================================================
# plot indicator by Config parameters
# ================================================================

plotIndicator <- function(Config, data, indicator, plot = "interactive") {
  
  # Parameters
  countries <- Config$Input$Indicator$countries
  years     <- Config$Input$Indicator$years
  
  # get data
  dataplot <- data[Economy %in% countries & Year %in% years,.(Economy, Year, Value = get(indicator))]
  dataplot[, Economy := factor(Economy, levels = countries)]
  
  title_txt <- sprintf("%s (%d–%d)", indicator, min(years), max(years))
  
  if (plot == "interactive") {
    plotly::plot_ly(dataplot,
                    x = ~Year, y = ~Value, color = ~Economy,
                    type = "scatter", mode = "lines+markers") %>%
      plotly::layout(
        title  = title_txt,
        xaxis  = list(title = "Year"),
        yaxis  = list(title = indicator),   # <-- raw indicator
        legend = list(orientation = "h",
                      x = 0.5, xanchor = "center",
                      y = -0.15, yanchor = "top"),
        margin = list(b = 90)
      )
  } else {
    ggplot2::ggplot(dataplot, ggplot2::aes(Year, Value, color = Economy)) +
      ggplot2::geom_line(size = 1) +
      ggplot2::geom_point(size = 2) +
      ggplot2::scale_x_continuous(breaks = years) +
      ggplot2::scale_y_continuous(
        labels = scales::label_number(scale_cut = scales::cut_short_scale())
        # optional: accuracy einstellen, z.B. accuracy = 0.1
        # labels = scales::label_number(accuracy = 0.1, scale_cut = scales::cut_short_scale())
      ) +
      ggplot2::labs(
        title = title_txt,
        x = "Year",
        y = indicator,
        color = "Country/Group"
      ) +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
                     legend.position = "bottom")
  }
}
