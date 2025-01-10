# main.R
# Source all necessary files
source("R/dependencies.R")
source("R/data_processing/nlt_processing.R")
source("R/data_processing/sii_processing.R")
source("R/visualization/life_expectancy_plots.R")
source("R/models/predictive_models.R")

# Process NLT data
england_data <- process_workbook("data/nlte198020213.xlsx")
wales_data <- process_workbook("data/nltw198020213.xlsx")

# Process SII data
process_workbook_SII("data/englandreferencetable2020.xlsx")
process_workbook_SII("data/walesreferencetable2020.xlsx")

# Create and save visualizations
plots <- list(
  create_historical_trends_plot(combined_df),
  create_mortality_rates_plot(combined_df),
  create_sii_heatmap(sii_trends)
)
save_all_plots(plots)

# Train and evaluate models
model_data <- prepare_model_data(final_data)
rf_results <- train_random_forest(model_data$train)
lr_results <- train_linear_regression(model_data$train)
model_evaluation <- evaluate_models(rf_results, lr_results, model_data$test)

# Save results
saveRDS(rf_results, "outputs/models/rf_model.rds")
saveRDS(lr_results, "outputs/models/lr_model.rds")
saveRDS(model_evaluation, "outputs/models/model_evaluation.rds")
