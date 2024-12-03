
# 配对样本T检验

#数据录入
before <-c(82.5,85.2,87.6,89.9,89.4,90.1,87.8,87.0,88.5,92.4,83.5,78.9,83.6,87.9,78.6)
after <-c(82.7,84.2,89.3,89.0,88.4,91.5,87.2,86.2,87.5,93.8,82.6,79.3,84.6,88.3,79.3)

data <- data.frame(
  group = rep(c("before", "after"), each = 15),
  weight = c(before,  after)
)
data

#数据整理
library("dplyr")
group_by(data, group) %>%
  summarise(
    count = n(),
    mean = mean(weight, na.rm = TRUE),
    sd = sd(weight, na.rm = TRUE)
  )

#画图
#绘制配对数据的箱线图
library(PairedData)

# 提取治疗前数据
before <- subset(data,  group == "before", weight,
                 drop = TRUE)

# 提取治疗后数据
after <- subset(data,  group == "after", weight,
                drop = TRUE)

# 画配对图
library(PairedData)
pd <- paired(before, after)
plot(pd, type = "profile") + theme_bw()


#作差，正态性检验
#差值正态性检验，差值符合正态分布（P>0.05）
d <- with(data, weight[group == "before"] - weight[group == "after"])
#Shapiro-Wilk正态性检验差值是否符合正态分布
shapiro.test(d) 

# 配对样本t检验
res <- t.test(after,before, paired = TRUE)
# 显示结果
res ## p>0.05表明无显著差异


dataT <- data.frame(before,after)
dataT

dataT |>  bruceR::TTEST(c("before", "after"), paired = T)
