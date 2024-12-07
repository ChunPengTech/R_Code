library(interactions)
library(bruceR)
set.wd()
data <- import("JN.sav", as = "data.frame")
names(data)

data <- scale(data) |> as.data.table()


data
set.seed(123)

onelm <- lm(M ~ X, data = data)

twolm <- lm(Y ~ X + M, data = data)

lm <- lm(Y ~ X + M + W + W2 + M * W + M * W2, data = data)

model_summary(list(onelm, twolm, lm))

JN <- johnson_neyman(model = lm, pred = X, modx = W2)
JN
