# Rosseel, Y., & Loh, W. W. (2024). A structural after measurement approach to structural equation modeling. Psychological Methods, 29(3), 561–588.

pacman::p_load(
  bruceR, lavaan, tidytable
)

set.wd()
data <- import("data_298.csv", as = "data.frame")

# -------- 主效应 --------

model1 <- "
x =~ x1+x2+x3+x4+x5
y =~ y1+y2+y3+y4+y5+y6

y ~ c*x
"

# ----- sem -----

fit1 <- sem(model = model1, data = data)
parameterEstimates(fit1, standardized = T) |> 
  filter(op == "~") |>
  rename(B = est, β = std.lv) |>
  select(
    lhs, op, rhs,
    B, β,
    se, ci.lower, ci.upper,
    z, pvalue
  ) |> print_table()

# ----- sam -----

fit1_sam <- sam(model = model1, data = data)

summary(fit1_sam, remove.step1 = F, standardized = T)

parameterEstimates(fit1_sam, standardized = T) |> 
  filter(op == "~") |>
  rename(B = est, β = std.all) |>
  select(
    lhs, op, rhs,
    B, β,
    se, ci.lower, ci.upper,
    z, pvalue
  ) |> print_table()

# -------- 中介效应 --------

model2 <- "
x =~ x1+x2+x3+x4+x5
ma =~ ma1+ma2+ma3+ma4+ma5
mb =~ mb1+mb2+mb3+mb4+mb5+mb6
y =~ y1+y2+y3+y4+y5+y6

ma ~ a1*x
mb ~ d*ma+a2*x
y ~ cdash*x+b1*ma+b2*mb

med1 := a1*b1
med2 := a2*b2
chainmed := a1*d*b2
diff1 := med1-chainmed
diff2 := med2-chainmed
diff3 := med1 - med2
"

# ----- sem -----

fit2 <- sem(model = model2, data = data)
parameterEstimates(fit2, standardized = T) |>
  filter(op == "~" | op == ":=") |>
  rename(B = est, β = std.all) |>
  select(
    lhs, op, rhs,
    B, β,
    se, ci.lower, ci.upper,
    z, pvalue
  ) |> print_table()

# ----- sam -----

fit2_sam <- sam(model = model2, data = data)

res2_sam <- summary(fit2_sam, remove.step1 = F, standardized = T, ci = T)
res2_sam$pe |> 
  filter(op == "~" | op == ":=") |>
  rename(B = est, β = std.all) |>
  select(
    lhs, op, rhs,
    B, β,
    se, ci.lower, ci.upper,
    z, pvalue
  ) |> print_table()
