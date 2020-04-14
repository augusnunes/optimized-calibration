import sys 
sys.path.append('/home/augusto/Documents/epanet-python/epanet-module')
import epamodule as em

class EditModule():
    def __init__(self):
        self.g1 = ["2","3","15","14","13","12","11","10","1"]
        self.g2 = ["16","17","18","19","20"]
        self.g3 = ["5","4","6","7","8","9"]
        self.valores_pressao = [[20, 26.434926986694336, 34.299713134765625, 32.01907730102539], [30, 26.037752151489258, 34.08491516113281, 31.50044059753418], [50, 24.853008270263672, 33.45237731933594, 29.963409423828125], [55, 24.47783660888672, 33.25362014770508, 29.47846031188965], [60, 24.071619033813477, 33.03902816772461, 28.954042434692383], [70, 23.16685676574707, 32.56293487548828, 27.788007736206055]]


    def muda_vazao(self, valor):  
        nodes = ["2","3","15","14","13","12","11","10","1","16","17","18","5","4","6","7","8","9"]
        for node in nodes:
            index = em.ENgetnodeindex(node)
            em.ENsetnodevalue(index, em.EN_BASEDEMAND, em.ENgetnodevalue(index, em.EN_BASEDEMAND)*valor) 

    def reverte_vazao(self, valor):  
        nodes = ["2","3","15","14","13","12","11","10","1","16","17","18","5","4","6","7","8","9"]
        for node in nodes:
            index = em.ENgetnodeindex(node)
            em.ENsetnodevalue(index, em.EN_BASEDEMAND, em.ENgetnodevalue(index, em.EN_BASEDEMAND)/valor)

    def muda_rugosidade(grupo, rugosidade):
        for i in grupo:
            linkindex = em.ENgetlinkindex(i)
            em.ENsetlinkvalue(linkindex, em.EN_ROUGHNESS, rugosidade)

    def insere_data_frame(dic_row):
        dados = pd.DataFrame(dic_row)
        return df.append(dados, ignore_index=True)
    
    def insere_dados(lista_dados):
        dados = ','.join([str(s) for s in lista_dados ])+'\n'     
        arq = open("dados1.csv", 'a')
        arq.write(dados)
        print('\t'.join([str(e) for e in lista_dados[:3:]]))
        arq.close()