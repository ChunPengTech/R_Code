library(tidyplots)
library(tidytable)

data("animals")

# -------- 移除标题或注释 --------

# 多此一举 :)

# 移除前
animals |> 
  tidyplot(
    x = weight, y = speed,
    color = family
  ) %>%
  add_data_points() |> 
  add_title("Name of the plot") |> 
  add_caption("This is the caption")

# 移除后

# 移除标题
animals |> 
  tidyplot(
    x = weight, y = speed,
    color = family
  ) |> 
  add_data_points() |> 
  add_title("Name of the plot") |> 
  add_caption("This is the caption") |> 
  remove_title()

# 移除注释
animals |> 
  tidyplot(
    x = weight, y = speed,
    color = family
  ) |> 
  add_data_points() |> 
  add_title("Name of the plot") |> 
  add_caption("This is the caption") |> 
  remove_caption()
