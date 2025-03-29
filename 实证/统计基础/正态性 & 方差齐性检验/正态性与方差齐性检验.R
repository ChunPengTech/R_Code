bruceR::set.wd()
data <- bruceR::import(file = "data.xlsx", as = "tibble")

data$edu <- as.factor(data$edu)
table(data$edu)
data

# 数据正态性检验------------------------------------------

shapiro.test(data$y)

performance::check_normality(data$y)
performance::check_normality(lm(y ~ edu, data))

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

ggplot2::ggplot(data, aes(y)) +
  geom_histogram() +
  geom_density(color = "blue")

ggplot(data, aes(y)) +
  geom_histogram(aes(y = ..density..),
    colour = "black",
    fill = "white"
  ) +
  stat_function(fun = dnorm, args = list(mean = mean(data$y), sd = sd(data$y)))

ggplot(data, aes(y)) +
  geom_density()


library(moments)
skewness(data$y)
agostino.test(data$y) # 偏度的检验
kurtosis(data$y)
anscombe.test(data$y) # 峰度检验

# 方差齐性检验-----------------------------------------

car::leveneTest(y ~ edu, data) ## 不要求数据（y）的正态性

performance::check_homogeneity(lm(y ~ edu, data))

bartlett.test(y ~ edu, data)
