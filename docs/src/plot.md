# Plot

```@docs
save_plots
save_grid_plots
```

## Examples

```@example
using xfun
using Plots
figs = Plots.Plot[]
x = 0:0.1:1
for i in 1:6
    push!(figs, plot(x, x.^i, title = "degree = $i"))
end
save_grid_plots(figs)
```

![](/tmp/all.png)