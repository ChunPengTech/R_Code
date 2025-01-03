library(tidytable)
library(tidyplots)

# 常用参数
# binwidth bins

data("energy")

# -------- 直方图 --------

energy |> 
  tidyplot(
    x = power
  ) |> 
  add_histogram()

energy |> 
  tidyplot(
    x = power, color = energy_type
  ) |> 
  add_histogram()

