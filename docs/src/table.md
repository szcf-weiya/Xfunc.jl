# Table

```@docs
print2tex
tex2png
```

## Examples

### Multi-rows and Multi-columns

```@example 1
using xfun
μ = [rand(3, 4), rand(3, 4)]
σ = [rand(3, 4), rand(3, 4)]
print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = "ex1.tex")
tex2png("ex1.tex")
```

![](ex1.png)

### Add columns on the left

```@example 1
others = [rand(3, 1), rand(3, 1)]
others_σ = [rand(3, 1), rand(3, 1)]
print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = "ex2.tex", other_cols = others, other_col_names = ["other"], other_cols_σ = others_σ)
tex2png("ex2.tex")
```

![](ex2.png)


### Add columns on the right

```@example 1
right = [[rand(3), rand(3)]]
filepath = joinpath(@__DIR__, "tables/table.tex")
# filepath = "../test/tables/table.tex"
print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = "ex3.tex", other_cols = others, other_col_names = ["other"], other_cols_σ = others_σ, right_cols = right, right_col_names = ["right"])
tex2png("ex3.tex")
```

![](ex3.png)
