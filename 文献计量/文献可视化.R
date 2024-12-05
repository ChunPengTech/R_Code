library(bibliometrix)

# 打开shiny程序
biblioshiny()

# -------- Data loading and converting 数据加载和转换 --------

file <- "ai.txt"

M <- convert2df(file = file, dbsource = "wos", format = "plaintext")

# -------- Bibliometric Analysis 书目分析 --------

# 第一步是对数据进行描述性分析。函数 biblioAnalysis 返回一个 "bibliometrix "类对象。
results <- biblioAnalysis(M, sep = ";")

# 使用通用函数summary总结文献计量分析的主要结果。它可以显示书目数据框架的主要信息和几个表格，如年度科研成果、按引用次数排序的顶级手稿、最有成果的作者、最有成果的国家、每个国家的总引用次数、最相关的来源（期刊）和最相关的关键词。
# k 是一个格式值，表示每个表格的行数。pause 是一个逻辑值（TRUE 或 FALSE），用于允许（或不允许）暂停屏幕滚动。如果选择 k=10，就可以看到前 10 个作者、前 10 个来源等。
S <- summary(object = results, k = 10, pause = FALSE)

# 使用通用函数 plot 可以绘制一些基本图
plot(x = results, k = 10, pause = FALSE)