# https://discourse.julialang.org/t/plotting-errors-when-building-documentation-using-plots-jl-and-documenter-jl/67849/5
ENV["PLOTS_TEST"] = "true"
ENV["GKSwstype"] = "100"
using Documenter, xfun

makedocs(sitename = "xfun.jl Documentation")

deploydocs(
    repo = "github.com/szcf-weiya/xfun.jl.git",
)