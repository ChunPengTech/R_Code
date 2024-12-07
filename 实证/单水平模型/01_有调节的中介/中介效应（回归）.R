library(bruceR)
set.wd()
data <- import("main variable.xlsx", as = "data.frame")

# -------- Baron & Kenny’s 逐步法 --------

# 因果逐步回归法 Baron & Kenny’s (1986)
# 1.做X到Y的回归，得到总效应c（可以不显著）
# 2.做X到M的回归，得到路径a，a必须显著
# 3.控制X做M到Y的回归，得到路径b和c'，b必须显著
# 做Y到X的回归，一定不显著（不是必须）

fit <- lm(IKS ~ DT, data) # 1.总效应c
summary(fit)
GLM_summary(fit) ## 一般线性模型汇总

fita <- lm(KF ~ DT, data) # 2.路径a
summary(fita)

fitb <- lm(IKS ~ KF + DT, data) # 3.路径b, c'
summary(fitb)
GLM_summary(fitb)
print_table(fitb, file = "Results.doc")

fitc <- lm(DT ~ IKS + KF, data) # 4.反向路径
summary(fitc)

library(stargazer)
stargazer(fit, fita, fitb, fitc,
  type = "html",
  title = "Baron and Kenny Method",
  out = "test.html"
)

## or
model_summary(list(fit, fita, fitb, fitc))


library(performance)
compare_models(fit, fitb)
compare_performance(fit, fitb)
test_performance(fit, fitb) # 同一个因变量

# -------- mediation::mediate --------

library(mediation)

med <- lm(KF ~ DT, data)
out <- lm(IKS ~ DT + KF, data)

set.seed(12)
med.out <- mediate(med, out,
  treat = "DT", mediator = "KF",
  ## treat自变量，mediator中介变量
  sims = 5000
)
summary(med.out)
## ACME间接效应，ADE直接效应，Prop占比
med_summary(med.out)

broom::tidy(med.out)

plot(med.out)

# 敏感性分析
set.seed(123)
sens.out <- medsens(med.out,
  rho.by = 0.1,
  effect.type = "indirect", sims = 1000
)
summary(sens.out)
plot(sens.out,
  sens.par = "rho", main = "KF",
  ylim = c(-0.6, 0.6)
)
# Y表示中介效应值，X表示敏感度关于rho。
# 虚线表示rho=0的时候，就是没有混杂效应的时候。
# 红线表示混杂效应导致中介效应消失时rho的值，
# 因此得出rho的绝对值越高，中介效应越可靠。

# --------bruceR::PROCESS --------

PROCESS(data,
  y = "IKS", x = "DT",
  meds = "KF", ## 中介变量，可以是多个，用cc()
  mods = "OT", ## 调节变量，可以是多个，用cc()
  mod.path = "m-y", ## 设置调节路径
  std = T, ## 标准化
  ci = "bc.boot", nsim = 1000, seed = 1
)
## 括号内的数字是标准差SE
