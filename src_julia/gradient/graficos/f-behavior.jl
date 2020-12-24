# Including epamodule.jl
include("/home/augusto/Documents/IC-2020/epanet-julia/epamodule.jl")
em = Main.epamodule

#Including epanet.jl
include("/home/augusto/Documents/IC-2020/optimized-calibration/epanet/epanet.jl")
sm = Main.simulation

function printa_dados(path, i, j, k, erro)
    s = string(i, ",", j, ",", k, ",", erro, "\n")
    arq = open(path.saida,"a")
    println(s)
    write(arq,s)
    close(arq)
end

function cria_saida(s)
    println("Criando arquivo de saída")
    arq = open(s.saida,"w")
    write(arq, "r1,r2,r3,erro\n")
    close(arq)
    println("Criado arquivo de saída")
end


function behavior(
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
    a = 0.001 # 0.01
    b = 0.040 # 0.079
    c = 0.001 # 0.115
    intime_smvalues = sm.Simulation(Dict{Int64,Float64}(1 => a, 2=>b, 3 => c)) 
    sm.update_network_values(net,intime_smvalues)
    cria_saida(paths)
    intervalo = 0.001:0.001:0.2
    for i in intervalo, j in intervalo, k in intervalo
        intime_smvalues.link_values[1] = i
        intime_smvalues.link_values[2] = j
        sm.update_network_values(net,intime_smvalues)
        #derivada = sm.calcula_derivada(net, i, 1)
        derivada = sm.f(net, k, 3)
        printa_dados(paths, i, j, k, derivada)
    end
    sm.close_sim()
end # end func gradient

values = Dict{Float64, Dict{Int64, Float64}}(
    20.0 => Dict(6 =>26.434926986694336,11 => 34.299713134765625,15 => 32.01907730102539), 
    30.0 => Dict(6 =>26.037752151489258,11 => 34.08491516113281, 15 => 31.50044059753418), 
    50.0 => Dict(6 =>24.853008270263672,11 => 33.45237731933594, 15 => 29.963409423828125 ), 
    55.0 => Dict(6 =>24.47783660888672, 11 => 33.25362014770508, 15 => 29.47846031188965 ),
    60.0 => Dict(6 =>24.071619033813477,11 => 33.03902816772461, 15 => 28.954042434692383),
    70.0 => Dict(6 =>23.16685676574707, 11 => 32.56293487548828, 15 => 27.788007736206055))
    

behavior(
    "/home/augusto/Documents/IC-2020/optimized-calibration/networks/b-town/nodes",
    "/home/augusto/Documents/IC-2020/optimized-calibration/networks/b-town/links",
    "/home/augusto/Documents/IC-2020/optimized-calibration/networks/b-town/rede.inp",
    "/home/augusto/Documents/IC-2020/optimized-calibration/gradient/f_b/geral/f.csv",
    values
)