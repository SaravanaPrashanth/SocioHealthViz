# R/visualization/deprivation_plots.R
source("R/dependencies.R")

create_deprivation_plot <- function(mortality_disparities) {
  # Basic line plot
  basic_plot <- ggplot(mortality_disparities, 
                       aes(x = factor(Decile), y = mean_rate, group = region, color = region)) +
    geom_line(size = 1) +
    geom_point(size = 2) +
    labs(
      title = "Mortality Rates by Deprivation Decile (2011–2020)",
      x = "Deprivation Decile",
      y = "Mean Mortality Rate",
      color = "Region"
    ) +
    theme_minimal()
  
  # Diverging bar chart
  bar_chart <- ggplot(mortality_disparities, 
                      aes(x = reorder(factor(Decile), mean_rate), y = mean_rate, fill = region)) +
    geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
    geom_text(aes(label = round(mean_rate, 1)), 
              position = position_dodge(0.9), vjust = -0.5, size = 3) +
    labs(
      title = "Disparities in Avoidable Mortality Rates by Decile (2011–2020)",
      x = "Deprivation Decile (Lower is More Deprived)",
      y = "Mean Mortality Rate",
      fill = "Region"
    ) +
    scale_fill_manual(values = c("#CD534C", "#868686")) +
    theme_minimal() +
    theme(
      text = element_text(family = "sans", face = "bold"),
      legend.position = "top"
    )
  
  list(basic_plot = basic_plot, bar_chart = bar_chart)
}

create_composite_visualization <- function(plots) {
  grid.arrange(
    plots$historical_trends,
    plots$mortality_rates,
    plots$deprivation_bar,
    plots$sii_heatmap,
    ncol = 2
  )
}
