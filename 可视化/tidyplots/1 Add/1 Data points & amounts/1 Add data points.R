library(tidytable)
library(tidyplots)

# 常用参数
# shape(0-24) size white_border dodge_width alpha filter_rows()

data(study)

# -------- 散点图 --------

study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points()

# -------- 添加抖动点和蜂蜜群图 --------

study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points_jitter()

study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points_beeswarm()


# -------- 调整参数 --------

# 抖动的宽度
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_data_points_jitter(jitter_width = 1)

# 散点外围添加白圈
animals |> 
  tidyplot(
    x = weight, y = size
  ) |> 
  add_data_points(white_border = TRUE)

# 调整点的透明度
animals |> 
  tidyplot(
    x = weight, y = size
  ) |> 
  add_data_points(alpha = 0.1)

# 栅格化:将矢量图形转换成位图的过程（调整像素大小？？）
animals |> 
  tidyplot(
    x = weight, y = size
  ) |> 
  add_data_points(rasterize = TRUE, rasterize_dpi = 20)

# 图内选取子集，更改属性（突出显示）
animals |> 
  tidyplot(
    x = weight, y = size
  ) |> 
  add_data_points() |> 
  add_data_points(filter_rows(size > 300), color = "red")
