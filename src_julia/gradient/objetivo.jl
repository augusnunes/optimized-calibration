module objetivo

# Incluindo módulo epanet
include("../epanet/epanet.jl")
epa = Main.epanet

# Including epamodule
include("../epamodule/epamodule.jl")
em = Main.epamodule

function simula(net, new_rugo::Float64, numero_grupo::Int64)::Float64
    epa.muda_rugosidade.(net.group_link[numero_grupo], new_rugo)
    dados::Float64 = 0.0
    for i in keys(net.valores_reais)
        epa.muda_vazao.(net.all_nodes, i)
        em.ENsolveH()
        for j in keys(net.valores_reais[i])
            dados += abs(net.valores_reais[i][j]-em.ENgetnodevalue(j, em.EN_PRESSURE))
        end
        epa.reverte_vazao.(net.all_nodes,i)
    end
    #dados |> println
    return dados/(3*6)
end

function f(net, rugosidade::Float64, numero_grupo::Int64)::Float64
    #a = simula(net, rugosidade, numero_grupo)
    #a |> println 
    return simula(net, rugosidade, numero_grupo)
end


end # end module objetivo