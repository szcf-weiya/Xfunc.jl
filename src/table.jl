using Printf

writeline(io, str...) = write(io, str..., "\n")
# suppose each row has the same number of subrows
# TODO: varied subrows and subcolumns
function print2tex(μ::AbstractVector{Matrix{T}}, σ::AbstractVector{Matrix{T}}, 
                    rownames::AbstractVector{String}, colnames::AbstractVector{String},
                    subrownames::AbstractVector{String}, subcolnames::AbstractVector{String}; 
                    colnames_of_rownames = ["level0", "level1"], file = "/tmp/tmp.tex",
                    isbf = nothing,
                    sigdigits = 4) where T <: AbstractFloat
    @assert length(rownames) == length(μ) == length(σ)
    nrow = length(μ)
    rowlevel = 2
    ncol0 = length(colnames)
    ncol1 = length(subcolnames)
    ncol = ncol0 * ncol1 # plus levels of rownames
    open(file, "w") do io
        write(io, raw"\begin{tabular}{" * repeat("c", ncol + 2) * raw"}", "\n")
        writeline(io, raw"\toprule")
        # colnames at the first level
        # write(io, "&")
        write(io, raw"\multirow{2}{*}{", colnames_of_rownames[1], "} & ", 
                  raw"\multirow{2}{*}{", colnames_of_rownames[2], "}\n")
        for i = 1:ncol0
            write(io, "&" * raw"\multicolumn{", "$ncol1}{c}{", colnames[i], "}")
        end
        writeline(io, raw"\tabularnewline")
        # writeline(io, raw"\cmidrule{3-", "$(ncol+2)}")
        left = 3
        for i = 1:ncol0
            right = left + ncol1 - 1
            writeline(io, raw"\cmidrule(lr){", "$left-", "$right}")
            left = right + 1
        end
        # colnames at the second level
        write(io, "&")
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
                writeline(io, raw"\tabularnewline")
            end
        end
        writeline(io, raw"\bottomrule")
        writeline(io, raw"\end{tabular}")
    end
end