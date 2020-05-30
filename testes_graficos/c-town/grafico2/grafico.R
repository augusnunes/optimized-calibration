library(tidyverse)

lista = c('19.csv', '214.csv', '104.csv', '131.csv', '302.csv', '59.csv', '136.csv', '81.csv', '282.csv', '144.csv', '86.csv', '192.csv', '254.csv', '239.csv', '294.csv', '46.csv', '184.csv', '242.csv', '41.csv', '129.csv', '237.csv', '34.csv', '99.csv', '115.csv', '202.csv', '169.csv', '279.csv', '277.csv', '74.csv', '229.csv', '56.csv', '284.csv', '51.csv', '194.csv', '252.csv', '4.csv', '139.csv', '24.csv', '227.csv', '89.csv', '11.csv', '212.csv', '179.csv', '269.csv', '16.csv', '64.csv', '267.csv', '177.csv', '166.csv', '161.csv', '113.csv', '204.csv', '121.csv', '49.csv', '231.csv', '126.csv', '292.csv', '154.csv', '91.csv', '182.csv', '244.csv', '96.csv', '76.csv', '209.csv', '119.csv', '272.csv', '71.csv', '159.csv', '31.csv', '36.csv', '249.csv', '247.csv', '44.csv', '146.csv', '197.csv', '84.csv', '141.csv', '287.csv', '224.csv', '289.csv', '199.csv', '9.csv', '134.csv', '69.csv', '101.csv', '106.csv', '174.csv', '264.csv', '187.csv', '156.csv', '39.csv', '151.csv', '297.csv', '94.csv', '234.csv', '299.csv', '189.csv', '124.csv', '79.csv', '111.csv', '206.csv', '164.csv', '274.csv', '66.csv', '172.csv', '219.csv', '109.csv', '61.csv', '262.csv', '14.csv', '217.csv', '149.csv', '21.csv', '222.csv', '26.csv', '259.csv', '28.csv', '1.csv', '54.csv', '257.csv', '6.cs')
length(lista)
for(i in 1:length(lista)){
  df = read_csv(str_c('./Documents/IC-2020/epanet_arquivos/c-town/grafico2/dados/',lista[i]))
  rugosidade = str_remove(lista[i],'.csv')
  df['erro_20_50_70'] = (df['erro_20']+df['erro_50']+ df['erro_70'])/9
  df %>% 
    ggplot(mapping = aes(x = r2, y = r3, color = erro_20_50_70))+
    geom_point()+
    scale_color_gradientn(colours = rainbow(20), limit=c(0,4))+
    labs(x = "Rugosidade 2", y = "Rugosidade 3", color = "Erro entre Ps e Pr")+
    ggtitle(str_c("Rugosidade: ", as.double(rugosidade)/100))+
    ggsave(file=str_c(rugosidade,'.png'), path =str_c('./Documents/IC-2020/epanet_arquivos/c-town/grafico2/graficos/rainbow/'))
 }
