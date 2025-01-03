library(tidytable)
library(tidyplots)

# 常用参数
# alpha saturation accuracy fontsize color 

data(study)

study |> 
  group_by(treatment) |> 
  summarise(mean_score = mean(score), sum_score = sum(score)) |> 
  ungroup()

# -------- 均值图 --------

study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_mean_bar()

study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_mean_dash()

study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_mean_dot()

study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_mean_value()

study |> 
  tidyplot(
    x = treatment, y = score
  ) |> 
  add_mean_line()

study |> 
  tidyplot(
    x = treatment, y = score
  ) |> 
  add_mean_area()

# -------- 调整参数 --------

# 透明度
study |> 
  tidyplot(
    x = treatment, y = score, color = treatment
  ) |> 
  theme_minimal_y() |> 
  add_mean_bar(alpha = 0.3)

# 饱和度
study |> 
  tidyplot(
    x = treatment, y = score, color = treatment
  ) |> 
  theme_minimal_y() |> 
  add_mean_bar(saturation = 0.5)

# 数值精度
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_mean_value(accuracy = 0.1)

# 字体大小
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_mean_value(fontsize = 10)

# 字体颜色
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_mean_value(color = "red")
