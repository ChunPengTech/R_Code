library(tidyverse)
library(seminr)
library(bruceR)

set.wd()
data <- import("data_298.csv", as = "tibble")
data

# --------- Create measurement model ---------

simple_mm <- constructs(
  composite("X", multi_items("x", 1:5)),
  composite("MA", multi_items("ma", 1:5)),
  composite("MB", multi_items("mb", 1:6)),
  composite("Y", multi_items("y", 1:6))
)

# --------- Create structural model ---------

simple_sm <- relationships(
  paths(from = "X", to = c("MA", "MB", "Y")),
  paths(from = "MA", to = c("MB", "Y")),
  paths(from = "MB", to = "Y")
)

# --------- Estimate the model with Omissions ---------

simple_model <- estimate_pls(
  data = data,
  measurement_model = simple_mm,
  structural_model = simple_sm,
  missing = mean_replacement,
  missing_value = "-99"
)

# --------- Summary the model ---------

summary_simple <- summary(simple_model)

## 因子载荷
summary_simple$loadings %>% print_table()

## 交叉载荷
summary_simple$validity$cross_loadings %>% print_table()

## α、AVE、rhoC、rhoA
summary_simple$reliability %>% print_table()

## HTMT
summary_simple$validity$htmt %>% print_table()

## fl_criteria
summary_simple$validity$fl_criteria %>% print_table()

## 内部模型的共线性
a <- summary_simple$vif_antecedents

## f2
summary_simple$fSquare %>% print_table()

## R方与路径系数（各效应值）
summary_simple$paths %>% print_table()

## 总效应值
summary_simple$total_effects %>% print_table()

## 总间接效应
summary_simple$total_indirect_effects %>% print_table()

plot(simple_model)
plot(summary_simple$reliability)


# --------- Bootstrapping the model ---------

boot_simple <- bootstrap_model(
  seminr_model = simple_model,
  nboot = 5000,
  cores = 4,
  seed = 123
)

summary_boot <- summary(boot_simple)

## 路径系数（含T值与置信区间）
summary_boot$bootstrapped_paths %>% print_table()

## 总效应系数
summary_boot$bootstrapped_total_paths %>% print_table()

  # --------- Bootstrapping mediation ---------

  specific_effect_significance(boot_simple,
  from = "X",
  through = "MA",
  to = "Y",
  alpha = 0.05
)

specific_effect_significance(boot_simple,
  from = "X",
  through = "MB",
  to = "Y",
  alpha = 0.05
)

specific_effect_significance(boot_simple,
  from = "X",
  through = c("MA", "MB"),
  to = "Y",
  alpha = 0.05
)

plot(boot_simple)
