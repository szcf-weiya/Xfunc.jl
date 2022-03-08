using Printf

"""
    myrange(x)

Return the range of `x` by columns, ignoring `NaN`. Note that `NaN` will results an Int array as Float64 array.

# Examples

```jldoctest
julia> myrange([1, 2, 3])
(1, 3)

julia> myrange([1, NaN, 3])
(1.0, 3.0)

julia> myrange([1 2; 3 4; 5 6])
2×2 Matrix{Int64}:
 1  2
 5  6
```

"""
function myrange(x::AbstractVector{T}) where T <: Real
    ind = .!isnan.(x)
    return (minimum(x[ind]), maximum(x[ind]))
end

function myrange(x::AbstractMatrix{T}) where T <: Real
    n = size(x, 2)
    res = zeros(typeof(x[1]), 2, n)
    for i = 1:n
        res[:, i] .= myrange(x[:, i])
    end
    return res
end

"""
    star_pval(x)
    
Annotate significance with symbols. Refer to `?symnum` in R.

# Examples

```jldoctest
julia> star_pval([0.0001, 0.1])
2-element Vector{String}:
 "1.00e-04 (***)"
 "1.00e-01"
```
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

