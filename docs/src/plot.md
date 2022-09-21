# Plots

```@docs
save_plots
save_grid_plots
```

## Examples

```@example
using Xfunc
using Plots
figs = Plots.Plot[]
x = 0:0.1:1
for i in 1:6
    push!(figs, plot(x, x.^i, title = "degree = $i"))
end
save_grid_plots(figs)
```

![](/tmp/all.png)

## Gallery

This part contains figures that I used, and not necessarily depend on the `Xfunc.jl` package.

### Joint Density with Marginal Densities

```@example
using Plots
using Distributions
# GR.inline("svg") # No need, see #1 for more details
d1 = Normal(0, 1)
d2 = Normal(0, 1)
jd = MvNormal([1 0.5; 0.5 1])
x1 = -2:0.1:2
x2 = -2:0.1:2
m1 = plot(x1, Base.Fix1(pdf, d1), label="", axis = nothing)
m2 = plot(pdf.(d2, x2), x2, xflip=true, ymirror=true, label="", axis = nothing)
j = contour(x1, x2, (x, y)->pdf(jd, [x, y]), legend = false)
plot(m1, m2, j, layout=@layout([_ o{0.1h}; o{0.1w} o]))
```

!!! tip
    - Underscore `_` can represent empty figures in `@layout`.
    - `xflip` and `ymirror` are used to created the rotated density plot.