library(seminr)
library(bruceR)

set.wd()
data <- import("data_298.csv", as = "data.frame")

# PLS—SEM eg.chainmed

# -------- Create measurement model --------

simple_mm <- constructs(
  composite("X", multi_items("x", 1:8)),
  composite("MA", multi_items("ma", 1:8)),
  composite("MB", multi_items("mb", 1:7)),
  composite("Y", multi_items("y", 1:5))
)
## 如果有单一构造，如显变量，则用single_item("xx")

# -------- Create structural model --------

simple_sm <- relationships(
  paths(from = "X", to = c("MA", "MB", "Y")),
  paths(from = "MA", to = c("MB", "Y")),
  paths(from = "MB", to = "Y")
)

# -------- Estimate the model with Omissions --------

simple_model <- estimate_pls(
  data = data,
  measurement_model = simple_mm,
  structural_model = simple_sm,
  missing = mean_replacement,
  missing_value = "-99"
)

summary_simple <- summary(simple_model)

## 因子载荷
summary_simple$loadings %>% print_table()
## 交叉载荷
summary_simple$validity$cross_loadings %>% print_table()
## α、AVE、rhoC、rhoA
summary_simple$reliability %>% print_table()
## HTMT
summary_simple$validity$htmt %>% print_table()
## 相关系数与AVE平方根
summary_simple$validity$fl_criteria %>% print_table()

## 相关性
summary_simple$descriptives$correlations$constructs %>% print_table()
## 共线性
summary_simple$vif_antecedents
## 模型选择标准
summary_simple$it_criteria %>% print_table()

## R方与路径系数（各效应值）
summary_simple$paths %>% print_table()
## 各效应值
summary_simple$total_effects %>% print_table()
## 总间接效应
summary_simple$total_indirect_effects %>% print_table()

plot(simple_model)
plot(summary_simple$reliability)

# -------- bootstrap the model --------

boot_simple <- bootstrap_model(
  seminr_model = simple_model,
  nboot = 1000,
  cores = 4,
  seed = 123
)

# Store the summary of the bootstrapped model
summary_boot <- summary(boot_simple)
summary_boot

## 路径系数（含T值与置信区间）
summary_boot$bootstrapped_paths %>% print_table()
## 直接效应的系数
summary_boot$bootstrapped_total_paths %>% print_table()


#-------- bootstrap med --------

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