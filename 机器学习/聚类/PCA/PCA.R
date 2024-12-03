data(iris)

# 数据标准化（均值0，方差1）
irised <- scaled_data <- scale(iris[, 1:4]) |> as.data.frame()

irised |> names()

bruceR::EFA(irised, varrange = "Sepal.Length:Petal.Width")


pca.res <- prcomp(irised)
pca.res

psych::principal(irised, rotate = "varimax")