library(bruceR)

set.wd()
data <- import("data.xlsx", as = "tibble")

data <- data |>
  plm::pdata.frame(index = cc("province, year"))

# -------- Tobit模型 --------

library(AER)

model_tobit <- tobit(y ~ x + c1 + c6 + c7 + c8 + factor(province) + factor(year), data = data)

res1 <- summary(model_tobit)
res1$coefficients[1:6, ] |> print_table()

# -------- GLS模型 --------

library(nlme)

model_gls <- gls(y ~ x + c1 + c6 + c7 + c8 + factor(province) + factor(year), data = data)
res2 <- summary(model_gls)
res2$tTable[1:6, ] |> print_table()

# -------- 模型汇总 --------

modelsummary::modelsummary(list(model_tobit, model_gls), stars = T)
             