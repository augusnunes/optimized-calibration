# importing 
using PyCall
em = pyimport("epamodule")

# Declaring variables
global v = 1
global rede = "../../redes/c-town/C-Town.inp"
global path_nodes = "../../redes/c-town/nodes"
global path_links = "../../redes/c-town/links"
global nodes = []
global links = Dict()
global valores_reais = Array{Float64,2}(undef,6,11)
global lista_nodes = ["J175" "J188" "J6" "J242" "J280" "J323" "J17" "J239" "J77" "J38"]
global rugosidades = [0.073  0.023  0.082  0.065  0.008  0.046  0.098  0.004  0.053  0.094]

function cria_arquivo()
    saida = "./teste"*string(v)*"/dados.csv"
    arq = open(saida,"w")
    write(arq, "i,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,erro\n")
    close(arq)
end

function muda_vazao(node::String, valor::Float64)
    index = em.ENgetnodeindex(node)
    em.ENsetnodevalue(index, em.EN_BASEDEMAND, em.ENgetnodevalue(index, em.EN_BASEDEMAND)*valor)
end

function reverte_vazao(node::String, valor::Float64)
    index = em.ENgetnodeindex(node)
    em.ENsetnodevalue(index, em.EN_BASEDEMAND, em.ENgetnodevalue(index, em.EN_BASEDEMAND)/valor)
end

function muda_rugosidade(link, r)
    linkindex = em.ENgetlinkindex(link)
    em.ENsetlinkvalue(linkindex, em.EN_ROUGHNESS, r)
end

function get_nodes(path::String)
    arq = open(path)
    nodes = string.(split(read(arq,String),"\n"))
end

function get_links(n_grupos::Int64)
    s_links = string.(vec(split(read(open(path_links),String),"\n")))
    tamanho = Int(round(length(s_links)/n_grupos))
    l_start = 1
    l_end = tamanho
    count = 1
    while length(s_links) >= l_end
        if (length(s_links)-l_end) < tamanho
            links["g"*string(count)] = s_links[l_start:l_end] 
            links["g"*string(count+1)] = s_links[l_start+tamanho:length(s_links)] 
            println(string(count+1))
            break;
        end
        links["g"*string(count)] = s_links[l_start:l_end] 
        l_start += tamanho
        l_end += tamanho
        count += 1 
        
    end
end

function get_node_pressure(node)
    return em.ENgetnodevalue(em.ENgetnodeindex(node), em.EN_PRESSURE)
end

function pega_dados_reais()
    lista_vazao = [20.0 30.0 40.0 50.0 60.0 70.0]
    lista_rugosidade = [0.04 0.094 0.07 0.079 0.048 0.039 0.027 0.042 0.047 0.004]
    for i in 1:10
        muda_rugosidade.(links["g"*string(i)], lista_rugosidade[i])
    end
    for i in 1:length(lista_vazao)
        valores_reais[i,1] = lista_vazao[i]
        muda_vazao.(nodes, lista_vazao[i])
        em.ENsolveH()
        for j in 1:10
            valores_reais[i,j+1] = get_node_pressure(lista_nodes[j])
        end
        reverte_vazao.(nodes, lista_vazao[i])

    end
    arq = open("./teste1/dados_reais.csv","w")
    write(arq, string(valores_reais))
    println(valores_reais)
    close(arq)
end

function inicia_simulacao()
    em.ENopen(rede)
    em.ENopenH()
end

function para_simulacao()
    em.ENcloseH()
    em.ENclose()
end

#= Links úteis para bibliotecas de gradient descent
- https://github.com/lindahua/SGDOptim.jl
- 

=#
## Funções referentes ao método

function simula()
    dados::Float64 = 0.0
    for i in 1:6
        muda_vazao.(nodes, valores_reais[i,1])
        em.ENsolveH()
        for j in 1:10
            dados += abs(valores_reais[i,j+1]-get_node_pressure(lista_nodes[j]))
        end
        reverte_vazao.(nodes,valores_reais[i,1])
    end

    return dados/60
end

function muda_rugosidade_grupos(r)
    for i in 1:10
        muda_rugosidade.(links["g"*string(i)], r[i])
    end
end

function f(rugosidade, numero_grupo)
    r = rugosidades
    r[numero_grupo] = rugosidade
    muda_rugosidade_grupos(r)
    return simula()
end

function calcula_derivada(rugosidade, numero_grupo)
    # f(x)-f(x+h)
    #      h
    h = 0.001
    return (f(rugosidade,numero_grupo)-f(rugosidade - h, numero_grupo))/h
    
end


function calcula_derivada_segunda(rugosidade,numero_grupo)
    # f(x+h)+f(x)+f(x-h)
    #        h^2
    h = 0.001
    return (f(rugosidade+h,numero_grupo)+f(rugosidade,numero_grupo)+f(rugosidade-h,numero_grupo))/h^2
end



function gradient()
    #for i in 1:6
    #    println("Teste número: "*string(i))
    Δ = 1
    interacao = 1
    while abs(Δ) > 1e-11
        println("Interação: "*string(interacao))
        for i in 1:10
            ∂f = calcula_derivada(rugosidades[i], i)
            Δ = ∂f/calcula_derivada_segunda(rugosidades[i],i)
            
            if abs(Δ) > 1e-6
                if ∂f > 0
                    rugosidades[i]+=abs(Δ)*0.0001
                elseif ∂f < 0
                    rugosidades[i]-=abs(Δ)*0.0001
                end
            end
            muda_rugosidade_grupos(rugosidades)
            printa_dados(interacao, i, ∂f,Δ, rugosidades, simula())
        end
        interacao += 1
    end
    #end
end

function printa_dados(i, numero_grupo, derivada1,delta, r, erro)
    s = string(i)*","*string(numero_grupo)*","*string(derivada1)*","*string(delta)*","
    for i in r
        s *= string(i)*","
    end
    s *= string(erro)*"\n"
    arq = open("./teste1/dados/dados.csv","a")
    write(arq,s)
    close(arq)
end



println("Iniciando Simulação")
inicia_simulacao()
println("Pegando valores da rede")
get_nodes(path_nodes)
get_links(10) # 10 grupos de rugosidade
println("Criando Arquivo")
cria_arquivo()
println("Pegando dados de pressão nos nós")
pega_dados_reais()
println("Iniciando método gradiente")
gradient()
println("Encerrando Simulação")
para_simulacao()
