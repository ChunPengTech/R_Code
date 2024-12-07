## 导入数据并加载需要的包
library(lavaan)
library(bruceR)
library(tidySEM)

set.wd()
data <- import("paper.xlsx", as = "data.frame")

# -------- 主效应 --------

model1 <- "
DT1 =~ DT11 + DT12 + DT13   ## 定义潜变量
DT2 =~ DT21 + DT22
DT3 =~ NA*DT31 + 1*DT32 + DT33
IKS1 =~ IKS11 + IKS12 + IKS13
IKS2 =~ IKS21 + IKS22

DT =~ DT1 + DT2 + DT3       ## 定义回归
IKS =~ IKS1 + IKS2

IKS ~ a*DT                  ## 定义回归系数
"
fit1 <- sem(model = model1, data = data)
lavaan_summary(fit1)

graph_sem(model = fit1)
get_layout(fit1) ## 获取布局，手动调整

lay <- get_layout(
  "DT11", NA, NA, NA, NA, NA, NA,
  "DT12", "DT1", NA, NA, NA, NA, "IKS11",
  "DT13", NA, NA, NA, NA, "IKS1", "IKS12",
  "DT21", NA, NA, NA, NA, NA, "IKS13",
  NA, "DT2", "DT", NA, "IKS", NA, NA,
  "DT22", NA, NA, NA, NA, NA, "IKS21",
  "DT31", NA, NA, NA, NA, "IKS2", NA,
  "DT32", "DT3", NA, NA, NA, NA, "IKS22",
  "DT33", NA, NA, NA, NA, NA, NA,
  rows = 9
)

graph_sem(fit1, layout = lay) ## 更新模型图

# -------- 中介效应 --------

### 定义模型

model2 <- "
KF ~ a*DT
IKS ~ b*KF + c*DT

med := a*b           ## 赋新值
"

fit2 <- sem(model = model2, data = data)
lavaan_summary(fit2)

fit2_boot <- sem(
  model = model2, data = data,
  se = "bootstrap", bootstrap = 1000
)
lavaan_summary(fit2_boot)

graph_sem(model = fit2)
get_layout(fit2) ## 获取布局，手动调整

lay <- get_layout(
  "DT11", NA, NA, NA, NA, NA, "IKS11",
  "DT12", "DT1", NA, NA, NA, "IKS1", "IKS12",
  "DT13", NA, NA, NA, NA, NA, "IKS13",
  "DT21", NA, "DT", NA, "IKS", NA, "IKS21",
  NA, "DT2", NA, NA, NA, "IKS2", NA,
  "DT22", NA, NA, "KF", NA, NA, "IKS22",
  "DT31", "DT3", NA, NA, NA, NA, NA,
  "DT32", NA, "KF1", "KF14", NA, "KF2", "KF21",
  "DT33", "KF11", "KF12", "KF13", "KF23", "KF24", "KF22",
  rows = 9
)

graph_sem(fit2,
  layout = lay,
  rect_width = 0.75, ## rect_width 矩形宽度
  ellipses_width = 0.75, ## ellipses_width 椭圆宽度
  variance_diameter = 0.6, ## variance_diameter 残差大小
  curvature = 0,
  spacing_x = 2
) ## 更新模型图