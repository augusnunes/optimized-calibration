import pandas as pd

m3 = []
dados = pd.read_csv('dados.csv')
for i in range(10):
    m2 = []
    for j in range(10):
        m1 = []
        for k in range(10):
            m1.append(0)
        m2.append(m1)
    m3.append(m2)

for i in range(10):
    for j in range(10):
        for k in range(10):
            valor = dados[dados['Rg1'] == (i+1)/1000][dados['Rg2'] == (j+1)/1000][dados['Rg3']==(k+1)/1000]['Erro']
            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
            print(m3)
            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
            m3[i][j][k] += float(pd.to_numeric(dados[dados['Rg1'] == (i+1)/1000][dados['Rg2'] == (j+1)/1000][dados['Rg3']==(k+1)/1000]['Erro']))           

print(m3)