

function gradient(f, ponto)
    h = 1e-3
    f1(x)=(f(x)-f(x-h))/h
    #f2(x)=(f1(x)-f1(x-h))/h
    f2(x) = (f(x+2*h)-2*f(x+h)+f(x))/h^2
    variavel = ponto
    δf=f1(variavel)
    count = 0
    while abs(δf) > 0.001
        println(variavel)
        δf=f1(variavel)
        Δ = δf/abs(f2(variavel))
        variavel -= Δ
        println(string("x: ",variavel,"\t","δ: ",δf,"\t","Δ: ",Δ))
        
    end
    return variavel
end
#=
function f(x)
    a = x[1]^2 + x[2]^2
    return a
end

function f1(x,i)
    h = 0.001
    a = f(x)
    x[i] -=h
    b = f(x)
    return (a - b)/h
end

function f2(x,i)
    h = 0.001
    x_a = x
    x_a[i] += 2*h
    x_b = x
    x_b[i] += h 
    return (f(x_a)-2*f(x_b)+f(x))/h^2
end

function gradient_2d(x)
    h = 1e-3
    for i in 1:1:2
        ∂f = f1(x,i)
        while abs(∂f) < 1e-6
            ∂f = f1(x,i)
            Δ = ∂f/abs(f2(x,i))
            x[i] -= Δ
            string("x: ",x,"\t","∂f: ",∂f,"\t","Δ:",Δ) |> println
        end
    end
    return x
end


#g(x) = x^5+x^4+8*x^2
#gradient(g,-1) |> println
#h = 0.001
#f(x) = cos(x)
#f2(x) = (f(x+2*h)-2*f(x+h)+f(x))/h^2
#gradient_2d([500.0 3.0])
gradient_2d([1.0 3.0]) |> println
=#

f(x) = -x^3 + 3*x
#gradient(f, 0)



function gradient_v2(f, ponto)
    h = 0.002
    f1(x)=(f(x)-f(x-h))/h
    #f2(x)=(f1(x)-f1(x-h))/h
    f2(x) = (f(x+2*h)-2*f(x+h)+f(x))/h^2
    variavel = ponto
    δf=f1(variavel)
    count = 0
    while abs(δf) > 0.001
        #println(variavel)
        δf=f1(variavel)
        Δ = δf*0.001
        variavel -= Δ
        println(string("x: ",variavel,"\t","δ: ",δf,"\t","Δ: ",Δ))
        
    end
    return variavel
end

#gradient_v2(f, -4)
g(x) = abs(x-1)
gradient_v2(g, 0)