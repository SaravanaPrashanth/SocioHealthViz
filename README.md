# A Comparative Analysis of Life Expectancy Trends in England and Wales

## Overview
This project analyzes life expectancy trends and mortality rates in England and Wales, examining the relationships between deprivation indices, avoidable mortality, and regional variations.

## Project Structure
```
SocioHealthViz/
├── R/
|   ├── analysis/
│   ├── data-processing/
│   ├── model/
│   ├── visualizations/
│   ├── dependencies.R
├── data/
│   ├── processed/
|   ├── raw/
├── outputs/
│   ├── charts/
│   └── model/
├── .gitignore
├──  LICENSE.md
├── README.md
├── index-data science.html
└── main.R
```

## Setup and Installation
1. Install R and RStudio:
   * Visit [RStudio Desktop Download Page](https://posit.co/download/rstudio-desktop/)
   * Follow the installation instructions for your operating system

2. Clone the repository:
```bash
git clone https://github.com/SaravanaPrashanth/SocioHealthViz.git
```

3. Install required R packages:
```R
install.packages(c(
    "tidyverse",
    "caret",
    "corrplot",
    "readxl",
    "dplyr",
    "ggplot2",
    "purrr",
    "tidyr",
    "stringr",
    "randomForest",
    "gridExtra"
))
```

4. Data Requirements:
Place the following files in the `data/raw/` directory:
- `nlte198020213.xlsx` (England National Life Tables)
- `nltw198020213.xlsx` (Wales National Life Tables)
- `englandreferencetable2020.xlsx` (England Reference Tables)
- `walesreferencetable2020.xlsx` (Wales Reference Tables)

5. Run the analysis:
```R
source("main.R")
```

## File Descriptions

- `01_dependencies.R`: Loads all required packages
- `02_data_processing.R`: Data cleaning and processing functions
- `03_visualization.R`: All visualization functions
- `04_analysis.R`: Statistical analysis and correlation studies
- `05_models.R`: Predictive modeling with Random Forest and Linear Regression
- `main.R`: Main script that runs the entire analysis pipeline

## Outputs

The analysis produces several outputs:
- Processed datasets (in `outputs/processed/`)
- Visualization plots (in `outputs/figures/`)
- Model results (in `outputs/models/`)

## Results

Key visualizations include:
1. Life expectancy trends by region and sex
2. Mortality rates by age and sex
3. Deprivation index analysis
4. Correlation matrices
5. Model performance comparisons

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.
