module MzPlots

using Unitful
using MzCore
using MzCore.IntervalSets
import MzCore.AxisArrays
using Observables
import AbstractPlotting
using AbstractPlotting: Scene, image!, xlabel!, ylabel!, cam2d!
using AbstractPlotting.MakieLayout
import RecipesBase
using UnitfulRecipes
using UnitfulRecipes: fixaxis!

export dynamic_binning, mzplot

function dynamic_binning(f, scans, limits::Observable; buffersz=(1000,1000))
    map(limits) do lims
        time, mz = lims
        axt  = Axis{:time}(range(minimum(time), stop=maximum(time), length=buffersz[1]))
        axmz = Axis{:mz}(range(minimum(mz), stop=maximum(mz), length=buffersz[2]))
        T = intensitytype(eltype(scans))
        tmp = AxisArray(Matrix{T}(undef, buffersz), axmz, axt)
        copyto!(tmp, scans)
        return f.(transpose(tmp.data))
    end
end

interval_width(left, w) = left .. left+w
interval_width(left, w, scale) = left*scale .. (left+w)*scale

function mzplot(f, scans; title=" ", resolution=(800,800), buffersz=resolution, kwargs...)
    axmz, axtime = limits(scans)
    limmz, limtime = axisvalues(axmz)[1], axisvalues(axtime)[1]
    timeu = unit(limtime.left)

    scene, layout = layoutscene(30, resolution=resolution)
    ax = layout[1,1] = LAxis(scene, title=title, xlabel="Time ($timeu)", ylabel="m/z")
    isfirst = true
    axlimits = async_latest(ax.limits)
    lims = map(axlimits) do box
        if isfirst
            isfirst = false
            return limtime, limmz
        end
        return interval_width(box.origin[1], box.widths[1], timeu), interval_width(box.origin[2], box.widths[2])
    end
    imgbin = dynamic_binning(f, scans, lims; buffersz=buffersz)
    xi, yi = ustrip(lims[][1]), lims[][2]
    image!(ax, xi, yi, imgbin)
    return scene, ax
end
mzplot(scans; kwargs...) = mzplot(sqrt, scans; kwargs...)

# User recipe for Plots
RecipesBase.@recipe function f(img::AA) where AA<:AxisArray{T,2} where T
    y, x = axisvalues(img)
    yname, xname = axisnames(img)
    xguide --> string(xname)
    yguide --> string(yname)
    if eltype(x) <: Quantity
        x = fixaxis!(plotattributes, x, :x)
    end
    if eltype(y) <: Quantity
        y = fixaxis!(plotattributes, y, :y)
    end
    return x, y, parent(img)
end

end
