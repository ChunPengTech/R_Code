library(tidyplots)
library(tidytable)

data("study")

# -------- 倒转轴 --------

# 调整前
study |>
  tidyplot(x = treatment, y = score) |>
  add_data_points() |>
  add_mean_bar(alpha = 0.4) |>
  add_sem_errorbar()

# 调整后
study |>
  tidyplot(x = treatment, y = score) |>
  add_data_points() |>
  add_mean_bar(alpha = 0.4) |>
  add_sem_errorbar() |> 
  reverse_x_axis_labels()

# -------- 倒转颜色标签 --------

# 调整前
study |>
  tidyplot(
    x = group, y = score,
    color = dose
  ) |>
  add_data_points() |>
  add_mean_bar(alpha = 0.4) |>
  add_sem_errorbar()

# 调整后
study |>
  tidyplot(
    x = group, y = score,
    color = dose
  ) |>
  add_data_points() |>
  add_mean_bar(alpha = 0.4) |>
  add_sem_errorbar() |> 
  reverse_color_labels()
