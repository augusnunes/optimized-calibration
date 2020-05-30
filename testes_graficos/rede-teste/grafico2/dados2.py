import pandas as pd
import numpy as np 

dados = pd.read_csv('/home/augusto/Documents/IC-2020/epanet_arquivos/grafico2/dados.csv')

for i in range(200):
    dados[dados["Rg1"]==(i+1)/1000].drop("Rg1",axis=1).to_csv("./dados/"+str(i)+".csv", index = False)
    