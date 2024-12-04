library(plm)
library(datawizard)
library(tidyverse)

data <- bruceR::import("patent.dta") |>
  pdata.frame(index = c("code", "year"))
data |> View()
skimr::skim(data)
pdim(data)

# code 企业
# year 年份
# patent 企业创新
# support 政府补贴
# Size 总资产
# Lev 资产负债率（-）
# Capital 资本性支出
# Roa 资产利润率
# PPE 固定资产规模（-）
# Cash 企业现金量
# Age 企业年龄
# Gdp GDP增长率（-）
# ind 行业

#-----------混合效应--------------

# pooled regression 混合效应(截面数据处理)
pooled <- plm(patent ~ support + Size + Lev + Roa + PPE + Capital + Cash + Gdp, data = data, model = "pooling")
summary(pooled)

#-----------固定效应--------------

# fixed effects model 固定效应
## 双固定
twoway.fe <- plm(patent ~ support + Size + Lev + Roa + PPE + Capital + Cash + Gdp, data = data, effect = "twoway", model = "within")
summary(twoway.fe)

## 固定个体
ind.fe <- plm(patent ~ support + Size + Lev + Roa + PPE + Capital + Cash + Gdp, data = data, effect = "individual", model = "within")
summary(ind.fe)

## 固定时间
time.fe <- plm(patent ~ support + Size + Lev + Roa + PPE + Capital + Cash + Gdp, data = data, effect = "time", model = "within")
summary(time.fe)

bruceR::model_summary(list(twoway.fe, ind.fe, time.fe))

#-----------随机效应--------------

# random effects model 随机效应

## 双随机
twoway.re <- plm(patent ~ support + Size + Lev + Roa + PPE + Capital + Cash + Gdp, data = data, effect = "twoway", model = "random")
summary(twoway.re)

## 个体随机
ind.re <- plm(patent ~ support + Size + Lev + Roa + PPE + Capital + Cash + Gdp, data = data, effect = "individual", model = "random")
summary(ind.re)

## 时间随机
time.re <- plm(patent ~ support + Size + Lev + Roa + PPE + Capital + Cash + Gdp, data = data, effect = "time", model = "random")
summary(time.re)

bruceR::model_summary(list(twoway.re, ind.re, time.re))


#-----------模型汇总--------------

# 不同效应模型汇总
bruceR::model_summary(list(pooled, twoway.fe, twoway.re))


#-----------模型选择--------------

# redundant fixed effect test
pFtest(twoway.fe, pooled) ## 前固定，后混合
## p<0.05 说明固定效应模型更好

# hausman test: random effect or fixed effect
phtest(twoway.re, twoway.fe) ## 前随机，后固定
## p<0.05 说明固定效应模型更好
