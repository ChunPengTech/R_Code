data(nutrient, package = "flexclust")
row.names(nutrient) <- tolower(row.names(nutrient)) # 大写变小写

dim(nutrient) # 27行5列

# 层次聚类在R语言中，通过hclust实现。
# # 不管是哪种类型的聚类分析，都需要找到一个评价相似性的指标，通常使用相似系数（similarity coefficient）衡量，相似系数类似于相关系数，但是并不是完全一样。
# 由于计算相似系数需要计算不同样本间的距离，因此就需要对数据提前进行标准化处理，以消除不同单位对计算的影响。一般来说，样本间的距离越大，样本间的相异质性越大，相似性越小。
#
# 计算距离时，有以下几种方法（其实还有非常多，可参考距离定义）：
# 欧氏距离（Euclidean）
# 绝对距离（曼哈顿距离，Manhattan）
# 马氏距离（Mahalanobis）：欧式距离的平方
# 闵可夫斯基距离（Minkowski）
# 兰氏距离（Lance and Williams），又称为堪培拉距离（Canberra）
# 杰卡德距离（Jaccard），又称为二元距离，用来计算二元变量的距离
#
# 计算相似系数也有多种不同的方法，比如：
# single：单联动法，一个簇中的点到另一个簇中的点的最小距离
# complete：全联动法，一个簇中的点到另一个簇中的点的最大距离
# average：平均联动法，一个簇中的点到另一个簇中的点的平均距离
# ward.D：Ward法，两个簇之间所有变量的方差分析的平方和
# centroid：质心法，两个簇的质心之间的距离

# -------------- 系统聚类的实现 ----------------

# 聚类前先进行标准化
nutrient.scaled <- scale(nutrient) |> as.data.frame()

# 然后计算距离，方法就选择欧氏距离。这也是默认方法
d <- dist(nutrient.scaled, method = "euclidean")

# 进行层次聚类
h.clust <- hclust(d,
  method = "average" # 计算相似系数的方法
)

plot(h.clust, main = "", xlab = "")

# 树状图应该从下往上读，每个观测值起初自成一个聚类簇，然后相距最近的两个聚类簇（beef braised和smoked ham)合并。比如，pork roast和pork simmered合并，chicken canned和 tuna canned合并。
#
# 然后，beef braised/smoked ham这一簇和pork roast/pork simmered这一簇合并（这个聚类簇目前包含4种食品)。合并继续进行下去，直到所有的食物合并成一个聚类簇。
#
# 纵坐标的刻度代表了该高度的聚类簇之间合并的判定值。
#
# 如果我们的目的是理解不同食物营养物质之间的相似性和异质性，那么做到这里就可以满足需求了。但是如果我们想要知道到底聚成几个类才是最合适的，就需要继续探索。
#
# 聚类是把性质相似的样本聚在一起，通常我们也不知道应该分为几类比较合适，可以通过R包NbClust实现。

library(NbClust)

nc <- NbClust(nutrient.scaled,
  distance = "euclidean",
  min.nc = 2, # 最小聚类数
  max.nc = 10, # 最大聚类数
  method = "average"
)

# 它给出的结论是最佳聚类数是2。也可以通过条形图查看这些评判准则的具体数量。

barplot(table(nc$Best.nc[1, ]),
  xlab = "聚类数目",
  ylab = "评判准则个数"
)
# 从条形图中可以看出，聚类数目为2,3,5,10时，评判准则个数最多为5个，可以选择5个（也可以选择2，3，10，根据需要选择即可）。

cluster <- cutree(h.clust, k = 5)
table(cluster)

plot(h.clust, hang = -1, main = "", xlab = "")
rect.hclust(h.clust, k = 5) # 添加矩形，方便观察


# -------------- 系统聚类的可视化 ----------------

# 简单点可以直接用plot()函数进行聚类树的可视化。
plot(h.clust,
  hang = -1, main = "层次聚类", sub = "",
  xlab = "", cex.lab = 1.0, cex.axis = 1.0, cex.main = 2
)

# as.dendrogram()转化一下，再画图指定更多细节。
dhc <- as.dendrogram(h.clust)

# 按照上面的结果，我们可以分为5类，所以准备好5个颜色
labelColors <- c("#CDB380", "#036564", "#EB6841", "#EDC951", "#487AA1")

# 把聚类树分为5个类
clusMember <- cutree(h.clust, k = 5)

# 给标签增加不同的颜色
colLab <- function(n) {
  if (is.leaf(n)) {
    a <- attributes(n)
    labCol <- labelColors[clusMember[which(names(clusMember) == a$label)]]
    attr(n, "nodePar") <- c(
      a$nodePar,
      list(
        cex = 1.5, # 节点形状大小
        pch = 20, # 节点形状
        col = labCol, # 节点颜色
        lab.col = labCol, # 标签颜色
        lab.font = 2, # 标签字体，粗体斜体粗斜体
        lab.cex = 0.7 # 标签大小
      )
    )
  }
  n
}

# 把自定义标签颜色应用到聚类树中
diyDendro <- dendrapply(dhc, colLab)

# 画图
plot(diyDendro, main = "DIY Dendrogram")

# 加图例
legend("topright",
  legend = c("Cluster 1", "Cluster 2", "Cluster 3", "Cluster 4", "Cluster 5"),
  col = c("#CDB380", "#036564", "#EB6841", "#EDC951", "#487AA1"),
  pch = c(20, 20, 20, 20, 20), bty = "n", pt.cex = 2, cex = 1,
  text.col = "black", horiz = FALSE, inset = c(0, 0.1),
)
