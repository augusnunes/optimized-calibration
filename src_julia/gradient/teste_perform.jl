include("../epamodule/epamodule.jl")
include("../epanet/epanet.jl")
em = Main.epamodule
epa = Main.epanet


using Main.epanet
using PyCall
using DelimitedFiles
numpy = pyimport("numpy")
opt = pyimport("scipy.optimize")


t = [0.075, 0.812, 0.317, 0.581, 0.752, 0.994, 0.967, 0.511, 0.851,0.925, 0.842, 0.295, 0.633, 0.522, 0.306]
seed = 661
numpy.random.seed(seed)
posicao_nos = 0.1
q_nos = 10
comeco = time()

for dim in 1:15
    paths = Paths("/home/augusto/Documents/IC-2020/optimized-calibration/networks/c-town/nodes",
        "/home/augusto/Documents/IC-2020/optimized-calibration/networks/c-town/links",
        "/home/augusto/Documents/IC-2020/optimized-calibration/networks/c-town/rede.inp",
        "/home/augusto/Documents/IC-2020/optimized-calibration/networks/c-town/testejl/$dim.csv")
    tt = t[1:(dim)]
    diretorio = "./teste_perform/$dim"
    if !isdir(diretorio)
        mkdir(diretorio)
    end
    net = SimulationValues(paths, tt, q_nos, posicao_nos)
    pontos = numpy.random.random((500,dim)).*1 .+ 0.001
    epa.start_sim(paths)
    x = []
    y = []
    dists = []
    for i in 1:500
        try
            g(x) = epa.objetivo(x, net)
            o = opt.minimize(g, pontos[i,:], method="Nelder-Mead")
            #if o["sucess"]
            append!(x, [pontos[i,:]])
            append!(y, o["x"])
            append!(dists, epa.get_dist(y[end], net))
            println(y[end])
            #end
        catch
            nothing
        end
    end
    writedlm("./teste_perform/$dim/x.txt", x)
    writedlm("./teste_perform/$dim/dists.txt", dists)
    writedlm("./teste_perform/$dim/y.txt", y)
    epa.close_sim()

end

termino = time()
println(termino-comeco)