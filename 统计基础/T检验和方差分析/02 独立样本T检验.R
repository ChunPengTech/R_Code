library(bruceR)
library(tidyverse)

# 独立样本T检验

## Ⅰ 读入数据，数量多时，可以用read.csv或者read.xlsx函数读取
A <- c(134,146,119,124,161,107,83,113,129,97,123,115,119,140,131)
B <- c(106,70,118,101,85,107,132,94,99,103,107,130,131,78,99)
#合并数据,并设置分组标签
data <- c(A,B)
group<-c(rep("A",15),rep("B",15))

## Ⅱ 正态性检验
shapiro.test(A)  #若P>0.05 符合正态分布
shapiro.test(B)   #若P>0.05 符合正态分布

## Ⅲ 方差齐性检验:若P>0.05 方差齐
bartlett.test(data~group)

## t检验, 若 P<0.05 存在差异；有两种方式
### ①假如没有设置分组标签
t.test(A,B,paired=F,var.equal=T)   #如果方差不齐，更改：var.equal=F,
### ②根据设置了的分组标签
t.test(data ~ group,paired=F,var.equal=T)

## 需要报告p值和t值，若t>0，前组显著高于后组，p<0相反

##################################################################

#数据
women_weight <- c(69.9, 64.2, 73.3, 61.8, 63.4, 65.6, 48.4, 58.8, 68.5,67.0,63.2,55.2,48.3,44.6,43.2)
men_weight <- c(67.8, 60.0, 63.4, 76, 89.4, 72.3, 67.3, 61.3, 61.4,55.2,60.3,61.3,58.1,62.4,58.3)

# Ⅰ 数据整理，分组
data <- data.frame(
  group = rep(c("Woman", "Man"), each = 15),
  weight = c(women_weight,  men_weight)
)
#预览数据,并获取基本统计量
head(data)

## 筛选数据filter
library(tidyverse)
men <- data %>% filter(group == "Man")
men
## 或者使用subset
data %>% subset(group=="Man")

#按性别计算统计信息（如统计各分组变量数量、平均值、标准差）
library(dplyr)

data_summary <- group_by(data, group) %>%
  summarise(
    count = n(),#统计数量
    mean = mean(weight, na.rm = TRUE),#计算平均值
    sd = sd(weight, na.rm = TRUE)#计算标准差
  )
data_summary

# 画图展示，根据男女分组按体重制作箱式图
library("ggpubr")
ggboxplot(data, x = "group", y = "weight",
          color = "group",
          palette = c("red", "blue"))

# 正态性分析
?with
with(data, shapiro.test(weight[group == "Man"]))
shapiro.test(men_weight)
with(data, shapiro.test(weight[group == "Woman"]))
## 注：不符合正态性的数据需要进行转换或者使用非参数中的置和检验。

# 方差齐性检验：
# 一般使用F检验来检验两个样本（两个分组）方差齐性，
# 在R中，针对两分组正态分布样本的var.test()；
# P>0.05方差齐性

#var.test()用法 
# ① 一种是直接输入两组用于比较的变量，比如var.test(groupA, groupB)； 
# ② 一种更方便，输入对应表头(分类表头在后)和数据，如var.test(结果变量~group)；

res.ftest <- var.test(weight ~ group, data = data)
res.ftest

data %>% TTEST("weight", "group")

# 经F检验，P>0.05，两组数据方差齐

# 满足所以条件后，可以进行两样本独立 t 检验
# 两独立样本t检验
res <- t.test(weight ~ group, data = data, var.equal = TRUE)
res

##果P=0.07988>0.05，因此这个小区20岁男女性体重在统计意义上不存在差异。

# 绘图并显示检验结果

###绘图
library(ggpubr)
p <- ggboxplot(data, x="group", 
               y = "weight", color = "group", 
               palette = "jco", add = "jitter",  
               short.panel.labs = FALSE)

# 添加p值并显示检验方法
p + stat_compare_means(method = "t.test",label.y=100)
# 显示p值但不显示方法
p + stat_compare_means(aes(label = ..p.format..),
                       ethod = "t.test",label.x = 1.5)
# 只显示显著性水平（ns表示不显著）
p + stat_compare_means(aes(label = ..p.signif..),
                       method = "t.test",label.x = 1.5)

# 若我们事先知道总体均数中，男性或者女性的体重一定高于对方，可以设为：

#已知20岁女性体重普遍高于男性，则检验20岁男性的体重是否小于女性的体重
t.test(weight ~ group, data = data,
       var.equal = TRUE, alternative = "less")

#已知20岁男性体重普遍高于女性，则检验20岁男性的体重是否大于女性的体重
t.test(weight ~ group, data = data,
       var.equal = TRUE, alternative = "greater")
