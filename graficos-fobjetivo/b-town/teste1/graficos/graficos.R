
library(tidyverse)
library(stringr)
library(ggplot2)
install.packages('tidyverse')

for (i in 1:200){
  df = read_csv(str_c('./Documents/IC-2020/optimized-calibration/graficos-fobjetivo/b-town/teste1/dados/',i, '.csv'))
  rugosidade = i
  df %>% 
    ggplot(mapping = aes(x = Rg2, y = Rg3, color = Erro))+
    geom_point()+ 
    scale_color_gradientn(colours = rainbow(20), limit=c(0.07,0.1))+
    labs(x = "Rugosidade 2", y = "Rugosidade 3", color = "Erro")+
    ggtitle(str_c("Rugosidade: ", as.double(rugosidade)/1000))+
    ggsave(file=str_c(rugosidade,'.png'), path =str_c('./Documents/IC-2020/optimized-calibration/graficos-fobjetivo/b-town/teste1/graficos/'))
  print(i)
}

i=10
rugosidade = 10
df = read_csv(str_c('./Documents/IC-2020/optimized-calibration/graficos-fobjetivo/b-town/teste1/dados/',i, '.csv'))
df %>% 
  ggplot(mapping = aes(x = Rg2, y = Rg3, color = Erro))+
  geom_point()+ 
  scale_color_gradientn(colours = rainbow(20), limit=c(0.07,0.1))+
  labs(x = "Rugosidade 2", y = "Rugosidade 3", color = "Erro")+
  ggtitle(str_c("Rugosidade: ", as.double(rugosidade)/1000))+
  geom_point(x=0.069,y=0.115, color='black')+
  labs(x = "Rugosidade 2", y = "Rugosidade 3", color = "Erro")+
  ggtitle(str_c("Rugosidade: ", as.double(rugosidade)/1000))+
  ggsave(file=str_c(rugosidade,'.png'), path =str_c('./Documents/IC-2020/optimized-calibration/graficos-fobjetivo/b-town/teste1/graficos/'))
  
  
  