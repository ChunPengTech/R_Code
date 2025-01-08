pacman::p_load(
  lavaan, bruceR, tidySEM
)

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


# ------- 汇总信息 -------

mylist <- list(baseline_model, three_model, two_model, one_model, bifactor_model)
label <- cc("baseline_model, three_model, two_model, one_model, bifactor_model")

# 初始化结果数据框
result <- data.frame()

# 使用循环迭代拟合结果
for (i in seq_along(mylist)) {
  cfa_model <- mylist[[i]]
  fit <- summary(cfa_model, estimate = F, fit.measures = T)

  # 将结果存储在数据框中
  result <- rbind(result, data.frame(
    ID = label[i],
    χ2 = fit[["fit"]][["chisq"]],
    df = fit[["fit"]][["df"]],
    `χ2/df` = fit[["fit"]][["chisq"]] / fit[["fit"]][["df"]],
    CFI = fit[["fit"]][["cfi"]],
    TLI = fit[["fit"]][["tli"]],
    RMSEA = fit[["fit"]][["rmsea"]],
    SRMR = fit[["fit"]][["srmr"]],
    check.names = F
  ))
}

# 打印结果
print_table(result)
