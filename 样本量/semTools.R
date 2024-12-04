library(semTools)
# 计算样本量
findRMSEAsamplesize(
  rmsea0 = 0.10,
  rmseaA = 0.03,
  df = 5,
  power = 0.8,
  alpha = 0.05
)
2
# 计算功效
findRMSEApower(
  rmsea0 = 0.10,
  rmseaA = 0.05,
  df = 15,
  n = 233,
  alpha = 0.05
)
