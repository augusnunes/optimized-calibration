import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd 

dados = pd.read_csv("dados1.csv")
x = np.array(dados['Rg1'])
y = np.array(dados['Erro'])

# Data for plotting
#t = np.arange(0.0, 2.0, 0.01)
#s = 1 + np.sin(2 * np.pi * t)

fig, ax = plt.subplots()
ax.plot(x, y)

ax.set(xlabel='Rugosidade', ylabel='Erro entre pressão real e simulada',
       title='Gráfico do erro entre pressão real e simulada em função da rugosidade das tubulações')
ax.grid()

fig.savefig("test.png")
plt.show()