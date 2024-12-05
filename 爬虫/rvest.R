library(rvest)
library(bruceR)

# -------- 简单上手 --------

HTML <- read_html(x = "https://hz.fang.anjuke.com/loupan/xiaoshanqu_1919/?from=loupan_index_crumb")
HTML
NAME <- HTML %>% html_nodes("#container > div.list-contents.theme-ajk-listcont > div.list-results > div.key-list.imglazyload > div:nth-child(1)") 
NAME
NAME %>% html_text()

# -------- 爬取BOSS直聘数据（数据分析职位） --------

url <- "https://www.zhipin.com/web/geek/job?query=%E6%95%B0%E6%8D%AE%E5%88%86%E6%9E%90"
HTML <- read_html(url)
HTML

JobName <- HTML %>% html_nodes(".job-name") %>% html_text()
JobArea <- HTML %>% html_nodes(".job-area") %>% html_text()
Salary <- HTML %>% html_nodes(".salary") %>% html_text()
CompanyName <- HTML %>% html_nodes(".company-name") %>% html_text()

Result <- data.frame(JobName, JobArea, Salary, CompanyName)
head(Result)

# -------- 谷歌学术panda985 --------

url <- "https://sc.panda985.com/scholar?hl=zh-cn&q=knowledge+management"

HTML <- read_html(url)
HTML

Title <- HTML %>% html_nodes(".gs_rt") %>% html_text()
Basic_info<- HTML %>% html_nodes(".gs_a") %>% html_text()
Cite <- HTML %>% html_nodes(".gs_flb") %>% html_text()

Result <- data.frame(Title, Basic_info, Cite)
head(Result)

Result %>% export(file = "Result.xlsx")


# -------- 谷歌学术panda985循环1-10页 --------

library(tidyverse)

i <-  0:9
Paper_inf <- data.frame()

for(i in 0:9){

  string1 <- "https://sc.panda985.com/scholar?start="
  string2 <- i
  string3 <- "0&q=knowledge+management&hl=zh-CN&as_sdt=0,5"
  url <- paste(string1, string2, string3, sep ="")
  
  HTML <- read_html(url, encoding = "UTF-8")
  
  Title <- HTML %>% html_nodes(".gs_rt") %>% html_text()
  Basic_info<- HTML %>% html_nodes(".gs_a") %>% html_text()
  Cite <- HTML %>% html_nodes(".gs_flb") %>% html_text()
  
  Result <- data.frame(Title, Basic_info, Cite)
  
  Paper_inf <- rbind(Paper_inf, Result)
  
}

Paper_inf %>% export(file = "Result_1-10.xlsx")


# -------- 豆瓣新片榜 --------

urlnew <-  "https://movie.douban.com/chart"

HTMLN <- read_html(urlnew, encoding = "UTF-8")
HTMLN
HTMLN %>% html_nodes(xpath = "//td[2]/div/a") %>% html_text2(preserve_nbsp = F)
## html_text(trim=T) 删除前导和尾随空格
## html_text2(preserve_nbsp = F) 删除不间断空格


# -------- 爬取芳华豆瓣数据 --------

url_fanghua <-  "https://movie.douban.com/subject/26862829/"

HTML <- read_html(url_fanghua, encoding = "UTF-8")
HTML

## 提取名字和年份
Name <- HTML %>% html_nodes(xpath="/html/body/div[3]/div[1]/h1/span")
Name %>% html_text()

## 影片详情
HTML %>% html_nodes(xpath = "//div[@id = 'info']") %>% html_text()
## //表示选择任意的节点，@表示选择属性
HTML %>% html_nodes(xpath = "//*[@id = 'info']") %>% html_text()
## *表示匹配任何元素节点，代替前面所有内容
Detail <- HTML %>% html_nodes("div#info")
## #表示标记
Detail %>% html_text(trim=T)

## 详情中的人名
HTML %>% html_nodes(xpath = "//*[(@id = 'info')]//a") %>% html_text()
HTML %>% html_nodes(".attrs a") %>% html_text()
HTML %>% html_nodes(".attrs") %>% html_text()
## .rating_num是节点名称，然后加a将之区分成一列列，否则是合在一起的

# 评分
HTML %>% html_nodes(".rating_num") %>% html_text()
HTML %>% html_nodes(xpath = "//*[@id='interest_sectl']/div[1]/div[2]/strong") %>% html_text()
HTML %>% html_nodes(xpath = "//*[contains(concat( ' ', @class, ' ' ), concat( ' ', 'rating_num', ' ' ))]") %>% html_text()

## 短评
Reviews <- HTML %>% html_nodes(xpath = "//*[(@id = 'reviews-wrapper')]") %>% html_text()
Reviews

# -------- 爬取链家网二手房数据 --------

#加载所需的包：
library(xml2)
library(rvest)
library(dplyr)
library(stringr)

#对爬取页数进行设定并创建数据框：
i <- 1:100
house_inf <- data.frame()

#利用for循环封装爬虫代码，进行批量抓取：
for (i in 1:100){

  #发现url规律(pg1-pg100)，利用字符串函数进行url拼接并规定编码：
  web <- read_html(str_c("http://hz.lianjia.com/ershoufang/pg", i), encoding = "UTF-8")
  
  #提取房名基本信息并消除空格
  house_basic_inf <- web %>% html_nodes(".houseInfo") %>% html_text()
  house_basic_inf <- str_replace_all(house_basic_inf, " ", "")
  
  #提取二手房名字和地址信息
  house_address <- web %>% html_nodes(".positionInfo") %>% html_text()
  house_address <- str_replace_all(house_address, " " ,"")
  
  #提取二手房总价信息
  house_totalprice <- web %>% html_nodes(".totalPrice2") %>% html_text()
  
  #提取二手房单价信息
  house_unitprice <- web %>% html_nodes(".unitPrice") %>% html_text()
  
  #创建数据框存储以上信息
  house<-data.frame(house_address, 
                    house_basic_inf, 
                    house_totalprice, 
                    house_unitprice)

  house_inf <- rbind(house_inf, house)
}

#将数据写入文档
library(bruceR)
set.wd()
house_inf %>% export(file = "house_inf.xlsx")

