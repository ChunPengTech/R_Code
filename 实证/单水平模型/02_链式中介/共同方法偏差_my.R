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

# ------- 汇总信息 -------

# 定义模型列表
models <- list(
  "Baseline model" = baseline_model,
  "Three-factor model" = three_model,
  "Two-factor model" = two_model,
  "Single-factor model" = one_model,
  "Bifactor model" = bifactor_model
)

# 使用 lapply 循环遍历模型，计算拟合指标并整理结果
results <- lapply(names(models), function(model_name) {
  model <- models[[model_name]]

  # 计算拟合指标
  fitted <- table_fit(model)

  # 创建新的数据框并添加模型名称
  fitted |>
    mutate(
      "χ2/df" = chisq / df,
      "χ2" = chisq,
      CFI = cfi,
      TLI = tli,
      RMSEA = rmsea,
      SRMR = srmr,
      Model = model_name
    ) |>
    select(Model, "χ2", df, "χ2/df", CFI, TLI, RMSEA, SRMR)
})

# 将结果合并在一起并输出
final_results <- bind_rows(results)
final_results |> print_table()


# ------- 卡方差异检验1 -------

diff_results <- final_results %>%
  mutate(
    Δχ2 = abs(χ2 - χ2[Model == "Baseline model"]),
    Δdf = abs(df - df[Model == "Baseline model"]),
    p = p.chi2(Δχ2, Δdf)
  )

# 显示结果
diff_results |> print_table()


# ------- 卡方差异检验2 -------

# 获取基准模型的模型值
baseline_values <- final_results |>
  filter(Model == "Baseline model")

# 计算其他模型的差值
other_values <- final_results |>
  filter(Model != "Baseline model") |>
  mutate(
    Δχ2 = abs(χ2 - baseline_values$χ2),
    Δdf = abs(df - baseline_values$df),
    p = p.chi2(Δχ2, Δdf)
  )

# 合并并输出结果
model_results <- bind_rows(baseline_values, other_values)
model_results |> print_table()
