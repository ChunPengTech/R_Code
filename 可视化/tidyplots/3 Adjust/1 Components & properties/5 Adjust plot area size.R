library(tidyplots)
library(tidytable)

# 常用参数
# wide height unit

data("study")

# -------- 调整绘图区域大小 -------

# 调整前
study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  add_data_points_beeswarm(shape = 1) |> 
  add_mean_bar(alpha = 0.4) |> 
  add_sem_errorbar()

# 调整后

study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  add_data_points_beeswarm(shape = 1) |> 
  add_mean_bar(alpha = 0.4) |> 
  add_sem_errorbar() |> 
  adjust_size(width = 20, height = 20)

# 设置单位
study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  add_data_points_beeswarm(shape = 1) |> 
  add_mean_bar(alpha = 0.4) |> 
  add_sem_errorbar() |> 
  adjust_size(width = 10, height = 10, unit = "cm")

# 利用所有空间
study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  add_data_points_beeswarm(shape = 1) |> 
  add_mean_bar(alpha = 0.4) |> 
  add_sem_errorbar() |> 
  adjust_size(width = NA, height = NA) |> 
  adjust_font(fontsize = 20)
