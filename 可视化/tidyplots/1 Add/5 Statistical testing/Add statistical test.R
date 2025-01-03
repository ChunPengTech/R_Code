library(tidyplots)
library(tidytable)

# 常用参数
# method p.adjust.method ref.group hide.ns padding_top hide_info

data(study)

# -------- 分组检验图 --------

p1 <- study |>
  tidyplot(
    x = dose, y = score,
    color = group
  ) |>
  add_mean_dash() |>
  add_data_points() |>
  add_sem_errorbar() |>
  add_test_pvalue()
# add_test_asterisks()

study |>
  tidyplot(
    x = dose, y = score,
    color = group
  ) |>
  add_mean_dash() |>
  add_data_points() |>
  add_sem_errorbar() |>
  add_test_pvalue(method = "wilcoxon", p.adjust.method = "BH")

# -------- 调整参数 --------

# 定义参考组
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_dash() |>
  add_data_points() |>
  add_sem_errorbar() |>
  add_test_pvalue(ref.group = "A")

# 隐藏不显著的p值
gene_expression |>
  filter(external_gene_name == "Apol6") |>
  tidyplot(
    x = condition, y = expression,
    color = sample_type
  ) |>
  add_mean_dash() |>
  add_sem_errorbar() |>
  add_data_points() |>
  add_test_pvalue(hide.ns = TRUE)

# 数据点上方的额外填充以适应统计比较
study |>
  tidyplot(
    x = treatment, y = score,
    color = treatment
  ) |>
  add_mean_dash() |>
  add_sem_errorbar() |>
  add_data_points() |>
  add_test_pvalue(padding_top = 0.08)

# 隐藏统计信息
study |>
  tidyplot(
    x = dose, y = score,
    color = group
  ) |>
  add_mean_dash() |>
  add_sem_errorbar() |>
  add_data_points() |>
  add_test_pvalue(hide_info = TRUE)
