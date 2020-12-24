import pandas as pd
import epamodule as em
import numpy as np

class Rede(object):
    def __init__(self, l_links, group_links, t):
        self.nodes = l_links[0]
        self.links = l_links[1]
        self.inp = l_links[2]
        print("Começando simulação")
        self.start_sim()
        self.target = t
        self.valores_reais = pd.read_csv(l_links[3]) # dicionario(vazao -> [valores de pressão pra cada grupo])
        self.nodes = self.get_nodes()
        self.g_links = group_links # vetor[nº grupo] = [link1, link2, .....] começando do 0
    
    def start_sim(self):
        em.ENopen(self.inp)
        em.ENopenH()
    
    def close_sim(self):
        em.ENcloseH()
        em.ENclose()
    
    def restart(self):
        self.close_sim() 
        self.start_sim()   


    def get_nodes(self):
        arq = open(self.nodes)
        s = arq.read().split('\n')
        nodes = [em.ENgetnodeindex(e) for e in s]
        return nodes 
    """
    function get_links(path_links::String, n_grupos::Int64)::Dict{Int64, Array{Int64}}
    println("Pegando links")
    s_links = string.(vec(split(read(open(path_links),String),"\n")))
    tamanho = Int(round(length(s_links)/n_grupos))
    l_start = 1
    l_end = tamanho
    count = 1
    links = Dict{Int64, Array{Int64}}()
    while length(s_links) >= l_end
        if (length(s_links)-l_end) < tamanho
            links[count] = em.ENgetlinkindex.(s_links[l_start:l_end]) 
            links[count+1] = em.ENgetlinkindex.(s_links[l_start+tamanho:length(s_links)]) 
            break;
        end
        links[count] = em.ENgetlinkindex.(s_links[l_start:l_end]) 
        l_start += tamanho
        l_end += tamanho
        count += 1 
    end
    println(links)
    return links
    end
    """

    def muda_vazao(self, vazao):
        for node in self.nodes:
            em.ENsetnodevalue(node, em.EN_BASEDEMAND, em.ENgetnodevalue(node, em.EN_BASEDEMAND)*vazao)
    
    def reverte_vazao(self, vazao):
        for node in self.nodes:
            em.ENsetnodevalue(node, em.EN_BASEDEMAND, em.ENgetnodevalue(node, em.EN_BASEDEMAND)/vazao)

    def muda_rugosidade(self, no_link, rugosidade):
        for link in self.g_links[no_link]:
            em.ENsetlinkvalue(link, em.EN_ROUGHNESS, rugosidade)
    
    def update_network_values(self, values):
        for i in range(len(values)):
            self.muda_rugosidade(i, values[i])
        em.ENsolveH()
    
    def objetivo(self, values):
        self.update_network_values(values)
        erro = 0
        for vazao in self.valores_reais['vazao'].unique():
            self.muda_vazao(vazao)
            em.ENsolveH()
            for v in self.valores_reais[self.valores_reais['vazao']==vazao].values:
                erro += abs(v[2]-em.ENgetnodevalue(int(v[1]), em.EN_PRESSURE))
            self.reverte_vazao(vazao)
        return erro/(3*6)

    def gradient(self, x, h=0.001): #vetor ponto
        g = np.zeros((len(x)))
        dim = len(x)
        for i in range(dim):
            derivada_parcial = (self.objetivo(x) - self.objetivo([x[e]-h if e==i else x[e] for e in range(dim)]))/h
            derivada_parcial += (self.objetivo([x[e]+h if e==i else x[e] for e in range(dim)]) - self.objetivo(x))/h
            derivada_parcial += (self.objetivo([x[e]+h if e==i else x[e] for e in range(dim)])-self.objetivo([x[e]-h if e==i else x[e] for e in range(dim)]))/(2*h)
            g[i] += round(derivada_parcial/3,3)
        return g

    def get_dist(self, p):
        return np.linalg.norm(self.target-p)