library(bruceR)
library(tableone)

set.wd()

data <- import("basic info.xlsx", as = "data.frame")

# -------- 不进行任何设置 --------

CreateTableOne(data = data) # 汇总摘要整个数据集

dput(names(data)) # 输出数据集变量名称

# 指定需要汇总的变量
myVars <- c(
  "ID", "Position", "Type", "Size", "Year",
  "Big Data", "Cloud Computing", "AI",
  "Block Chain", "IOT", "Other"
)

# 指定哪些是分类变量
catVars <- c(
  "Position", "Type", "Size", "Year",
  "Big Data", "Cloud Computing", "AI",
  "Block Chain", "IOT", "Other"
)

tab2 <- CreateTableOne(vars = myVars, factorVars = catVars, data = data)
tab2 ## 两个水平的默认显示后一个水平

print(tab2) %>% write.csv(file = "myTableone2.csv")

# 显示所有水平的数据
print(tab2, showAllLevels = TRUE)

# -------- 多组汇总 --------

tab3 <- CreateTableOne(
  vars = myVars, factorVars = catVars,
  strata = "Type", data = data
)
tab3
print(tab3, showAllLevels = TRUE)

tab3Mat <- print(tab3)
tab3Mat
write.csv(tab3Mat, file = "myTableone.csv")
