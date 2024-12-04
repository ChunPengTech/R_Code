library(semPower)

# 参见 https://moshagen.github.io/semPower/#powerMediation


Beta <- matrix(c(
  c(.00, .00, .00, .00), # f1 = .00*f1 + .00*f2 + .00*f3 + .00*f4
  c(.20, .00, .00, .00), # f2 = .20*f1 + .00*f2 + .00*f3 + .00*f4
  c(.20, .30, .00, .00), # f3 = .20*f1 + .30*f2 + .00*f3 + .00*f4
  c(.10, .30, .40, .00) # f4 = .10*f1 + .20*f2 + .40*f3 + .00*f4
), byrow = TRUE, ncol = 4)

nullWhich <- c(4, 3)

powerPath <- semPower.powerPath(
  # define type of power analysis
  type = "a-priori", alpha = .05, power = .80,
  # define hypothesis
  Beta = Beta,
  nullEffect = "beta = 0",
  nullWhich = nullWhich, # 坐标(4,1)的路径系数
  # define measurement model
  nIndicator = c(4, 4, 5, 6),
  loadM = c(.7, .7, .7, .7),
)

summary(powerPath)
