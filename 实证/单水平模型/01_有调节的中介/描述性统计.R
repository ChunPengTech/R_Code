library(bruceR)
data <- import("main variable.xlsx")

# -------- 均值与标准差 --------

library(psych)
describe <- describe(data)
round(describe$mean, 3)
round(describe$sd, 3)

## or
library(skimr)
sum <- skim(data)
round(sum$numeric.mean, 3)
round(sum$numeric.sd, 3)

## or
library(bruceR)
Describe(data)


# -------- 相关系数 --------

library(Hmisc) ## 相关系数与P值
library(PerformanceAnalytics) ## 可视化

Corr(data, digits = 3) ## 来源于bruceR，输出相关性并绘图

## or

data1 <- as.matrix(data)
res <- rcorr(data1)
round(res$r, 3)
round(res$P, 3) ## 提取相关系数与p值并保留三位小数

chart.Correlation(data, histogram = T, pch = 19) ## 可视化

# -------- 共线性 --------

lmfit <- lm(IKS ~ DT + KF + OT, data) ## 线性回归
library(car)
round(vif(lmfit), 3)
GLM_summary(lmfit)
