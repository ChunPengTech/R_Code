library(seminr)
library(bruceR)

set.wd()
data <- import("data_298.csv", as = "data.frame")

simple_mm <- constructs(
  reflective("X", multi_items("x", 1:8)),
  reflective("MA", multi_items("ma", 1:8)),
  reflective("MB", multi_items("mb", 1:7)),
  reflective("Y", multi_items("y", 1:5))
)

cfa_model <- estimate_cfa(
  data,
  simple_mm
)
summary_cfa <- summary(cfa_model)


## 因子载荷
summary_cfa$loadings$coefficients
## 相关系数
summary_cfa$descriptives$correlations$constructs
## 拟合指数
summary_cfa$quality$fit
## 信度
summary_cfa$quality$reliability
summary_cfa

plot(cfa_model)