library(tidyplots)
library(tidytable)

data("study")

# -------- 重排坐标轴标签 --------

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
  reorder_x_axis_labels("D", "B", "A")


# -------- 重命名图例标签 --------

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
  reorder_color_labels("low")
