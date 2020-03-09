prn6 = 26.54
prn11 = 34.24
prn15 = 31.88
arq1 = open("saida_teste21.txt", 'w')

while True:
    psn6, psn11, psn15 = [float(i) for i in input("Valores:").split()]
    err = ((prn6-psn6)**2)**(1/2) + ((prn11-psn11)**2)**(1/2) + ((prn15-psn15)**2)**(1/2) 
    print("Erro: "+str(err))
    arq1.write(str(err)+'\n')