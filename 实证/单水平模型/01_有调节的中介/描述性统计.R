library(bruceR)
data <- import("main variable.xlsx")

# -------- 均值与标准差 --------

Describe(data)

# -------- 相关系数 --------

Corr(data, digits = 3)

library(PerformanceAnalytics)

chart.Correlation(data, histogram = T, pch = 19)

# -------- 共线性 --------

lmfit <- lm(IKS ~ DT + KF + OT, data) ## 线性回归
library(car)
round(vif(lmfit), 3)
GLM_summary(lmfit)
