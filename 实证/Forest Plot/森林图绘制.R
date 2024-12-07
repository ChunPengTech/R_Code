library(bruceR)
set.wd()
dt <- import("森林图R.xlsx", as = "data.frame")

library(grid)
library(forestploter)

dt$` ` <- paste(rep(" ", 20), collapse = " ")
dt$"Effect (95%CI)" <- ifelse(is.na(dt$Effect), "",
  sprintf(
    "%.2f(%.2f to %.2f)",
    dt$Effect, dt$LLCI, dt$ULCI
  )
)
dt[is.na(dt)] <- " "

tm <- forest_theme(
  base_size = 10, # 基础大小
  # 可信区间点的形状，线型、颜色、宽度
  ci_pch = 20,
  ci_col = "#4575b4", # #762a83
  ci_lty = 1,
  ci_lwd = 2.3,
  ci_Theight = 0.2, # 可信区间两端加短竖线

  # 参考线宽度、形状、颜色
  refline_lwd = 1.5,
  refline_lty = "dashed",
  refline_col = "red",

  # 汇总菱形的填充色和边框色
  summary_fill = "#4575b4",
  summary_col = "#4575b4",

  # 脚注大小、字体、颜色
  footnote_cex = 1.1,
  footnote_fontface = "italic",
  footnote_col = "blue"
)

p <- forest(dt[, c(1, 7, 6, 3)], # 选择数据列作为森林图元素
  est = dt$Effect, # HR
  lower = dt$LLCI, # 可信区间下限
  upper = dt$ULCI, # 可信区间上限
  sizes = 0.6, # 点估计框大小，用标准误映射
  ci_column = 3, # 可信区间在第几列展示
  ref_line = 0.678,
  xlim = c(0, 0.8),
  ticks_at = c(0, 0.4, 0.8),
  arrow_lab = c("protective factor", "risk factor"),
  theme = tm
) # 主题

print(p)
