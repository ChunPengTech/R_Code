library(tidytable)
library(tidyplots)

# 常用参数
# method linewidth alpha se

data("time_course")

# -------- 拟合曲线 --------

time_course |> 
  tidyplot(
    x = day, y = score, 
    color = treatment
  ) |> 
  add_curve_fit(linewidth = 1)

time_course |> 
  tidyplot(
    x = day, y = score, 
    color = treatment
  ) |> 
  add_curve_fit(alpha = 0.8)

time_course |> 
  tidyplot(
    x = day, y = score, 
    color = treatment
  ) |> 
  add_curve_fit(se = FALSE)
