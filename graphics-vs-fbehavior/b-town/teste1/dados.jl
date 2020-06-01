using PyCall
em = pyimport("epamodule")


function mudaRugosidade(grupo, rugosidade)
    for i in grupo
        linkindex = em.ENgetlinkindex(i)
        em.ENsetlinkvalue(linkindex, em.EN_ROUGHNESS, rugosidade)
    end
end

function printaResultados(R1, R2, R3, erro)
    arq = open("./dados_julia/dados.csv", "a")
    write(arq,string(R1)*","*string(R2)*","*string(R3)*","*string(erro)*"\n")
    close(arq)
end

function pega_dados()

    # definindo a lista de trechos a qual será variada a rugosidade
    g1 = ["2","3","15","14","13","12","11","10","1"]
    g2 = ["16","17","18","19","20"]
    g3 = ["5","4","6","7","8","9"]
    n6 = 26.54
    n11 = 34.24
    n15 = 31.88


    # lendo arquivo que contem a rede e abrindo sistema de análise hidráulica
    em.ENopen("../../../networks/b-town/teste21.inp")
    em.ENopenH()

    # Criando arquivo 
    arq = open("./dados_julia/dados.csv", "w")
    write(arq,"Rg1,Rg2,Rg3,Erro\n")
    close(arq)

    # Criando vetor domínio da função
    v = 0.001:0.001:0.2
    for i in v
        mudaRugosidade(g1, i)
        for j in v
            mudaRugosidade(g2,j)
            for k in v
                mudaRugosidade(g3, k)
                em.ENsolveH()
                erro = 1/3*(abs(n6-em.ENgetnodevalue(em.ENgetnodeindex("6"), em.EN_PRESSURE)) + abs(n11-em.ENgetnodevalue(em.ENgetnodeindex("11"), em.EN_PRESSURE)) + abs(n15 - em.ENgetnodevalue(em.ENgetnodeindex("15"), em.EN_PRESSURE)))
                printaResultados(i, j, k, round(erro,digits=5))
            end
        end
    end
    em.ENcloseH()
    em.ENclose()
end

@time pega_dados()