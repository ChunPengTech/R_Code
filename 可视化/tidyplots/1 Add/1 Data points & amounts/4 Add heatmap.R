library(tidytable)
library(tidyplots)

# 常用参数
# scale rasterize

data("climate")

# -------- 热图 --------

climate |> 
  tidyplot(
    x = month, y = year, 
    color = max_temperature
  ) |> 
  add_heatmap()


# 按行z值标准化
climate |> 
  tidyplot(
    x = month, y = year, 
    color = max_temperature
  ) |> 
  add_heatmap(scale = "row")

# # 按列z值标准化
climate |> 
  tidyplot(
    x = month, y = year, 
    color = max_temperature
  ) |> 
  add_heatmap(scale = "column")

# 栅格化
climate |> 
  tidyplot(
    x = month, y = year, 
    color = max_temperature
  ) |> 
  add_heatmap(rasterize = TRUE, rasterize_dpi = 30)