using MzPlots
using Documenter

makedocs(;
    modules=[MzPlots],
    authors="Tim Holy <tim.holy@gmail.com> and contributors",
    repo="https://github.com/timholy/MzPlots.jl/blob/{commit}{path}#L{line}",
    sitename="MzPlots.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://timholy.github.io/MzPlots.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/timholy/MzPlots.jl",
)
