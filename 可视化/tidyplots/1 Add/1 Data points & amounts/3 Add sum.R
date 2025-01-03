library(tidytable)
library(tidyplots)

# 常用参数
# alpha saturation accuracy fontsize color extra_padding

data("spendings")

spendings |>
  group_by(category) |>
  summarise(sum_amount = sum(amount)) |> 
  ungroup()

dinosaurs |> ungroup()

# -------- 求和图 --------

spendings |> 
  tidyplot(
    x = category, y = amount,
    color = category
  ) |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_bar()

spendings |> 
  tidyplot(
    x = category, y = amount,
    color = category
  ) |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_dash()

spendings |> 
  tidyplot(
    x = category, y = amount,
    color = category
  ) |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_dot()

spendings |> 
  tidyplot(
    x = category, y = amount,
    color = category
  ) |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_value()

spendings |> 
  tidyplot(
    x = category, y = amount
  ) |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_line()

spendings |> 
  tidyplot(
    x = category, y = amount
  ) |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_area()

# -------- 组合 --------

spendings |> 
  tidyplot(
    x = category, y = amount
  ) |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_bar(alpha = 0.3) |> 
  add_sum_dash() |> 
  add_sum_dot() |> 
  add_sum_value() |> 
  add_sum_line()

# -------- 调整参数 --------

# 透明度
spendings |> 
  tidyplot(x = category, y = amount, color = category) |> 
  theme_minimal_y() |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_bar(alpha = 0.3)

# 饱和度
spendings |> 
  tidyplot(x = category, y = amount, color = category) |> 
  theme_minimal_y() |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_bar(saturation = 0.3)

# 数值精度
spendings |> 
  tidyplot(x = category, y = amount, color = category) |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_value(accuracy = 1)

# 字体大小
spendings |> 
  tidyplot(x = category, y = amount, color = category) |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_value(fontsize = 10)

# 字体颜色
spendings |> 
  tidyplot(x = category, y = amount, color = category) |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_value(color = "blue")

# 顶部额外填充空白空间
spendings |> 
  tidyplot(x = category, y = amount, color = category) |> 
  adjust_x_axis(rotate_labels = TRUE) |> 
  add_sum_bar() |> 
  add_sum_value(extra_padding = 0.1)
