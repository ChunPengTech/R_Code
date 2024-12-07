library(tidyverse)
library(tidytext)
library(jiebaR)

# -------- 分词初步 --------

text <- c(
  "床前明月光，",
  "疑是地上霜。",
  "举头望明月，",
  "低头思故乡。"
)
text


# jiebaR::segment函数

cut <- worker()
text_jieba <- segment(text, cut)
tibble(line = 1:length(text_jieba), text = text_jieba)


cutter <- worker(bylines = TRUE, symbol = TRUE)
# bylines按输入文件的行数返回结果
# symbol是否在句子中保留符号

text_wb <- sapply(segment(text, cutter), function(x) {
  paste(x, collapse = " ")
})
text_wb

# 先用jiebaR分词，用空格分隔分词结果，然后使用 tidytext::unnest_tokens函数
text_df <- tibble(line = 1:length(text), text = text_wb)
text_df

text_df %>%
  unnest_tokens(word, text) # unnest_tokens的处理对象是数据框类

# 对比下来jiebaR的中文分词明显更好


# -------- 用 tidy 处理英文名著 --------

# 英文例子使用 janeaustenr (Silge 2017) 引入 Jane Austen 的六部完整已发表小说的文本。
# janeaustenr 包提供的文本格式每行为书页里的一行，这个行严格对应着实体书里印刷的行。

library(janeaustenr)
austen_books()

original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(
    linenumber = row_number(),
    chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
      # regex使用正则表达式，^chapter表示以chapter开头，\\转义字符
      ignore_case = TRUE
    )))
  ) %>%
  ungroup()
original_books

tidy_books <- original_books %>%
  unnest_tokens(word, text)
tidy_books

# tidytext自带的stop_words
data(stop_words)

tidy_books <- tidy_books %>%
  anti_join(stop_words, by = "word")

# 统计频率
tidy_books %>%
  count(word, sort = TRUE)


# 可视化
tidy_books |>
  count(word, sort = TRUE) |>
  filter(n > 600) |>
  mutate(word = reorder(word, n)) |>
  ggplot(aes(x = n, y = word)) +
  geom_col() +
  xlab(NULL) + # 去掉x轴的标题
  coord_flip() # 反转x和y轴，其实可以直接在aes指定x和y

# -------- 用 tidy 处理中文名著 --------

# devtools::install_github("boltomli/mingqingxiaoshuor")
library(mqxsr)

mingqingxiaoshuo <- books()

cutter <- worker(bylines = TRUE, stop_word = "all_stopwords.txt")

tidy_mingqingxiaoshuo <- mingqingxiaoshuo %>%
  mutate(text = sapply(segment(text, cutter), function(x) {
    paste(x, collapse = " ")
  })) %>%
  unnest_tokens(word, text)

tidy_mingqingxiaoshuo %>%
  count(word, sort = TRUE) |>
  filter(n > 5000)

# -------- 词频 --------

library(gutenbergr)

# 冯梦龙的小说
sanyan <- gutenberg_download(c(24141, 24239, 27582))

# 袁枚的小说
zibuyu <- gutenberg_download(c(25245, 25315))


# 三言和子不语最常用的词是什么

cutter <- worker(bylines = TRUE, stop_word = "all_stopwords.txt")

tidy_sanyan <- sanyan %>%
  mutate(text = sapply(segment(text, cutter), function(x) {
    paste(x, collapse = " ")
  })) %>%
  unnest_tokens(word, text)

tidy_sanyan %>%
  count(word, sort = TRUE)

tidy_zibuyu <- zibuyu %>%
  mutate(text = sapply(segment(text, cutter), function(x) {
    paste(x, collapse = " ")
  })) %>%
  unnest_tokens(word, text)

tidy_zibuyu %>%
  count(word, sort = TRUE)

# 计算一下每个词在每位作家的作品中出现的频率，把数据框绑定到一起。可以使用 tidyr 中的 spread 和 gather 重新定形数据框，只留下绘图需要的点，以便对三个作品集进行比较。

frequency <- bind_rows(
  mutate(tidy_zibuyu, author = "袁枚"),
  mutate(tidy_sanyan, author = "冯梦龙"),
  mutate(tidy_mingqingxiaoshuo, author = "Various")
) %>%
  # mutate(word = str_extract(word, "[a-z']+")) %>%
  mutate(word = str_extract(word, "[^a-z0-9']+")) %>%
  count(author, word) %>%
  group_by(author) %>%
  mutate(proportion = n / sum(n)) %>%
  select(-n) %>%
  spread(author, proportion) %>%
  gather(author, proportion, `袁枚`:`冯梦龙`)

library(scales)

ggplot(frequency, aes(x = proportion, y = `Various`, color = abs(`Various` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5, family = "wqy-microhei") +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +
  facet_wrap(~author, ncol = 2) +
  theme(legend.position = "none") +
  labs(y = "Various", x = NULL) +
  theme(text = element_text(family = "wqy-microhei"))

cor.test(data = frequency[frequency$author == "冯梦龙",], ~ proportion + `Various`)

cor.test(data = frequency[frequency$author == "袁枚",], ~ proportion + `Various`)

# 词频在四大名著和冯梦龙的小说中相关度要高于四大名著和袁枚的随笔中。基本上，这个结论也符合主观的观感