import pandas as pd
import numpy as np 

def formata():
    m3 = []
    dados = pd.read_csv('dados.csv')
    for i in range(20):
        m2 = []
        for j in range(20):
            m1 = []
            for k in range(20):
                m1.append(0)
            m2.append(m1)
        m3.append(m2)

    indexE = 0
    for i in range(20):
        for j in range(20):
            for k in range(20):
                valor = dados['Erro'][indexE]
                print(valor)
                m3[i][j][k] += valor            
                indexE -=-1
    return m3
    #arq = open('matriz.txt','w')
    #arq.write(str(m3))
    #arq.close()