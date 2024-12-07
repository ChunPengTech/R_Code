z <- function(a,b,se_a,se_b){
  se_ab <- sqrt(a^2*se_b^2+b^2*se_a^2) 
  z <- round(a*b/se_ab,3) 
  # print(paste0("z = ",z))
  
  if(z > 1.96){
    print(paste0(z," > 1.96，中介效应存在"))
  }
  else{
    print(paste0(z," < 1.96，中介效应存在"))
  }
}

a = 0.154
b = 0.233
se_a = 0.051
se_b = 0.076

z(a, b, se_a, se_b)