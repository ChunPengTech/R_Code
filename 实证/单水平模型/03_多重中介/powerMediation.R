library(powerMediation)
library(bruceR)
library(tidyverse)

set.wd()
data <- import("maindata304n.csv", as = "tibble")
data <- data |> 
  select(X, M, Y)

data
Describe(data)
Corr(data)

# -------- 计算线性回归模型中中介效应检验所需的样本量 --------

ssMediation.VSMc(
  power = 0.95, b2 = 0.5,
  sigma.m = 0.72, sigma.e = 1,
  corr.xm = 0.79, alpha = 0.05
)
# n = 267

# -------- 计算线性回归模型中中介效应的检验功效 --------

powerMediation.VSMc(
  n = 304, b2 = 0.5,
  sigma.m = 0.72, sigma.e = 1,
  corr.xm = 0.79, alpha = 0.05
)
# power = 0.9705135 > 0.8