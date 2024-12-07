library(bruceR)
set.wd()
data <- import("maindata_298.csv", as = "data.frame")
data |> names()

# -------- 均值与标准差 --------

Describe(data, digits = 3)


# -------- 相关系数 --------

library(Hmisc) ## 相关系数与P值
data1 <- as.matrix(data)
res <- rcorr(data1)
round(res$r, 3)
round(res$P)

library(corrplot)
corrplot.mixed(res$r,
  lower = "shade",
  upper = "pie",
  order = "hclust"
)

library(PerformanceAnalytics) ## 可视化
chart.Correlation(data, histogram = T, pch = 19)


Corr(data, digits = 3) ## bruceR，输出相关性、置信区间并绘图

apaTables::apa.cor.table(data)
sjPlot::tab_corr(data, triangle = "lower")
correlation::correlation(data) |> summary()


# -------- 均值与标准差的可视化（直方图+箱线图） --------

# -------- 使用 lapply 批量绘制图形 --------

# 保存当前图形参数
opar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))

# 用于绘制直方图和箱线图的变量
variables <- list(DT = data$DT, KD = data$KD, IKS = data$IKS, DKI = data$DKI)

# 绘图函数
plot_hist_box <- function(data, name) {
  # 绘制直方图
  hist(data, prob = TRUE, col = "white", main = name)

  # 添加箱线图
  par(new = TRUE)
  boxplot(data, horizontal = TRUE, axes = FALSE, col = rgb(0, 0.8, 1, alpha = 0.5))

  # 绘制边框
  box()
}

lapply(names(variables), function(name) {
  plot_hist_box(variables[[name]], name)
})

par(opar)

# -------- 或者逐个输出 --------

opar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))
attach(data)
# Histogram
hist(DT,
  prob = TRUE,
  col = "white",
  main = ""
)
# Add new plotDT
par(new = TRUE)
# Box plot
boxplot(DT,
  horizontal = TRUE, axes = FALSE,
  col = rgb(0, 0.8, 1, alpha = 0.5)
)
# Box around the plots
box()

hist(KD,
  prob = TRUE,
  col = "white",
  main = ""
)
# Add new plotDT
par(new = TRUE)
# Box plot
boxplot(KD,
  horizontal = TRUE, axes = FALSE,
  col = rgb(0, 0.8, 1, alpha = 0.5)
)
# Box around the plots
box()

hist(IKS,
  prob = TRUE,
  col = "white",
  main = ""
)
# Add new plotDT
par(new = TRUE)
# Box plot
boxplot(IKS,
  horizontal = TRUE, axes = FALSE,
  col = rgb(0, 0.8, 1, alpha = 0.5)
)
# Box around the plots
box()

hist(DKI,
  prob = TRUE,
  col = "white",
  main = ""
)
# Add new plotDT
par(new = TRUE)
# Box plot
boxplot(DKI,
  horizontal = TRUE, axes = FALSE,
  col = rgb(0, 0.8, 1, alpha = 0.5)
)
# Box around the plots
box()

detach(data)
par(opar)
