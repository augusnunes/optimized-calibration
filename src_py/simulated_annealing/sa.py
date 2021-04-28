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
# On the acceleration of simulated annealing
# James D. Cohoow

def simulated_annealing(x0, f, t0=100, dt=1, iter_MAX=50):
    x = x0
    x_bsf = x0
    t = t0 #aquece até a temperatura t0
    energia = f(x)
    imagem = []
    while t > dt: # até que atinja a temperatura mínima para parar
        iter = 0
        while iter < iter_MAX: # até que atinja o equilíbrio na temperatura atual
            y = x + np.random.uniform(-0.01,0.01,len(x)) # perturbe o x 
            delta_xy = f(y) - f(x) # faça a variação do custo, se negativa, então y tem um custo menor
            if (delta_xy <= 0) or np.random.normal() < np.exp(-delta_xy/t): # a aceitação do novo ponto segue o critério de metropolis
                x = y
                if f(x) < f(x_bsf): # caso o ponto seja aceito pelo critério de metropolis, ele é avaliado
                    x_bsf = x 
            iter +=1
            imagem.append(f(x))
        print(f"t={t}\tf(x)={f(x)}")
        dt = dt+dt*t
        t -= dt
    return x_bsf, imagem

a = simulated_annealing([100,200],f, 100, 0.0000001, 50 )
# 0.000534
print(f"{a}")