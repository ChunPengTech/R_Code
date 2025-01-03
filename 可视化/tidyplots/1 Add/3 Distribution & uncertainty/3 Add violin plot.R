library(tidytable)
library(tidyplots)

# 常用参数
# saturation draw_quantiles trim linewidth

data(study)

# -------- 小提琴图 --------

study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_violin()

# -------- 调整参数 --------

# 饱和度
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_violin(saturation = 0.3)

# 添加分位数
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_violin(draw_quantiles = c(0.25, 0.5, 0.75))

# 截尾
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_violin(trim = TRUE)

# 线宽
study |> 
  tidyplot(
    x = treatment, y = score, 
    color = treatment
  ) |> 
  add_violin(linewidth = 1)
