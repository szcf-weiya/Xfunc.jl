module xfun

include("plot.jl")
include("stat.jl")
include("str.jl")
include("table.jl")

export 
    save_grid_plots,
    save_plots,
    myrange,
    split_keystr,
    print2tex,
    tex2png,
    star_pval
end