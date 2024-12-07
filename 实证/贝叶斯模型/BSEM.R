library(lavaan)
library(bruceR)
library(tidyverse)
library(blavaan)

set.wd()
data <- import("data_298.csv", as = "data.frame")

# -------- 主效应 --------

model1 <- "
x =~ x1+x2+x3+x4+x5
y =~ y1+y2+y3+y4+y5+y6

y ~ c*x
"

bfit1 <- bsem(model = model1, data = data)
summary(bfit1, standardized = TRUE)

# -------- 中介效应 --------

model2 <- "
x =~ x1+x2+x3+x4+x5
ma =~ ma1+ma2+ma3+ma4+ma5
mb =~ mb1+mb2+mb3+mb4+mb5+mb6
y =~ y1+y2+y3+y4+y5+y6

ma ~ a1*x
mb ~ d*ma+a2*x
y ~ cdash*x+b1*ma+b2*mb

med1 := a1*b1
med2 := a2*b2
chainmed := a1*d*b2
diff1 := med1-chainmed
diff2 := med2-chainmed
diff3 := med1 - med2
"

bfit2 <- bsem(model = model2, data = data)
summary(bfit2)