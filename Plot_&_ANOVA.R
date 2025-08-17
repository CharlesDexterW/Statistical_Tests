##SETUP
## First of, To load the needed packages

library(tidyverse) ## A collection of packages, which includes:
# library(dplyr) this one I'll use it for later.
#library(ggplot2) needed to plot the graphs
# library(tidyr) for structuring data.
library(readxl) ## necessary for loading the "readxl" function
library(pwr) # to run ANOVA
## ---

## Now let's load my data. It corresponds to simulated spermic urine of four different Atelopus sp. 

xlr <- read_xlsx("prd.xlsx", range ="A1:C40", col_names = FALSE) ## limiting the range avoids unnecesary warnings by not reading empty columns
## I've previously tidyed up this data on google worksheets. 
## Also, I used col_names so it doesn't use the first row as column names.

colnames(xlr) <- c("Treatment", "Time_Lapse", "Motility")

## There's only two treatments which are cryoprotectant formulations. 
## I'm creating two new tables from my data to work smoothly.
cpa1r <- xlr %>%
  filter(Treatment == "CPA1")

cpa2r <- xlr %>%
  filter(Treatment == "CPA2")
## Now let's create a summary of statistical descriptors for each treatment set, which will be useful for creating plots later.

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

## now let's to plot the graphs. 
# To plot a graph with jittered points and a line representing the mean plus +- 1 SD, let's run:
## First for CPA1 treatment,
ggplot(cpa1r, aes(x = Time_Lapse, y = Motility)) + # Individual Data Points
  geom_jitter(aes(color = "Individual Data Points"), width = 0.2, alpha = 0.5) + # to create scattered dots corresponding to data points.
  geom_errorbar(data = cpa1_summary,   # To use the Statistical Summary to graph a dot for mean value and a standard deviation bar. 
                aes(ymin = mean_motility - sd_motility,
                    ymax = mean_motility + sd_motility,
                    y = mean_motility,
                    color = "Mean Motility ± 1 SD"),
                width = 0.2, size = 0.5) +
  geom_point(data = cpa1_summary,
             aes(y = mean_motility),
             color = "black",
             size = 2) + # Plots the mean points
  scale_color_manual(name = "Data Representation",   # Customize the legend labels and colors
                     values = c("Individual Data Points" = "darkblue",
                                "Mean Motility ± 1 SD" = "black")) +
  labs(title = "Sperm Motility in CPA1: Jitter Plot",
       x = "Time Lapse (Minutes)",
       y = "Motility (%)") +
  theme_minimal() + # my favorite theme.
  theme(legend.position = "bottom") # to localize the legend bellow the plot.


# Now the Plot with jittered points and a line representing the mean for CPA2 treatment
ggplot(cpa2r, aes(x = Time_Lapse, y = Motility)) + # Individual Data Points (The "Rain")
  geom_jitter(aes(color = "Individual Data Points"), width = 0.2, alpha = 0.5) +
  geom_errorbar(data = cpa2_summary,   # Statistical Summary (The "Lightning")
                aes(ymin = mean_motility - sd_motility,
                    ymax = mean_motility + sd_motility,
                    y = mean_motility,
                    color = "Mean Motility ± 1 SD"),
                width = 0.2, size = 0.5) +
  geom_point(data = cpa2_summary,
             aes(y = mean_motility),
             color = "black",
             size = 2) + # Plots the mean points
  scale_color_manual(name = "Data Representation", # Customize the legend labels and colors
                     values = c("Individual Data Points" = "darkblue",
                                "Mean Motility ± 1 SD" = "black")) +
  labs(title = "Sperm Motility in CPA2: Jitter Plot",
       x = "Time Lapse (Minutes)",
       y = "Motility (%)") +
  theme_minimal() +
  theme(legend.position = "bottom")


## As an alternative I can also generate bar plots which are still frequently used. 
## CPA1
ggplot(cpa1_summary, aes(x = Time_Lapse, y = mean_motility)) +
  geom_bar(stat = "identity", fill = "lightblue", width = 3) +  # Use identity since there are pre-calculated means
  geom_errorbar(aes(ymin = mean_motility - sd_motility,
                    ymax = mean_motility + sd_motility),
                width = 0.2) +
  labs(title = "Sperm Motility in CPA1",
       x = "Time Lapse (Minutes)",
       y = "Mean Motility (%)") +
  theme_minimal()

## CPA2
ggplot(cpa2_summary, aes(x = Time_Lapse, y = mean_motility)) +
  geom_bar(stat = "identity", fill = "lightgreen", width = 3) +  # Use identity since there are pre-calculated means
  geom_errorbar(aes(ymin = mean_motility - sd_motility,
                    ymax = mean_motility + sd_motility),
                width = 0.2) +
  labs(title = "Sperm Motility in CPA2",
       x = "Time Lapse (Minutes)",
       y = "Mean Motility (%)") +
  theme_minimal()

## Let's run a two-way ANOVA to compare the results of CPA1 and CPA2 with Motility as the 
## dependent variable and Treatment and Time_Lapse as the two independent 
## variables. 

anova_two_way <- aov(Motility ~ Treatment * Time_Lapse, data = xlr)
print(summary(anova_two_way))

## Let's Interpret the Main Effect of Treatment (CPA1 vs. CPA2):
## There is no significant overall difference in average motility between CPA1 
## and CPA2.
## However, the Time_Lapse significantly impacts motility, meaning motility changes 
## over time regardless of the cryoprotectant. And the pattern of motility change over 
## time is similar for both CPA1 and CPA2. There is no significant interaction, 
## suggesting that, at least with the current sample size, neither CPA1 nor CPA2 
## is uniquely better or worse at preserving motility over specific time intervals, 
## compared to the other. Both formulations seem to experience similar 
## time-dependent effects on motility.

## Now I'd like to know if each time lapse is significantly different. 
## To do that I'd like to Perform ANOVA for each treatment. So my null hypothesis 
## would be "there's no significant difference between time lapses".

anova_cpa1 <- aov(`Motility` ~ factor(Time_Lapse), data = cpa1r)
anova_cpa2 <- aov(`Motility` ~ factor(Time_Lapse), data = cpa2r)

print("ANOVA for CPA1:")
print(summary(anova_cpa1))

print("ANOVA for CPA2:")
print(summary(anova_cpa2))

## As the Pr value of CPA1 treatment is greater than 0.5, we discard the 
## alternative hypothesis. On the other hand, the Pr value of CPA2 treatment is 
## lower than 0.5, so we approve can safely state that there's a significant difference 
## between time lapses. 

## The next step if there was significant difference is to run a Post-Hoc test to 
## tell wich time lapse yields the most different result.

model_cpa2 <- aov(Motility ~ factor(Time_Lapse), data = cpa2r) # off to create an aov() to run it in the Tuckey test.
model_cpa2

TukeyHSD(model_cpa2)

## Post-Hoc Analysis of Cryoprotectant CPA2 Efficacy over Time (Tukey's HSD)
## The table above presents the following for each pairwise comparison:
## diff: The mean difference in motility between the two time points being 
## compared.
## lwr and upr: The lower and upper bounds of the 95% confidence interval for 
## the mean difference. If this interval does not include zero, the difference 
## is statistically significant.
## p adj: The adjusted p-value for the pairwise comparison. This p-value has been 
## corrected for multiple comparisons, maintaining a controlled family-wise error 
## rate. A p adj value less than 0.05 (or your chosen alpha level) indicates a 
## statistically significant difference between the two time points.

## Key Findings from CPA2 data Analysis:
## There's a statistically significant decrease in motility between Time 
## 15 and Time 5, which suggests that by Time 15, motility had significantly 
## declined compared to Time 5.The same was also observed between Time 20 and 
## Time 5. This indicates a significant drop in motility by Time 20 relative to 
## Time 5, though the effect is less pronounced than the 15-5 comparison.

## All other pairwise comparisons (10-5, 15-10, 20-10, 20-15) did not show 
## statistically significant differences at the 0.05 level, suggesting that 
## changes within these narrower time frames were not significant or that 
## recovery/stabilization occurred.

## This analysis provides granular insights into the degradation or stability of 
## cell motility under CPA2 conditions over various time exposures, highlighting 
## specific critical time points where significant changes occur.

## I remained curious about what would be the proper statistical sample size to 
## safely state my current interpretation, so I decided to run a One way ANOVA to
## calculate the appropriate number of repetitions.

# n = number of subjects per group (what we want to find)
# k = number of groups (your time points)
# f = effect size (Cohen's f)
# sig.level = alpha level
# power = desired power

pwr.anova.test(k = 4, f = 0.25, sig.level = 0.05, power = 0.80)
## Turns out the appropriate sample size is around 45.

