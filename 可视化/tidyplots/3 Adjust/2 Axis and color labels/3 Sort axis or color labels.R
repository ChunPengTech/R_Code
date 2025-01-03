library(tidyplots)
library(tidytable)

data("study")

# -------- 坐标轴按大小排序 --------

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
  sort_x_axis_labels()

# -------- 图例按大小排序 --------

# 调整前
study |>
  tidyplot(
    x = group, y = score,
    color = treatment
  ) |>
  add_data_points() |>
  add_mean_bar(alpha = 0.4) |>
  add_sem_errorbar()

# 调整后
study |>
  tidyplot(
    x = group, y = score,
    color = treatment
  ) |>
  add_data_points() |>
  add_mean_bar(alpha = 0.4) |>
  add_sem_errorbar() |>
  sort_color_labels()

