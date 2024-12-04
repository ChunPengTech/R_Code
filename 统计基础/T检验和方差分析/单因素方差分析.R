data <- multcomp::litter[, c(1, 2)]

# 基本信息展示
head(data, 74)
table(data$dose) ## 计算dose中类别的数量

# 显示因子水平
levels(data$dose)

# 基本统计信息展示
library(dplyr)
data_summary <- group_by(data, dose) %>%
  summarise(
    count = n(),
    mean = mean(weight, na.rm = TRUE),
    sd = sd(weight, na.rm = TRUE)
  )
data_summary

# 或者使用summary函数
summary(data)

# Ⅱ. 数据正态性检验

## ①使用tapply()函数批量对不同的处理组进行数据正态性检验
tapply(data$weight, data$dose, shapiro.test)

## 也可以使用spss里面用到的Q-Q图
car::qqPlot(lm(weight ~ dose, data),
  simulate = T,
  main = "Q-Q Plot",
  labels = F
)

# 方差齐性检验

## ①Bartlett检验，使用的R函数为bartlett.test()，
## bartlett.test(formala, data, subset，na.action…)
bartlett.test(weight ~ dose, data) ## P<0.05 方差不齐

## ②Levene检验，调用car包的leveneTest()函数
library(car)
leveneTest(weight ~ dose, data)

## ③Fligner-Killeen检验，方差均匀性测试中的一种，对偏离正态的情况最为稳健
## 在R中调用的是fligner.test()函数，用法与前面两种一致：
fligner.test(weight ~ dose, data)

### 数据方差不齐，需要进行变量转换或者转用非参数检验的K-W检验

# 方差分析（满足正态，方差齐之后）

res.aov <- aov(weight ~ dose, data = data)
summary(res.aov) ## p>0.05则表明不存在差异

# 多重比较
## LSD法
library(DescTools)
PostHocTest(res.aov, method = "lsd")
## p<0.05表明组间存在差异
