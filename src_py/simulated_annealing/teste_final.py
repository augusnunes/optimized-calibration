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
import datetime
import os 
from multiprocessing import Process, Lock

def format_data(t):
    return datetime.timedelta(seconds=t).__str__()

def simulated_annealing(x0, f, min_score=0.1, t0=100, t_min = 0.1, alpha=0.9, iter_MAX=50):
    x = x0
    x_bsf = x0
    fxbsf = f(x_bsf)
    fx = f(x)
    t = t0 #aquece até a temperatura t0
    historico = []
    while t > t_min and f(x_bsf)>min_score: # até que atinja a temperatura mínima para parar
        if len(historico) > 10:
            if historico[-1] == historico[-9]:
                break
        for i in range(iter_MAX):# até que atinja o equilíbrio na temperatura atual
            y = x + np.random.uniform(-0.01,0.01,len(x))*np.random.randint(0,2,(len(x),)) # perturbe o x 
            delta_xy = f(y) - fx # faça a variação do custo, se negativa, então y tem um custo menor
            if (delta_xy <= 0) or np.random.uniform(0,1) < np.exp(-delta_xy/t): # a aceitação do novo ponto segue o critério de metropolis
                x = y
                fx = f(x)
                if fx < fxbsf: # caso o ponto seja aceito pelo critério de metropolis, ele é avaliado
                    x_bsf = x 
                    fxbsf = f(x_bsf)
        historico.append(fxbsf)
        t = t*alpha
    return x_bsf


def f(t, d5, seed, q_no, p, dim):
    links = ["../../networks/c-town/nodes", 
            "../../networks/c-town/links", 
            "../../networks/c-town/rede.inp", 
            f"../../networks/c-town/{dim}dim_{p}_{q_no}.csv"]
    rv = epa.RealValuesNos(links, t[:dim], nos_dim=q_no, posicao=p)
    rv.getRealValue()
    rv.close_sim()
    net = epa.Rede(links, rv.groups, t[:dim], [0.001,1])
    np.random.seed(seed)
    pontos = np.random.random((dim,100))*1+0.001
    dist = []
    f = []
    for i in range(100):
        x = simulated_annealing(pontos[:,i], net.objetivo, min_score=0.0009, t_min=0.0000001, t0=10, alpha=0.9 , iter_MAX=30)
        f.append(net.objetivo(x))
        dist.append(net.get_dist(x))
    f = np.array(f)
    dist = np.array(dist)
    arq = open(d5+'f.txt', 'a')
    np.savetxt(arq, f)
    arq.close()
    arq = open(d5+'dist.txt', 'a')
    np.savetxt(arq, dist)
    arq.close()
    arq = open(d5+'x.txt', 'a')
    np.savetxt(arq, pontos)
    arq.close()
    net.close_sim()

if __name__ == '__main__':
    t = np.array([0.075, 0.812, 0.317, 0.581, 0.752, 0.994, 0.967, 0.511, 0.851,
                0.925, 0.842, 0.295, 0.633, 0.522, 0.306])
    seeds = [308, 343, 491, 661, 769]
    posicao_nos = [0.1, 0.3, 0.5, 0.7, 0.9]
    q_nos = [10, 20, 30, 40, 50]   


    inicio = time.time()

    bot = CjsBot()
    diretorio = f'./teste_final/'
    for seed in seeds:
        d2 = diretorio+f'{seed}/'
        if not os.path.isdir(d2):
            os.mkdir(d2)
        for q_no in q_nos:
            d3 = d2+f"{q_no}/"
            if not os.path.isdir(d3):
                os.mkdir(d3)
            for p in posicao_nos:
                d4 = d3+f"{p}/"
                threads = []
                if not os.path.isdir(d4):
                    os.mkdir(d4)
                for dim in range(1,16):
                    d5 = d4+f"{dim}/"
                    if not os.path.isdir(d5):
                        os.mkdir(d5)
                    if os.path.isfile(d5+'f.txt'):
                        continue
                    threads.append(Process(target=f, args=(t, d5, seed, q_no, p, dim)))
                for thread in threads:
                    thread.start()
                for thread in threads:
                    thread.join()
                bot.send_message(f"Seed: {seed}\nQuantidade nós: {q_no}\nPos: {p}\nDim: {dim}\nTempo: {format_data(time.time()-inicio)}")
    fim = time.time()
    bot.send_message(f"Fim da simulação!!\nTempo: {format_data(fim-inicio)}")
