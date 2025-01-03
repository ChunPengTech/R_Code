library(tidytable)
library(tidyplots)

# 常用参数
# scale rasterize

data(study)

# -------- 线 --------

study |> 
  tidyplot(
    x = treatment, y = score, 
    color = group
  ) |> 
  reorder_x_axis_labels("A", "C", "B", "D") |> 
  add_data_points() |> 
  add_line(group = participant, color = "grey") # 组别一致连成线?

# -------- 区域 --------

study |> 
  tidyplot(
    x = treatment, y = score
  ) |> 
  reorder_x_axis_labels("A", "C", "B", "D") |> 
  add_data_points() |> 
  add_area(group = participant)
