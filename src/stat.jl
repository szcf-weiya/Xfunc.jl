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
