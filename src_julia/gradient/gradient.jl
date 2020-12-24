# Including epamodule.jl
include("../epamodule/epamodule.jl")
em = Main.epamodule

# Including epanet.jl
include("../epanet/epanet.jl")
epa = Main.epanet

# Including derivative.jl
include("./derivative.jl")
d = Main.derivative

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
    values::Dict{Float64, Dict{Int64, Float64}}
)
    println("Iniciando struct paths")
    paths = epa.Paths(path_nodes, path_links, path_inp, path_saida)
    println("Iniciando simulação")
    epa.start(paths)
    println("Iniciando network")
    group_link = Dict{Int64, Array{Int64,1}}(1 => em.ENgetlinkindex.(["2","3","15","14","13","12","11","10","1"]), 2=>em.ENgetlinkindex.(["16","17","18","19","20"]), 3=> em.ENgetlinkindex.(["5","4","6","7","8","9"]))
    net = epa.Network(paths, 3, group_link, values)
    rg1 = 0.012 # 0.01
    rg2 = 0.08 # 0.079
    rg3 = 0.112 # 0.115
    intime_smvalues = epa.Simulation(Dict{Int64,Float64}(1 => rg1, 2=>rg2, 3 => rg3)) 
    epa.update_network_values(net,intime_smvalues)
    cria_saida(paths)
    interacao = 1
    ln = 0.001
    for i in 1:1:3
    #i = 3
        interacao = 0
        ∂f = d.calcula_derivada(net, intime_smvalues.link_values[i], i)
        while abs(∂f) > 0.001  
            interacao += 1
            ∂f = d.calcula_derivada(net, intime_smvalues.link_values[i], i)
            #∂f² = d.calcula_derivada_segunda(net, intime_smvalues.link_values[i],i)
            Δ = ln*∂f
            #Δ = ∂f/abs(∂f²)
            println("$(intime_smvalues.link_values[1]) \t $(intime_smvalues.link_values[2]) \t $(intime_smvalues.link_values[3]) \t $∂f")
            # limitando os valores para que não passem do intervalo desejado
            if intime_smvalues.link_values[i] - Δ < 0.001
                intime_smvalues.link_values[i] = 0.001
                break
            elseif intime_smvalues.link_values[i] - Δ > 0.2
                intime_smvalues.link_values[i] = 0.2
                break
            else
                intime_smvalues.link_values[i] -= Δ
            end
        
            printa_dados(paths, Int(ceil(interacao/3)), i, ∂f,Δ, intime_smvalues.link_values, epa.simula(net, intime_smvalues.link_values[i], i))
            
            # limitando interações para caso ele caia em um loop
            if interacao > 100
                break
            end
        end
        
    end # end loop gradient
    epa.close_sim()
end # end func gradient

values = Dict{Float64, Dict{Int64, Float64}}(20.0 => Dict(6 =>26.434926986694336,11 => 34.299713134765625,15 => 32.01907730102539), 
    30.0 => Dict(6 =>26.037752151489258,11 => 34.08491516113281, 15 => 31.50044059753418), 
    50.0 => Dict(6 =>24.853008270263672,11 => 33.45237731933594, 15 => 29.963409423828125 ), 
    55.0 => Dict(6 =>24.47783660888672, 11 => 33.25362014770508, 15 => 29.47846031188965 ),
    60.0 => Dict(6 =>24.071619033813477,11 => 33.03902816772461, 15 => 28.954042434692383),
    70.0 => Dict(6 =>23.16685676574707, 11 => 32.56293487548828, 15 => 27.788007736206055))  

gradient(
    "../../networks/b-town/nodes",
    "../../networks/b-town/links",
    "../../networks/b-town/rede.inp",
    "./tests/dados17.csv",
    values
)