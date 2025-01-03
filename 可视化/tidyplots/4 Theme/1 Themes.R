library(tidyplots)
library(tidytable)

data("study")

# -------- 调整主题 --------

study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points() |>
  add_sem_errorbar() |>
  add_mean_dash() |>
  theme_tidyplot()


study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points() |>
  add_sem_errorbar() |>
  add_mean_dash() |>
  theme_ggplot2()


study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points() |>
  add_sem_errorbar() |>
  add_mean_dash() |>
  theme_minimal_xy()


study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points() |>
  add_sem_errorbar() |>
  add_mean_dash() |>
  theme_minimal_x()


study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points() |>
  add_sem_errorbar() |>
  add_mean_dash() |>
  theme_minimal_y()
