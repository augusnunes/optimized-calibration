include("/home/augusto/Documents/IC-2020/epanet-julia/epamodule.jl")
em = Main.epamodule
using BenchmarkTools

function mudaRugosidade(grupo, rugosidade)
    for i in grupo
        em.ENsetlinkvalue(i, em.EN_ROUGHNESS, rugosidade)
    end
end

function printaResultados(R1, R2, R3, erro)
    arq = open(string("./dados/",Int(round(R1*100000)),".csv"), "a")
    write(arq,string(R2)*","*string(R3)*","*string(erro)*"\n")
    println(string(R1)*","*string(R2)*","*string(R3)*","*string(erro)*"\n")
    close(arq)
end

function pega_dados()


    # lendo arquivo que contem a rede e abrindo sistema de análise hidráulica
    em.ENopen("/home/augusto/Documents/IC-2020/optimized-calibration/networks/b-town/teste21.inp")
    em.ENopenH()

    # definindo a lista de trechos a qual será variada a rugosidade
    println("Pegando index do grupo")
    g1 = em.ENgetlinkindex.(["2","3","15","14","13","12","11","10","1"])
    g2 = em.ENgetlinkindex.(["16","17","18","19","20"])
    g3 = em.ENgetlinkindex.(["5","4","6","7","8","9"])
    n6 = 26.54
    n11 = 34.24
    n15 = 31.88

    # Criando arquivo 
    arq = open("./dados.csv", "w")
    write(arq,"Rg1,Rg2,Rg3,Erro\n")
    close(arq)

    # Criando vetor domínio da função
    println("Começando simulação")
    v = 0.001:0.00001:0.002
    for i in v
        arq = open(string("./dados/",Int(round(i*100000)),".csv"), "w")
        write(arq,"Rg2,Rg3,Erro\n")
        close(arq)
        mudaRugosidade(g1, i)
        for j in v
            mudaRugosidade(g2,j)
            for k in v
                mudaRugosidade(g3, k)
                em.ENsolveH()
                erro = 1/3*(abs(n6-em.ENgetnodevalue(6, em.EN_PRESSURE)) + abs(n11-em.ENgetnodevalue(11, em.EN_PRESSURE)) + abs(n15 - em.ENgetnodevalue(15, em.EN_PRESSURE)))
                printaResultados(i, j, k, erro)
            end
        end
    end
    em.ENcloseH()
    em.ENclose()
end

pega_dados()