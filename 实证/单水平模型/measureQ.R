library(measureQ)

data(Data_A)

Model.A <- "
  EB =~ EB1 + EB2 + EB3 +EB4 + EB5 + EB6 + EB7 + EB8
  IV =~ IV1 + IV2 + IV3 + IV4 + IV5
  NVG =~ NVG1 + NVG2 + NVG3
  NVA =~ NVA1 + NVA2 + NVA3 + NVA4
"

measureQ(Model.A, Data_A, b.no = 500, CI = "BCCI", HTMT = "TRUE")
