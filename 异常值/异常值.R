library(bruceR)
set.wd()
data <- import("data304n.csv", as = "data.frame")

# ----------------------------
## k-means聚类
# ----------------------------

result <- kmeans(data, 6) # kmeans聚类为6类
result$centers ## 聚类中心
result$cluster ## 聚类结果
data$cluster <- result$cluster ## 放入data


## 计算每个样本对应的聚类中心样本
centers <- result$centers[result$cluster, ] 
centers

## 计算每个样本到聚类中心的距离
distances <- sqrt(rowSums(data-centers)^2) 
distances

## 找到5个最大的样本认为是异常值
out <- order(distances, decreasing = T)[1:5]
out ## 异常值样本
data[out,]  ## 异常值


# ----------------------------
## 局部异常因子法（LOF）
# ----------------------------

# 将一个点的局部密度与其周围的点的密度想比较，若前者明显小于后者（LOF值＞1），则该点相对于周围的点来说就处于一个相对稀疏的区域，这就表明该店是一个异常值

library(DMwR2)

out.scores <- lofactor(data,6)

plot(density(out.scores)) ## LOF值的概率密度图

## 取排行前5的作为异常值
out_lof <- order(out.scores, decreasing = T)[1:5]
out_lof ## 异常值样本
data[out_lof,]   ## 异常值

# ----------------------------
## 稳健马氏距离（检测最多）
# ----------------------------

# 程序包‘DEoptimR’打开成功，MD5和检查也通过
# 程序包‘sgeostat’打开成功，MD5和检查也通过
# 程序包‘robustbase’打开成功，MD5和检查也通过
# 程序包‘mvoutlier’打开成功，MD5和检查也通过

library(mvoutlier)


# 多元异常值检验
res <- aq.plot(data)
which(res$outliers==T)

# 高维数据多变量的异常值检验
res2 <- pcout(data)
which(res2$wfinal01==0) ## 若有异常值会将wfinal标记0
