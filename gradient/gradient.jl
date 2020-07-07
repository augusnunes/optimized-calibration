# Including epamodule.jl
include("/home/augusto/Documents/IC-2020/epanet-julia/epamodule.jl")
em = Main.epamodule

#Including epanet.jl
include("/home/augusto/Documents/IC-2020/optimized-calibration/algorithms/epanet/epanet.jl")
sm = Main.simulation

function printa_dados(paths, i, numero_grupo, derivada, delta, r, erro)
    s = string(i, ",", numero_grupo, ",", derivada, ",", delta, ",")
    for i in keys(r)
        s *= string(r[i],",")
    end
    s *= string(erro,"\n")
    arq = open(paths.saida,"a")
    write(arq,s)
    close(arq)
end

function cria_saida(s)
    println("Criando arquivo de saída")
    arq = open(s.saida,"w")
    write(arq, "i,rn,derivada,delta,r2,r3,r1,erro\n")
    close(arq)
    println("Criado arquivo de saída")
end

function gradient(
    path_nodes::String,
    path_links::String,
    path_inp::String,
    path_saida::String,
    #lista_vazao::Array{Float64},
    #lista_rugosidade_real::Array{Float64},
    values::Dict{Float64, Dict{Int64, Float64}}
)
    println("Iniciando struct paths")
    paths = sm.Paths(path_nodes, path_links, path_inp, path_saida)
    println("Iniciando simulação")
    sm.start(paths)
    println("Iniciando network")
    group_link = Dict{Int64, Array{Int64,1}}(1 => em.ENgetlinkindex.(["2","3","15","14","13","12","11","10","1"]), 2=>em.ENgetlinkindex.(["16","17","18","19","20"]), 3=> em.ENgetlinkindex.(["5","4","6","7","8","9"]))
    net = sm.Network(paths, 3, group_link, values)
    a = 0.2
    b = 0.001
    c = 0.115
    intime_smvalues = sm.Simulation(Dict{Int64,Float64}(1 => a, 2=>b, 3 => c)) 
    sm.update_network_values(net,intime_smvalues)
    cria_saida(paths)
    interacao = 1
    
    #for i in 1:1:3
    i = 1
        ∂f = sm.calcula_derivada(net, intime_smvalues.link_values[i], i)
        while abs(∂f) > 0.0001
            ∂f = sm.calcula_derivada(net, intime_smvalues.link_values[i], i)
            ∂f² = sm.calcula_derivada_segunda(net, intime_smvalues.link_values[i],i)
            Δ = ∂f/abs(∂f²)
            println("$(intime_smvalues.link_values[i]) \t $(∂f) \t $(∂f²) \t $Δ \t $(sm.simula(net, intime_smvalues.link_values[i], i))")
            intime_smvalues.link_values[i] -= Δ
            printa_dados(paths, Int(ceil(interacao/3)), i, ∂f,Δ, intime_smvalues.link_values, sm.simula(net, intime_smvalues.link_values[i], i))
            # interacao += 1
        end
        
    #end # end loop gradient
    sm.close_sim()
end # end func gradient

values = Dict{Float64, Dict{Int64, Float64}}(20.0 => Dict(6 =>26.434926986694336,11 => 34.299713134765625,15 => 32.01907730102539), 
    30.0 => Dict(6 =>26.037752151489258,11 => 34.08491516113281, 15 => 31.50044059753418), 
    50.0 => Dict(6 =>24.853008270263672,11 => 33.45237731933594, 15 => 29.963409423828125 ), 
    55.0 => Dict(6 =>24.47783660888672, 11 => 33.25362014770508, 15 => 29.47846031188965 ),
    60.0 => Dict(6 =>24.071619033813477,11 => 33.03902816772461, 15 => 28.954042434692383),
    70.0 => Dict(6 =>23.16685676574707, 11 => 32.56293487548828, 15 => 27.788007736206055))  

gradient(
    "/home/augusto/Documents/IC-2020/optimized-calibration/networks/b-town/nodes",
    "/home/augusto/Documents/IC-2020/optimized-calibration/networks/b-town/links",
    "/home/augusto/Documents/IC-2020/optimized-calibration/networks/b-town/rede.inp",
    "/home/augusto/Documents/IC-2020/optimized-calibration/algorithms/gradient/testes/1/dados7.csv",
    values
)