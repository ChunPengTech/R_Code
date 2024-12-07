library(bruceR)
library(gtsummary)

set.wd()

data <- import("basic info.xlsx", as = "data.frame")

# -------- 不进行任何设置 --------
data %>%
  tbl_summary()

dat <- data.frame(lapply(data[2:11], as.factor)) # 批量转换为因子型
data1 <- cbind(data[1], dat)
str(data1)

# -------- by=Size明确分组变量，并增加组间比较的P值add_p() --------
data1 %>%
  tbl_summary(by = Size) %>%
  add_p() %>%
  add_overall()

one <- data1 %>%
  tbl_summary(
    by = Size,
    type = all_continuous() ~ "continuous2",
    statistic = all_continuous() ~ c(
      "{mean} ({sd})",
      "{median} ({p25}, {p75})",
      "{min}, {max}"
    )
  ) %>%
  add_p(pvalue_fun = ~ style_pvalue(.x, digits = 2))

one

one %>%
  as_gt() %>%
  gt::gtsave("tab_1.rtf") # use extensions .html .tex .ltx .rtf ;default path

data1 %>%
  tbl_summary(
    by = Size,
    type = all_continuous() ~ "continuous2",
    statistic = all_continuous() ~ c(
      "{mean} ({sd})",
      "{median} ({p25}, {p75})",
      "{min}, {max}"
    ),
    digits = all_continuous() ~ 2
  ) %>%
  add_p(
    pvalue_fun = ~ style_pvalue(.x, digits = 3),
    list(
      all_continuous() ~ "t.test",
      all_categorical() ~ "fisher.test"
    )
  ) %>%
  modify_caption("Characteristics") %>%
  as_gt() %>%
  gt::tab_source_note(gt::md("*This data is simulated*"))