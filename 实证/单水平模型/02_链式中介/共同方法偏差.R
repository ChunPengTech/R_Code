library(lavaan)
library(bruceR)
library(tidySEM)

set.wd()
data <- import("data_298.csv", as = "tibble")

# ------- 探索性因子分析 -------

EFA(data, varrange = "x1:y6", hide.loadings = 0.5)

# ------- 验证性因子分析 -------

baseline <- "
x =~ x1+x2+x3+x4+x5
ma =~ ma1+ma2+ma3+ma4+ma5
mb =~ mb1+mb2+mb3+mb4+mb5+mb6
y =~ y1+y2+y3+y4+y5+y6
"
baseline_model <- cfa(model = baseline, data = data)

three <- "
x =~ x1+x2+x3+x4+x5+
ma1+ma2+ma3+ma4+ma5

mb =~ mb1+mb2+mb3+mb4+mb5+mb6

y =~ y1+y2+y3+y4+y5+y6
"

three_model <- cfa(model = three, data = data)

two <- "
x =~ x1+x2+x3+x4+x5+
ma1+ma2+ma3+ma4+ma5+
mb1+mb2+mb3+mb4+mb5+mb6

y =~ y1+y2+y3+y4+y5+y6
"

two_model <- cfa(model = two, data = data)

one <- "
x =~ x1+x2+x3+x4+x5+
ma1+ma2+ma3+ma4+ma5+
mb1+mb2+mb3+mb4+mb5+mb6+
y1+y2+y3+y4+y5+y6
"
one_model <- cfa(model = one, data = data)

bifactor <- "
x =~ x1+x2+x3+x4+x5
ma =~ ma1+ma2+ma3+ma4+ma5
mb =~ mb1+mb2+mb3+mb4+mb5+mb6
y =~ y1+y2+y3+y4+y5+y6

G =~ x1+x2+x3+x4+x5+
ma1+ma2+ma3+ma4+ma5+
mb1+mb2+mb3+mb4+mb5+mb6+
y1+y2+y3+y4+y5+y6
"

bifactor_model <- cfa(model = bifactor, data = data, orthogonal = TRUE)

goodfit_bifactor <- table_fit(bifactor_model)

goodfit_bifactor |>
  mutate("χ2/df" = chisq / df, "χ2" = chisq, model = "bifactor") |>
  select(model, "χ2", df, "χ2/df", cfi, tli, rmsea, srmr) |>
  print_table()


# ------- 汇总信息 -------

mylist <- list(baseline, three, two, one, bifactor)
label <- cc("baseline, three, two, one, bifactor")

result <- rbindlist(lapply(mylist, function(model) {
  cfa <- cfa(model, data = data)
  fit <- summary(cfa, estimate = F, fit.measures = T)
  result <- data.frame(
    ID = label[[which(model == mylist)]],
    χ2 = fit[["fit"]][["chisq"]],
    df = fit[["fit"]][["df"]],
    `χ2/df` = fit[["fit"]][["chisq"]] / fit[["fit"]][["df"]],
    CFI = fit[["fit"]][["cfi"]],
    TLI = fit[["fit"]][["tli"]],
    RMSEA = fit[["fit"]][["rmsea"]],
    SRMR = fit[["fit"]][["srmr"]],
    check.names = F
  )
  return(result)
})) |>
  print_table()
