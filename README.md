# Statistical Tests
## Personal Introduction
During my undergraduate studies in Biochemistry Engineering, I took a full semester of Experimental Design with an excellent professor from Cuba. His teaching methodology involved thirty straight minutes of writing the theory for each ANOVA method by hand and performing all calculations for each problem the same way. Although I've never had to do it by hand again since we learned how to use SPSS the following semester I still remember my hand and butt used aching during weekends spent transcribing full datasets and analysing them. Anyway, I decided to learn R for creating Markdown files the moment Overleaf couldn't process my research thesis images due to their size. After I completed my thesis, I realized I might as well learn how to perform statistical analysis with R.

So here we are.
During 2025 I've worked at the Research Center of Fundación Jambatu, running cryopreservation experiments with frog sperm. With the explicit permission of Andrea Terán, my supervisor, I used the gathered experimental data to establish the ranges and characteristics of the dataset utilized in this portfolio. The data presented here is a simulated representation of the real findings, created to secure against any potential disclosure of privileged project information.


## Sperm Motility Analysis of Atelopus sp. with Cryoprotectant Formulations
### Overview

This R script performs an analysis of sperm motility data collected from _Atelopus sp_ specimens. The primary goal is to evaluate the effect of two different cryoprotectant formulations (CPA1 and CPA2) on sperm viability over various time points. This analysis includes data loading, cleaning, descriptive statistics, visualization through either jittered dot plots or bar plots with error bars, and ANOVA to assess statistical differences between treatments and time lapses.

This project is part of ongoing research in amphibian conservation, specifically focusing on the cryopreservation of a specific Atelopus sp sperm, a critically endangered species. The data used in this analysis was personally collected by me in laboratory settings. Due to disclosure agreements with my current employer I won't discuss the two formulations of CPA.

### Data Description
The raw data is stored in an Excel file named **prd.xlsx.** This file contains sperm motility percentages for different time lapses under two distinct cryoprotectant treatments. The data has been pre-processed and tidied in Google Sheets before being imported into R.

**Column Descriptions:**


**Treatment:** Denotes the cryoprotectant formulation applied (CPA1 or CPA2).

**Time_Lapse:** The time point (in minutes) at which sperm motility was measured.

**Motility:** The percentage of motile sperm at a given time and treatment.

### Methodology
I applied a two-way ANOVA to compare the results of CPA1 and CPA2 with Motility as the dependent variable and Treatment and Time_Lapse as the two independent variables.
Then, I ran a one-way ANOVA for each treatment to know if each time lapse is significantly different for each treatment. 
After defining which of the two treatments shows any significant differences between time lapses, I ran Tukey's Post-Hoc test to define which time lapse yields the most different result.
Since this ins a simulated dataset taken from an ongoing project, we would like to take into consideration which sample size would be statistically appropriate for these analysis, which is why I ran a one-way ANOVA to determine it.


**Script Usage**


To run this analysis, you will need to have R and RStudio installed on your system. This script was developed and tested on Ubuntu 24.04 LTS.

**Prerequisites**


Ensure you have the following R packages installed. If not, you can install them using the install.packages() function in R:

- install.packages("tidyverse")
  
- install.packages("ggplot2")
  
- install.packages("tidyr")

- library(readxl)

- library(pwr) 

**Running the Script**


Place the **prd.xlsx** file in the same directory as the R script.
Open the R script in RStudio.
Run the entire script.

**The script will:**

Load the necessary libraries.
Import the prd.xlsx dataset.
Rename the columns for clarity.
Create separate dataframes for CPA1 and CPA2 treatments.
Calculate mean and standard deviation of motility for each time lapse under both treatments.
Generate two jittered plots visualizing mean sperm motility with standard deviation error bars for CPA1 and CPA2.
Perform a two-way ANOVA test to determine if there's a significant difference between both treatments.
Perform an ANOVA test for each treatment to determine if there are significant differences in motility across time lapses.
Perform a post-hoc test (Tuckey test) to determine if there are significant differences in motility among time lapses. 
Print the summary results of of each test to the console.
Additionally, it'll calculate a statistically appropriate sample size via ANOVA for these analysis. 

## Visualization & Interpretations

So far, there's a significant difference between time lapses in the second treatment. The Tukey test indicates a significant difference in Time 5  in comparison to the Times 15 and 20, during the second treatment. However, these preliminary results come from a sample too small to be considered statistically significant, according to the One-way ANOVA run at the end of the code. 

<p align="center">
  <img src="https://github.com/CharlesDexterW/Statistical_Tests/blob/main/CPA1_Jitter_Plor.png?raw=true" width="450" hspace="20">
  <img src="https://github.com/CharlesDexterW/Statistical_Tests/blob/main/CPA2_Jitter_Plot.png?raw=true" width="450" hspace="20">
</p>
*Figure 1: Jittered Plots visualizing the effects of Cryoprotective Agent (CPA) 1 (left) and CPA 2 (right), sperm motility percentage on four different time lapses. 

<br>
<br>

<p align="center">
  <img src="https://github.com/user-attachments/assets/4d875680-9634-4380-aac2-80de65ac1690" width="450" hspace="20">
  <img src="https://github.com/user-attachments/assets/bb46f793-30d1-4ee4-89d4-72cff818bebb" width="450" hspace="20">
</p>
*Figure 2: Bar Plots visualizing the effects of Cryoprotective Agent (CPA) 1 (left) and CPA 2 (right), sperm motility percentage on four different time lapses. 

<br>
<br>


Author

A. Benjamin Garcés C.
