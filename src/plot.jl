using Primes
using Plots
const tmp = tempdir()

"""
    save_plots(ps; output)

Save multi-images into a pdf file, if `output` is unspecified (default), the resulting file is `/tmp/all.pdf`.
"""
function save_plots(ps::Array; output = nothing)
    n = length(ps)
    for (i, p) in enumerate(ps)
        savefig(p, "$tmp/p$i.pdf")
    end
    fignames = "$tmp/p" .* string.(1:n) .* ".pdf"
    run(`pdftk $fignames cat output $tmp/all.pdf`)
    if !isnothing(output)
        mv("$tmp/all.pdf", output)
    end
end
# Tip: convert tuple (a, b, c) to array [a, b, c] via `collect`
save_plots(ps::Tuple; kw...) = save_plots(collect(ps); kw...)

"""
    save_grid_plots(ps[, nrow, ncol])

Combine multi-plots into a `nrow` x `ncol` grid. If `nrow` and `ncol` are not specified, then a factorization would be used. The output file is `/tmp/all.png`

If the backend is PGFPlotsXBackend, it will call `save_plots` instead.
"""
function save_grid_plots(ps::Array, out = "all")
    if Plots.backend() == Plots.PGFPlotsXBackend()
        @warn "PGFPlotsXBackend is used, so cat figures into pdf"
        save_plots(ps)
        return 0
    end
    n = length(ps)
    res = factor(Vector, n)
    # determine nrow and ncol of the grid
    ncol = res[end]
    nrow = Int(n / ncol)
    save_grid_plots(ps, nrow, ncol, out)
end

function save_grid_plots(ps, nrow, ncol, out = "all")
    n = length(ps)
    if nrow * ncol != n
        error("different number of plots")
    end
    for (i, p) in enumerate(ps)
        savefig(p, "$tmp/p$i.png")
    end
    for i = 1:nrow
        fignames = "$tmp/p" .* string.(ncol * (i-1) .+ (1:ncol)) .* ".png"
        run(`convert $fignames +append $tmp/pp$i.png`)
    end
    for i = 1:nrow
        fignames = "$tmp/pp" .* string.(1:nrow) .* ".png"
        run(`convert $fignames -append $tmp/$out.png`)
    end
end
