library(tidyplots)
library(tidytable)

# 常用参数
# orientation

data("energy")

energy |>
  group_by(energy_type, year) |>
  summarize(sum_power = sum(power), freq_type = n())

# -------- 堆积条形图 --------

# 频率
energy |>
  tidyplot(
    x = year, color = energy_type
  ) |>
  add_areastack_absolute()

energy |>
  tidyplot(
    x = year, color = energy_type
  ) |>
  add_areastack_relative()

# 求和
energy |>
  tidyplot(
    x = year, y = power,
    color = energy_type
  ) |>
  add_areastack_absolute()

energy |>
  tidyplot(
    x = year, y = power,
    color = energy_type
  ) |>
  add_areastack_relative()

# -------- 调换x和y轴 --------
energy |>
  tidyplot(
    x = power, y = year,
    color = energy_type
  ) |>
  add_areastack_absolute(orientation = "y")

energy |>
  tidyplot(
    x = power, y = year,
    color = energy_type
  ) |>
  add_areastack_relative(orientation = "y")
