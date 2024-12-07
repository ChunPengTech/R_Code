library(bruceR)
set.wd()
data <- import("paper.xlsx")

# -------- KMO和Bartlett检验 --------

check_factorstructure(data[1:28])

EFA(data, varrange = "DT11:OT32")

# -------- 验证性因子分析 --------

library(lavaan)
library(semTools)
library(tidyverse)
library(tidySEM)

model <- "
DT1 =~ DT11 + DT12 + DT13
DT2 =~ DT21 + DT22
DT3 =~ DT31 + DT32 + DT33
KF1 =~ KF11 + KF12 + KF13 + KF14
KF2 =~ KF21 + KF22 + KF23 + KF24
IKS1 =~ IKS11 + IKS12 + IKS13
IKS2 =~ IKS21 + IKS22
OT1 =~ OT11 + OT12 + OT13
OT2 =~ OT21 + OT22
OT3 =~ OT31 + OT32
"
fit <- cfa(model, data)
lavaan_summary(fit)
graph_sem(fit)


CFA(data,
  model = model,
  estimator = "ML"
)

# -------- 信度与聚敛效度 -------- 
reliability(fit) %>% print_table(digits = 3)

Alpha(data, "DT", 11:13)
## α系数也可以用Aplha函数分别求

# -------- 区分效度 -------- 
lavInspect(fit, "cor.lv")
matrix <- lavInspect(fit, "cor.lv")
diag(matrix) <- sqrt(AVE(fit)) ## 将相关系数的对角线替换为AVE的平方根
matrix
