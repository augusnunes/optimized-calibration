import pandas as pd
import numpy as np 

dados = pd.read_csv("dados1.csv")

dados.r1 = round(dados.r1,3)
dados.r2 = round(dados.r2,3)
dados.r3 = round(dados.r3,3)

for i in dados.r1.value_counts().index:
    dados[dados.r1 == i].drop('r1',axis=1).to_csv("./dados1/"+str(int(i*1000))+".csv",index=False)
