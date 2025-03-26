library(bruceR)
library(fixest)

set.wd()
data <- import("data.xlsx", as = "tibble")

data <- data |>
  group_by(province) |>
  mutate(L.y = lag(y), L.x = lag(x))

iv_fix <- feols(y ~  c1 + c6 + c7 + c8 | year + province | x ~ L.x, data, se = "hetero")

# 查看工具变量法的结果
esttable(iv_fix, digits = 3)

# 查看第一阶段的结果
fitstat(iv_fix, ~ ivf1 + ivwald1 + ivf2 + ivwald2)

# 同时输出两阶段的结果
esttable(summary(iv_fix, stage = 1:2),fitstat = ~ ivf1 + ivwald1 + ivf2 + ivwald2)

## 提取固定效应系数，如年度固定效应，城市固定效应
fixedEffects <- fixef(iv_fix)
summary(fixedEffects)
plot(fixedEffects)
