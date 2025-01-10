# R/analysis/avoidable_mortality_analysis.R
source("R/dependencies.R")

analyze_avoidable_mortality <- function(table_2_eng, table_2_wal, nlt_combined) {
  # Filter data for relevant years and merge with National Life Table data
  filtered_nlt <- nlt_combined %>%
    filter(year_start >= 2000 & year_start <= 2020)
  
  # Combine and process mortality data
  merged_data <- bind_rows(
    table_2_eng %>% mutate(region = "England"),
    table_2_wal %>% mutate(region = "Wales")
  ) %>%
    inner_join(filtered_nlt, 
               by = c("Year" = "year_start", "Sex" = "sex", "region"), 
               relationship = "many-to-many") %>%
    select(region, Sex, age, Measure, mx, Rate)
  
  # Filter and prepare data for analysis
  filtered_data <- merged_data %>%
    filter(age %in% c(0, 65)) %>%
    mutate(
      Cause = factor(Measure, levels = c("Avoidable Mortality", "Treatable Mortality")),
      Sex = factor(Sex, levels = c("Male", "Female"))
    )
  
  # Perform correlation analysis
  correlation_data <- filtered_data %>%
    group_by(age, region) %>%
    summarise(
      correlation = cor(mx, Rate, use = "complete.obs"),
      .groups = 'drop'
    )
  
  # Create visualization
  mortality_plot <- ggplot(filtered_data, 
                           aes(x = mx, y = Rate, color = Cause, shape = Sex)) +
    geom_point(size = 3, alpha = 0.7) +
    facet_wrap(~age + region, scales = "free", ncol = 2) +
    geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
    labs(
      title = "Mortality Rates (mx) vs Avoidable and Treatable Mortality Rates",
      subtitle = "By Age Groups and Regions (2000–2020)",
      x = "Mortality Rate (mx)",
      y = "Avoidable/Treatable Mortality Rate",
      color = "Mortality Type",
      shape = "Sex"
    ) +
    theme_minimal()
  
  list(
    data = filtered_data,
    correlations = correlation_data,
    plot = mortality_plot
  )
}
