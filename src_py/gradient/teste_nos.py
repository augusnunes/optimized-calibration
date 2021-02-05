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
np.random.seed(45)
pontos = np.random.random((500,i))*1 +0.001

for seed in seeds:
    np.random.seed(seed)
    bot.send_message(f"Estou na {seeds.index(seed)+1}a de 5 ~~~ Simulação 2")
    pontos = np.random.random((500,dim))*1 +0.001
    if not os.path.isdir(f'./teste_nos/{seed}/'):
        os.mkdir(f'./teste_nos/{seed}/')
    for dim in range(1,16):
        links = ["../../networks/c-town/nodes", 
            "../../networks/c-town/links", 
            "../../networks/c-town/rede.inp", 
            f"../../networks/c-town/30nodes/{dim}dim.csv"]
        if not os.path.isdir(f'./teste_nos/{seed}/{dim}'):
            os.mkdir(f'./teste_nos/{seed}/{dim}')
        tt = t[:dim]
        rv = epa.RealValuesNos(links, tt)
        rv.getRealValue()
        net = epa.Rede(links, rv.groups, tt, [0.001,1])
        #arq = open(f'./teste_nn/{i}/x.txt')
        x = []
        y = []
        dists = []
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
        sts = f'mode:{stats.mode(dists)}\nsd:{np.array(dists).std()}'
        open(f'./teste_nos/{dim}/stats.txt', 'a').write(sts).close()
    
        arq = open(f'./teste_nos/{seed}/{dim}/y.txt','a')
        np.savetxt(arq, y)
        arq.close()
    
        arq = open(f'./teste_nos/{seed}/{dim}/x.txt','a')
        np.savetxt(arq, x)
        arq.close()

        arq = open(f'./teste_nos/{seed}/{dim}/dists.txt', 'a')
        np.savetxt(arq, dists)
        arq.close()
    
bot.send_message("Acabou simulação 2")