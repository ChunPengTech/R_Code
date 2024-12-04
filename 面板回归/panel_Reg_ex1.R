library(plm)
stu <- bruceR::import("panel.xlsx") |>
  pdata.frame(index = c("id", "week"))
stu
skimr::skim(stu)


# pooled regression 混合效应（线性回归）
pooled <- plm(y ~ x, data = stu, model = "pooling")
summary(pooled)
bruceR::model_summary(pooled)
stargazer::stargazer(pooled, type = "text")


# fixed effects model 固定效应
ind.fe <- plm(y ~ x,
  data = stu,
  effect = "individual", model = "within"
)
summary(ind.fe)

period.fe <- plm(y ~ x,
  data = stu,
  effect = "time", model = "within"
)
summary(period.fe)

twoway.fe <- plm(y ~ x, stu,
  effect = "twoways", model = "within"
)
summary(twoway.fe)

bruceR::model_summary(list(ind.fe, period.fe, twoway.fe))
stargazer::stargazer(ind.fe, period.fe, twoway.fe, type = "text")


# random effects model 随机效应
twoway.re <- plm(y ~ x, stu,
  effect = "twoway", model = "random"
)
summary(twoway.re)

ind.re <- plm(y ~ x, stu,
  effect = "individual", model = "random"
)
summary(ind.re)

bruceR::model_summary(list(twoway.re, ind.re))

# redundant fixed effect test
pFtest(ind.fe, pooled) ## 前固定，后混合
## p<0.05 说明固定效应模型更好


# hausman test: random effect or fixed effect
phtest(ind.re, ind.fe) ## 前随机，后固定
## p<0.05 说明固定效应模型更好
