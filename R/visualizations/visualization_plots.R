# R/visualization/life_expectancy_plots.R
source("R/dependencies.R")

create_historical_trends_plot <- function(combined_df) {
  # Filter past decade
  past_decade <- combined_df %>%
    filter(year_start >= 2005)
  
  # Calculate life expectancy trends
  life_expectancy_trends <- past_decade %>%
    group_by(region, sex, year_start) %>%
    summarise(mean_life_expectancy = mean(ex, na.rm = TRUE)) %>%
    ungroup()
  
  # Create visualization
  ggplot(life_expectancy_trends, 
         aes(x = year_start, y = mean_life_expectancy, color = interaction(region, sex))) +
    geom_line(size = 1.5) +
    geom_point(size = 2, shape = 21, fill = "white") +
    scale_color_manual(values = c("#E69F00", "#56B4E9", "#009E73", "#F0E442")) +
    labs(
      title = "Life Expectancy Trends by Region and Sex (2005–2023)",
      x = "Year",
      y = "Mean Life Expectancy",
      color = "Region and Sex"
    ) +
    theme_minimal() +
    theme(
      text = element_text(family = "sans", face = "bold"),
      legend.position = "bottom",
      panel.grid.major = element_line(color = "gray90"),
      panel.grid.minor = element_blank()
    )
}

create_mortality_rates_plot <- function(combined_df) {
  # Filter data for specific ages and mortality rates
  mortality_rate <- combined_df %>%
    filter(age %in% c("0", "65") & year_start >= 2000 & year_start <= 2020)
  
  # Create visualization
  ggplot(mortality_rate, aes(x = age, y = mx, fill = sex)) +
    geom_boxplot() +
    facet_wrap(~region) +
    labs(
      title = "Mortality Rates by Age and Sex (2000–2020)",
      x = "Age Group",
      y = "Mortality Rate (mx)",
      fill = "Sex"
    ) +
    theme_minimal() + 
    theme(
      text = element_text(family = "sans", face = "bold"),
      legend.position = "bottom"
    )
}

create_sii_heatmap <- function(sii_trends) {
  ggplot(sii_trends, aes(x = Year, y = Sex, fill = mean_sii)) +
    geom_tile() +
    facet_wrap(~region) +
    scale_fill_viridis_c() +
    labs(
      title = "Slope Index of Inequality (SII) Trends (2005–2020)",
      x = "Year",
      y = "Sex",
      fill = "Mean SII"
    ) +
    theme_minimal() + 
    theme(
      text = element_text(family = "sans", face = "bold"),
      legend.position = "bottom"
    )
}

# Function to save all plots
save_all_plots <- function(plots, output_path = "outputs/charts") {
  dir.create(output_path, recursive = TRUE, showWarnings = FALSE)
  pdf(file.path(output_path, "charts_all.pdf"), width = 8, height = 6)
  for (plot in plots) {
    print(plot)
  }
  dev.off()
}
