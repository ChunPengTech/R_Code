library(semPower)

# 参见 https://moshagen.github.io/semPower/#powerMediation


# -------------   简单中介模型  ----------------

## 样本量分析
powerMed_Pri <- semPower.powerMediation(
  # define type of power analysis
  type = "a-priori", alpha = 0.05, power = 0.8,
  # define hypothesis
  bYX = 0.3, # X->Y
  bMX = 0.3, # X->M
  bYM = 0.4, # M->Y
  nullEffect = "ind = 0",
  # define measurement model
  nIndicator = c(5, 5, 5), # X M Y的题项数
  loadM = c(0.7, 0.7, 0.7) # X M Y的载荷
)

summary(powerMed_Pri)


## 事后功效分析
powerMed_Hoc <- semPo1wer.powerMediation(
  # define type of power analysis
  type = "post-hoc", alpha = 0.05, N = 304,
  # define hypothesis
  bYX = 0.3,
  bMX = 0.3,
  bYM = 0.4,
  nullEffect = "ind = 0",
  # define measurement model
  nIndicator = c(5, 5, 5),
  loadM = c(0.7, 0.7, 0.7)
)
summary(powerMed_Hoc)

powerMed_Hoc$power


# -------------   多中介模型  ----------------

# 假设为X -> M1 -> M2 -> Y

# 只需给中介路径的系数
Beta <- matrix(c(
  c(.00, .00, .00, .00), # X = .00*X + .00*M1 + .00*M2 + .00*Y
  c(.40, .00, .00, .00), # M1 = .20*X + .00*M1 + .00*M2 + .00*Y
  c(.00, .30, .00, .00), # M2 = .00*X + .30*M1 + .00*M2 + .00*Y
  c(.00, .00, .40, .00) # Y = .00*X + .00*M1 + .40*M2 + .00*Y
), byrow = TRUE, ncol = 4)

loadings <- list(
  c(0.7, 0.7, 0.7), # X的3个指标的载荷
  c(0.7, 0.7, 0.7, 0.7), # M1的4个指标的载荷
  c(0.7, 0.7, 0.7, 0.7, 0.7), # M2的4个指标的载荷
  c(0.7, 0.7, 0.7) # Y的3个指标的载荷
)

# 上述Beta中系数坐标
indirect <- list(c(2, 1), c(3, 2), c(4, 3))

## 样本量计算
mutil_powerMed_pri <- semPower.powerMediation(
  type = "a-priori", alpha = .05, power = .80,
  Beta = Beta,
  indirect = list(
    c(2, 1),
    c(3, 2),
    c(4, 3)
  ),
  nullEffect = "ind = 0",
  loadings = loadings
)

summary(mutil_powerMed_pri)

## 事后功效分析
mutil_powerMed_hoc <- semPower.powerMediation(
  type = "post-hoc", alpha = .05, N = 300,
  Beta = Beta,
  indirect = list(
    c(2, 1),
    c(3, 2),
    c(4, 3)
  ),
  nullEffect = "ind = 0",
  loadings = loadings
)
summary(mutil_powerMed_hoc)
