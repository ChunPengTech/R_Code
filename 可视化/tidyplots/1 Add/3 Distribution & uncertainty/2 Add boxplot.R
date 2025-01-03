library(tidytable)
library(tidyplots)

# 常用参数
# show_whiskers show_outliers box_width whiskers_width outlier.size linewidth

data(study)

# -------- 箱线图 --------

study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_boxplot()

# -------- 调整参数 --------

# 是否展示箱线图的线
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_boxplot(show_whiskers = FALSE)

# 是否展示异常值
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_boxplot(show_outliers = TRUE)

# 框宽
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_boxplot(box_width = 0.3)

# 线宽
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_boxplot(whiskers_width = 0.3)

# 