library(bruceR)
set.wd()
data <- import("maindata304n.xlsx", as = "data.frame")

# -------- 均值与标准差 --------

Describe(data)

# -------- 相关系数 --------

Corr(data, digits = 3)

library(PerformanceAnalytics)

chart.Correlation(data, histogram = T, pch = 19)

