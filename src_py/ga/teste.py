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

def selecao(pop, f): 
    random.shuffle(pop)
    pais = []
    i = 0
    while i < len(pop):
        if f(pop[i]) < f(pop[i+1]):
            pais.append(pop[i])
        else:
            pais.append(pop[i+1])
        i += 2
    aux = sorted(pais, key=lambda x: f(x))
    return aux[0], pais

def reproducao(pais, p_mut, p_comb):
    aux = np.copy(pais)
    aux = [list(i) for i in list(aux)]
    filhos = []
    random.shuffle(pais)
    n = 0
    while n <len(pais):
        # acasalamento
        a = pais[n] 
        n+=1
        b = pais[n]
        n+=1
        
        # recombinação
        filho_a = None
        filho_b = None
        # mudar operações 0.8 ~ 1.2
        if np.random.uniform(0,1)<p_comb:
            comb_a = np.random.uniform(0,1, size=(len(a),))
            comb_b = np.random.uniform(0.8, 1.2, size=(len(a),)) - comb_a
            filho_a = a*comb_a + b*comb_b 
            
            comb_a = np.random.uniform(0,1, size=(len(a),))
            comb_b = np.random.uniform(0.8, 1.2, size=(len(a),)) - comb_a
            filho_b = a*comb_a + b*comb_b 
        else:
            filho_a = np.copy(a)
            filho_b = np.copy(b)
            
        # mutação
        if np.random.uniform(0,1) < p_mut:
            filho_a += np.random.normal(0,0.01, size=(len(filho_a),))
        if np.random.uniform(0,1) < p_mut:
            filho_b += np.random.normal(0,0.01, size=(len(filho_a),))
        
        filhos.append(filho_a)
        filhos.append(filho_b)
    return aux+filhos
        

def ga(objetivo, population, gens, p_mut = 0.05, p_comb=0.8, best_score=1e-10):
    population = list(population)
    for i in range(gens):
        x_bsf, pais = selecao(population, objetivo)
        population = reproducao(pais, p_mut, p_comb)
        score = objetivo(x_bsf)
        print(i, score)
        if score < best_score:
            break
    return x_bsf

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



dist = []
f = []
np.random.seed(seed)
pontos = np.random.random((dim,100))
pop = [list(i) for i in list(pontos)]
for i in range(100):
    pontos = np.random.random((dim,40)).T
    pop = [list(i) for i in list(pontos)]
    x = ga(net.objetivo, pop)
    dist.append(net.get_dist(x))
    f.append(net.objetivo(x))

a = np.array(dist)
f = np.array(f)

arq = open('teste/dist.txt', 'a')
np.savetxt(arq, a)
arq.close()

arq = open('teste/f.txt','a')
np.savetxt(arq, f)
arq.close()
