library(tidyplots)
library(tidytable)

data("study")

# -------- 移除x轴或部分 --------

# 移除前
study %>%
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) %>%
  add_mean_bar()


# 移除后

# 移除x轴线
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar() |>
  remove_x_axis_line()

# 移除x轴刻度
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar() |>
  remove_x_axis_ticks()

# 移除x轴标签
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar() |>
  remove_x_axis_labels()

# 移除x轴标题
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar() |>
  remove_x_axis_title()

# 移除整个x轴
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar() |>
  remove_x_axis()
