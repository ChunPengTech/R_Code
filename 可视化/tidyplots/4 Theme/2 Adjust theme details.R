library(tidyplots)
library(tidytable)

# 常用参数
# new_colors

data("study")

# -------- 调整颜色 --------

study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  add_data_points_beeswarm() |> 
  add_mean_bar(alpha = 0.4) |> 
  adjust_theme_details(plot.background = ggplot2::element_rect(fill = "#FFEBFF"))
