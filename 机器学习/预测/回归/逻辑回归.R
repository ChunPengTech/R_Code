# 二分类logistic回归（因变量是二分类变量）
bcdata <- bruceR::import("Logistic.sav")

## 查看数据概况
skimr::skim(bcdata)

## 若数据有缺失值
### （1）删除含有缺失值的样本（适合样本量大） bcdata <- na.omit(bcdata$)
### （2）使用均值（数字型）和众数（分类型）进行填充

## 变量类型修正
bcdata$CVD <-as.factor(bcdata$CVD) 

contrasts(bcdata$CVD)        ## 查看分类型变量的编码
table(bcdata$CVD)            ## 查看分类型变量的频数分布

## logistic回归建模
glmfit <- glm(CVD ~ .-ID, data = bcdata, family = binomial())
glmfit |> bruceR::model_summary()
autoReg::gaze(glmfit)

fitted(glmfit)               ## 输出预测值

library(car)
vif(glmfit)        ## 查看共线性

## 预测概率
predprob <- predict(glmfit, newdata = bcdata, type = "response")
### response输出的是概率，注意有些模型predict输出的概率是矩阵
predprob


## ROC曲线（评价二分类图形性能）
library(pROC)
rocs <- roc(response = bcdata$CVD,          ## 实际类别
            predictor = predprob)           ## 预测概率

plot(
  rocs,
  print.auc = T,                   ## ROC对象
  auc.polygon = T,                 ## 打印AUC值（图像面积）
  grid = T,                        ## 网格线
  max.auc.polygon = T,             ## 显示AUC=1的区域
  auc.polygon.col = "skyblue",     ## AUC区域填充色
  print.thres = T,                 ## 打印最佳临界点（约登法则得出）
  legacy.axes = T                  ## 横轴显示为1-specificity
)
## AUC值越接近1越好

## 约登法则
bestp <- rocs$thresholds[           ## thresholds是概率分界点
  which.max(rocs$sensitivities + rocs$specificities - 1)
]
bestp

## 预测分类
predlab <- as.factor(
  ifelse(predprob > bestp, "1", "0")
)
predlab

## 混淆矩阵
library(caret)
confusionMatrix(data = predlab,              ## 预测类别
                reference = bcdata$CVD,      ## 实际类别
                positive = "1",
                mode = "everything")