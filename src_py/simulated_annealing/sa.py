import numpy as np 

# On the acceleration of simulated annealing
# James D. Cohoow

def f(x):
    return x[0]**2 + x[1]**2 


def simulated_annealing(x0, f, t0, h, iter_MAX):
    x = x0
    x_bsf = x0
    t = t0 #aquece até a temperatura t0
    energia = f(x)
    while t > h: # até que atinja a temperatura mínima para parar
        iter = 0
        while iter < iter_MAX: # até que atinja o equilíbrio na temperatura atual
            y = x + np.random.uniform(-1,1,len(x)) # perturbe o x 
            delta_xy = f(y) - f(x) # faça a variação do custo, se negativa, então y tem um custo menor
            if (delta_xy <= 0) or np.random.normal() < np.exp(-delta_xy/t): # a aceitação do novo ponto segue o critério de metropolis
                x = y
                if f(x) < f(x_bsf): # caso o ponto seja aceito pelo critério de metropolis, ele é avaliado
                    x_bsf = x 
            iter +=1
            print(f"t={t}   iter={iter}   x={x}")
        t -= 0.1*t
    return x_bsf

a = simulated_annealing([100,200],f, 100, 0.0000001, 50 )
# 0.000534
print(f"{a}")