using MzPlots
using MzXML
using AbstractPlotting
using Test

@testset "MzPlots AbstractPlotting" begin
    mzxmldir = dirname(dirname(pathof(MzXML)))
    testfile = joinpath(mzxmldir, "test", "test64.mzXML")
    scans, info = MzXML.load(testfile)
    scene, ax = mzplot(scans)
    @test isa(scene, Scene)
end

import Plots
using MzPlots.MzCore
using MzCore.AxisArrays: Axis

@testset "MzPlots Plots" begin
    mzxmldir = dirname(dirname(pathof(MzXML)))
    testfile = joinpath(mzxmldir, "test", "test64.mzXML")
    scans, info = MzXML.load(testfile)
    lims = limits(scans)
    sz = (10, 2)
    asrange(axi::Axis{name}, n) where name = Axis{name}(range(minimum(axi.val), stop=maximum(axi.val), length=n))
    aa = AxisArray(zeros(sz), map(asrange, lims, sz)...)
    copyto!(aa, scans)
    p = Plots.plot(aa)
    @test isa(p, Plots.Plot)
end
