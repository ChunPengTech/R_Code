pacman::p_load(
  lavaan, bruceR, tidySEM, tidyverse, semTools
)

set.wd()
data <- import("data304n.csv", as = "tibble")


# -------- 因子分析 --------

EFA(data, varrange = "xa1:y5")
check_factorstructure(data)

# -------- 验证性因子分析 --------

model <- "
xa =~ xa1+xa2+xa3+xa4+xa5+xa6
xb =~ xb1+xb2+xb3+xb4+xb5
ma =~ ma1+ma2+ma3
mb =~ mb1+mb2+mb3
mc =~ mc1+mc2+mc3
y =~ y1+y2+y3+y4+y5
"

fit <- cfa(model, data)
lavaan_summary(fit)

# -------- 信度与聚敛效度 --------

reliability(fit) %>% print_table(digits = 3)

# -------- 区分效度 --------

lavInspect(fit, "cor.lv")
matrix <- lavInspect(fit, "cor.lv")
diag(matrix) <- sqrt(AVE(fit))
## 将相关系数的对角线替换为AVE的平方根
matrix
