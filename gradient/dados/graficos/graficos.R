library(tidyverse)
library(stringr)

setwd("~/Documents/IC-2020/optimized-calibration/gradient-teste/dados/graficos/")

for(i in 100:200){
  df = read.csv(str_c('../',i,'.csv'))
  df %>% 
    ggplot(mapping = aes(x = Rg2, y = Rg3, color = Erro))+
    geom_point()+
    scale_color_gradientn(colours = rainbow(10), limit=c(0.0928,0.093))+
    labs(x = "Rugosidade 2", y = "Rugosidade 3", color = "Erro entre Pressão simulada e Pressão real")+
    ggtitle(str_c("Rugosidade 1:",i/100000))+
    ggsave(file=str_c(i,'.png'), path =str_c('./'))
  
}

, limit=c(0.09,0.10)
