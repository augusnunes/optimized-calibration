function g(i)
x = 1
for j in 1:i
println(x)
x -= (2^(j-1))*(1/4)^j
end
return x
end
println("Entre com um número i")
println(g(parse(Int64, readline())))
