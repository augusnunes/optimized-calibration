##
#   GRAFICO 4 - Mudando os grupos e a condição inicial - Usando outra rede (?)
##

import sys 
sys.path.append('/home/augusto/Documents/epanet-python/epanet-module')
import epamodule as em
import numpy as np 
import time
import pandas as pd

def muda_vazao(valor):  
    nodes = ["2","3","15","14","13","12","11","10","1","16","17","18","5","4","6","7","8","9"]
    for node in nodes:
        index = em.ENgetnodeindex(node)
        em.ENsetnodevalue(index, em.EN_BASEDEMAND, em.ENgetnodevalue(index, em.EN_BASEDEMAND)*valor) 

def reverte_vazao(valor):  
    nodes = ["2","3","15","14","13","12","11","10","1","16","17","18","5","4","6","7","8","9"]
    for node in nodes:
        index = em.ENgetnodeindex(node)
        em.ENsetnodevalue(index, em.EN_BASEDEMAND, em.ENgetnodevalue(index, em.EN_BASEDEMAND)/valor)

def muda_rugosidade(grupo, rugosidade):
    for i in grupo:
        linkindex = em.ENgetlinkindex(i)
        em.ENsetlinkvalue(linkindex, em.EN_ROUGHNESS, rugosidade)

def insere_data_frame(dic_row):
    dados = pd.DataFrame(dic_row)
    return df.append(dados, ignore_index=True)

# definindo a lista de trechos a qual será variada a rugosidade
g1 = ["2","3","15","14","13","12","11","10","1"]
g2 = ["16","17","18","19","20"]
g3 = ["5","4","6","7","8","9"]
valores_pressao = [[20, 26.434926986694336, 34.299713134765625, 32.01907730102539], [30, 26.037752151489258, 34.08491516113281, 31.50044059753418], [50, 24.853008270263672, 33.45237731933594, 29.963409423828125], [55, 24.47783660888672, 33.25362014770508, 29.47846031188965], [60, 24.071619033813477, 33.03902816772461, 28.954042434692383], [70, 23.16685676574707, 32.56293487548828, 27.788007736206055]]

# lendo arquivo que contem a rede e abrindo sistema de análise hidráulica
em.ENopen("/home/augusto/Documents/IC-2020/epanet_arquivos/grafico1/rede.inp")
em.ENopenH()

# Criando arquivo 
"""
arq = open("dados.csv", 'w')
arq.write("Rg1,Rg2,Rg3,Erro\n")
arq.close()
"""
# Criando DataFrame com pandas
df = pd.DataFrame()

# Criando vetor domínio da função
v = []
for i in np.linspace(0.001,0.2,200):
    v.append(round(i,3))

inicio = time.time()
for i in v:
    muda_rugosidade(g1, i)
    for j in v:
        muda_rugosidade(g2,j)
        for k in v:
            muda_rugosidade(g3, k)
            erro = {}
            erro['r1'] = [i]
            erro['r2'] = [j]
            erro['r3'] = [k]
            for posicao_pressao in valores_pressao:
                #posicao_pressao = valores_pressao[valor]
                muda_vazao(posicao_pressao[0])
                em.ENsolveH()
                n6 = np.abs(posicao_pressao[1]-em.ENgetnodevalue(em.ENgetnodeindex("6"), em.EN_PRESSURE))
                n11 = np.abs(posicao_pressao[2]-em.ENgetnodevalue(em.ENgetnodeindex("11"), em.EN_PRESSURE))
                n15 = np.abs(posicao_pressao[3] - em.ENgetnodevalue(em.ENgetnodeindex("15"), em.EN_PRESSURE))
                erro['erro_'+str(posicao_pressao[0])] = [n6 + n11 + n15]
                reverte_vazao(posicao_pressao[0])
            df = insere_data_frame(erro)
            print(erro)

df.to_csv('dados.csv', index = False)
fim = time.time()
print("Inicio:\t", inicio)
print("Fim:\t", fim)
print("Tempo de execução:\t"+str(fim-inicio))
em.ENcloseH()
em.ENclose()