import sys 
sys.path.append('/home/augusto/Documents/epanet-python/epanet-module')
import epamodule as em
import numpy as np 
import time

def mudaVazao(valor):  
    nodes = ["2","3","15","14","13","12","11","10","1","16","17","18","5","4","6","7","8","9"]
    for node in nodes:
        index = em.ENgetnodeindex(node)
        em.ENsetnodevalue(index, em.EN_BASEDEMAND, em.ENgetnodevalue(index, em.EN_BASEDEMAND)*valor) 

def reverteVazao(valor):  
    nodes = ["2","3","15","14","13","12","11","10","1","16","17","18","5","4","6","7","8","9"]
    for node in nodes:
        index = em.ENgetnodeindex(node)
        em.ENsetnodevalue(index, em.EN_BASEDEMAND, em.ENgetnodevalue(index, em.EN_BASEDEMAND)/valor)

def mudaRugosidade(grupo, rugosidade):
    for i in grupo:
        linkindex = em.ENgetlinkindex(i)
        em.ENsetlinkvalue(linkindex, em.EN_ROUGHNESS, rugosidade)

def printaResultados(nome, R2, R3, erro):
    arq = open(nome, 'a')
    s = str(R2)+","+str(R3)+","+str(erro)+"\n"
    arq.write(s)
    print(nome+'\t'+s)
    arq.close()

# definindo a lista de trechos a qual será variada a rugosidade
g1 = ["2","3","15","14","13","12","11","10","1"]
g2 = ["16","17","18","19","20"]
g3 = ["5","4","6","7","8","9"]
valores = [[50,24.85,33.45,29.96],[55,24.48,33.25,29.47],[60,24.07,33.04,28.95]]

# lendo arquivo que contem a rede e abrindo sistema de análise hidráulica
em.ENopen("/home/augusto/Documents/IC-2020/epanet_arquivos/grafico1/rede.inp")
em.ENopenH()

# Criando vetor domínio da função
v = []
for i in np.linspace(0.001,0.2,200):
    v.append(round(i,3))

inicio = time.time()
for i in v:
    nome = "./dados/"+str(int(i*1000))+".csv"
    arq = open(nome, 'w')
    arq.write("Rg2,Rg3,Erro\n")
    arq.close()
    mudaRugosidade(g1, i)
    for j in v:
        mudaRugosidade(g2,j)
        for k in v:
            mudaRugosidade(g3, k)
            erro = 0
            for valor in range(3):
                vetor = valores[valor]
                mudaVazao(vetor[0])
                em.ENsolveH()
                n6 = np.abs(vetor[1]-em.ENgetnodevalue(em.ENgetnodeindex("6"), em.EN_PRESSURE))
                n11 = np.abs(vetor[2]-em.ENgetnodevalue(em.ENgetnodeindex("11"), em.EN_PRESSURE))
                n15 = np.abs(vetor[3] - em.ENgetnodevalue(em.ENgetnodeindex("15"), em.EN_PRESSURE))
                erro = n6 + n11 + n15
                reverteVazao(vetor[0])
            printaResultados(nome, j, k, erro)

fim = time.time()
print("Tempo de execução: "+str(fim-inicio))
em.ENcloseH()
em.ENclose()