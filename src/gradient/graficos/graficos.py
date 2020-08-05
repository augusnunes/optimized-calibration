import pandas as pd
import matplotlib.pyplot as plt

def plota(nome_arq, nome_saida):
    dados = pd.read_csv(nome_arq)
    fig, ax = plt.subplots()
    ax.plot(dados.i, dados.derivada, '-')
    ax.plot(0.01, dados.derivada[dados.i ==0.01], 'o')
    fig.savefig(nome_saida)
    plt.show()


dados = pd.read_csv(nome_arq)
fig, ax = plt.subplots()
ax.plot(dados.i, dados.derivada, '-')
ax.plot(0.01, dados.derivada[dados.i ==0.079], 'o')
fig.savefig(nome_saida)
plt.show()