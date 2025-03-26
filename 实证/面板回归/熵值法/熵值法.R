pacman::p_load(
  tidyverse, bruceR
)

set.wd()
data <- import("data.xlsx", as = "tibble")

# -------- 1. 数据标准化 --------

# # 正向指标标准化函数
# normalize_positive <- function(x) {
#   return((x - min(x)) / (max(x) - min(x)))
# }
# # == bruceR::scaler
# 
# # 负向指标标准化函数
# normalize_negative <- function(x) {
#   return((max(x) - x) / (max(x) - min(x)))
# }
# # == 1 - bruceR::scaler

# 标准化所有指标
data_norm_p <- as_tibble(lapply(data[, 3:25], scaler))
data_norm_n <- 1 - as_tibble(lapply(data[, 26:28], scaler))
data_norm <- bind_cols(data_norm_p, data_norm_n)

#-------- 2. 计算比重 --------
p <- as_tibble(lapply(data_norm, function(x) {
  p <- x / sum(x)
  return(p)
}))

#-------- 3. 计算熵值 --------
calculate_entropy <- function(data_norm) {
  k <- 1 / log(nrow(data_norm))  # 本代码此处样本量作为对数底
  entropy <- -k * colSums(p * log(p), na.rm = TRUE)
  return(entropy)
}

entropy <- calculate_entropy(data_norm)

#-------- 4. 计算权重 --------
calculate_weights <- function(entropy) {
  weight <- (1 - entropy) / sum(1 - entropy)
  return(weight)
}

weights <- calculate_weights(entropy)

# -------- 5. 计算最终得分 --------
data_score <- data_norm

for (i in 1:length(data_score)) {
  data_score[i] <- data_score[i] * weights[i]
}

# data_score[] <- lapply(1:ncol(data_score), function(i) {
#   data_score[[i]] * weights[i]
# })

# mapply将多个向量或列表的元素进行逐元素的操作
# data_score[] <- mapply(function(score, weight) {
#   score * weight
# }, data_score, weights)

scores <- rowSums(data_score)

data$scores <- scores

# -------- 6. 输出结果 --------

# 综合得分
data_fin <- data |>
  select(province, year, scores)
data_fin |> print(n = 11)

# 长数据变宽数据
data_fin |> pivot_wider(
  names_from = "year",
  values_from = "scores"
) |> View()

# 权重
tibble(var = paste0("x", 1:26), weights = weights)
