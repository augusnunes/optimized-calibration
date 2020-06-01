import sys 
sys.path.append('/home/augusto/Documents/epanet-python/epanet-module')

import epamodule as em
import numpy as np 

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

# definindo a lista de trechos a qual será variada a rugosidade
g1 = ["2","3","15","14","13","12","11","10","1"]
g2 = ["16","17","18","19","20"]
g3 = ["5","4","6","7","8","9"]


# lendo arquivo que contem a rede e abrindo sistema de análise hidráulica
em.ENopen("/home/augusto/Documents/IC-2020/epanet_arquivos/grafico1/rede.inp")
em.ENopenH()

muda_rugosidade(g1, 0.010)
muda_rugosidade(g2, 0.079)
muda_rugosidade(g3, 0.115)
v = [20,30,50,55,60,70]
valores = []
for i in v:
    l = [i]
    muda_vazao(i)
    em.ENsolveH()
    print("Para vazao = ",i)
    l.append(em.ENgetnodevalue(em.ENgetnodeindex("6"), em.EN_PRESSURE))
    l.append(em.ENgetnodevalue(em.ENgetnodeindex("11"), em.EN_PRESSURE))
    l.append(em.ENgetnodevalue(em.ENgetnodeindex("15"), em.EN_PRESSURE))
    print("n6: ", em.ENgetnodevalue(em.ENgetnodeindex("6"), em.EN_PRESSURE))
    print("n11: ", em.ENgetnodevalue(em.ENgetnodeindex("11"), em.EN_PRESSURE))
    print("n15: ", em.ENgetnodevalue(em.ENgetnodeindex("15"), em.EN_PRESSURE))
    reverte_vazao(i)
    valores.append(l)

print(valores)
em.ENcloseH()
em.ENclose()