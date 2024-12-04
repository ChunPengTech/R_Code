# 1. 加载所需包，打开数据集

library(forecast)
library(tseries)
library(bruceR)

data(Nile) # 打开数据集

# 2. 验证序列平稳性

## （1）对时间序列数据进行绘图，观察其趋势及特点

plot(Nile)
### 由图可见序列有向下的趋势，为非平稳序列，需对其进一步处理

## （2）对数据进行平稳性检验

ADF <- adf.test(Nile) # 单位根检验
ADF ## P>0.05，不拒绝原假设，即序列不平稳：

## （3）数据平稳化

ndiffs(Nile) # 返回差分阶数d
dNile <- diff(Nile) # 差分处理
plot(dNile) # 观察差分处理后的图形是否平稳

ADF <- adf.test(dNile) # 单位根检验
ADF

## （4）白噪声检验

Box.test(dNile, type = "Ljung-Box")
### P<0.05，拒绝原假设(白噪声序列)，非白噪声序列，此序列有分析价值

# 3. 模型定阶和拟合

## （1）模型p和q阶数确定

### 方法1

fit <- auto.arima(Nile) # R语言相对最优模型识别命令
summary(fit)

### 方法2：

acf(dNile) # 对差分后的序列绘制ACF图
pacf(dNile) # 对差分后的序列绘制PACF图
#### 由图可得ACF图1阶截尾，PACF图1阶拖尾，拟合MA(1)模型

# 注：当两种方法得到的模型不同时，可根据AIC或BIC最小原则选择较优模型。
AIC(fit) ## 方法1
AIC(fit, order = c(0, 0, 1)) ## 方法2
## 结果：方法1模型AIC=1267.25，方法2模型AIC=1270.309，
## 因此，本例选择方法1得到的模型为例进行后续分析。

## 观察模型拟合精度
accuracy(fit)
## 平均误差为-16.0660，
## 均方根误差为139.8986，
## 平均绝对误差为109.9998，
## 平均百分比误差为-4.0060，
## 平均绝对百分误差为12.7875，
## 平均绝对标准化误差为0.8255，
## 自相关系数为-0.0323

# 4. 模型诊断：检验拟合模型的准确性，提供模型改进方向

## （1）残差正态性检验

shapiro.test(fit$residuals) # Shapiro-Wilk正态性检验
### 返回结果P >0.05，表示残差服从正态性分布。

## （2）检验残差自相关函数值

Box.test(fit$residuals, type = "Ljung-Box") # 残差白噪声检验
### 返回结果P>0.05，不拒绝原假设，序列为白噪声序列，停止建模

# 5. 模型预测

forecast(fit, 3) # 预测3年，分别给出了预测值和80%、95%的置信区间
plot(forecast(fit, 3), xlab = "Year", ylab = "Annual Flow") # 绘制预测图
## 返回结果为预测值 (Point Forecast)、80%置信区间、95%置信区间。
## 图中蓝点为预测值的点估计，蓝紫色带为80%置信区间，灰色带为95%置信区间。
