library(tidyplots)
library(tidytable)

# 常用参数
# new_colors

data("study")

# -------- 调整颜色 --------

# 调整前
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_mean_bar(alpha = 0.3) |> 
  add_sem_errorbar()

# 调整后

# 16进制颜色
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_mean_bar(alpha = 0.3) |> 
  add_sem_errorbar() |> 
  adjust_colors(new_colors = c("#644296","#F08533","#3B78B0", "#D1352C"))

# 离散色彩
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_mean_bar(alpha = 0.3) |> 
  add_sem_errorbar() |> 
  adjust_colors(new_colors = colors_discrete_seaside)

# 色彩名称
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_mean_bar(alpha = 0.3) |> 
  add_sem_errorbar() |> 
  adjust_colors(new_colors = c(
    "A" = "pink",
    "B" = "purple",
    "C" = "grey",
    "D" = "blue"
  ))

# 连续色彩
climate |> 
  tidyplot(x = month, y = year, color = max_temperature) |> 
  add_heatmap() |> 
  adjust_colors(new_colors = colors_continuous_turbo)