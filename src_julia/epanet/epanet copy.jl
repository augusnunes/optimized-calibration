# Module for run simulation
module epanet



# struct para controle de paths
struct Paths
    nodes::String
    links::String
    inp::String
    values::String
end # end struct Paths

# struct para controle de elementos e volores da rede
struct SimulationData
    all_nodes::Array{Int64} # todos os IDs dos nós
    group_links::Dict{Int64, Array{Int64,1}} # armazena o grupo de tubulações e seus IDs
    #valores_reais::Dict{Float64, Dict{Int64, Float64}} # Dict{vazao, Dict{id_node, pressão}} # armazena os valores reais da rede
    
    function Network(p::Paths, 
        dim::Int64, 
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

# struct para controlar os valores das rugosidades dos grupos de tubulações
mutable struct Simulation
    link_values::Dict{Int64, Float64} #In-time values of network # Dict {id do grupo, rugosidade}
end

# Função que começa simulação do epanet
function start_sim(s::Paths)
    em.ENopen(s.inp)
    em.ENopenH()
end


# Função que fecha simulação do epanet
function close_sim()
    em.ENcloseH()
    em.ENclose()
end

# Função que lê arquivo dos nós e obtém os IDs de todos eles
function get_nodes(path::String)::Array{Int64}
    arq = open(path)
    nodes = em.ENgetnodeindex.(string.(split(read(arq,String),"\n")))
    #nodes = read(arq,String) |> x -> read(x,"\n") |> split |> string. |> em.ENgetnodeindex.
end

# Função
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

function update_network_values(net::Network, values)
    for i in keys(values.link_values)
        muda_rugosidade.(net.group_link[i],values.link_values[i])
    end
    em.ENsolveH()
end

# função objetivo
function simula(net, new_rugo::Float64, numero_grupo::Int64)::Float64
    muda_rugosidade.(net.group_link[numero_grupo], new_rugo)
    dados::Float64 = 0.0
    for i in keys(net.valores_reais)
        muda_vazao.(net.all_nodes, i)
        em.ENsolveH()
        for j in keys(net.valores_reais[i])
            dados += abs(net.valores_reais[i][j]-em.ENgetnodevalue(j, em.EN_PRESSURE))
        end
        reverte_vazao.(net.all_nodes,i)
    end
    #dados |> println
    return dados/(3*6)
end

# Outro nome para a função objetivo (mais curto)
function f(net, rugosidade::Float64, numero_grupo::Int64)::Float64
    #a = simula(net, rugosidade, numero_grupo)
    #a |> println 
    return simula(net, rugosidade, numero_grupo)
end


end # end epanet module