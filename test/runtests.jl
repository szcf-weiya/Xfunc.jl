using Test
using xfun
using Plots

@testset "myrange" begin
    @test myrange([1, 2, 3]) == (1, 3)
    @test myrange([1, NaN, 3]) == (1, 3)
end

@testset "split_keystr" begin
    res = split_keystr("a123_b234")
    @test res["a"] == 123
    @test res["b"] == 234
end

@testset "saveplots" begin
    figs = Plots.Plot[]
    for i in 1:12
        push!(figs, plot(i))
    end
    save_grid_plots(figs, 3, 4)
end

@testset "print2tex" begin
    @testset "simple" begin
        μ = [rand(3, 4), rand(3, 4)]
        σ = [rand(3, 4), rand(3, 4)]
        print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = joinpath(@__DIR__, "tables/table.tex"))
        # run(`make -C $(@__DIR__)/tables`) # test locally
    end
    @testset "other cols" begin
        μ = [rand(3, 4), rand(3, 4)]
        σ = [rand(3, 4), rand(3, 4)]
        others = [rand(3, 1), rand(3, 1)]
        others_σ = [rand(3, 1), rand(3, 1)]
        filepath = joinpath(@__DIR__, "tables/table.tex")
        # filepath = "test/tables/table.tex" # use when locally developping
        print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = filepath, other_cols = others, other_col_names = ["other"], other_cols_σ = others_σ)
    end
    @testset "other right cols"  begin
        μ = [rand(3, 4), rand(3, 4)]
        σ = [rand(3, 4), rand(3, 4)]
        others = [rand(3, 1), rand(3, 1)]
        others_σ = [rand(3, 1), rand(3, 1)]
        right = [[rand(3), rand(3)]]
        filepath = joinpath(@__DIR__, "tables/table.tex")
        # filepath = "../test/tables/table.tex"
        print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = filepath, other_cols = others, other_col_names = ["other"], other_cols_σ = others_σ, right_cols = right, right_col_names = ["right"])
    end
end