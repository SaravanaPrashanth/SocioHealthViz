# R/data_processing/nlt_processing.R
source("R/dependencies.R")

# Pre-processing single sheet of NLT
process_sheet <- function(sheet_name, workbook) {
  # Read the specific sheet and skip the first 4 rows
  raw_data <- read_excel(workbook, sheet = sheet_name, skip = 5)
  
  # Process males data
  males_data <- raw_data %>%
    select(1:6) %>%
    set_names(c("age", "mx", "qx", "lx", "dx", "ex")) %>%
    na.omit() %>%
    mutate(
      sex = "Male",
      year = sheet_name
    )
  
  # Process females data
  females_data <- raw_data %>%
    select(8:13) %>%
    set_names(c("age", "mx", "qx", "lx", "dx", "ex")) %>%
    na.omit() %>%
    mutate(
      sex = "Female",
      year = sheet_name
    )
  
  # Combine males and females data
  combined_data <- bind_rows(males_data, females_data)
  
  # Split 'year' into 'year_start' and 'year_end'
  combined_data <- combined_data %>%
    separate(year, into = c("year_start", "year_end"), sep = "-", convert = TRUE, remove = FALSE)
  
  return(combined_data)
}

# Pre-processing entire workbook of NLT
process_workbook <- function(file_path) {
  sheets <- excel_sheets(file_path)
  selected_sheets <- sheets[5:length(sheets)]
  all_data <- map_df(selected_sheets, ~process_sheet(.x, file_path))
  
  list(
    data = all_data,
    life_expectancy_plot = create_life_expectancy_plot(all_data),
    mortality_plot = create_mortality_plot(all_data)
  )
}

# Create basic plots
create_life_expectancy_plot <- function(data) {
  ggplot(data, aes(x = age, y = ex, color = sex, linetype = year)) +
    geom_line() +
    labs(title = "Life Expectancy by Age, Sex, and Year",
         x = "Age", y = "Life Expectancy (years)",
         color = "Sex", linetype = "Year") +
    theme_minimal()
}

create_mortality_plot <- function(data) {
  ggplot(data, aes(x = age, y = mx, color = sex, linetype = year)) +
    geom_line() +
    labs(title = "Mortality Rates by Age, Sex, and Year",
         x = "Age", y = "Mortality Rate",
         color = "Sex", linetype = "Year") +
    scale_y_log10() +
    theme_minimal()
}
