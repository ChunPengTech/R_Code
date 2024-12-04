library(powerMediation)
library(bruceR)
library(tidyverse)

set.wd()
data <- import("maindata304n.csv", as = "data.frame")
data <- data |> select(X1, X2, X, M1, M2, M3, M, Y)

data |> head()
Corr(data)

sum <- lm(Y ~ X + M, data)
summary(sum)

citation("powerMediation")


#--- 计算线性回归模型中可以检测到的最小中介效应 ---
minEffect.VSMc(
  n = 304, power = 0.8,
  sigma.m = 0.72, sigma.e = 1,
  corr.xm = 0.79, alpha = 0.05,
  verbose = TRUE
)

# 输出0.1684396表示在这些条件下，线性回归模型中中介变量的最小可检测斜率为0.1684396。
# 换句话说，当中介变量的真实效应大小（斜率）大于或等于0.1684396时，检验才有 80%的概率能够检测到这个效应。

#--- 计算简单线性回归模型中斜率检验的样本量 ---
ss.SLR(
  power = 0.8, lambda.a = 0.5,
  sigma.x = 0.2, sigma.y = 0.5,
  alpha = 0.05, verbose = TRUE
)
# n = 190


#--- 计算线性回归模型中 中介效应检验所需的样本量 ---
ssMediation.VSMc(
  power = 0.95, b2 = 0.5,
  sigma.m = 0.72, sigma.e = 1,
  corr.xm = 0.79, alpha = 0.05,
  verbose = TRUE
)
# n = 267

#--- 计算线性回归模型中 中介效应的检验功效 ---
powerMediation.VSMc(
  n = 304, b2 = 0.5,
  sigma.m = 0.72, sigma.e = 1,
  corr.xm = 0.79, alpha = 0.05,
  verbose = TRUE
)
# power = 0.9705135 > 0.8