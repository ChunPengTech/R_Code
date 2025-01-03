library(tidyplots)
library(tidytable)

data("study")

# -------- 移除填充区 --------

# 移除前
animals |>
  tidyplot(
    x = weight, y = speed,
    color = family
  ) |>
  add_data_points()

# 移除后
animals |>
  tidyplot(
    x = weight, y = speed,
    color = family
  ) |>
  add_data_points() |>
  remove_padding()
