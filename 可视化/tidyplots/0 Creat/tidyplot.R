library(tidytable)
library(tidyplots)

# tidyplot内一般是x，y和color三个参数

# -------- 添加数据点 --------

study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points() |>
  add_data_points_beeswarm()

study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points_jitter()

# 添加蜜蜂群和抖动都可以将重合的点单独显示出来

# -------- 添加均值条形图 --------

study |>
  group_by(group, dose) |>
  summarise(mean = mean(score)) |> 
  ungroup()

study |>
  tidyplot(
    x = group, y = score,
    color = dose
  ) |>
  add_mean_bar()

# -------- 更改画布大小，默认是50*50 --------

study %>%
  tidyplot(
    x = treatment, y = score,
    color = treatment,
    width = 80, height = 80
  ) %>%
  add_data_points_beeswarm()

# -------- 更改分组内组件之间的距离 --------

study |>
  tidyplot(
    x = group, y = score,
    color = dose,
    dodge_width = 0.6
  ) |>
  add_mean_bar()