library(bruceR)
library(lmerTest)
library(lme4)
library(mediation)

# HLM_summary(): fit model with `lmerTest::lmer()` or `lme4::glmer()`

## -------- Group-level treatment and individual-level mediator (2-1-1) --------

data("student", package = "mediation")
head(student)

# catholic ==> attachment ==> fight

# -------- 主要路径检验 --------

med.fit <- glmer(attachment ~ catholic + gender + income + pared + (1 | SCH_ID), family = binomial(link = "logit"), data = student)

med.fit |> summary()
HLM_summary(med.fit)
HLM_ICC_rWG(data = student, group = "SCH_ID", icc.var = "attachment")

out.fit <- glmer(fight ~ catholic * attachment + gender + income + pared + (1 | SCH_ID), family = binomial(link = "logit"), data = student)

out.fit |> summary()
HLM_summary(out.fit)
HLM_ICC_rWG(data = student, group = "SCH_ID", icc.var = "fight")


# -------- 中介效应检验 --------

med.out <- mediate(med.fit,
  out.fit,
  treat = "catholic",
  mediator = "attachment",
  sims = 100
)

summary(med.out)
med_summary(med.out)

# -------- Group-level treatment and mediator (2-2-1) --------

data("school", package = "mediation")
data("student", package = "mediation")
head(school)
head(student)

# free ==> smorale ==> late

# -------- 主要路径检验 --------

med.fit <- lm(smorale ~ free + catholic + coed, data = school)

GLM_summary(med.fit) ## n=568，school数据测量568学校总体数据

out.fit <- lmerTest::lmer(late ~ free + smorale + catholic + coed + gender + income + pared + (1 | SCH_ID), data = student) ## SCH_ID的数量=568，student数据测量568学校多个学生的数据

HLM_summary(out.fit)
HLM_ICC_rWG(data = student, group = "SCH_ID", icc.var = "late")

anova(out.fit) |> print_table() ## 固定因子的显著性
lmerTest::ranova(out.fit) |> print_table() ## 随机因子的显著性

# -------- 中介效应检验 --------

med.out <- mediate(med.fit,
  out.fit,
  treat = "free",
  mediator = "smorale",
  control.value = 3,
  treat.value = 4,
  sims = 100
)
med_summary(med.out)
