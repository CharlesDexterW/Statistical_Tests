##SETUP
## First of To load the needed packages

library(tidyverse) ## this one usually allow the readxl functions to work. 
library(readxl) ## I had to add this one alone anyway since the read_xlsx function didn't work properly on my last run.
library(dplyr) ## this one I'll use it for later.
library(ggplot2) ## needed to plot the graphs
library(tidyr)
library(pwr) ## to run a One way ANOVA.

## ---
## first let's load my data. This is real data from the lab I currently work at. 
## It corresponds spermic urine of four different Atelopus longirostris specimens collected by me.

xlr <- read_xlsx("Cryoprotectant_Results.xlsx", col_names = FALSE)
## I've previously tidyed up this data on google worksheets. 
## Also, I used col_names so it doesn't use the first row as column names.

colnames(xlr) <- c("Treatment", "Time_Lapse", "Motility")

## BTW There's only two treatments which are cryoprotectant formulations prepared by me. 
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

## There seems to be a big difference between the standard deviations of Time 5 and the others CPA2. We'll check that later on. 
## Now let's run a Two-way ANOVA to compare the motility results between treatments (CPA1 and CPA2),
## where motility is the dependent variable and Treatment and Time_Lapse as the two independent variables.

anova_two_way <- aov(Motility ~ Treatment * Time_Lapse, data = xlr)
print(summary(anova_two_way))

## there's no significant overall difference in average motility between treatments.
## However, Time_Lapse significantly impacts motility, which means it changes over time regardles of which cryoprotectant is used.
## Both formulations seem to experience similar time-dependend effects on motility.

## Now let's create a new item called "model_cpa2" through the aov() function using CPA2.
## to test which time lapse yields the most different results. 

model_cpa2 <- aov(Motility ~ factor(Time_Lapse), data = cpa2r)

## For a Post-Hoc Analysis, let's run a Tukey test evaluate the CPA2 efficacy over time. 
TukeyHSD(model_cpa2)
## This table above presents a pairwise comparison:
## diff: It's the mean difference in motility between two time points being compared.
## lwr and upr: These are the lower and upper bounds of the 95% confidence interval for the mean difference.
## if it doesn't include zero, it's statistically significant.
## p adj: It's the adjusted p-value for the pairwise comparison. This p-value has been corrected
## for multiple comparisons, maintaining a controlled family-wise error rate. 
## a p adj value less than 0.05 (or chosen alpha level9 indicates a statistically significant difference between the two time points.


## Now there's a statistically significant decrease in motility on the times 5-15 comparison,
## whicho suggests that sperm motility declines past time 5. 
## This is corroborated in the comparison of Time 5-20, where sperm motility drops more significantly.


## As you can see, these are preliminary results. It's still not clear if these results figure a biological significance, 
## but it's clear the number of repetitions is not statistically significant.
## However I'll run here a One way ANOVA to calculate the appropiate number of repetitions using the "pwr" package.

# n = number of subjects per group
# k = number of groups
# f = effect size (according ot Cohen's f it'll be equal to 0.25)
# sig.level = it's the alpha level
# power = desired power.

pwr.anova.test(k = 4, f = 0.25, sig.level = 0.05, power = 0.80)


## With this result I've got a better idea of an adequate number of assay repetitions 
## we require to gather reliable results in this experiment.  
