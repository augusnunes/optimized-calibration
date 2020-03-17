import sys 
sys.path.append('/home/augusto/Documents/epanet-python/epanet-module')

import epamodule as em
import numpy as np 

def mudaRugosidade(grupo, rugosidade):
    for i in grupo:
        linkindex = em.ENgetlinkindex(i)
        em.ENsetlinkvalue(linkindex, em.EN_ROUGHNESS, rugosidade)

def printaResultados(R1, erro):
    arq = open("dados1.csv", 'a')
    arq.write(str(R1)+","+str(erro)+"\n")
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
arq = open("dados1.csv", 'w')
arq.write("Rg1,Erro\n")
arq.close()


mudaRugosidade(g2,0.002)
mudaRugosidade(g3,0.002)

# Criando vetor domínio da função
v = []
for i in np.linspace(0.001,0.2,200):
    v.append(round(i,3))

for i in v:
    mudaRugosidade(g1, i)
    em.ENsolveH()
    erro = np.abs(n6-em.ENgetnodevalue(em.ENgetnodeindex("6"), em.EN_PRESSURE)) 
    printaResultados(i,erro)



em.ENcloseH()
em.ENclose()