library(compareGroups)
library(bruceR)

set.wd()
data <- import("basic info.xlsx", as = "data.frame")

# 批量转换为因子型
dat <- data.frame(lapply(data[2:11], as.factor))

# data1 <- cbind(data[1], dat)
# str(data1)

# -------- 不分类 --------

# 符号 ~ 的左边可以为分组变量或不填入变量，不填入变量则默认计算总研究人群的基线特征，并且不会进行统计检验；
# 符号 ~ 的右边为基线特征表中需要进行统计计算的变量，如果没填变量仅出现一个.，则默认数据集的全部变量进行统计计算。
descrTable(~., data = dat)

# -------- Type为分类变量 --------

table1 <- descrTable(Type ~ ., data = dat, show.all = TRUE)
## 也可以自己选择基线表行变量
# 如果基线表中纳入的变量较多，不想这么麻烦，也可以通过-号的形式移除变量。
# 这里的p.overall是通过t检验计算的：(如果不符合正态分布是通过Kruskall-Wallis检验计算)

table1$descr %>% print_table()

export2csv(table1, file = "table1.csv") ## compareGroups的函数
export2word(table1, file = "table1.docx")

#  分类变量OR/HR值计算
descrTable(Type ~ ., data = dat, ref = 1, show.ratio = TRUE)
# 表格中的p.ratio和OR值就是做个逻辑回归得到的