library(seminr)
library(bruceR)

set.wd()
data <- import("data_298.csv", as = "data.frame")

simple_mm <- constructs(
  reflective("X", multi_items("x", 1:8)),
  reflective("MA", multi_items("ma", 1:8)),
  reflective("MB", multi_items("mb", 1:7)),
  reflective("Y", multi_items("y", 1:5))
)

simple_sm <- relationships(
  paths(from = "X", to = c("MA", "MB", "Y")),
  paths(from = "MA", to = c("MB", "Y")),
  paths(from = "MB", to = "Y")
)

cb_model <- estimate_cbsem(
  data,
  simple_mm,
  simple_sm
)
summary_cb <- summary(cb_model)

summary_cb$paths$significance

plot(cb_model)
