# Módulo para rodar simulação
module epanet

include("../epamodule/epamodule.jl")
em = Main.epamodule

using DataFrames
using CSV

# exporting structs
export SimulationValues, Paths

# exporting functions



# struct para controle de paths
struct Paths
    nodes::String
    links::String
    inp::String
    values::String
end # end struct Paths


struct SimulationValues
    real_values::DataFrame
    target::Array{Float64, 1}
    all_nodes::Array{Int64,1}
    g_links::Array{Array{Int64,1},1}
    dim::Int64
    paths::Paths
    function SimulationValues(paths::Paths,
        target::Array{Float64, 1}, 
        nos_dim::Int64, 
        posicao::Float64 = 0.1, 
        vazoes::Array{Int64, 1} = [20,30,50,55,60,70] )
        # Puxando valores
        dim = length(target)
        tubulacoes = split.(read(paths.links, String), "\n")
        start_sim(paths)
        all_nodes = get_allnodes(paths)        
        t_nodes = get_target_nodes(nos_dim, tubulacoes, posicao)
        g_links = get_groups(dim, tubulacoes)
        get_real_values(paths, vazoes, target, t_nodes,g_links, all_nodes)
        real_values = CSV.File(paths.values) |> DataFrame
        close_sim()
        new(real_values, target, all_nodes, g_links, dim, paths)
    end 
end


function release_net(n)::Nothing
    global net = n
end

# Função que começa simulação do epanet
function start_sim(paths::Paths)::Nothing
    em.ENopen(paths.inp)
    em.ENopenH()
end

# Função que fecha simulação do epanet
function close_sim()::Nothing
    em.ENcloseH()
    em.ENclose()
end

function restart_sim(paths::Paths)::Nothing
    close_sim()
    start_sim(paths)
end


# Função que lê arquivo dos nós e obtém os IDs de todos eles
function get_allnodes(paths::Paths)::Array{Int64}
    arq = open(paths.nodes)
    nodes = em.ENgetnodeindex.(string.(split(read(arq,String),"\n")))
    return nodes
end


function update_network_values(values, net)::Nothing
    for i in 1:length(values)
        muda_rugosidade.(net.g_links[i],values[i])
    end
    em.ENsolveH()
end

function update_network_values(values::Array{Float64,1}, l_groups::Array{Array{Int64,1},1})::Nothing
    for i in 1:length(values)
        muda_rugosidade.(l_groups[i],values[i])
    end
    em.ENsolveH()
end


# function muda_vazao(valor, net::SimulationValues)::Nothing
#     em.ENsetnodevalue(net.all_nodes, em.EN_BASEDEMAND, em.ENgetnodevalue(node, em.EN_BASEDEMAND)*valor)
# end

function muda_vazao(valor, node)::Nothing
    em.ENsetnodevalue(node, em.EN_BASEDEMAND, em.ENgetnodevalue(node, em.EN_BASEDEMAND)*valor |> Float64)
end

# function reverte_vazao(valor, net::SimulationValues)::Nothing
#     em.ENsetnodevalue(net.all_nodes, em.EN_BASEDEMAND, em.ENgetnodevalue(node, em.EN_BASEDEMAND)/valor)
# end

function reverte_vazao(valor, nodes)::Nothing
    em.ENsetnodevalue(nodes, em.EN_BASEDEMAND, em.ENgetnodevalue(nodes, em.EN_BASEDEMAND)/valor |> Float64)
end

function muda_rugosidade(link::Int64, r::Float64)::Nothing
    em.ENsetlinkvalue(link, em.EN_ROUGHNESS, r)
end

# função objetivo
function objetivo(values::Array{Float64,1}, net)::Float64
    try
        erro::Float64 = 0.0
        update_network_values(values, net)
        for df in groupby(net.real_values, :vazao)
            muda_vazao.(df[1, :vazao], net.all_nodes)
            em.ENsolveH()
            for i in 1:size(df)[1]
                erro += (df[i,:pressure] - em.ENgetnodevalue(df[i,:node], em.EN_PRESSURE))^2
            end
            reverte_vazao.( df[1,:vazao], net.all_nodes)
        end
        return erro
    catch
        return Inf
    end
end


function get_dist(x, net)::Float64
    return sum((net.target-x).^2)^0.5
end

function get_groups(dim::Int64, tubulacoes)::Array{Array{Int64,1},1}
    groups = Array{Array{String,1},1}()
    if length(tubulacoes)%dim == 0
        count = 0
        for i in 1:dim
            append!(groups, [tubulacoes[count+1:Int(count+length(tubulacoes)/dim |> round)]])
            count += Int(length(tubulacoes)/dim |> round)
        end
    else
        count = 0
        for i in 1:dim
            if i==dim
                append!(groups, [tubulacoes[count+1:end]])
            else
                append!(groups, [tubulacoes[count+1:Int(count+length(tubulacoes)/dim |> round)]])
                count += Int(length(tubulacoes)/dim  |> round)
            end  
        end  
    end
    index_groups = Array{Array{Int64,1},1}()
    for group in groups
        append!(index_groups, [em.ENgetlinkindex.(group)])
    end
    return index_groups
end

function get_target_nodes(dim::Int64, tubulacoes, posicao::Float64)::Array{Int64,1}
    groups = Array{Array{String,1},1}()
    if length(tubulacoes)%dim == 0
        count = 0
        for i in 1:dim
            append!(groups, [tubulacoes[count+1:Int(count+length(tubulacoes)/dim |> round)]])
            count += Int(length(tubulacoes)/dim |> round)
        end
    else
        count = 0
        for i in 1:dim
            if i==dim
                append!(groups, [tubulacoes[count+1:end]])
            else
                append!(groups, [tubulacoes[count+1:Int(count+length(tubulacoes)/dim |> round)]])
                count += Int(length(tubulacoes)/dim |> round)
            end    
        end
    end
    index_groups = Array{Array{Int64,1},1}()
    for group in groups
        append!(index_groups, [em.ENgetlinkindex.(group)])
    end
    return [em.ENgetlinknodes(x[Int(length(x)*posicao |> round)])[1] for x in index_groups]
end

function get_real_values(paths, vazoes, target_rugo, 
    target_nodes, g_links, all_nodes)::Nothing
    if !isfile(paths.values)
        v = []
        n = []
        pressure = []
        update_network_values(target_rugo, g_links)
        for vazao in vazoes
            muda_vazao.(vazao, all_nodes)
            em.ENsolveH()
            for node in target_nodes
                append!(v, vazao)
                append!(n, node)
                append!(pressure, em.ENgetnodevalue(node, em.EN_PRESSURE))
            end
            reverte_vazao.(vazao, all_nodes)
        end
        df = DataFrame(node=n, vazao=v, pressure=pressure)
        CSV.write(paths.values, df)
    end
end


end # end epanet module