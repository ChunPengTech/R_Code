library(tidyplots)
library(tidytable)

# 常用参数
# title limits padding

data("animals")

# -------- 调整坐标轴 -------

# 调整前
animals |>
  tidyplot(
    x = weight, y = size,
    color = family
  ) |>
  add_data_points()

# 调整后

# 坐标轴标题
animals |>
  tidyplot(
    x = weight, y = size,
    color = family
  ) |>
  add_data_points() |> 
  adjust_x_axis(title = "治疗组") |>  # adjust_x_axis_title()
  adjust_y_axis(title = "得分")

# 坐标轴范围
animals |>
  tidyplot(
    x = weight, y = size,
    color = family
  ) |>
  add_data_points() |> 
  adjust_x_axis(limits = c(-1000, 4000)) |> 
  adjust_y_axis(limits = c(-200, 600))

# 坐标轴标签旋转
animals |>
  tidyplot(
    x = weight, y = size,
    color = family
  ) |>
  add_data_points() |> 
  adjust_x_axis(rotate_labels = 90)

# 绘图区域填充
animals |>
  tidyplot(
    x = weight, y = size,
    color = family
  ) |>
  add_data_points() |> 
  adjust_x_axis(padding = c(0.2, 0.2)) |> 
  adjust_y_axis(padding = c(0.2, 0.2))

# 刻度变换
animals |>
  tidyplot(
    x = weight, y = size,
    color = family
  ) |>
  add_data_points() |> 
  adjust_x_axis(transform = "log10") |> 
  adjust_y_axis(transform = "log2")
