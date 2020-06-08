using Gadfly
using Distributions
import Cairo, Fontconfig

p = plot(Guide.title("True beta: 2, est. beta: " * string(b)),
layer(x=x, y=y, Geom.point()),
layer(x=x,y=x*bvals[1], Geom.line()),
layer(x=x,y=x*bvals[5], Geom.line()),
layer(x=x,y=x*b, Geom.line()))
img = PNG("iris_plot2.png", 14cm, 8cm)
draw(img, p)