# Including epamodule.jl
include("/home/augusto/Documents/IC-2020/epanet-julia/epamodule.jl")
em = Main.epamodule

#Including epanet.jl
include("/home/augusto/Documents/IC-2020/optimized-calibration/epanet/epanet.jl")
sm = Main.simulation

path_nodes = "/home/augusto/Documents/IC-2020/optimized-calibration/networks/b-town/nodes"
path_links = "/home/augusto/Documents/IC-2020/optimized-calibration/networks/b-town/links"
path_inp = "/home/augusto/Documents/IC-2020/optimized-calibration/networks/b-town/rede.inp"
path_saida = "/home/augusto/Documents/IC-2020/optimized-calibration/gradient/f_b/other2/socorro.csv"

paths = sm.Paths(path_nodes, path_links, path_inp, path_saida)
sm.start(paths)
group_link = Dict{Int64, Array{Int64,1}}(1 => em.ENgetlinkindex.(["2","3","15","14","13","12","11","10","1"]), 2=>em.ENgetlinkindex.(["16","17","18","19","20"]), 3=> em.ENgetlinkindex.(["5","4","6","7","8","9"]))

v = Dict{Float64, Dict{Int64, Float64}}(
    20.0 => Dict(6 =>26.434926986694336,11 => 34.299713134765625,15 => 32.01907730102539), 
    30.0 => Dict(6 =>26.037752151489258,11 => 34.08491516113281, 15 => 31.50044059753418), 
    50.0 => Dict(6 =>24.853008270263672,11 => 33.45237731933594, 15 => 29.963409423828125 ), 
    55.0 => Dict(6 =>24.47783660888672, 11 => 33.25362014770508, 15 => 29.47846031188965 ),
    60.0 => Dict(6 =>24.071619033813477,11 => 33.03902816772461, 15 => 28.954042434692383),
    70.0 => Dict(6 =>23.16685676574707, 11 => 32.56293487548828, 15 => 27.788007736206055))
net = sm.Network(paths, 3, group_link, v)

a = 0.01 # 0.01
b = 0.079 # 0.079
c = 0.115 # 0.115

intime_smvalues = sm.Simulation(Dict{Int64,Float64}(1 => a, 2=>b, 3 => c)) 

sm.update_network_values(net,intime_smvalues)

using Makie

function get_data(rugo_g2, rugo_g3, v)
    # Atualizando valores das rugo das tubulações
    v.link_values[2] = rugo_g2
    v.link_values[3] = rugo_g3
    sm.update_network_values(net,intime_smvalues)
    
    # Puxando valores para Rugo g1
    erro = Array{Float64,1}([])
    for i in 1e-3:1e-3:0.2
        sm.f(net, i, 1) |> valor -> append!(erro, valor)
    end
    return erro
end

g2_i = 0.079 #0.079
g3_i = 0.115 #0.115
xr = 0.001:0.001:0.2
## setup sliders 
sg2, g2 = textslider(xr, "Rugo g2", start = g2_i)
sg3, g3 = textslider(xr, "Rugo g3", start = g3_i)

## setup lifts
erro = lift((g2, g3) -> get_data(g2,g3, intime_smvalues), g2, g3)

## setup plot
scene = lines(               # plot x=y, the bisector line
    xr,                   # xs
    erro,                 # ys
    #linestyle = :dash,    # style of line
    linewidth = 2,        # width of line
    color = :green         # colour of line
)
scene[Axis][:names][:axisnames] = ("Rugosidade g1", "Erro") # set axis names

final = hbox(scene, vbox(sg2, sg3))

display(final)

