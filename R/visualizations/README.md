# Life Expectancy Trends in England and Wales: A Visual Exploration

## Overview
This project explores life expectancy trends in England and Wales through various data visualizations. It highlights socio-economic disparities and presents insights into how factors like deprivation and preventable mortality affect public health outcomes.

## Project Structure
```
SocioHealthViz/
│
└── visualizations/
    ├── visualization_plots.R
    ├── deprivation_plots.R
    └── composite_visualization.png
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

### `visualization_plots.R`
Contains R scripts for generating visualizations related to life expectancy analysis. The script processes demographic data and creates various plots including:
- Time series trends of life expectancy
- Geographic distribution maps
- Comparative analysis charts

### `deprivation_plots.R`
Implements visualization routines for deprivation indices, including:
- Multi-dimensional deprivation scores
- Regional comparison plots
- Correlation analysis with health outcomes

### `Composite_Visualisation.png`
A comprehensive visualization that combines key insights from both life expectancy and deprivation analyses, providing a holistic view of socio-health relationships.

## Outputs and Results
The project generates several types of visualizations:
- Interactive maps showing regional health disparities
- Time-series plots of life expectancy trends
- Heat maps of deprivation indices
- Correlation matrices between social and health factors

All visualizations are exported in high-resolution PNG format, suitable for both digital display and print media.

## Contributing
We welcome contributions to the SocioHealthViz project! Here's how you can help:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

---
For more information or support, please open an issue in the repository or contact the project maintainers.
