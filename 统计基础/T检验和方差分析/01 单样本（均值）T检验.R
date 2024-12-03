# 单样本T检验

## 本次抽样湖水数据(总体均值4.65)
y <- c(3.96,4.62,3.99,4.34,4.78,4.64,4.52,4.55,4.48,4.56)

mean(y) ## 样本均值

data <- as.data.frame(y)

## 进行数据的正态性检验
shapiro.test(y)   #若P>0.05 符合正态分布
performance::check_normality(y)

## 进行单样本t检验
t.test(y,mu=4.65)
#单样本t检验时，需要填写总体均数值mu, 
#若P>0.05 ，则不能确定两者间存在差异，即在统计上可认为不存在差别

library(bruceR)
data %>% TTEST("y", test.value = 4.65)
