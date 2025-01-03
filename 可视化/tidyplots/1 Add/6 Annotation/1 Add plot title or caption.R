library(tidyplots)
library(tidytable)

data(study)

# -------- 标题或注释 --------

study |> 
  tidyplot(
    x = treatment, y = score
  ) |> 
  add_data_points_beeswarm() |> 
  add_title("这是标题")

study |> 
  tidyplot(
    x = treatment, y = score
  ) |> 
  add_data_points_beeswarm() |> 
  add_caption("这是注释")

# 标题添加数学表达式
study |> 
  tidyplot(
    x = treatment, y = score
  ) |> 
  add_data_points_beeswarm() |> 
  add_title("$H[2]*O~and~E == m*c^{2}$")
