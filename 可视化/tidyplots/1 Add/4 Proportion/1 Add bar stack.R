library(tidyplots)
library(tidytable)

# 常用参数
# orientation

data("energy")

energy |>
  group_by(energy_type) |>
  summarize(sum_power = sum(power), freq_type = n()) |>
  mutate(prop_power = sum_power / sum(sum_power), prop_type = freq_type / sum(freq_type))

# -------- 堆积条形图 --------

# 频率
energy |>
  tidyplot(
    color = energy_type
  ) |>
  add_barstack_absolute()

energy |>
  tidyplot(
    color = energy_type
  ) |>
  add_barstack_relative()

# 求和
energy |>
  tidyplot(
    y = power,
    color = energy_type
  ) |>
  add_barstack_absolute()

energy |>
  tidyplot(
    y = power,
    color = energy_type
  ) |>
  add_barstack_relative()

# 增加x轴的变量
energy |>
  tidyplot(
    x = year, y = power,
    color = energy_type
  ) |>
  add_barstack_absolute()

energy |>
  tidyplot(
    x = year, y = power,
    color = energy_type
  ) |>
  add_barstack_relative()

# -------- 调换x和y轴 --------
energy |>
  tidyplot(
    x = power, y = year,
    color = energy_type
  ) |>
  add_barstack_absolute(orientation = "y")

energy |>
  tidyplot(
    x = power, y = year,
    color = energy_type
  ) |>
  add_barstack_relative(orientation = "y")
