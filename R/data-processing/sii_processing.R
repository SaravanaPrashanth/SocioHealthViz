# R/data_processing/sii_processing.R
source("R/dependencies.R")

# Pre-processing single sheet of SII
process_sheet_SII <- function(sheet_name, workbook, skip_rows, unreliable_col = FALSE) {
  raw_data <- read_excel(workbook, sheet = sheet_name, skip = skip_rows)
  colnames(raw_data) <- raw_data[1, ]
  raw_data <- raw_data[-1, ]
  
  if ("Sex" %in% colnames(raw_data)) {
    raw_data <- raw_data %>%
      mutate(Sex = case_when(
        Sex == "Males" ~ "Male",
        Sex == "Females" ~ "Female",
        TRUE ~ Sex
      ))
  }
  
  if (unreliable_col && "Unreliable rate" %in% colnames(raw_data)) {
    raw_data <- raw_data %>%
      mutate(`Unreliable rate` = str_replace_all(`Unreliable rate`, "\\[u\\]", "Unreliable")) %>%
      filter(!`Unreliable rate` %in% c("Unreliable", "unreliable"))
  }
  
  return(raw_data)
}

# Process workbook for SII data
process_workbook_SII <- function(file_path) {
  file_prefix <- substr(basename(file_path), 1, 3)
  
  sheets_to_process <- if(file_prefix == "eng") {
    list(
      list(name = "Table_1", skip_rows = 2, unreliable_col = FALSE),
      list(name = "Table_2", skip_rows = 2, unreliable_col = FALSE),
      list(name = "Table_3", skip_rows = 2, unreliable_col = FALSE),
      list(name = "Table_4", skip_rows = 2, unreliable_col = FALSE)
    )
  } else {
    list(
      list(name = "Table_1", skip_rows = 2, unreliable_col = FALSE),
      list(name = "Table_2", skip_rows = 4, unreliable_col = TRUE),
      list(name = "Table_3", skip_rows = 2, unreliable_col = FALSE),
      list(name = "Table_4", skip_rows = 2, unreliable_col = FALSE)
    )
  }
  
  for (sheet in sheets_to_process) {
    processed_data <- process_sheet_SII(
      sheet_name = sheet$name,
      workbook = file_path,
      skip_rows = sheet$skip_rows,
      unreliable_col = sheet$unreliable_col
    )
    csv_file_name <- paste0("data/processed/", sheet$name, "_cleaned_", file_prefix, ".csv")
    write.csv(processed_data, csv_file_name, row.names = FALSE)
  }
}
