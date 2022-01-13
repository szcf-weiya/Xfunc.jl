function myparse(str)
    if occursin(":", str) # only for int currently
        ys = split(str, ":")
        xs = parse.(Int, ys)
        if length(xs) == 2
            return xs[1]:xs[2]
        else
            return xs[1]:xs[2]:xs[3]
        end
    else
        if occursin(".", str)
            return parse(Float64, str)
        else
            return parse(Int, str)
        end
    end
end

"""
    split_keystr(str)

Split string with format `StrNum_StrNum` into key pairs

```jldoctest
julia> split_keystr("a123_b234")
Dict{Any, Any} with 2 entries:
  "b" => 234
  "a" => 123
```
"""
function split_keystr(x::String)
    # x = "a123_b234"
    xs = split(x, "_")
    res = Dict()
    for y in xs
        try
            ys = match(r"([a-zA-Z]+)(.*)", y).captures
            if ys[2] != ""
                res[ys[1]] = myparse(ys[2])
            end
        catch e
            @warn e
        end
    end
    return res
end
