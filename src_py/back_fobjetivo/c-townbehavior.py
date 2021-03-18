import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import epanet as epa
import epamodule as em
import seaborn as sns
from cjsbot import CjsBot
import time
import os 

dims = [1,2,3]
q_nos = [1,2,3,10,20,30]

t = np.array([0.075, 0.012, 0.017])

for q_no in q_nos:
    for dim in dims:
        links = ["../../networks/c-town/nodes", 
            "../../networks/c-town/links", 
            "../../networks/c-town/rede.inp", 
            f"../../networks/c-town/behavior/{q_no}-{dim}.csv"]
        tt = t[:dim]
        rv = epa.RealValuesNos(links, tt, nos_dim=q_no, posicao=0)
        rv.getRealValue()
        rv.close_sim()
        net = epa.Rede(links, rv.groups, tt, [0.001,0.2])
        arq = open(f"testes/{q_no}-{dim}.csv", 'a')
        bounds = np.linspace(0.001,0.2,200)
        if dim == 1:
            v = np.array(np.meshgrid(bounds)).T.reshape(-1,dim)
        elif dim == 2:
            v = np.array(np.meshgrid(bounds, bounds)).T.reshape(-1,dim)
        elif dim == 3: 
            for i in bounds:
                for j in bounds:
                    for k in bounds:
                        r = net.objetivo([i,j,k])
                        arq.write(f"{i},{j},{k},{r}\n")
        if dim != 3:
            for i in range(v.shape[0]):
                r = net.objetivo(v[i,:])
                arq.write(f"{','.join([str(e) for e in v[i,:]])},{r}\n")
        arq.close()

