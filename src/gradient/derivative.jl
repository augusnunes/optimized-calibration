module derivative

# Incluindo módulo epanet
include("../epanet/epanet.jl")
epa = Main.epanet

function calcula_derivada(net, rugosidade::Float64, numero_grupo::Int64)
    h = 0.0001
    value = 0
    # f(x)-f(x-h)
    #      h
    value += (epa.f(net, rugosidade, numero_grupo) - epa.f(net,rugosidade-h, numero_grupo))/h
    # f(x+h)-f(x)
    #      h
    value += (epa.f(net, rugosidade+h, numero_grupo) - epa.f(net, rugosidade, numero_grupo))/h
    # f(x+h)-f(x-h)
    #      2h
    value += (epa.f(net, rugosidade+h, numero_grupo) - epa.f(net, rugosidade-h, numero_grupo))/(h*2)
    return value/3
    
end


function calcula_derivada_segunda(net, rugosidade::Float64, numero_grupo::Int64)
    # f'(x)-f'(x-h)
    #     h
    h = 0.0001
    #"calculando segunda derivada" |> println
    #return (f(net,rugosidade+2*h,numero_grupo)-2*f(net, rugosidade+h,numero_grupo)+f(net, rugosidade,numero_grupo))/h^2
    #return (calcula_derivada(net, rugosidade,numero_grupo)-calcula_derivada(net,rugosidade-h,numero_grupo))/h
    value = 0
    value += (calcula_derivada(net, rugosidade, numero_grupo) - calcula_derivada(net,rugosidade-h, numero_grupo))/h
    value += (calcula_derivada(net, rugosidade+h, numero_grupo) - calcula_derivada(net, rugosidade, numero_grupo))/h
    value += (calcula_derivada(net, rugosidade+h, numero_grupo) - calcula_derivada(net, rugosidade-h, numero_grupo))/(h*2)
    return value/3
end

end #ends module