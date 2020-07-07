#=
Exemplo retirado de https://gist.github.com/dirmeier/d9f53587e32f265d92b1039d5d9a168f

=#
using Gadfly
using Distributions
import Cairo, Fontconfig

function df(x, y, b)
    sum(- (y - x*b)' * x)
end

function gd()
   rnorm = Normal()
   x = rand(rnorm, 100)
   y = x * 2 + rand(rnorm, 100)
   b    = 0.0
   bold = 1.0
   bvals = Float64[]
   while (sum(abs(b - bold)) > 1e-10)
       push!(bvals, b)
       bold = b
       der = df(x, y, bold)
       b   =  b - 0.001 * der
   end
   p = plot(Guide.title("True beta: 2, est. beta: " * string(b)),
        layer(x=x, y=y, Geom.point()),
        layer(x=x,y=x*bvals[1], Geom.line()),
        layer(x=x,y=x*bvals[5], Geom.line()),
        layer(x=x,y=x*b, Geom.line()))
    img = PNG("iris_plot2.png", 14cm, 8cm)
    draw(img, p)
end

gd()