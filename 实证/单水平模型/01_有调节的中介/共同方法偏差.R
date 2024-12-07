library(bruceR)
set.wd()
data <- import("paper.xlsx", as = "data.frame")

# -------- 探索性因子分析 --------
EFA(data, varrange = "DT11:OT32")

# -------- 验证性因子分析 --------
library(lavaan)

## 初始模型
baseline <- "
DT1 =~ DT11 + DT12 + DT13
DT2 =~ DT21 + DT22
DT3 =~ DT31 + DT32 + DT33
KF1 =~ KF11 + KF12 + KF13 + KF14
KF2 =~ KF21 + KF22 + KF23 + KF24
IKS1 =~ IKS11 + IKS12 + IKS13
IKS2 =~ IKS21 + IKS22
OT1 =~ OT11 + OT12 + OT13
OT2 =~ OT21 + OT22
OT3 =~ OT31 + OT32
"

baselinefit <- cfa(baseline, data = data)
lavaan_summary(baselinefit)

## 合并双模型
combine <- "
DT1 =~ DT11 + DT12 + DT13 + DT21 + DT22 + DT31 + DT32 + DT33 + 
KF12 + KF13 + KF14 + KF21 + KF22 + KF23 + KF24

IKS1 =~ IKS11 + IKS12 + IKS13 + IKS21 + IKS22 + 
OT11 + OT12 + OT13 + OT21 + OT22 + OT31 + OT32
"

## 合并单模型
one <- "
DT1 =~ DT11 + DT12 + DT13 + DT21 + DT22 + DT31 + DT32 + DT33 + 
KF12 + KF13 + KF14 + KF21 + KF22 + KF23 + KF24 + 
IKS11 + IKS12 + IKS13 + IKS21 + IKS22 + 
OT11 + OT12 + OT13 + OT21 + OT22 + OT31 + OT32
"

## ULMC法
bifactor <- "
# 自由估计
DT1 =~ DT11 + DT12 + DT13 ## 默认设置第一个位置为1
DT2 =~ DT21 + DT22
DT3 =~ DT31 + DT32 + DT33
KF1 =~ KF11 + KF12 + KF13 + KF14
KF2 =~ KF21 + KF22 + KF23 + KF24
IKS1 =~ IKS11 + IKS12 + IKS13
IKS2 =~ IKS21 + IKS22
OT1 =~ OT11 + OT12 + OT13
OT2 =~ OT21 + OT22
OT3 =~ OT31 + OT32

G =~ DT11 + DT12 + DT13 + DT21 + DT22 + DT31 + DT32 + DT33 + 
KF11 + KF12 + KF13 + KF14 + KF21 + KF22 + KF23 + KF24 + 
IKS11 + IKS12 + IKS13 + IKS21 + IKS22 + 
OT11 + OT12 + OT13 + OT21 + OT22 + OT31 + OT32

DT1 ~~ 1*DT1
DT2 ~~ 1*DT2
DT3 ~~ 1*DT3
KF1 ~~ 1*KF1
KF2 ~~ 1*KF2
IKS1 ~~ 1*IKS1
IKS2 ~~ 1*IKS2
OT1 ~~ 1*OT1
OT2 ~~ 1*OT2
OT3 ~~ 1*OT3
G ~~ 1*G
"

bifactorfit <- cfa(bifactor, data = data)
lavaan_summary(bifactorfit)

# -------- 模型汇总 --------

mylist <- list(baseline, combine, one, bifactor) # 这里的mylist是一个list
label <- cc("baseline, combine, one, bifactor")

result <- rbindlist(lapply(mylist, function(model) { # 对mylist各个元素进行function的分析
  cfa <- cfa(model, data = data)
  fit <- summary(cfa, estimate = F, fit.measures = T)
  result <- data.frame(
    ID = label[[which(model == mylist)]], # which可以帮助你获得当前lapply应用到哪个模型的索引，然后用label调取
    Chisq = fit[["fit"]][["chisq"]],
    df = fit[["fit"]][["df"]],
    `Chisq/df` = fit[["fit"]][["chisq"]] / fit[["fit"]][["df"]],
    CFI = fit[["fit"]][["cfi"]],
    TLI = fit[["fit"]][["tli"]],
    RMSEA = fit[["fit"]][["rmsea"]],
    SRMR = fit[["fit"]][["srmr"]],
    check.names = F # 不然没法显示/这个符号
  )
  return(result)
})) %>% print_table()











## ULMC法
bifactor <- "
# 自由估计
DT1 =~ NA*DT11 + DT12 + DT13
DT2 =~ NA*DT21 + DT22
DT3 =~ NA*DT31 + DT32 + DT33
KF1 =~ NA*KF11 + KF12 + KF13 + KF14
KF2 =~ NA*KF21 + KF22 + KF23 + KF24
IKS1 =~ NA*IKS11 + IKS12 + IKS13
IKS2 =~ NA*IKS21 + IKS22
OT1 =~ NA*OT11 + OT12 + OT13
OT2 =~ NA*OT21 + OT22
OT3 =~ NA*OT31 + OT32

G =~ NA*DT11 + DT12 + DT13 + DT21 + DT22 + DT31 + DT32 + DT33 + 
KF11 + KF12 + KF13 + KF14 + KF21 + KF22 + KF23 + KF24 + 
IKS11 + IKS12 + IKS13 + IKS21 + IKS22 + 
OT11 + OT12 + OT13 + OT21 + OT22 + OT31 + OT32

# 因子正交  可以适当改变，只让G与其他变量之间正交

DT1 ~~ 0*G
DT2 ~~ 0*G
DT3 ~~ 0*G
KF1 ~~ 0*G
KF2 ~~ 0*G
IKS1 ~~ 0*G
IKS2 ~~ 0*G
OT1 ~~ 0*G
OT2 ~~ 0*G
OT3 ~~ 0*G

DT1 ~~ 0*DT2
DT1 ~~ 0*DT3
DT1 ~~ 0*KF1
DT1 ~~ 0*KF2
DT1 ~~ 0*IKS1
DT1 ~~ 0*IKS2
DT1 ~~ 0*OT1
DT1 ~~ 0*OT2
DT1 ~~ 0*OT3

DT2 ~~ 0*DT3
DT2 ~~ 0*KF1
DT2 ~~ 0*KF2
DT2 ~~ 0*IKS1
DT2 ~~ 0*IKS2
DT2 ~~ 0*OT1
DT2 ~~ 0*OT2
DT2 ~~ 0*OT3

DT3 ~~ 0*KF1
DT3 ~~ 0*KF2
DT3 ~~ 0*IKS1
DT3 ~~ 0*IKS2
DT3 ~~ 0*OT1
DT3 ~~ 0*OT2
DT3 ~~ 0*OT3

KF1 ~~ 0*KF2
KF1 ~~ 0*IKS1
KF1 ~~ 0*IKS2
KF1 ~~ 0*OT1
KF1 ~~ 0*OT2
KF1 ~~ 0*OT3

KF2 ~~ 0*IKS1
KF2 ~~ 0*IKS2
KF2 ~~ 0*OT1
KF2 ~~ 0*OT2
KF2 ~~ 0*OT3

IKS1 ~~ 0*IKS2
IKS1 ~~ 0*OT1
IKS1 ~~ 0*OT2
IKS1 ~~ 0*OT3

IKS2 ~~ 0*OT1
IKS2 ~~ 0*OT2
IKS2 ~~ 0*OT3

OT1 ~~ 0*OT2
OT1 ~~ 0*OT3

OT2 ~~ 0*OT3
"
