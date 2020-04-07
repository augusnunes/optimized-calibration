import sys 
sys.path.append('/home/augusto/Documents/epanet-python/epanet-module')

import epamodule as em
import numpy as np 
g = ["2","3","15","14","13","12","11","10","1","16","17","18","5","4","6","7","8","9"]
gerr = ["19","20"]
em.ENopen("/home/augusto/Documents/IC-2020/epanet_arquivos/rede/teste21.inp")
em.ENopenH()

for i in g:
    index = em.ENgetnodeindex(i)
    valor = em.ENgetnodevalue(index,em.EN_BASEDEMAND)/21
    print(str(em.ENgetnodevalue(index,em.EN_BASEDEMAND))+"/21 = "+str(valor))
    em.ENsetnodevalue(index, em.EN_BASEDEMAND, valor)


em.ENsaveinpfile('rede.inp')
em.ENcloseH()
em.ENclose()