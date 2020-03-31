library(tidyverse)
library(gganimate)
library(stringr)

# Gráficos com animação
df = read_csv('./Documents/IC-2020/epanet_arquivos/grafico1/dados_menor.csv')
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
  df = read_csv(str_c('./Documents/IC-2020/epanet_arquivos/grafico1/dados/',i,'.csv'))
  df %>% 
    ggplot(mapping = aes(x = R1, y = R2, color = erro))+
    geom_point()+
    scale_color_gradientn(colours = rainbow(10))+
    labs(x = "Rugosidade 1", y = "Rugosidade 2", color = "Erro entre Pressão simulada e Pressão real")+
    ggtitle(str_c("Rugosidade 1:",i/1000))+
    ggsave(file=str_c(i+'.png'), path =str_c('./Documents/IC-2020/epanet_arquivos/grafico1/grafico/'))
  
}

# Sliced Graphic (dados completos)
for(i in 1:20){
  df = read_csv(str_c('./Documents/IC-2020/epanet_arquivos/grafico1/dados_menor/',i,'.csv'))
  df %>% 
    ggplot(mapping = aes(x = R1, y = R2, color = erro))+
    geom_point()+
    scale_color_gradientn(colours = rainbow(10))+
    labs(x = "Rugosidade 1", y = "Rugosidade 2", color = "Erro entre Pressão simulada e Pressão real")+
    ggtitle(str_c("Rugosidade 1:",i/1000))+
    ggsave(file=str_c(i,'.png'), path =str_c('./Documents/IC-2020/epanet_arquivos/grafico1/grafico_menor/'))
  
}

df = read_csv('./Documents/IC-2020/epanet_arquivos/grafico1/dados.csv')
colnames(df) = c('R1', 'R2', 'R3','erro')

#View(df)
faixas = c(0.0, 0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.007, 0.008, 0.009, 0.01, 0.011, 0.012, 0.013, 0.014, 0.015, 0.016, 0.017, 0.018, 0.019, 0.02, 0.021, 0.022, 0.023, 0.024, 0.025, 0.026, 0.027, 0.028, 0.029, 0.03, 0.031, 0.032, 0.033, 0.034, 0.035, 0.036, 0.037, 0.038, 0.039, 0.04, 0.041, 0.042, 0.043, 0.044, 0.045, 0.046, 0.047, 0.048, 0.049, 0.05, 0.051, 0.052, 0.053, 0.054, 0.055, 0.056, 0.057, 0.058, 0.059, 0.06, 0.061, 0.062, 0.063, 0.064, 0.065, 0.066, 0.067, 0.068, 0.069, 0.07, 0.071, 0.072, 0.073, 0.074, 0.075, 0.076, 0.077, 0.078, 0.079, 0.08, 0.081, 0.082, 0.083, 0.084, 0.085, 0.086, 0.087, 0.088, 0.089, 0.09, 0.091, 0.092, 0.093, 0.094, 0.095, 0.096, 0.097, 0.098, 0.099, 0.1, 0.101, 0.102, 0.103, 0.104, 0.105, 0.106, 0.107, 0.108, 0.109, 0.11, 0.111, 0.112, 0.113, 0.114, 0.115, 0.116, 0.117, 0.118, 0.119, 0.12, 0.121, 0.122, 0.123, 0.124, 0.125, 0.126, 0.127, 0.128, 0.129, 0.13, 0.131, 0.132, 0.133, 0.134, 0.135, 0.136, 0.137, 0.138, 0.139, 0.14, 0.141, 0.142, 0.143, 0.144, 0.145, 0.146, 0.147, 0.148, 0.149, 0.15, 0.151, 0.152, 0.153, 0.154, 0.155, 0.156, 0.157, 0.158, 0.159, 0.16, 0.161, 0.162, 0.163, 0.164, 0.165, 0.166, 0.167, 0.168, 0.169, 0.17, 0.171, 0.172, 0.173, 0.174, 0.175, 0.176, 0.177, 0.178, 0.179, 0.18, 0.181, 0.182, 0.183, 0.184, 0.185, 0.186, 0.187, 0.188, 0.189, 0.19, 0.191, 0.192, 0.193, 0.194, 0.195, 0.196, 0.197, 0.198, 0.199,0.2)
faixas_menor = c(0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2)
df['R1_faixas'] = cut(df$R1, breaks = faixas)
df['erro_faixas'] = cut(df$erro, breaks = 10)
#summary(df$R1_faixas)

options(gganimate.nframes = 50)

df %>% 
  ggplot(mapping = aes(x = R1, y = R2, color = erro))+
    geom_point()+
    scale_color_gradientn(colours = rainbow(10))+
    labs(x = "Orçamento", y = "Arrecadação", color = "Houve lucro?")+
    ggtitle(str_c("Rugosidade 1:",0.001))


p = df %>% 
  ggplot(mapping = aes(x = R2, y = R3, color = erro_faixas))+
  geom_point()+
  scale_colour_manual(values = rainbow(10))+
p+
  transition_states(df$R1_faixas, transition_length = 0, state_length = 1)+
  ggtitle('Rugosidade do Grupo 1: {closest_state}',
          subtitle = 'Frame {frame} of {nframes}')



#mtcars

#a = c( 0, 1, 2, 3, 4 )

#summary(df$R1_faixas)
#df$R1_faixas <- cut(df$R1, a, include.lowest=T)
#summary(df$R1_faixas)
