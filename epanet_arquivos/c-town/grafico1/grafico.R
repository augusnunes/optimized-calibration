library(tidyverse)

for(i in 1:200){
  df = read_csv(str_c('./Documents/IC-2020/epanet_arquivos/c-town/grafico1/dados/',i,'.csv'))
  df['erro_20_30_50_60_70'] = (df['erro_20']+df['erro_30']+df['erro_50']+df['erro_60'] + df['erro_70'])/9
  df %>% 
    ggplot(mapping = aes(x = r2, y = r3, color = erro_20_30_50_60_70))+
    geom_point()+
    scale_color_gradientn(colours = rainbow(4), limits=c(0,1))+
    labs(x = "Rugosidade 2", y = "Rugosidade 3", color = "Erro entre Ps e Pr")+
    ggtitle(str_c("Rugosidade: ", i/1000))+
    ggsave(file=str_c(i,'.png'), path =str_c('./Documents/IC-2020/epanet_arquivos/c-town/grafico1/graficos/rainbow/'))
 }
