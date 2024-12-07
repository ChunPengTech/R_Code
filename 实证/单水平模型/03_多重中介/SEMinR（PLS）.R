library(seminr)
library(bruceR)

set.wd()
data <- import("data304n.csv", as = "tibble")


# -------- Create measurement model --------


simple_mm <- constructs(
  composite("XA", multi_items("xa", 1:6)),
  composite("XB", multi_items("xb", 1:5)),
  composite("MA", multi_items("ma", 1:3)),
  composite("MB", multi_items("mb", 1:3)),
  composite("MC", multi_items("mc", 1:3)),
  composite("Y", multi_items("y", 1:5))
)


# -------- Create structural model --------


simple_sm <- relationships(
  paths(from = "XA", to = cc("MA, MB, MC, Y")),
  paths(from = "XB", to = cc("MA, MB, MC, Y")),
  paths(from = cc("MA, MB, MC"), to = "Y")
)


# -------- Estimate the model with Omissions --------


simple_model <- estimate_pls(
  data = data,
  measurement_model = simple_mm,
  structural_model = simple_sm
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


# -------- Bootstrap the model --------


boot_simple <- bootstrap_model(
  seminr_model = simple_model,
  nboot = 5000,
  cores = 4,
  seed = 123
)

## Store the summary of the bootstrapped model
summary_boot <- summary(boot_simple)

## 路径系数（含T值与置信区间）
summary_boot$bootstrapped_paths %>% print_table()
## 总效应的系数
summary_boot$bootstrapped_total_paths %>% print_table()


# -------- bootstrap med --------

specific_effect_significance(boot_simple,
  from = "XA",
  through = "MA",
  to = "Y",
  alpha = 0.05
)

specific_effect_significance(boot_simple,
  from = "XA",
  through = "MB",
  to = "Y",
  alpha = 0.05
)

specific_effect_significance(boot_simple,
  from = "XA",
  through = "MC",
  to = "Y",
  alpha = 0.05
)

specific_effect_significance(boot_simple,
  from = "XB",
  through = "MA",
  to = "Y",
  alpha = 0.05
)

specific_effect_significance(boot_simple,
  from = "XB",
  through = "MB",
  to = "Y",
  alpha = 0.05
)

specific_effect_significance(boot_simple,
  from = "XB",
  through = "MC",
  to = "Y",
  alpha = 0.05
)

plot(boot_simple)
