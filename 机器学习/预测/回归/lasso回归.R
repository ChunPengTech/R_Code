library(glmnet)

data(BinomialExample)
x <- BinomialExample$x
y <- BinomialExample$y

fit <- glmnet(x, y, family = "binomial")

# 官方不建议直接提取fit中的元素，因为提供了plot，print，coef，predict方法帮助探索结果。

plot(fit,label = T)

