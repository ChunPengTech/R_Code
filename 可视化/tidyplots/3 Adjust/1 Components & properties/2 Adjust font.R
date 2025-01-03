library(tidyplots)
library(tidytable)

# 常用参数
# fontsize family face

data("study")

# -------- 调整字体 --------

# 调整前
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points_beeswarm() |>
  add_mean_bar(alpha = 0.4) |>
  add_sem_errorbar()

# 调整后

# 字体大小
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points_beeswarm() |>
  add_mean_bar(alpha = 0.4) |>
  add_sem_errorbar() |> 
  adjust_font(fontsize = 10)

# 字体
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points_beeswarm() |>
  add_mean_bar(alpha = 0.4) |>
  add_sem_errorbar() |> 
  adjust_font(family = "mono")

# 加粗
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points_beeswarm() |>
  add_mean_bar(alpha = 0.4) |>
  add_sem_errorbar() |> 
  adjust_font(face = "bold")