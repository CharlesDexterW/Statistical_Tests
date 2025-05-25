# Statistical Tests
During my undergraduate studies in Biochemistry Engineering, I took a full semester of Experimental Design with an excellent professor from Cuba. His teaching methodology involved thirty straight minutes of writing the theory for each ANOVA method by hand and performing all calculations for each problem the same way. Although I've never had to do it by hand again since we learned how to use SPSS the following semester I still remember my hand and butt used aching during weekends spent transcribing full datasets and analysing them. Anyway, I decided to learn R for creating Markdown files the moment Overleaf couldn't process my research thesis images due to their size. After I completed my thesis, I realized I might as well learn how to perform statistical analysis with R.. 

So here we are.

## Sperm Motility Analysis of Atelopus longirostris with Cryoprotectant Formulations
### Overview
This R script performs an analysis of sperm motility data collected from _Atelopus longirostris_ specimens. The primary goal is to evaluate the effect of two different cryoprotectant formulations (CPA1 and CPA2) on sperm viability over various time points. This analysis includes data loading, cleaning, descriptive statistics, visualization through bar plots with error bars, and an ANOVA to assess statistical differences between time lapses for each treatment.

This project is part of ongoing research in amphibian conservation, specifically focusing on the cryopreservation of Atelopus longirostris sperm, a critically endangered species. The data used in this analysis was personally collected by me in laboratory settings. Due to disclosure agreements with my current employer I won't discuss the two formulations of CPA.

Data
The raw data is stored in an Excel file named **Cryoprotectant_Results.xlsx.** This file contains sperm motility percentages for different time lapses under two distinct cryoprotectant treatments. The data has been pre-processed and tidied in Google Sheets before being imported into R.

**Column Descriptions:**
**Treatment:** Denotes the cryoprotectant formulation applied (CPA1 or CPA2).
**Time_Lapse:** The time point (in minutes) at which sperm motility was measured.
**Motility:** The percentage of motile sperm at a given time and treatment.

**Script Usage**
To run this analysis, you will need to have R and RStudio installed on your system. This script was developed and tested on Ubuntu 24.04 LTS.

**Prerequisites**
Ensure you have the following R packages installed. If not, you can install them using the install.packages() function in R:

install.packages("tidyverse") # Includes readxl and dplyr
install.packages("ggplot2")
install.packages("tidyr")

**Running the Script**
Place the Cryoprotectant_Results.xlsx file in the same directory as the R script.
Open the R script in RStudio.
Run the entire script.

**The script will:**

Load the necessary libraries.
Import the Cryoprotectant_Results.xlsx dataset.
Rename the columns for clarity.
Create separate dataframes for CPA1 and CPA2 treatments.
Calculate mean and standard deviation of motility for each time lapse under both treatments.
Generate two bar plots visualizing mean sperm motility with standard deviation error bars for CPA1 and CPA2.
Perform an ANOVA test for each treatment to determine if there are significant differences in motility across time lapses.
Print the summary results of the ANOVA tests to the console.

Author

Benjamin Garcés - Biochemistry Engineer
