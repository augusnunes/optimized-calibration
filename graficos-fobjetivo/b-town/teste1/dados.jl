include("/home/augusto/Documents/IC-2020/epanet-julia/epamodule.jl")
em = Main.epamodule
using BenchmarkTools

function mudaRugosidade(grupo, rugosidade)
    @simd for i in grupo
        em.ENsetlinkvalue(i, em.EN_ROUGHNESS, rugosidade)
    end
end

function printaResultados(R1, R2, R3, erro)
    arq = open("./dados_julia/dados.csv", "a")
    write(arq,string(R1)*","*string(R2)*","*string(R3)*","*string(erro)*"\n")
    close(arq)
end

function pega_dados()


    # lendo arquivo que contem a rede e abrindo sistema de análise hidráulica
    em.ENopen("../../../networks/b-town/teste21.inp")
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
    arq = open("./dados_julia/dados.csv", "w")
    write(arq,"Rg1,Rg2,Rg3,Erro\n")
    close(arq)

    # Criando vetor domínio da função
    println("Começando simulação")
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