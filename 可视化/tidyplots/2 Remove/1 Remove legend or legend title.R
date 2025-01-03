library(tidyplots)
library(tidytable)

data("study")

# -------- 移除图例或图例标题 --------

# 移除前
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar()


# 移除后

# 移除图例标题
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar() |>
  remove_legend_title()

# 移除图例(包括标题)
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_bar() |>
  remove_legend()