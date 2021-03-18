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



if __name__ == '__main__':
    t = np.array([0.075, 0.812, 0.317, 0.581, 0.752, 0.994, 0.967, 0.511, 0.851,
                  0.925, 0.842, 0.295, 0.633, 0.522, 0.306])
    bot = CjsBot()
    seed = 661
    posicao_no = 0.1
    q_no = 10
    comeco = time.time()
    np.random.seed(seed)

    for dim in range(1,16):
        pontos = np.random.random((500,dim))*1 +0.001
        links = ["../../networks/c-town/nodes", 
            "../../networks/c-town/links", 
            "../../networks/c-town/rede.inp", 
            f"../../networks/c-town/teste/{dim}.csv"]
        diretorio = f'./teste_perform/{dim}'
        if not os.path.isdir(diretorio):
            os.mkdir(diretorio)
        tt = t[:dim]
        rv = epa.RealValuesNos(links, tt, nos_dim=q_no, posicao=posicao_no)
        rv.getRealValue()
        rv.close_sim()
        net = epa.Rede(links, rv.groups, tt, [0.001,1])
        x = []
        y = []
        dists = []
        for i in range(pontos.shape[0]):
            try:
                o = optimize.minimize(net.objetivo, pontos[i,:], method='Nelder-Mead')
                #if o.sucess:
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
    
    termino = time.time()
    print(termino -comeco)
