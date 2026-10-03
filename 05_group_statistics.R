# Descriptive statistics, Shapiro-Wilk tests and t-tests by group
# Usage: Rscript 05_group_statistics.R demographics.xlsx
# Input (not included): one row per participant with columns
# Group, Age, IQ_total, AutismQuotient, EmpathyQuotient, Coverage

library(openxlsx)
library(dplyr)

d <- read.xlsx(commandArgs(trailingOnly = TRUE)[1], sheet = 1)

summary_stats <- d %>%
  group_by(Group) %>%
  summarise(across(c(Age, IQ_total, AutismQuotient, EmpathyQuotient, Coverage),
                   list(mean = ~ mean(.x, na.rm = TRUE), median = ~ median(.x, na.rm = TRUE),
                        sd = ~ sd(.x, na.rm = TRUE), min = ~ min(.x, na.rm = TRUE),
                        max = ~ max(.x, na.rm = TRUE))))
print(as.data.frame(summary_stats))

shapiro <- d %>%
  group_by(Group) %>%
  summarise(across(c(AutismQuotient, EmpathyQuotient, Coverage), ~ shapiro.test(.x)$p.value))
print(shapiro)

groups <- unique(d$Group)
results <- do.call(rbind, lapply(c("AutismQuotient", "EmpathyQuotient", "Coverage", "IQ_total"), function(v) {
  tt <- t.test(d[[v]][d$Group == groups[1]], d[[v]][d$Group == groups[2]])
  data.frame(Group1 = groups[1], Group2 = groups[2], Variable = v,
             t_statistic = unname(tt$statistic), p_value = tt$p.value)
}))
print(results)
