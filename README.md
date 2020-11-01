# MzPlots

[![Build Status](https://github.com/timholy/MzPlots.jl/workflows/CI/badge.svg)](https://github.com/timholy/MzPlots.jl/actions)
[![Coverage](https://codecov.io/gh/timholy/MzPlots.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/timholy/MzPlots.jl)

This package supports limited plotting of mass spectrometry data.
It is designed to be format-agnostic through its use of the [`MzCore`](https://github.com/timholy/MzCore.jl) interface,
although currently only [MzXML](https://github.com/timholy/MzXML.jl) has been implemented.

## Interactive exploration via Makie

Supposing that you have some mass spectrometry data loaded into `scans`, then it's as simple as

```julia
using Makie, MzPlots
scene, ax = mzplot(scans)   # `scans` is a vector of scan data you've loaded from a file
display(scene)
```

## Limited Plots support

You can convert the scans to an `AxisArray`:

```julia
using AxisArrays: Axis, AxisArray
# Convenient creation of an Axis range from an interval. `n` is the number of distinct values in the range.
asrange(axi::Axis{name}, n) where name = Axis{name}(range(minimum(axi.val), stop=maximum(axi.val), length=n))

lims = limits(scans)
sz = (800, length(scans))                    # or pick something else
aa = AxisArray(zeros(sz), map(asrange, lims, sz)...)
copyto!(aa, scans)
```

Then you can plot `aa` with `Plots.plot`.
