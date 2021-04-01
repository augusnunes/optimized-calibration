import pandas as pd
import epamodule as em
import numpy as np
import os 

class RealValues(object):
    def __init__(self, path_links, target_rugo, vazoes = [20,30,50,55,60,70]):
        self.dim = len(target_rugo)
        self.inp = path_links[2]
        self.links = open(path_links[1]).read().split('\n')
        self.saida = path_links[3]
        self.start_sim()
        self.nodes = self.get_nodes(path_links[0])
        self.get_groups()
        self.target_nodes = [em.ENgetlinknodes(x)[0] for x in self.get_target_links()]
        #self.target_nodes = [em.ENgetlinknodes(x)[0] for x in target_links]
        self.target_rugo = target_rugo
        self.vazoes = vazoes
    
    def start_sim(self):
        em.ENopen(self.inp)
        em.ENopenH()
    
    def close_sim(self):
        em.ENcloseH()
        em.ENclose()
    
    def restart(self):
        self.close_sim() 
        self.start_sim() 
    
    def muda_vazao(self, vazao):
        for node in self.nodes:
            em.ENsetnodevalue(node, em.EN_BASEDEMAND, em.ENgetnodevalue(node, em.EN_BASEDEMAND)*vazao)
    
    def reverte_vazao(self, vazao):
        for node in self.nodes:
            em.ENsetnodevalue(node, em.EN_BASEDEMAND, em.ENgetnodevalue(node, em.EN_BASEDEMAND)/vazao)

    def muda_rugosidade(self, no_link, rugosidade):
        for link in self.groups[no_link]:
            em.ENsetlinkvalue(link, em.EN_ROUGHNESS, rugosidade)
    
    def update_network_values(self, values):
        for i in range(len(values)):
            self.muda_rugosidade(i, values[i])
        em.ENsolveH()

    def get_nodes(self,path, test_value=1):
        arq = open(path)
        s = arq.read().split('\n')
        nodes = []
        for e in s:
            #try:
                #em.ENsetnodevalue(node, em.EN_BASEDEMAND, test_value)
            nodes.append(em.ENgetnodeindex(e))
            #except:
             #   print(f'{e} isnt a node')
        self.restart()
        return nodes 

    def get_groups(self):
        groups = []
        dim = self.dim
        if len(self.links)%dim ==0:
            count = 0
            for i in range(dim):
                groups.append(self.links[count:int(count+len(self.links)/dim)])
                count += int(len(self.links)/dim)
        else:
            count = 0
            for i in range(dim):
                if i==dim-1:
                    groups.append(self.links[count:])
                else:
                    groups.append(self.links[count:int(count+len(self.links)/dim)])
                    count += int(len(self.links)/dim)
                    
        #getid = np.vectorize(em.ENgetlinkindex) 
        #self.groups = getid(groups)
        index_groups = []
        for group in groups:
            index_groups.append([em.ENgetlinkindex(e) for e in group])
        self.groups = index_groups
        return index_groups

    def get_target_links(self):
        t_links = []
        for i in self.groups:
            t_links.append(i[0])
        return t_links


    def getRealValue(self):
        if not os.path.isfile(self.saida):
            values = []
            self.update_network_values(self.target_rugo)
            for vazao in self.vazoes:
                self.muda_vazao(vazao)
                for node in self.target_nodes:
                    em.ENsolveH()
                    pressure = em.ENgetnodevalue(node, em.EN_PRESSURE)
                    values.append([vazao, node, pressure])
                self.reverte_vazao(vazao)
            df = pd.DataFrame(np.array(values), columns = ['vazao', 'node', 'pressure'])
            df.loc[:,'node'] = df['node'].astype(int)
            df.to_csv(self.saida, index=False)



class Rede(object):
    def __init__(self, l_links, group_links, t, bound):
        self.bounds = bound
        self.limita = np.vectorize(lambda x: bound[0] if x< bound[0] else bound[1] if x>bound[1] else x)
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
        #values = self.limita(values)
        #values = np.array(values)
        #if sum(values > self.bounds[1])+sum(values < self.bounds[0]) > 0:
        #    return 1000
        #print(values)
        try:
            self.update_network_values(values)
            erro = 0
            for vazao in self.valores_reais['vazao'].unique():
                self.muda_vazao(vazao)
                em.ENsolveH()
                for v in self.valores_reais[self.valores_reais['vazao']==vazao].values:
                    erro += (v[2]-em.ENgetnodevalue(int(v[1]), em.EN_PRESSURE))**2
                self.reverte_vazao(vazao)
            self.ultimo_ponto = values
        #self.restart()
        finally:
            return erro
        return erro

    def gradient(self, x, h=0.0001): #vetor ponto
        g = np.zeros((len(x)))
        dim = len(x)
        for i in range(dim):
            #derivada_parcial = (self.objetivo(x) - self.objetivo([x[e]-h if e==i else x[e] for e in range(dim)]))/h
            #derivada_parcial += (self.objetivo([x[e]+h if e==i else x[e] for e in range(dim)]) - self.objetivo(x))/h
            derivada_parcial = (self.objetivo([x[e]+h if e==i else x[e] for e in range(dim)])-self.objetivo([x[e]-h if e==i else x[e] for e in range(dim)]))/(2*h)
            #g[i] += round(derivada_parcial,3)
            g[i] += round(derivada_parcial,3)
            
        return g

    def get_dist(self, p):
        return np.linalg.norm(self.target-p)


class RealValuesNos(object):
    def __init__(self, path_links, target_rugo, nos_dim = 30, posicao = 0, vazoes = [20,30,50,55,60,70]):
        self.nos_dim = nos_dim
        self.posicao = posicao # em %
        self.dim = len(target_rugo)
        self.inp = path_links[2]
        self.links = open(path_links[1]).read().split('\n')
        self.saida = path_links[3]
        self.start_sim()
        self.nodes = self.get_nodes(path_links[0])
        self.get_groups()
        self.target_nodes = self.get_target_nodes()
        #self.target_nodes = [em.ENgetlinknodes(x)[0] for x in target_links]
        self.target_rugo = target_rugo
        self.vazoes = vazoes
        
        
        
    
    def start_sim(self):
        em.ENopen(self.inp)
        em.ENopenH()
    
    def close_sim(self):
        em.ENcloseH()
        em.ENclose()
    
    def restart(self):
        self.close_sim() 
        self.start_sim() 
    
    def muda_vazao(self, vazao):
        for node in self.nodes:
            em.ENsetnodevalue(node, em.EN_BASEDEMAND, em.ENgetnodevalue(node, em.EN_BASEDEMAND)*vazao)
    
    def reverte_vazao(self, vazao):
        for node in self.nodes:
            em.ENsetnodevalue(node, em.EN_BASEDEMAND, em.ENgetnodevalue(node, em.EN_BASEDEMAND)/vazao)

    def muda_rugosidade(self, no_link, rugosidade):
        for link in self.groups[no_link]:
            em.ENsetlinkvalue(link, em.EN_ROUGHNESS, rugosidade)
    
    def update_network_values(self, values):
        for i in range(len(values)):
            self.muda_rugosidade(i, values[i])
        em.ENsolveH()

    def get_nodes(self,path, test_value=1): # pega todos os nós
        arq = open(path)
        s = arq.read().split('\n')
        nodes = []
        for e in s:
            #try:
                #em.ENsetnodevalue(node, em.EN_BASEDEMAND, test_value)
            nodes.append(em.ENgetnodeindex(e))
            #except:
             #   print(f'{e} isnt a node')
        self.restart()
        return nodes 

    def get_groups(self): # pega os grupos de tubulações de acordo com a dimensão
        groups = []
        dim = self.dim
        if len(self.links)%dim ==0:
            count = 0
            for i in range(dim):
                groups.append(self.links[count:int(count+len(self.links)/dim)])
                count += int(len(self.links)/dim)
        else:
            count = 0
            for i in range(dim):
                if i==dim-1:
                    groups.append(self.links[count:])
                else:
                    groups.append(self.links[count:int(count+len(self.links)/dim)])
                    count += int(len(self.links)/dim)
        #getid = np.vectorize(em.ENgetlinkindex) 
        #self.groups = getid(groups)
        index_groups = []
        for group in groups:
            index_groups.append([em.ENgetlinkindex(e) for e in group])
        self.groups = index_groups
        return index_groups

    def get_target_nodes(self): # pega 30 nós de acordo com a divisão de nos_dim grupos de  tubulações
        groups = []
        dim = self.nos_dim
        if len(self.links)%dim ==0:
            count = 0
            for i in range(dim):
                groups.append(self.links[count:int(count+len(self.links)/dim)])
                count += int(len(self.links)/dim)
        else:
            count = 0
            for i in range(dim):
                if i==dim-1:
                    groups.append(self.links[count:])
                else:
                    groups.append(self.links[count:int(count+len(self.links)/dim)])
                    count += int(len(self.links)/dim)
        index_groups = []
        for group in groups:
            index_groups.append([em.ENgetlinkindex(e) for e in group])
        return [em.ENgetlinknodes(x[int(len(x)*self.posicao)])[0] for x in index_groups]

    def get_target_links(self):
        t_links = []
        for i in self.groups:
            t_links.append(i[0])
        return t_links


    def getRealValue(self):
        if not os.path.isfile(self.saida):
            values = []
            self.update_network_values(self.target_rugo)
            for vazao in self.vazoes:
                self.muda_vazao(vazao)
                for node in self.target_nodes:
                    em.ENsolveH()
                    pressure = em.ENgetnodevalue(node, em.EN_PRESSURE)
                    values.append([vazao, node, pressure])
                self.reverte_vazao(vazao)
            df = pd.DataFrame(np.array(values), columns = ['vazao', 'node', 'pressure'])
            df.loc[:,'node'] = df['node'].astype(int)
            df.to_csv(self.saida, index=False)
