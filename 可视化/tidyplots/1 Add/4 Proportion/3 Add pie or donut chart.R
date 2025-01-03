library(tidyplots)
library(tidytable)

data("energy")

res <- energy |>
  group_by(energy_type) |>
  summarize(sum_power = sum(power), freq_type = n()) |>
  mutate(prop_power = sum_power / sum(sum_power), prop_type = freq_type / sum(freq_type))

# -------- 扇形图和环形图 --------

energy |> 
  tidyplot(
    color = energy_type
  ) |> 
  add_pie()

energy |> 
  tidyplot(
    color = energy_type
  ) |> 
  add_donut()

energy |> 
  tidyplot(
    y = power, color = energy_type
  ) |> 
  add_pie()

energy |> 
  tidyplot(
    y = power, color = energy_type
  ) |> 
  add_donut()
