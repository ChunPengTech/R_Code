library(tidyplots)
library(tidytable)

data("study")

# -------- 移除y轴或部分 --------

# 移除前
study %>%
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) %>%
  add_mean_bar()


# 移除后

# 移除y轴线
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar() |>
  remove_y_axis_line()

# 移除y轴刻度
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar() |>
  remove_y_axis_ticks()

# 移除y轴标签
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar() |>
  remove_y_axis_labels()

# 移除y轴标题
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar() |>
  remove_y_axis_title()

# 移除整个y轴
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar() |>
  remove_y_axis()
