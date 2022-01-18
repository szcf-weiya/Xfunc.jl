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