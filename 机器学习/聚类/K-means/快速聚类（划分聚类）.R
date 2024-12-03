# -------------- K-means聚类 --------------

# K-means聚类，K均值聚类，是快速聚类的一种。比层次聚类更适合大样本的数据。在R语言中可以通过kmeans()实现K均值聚类。

library(cluster)
library(factoextra)

# 加载数据
df <- USArrests

# 移除缺失值
df <- na.omit(df)

# 数据标准化
df <- scale(df) |> as.data.frame()

# 寻找最佳聚类数量

# kmeans(data, centers, nstart)
# data : 数据集名称
# centers: 聚类数量,即选择k的值
# nstart: 初始配置个数。因为不同的初始启动集合可能会导致不同的结果，所以建议使用几种不同的初始配置。k-means算法将找到导致簇内变异最小的初始配置。

# 进行K均值聚类时，需要在一开始就指定聚类的个数，可以通过NbClust包实现这个过程。
library(NbClust)

set.seed(123)
nc <- NbClust(df, min.nc = 2, max.nc = 15, method = "kmeans")

# 结果中给出了划分依据以及最佳的聚类数目为2个，可以画图查看结果

# 也可以使用factoextra::fviz_nbclust寻找最佳聚类数
fviz_nbclust(df, kmeans, k.max = 15)

# 开始聚类
set.seed(123)
fit.km <- kmeans(df, centers = 2, nstart = 25) # 尝试多种配置选择最好的一个
fit.km

# 可视化
fviz_cluster(fit.km, data = df)

# aggregate()函数查看每个类中变量的均值
aggregate(USArrests, by=list(cluster=fit.km$cluster), mean)
