library(tidytable)
library(tidyplots)

# 常用参数
# alpha

data(time_course)

# -------- 丝带图 --------

# 均值标准误
time_course |> 
  tidyplot(
    x = day, y = score, 
    color = treatment
  ) |> 
  add_mean_line() |> 
  add_sem_ribbon()

# 最值范围
time_course |> 
  tidyplot(
    x = day, y = score, 
    color = treatment
  ) |> 
  add_mean_line() |> 
  add_range_ribbon()

# 标准误
time_course |> 
  tidyplot(
    x = day, y = score, 
    color = treatment
  ) |> 
  add_mean_line() |> 
  add_sd_ribbon()

# 95CI
time_course |> 
  tidyplot(
    x = day, y = score, 
    color = treatment
  ) |> 
  add_mean_line() |> 
  add_ci95_ribbon()
  