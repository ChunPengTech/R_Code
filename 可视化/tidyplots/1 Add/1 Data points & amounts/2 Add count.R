library(tidytable)
library(tidyplots)

# 常用参数
# alpha saturation accuracy fontsize color

data(dinosaurs)

dinosaurs |>
  group_by(time_lived) |>
  count() |> 
  ungroup()

# -------- 频数图 --------

dinosaurs |>
  tidyplot(
    x = time_lived, color = time_lived
  ) |>
  adjust_x_axis(rotate_labels = TRUE) |> # 调整x轴的标签位置
  add_count_bar() |>
  add_count_value()

dinosaurs |>
  tidyplot(
    x = time_lived, color = time_lived
  ) |>
  adjust_x_axis(rotate_labels = TRUE) |>
  add_count_dash() |>
  add_count_value()

dinosaurs |>
  tidyplot(
    x = time_lived, color = time_lived
  ) |>
  adjust_x_axis(rotate_labels = TRUE) |>
  add_count_dot() |>
  add_count_value()

dinosaurs |>
  tidyplot(
    x = time_lived
  ) |>
  adjust_x_axis(rotate_labels = TRUE) |>
  add_count_line() |>
  add_count_value()

dinosaurs |>
  tidyplot(
    x = time_lived
  ) |>
  adjust_x_axis(rotate_labels = TRUE) |>
  add_count_area(alpha = 0.1) |>
  add_count_value()

# -------- 汇总 --------

dinosaurs |>
  tidyplot(
    x = time_lived
  ) |>
  adjust_x_axis(rotate_labels = TRUE) |>
  add_count_bar(alpha = 0.4) |>
  add_count_dash() |>
  add_count_dot() |>
  add_count_value() |>
  add_count_line()

# -------- 调整参数 --------

# 透明度
dinosaurs |>
  tidyplot(
    x = time_lived, color = time_lived
  ) |>
  theme_minimal_y() |>
  adjust_x_axis(rotate_labels = TRUE) |>
  add_count_bar(alpha = 0.4)

# 饱和度
dinosaurs |>
  tidyplot(
    x = time_lived, color = time_lived
  ) |>
  theme_minimal_y() |>
  adjust_x_axis(rotate_labels = TRUE) |>
  add_count_bar(saturation = 0.3)

# 数据精度
dinosaurs |>
  tidyplot(
    x = time_lived, color = time_lived
  ) |>
  adjust_x_axis(rotate_labels = TRUE) |>
  add_count_value(accuracy = 1)

# 字体大小
dinosaurs |>
  tidyplot(
    x = time_lived, color = time_lived
  ) |>
  adjust_x_axis(rotate_labels = TRUE) |>
  add_count_value(fontsize = 10)

# 字体颜色
dinosaurs |>
  tidyplot(
    x = time_lived, color = time_lived
  ) |>
  adjust_x_axis(rotate_labels = TRUE) |>
  add_count_value(color = "red")