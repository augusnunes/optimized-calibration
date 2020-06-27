library(tidyverse)

setwd("~/Documents/IC-2020/optimized-calibration/gradient/f_b/")

## Grupo 1
# sem fazer a média
dados = read.csv("rugo_1/dados.csv")
dados %>%
  ggplot(mapping = aes(x=rugosidade, y=erro))+
  geom_line()+
  ggtitle("Grupo 1: dados completos")+
  ggsave("rugo_1/g1.png")
# aproximando 
d = dados %>% 
  filter(rugosidade>0.00999 & rugosidade < 0.01001)
d %>%
  ggplot(mapping = aes(x=rugosidade, y=erro))+
  geom_line()+
  ggtitle("Grupo 1:dados completos (aproximado)")+
  ggsave("rugo_1/g1_aprox.png")

# fazendo a média
dados = read.csv("rugo_1/dados_completos.csv")
dados %>%
  ggplot(mapping = aes(x=rugosidade, y=erro))+
  geom_line()+
  ggtitle("Grupo 1: sem média")+
  ggsave("rugo_1/g1_completos.png")
# aproximando 
d = dados %>% 
  filter(rugosidade>0.00999 & rugosidade < 0.01001)
d %>%
  ggplot(mapping = aes(x=rugosidade, y=erro))+
  geom_line()+
  ggtitle("Grupo 1: sem media (aproximado)")+
  ggsave("rugo_1/g1_aprox_completos.png")

# arredondando erro
d$erro = round(d$erro, digits = 7)
d %>%
  ggplot(mapping = aes(x=rugosidade, y=erro))+
  geom_line()


# pegando dados errados
dados = read.csv("rugo_1/errado.csv")
dados %>%
  ggplot(mapping = aes(x=rugosidade, y=erro))+
  geom_line()+
  ggtitle("Grupo 1: dados completos")
d = dados %>% 
  filter(rugosidade>0.00999 & rugosidade < 0.01001)
d %>%
  ggplot(mapping = aes(x=rugosidade, y=erro))+
  geom_line()+
  ggtitle("Grupo 1: dados completos")
