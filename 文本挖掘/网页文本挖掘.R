library(rvest)
library(tidytext)
library(tidyverse)
library(bruceR)

# -------- 读取网页数据--------

# 以2024政府工作报告为例
url <- "https://www.cs.com.cn/xwzx/hg/202403/t20240312_6394477.html"

read_speech <- read_html(url) %>%
  html_elements("p") %>%
  html_text()
head(read_speech)
tail(read_speech)


# -------- 调整数据 --------

speech_r <- tibble(paragraph = 1:length(read_speech), text= read_speech)
speech_r

speech_r |> View()

# 因为中文中有很多没有意义的停用词，因此自定义一些停用词

stop_words <- tibble(word = cc("我, 你, 她, 吗, 他, 的, 是, 和, 化, 等, 要, 为, 性"))


# 使用unnest_tokens拆分成单独的单词

word_tokens <- speech_r %>%
  unnest_tokens(output = word, input = text) %>%
  anti_join(stop_words, by = "word") %>% # 在结果中去掉停用词
  count(word, sort = TRUE)
word_tokens

# 1 发展    140
# 2 建设     84
# 3 加强     69
# 4 推进     69
# 5 政策     66
# 6 经济     63
# 7 推动     59
# 8 实施     47
# 9 服务     47
# 10 高      47

# jiebaR的分词结果

wk <- worker()
jieba_words <- segment(speech_r$text, wk)
jieba_words |>
  as_tibble() |>
  rename(word = value) |> 
  anti_join(stop_words, by = "word") |> 
  count(word, sort = TRUE)

# 1 发展    129
# 2 建设     82
# 3 推进     69
# 4 加强     68
# 5 推动     59
# 6 政策     53
# 7 实施     45
# 8 经济     45
# 9 加快     43
# 10 新      42

# -------- 数据可视化 --------

ggplot(data = word_tokens[1:10, ], aes(n, reorder(word, n))) +
  geom_col(color = "#FF6885", fill = "#FF6885") +
  labs(y = NULL) + theme_test()
