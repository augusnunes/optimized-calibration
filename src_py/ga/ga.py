def selecao(pop, f):
    # pega os primeiros len(pop)/2 melhores
    r = []
    for i in np.arange(len(pop)):
        r.append(f(pop[i]))
    indices = np.arange(len(pop))
    best_i = sorted(indices, key=lambda x: r[x])[:int(len(pop)/2)]
    pais = []
    for i in best_i:
        pais.append(pop[i])
    return pais[0], pais

def reproducao(pais, p_mut):
    aux = np.copy(pais)
    aux = [list(i) for i in list(aux)]
    filhos = []
    random.shuffle(pais) # pra ser aleatório
    n = 0
    while n <len(pais):
        # acasalamento
        a = pais[n] 
        n+=1
        b = pais[n]
        n+=1
        
        # recombinação
        comb_a = np.random.randint(0,2, size=(len(a),))
        comb_b = np.ones((len(a),)) - comb_a
        filho_a = a*comb_a + b*comb_b 
        
        comb_a = np.random.randint(0,2, size=(len(a),))
        comb_b = np.ones((len(a),)) - comb_a
        filho_b = a*comb_a + b*comb_b 
        
        # mutação
        if np.random.uniform(0,1) < p_mut:
            filho_a += np.random.normal(0,0.01, size=(len(filho_a),))
        if np.random.uniform(0,1) < p_mut:
            filho_b += np.random.normal(0,0.01, size=(len(filho_a),))

        filhos.append(filho_a)
        filhos.append(filho_b)
    return aux+filhos
        

def ga(objetivo, population, gens, p_mut = 0.15, best_score=1e-10):
    population = list(population)
    for i in range(gens):
        x_bsf, pais = selecao(population, objetivo)
        population = reproducao(pais, p_mut)
        score = objetivo(x_bsf)
        print(i, score)
        if score < best_score:
            break
    return x_bsf