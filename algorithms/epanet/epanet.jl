# Module for run simulation
module simulation
# Including epamodule.jl
include("/home/augusto/Documents/IC-2020/epanet-julia/epamodule.jl")
em = Main.epamodule
export Network

struct Paths
    nodes::String
    links::String
    inp::String
    saida::String
end # end struct Paths


struct Network
    all_nodes::Array{Int64}
    group_link::Dict{Int64, Array{Int64,1}}
    valores_reais::Dict{Float64, Dict{Int64, Float64}} # Dict{vazao, Dict{id_node, vazao}}
    function Network(p::Paths, numero_grupos::Int64, 
        #target_nodes::Dict{Int64, Float64}, 
        #lista_vazao::Array{Float64},
        group_link::Dict{Int64, Array{Int64,1}},
        valores_reais::Dict{Float64, Dict{Int64, Float64}})
        all_nodes = get_nodes(p.nodes)
        #group_link = get_links(p.links, numero_grupos)
        #valores_reais= get_real_values(lista_vazao, target_nodes, all_nodes, group_link )
        new(all_nodes, group_link, valores_reais)
    end
    
end


mutable struct Simulation
    link_values::Dict{Int64, Float64} #In-time values of network # Dict {id do grupo, rugosidade}

end
#=
function cria_saida(s::Paths)
    println("Criando arquivo de saída")
    arq = open(s.saida,"w")
    write(arq, "i,rn,derivada,delta,r2,r3,r1,erro\n")
    close(arq)
    println("Criado arquivo de saída")
end
=#

function cria_saida(s::Paths)
    println("Criando arquivo de saída")
    arq = open(s.saida,"w")
    write(arq, "rugosidade,erro\n")
    close(arq)
    println("Criado arquivo de saída")
end


function start(s::Paths)
    em.ENopen(s.inp)
    em.ENopenH()
end

function close_sim()
    em.ENcloseH()
    em.ENclose()
end

function get_nodes(path::String)::Array{Int64}
    arq = open(path)
    nodes = em.ENgetnodeindex.(string.(split(read(arq,String),"\n")))
    #nodes = read(arq,String) |> x -> read(x,"\n") |> split |> string. |> em.ENgetnodeindex.
end

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


function muda_vazao(node::Int64, valor::Float64)
    em.ENsetnodevalue(node, em.EN_BASEDEMAND, em.ENgetnodevalue(node, em.EN_BASEDEMAND)*valor)
end

function reverte_vazao(node::Int64, valor::Float64)
    em.ENsetnodevalue(node, em.EN_BASEDEMAND, em.ENgetnodevalue(node, em.EN_BASEDEMAND)/valor)
end

function muda_rugosidade(link::Int64, r::Float64)
    em.ENsetlinkvalue(link, em.EN_ROUGHNESS, r)
end

function update_network_values(net::Network, values::Simulation)
    for i in keys(values.link_values)
        muda_rugosidade.(net.group_link[i],values.link_values[i])

    end
    em.ENsolveH()
end

#=
function get_real_values(
    lista_vazao::Array{Float64}, 
    target::Dict{Int64, Float64}, 
    nodes::Array{Int64}, 
    links::Dict{Int64, Array{Int64,1}})

    valores_reais = Dict
    for i in 1:10
        muda_rugosidade.(links["g"*string(i)], lista_rugosidade_real[i])
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
=#

#=
#################################
----------------Rever sintaxe--------------
#################################
=#

function get_node_pressure(node::Int64)::Float64
    return em.ENgetnodevalue(node, em.EN_PRESSURE)
end

function simula(net::Network, new_rugo::Float64, numero_grupo::Int64)::Float64
    muda_rugosidade.(net.group_link[numero_grupo], new_rugo)
    dados::Float64 = 0.0
    for i in keys(net.valores_reais)
        muda_vazao.(net.all_nodes, i)
        em.ENsolveH()
        for j in keys(net.valores_reais[i])
            dados += abs(net.valores_reais[i][j]-get_node_pressure(j))
        end
        reverte_vazao.(net.all_nodes,i)
    end
    #dados |> println
    return dados/(3*6)
end


function f(net::Network, rugosidade::Float64, numero_grupo::Int64)::Float64
    a = simula(net, rugosidade, numero_grupo)
    #a |> println 
    return a
end


function calcula_derivada(net::Network, rugosidade::Float64, numero_grupo::Int64)
    # f(x)-f(x+h)
    #      h
    #"calculando derivada" |> println
    h = 0.001
    return (f(net, rugosidade,numero_grupo)-f(net, rugosidade + h, numero_grupo))/h
    
end


function calcula_derivada_segunda(net::Network, rugosidade::Float64, numero_grupo::Int64)
    # f(x+h)+f(x)+f(x-h)
    #        h^2
    h = 0.001
    #"calculando segunda derivada" |> println
    #return (f(net,rugosidade+2*h,numero_grupo)-2*f(net, rugosidade+h,numero_grupo)+f(net, rugosidade,numero_grupo))/h^2
    return (calcula_derivada(net, rugosidade,numero_grupo)-calcula_derivada(net,rugosidade+h,numero_grupo))/h
end



end # end simulation module