library(tidyplots)
library(tidytable)

# 常用参数
# x y linetype

data("animals")

# -------- 参考线 --------

animals |> 
  tidyplot(
    x = weight, y = speed
  ) |> 
  add_data_points() |> 
  add_reference_lines(x = 4000, y = c(100, 200))

# 更改参考线的类型

animals |> 
  tidyplot(
    x = weight, y = speed
  ) |> 
  add_data_points() |> 
  add_reference_lines(x = 4000, y = c(100, 200), linetype = "dotdash")
