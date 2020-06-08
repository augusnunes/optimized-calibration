##
#   Classe de funções para modificar rede e fazer simulações
##

import epamodule as em
import numpy as np 
import time
import os

class Simulation ():
    # Tarefas da classe
    # Iniciar uma simulação
    # Pegar valores dos nós
    # Pegar valores das tubulações
    # 


    # Inicializa variáveis
    def __init__(self, rede_path, node_path, link_path, v = '1'):
        self.rede_path = rede_path
        self.v = v
        self.nodes = getNodes()
        self.grupos = {}


    # Inicia módulo de simulação
    def start(self):
        em.ENopen(self.rede_path)
        em.ENopenH()
    
    # Termina módulo de simulações
    def stop(self):
        em.ENcloseH()
        em.ENclose()
    
    # Muda valores da vazao dos nós
    def muda_vazao(self, valor):  
        for node in self.nodes:
            index = em.ENgetnodeindex(node)
            em.ENsetnodevalue(index, em.EN_BASEDEMAND, em.ENgetnodevalue(index, em.EN_BASEDEMAND)*valor) 

    # Reverte os valores da vazao dos nós
    def reverte_vazao(self, valor):  
        for node in self.nodes:
            index = em.ENgetnodeindex(node)
            em.ENsetnodevalue(index, em.EN_BASEDEMAND, em.ENgetnodevalue(index, em.EN_BASEDEMAND)/valor)

    # Muda rugosidade de um grupo de tubulações
    def muda_rugosidade(self, grupo:str, rugosidade):
        try:
            for i in self.grupos[grupo]:
                linkindex = em.ENgetlinkindex(i)
                em.ENsetlinkvalue(linkindex, em.EN_ROUGHNESS, rugosidade)
        except Exception:
            print('erro em muda_rugosidade ',grupo, rugosidade )
    
    # Armazena dados de simulação em arquivo
    def insere_dados(self, lista_dados, n_r1:float):
        dados = ','.join([str(s) for s in lista_dados ])+'\n'     
        arq = open('./grafico'+self.v+"/dados/"+str(int(n_r1))+".csv", 'a')
        arq.write(dados)
        print("./dados/"+str(int(n_r1))+".csv"+'\t'+'\t'.join([str(e) for e in lista_dados[:3:]]))
        arq.close()

    # Cria arquivo que armazena dados
    def cria_arquivo(self, colunas:str, n_r1:float):
        try:
            os.mkdir('./grafico'+self.v+'/dados')
        except:
            print('Já existe esse diretório')
        print(n_r1)
        caminho = './grafico'+self.v+"/dados/"+str(int(n_r1))+".csv"
        arq = open(caminho, 'w')
        print(caminho)
        arq.write(colunas+"\n")
        arq.close()
    
    # Criando vetor domínio da função
    def cria_vetor_dominio(self, inicio, fim, quantidade, casas_dec:int = 3):
        vetor_dominio = []
        for i in np.linspace(inicio,fim,quantidade):
            vetor_dominio.append(round(i,casas_dec))
        return vetor_dominio
           
    def pega_vazao_real(self, lista_vazoes):
        self.muda_rugosidade('g1', 0.01)
        self.muda_rugosidade('g2', 0.079)
        self.muda_rugosidade('g3', 0.115)
        valores = []
        for i in lista_vazoes:
            l = [i]
            self.muda_vazao(i)
            em.ENsolveH()
            l.append(em.ENgetnodevalue(em.ENgetnodeindex("J432"), em.EN_PRESSURE))
            l.append(em.ENgetnodevalue(em.ENgetnodeindex("J250"), em.EN_PRESSURE))
            l.append(em.ENgetnodevalue(em.ENgetnodeindex("J369"), em.EN_PRESSURE))
            self.reverte_vazao(i)
            valores.append(l)
        return valores



    """
    def cria_links(self):
        arq = open('./links')
        s = arq.read()
        links = []
        for link in s.split('\n'):
            if not link == '':
                links.append(link)
        print(links)
        return links
    """

    def cria_nodes(self):
        arq = open('./nodes')
        s = arq.read()
        nodes = []
        for node in s.split('\n'):
            if not node == '':
                nodes.append(node)
        self.nodes = nodes