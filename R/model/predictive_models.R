# R/models/predictive_models.R
source("R/dependencies.R")

prepare_model_data <- function(final_data, sample_size = 1000) {
  # Prepare and clean data
  clean_data <- final_data %>%
    select(ex, mx, SII, Decile, region, Sex) %>%
    drop_na() %>%
    mutate(Decile = as.numeric(Decile))
  
  # Sample data
  set.seed(123)
  sampled_data <- clean_data %>% sample_n(sample_size)
  
  # Split data
  trainIndex <- createDataPartition(sampled_data$ex, p = 0.8, list = FALSE)
  list(
    train = sampled_data[trainIndex, ],
    test = sampled_data[-trainIndex, ]
  )
}

train_random_forest <- function(train_data, k = 5) {
  set.seed(123)
  
  # Create folds for cross-validation
  folds <- createFolds(train_data$ex, k = k, list = TRUE, returnTrain = TRUE)
  
  # Initialize metrics storage
  cv_metrics <- list(
    mse = numeric(k),
    r2 = numeric(k)
  )
  
  # Perform cross-validation
  for(i in 1:k) {
    train_fold <- train_data[folds[[i]], ]
    valid_fold <- train_data[-folds[[i]], ]
    
    rf_fold <- randomForest(
      ex ~ mx + SII + Decile,
      data = train_fold,
      ntree = 500,
      mtry = 2,
      importance = TRUE
    )
    
    pred_fold <- predict(rf_fold, valid_fold)
    cv_metrics$mse[i] <- mean((pred_fold - valid_fold$ex)^2)
    cv_metrics$r2[i] <- cor(pred_fold, valid_fold$ex)^2
  }
  
  # Train final model
  final_model <- randomForest(
    ex ~ mx + SII + Decile,
    data = train_data,
    ntree = 500,
    mtry = 2,
    importance = TRUE
  )
  
  list(
    model = final_model,
    cv_metrics = cv_metrics,
    mean_mse = mean(cv_metrics$mse),
    mean_r2 = mean(cv_metrics$r2)
  )
}

train_linear_regression <- function(train_data) {
  model <- lm(ex ~ mx + SII + Decile, data = train_data)
  list(
    model = model,
    summary = summary(model)
  )
}

evaluate_models <- function(rf_model, lr_model, test_data) {
  # Get predictions
  rf_pred <- predict(rf_model$model, test_data)
  lr_pred <- predict(lr_model$model, test_data)
  
  # Calculate metrics
  metrics <- data.frame(
    Model = c("Random Forest", "Linear Regression"),
    MSE = c(
      mean((rf_pred - test_data$ex)^2),
      mean((lr_pred - test_data$ex)^2)
    ),
    R2 = c(
      cor(rf_pred, test_data$ex)^2,
      cor(lr_pred, test_data$ex)^2
    )
  )
  
  # Plot comparison
  plot_comparison <- function(metrics) {
    metrics_long <- melt(metrics, id.vars = "Model")
    ggplot(metrics_long, aes(x = Model, y = value, fill = variable)) +
      geom_bar(stat = "identity", position = "dodge") +
      scale_fill_manual(
        values = c("MSE" = "darkorange", "R2" = "darkblue"),
        labels = c("Mean Squared Error (MSE)", "R-Squared (R²)")
      ) +
      labs(
        title = "Model Performance Comparison",
        x = "Model",
        y = "Metric Value",
        fill = "Metric"
      ) +
      theme_minimal()
  }
  
  list(
    metrics = metrics,
    comparison_plot = plot_comparison(metrics)
  )
}
