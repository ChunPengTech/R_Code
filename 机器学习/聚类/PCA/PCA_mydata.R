library(bruceR)
set.wd()
data <- import("data_298.csv", as = "data.frame")
data <- data |> select(-V23)

# 因子分析
EFA(data, varrange = "x1:y6", hide.loadings = 0.5, plot.scree = FALSE)



fa_result <- psych::principal(data, rotate = "varimax", nfactors = 4)
print(fa_result$loadings, cutoff = 0.5)


pca_res <- FactoMineR::PCA(data, ncp = 4, graph = T)
# 特征值
pca_res$eig
pca_res$svd

factoextra::fviz_pca(pca_res)
