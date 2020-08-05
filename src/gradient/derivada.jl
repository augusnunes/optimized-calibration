f(x) = x^2

function derivada1(f, p)
    value = 0
    h = 0.001
    value += (f(p) - f(p-h))/h
    value += (f(p+h) - f(p))/h
    value += (f(p+h) - f(p-h))/(h*2)
    return value/3
end

derivada1(f, 2) |> println