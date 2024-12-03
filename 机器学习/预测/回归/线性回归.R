mtcars
str(mtcars)
skimr::skim(mtcars)

## 数据处理，将分类型变量转换为factor
mtcars$vs <- as.factor(mtcars$vs)
mtcars$am <- as.factor(mtcars$am)

model <- 'mpg ~ hp +wt + vs + am'

## 普通线性回归建模
lmfit <- lm(model, data = mtcars)   ## 或直接放入formula
## 自变量部分-1可以排除输出结果的截距项
lmfit |> broom::tidy()
fitted(lmfit)                   ## 基于原数据的拟合模型的预测值
confint(lmfit, level = 0.95)    ## 模型的置信区间

## 多重共线性诊断
library(car) 
vif(lmfit)
bruceR::model_summary(lmfit)
autoReg::gaze(lmfit)


# 模型诊断
library(easystats)
check_model(lmfit)
model_parameters(lmfit) # 模型参数
model_performance(lmfit)  # 模型性能
check_collinearity(lmfit)  # 共线性
check_outliers(lmfit)    # 离群值
check_normality(lmfit)  # 正态性
model_dashboard(lmfit)   # 仪表盘
report(lmfit)


## 预测
pred <- predict(lmfit, newdata = mtcars)  ## 基于新数据的模型预测值，新旧数据集的变量名需要保持一致

plot(mtcars$mpg, pred)
plot(pred ~ mtcars$mpg)            ## 图示比较结果
abline(a = 0, b = 1, col = "red")  ## 绘制y=x的红色线
