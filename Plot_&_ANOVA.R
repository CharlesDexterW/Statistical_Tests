##SETUP
## First of To load the needed packages

library(tidyverse) ## this one usually allow the readxl functions to work. 
library(readxl) ## I had to add this one alone anyway since the read_xlsx function didn't work properly on my last run.
library(dplyr) ## this one I'll use it for later.
library(ggplot2) ## needed to plot the graphs
library(tidyr)

## ---
## first let's load my data. This is real data from the lab I currently work at. 
## It corresponds spermic urine of four different Atelopus longirostris specimens collected by me.

xlr <- read_xlsx("Cryoprotectant_Results.xlsx")
## I've previously tidyed up this data on google worksheets.  But I'll name each column here.

colnames(xlr) <- c("Treatment", "Time_Lapse", "Motility")

## BTW There's only two treatments which are cryoprotectant formulations prepared by my colleague. 
## I'm creating two new tables from my data to work smoothly.
cpa1r <- xlr %>%
  filter(Treatment == "CPA1")

cpa2r <- xlr %>%
  filter(Treatment == "CPA2")
## Now let's create a summary of statistical descriptors for each treatment set.

cpa1_summary <- xlr %>%
  filter(Treatment == "CPA1") %>%
  group_by(Time_Lapse) %>%
  summarize(mean_motility = mean(`Motility`, na.rm = TRUE),
            sd_motility = sd(`Motility`, na.rm = TRUE))

cpa2_summary <- xlr %>%
  filter(Treatment == "CPA2") %>%
  group_by(Time_Lapse) %>%
  summarize(mean_motility = mean(`Motility`, na.rm = TRUE),
            sd_motility = sd(`Motility`, na.rm = TRUE))
## now off to plot the graphs. 

ggplot(cpa1_summary, aes(x = Time_Lapse, y = mean_motility)) +
  geom_bar(stat = "identity", fill = "lightblue") +  # Use identity since there are pre-calculated means
  geom_errorbar(aes(ymin = mean_motility - sd_motility,
                    ymax = mean_motility + sd_motility),
                width = 0.2) +
  labs(title = "Sperm Motility in CPA1",
       x = "Time Lapse (Minutes)",
       y = "Mean Motility (%)") +
  theme_minimal()


ggplot(cpa2_summary, aes(x = Time_Lapse, y = mean_motility)) +
  geom_bar(stat = "identity", fill = "lightgreen") +  # Use identity since there are pre-calculated means
  geom_errorbar(aes(ymin = mean_motility - sd_motility,
                    ymax = mean_motility + sd_motility),
                width = 0.2) +
  labs(title = "Sperm Motility in CPA2",
       x = "Time Lapse (Minutes)",
       y = "Mean Motility (%)") +
  theme_minimal()
## Now I'd like to know if each time lapse is significantly different. 
## To do that I'd like to Perform ANOVA for each treatment.
## So my null hypothesis would be "there's no significant difference between time lapses".

anova_cpa1 <- aov(`Motility` ~ factor(Time_Lapse), data = cpa1r)
anova_cpa2 <- aov(`Motility` ~ factor(Time_Lapse), data = cpa2r)

# 3.  Print the ANOVA results
print("ANOVA for CPA1:")
print(summary(anova_cpa1))

print("ANOVA for CPA2:")
print(summary(anova_cpa2))
