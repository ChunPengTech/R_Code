library(bruceR)
library(mediation)
library(lavaan)

data("school", package = "mediation")
data("student", package = "mediation")

# -------- 2-1-1 --------

# catholic ==> attachment ==> fight

model_211 <- "
  level:1
    fight ~ b*attachment
  
  level:2
    attachment ~ a*catholic
    fight ~ cdash*catholic + b*attachment
  
  med := a*b
  total := a*b + cdash
"

fit_211 <- sem(model = model_211, data = student, cluster = "SCH_ID")
summary(fit_211, fit.measures = T, std = T, ci = T)
fitmeasures(fit_211, cc("cfi, tli, srmr, rmsea, chisq, df"))
lavInspect(fit_211, "ICC")

# -------- 2-2-1 --------

# free ==> smorale ==> late

model_221 <- "
  level:1
    late ~~ late

  level:2
    smorale ~ a*free
    late ~ b*smorale + cdash*free
  
  med := a*b
  total := a*b + cdash
"

fit_221 <- sem(model = model_221, data = student, cluster = "SCH_ID")
summary(fit_221, fit.measures = T, std = T, ci = T)
lavInspect(fit_221, "ICC")
