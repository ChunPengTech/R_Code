library(tidytable)
library(tidyplots)

# 常用参数
# width linewidth

data(study)

# -------- 误差棒图 --------

# 均值标准误
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_data_points() |> 
  add_mean_dash() |> 
  add_sem_errorbar()

# 最值范围
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_data_points() |> 
  add_range_errorbar()

# 标准差
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_data_points() |> 
  add_sd_errorbar()

# 95CI
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_data_points() |> 
  add_ci95_errorbar()

# -------- 调整参数 --------

# 误差棒宽度
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_data_points() |> 
  add_sem_errorbar(width = 1)

# 误差棒粗细
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_data_points() |> 
  add_sem_errorbar(linewidth = 1)

# 