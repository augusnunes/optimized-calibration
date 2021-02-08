import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import epanet as epa
import epamodule as em
import seaborn as sns
from cjsbot import CjsBot
from scipy import optimize
from scipy import stats
import time
import os 


t = np.array([0.075, 0.812, 0.317, 0.581, 0.752, 0.994, 0.967, 0.511, 0.851,
              0.925, 0.842, 0.295, 0.633, 0.522, 0.306])
              
bot = CjsBot()
seeds = [661, 308, 769, 343, 491]
posicao_nos = [0.1,0.3,0.5,0.7,0.9]
q_nos = [10,20,30,40,50]
progresso = 0
comeco = time.time()
for seed in seeds:
    np.random.seed(seed)
    if not os.path.isdir(f'./teste_escolha_nos/{seed}/'):
        os.mkdir(f'./teste_escolha_nos/{seed}/')
    for posicao_no in posicao_nos:
        if not os.path.isdir(f'./teste_escolha_nos/{seed}/{posicao_no}'):
                    os.mkdir(f'./teste_escolha_nos/{seed}/{posicao_no}')
        for q_no in q_nos:
            if not os.path.isdir(f'./teste_escolha_nos/{seed}/{posicao_no}/{int(q_no*100)}'):
                    os.mkdir(f'./teste_escolha_nos/{seed}/{posicao_no}/{q_no*100}')
            for dim in range(1,16):
                bot.send_message(f"Simulação 1 está {progresso/(15*5*5*5)*100:.2f} % completa")
                links = ["../../networks/c-town/nodes", 
                    "../../networks/c-town/links", 
                    "../../networks/c-town/rede.inp", 
                    f"../../networks/c-town/{dim}dim_{posicao_no}_{q_no}.csv"]
                if not os.path.isdir(f'./teste_escolha_nos/{seed}/{posicao_no}/{q_no*100}/{dim}'):
                    os.mkdir(f'./teste_escolha_nos/{seed}/{posicao_no}/{q_no*100}/{dim}')
                
                diretorio = f'./teste_escolha_nos/{seed}/{posicao_no}/{q_no*100}/{dim}'
                tt = t[:dim]
                rv = epa.RealValuesNos(links, tt, nos_dim=q_no, posicao=posicao_no)
                rv.getRealValue()
                net = epa.Rede(links, rv.groups, tt, [0.001,1])
                rv.close_sim()
                x = []
                y = []
                dists = []
                pontos = np.random.random((500,dim))*1 +0.001
                for i in range(pontos.shape[0]):
                    try:
                        o = optimize.minimize(net.objetivo, pontos[i,:], method='Nelder-Mead')
                        x.append(pontos[i,:])
                        y.append(np.round(o.x, decimals=3))
                        print(y[-1])
                        dists.append(net.get_dist(y[-1]))
                    except:
                        continue
                dists = np.array(dists)


                arq = open(f'{diretorio}/y.txt','a')
                np.savetxt(arq, y)
                arq.close()

                arq = open(f'{diretorio}/x.txt','a')
                np.savetxt(arq, x)
                arq.close()

                arq = open(f'{diretorio}/dists.txt', 'a')
                np.savetxt(arq, dists)
                arq.close()
                net.close_sim()
                progresso += 1
    
termino = time.time()
tempo_total = termino-comeco
horas = int(tempo_total/60/60)
tempo_total -= horas*60*60
minutos = int(tempo_total/60)
tempo_total -= minutos*60
segundos = int(tempo_total)
bot.send_message(f"Simulação 1 terminou!\nTempo gasto: {horas}:{minutos}:{segundos}")