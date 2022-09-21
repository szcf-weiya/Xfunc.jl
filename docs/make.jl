# https://discourse.julialang.org/t/plotting-errors-when-building-documentation-using-plots-jl-and-documenter-jl/67849/5
ENV["PLOTS_TEST"] = "true"
ENV["GKSwstype"] = "100"
using Documenter, Xfunc

makedocs(sitename = "Xfunc.jl Documentation")

deploydocs(
    repo = "github.com/szcf-weiya/Xfunc.jl.git",
)