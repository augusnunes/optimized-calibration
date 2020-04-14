import sys 
sys.path.append('/home/augusto/Documents/epanet-python/epanet-module')

import epamodule as em
import numpy as np 

def mudaRugosidade(grupo, rugosidade):
    for i in grupo:
        linkindex = em.ENgetlinkindex(i)
        em.ENsetlinkvalue(linkindex, em.EN_ROUGHNESS, rugosidade)

def printaResultados(R1, R2, R3, erro):
    arq = open("dados.csv", 'a')
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
em.ENopen("/home/augusto/Documents/IC-2020/GA/rede.inp")
em.ENopenH()
