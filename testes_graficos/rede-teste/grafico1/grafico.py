import pandas as pd
import numpy as np
from formata_dados import formata 


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
matriz = formata()

import matplotlib.pyplot as plt
np.random.seed(19680801)

data = {'a': np.arange(50),
        'c': np.random.randint(0, 50, 50),
        'd': np.random.randn(50)}
data['b'] = data['a'] + 10 * np.random.randn(50)
data['d'] = np.abs(data['d']) * 100

fig, ax = plt.subplots()
ax.scatter('a', 'b', c='c', s='d', data=data)
ax.set(xlabel='entry a', ylabel='entry b')
plt.show()

"""
from matplotlib import cbook
from matplotlib import cm
from matplotlib.colors import LightSource
import matplotlib.pyplot as plt

v = []
for i in np.linspace(0.01,0.2,20):
    v.append(round(i,2))
v = np.array(v)

x,y = np.meshgrid(v,v)
z = v 
err = matriz 

fig, ax = plt.subplots(subplot_kw=dict(projection='3d'))

ls = LightSource(270,45)

rgb = ls.shade(err, cmap=cm.gist_earth, vert_exag=0.1, blend_mode='soft')
surf = ax.plot_surface(x, y, z, rstride=1, cstride=1, facecolors=rgb,linewidth=0, antialiased=False, shade=False)


plt.show()
"""