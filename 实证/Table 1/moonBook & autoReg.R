library(autoReg)
library(moonBook)
library(bruceR)

# paper02

set.wd()
data <- import("basic info.xlsx", as = "data.frame")
data |> names()

# data[2:11] == data |> tidytable::select(Position:Other)

# 批量转换为因子型
dat <- data.frame(lapply(data[2:11], as.factor))
dat |> names()

## 因子水平重命名

dat$Position <- recode(dat$Position,
  "1" = "Junior level",
  "2" = "Middle level",
  "3" = "Senior level",
  "4" = "Upper management"
)

dat$Type <- recode(dat$Type,
  "1" = "Pubic",
  "2" = "Private"
)

dat$Size <- recode(dat$Size,
  "1" = "<50",
  "2" = "50-300",
  "3" = "300-500",
  "4" = ">500"
)

dat$Year <- recode(dat$Year,
  "1" = "<3",
  "2" = "3-5",
  "3" = "5-10",
  "4" = ">10"
)

# dat <- cbind(data[1], dat)
# str(dat)

# -------- autoReg --------

## 无论总体还是分类结果都是数据框
gaze(data = dat) %>% print_table()

ft <- gaze(Type ~ ., data = dat)
ft %>% print_table()

# -------- moonBook --------

## 总体描述结果是数据框可以直接导出
mytable(dat) %>% print_table()

## 分类描述结果是list，要$之后导出
myfit <- mytable(Type ~ ., data = dat, show.total = TRUE)
## show.total=TRUE相当于直接执行mytable(dat)的结果
##
summary(myfit)

mytable_sub(Type ~ ., data = dat)

myfit$res %>% print_table()
myfit$res %>% print_table(file = "moonbook.rtf")
