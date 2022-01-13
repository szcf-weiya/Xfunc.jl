using Test
using xfun

@testset "myrange" begin
    @test myrange([1, 2, 3]) == (1, 3)
    @test myrange([1, NaN, 3]) == (1, 3)
end

@testset "split_keystr" begin
    res = split_keystr("a123_b234")
    @test res["a"] == 123
    @test res["b"] == 234
end