library(tidyplots)
library(tidytable)

data("study")

# -------- 调整图例 -------

# 调整前
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_data_points_beeswarm() |> 
  add_mean_bar(alpha = 0.3) |> 
  add_sem_errorbar()

# 调整后

# 图例标题
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_data_points_beeswarm() |> 
  add_mean_bar(alpha = 0.3) |> 
  add_sem_errorbar() |> 
  adjust_legend_title("图例标题")

# 带数学表达式的图例标题  
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_data_points_beeswarm() |> 
  add_mean_bar(alpha = 0.3) |> 
  add_sem_errorbar() |> 
  adjust_legend_title("$E==m*c^{2}$")

# 图例位置
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_data_points_beeswarm() |> 
  add_mean_bar(alpha = 0.3) |> 
  add_sem_errorbar() |> 
  adjust_legend_position("left")
