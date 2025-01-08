library(bruceR)
set.wd()
data <- import("maindata_298.csv", as = "data.frame")
data |> names()

# -------- 均值与标准差 --------

Describe(data, digits = 3)


# -------- 相关系数 --------

library(PerformanceAnalytics)
chart.Correlation(data, histogram = T, pch = 19)


Corr(data, digits = 3)

apaTables::apa.cor.table(data)
sjPlot::tab_corr(data, triangle = "lower")
correlation::correlation(data) |> summary()