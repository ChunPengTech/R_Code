# https://www.modb.pro/db/451160

library(jiebaR)
library(tidyverse)

bruceR::set.wd()

data.txt <- scan("2020年福建省人民政府工作报告.txt", what = "", sep = "\n", encoding = "UTF-8")

data.txt

# 也可以使用 bruceR::import() 进行导入

# demo.csv <- bruceR::import("2020年福建省人民政府工作报告.csv", encoding = "UTF-8")
# 
# # 然后对 demo.csv$`各位代表：` 进行分词即可
# demo.engine1.csv <- worker()
# words.csv <- segment(demo.csv$`各位代表：`, demo.engine1.csv)


# -------- 初步分词 --------

# 设置分词函数
demo.engine1 <- worker()

# 进行初步分词
demo.words <- segment(data.txt, demo.engine1)

# 查看1~300个分词结果
demo.words[1:300]

# -------- 对初步分词结果进行统计及导出 --------

# 词频统计
demo.wordsfreq <- jiebaR::freq(demo.words)

# 利用arrange函数对词频进行降序，并查看前30个分词结果
arrange(demo.wordsfreq, desc(freq))[1:30, ]
# arrange(demo.wordsfreq, -freq)[1:30,]

# 以txt格式导出分词文件
options(max.print = 1000000)
capture.output(demo.words, file = "demo.words.txt")

# 以csv格式导出词频结果
demo.freqtop300 <- arrange(demo.wordsfreq, -freq)[1:300, ]
bruceR::export(demo.freqtop300, file = "demo.freqtop300.csv")


# -------- 对分词结果进行改进 --------

# 通过对分词文件以及词频的查看，可以发现，存在一些如"和"、"的"等无意义的单个词，以及存在部分数字，此时，我们可以将这些需要去除的字或词加入到停用词表中；此外，也有一些词可能并没有分出来，如”一带一路“、”新时代“、”脱贫攻坚“等，此时需要我们将未分出来的词添加到自定义词表中，从而实现精确分词。
# 首先需要在工作路径下建立两个txt文档，一个命名为user，一个命名为stopwords，并保存为utf-8格式（也可以根据需要自己不断进行添加和优化）。

# 通过去停用词以及自定义词对分词结果做进一步的优化

data.txt <- scan("2020年福建省人民政府工作报告.txt", what = "", sep = "\n", encoding = "UTF-8")

engine1 <- worker(user = "user.txt", stop_word = "stopwords.txt")
words <- segment(data.txt, engine1)
words |> head()

words.freq <- freq(words)
arrange(words.freq, desc(freq))[1:30, ]

# words |> as_tibble() %>%
#   count(value, sort = TRUE) %>%
#   mutate(freq = n / sum(n))

# 导出分词文件
options(max.print = 1000000)
capture.output(words, file = "My file.txt")
# bruceR::export(words, file = "My file.txt", encoding = "UTF-8")


# 导出词频文件
words.freqtop300 <- arrange(words.freq, -freq)[1:300, ]
write.csv(words.freqtop300, file = "words.freqtop300.csv", row.names = FALSE)
# bruceR::export(words.freqtop300, file = "words.freqtop300.csv", encoding = "UTF-8")


# -------- 对高频词进行可视化 ---------

# 1.利用wordcloud2包绘制词云图对高频词进行可视化

library(wordcloud2)

# 选择前100个高频词进行词云图绘制
word.freq_new <- words.freqtop300[1:100, ]
wordcloud2(word.freq_new, size = 1, minRotation = -pi / 6, maxRotation = -pi / 6, rotateRatio = 1, shape = "circle")

# 2.利用barplot函数绘制柱状图对高频词进行可视化

# 绘制排名前20的高频词：其中barplot第一个参数为数据源，第二个参数为标签
barplot(word.freq_new$freq[1:20], names.arg = word.freq_new$char[1:20])

# 对柱状图颜色进行修改，指定颜色
barplot(word.freq_new$freq[1:20], names.arg = word.freq_new$char[1:20], xlab = "词语", ylab = "频次", las = 3, col = "lightblue")

# 对柱状图颜色进行修改,生成彩虹色
barplot(word.freq_new$freq[1:20], names.arg = word.freq_new$char[1:20], xlab = "词语", ylab = "频次", las = 2, col = rainbow(20))

# 调用RColorBrewer包对图形颜色进行修改

library(RColorBrewer)
# 生成颜色
newpalette1 <- colorRampPalette(brewer.pal(8, "YlGnBu"))(30)
newpalette2 <- colorRampPalette(brewer.pal(8, "Purples"))(30)

# 进行颜色填充
barplot(word.freq_new$freq[1:30],
  names.arg = word.freq_new$char[1:30],
  xlab = "词语", ylab = "频次", las = 3,
  col = rev(newpalette1)
)
barplot(word.freq_new$freq[1:30],
  names.arg = word.freq_new$char[1:30],
  xlab = "词语", ylab = "频次", las = 3,
  col = rev(newpalette2)
)
# 部分参数含义：xlab表示y轴标题，ylab表示y轴标题，las表示标签垂直，col表示颜色，rev函数表示对颜色进行反转。

# 3.利用pie函数绘制饼图对高频词进行可视化

number <- word.freq_new$freq[1:20] # 提取数值
label <- word.freq_new$char[1:20] # 提取标签

# 不带比例的饼图
pie(number, label, main = "TOP20词语")

# 绘制带比例的饼图
pie.pct <- round(number / sum(number) * 100) # 计算比例
pie.label <- paste(label, " ", pie.pct, "%", sep = "") # 标签设置
pie(number, pie.label, main = "TOP20词语") # 绘制饼图，并添加图标题
