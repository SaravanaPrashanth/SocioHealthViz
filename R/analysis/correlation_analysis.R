# R/analysis/correlation_analysis.R
source("R/dependencies.R")

perform_correlation_analysis <- function(train_data) {
  # Select relevant columns for correlation matrix
  correlation_data <- train_data[, c("ex", "mx", "SII", "Decile")]
  
  # Compute correlation matrix
  cor_matrix <- cor(correlation_data, use = "complete.obs")
  
  # Create correlation plot
  correlation_plot <- corrplot(cor_matrix, 
                               method = "color", 
                               addCoef.col = "black", 
                               number.cex = 0.8,
                               tl.col = "black", 
                               tl.srt = 45, 
                               title = "Correlation Matrix", 
                               mar = c(0, 0, 2, 0))
  
  list(
    correlation_matrix = cor_matrix,
    correlation_plot = correlation_plot
  )
}

analyze_mortality_relationships <- function(filtered_data) {
  # Create scatter plot with regression lines
  mortality_relationship_plot <- ggplot(filtered_data, 
                                        aes(x = mx, y = Rate, color = Cause, shape = Sex)) +
    geom_point(size = 3, alpha = 0.7) +
    facet_wrap(~age + region, scales = "free", ncol = 2) +
    geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
    labs(
      title = "Mortality Rates (mx) vs Avoidable and Treatable Mortality Rates",
      subtitle = "Across Age Groups (0 and 65), Sex, and Regions (2000–2020)",
      x = "Mortality Rate (mx)",
      y = "Avoidable/Treatable Mortality Rate",
      color = "Mortality Type",
      shape = "Sex"
    ) +
    theme_minimal() +
    theme(
      text = element_text(size = 12),
      legend.position = "bottom"
    )
  
  # Calculate correlations
  correlation_by_group <- filtered_data %>%
    group_by(age, region, Sex) %>%
    summarise(
      correlation = cor(mx, Rate, use = "complete.obs"),
      .groups = 'drop'
    )
  
  list(
    plot = mortality_relationship_plot,
    correlations = correlation_by_group
  )
}
