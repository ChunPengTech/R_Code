library(tidyplots)
library(tidytable)

data("study")

# -------- 调整标题和注释 -------

# 调整前
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_data_points() |> 
  add_mean_bar(alpha = 0.3) |> 
  add_sem_errorbar()

# 调整后

study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_data_points() |> 
  add_mean_bar(alpha = 0.3) |> 
  add_sem_errorbar() |> 
  add_title("图标题") |> 
  adjust_x_axis_title("治疗组") |> 
  adjust_y_axis_title("得分") |> 
  adjust_legend_title("图例标题") |> 
  adjust_caption("新注释")
