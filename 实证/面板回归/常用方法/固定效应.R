# https://lrberge.github.io/fixest/

library(bruceR)
library(fixest)

set.wd()
data <- import("data.xlsx", as = "tibble")

# 可以设置标准误类型，比如"iid", "hetero"，默认是聚类（Time）

# -------- 固定年份 --------

time_fix <- feols(y ~ x + c1 + c6 + c7 + c8 | year, data)

# -------- 固定省份 --------

indv_fix <- feols(y ~ x + c1 + c6 + c7 + c8 | province, data)

# -------- 固定年份和省份 --------

two_fix <- feols(y ~ x + c1 + c6 + c7 + c8 | year + province, data, se = "hetero") # 异方差—稳健标准误

# -------- 汇总结果esttable --------

esttable(time_fix, indv_fix, two_fix, digits = 3)

# -------- 汇总结果modelsummary --------

modelsummary::modelsummary(list(time_fix, indv_fix, two_fix), stars = T, output = "data.frame") |> select(-part, -statistic)
