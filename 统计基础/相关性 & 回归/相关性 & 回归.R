pacman::p_load(
  bruceR, easystats, sjPlot, apaTables, autoReg
)

data(mtcars)
check_kmo(mtcars)
check_sphericity_bartlett(mtcars)
check_factorstructure(mtcars)
EFA(mtcars, varrange = "mpg:carb")

# ---------------- 相关性分析 ----------------

Corr(mtcars)

res <- correlation(mtcars)
res |> summary()

tab_corr(mtcars,
  triangle = "lower",
  digits = 3
)

apa.cor.table(mtcars,
  table.number = 1
)

# ---------------- 回归 ----------------

fit <- lm(mpg ~ wt + am + gear + vs * cyl, data = mtcars)
fit
summary(fit)

GLM_summary(fit)
model_summary(fit)

apa.reg.table(fit)

tab_model(fit)
model_parameters(fit)
model_performance(fit) # 模型性能
check_collinearity(fit) # 共线性
check_outliers(fit) # 离群值
check_normality(fit) # 正态性
model_dashboard(fit) # 仪表盘

broom::tidy(fit) |> tab_df(digits = 3)
broom::glance(fit) |> tab_df(digits = 3)

autoReg(fit)
gaze(fit)