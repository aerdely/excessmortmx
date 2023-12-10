### Supplementary material (inmediately after executing 5tables.jl)

println("*** Supplementary material ***")


#=
    Figure Extra 1: illness-related deaths evolution of fitted parameters
=#
let 
    println("\n FigureExtra1.png: illness-related deaths evolution of fitted parameters\n")
    m = Enftodos_modelo
    años = collect(1998:2022)
    #
    α = m.param[1, :]
    plot(años, α, lw = 3, legend = false, title = "α", xticks = 1998:7:2022)
    a, b = reglin(collect(1998:2019), α[1:22])
    println("illness-related deaths shift parameter:")
    println("α(t) ≈ c + mt")
    println("c = ", a)
    println("m = ", b)
    println("% change shift in 2019:")
    println(round(100b / (a + 2019b), digits = 2), "%")
    p0 = plot!(años, a .+ b.*años, color = :gray)
    #
    β1 = m.param[2, :]
    plot(años, β1, lw = 3, legend = false, title = "β₁", xticks = 1998:7:2022)
    a, b = reglin(collect(1998:2019), β1[1:22])
    p1 = plot!(años, a .+ b.*años, color = :gray)
    #
    β2 = m.param[3, :]
    plot(años, β2, lw = 3, legend = false, title = "β₂", xticks = 1998:7:2022)
    a, b = reglin(collect(1998:2019), β2[1:22])
    p2 = plot!(años, a .+ b.*años, color = :gray)
    #
    β3 = m.param[4, :]
    plot(años, β3, lw = 3, legend = false, title = "β₃", xticks = 1998:7:2022)
    a, b = reglin(collect(1998:2019), β3[1:22])
    p3 = plot!(años, a .+ b.*años, color = :gray)
    #
    β4 = m.param[5, :]
    plot(años, β4, lw = 3, legend = false, title = "β₄", xticks = 1998:7:2022)
    a, b = reglin(collect(1998:2019), β4[1:22])
    p4 = plot!(años, a .+ b.*años, color = :gray)
    #
    σ = m.desv
    plot(años, σ, lw = 3, legend = false, title = "σ", xticks = 1998:7:2022)
    a, b = reglin(collect(1998:2019), σ[1:22])
    p5 = plot!(años, a .+ b.*años, color = :gray)
    #
    plot(p0, p1, p2, p3, p4, p5, layout = (2,3), legend = false)
    savefig("FigureExtra1.png")
end;

#=
    Figure Extra 2: Adjusted R-squared and Anderson-Darling test for normality of residuals
=#
let
    println("\n FigureExtra2.png: Adjusted R-squared and Anderson-Darling test for normality of residuals")
    R2 = Enftodos_modelo.R2
    promR2 = round(mean(R2), digits = 2)
    res = Enftodos_modelo.res
    pv = zeros(22)
    for j ∈ 1:22
        x = res[:, j]
        pv[j] = pvalue(OneSampleADTest(x, Normal(mean(x), std(x))))
    end
    plot(1998:2019, R2, lw = 3, color = :green, label = "Adjusted R-squared", legend = (.2,.4))
    xticks!(1998:2019)
    yticks!(0.0:0.1:1.0)
    xaxis!("Year", xrotation = 90); yaxis!("Value"); title!("Goodness of fit")
    hline!([0, 1], lw = 0.1, color = :lightgray, label = "")
    plot!(1998:2019, pv, lw = 2, color = :red, label = "Normality test p-value")
    savefig("FigureExtra2.png")
end;


#=
    Figure Extra 3: Some examples of the fitted model
=#
let 
    # 2003 2006 2009 2019
    println("\n FigureExtra3.png: Some examples of the fitted model")
    plot_año(2003, 1, 1, "illness deaths")
    p1 = plot!(legend = false)
    plot_año(2006, 1, 1, "illness deaths")
    p2 = plot!(legend = false)
    plot_año(2009, 1, 1, "illness deaths")
    p3 = plot!(legend = false)
    plot_año(2019, 1, 1, "illness deaths")
    p4 = plot!(legend = false)
    plot(p1, p2, p3, p4, layout = (2,2), legend = false)
    savefig("FigureExtra3.png")
end;

println("\n*** End of supplementary material ***")
