using Printf
using HTTP

writeline(io, str...) = write(io, str..., "\n")
# suppose each row has the same number of subrows
# TODO: varied subrows and subcolumns
# abstractmatrix allows transposes of matrix
"""
    print2tex()

Print a structural result to a latex table.

# Examples

TODO: It seems that jldoctest does not generate result files `ex1.tex` in Documenter.jl.

```jldoctest
julia> μ = [[1 2 3 4; 5 6 7 8], [4 3 2 1; 8 7 6 5]]
2-element Vector{Matrix{Int64}}:
 [1 2 3 4; 5 6 7 8]
 [4 3 2 1; 8 7 6 5]

julia> σ = [ones(Int, 2, 4), ones(Int,2,4)]
2-element Vector{Matrix{Int64}}:
 [1 1 1 1; 1 1 1 1]
 [1 1 1 1; 1 1 1 1]

julia> print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2"], ["x", "y"], file = "ex1.tex")
noc = 0
14

julia> tex2png("ex1.tex")
```
"""
function print2tex(μ::AbstractVector{T}, σ::AbstractVector{T}, 
                    rownames::AbstractVector{String}, colnames::AbstractVector{String},
                    subrownames::AbstractVector{String}, subcolnames::AbstractVector{String}; 
                    colnames_of_rownames = ["level0", "level1"], file = "/tmp/tmp.tex",
                    other_cols = nothing, other_col_names = nothing,
                    other_cols_σ = nothing,
                    right_cols = nothing, right_col_names = nothing,
                    isbf = nothing,
                    right_align = 'l', # a better way?
                    sigdigits = 4) where T <: AbstractMatrix
    @assert length(rownames) == length(μ) == length(σ)
    nrow = length(μ)
    rowlevel = 2
    ncol0 = length(colnames)
    ncol1 = length(subcolnames)
    ncol = ncol0 * ncol1 # plus levels of rownames
    if isnothing(other_cols)
        noc = 0
    else
        noc = size(other_cols[1], 2)
    end
    println("noc = $noc")
    if isnothing(right_cols)
        nor = 0
    else
        nor = length(right_cols) # use list
    end
    open(file, "w") do io
        write(io, raw"\begin{tabular}{" * repeat('c', ncol + 2 + noc) * repeat(right_align, nor) * raw"}", "\n")
        writeline(io, raw"\toprule")
        # colnames at the first level
        # write(io, "&")
        write(io, raw"\multirow{2}{*}{", colnames_of_rownames[1], "} & ", 
                  raw"\multirow{2}{*}{", colnames_of_rownames[2], "}")
        if !isnothing(other_cols)
            for i = 1:noc
                write(io, raw"& \multirow{2}{*}{", other_col_names[i], "}")
            end
        end
        for i = 1:ncol0
            write(io, "&" * raw"\multicolumn{", "$ncol1}{c}{", colnames[i], "}")
        end
        if !isnothing(right_cols)
            for i = 1:nor
                write(io, raw"& \multirow{2}{*}{", right_col_names[i], "}")
            end
        end
        writeline(io, raw"\tabularnewline")
        # writeline(io, raw"\cmidrule{3-", "$(ncol+2)}")
        left = 3 + noc
        for i = 1:ncol0
            right = left + ncol1 - 1
            writeline(io, raw"\cmidrule(lr){", "$left-", "$right}")
            left = right + 1
        end
        # colnames at the second level
        write(io, "&")
        for i = 1:noc
            write(io, "&")
        end
        for i = 1:ncol0
            for j = 1:ncol1
                write(io, "&", subcolnames[j])
            end
        end
        writeline(io, raw"\tabularnewline")
        for i = 1:nrow
            writeline(io, raw"\midrule")
            # μi = round.(μ[i], sigdigits = sigdigits)
            # σi = round.(σ[i], sigdigits = sigdigits)
            m = size(μ[i], 1)
            for j = 1:m
                if j == 1
                    write(io, raw"\multirow{", "$m}{*}{", rownames[i], "}")
                end
                write(io, "&", subrownames[j])
                for ii in 1:noc
                    if isnothing(other_cols_σ)
                        write(io, "& $(@sprintf "%.2e" other_cols[i][j, ii])")
                    else
                        write(io, "& $(@sprintf "%.2e" other_cols[i][j, ii]) ($(@sprintf "%.1e" other_cols_σ[i][j, ii]))")
                    end
                end
                # write rownames
                for k = 1:ncol
                    if isnothing(isbf)
                        write(io, "& $(@sprintf "%.2e" μ[i][j, k]) ($(@sprintf "%.1e" σ[i][j, k]))")
                    else                        
                        if isbf[i][j, k]
                            write(io, "& \\textbf{$(@sprintf "%.2e" μ[i][j, k])} ($(@sprintf "%.1e" σ[i][j, k]))")
                        else
                            write(io, "& $(@sprintf "%.2e" μ[i][j, k]) ($(@sprintf "%.1e" σ[i][j, k]))")
                        end
                    end
                end
                if !isnothing(right_cols)
                    for ii = 1:nor
                        write(io, "& $(right_cols[ii][i][j])")
                    end
                end
                writeline(io, raw"\tabularnewline")
            end
        end
        writeline(io, raw"\bottomrule")
        writeline(io, raw"\end{tabular}")
    end
end

"""
    tex2png()

Render a latex table source file into an image via https://quicklatex.com/js/quicklatex.js
"""
function tex2png(file::String, url = "https://quicklatex.com/latex3.f")
    preamble = raw"""
    \usepackage{amsmath}
    \usepackage{amsfonts}
    \usepackage{amssymb}
    \usepackage{multirow}
    \usepackage{booktabs}
    """
    content = String(read(file))
    content = replace(content, "&"=>"%26", "%"=>"%25")
    preamble = replace(preamble, "&"=>"%26", "%"=>"%25")
    post_data = "formula=" * content * "&mode=0&out=1&preamble=" * preamble
    r = HTTP.request("POST", url, [], post_data)
    ret = String(r.body)
    imgurl = split(ret)[2]
    output = replace(file, ".tex" => ".png")
    HTTP.download(imgurl, output)
end