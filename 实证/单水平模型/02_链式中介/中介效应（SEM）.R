pacman::p_load(
  lavaan, bruceR, tidySEM, tidyverse, semPlots
)

set.wd()
data <- import("data_298.csv", as = "data.frame")

# -------- 主效应 --------

model1 <- "
x =~ x1+x2+x3+x4+x5
y =~ y1+y2+y3+y4+y5+y6

y ~ c*x
"

fit1 <- sem(model = model1, data = data)

goodfit <- table_fit(fit1)
goodfit |> 
  mutate("chisq/df" = chisq / df) |>
  select(chisq, df, "chisq/df", cfi, tli, rmsea, srmr) |>
  print_table()

lavaan_summary(fit1)

semPaths(fit1,
  whatLabels = "std",
  layout = "spring",
  color = "skyblue",
  edge.label.cex = 1
)

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

fit2 <- sem(model = model2, data = data)

lavaan_summary(fit2)

semPaths(fit2,
  whatLabels = "std",
  layout = "spring",
  color = "lightblue",
  edge.label.cex = 1
)

# -------- bootstrap --------

set.seed(1)
fit2_boot <- sem(
  model = model2, data = data,
  se = "bootstrap", bootstrap = 100
)
lavaan_summary(fit2_boot) ## 默认percent的置信区间

## bcboot
bca <- parameterEstimates(fit2_boot, boot.ci.type = "bca.simple", standardized = T)
names(bca)

bca_res <- bca |>
  mutate(B = est, β = std.all) |>
  select(
    lhs, op, rhs,
    B, β,
    se, ci.lower, ci.upper,
    z, pvalue
  ) |>
  filter(op == "~" | op == ":=")

print_table(bca_res)
