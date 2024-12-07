# 载入数据
library(bruceR)
set.wd()
data <- import("data_298.csv", as = "data.frame")
data

# -------- 探索性因子分析 -------- 

EFA(data, varrange = "x1:y6", hide.loadings = 0.5, plot.scree = FALSE)

fa_result <- psych::principal(data, rotate = "varimax", nfactors = 4)
print(fa_result$loadings, cutoff = 0.5)

# -------- kmo和bartlett检验 --------

# performance::check_kmo(data)
# performance::check_sphericity_bartlett(data)
performance::check_factorstructure(data) ## kmo和bartlett检验

# -------- 验证性因子分析 --------

library(lavaan)
library(semTools)
library(tidyverse)

model <- "
x =~ x1+x2+x3+x4+x5
ma =~ ma1+ma2+ma3+ma4+ma5
mb =~ mb1+mb2+mb3+mb4+mb5+mb6
y =~ y1+y2+y3+y4+y5+y6
"

fit <- cfa(model, data)

res <- summary(fit, standardized = T)
res$pe |>
  filter(op == "=~") |>
  select(rhs, std.all) |>
  print_table()

lavaan_summary(fit)

data |> Alpha("x", 1:5)

# -------- 信度与聚敛效度 --------

reliability(fit) |> print_table(digits = 3)


# -------- 区分效度 --------

lavInspect(fit, "cor.lv")
matrix <- lavInspect(fit, "cor.lv")
diag(matrix) <- sqrt(AVE(fit))
## 将相关系数的对角线替换为AVE的平方根
matrix
