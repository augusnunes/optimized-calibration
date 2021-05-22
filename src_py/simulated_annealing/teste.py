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
from multiprocessing import Process, Lock


def simulated_annealing(x0, f, min_score=0.1, t0=100, t_min = 0.1, alpha=0.9, iter_MAX=50):
    x = x0
    x_bsf = x0
    t = t0 #aquece até a temperatura t0
    imagem = []
    caminho = []
    caminho2 = []
    caminho.append(x0)
    caminho2.append(x0)
    metropolis = []
    validation = []
    while t > t_min and f(x_bsf)>min_score: # até que atinja a temperatura mínima para parar
        #if len(validation) > 10:
        #    if validation[-1] == validation[-10]:
        #        return x_bsf, imagem, caminho, caminho2, metropolis
                #return simulated_annealing(x_bsf, f, min_score=min_score, t0=t0, dt=dt, iter_MAX=iter_MAX)
        for i in range(iter_MAX):# até que atinja o equilíbrio na temperatura atual
            y = x + np.random.uniform(-0.01,0.01,len(x))*np.random.randint(0,2,(len(x),)) # perturbe o x 
            delta_xy = f(y) - f(x) # faça a variação do custo, se negativa, então y tem um custo menor
            metropolis.append(np.exp(-delta_xy/t))
            if (delta_xy <= 0) or np.random.uniform(0,1) < np.exp(-delta_xy/t): # a aceitação do novo ponto segue o critério de metropolis
                x = y
                caminho2.append(x)
                if f(x) < f(x_bsf): # caso o ponto seja aceito pelo critério de metropolis, ele é avaliado
                    x_bsf = x 
                    caminho.append(x_bsf)
            imagem.append(f(x_bsf))
        validation.append(f(x_bsf))
        print(f"t={t}\tf(x)={f(x_bsf)}")
        t = t*alpha
    return x_bsf, imagem, caminho, caminho2, metropolis



t = np.array([0.075, 0.812, 0.317, 0.581, 0.752, 0.994, 0.967, 0.511, 0.851,
              0.925, 0.842, 0.295, 0.633, 0.522, 0.306])
seeds = [661, 308, 769, 343, 491]
posicao_nos = [0.1, 0.3, 0.5, 0.7, 0.9]
q_nos = [10, 20, 30, 40, 50]   
dim=14
seed = seeds[0]
posicao_no = posicao_nos[2]
q_no = q_nos[3]
links = ["../../networks/c-town/nodes", 
        "../../networks/c-town/links", 
        "../../networks/c-town/rede.inp", 
        f"../../networks/c-town/{dim}dim_{posicao_no}_{q_no}.csv"]

diretorio = f'./teste/'
if not os.path.isdir(diretorio):
    os.mkdir(diretorio)
rv = epa.RealValuesNos(links, t[:dim], nos_dim=q_no, posicao=posicao_no)
rv.getRealValue()
rv.close_sim()
net = epa.Rede(links, rv.groups, t[:dim], [0.001,1])



annealing = []
f = []
np.random.seed(seed)
pontos = np.random.random((dim,100))*1+0.001
for i in range(100):
    x0 = pontos[:,i]
    x, imagem, caminho, caminho2, metropolis = simulated_annealing(x0, net.objetivo, min_score=0.0009, t_min=0.00000001, t0=10, alpha=0.9 , iter_MAX=30)
    annealing.append(net.get_dist(x))
    f.append(net.objetivo(x))

a = np.array(annealing)
f = np.array(f)

arq = open('teste/dist.txt', 'a')
np.savetxt(arq, a)
arq.close()

arq = open('teste/f.txt','a')
np.savetxt(arq, f)
arq.close()
