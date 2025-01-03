library(tidyplots)
library(tidytable)

# 常用参数
# new_names

data("study")

# -------- 重命名坐标轴标签 --------

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
  rename_x_axis_labels(new_names = c(
    "A" = "AA",
    "B" = "BB",
    "C" = "CC",
    "D" = "DD"
  )) |>
  flip_plot()


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
  rename_color_labels(new_names = c(
    "high" = "Sky high",
    "low" = "Deep low"
  ))
