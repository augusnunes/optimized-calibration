import sys 
sys.path.append('/home/augusto/Documents/epanet-python/epanet-module')

import epamodule as em
import numpy as np 

def mudaRugosidade(grupo, rugosidade):
    for i in grupo:
        linkindex = em.ENgetlinkindex(i)
        em.ENsetlinkvalue(linkindex, em.EN_ROUGHNESS, rugosidade)

def printaResultados(R1, R2, R3, erro):
    arq = open("dados_menor.csv", 'a')
    arq.write(str(R1)+","+str(R2)+","+str(R3)+","+str(erro)+"\n")
    arq.close()

# definindo a lista de trechos a qual será variada a rugosidade
g1 = ["2","3","15","14","13","12","11","10","1"]
g2 = ["16","17","18","19","20"]
g3 = ["5","4","6","7","8","9"]
n6 = 26.54
n11 = 34.24
n15 = 31.88

# lendo arquivo que contem a rede e abrindo sistema de análise hidráulica
em.ENopen("/home/augusto/Documents/IC-2020/epanet_arquivos/rede/teste21.inp")
em.ENopenH()

# Criando arquivo 
arq = open("dados_menor.csv", 'w')
arq.write("Rg1,Rg2,Rg3,Erro\n")
arq.close()

# Criando vetor domínio da função
v = []
for i in np.linspace(0.01,0.2,20):
    v.append(round(i,2))

for i in v:
    mudaRugosidade(g1, i)
    for j in v:
        mudaRugosidade(g2,j)
        for k in v:
            mudaRugosidade(g3, k)
            em.ENsolveH()
            erro = 1/3*(np.abs(n6-em.ENgetnodevalue(em.ENgetnodeindex("6"), em.EN_PRESSURE)) + np.abs(n11-em.ENgetnodevalue(em.ENgetnodeindex("11"), em.EN_PRESSURE)) + np.abs(n15 - em.ENgetnodevalue(em.ENgetnodeindex("15"), em.EN_PRESSURE)))
            printaResultados(i, j, k, erro)



em.ENcloseH()
em.ENclose()