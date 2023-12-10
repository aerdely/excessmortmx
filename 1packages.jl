### Install required Julia packages

using Pkg

begin
    paquete = ["CSV", "DataFrames", "Plots", "StatsPlots", "Distributions", "HypothesisTests"]
    for p in paquete
        println("*** Installing package: ", p)
        Pkg.add(p)
    end
    println("*** End of package list.")
end
