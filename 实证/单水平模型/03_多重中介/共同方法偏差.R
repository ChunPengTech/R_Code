pacman::p_load(lavaan, bruceR, tidySEM)

set.wd()
data <- import("data304n.csv", as = "data.tibble")

# -------- 探索性因子分析 --------

EFA(data, varrange = "xa1:y5", hide.loadings = 0.5)

# -------- 验证性因子分析 --------

baseline <- "
xa =~ xa1+xa2+xa3+xa4+xa5+xa6
xb =~ xb1+xb2+xb3+xb4+xb5
ma =~ ma1+ma2+ma3
mb =~ mb1+mb2+mb3
mc =~ mc1+mc2+mc3
y =~ y1+y2+y3+y4+y5
"
baseline_model <- cfa(model = baseline, data = data)


five <- "
xa =~ xa1+xa2+xa3+xa4+xa5+xa6+
xb1+xb2+xb3+xb4+xb5

ma =~ ma1+ma2+ma3
mb =~ mb1+mb2+mb3
mc =~ mc1+mc2+mc3
y =~ y1+y2+y3+y4+y5
"
five_model <- cfa(model = five, data = data)


four <- "
xa =~ xa1+xa2+xa3+xa4+xa5+xa6+
xb1+xb2+xb3+xb4+xb5+
ma1+ma2+ma3

mb =~ mb1+mb2+mb3
mc =~ mc1+mc2+mc3
y =~ y1+y2+y3+y4+y5
"
four_model <- cfa(model = four, data = data)


three <- "
xa =~ xa1+xa2+xa3+xa4+xa5+xa6+
xb1+xb2+xb3+xb4+xb5+
ma1+ma2+ma3+
mb1+mb2+mb3
 
mc =~ mc1+mc2+mc3
y =~ y1+y2+y3+y4+y5
"
three_model <- cfa(model = three, data = data)


two <- "
xa =~ xa1+xa2+xa3+xa4+xa5+xa6+
xb1+xb2+xb3+xb4+xb5+
ma1+ma2+ma3+
mb1+mb2+mb3+
mc1+mc2+mc3

y =~ y1+y2+y3+y4+y5
"
two_model <- cfa(model = two, data = data)


one <- "
xa =~ xa1+xa2+xa3+xa4+xa5+xa6+
xb1+xb2+xb3+xb4+xb5+
ma1+ma2+ma3+
mb1+mb2+mb3+
mc1+mc2+mc3+
y1+y2+y3+y4+y5
"
one_model <- cfa(model = one, data = data)


bifactor <- "
xa =~ xa1+xa2+xa3+xa4+xa5+xa6
xb =~ xb1+xb2+xb3+xb4+xb5
ma =~ ma1+ma2+ma3
mb =~ mb1+mb2+mb3
mc =~ mc1+mc2+mc3
y =~ y1+y2+y3+y4+y5

G =~ xa1+xa2+xa3+xa4+xa5+xa6+
xb1+xb2+xb3+xb4+xb5+
ma1+ma2+ma3+
mb1+mb2+mb3+
mc1+mc2+mc3+
y1+y2+y3+y4+y5

G ~~ 0*xa
G ~~ 0*xb
G ~~ 0*ma
G ~~ 0*mb
G ~~ 0*mc
G ~~ 0*y
"
bifactor_model <- cfa(model = bifactor, data = data)

# -------- 汇总信息 --------

# 定义模型列表
models <- list(
  "Baseline model" = baseline_model,
  "Five-factor model" = five_model,
  "Four-factor model" = four_model,
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

# 将结果绑定在一起并打印
final_results <- bind_rows(results)
final_results |> print_table()


# ------- 卡方差异检验 -------

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
