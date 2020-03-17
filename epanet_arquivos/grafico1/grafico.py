import pandas as pd
import numpy as np
# Lendo e separando dados
dados = pd.read_csv("dados.csv")
dados1 = dados[dados["Erro"]<=0.07410]

x =  np.array(dados1["Rg3"])[0:450]
y =  np.array(dados1["Rg1"])[0:450]
z =  np.array(dados1["Rg2"])[0:450]
err = np.array(dados1["Erro"])[0:450]

"""
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter

fig = plt.figure()
ax = fig.gca(projection='3d')

x,y = np.meshgrid(x,y)
err,z = np.meshgrid(err,z)
surf = ax.plot_surface(x,y,z,cmap=cm.coolwarm, linewidth=0,antialiased=False)

fig.colorbar(surf, shrink=0.5, aspect=5)
"""

from matplotlib import cbook
from matplotlib import cm
from matplotlib.colors import LightSource
import matplotlib.pyplot as plt

x,y = np.meshgrid(x,y)
z,w = np.meshgrid(z,z)
err, llalalalal = np.meshgrid(err,err)
fig, ax = plt.subplots(subplot_kw=dict(projection='3d'))
print(fig, ax)

ls = LightSource(270,45)

rgb = ls.shade(err, cmap=cm.gist_earth, vert_exag=0.1, blend_mode='soft')
surf = ax.plot_surface(x, y, z, rstride=1, cstride=1, facecolors=rgb,linewidth=0, antialiased=False, shade=False)


plt.show()