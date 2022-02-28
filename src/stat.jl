using Printf
"""
    myrange(x)

Return the range of `x` by columns, ignoring `NaN`.
"""
function myrange(x::AbstractVector{T}) where T <: Real
    ind = .!isnan.(x)
    return (minimum(x[ind]), maximum(x[ind]))
end

function myrange(x::AbstractMatrix{T}) where T <: Real
    n = size(x, 2)
    res = zeros(2, n)
    for i = 1:n
        res[:, i] .= myrange(x[:, i])
    end
    return res
end

"""
    Annotate significance with symbols. Refer to `?symnum` in R.
"""
function star_pval(x::AbstractVector)
    n = length(x)
    res = Array{String, 1}(undef, n)
    for i = 1:n
        if x[i] < 1e-3
            s = "***"
        elseif x[i] < 1e-2
            s = "**"
        elseif x[i] < 5e-2
            s = "*"
        elseif x[i] < 1e-1
            s = "."
        else
            s = ""
        end
        num = @sprintf "%.2e" x[i]
        if s != ""
            res[i] = "$num ($s)"
        else
            res[i] = "$num"
        end
    end
    return res
end

