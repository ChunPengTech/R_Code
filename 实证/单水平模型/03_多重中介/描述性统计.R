library(bruceR)
set.wd()
data <- import("maindata304n.xlsx", as = "data.frame")

# -------- 均值与标准差 --------

library(bruceR)
Describe(data)

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


# -------- 均值与标准差的可视化（直方图+箱线图） --------

opar <- par(no.readonly = TRUE)
par(mfrow = c(3, 2))
attach(data)
for (i in 1:length(data)) {
  # Histogram
  hist(data[[i]],
    prob = TRUE,
    col = "white",
    main = ""
  )
  # Add new plot
  par(new = TRUE)
  # Box plot
  boxplot(data[[i]],
    horizontal = TRUE, axes = FALSE,
    col = rgb(0, 0.8, 1, alpha = 0.5)
  )
  # Box around the plots
  box()
}
detach(data)
par(opar)


## 逐个输出
opar <- par(no.readonly = TRUE)
par(mfrow = c(3, 2))
attach(data)
# Histogram
hist(DI,
  prob = TRUE,
  col = "white",
  main = ""
)
# Add new plotDT
par(new = TRUE)
# Box plot
boxplot(DI,
  horizontal = TRUE, axes = FALSE,
  col = rgb(0, 0.8, 1, alpha = 0.5)
)
# Box around the plots
box()

hist(CI,
  prob = TRUE,
  col = "white",
  main = ""
)
# Add new plotDT
par(new = TRUE)
# Box plot
boxplot(CI,
  horizontal = TRUE, axes = FALSE,
  col = rgb(0, 0.8, 1, alpha = 0.5)
)
# Box around the plots
box()

hist(COD,
  prob = TRUE,
  col = "white",
  main = ""
)
# Add new plotDT
par(new = TRUE)
# Box plot
boxplot(COD,
  horizontal = TRUE, axes = FALSE,
  col = rgb(0, 0.8, 1, alpha = 0.5)
)
# Box around the plots
box()

hist(CON,
  prob = TRUE,
  col = "white",
  main = ""
)
# Add new plotDT
par(new = TRUE)
# Box plot
boxplot(CON,
  horizontal = TRUE, axes = FALSE,
  col = rgb(0, 0.8, 1, alpha = 0.5)
)
# Box around the plots
box()

hist(GEN,
  prob = TRUE,
  col = "white",
  main = ""
)
# Add new plotDT
par(new = TRUE)
# Box plot
boxplot(GEN,
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

detach(data)
par(opar)
