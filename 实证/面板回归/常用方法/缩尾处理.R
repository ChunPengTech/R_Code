# data是数据集合，p是需要缩尾的百分数，初始设定是1%，drop如果赋值为FALSE，则用对两端的极端值用1%处的数值替代，如果赋值为TRUE，则极端值会被直接删除（显示成NA）。

winsorize <- function(data, p = 0.01, drop = FALSE) {
  q <- 1 - p
  trim <- quantile(data, c(p, q), na.rm = T) # 缺失值不参与
  if (drop == FALSE) {
    data[data < trim[1]] <- trim[1]
    data[data > trim[2]] <- trim[2]
  } else if (drop == TRUE) {
    data[data < trim[1]] <- NA
    data[data > trim[2]] <- NA
  }
  data
}



