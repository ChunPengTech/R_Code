library(tidyplots)
library(tidytable)

# 常用参数
# label label_position color background background_color

data("animals")

# -------- 数据标签 --------

p <- animals |> 
  slice_head(n = 5) |> 
  tidyplot(
    x = weight, y = speed
  ) |> 
  theme_ggplot2() |> 
  add_data_points() |> 
  adjust_padding(all = 0.3)

p |> 
  add_data_labels(label = animal)

# 更改标签颜色
p |> 
  add_data_labels(label = animal, color = "black")

# 更改标签位置
p |> 
  add_data_labels(label = animal, label_position = "above")

# 添加标签背景(默认白色)
p |> 
  add_data_labels(label = animal, background = TRUE)

# 更改标签背景颜色
p |> 
  add_data_labels(label = animal, background = TRUE, background_color = "grey")

# 使用排斥性数据标签(防止标签重叠)
p |> 
  add_data_labels_repel(label = animal)


p |>  add_data_labels_repel(
  label = animal, color = "black", 
  background = TRUE, min.segment.length = 0)
