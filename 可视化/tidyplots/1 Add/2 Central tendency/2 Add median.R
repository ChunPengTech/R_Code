library(tidytable)
library(tidyplots)

# 常用参数
# alpha saturation accuracy fontsize color 

data(study)

study |> 
  group_by(treatment) |> 
  summarise(median_score = median(score))

# -------- 中位数图 --------

study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  add_median_bar()

study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  add_median_dash()


study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  add_median_dot()

study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  add_median_value()

study |> 
  tidyplot(
    x = treatment, y = score
  ) |> 
  add_median_line()

study |> 
  tidyplot(
    x = treatment, y = score
  ) |> 
  add_median_area()

# -------- 组合 --------

study |> 
  tidyplot(
    x = treatment, y = score
  ) |> 
  add_median_bar(alpha = 0.3) |> 
  add_median_dash() |> 
  add_median_dot(color = "red") |> 
  add_median_line() |> 
  add_median_value(color = "blue")

# -------- 调整参数 --------

# 透明度
study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  theme_minimal_y()|> 
  add_median_bar(alpha = 0.3)

# 饱和度
study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  theme_minimal_y()|> 
  add_median_bar(saturation = 0.5)

# 数值精度
study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  add_median_value(accuracy = 0.001)

# 字体大小
study |> 
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |> 
  add_median_value(fontsize = 8)

# 字体颜色
study |> 
  tidyplot(
    x = treatment, y = score
  ) |> 
  add_median_value(color = "orange")
