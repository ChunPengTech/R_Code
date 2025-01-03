library(tidyplots)
library(tidytable)

# 常用参数
# all top left right bottom

data("animals")

# -------- 调整绘图区域填充 -------

# 调整前
animals |>
  tidyplot(
    x = weight, y = size,
    color = family
  ) |>
  add_data_points()

# 调整后

# 四周填充
animals |>
  tidyplot(
    x = weight, y = size,
    color = family
  ) |>
  add_data_points() |> 
  adjust_padding(all = 0.2)

# 顶部填充
animals |>
  tidyplot(
    x = weight, y = size,
    color = family
  ) |>
  add_data_points() |> 
  adjust_padding(top = 0.3)

# ...
