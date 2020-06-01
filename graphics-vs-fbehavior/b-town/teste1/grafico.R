library(tidyverse)
library(gganimate)
library(stringr)


setwd("~/Documents/IC-2020/optimized-calibration/graphics-vs-fbehavior/b-town/teste1/")

# Gráficos com animação
df = read_csv('./dados_menor/dados_menor.csv')
colnames(df) = c('R1', 'R2', 'R3','erro')
faixas_menor = c(0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2)
df['R1_faixas'] = cut(df$R1, breaks = faixas_menor)
df['erro_faixas'] = cut(df$erro, breaks = 10)
options(gganimate.nframes = 1000)
p = df %>% 
  ggplot(mapping = aes(x = R2, y = R3, color = erro_faixas))+
  geom_point()+
  scale_colour_manual(values = rainbow(10))
p+
  transition_states(df$R1_faixas, transition_length = 1, state_length = 1)+
  ggtitle('Rugosidade do Grupo 1: {closest_state}',
          subtitle = 'Frame {frame} of {nframes}')


# Sliced Graphic (dados completos)
for(i in 1:200){
  df = read_csv(str_c('./dados/',i,'.csv'))
  df %>% 
    ggplot(mapping = aes(x = R1, y = R2, color = erro))+
    geom_point()+
    scale_color_gradientn(colours = rainbow(10))+
    labs(x = "Rugosidade 1", y = "Rugosidade 2", color = "Erro entre Pressão simulada e Pressão real")+
    ggtitle(str_c("Rugosidade 1:",i/1000))+
    ggsave(file=str_c(i+'.png'), path =str_c('./graficos/'))
  
}

# Sliced Graphic (dados completos)
for(i in 1:20){
  df = read_csv(str_c('./dados_menor/',i,'.csv'))
  df %>% 
    ggplot(mapping = aes(x = R1, y = R2, color = erro))+
    geom_point()+
    scale_color_gradientn(colours = rainbow(10))+
    labs(x = "Rugosidade 1", y = "Rugosidade 2", color = "Erro entre Pressão simulada e Pressão real")+
    ggtitle(str_c("Rugosidade 1:",i/1000))+
    ggsave(file=str_c(i,'.png'), path =str_c('./graficos_menor/'))
  
}

df = read_csv('./dados_menor/dados_menor.csv')
colnames(df) = c('R1', 'R2', 'R3','erro')

faixas_menor = c(0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2)
df['R1_faixas'] = cut(df$R1, breaks = faixas_menor)
df['erro_faixas'] = cut(df$erro, breaks = 10)

options(gganimate.nframes = 50)

p = df %>% 
  ggplot(mapping = aes(x = R2, y = R3, color = erro_faixas))+
  geom_point()+
  scale_colour_manual(values = rainbow(10))+
p+
  transition_states(df$R1_faixas, transition_length = 0, state_length = 1)+
  ggtitle('Rugosidade do Grupo 1: {closest_state}',
          subtitle = 'Frame {frame} of {nframes}')

