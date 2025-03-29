bruceR::set.wd()
data <- bruceR::import(file = "data.xlsx", as = "data.frame")
head(data)
table(data$edu)

data$edu <- as.factor(data$edu)
str(data)

# 数据正态性检验
shapiro.test(data$y)
performance::check_normality(data$y)
car::qqPlot(lm(y ~ edu, data),
  simulate = T,
  main = "Q-Q Plot",
  labels = F
)
car::qqPlot(data$y,
  main = "QQ PLot",
  col = "blue",
  col.lines = "red"
)
ggplot2::ggplot(data, aes(sample = y)) +
  stat_qq() +
  stat_qq_line()

summary(data)

library(moments)
skewness(data$y)
agostino.test(data$y) # 偏度的检验
kurtosis(data$y)
anscombe.test(data$y) # 峰度检验

# 方差齐性检验
library(car)
leveneTest(y ~ edu, data)

# 方差分析
res.aov_y <- aov(y ~ edu, data = data)
summary(res.aov_y) ## p>0.05则表明不存在差异
library(DescTools)
sum_y <- PostHocTest(res.aov_y, method = "lsd")
## p<0.05表明组间存在差异
sum_y$edu |> bruceR::print_table()

res.aov_m <- aov(m ~ edu, data = data)
summary(res.aov_m) ## p>0.05则表明不存在差异
sum_m <- PostHocTest(res.aov_m, method = "lsd")
sum_m$edu |> bruceR::print_table()

###################

res.aov3 <- aov(y ~ x + edu + edu:x, data = data)
summary(res.aov3)

res.aov4 <- aov(m ~ x + edu + edu:x, data = data)
summary(res.aov4)
