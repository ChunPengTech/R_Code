# https://mp.weixin.qq.com/s/UKmVwXYTLO7UIRRbKaUv1Q

# 加载所需包
pacman::p_load(
  glmm.hp, ggplot2, bruceR
)

# 读取数据
data <- import("egdata.csv", as = "tibble")
head(data)

# 先进行线性回归
model <- lm(Target ~ pH + SWC + BD + SOC + TN + TP + DOC + DON + DOP, data)
# 输出模型摘要和 ANOVA 结果
lm_result <- summary(model)
lm_res <- lm_result$coefficients |> as_tibble() |> filter(Estimate < 10)
lm_res <- lm_res |> add_row(`Pr(>|t|)` = NA)

# 输出anova的结果，但是具体使用哪个结果，自己斟酌，通常会选择更符合自己预期的结果
anova_result <- anova(model)
anova_result |> print_table()

# lm结果：在回归分析中，lm的结果提供每个自变量在控制其他变量后对因变量的影响。在回归结果中，pH的p值为0.4983，这表明在考虑其他因素的影响后，pH对目标变量Target的影响并不显著。
# ANOVA结果：ANOVA主要用于检验每个自变量的独立贡献，并评估它们在模型中相对的解释能力。在ANOVA结果中，pH的p值极小（8.763e-09），这意味着如果只考虑pH对Target的影响而不控制其他变量，pH与Target之间的关系是显著的。

# 层次分割
result <- glmm.hp(model)

# 提取 I.perc(%) 和对应的指标名称，保持原始顺序
original_order <- cc("pH, SWC, BD, SOC, TN, TP, DOC, DON, DOP") # 原始顺序

data_plot <- data.frame(
  variable = rownames(result$hierarchical.partitioning),
  percentage = result$hierarchical.partitioning[, "I.perc(%)"]
)

# 提取显著性信息
# 假设 anova_result 中第 1 列为变量名，第 5 列为 p 值（请确认列索引）
significance <- data.frame(
  variable = rownames(anova_result),
  p_value = lm_res$`Pr(>|t|)`
)

# 合并显著性信息到绘图数据
data_plot <- merge(data_plot, significance, by = "variable", all.x = TRUE)

# 设置颜色条件：显著（p < 0.05）为蓝色，不显著为灰色
data_plot$color <- ifelse(data_plot$p_value < 0.05, "#F39B7FFF", "#8491B4FF")


# 保持原始顺序
data_plot$variable <- factor(data_plot$variable, levels = original_order)

# 创建一个新的变量，标识显著性
data_plot$significance <- ifelse(data_plot$p_value < 0.05, "Significant", "Not Significant")



# 创建极坐标柱状图，映射 fill 到 significance
ggplot(data_plot, aes(x = variable, y = percentage, fill = significance)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = round(percentage, 2)), vjust = -0.5, size = 3.5) + # 在柱形上方标记数据
  coord_polar(start = 1.5) + # 转换为极坐标，并设置起始角度
  ylim(-5, 30) + # 设置 y 轴范围，确保图形中心有空隙
  theme_minimal() +
  labs(y = "%IncMSE", x = "", fill = "Significance") + # 添加图例标题
  scale_fill_manual(values = c("Significant" = "#F39B7FFF", "Not Significant" = "#8491B4FF")) + # 自定义颜色
  theme(
    axis.text.x = element_text(size = 10, hjust = 1), # x 轴标签旋转
    panel.background = element_rect(fill = "white")
  )




# 按 percentage 降序排列
data_plot_sorted <- data_plot[order(-data_plot$percentage), ]

# 设置 variable 因子顺序为从大到小
data_plot_sorted$variable <- factor(data_plot_sorted$variable, levels = data_plot_sorted$variable)

# 添加柱形图，按降序排列
ggplot(data_plot_sorted, aes(x = variable, y = percentage, fill = significance)) +
  geom_bar(stat = "identity", width = 0.7) + # 调整柱形宽度
  geom_text(aes(label = round(percentage, 2)), vjust = -0.5, size = 3.5) + # 在柱形上方标记数据
  theme_minimal() +
  ylim(0, 30) + # 设置 y 轴范围
  labs(y = "%IncMSE", x = "", fill = "Significance") + # 添加图例标题
  scale_fill_manual(values = c("Significant" = "#F39B7FFF", "Not Significant" = "#8491B4FF")) + # 自定义颜色
  theme(
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1), # x 轴标签旋转以适应较长标签
    panel.background = element_rect(fill = "white")
  )
