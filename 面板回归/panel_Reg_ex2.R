library(plm)
library(datawizard)
library(tidyverse)

data <- bruceR::import("panel101.dta") |> 
  pdata.frame(index = c("country", "year"))
data |> View()
skimr::skim(data)

## 标准化
data <- data |> select(y, x1, x2, x3) |> standardise()
data

# pooled regression 混合效应(截面数据处理)
pooled <- plm(y ~ x1+x2+x3, data = data, model = "pooling")
summary(pooled)
bruceR::model_summary(pooled)
stargazer::stargazer(pooled,type = "text")


# fixed effects model 固定效应
ind.fe <- plm(y ~ x1+x2+x3, data = data, 
              effect = "individual", model = "within")
summary(ind.fe)

# random effects model 随机效应
ind.re <- plm(y ~ x1+x2+x3, data = data, 
              effect = "individual", model = "random")
summary(ind.re)

bruceR::model_summary(list(pooled,ind.fe, ind.re))
stargazer::stargazer(pooled, ind.fe, ind.re,type = "text")


# redundant fixed effect test
pFtest(ind.fe, pooled) ##前固定，后混合
## p<0.05 说明固定效应模型更好


# hausman test: random effect or fixed effect
phtest(ind.fe, ind.re) ## 前固定，后随机
## p<0.05 说明固定效应模型更好
