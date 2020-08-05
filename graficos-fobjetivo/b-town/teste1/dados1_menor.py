import epamodule as em
import numpy as np 

def mudaRugosidade(grupo, rugosidade):
    for i in grupo:
        linkindex = em.ENgetlinkindex(i)
        em.ENsetlinkvalue(linkindex, em.EN_ROUGHNESS, rugosidade)

def printaResultados(R1, R2, erro, nome):
    arq = open(nome, 'a')
    arq.write(str(R1)+","+str(R2)+","+str(erro)+"\n")
    arq.close()

# definindo a lista de trechos a qual será variada a rugosidade
g1 = ["2","3","15","14","13","12","11","10","1"]
g2 = ["16","17","18","19","20"]
g3 = ["5","4","6","7","8","9"]
n6 = 26.54
n11 = 34.24
n15 = 31.88

# lendo arquivo que contem a rede e abrindo sistema de análise hidráulica
em.ENopen("../../../networks/b-town/teste21.inp")
em.ENopenH()



# Criando vetor domínio da função
v = []
for i in np.linspace(0.01,0.2,20):
    v.append(round(i,2))

for i in v:
    mudaRugosidade(g1, i)
    # Criando arquivo 
    nome = "./dados_menor/"+str(int(i*100))+".csv"
    arq = open(nome, 'w')
    arq.write("R1,R2,erro\n")
    arq.close()
    for j in v:
        mudaRugosidade(g2,j)
        for k in v:
            mudaRugosidade(g3, k)
            em.ENsolveH()
            erro = 1/3*(np.abs(n6-em.ENgetnodevalue(em.ENgetnodeindex("6"), em.EN_PRESSURE)) + np.abs(n11-em.ENgetnodevalue(em.ENgetnodeindex("11"), em.EN_PRESSURE)) + np.abs(n15 - em.ENgetnodevalue(em.ENgetnodeindex("15"), em.EN_PRESSURE)))
            printaResultados(j, k, erro, nome)



em.ENcloseH()
em.ENclose()