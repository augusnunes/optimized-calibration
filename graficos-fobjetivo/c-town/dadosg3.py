import os
import sys
import time

import numpy as np

import epamodule as em
from dados import Dados

from threading import Thread

def func(i):
    d.cria_arquivo('r2,r3,erro_20,erro_30,erro_50,erro_60,erro_70',(i*1000))
    d.muda_rugosidade('g1', i)
    for j in v:
        d.muda_rugosidade('g2',j)
        for k in v:
            d.muda_rugosidade('g3', k)
            dados = []
            dados.append(j)
            dados.append(k)
            for posicao_pressao in valores_pressao:
                d.muda_vazao(posicao_pressao[0])
                em.ENsolveH()
                j432 = np.abs(posicao_pressao[1]-em.ENgetnodevalue(em.ENgetnodeindex("J432"), em.EN_PRESSURE))
                j250 = np.abs(posicao_pressao[2]-em.ENgetnodevalue(em.ENgetnodeindex("J250"), em.EN_PRESSURE))
                j369 = np.abs(posicao_pressao[3]-em.ENgetnodevalue(em.ENgetnodeindex("J369"), em.EN_PRESSURE))
                dados.append(j432+j250+j369)
                d.reverte_vazao(posicao_pressao[0])
            d.insere_dados(dados, (i*1000))

def temp_exec(inicio, fim):
    print("Inicio:\t", inicio)
    print("Fim:\t", fim)
    res = fim-inicio
    h = str(int((res//60)//60))+'h '
    m = str(int((res//60)%60))+'m '
    s = str(int((res%60)))+'s '
    print("Tempo de execução:\t"+h+m+s)

inicio = time.time()
try: 
    d = Dados(v='3')
    d.start()
    v = d.cria_vetor_dominio(0.001,0.2,200,casas_dec=3)
    d.cria_grupos_links()
    d.cria_nodes()
    valores_pressao = d.pega_vazao_real([20,30,50,60,70])
    list_thr = []
    for i in v:
        if i <= 0.1:
            continue
        if i >= 0.188 and i <=0.2:
            list_thr.append(Thread(target=func(i)))
    for i in list_thr:
        i.start()
    d.stop()
    fim = time.time()
    temp_exec(inicio, fim)
except:
    fim = time.time()
    temp_exec(inicio, fim)