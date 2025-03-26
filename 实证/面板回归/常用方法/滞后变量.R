library(bruceR)

set.wd()
data <- import("data.xlsx", as = "tibble")

data |>
  group_by(province) |>
  mutate(L.x = lag(y), L.x = lag(x)) |>
  select(province, year, y, x, L.y, L.x) |>
  View()