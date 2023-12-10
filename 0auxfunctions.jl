#=
    Functions and packages to read and analyze
    deaths counts and population data from Mexico (1998-2022)
=#

using DataFrames, CSV, Dates, LinearAlgebra, Distributions, Plots
using Statistics, StatsPlots, HypothesisTests

function reglin(x::Vector{<:Real}, y::Vector{<:Real})
    # simple linear regression: y = a + bx
    if length(x) ≠ length(y)
        error("vectors must have the same length")
        return nothing
    end
    n = length(x)
    sxy = sum(x .* y)
    sx2 = sum(x .^ 2)
    mx = sum(x) / n
    my = sum(y) / n
    b = (sxy - n*mx*my) / (sx2 - n*mx^2)
    a = my - b*mx
    return(a, b)
end

function ev(x::String)
    # metaprogramming
    return eval(Meta.parse(x))
end

function leer_dfs(años::Vector{Int})
    # años = vector of 4-digit years
    año = string.(años)
    g = ["Enf", "EnfHom", "EnfMuj", "NoEnf", "NoEnfHom", "NoEnfMuj", "Covid", "CovidHom", "CovidMuj"]
    for i ∈ 1:length(g)
        for a in año
            archivo = g[i] * a * ".csv"
            ev(g[i] * a  * " = DataFrame(CSV.File(\"$archivo\"))")
        end
    end
    return nothing
end


# groups by cause of death (males, females or both)
""" 
Enf = illness deaths

    EnfHom = illness male deaths
    
    EnfMuj = illness female deaths

Covid = COVID-19 deaths (included in illness deaths)

    CovidHom = COVID-19 male deaths

    CovidMuj = COVID-19 female deaths

NoEnf = non-illness deaths (accidents, homicides and suicides)
    
    NoEnfHom = non-illness male deaths
    
    NoEnfMuj = non-illness female deaths 
"""
const grupo = ["Enf", "EnfHom", "EnfMuj", "NoEnf", "NoEnfHom", "NoEnfMuj", "Covid", "CovidHom", "CovidMuj"]


# age groups
"""
todos = all ages

e00 = ages 0 to 5

e06 = ages 6 to 10

e11 = ages 11 to 19

e20 = ages 20 to 29

e30 = ages 30 to 39

e40 = ages 40 to 49

e50 = ages 50 to 59

e60 = ages 60 to 269

e70 = ages 70 and older
"""
const edad = ["todos", "e00", "e06", "e11", "e20", "e30", "e40", "e50", "e60", "e70"]


"""
Names of data sets extracted using `datos` function
"""
datos_extraidos = String[]


function datos(g::Int, e::Int)
    # g = `grupo` number
    # e = `edad` number
    ge = grupo[g] * edad[e]
    ev(ge * " = DataFrame()") # `ge` dataframe
    for a ∈ string.(collect(1998:2022))
        ev(ge * ".a" * a * " = " * grupo[g] * a * "." * edad[e])
    end
    println(ge, " (dataframe)")
    ev(ge * "_obs = zeros(size($ge))") # matrix version of dataframe `ge`
    ev("nc = ncol($ge)")
    for j ∈ 1:nc
        ev(ge * "_obs[:, $j] = " * ge * "[:, $j]")
    end
    println(ge * "_obs (matrix)")
    if ge ∉ datos_extraidos
        push!(datos_extraidos, ge)
        sort!(datos_extraidos)
    end
    return nothing
end

function polinomio(Yobs::Matrix{<:Real})
    # polynomial equations for weeks 1:52 and correction factor for week 53
    # Yobs a 53×25 matrix (observed values of weeks 1:53 and years 1998:2022)
    fy(t, p) = p ⋅ t.^[0,1,2,3,4]
    t = collect(1:52)
    w = zeros(9)
    for k ∈ 1:9
        w[k] = sum(t .^ (k-1))
    end
    W = [w[1] w[2] w[3] w[4] w[5];
        w[2] w[3] w[4] w[5] w[6];
        w[3] w[4] w[5] w[6] w[7];
        w[4] w[5] w[6] w[7] w[8];
        w[5] w[6] w[7] w[8] w[9]
    ]
    invW = inv(W)
    n = size(Yobs)[2] # length of 1998:2022
    Z = zeros(5, n-3)
    # W*p = Z[:, j]
    for j ∈ 1:(n-3)
        for k ∈ 1:5
            Z[k, j] = (t.^(k-1)) ⋅ Yobs[1:52, j]
        end
    end
    # parameter estimation
    Pest = zeros(5, n)
    for j ∈ 1:(n-3) # j ∈ (n-2):n will be forecasted later
        Pest[:, j] = invW * Z[:, j] # solving for p in W*p = Z[:, j]
    end
    Yest = zeros(53, n)
    for j ∈ 1:(n-3) # j ∈ (n-2):n will be forecasted later
        for t ∈ 1:52
            Yest[t, j] = fy(t, Pest[:, j])
        end
    end
    # estimation of week 53 (1 day, or 2 days if leap year)
    Yaj53 = zeros(n-3)
    for j ∈ 1:(n-3)
        if isleapyear(1997 + j)
            Yaj53[j] = fy(53, Pest[:, j]) * 2/7
        else
            Yaj53[j] = fy(53, Pest[:, j]) * 1/7
        end
    end
    r53 = Yobs[53,1:(n-3)] ./ Yaj53
    factor53 = zeros(3)
    factor53[2] = median(r53)
    factor53[1] = quantile(r53, 0.025) / factor53[2]
    factor53[3] = quantile(r53, 0.975) / factor53[2]
    Yest[53, 1:(n-3)] = Yaj53 .* factor53[2]
    # results:
    return Pest, Yest, factor53
end

function modelo(g::Int, e::Int)
    # g = `grupo` number
    # e = `edad` number
    nombredatos = grupo[g] * edad[e]
    if nombredatos ∉ datos_extraidos
        println("`datos_extraidos`:")
        println(datos_extraidos)
        error("You must generate the data first with `datos` function")
        return nothing
    end
    ev("Yobs = " * nombredatos * "_obs")
    Pest, Yest, factor53 = polinomio(Yobs)
    R = Yest[1:52, 1:22] - Yobs[1:52, 1:22] # residuals for weeks 1:52 and years 1998:2019
    σ = zeros(25) # std dev of residuals for weeks 1:52 of each year
    q025 = zeros(25) # 0.025 quantile of residuals
    q975 = zeros(25) # 0.975 quantile of residuals
    n = size(R)[1] # sample size per year (52)
    nv = 4 # number of variables in model (4th degree polynomial)
    R2aj = zeros(22)
    for j ∈ 1:22 # for j ∈ 23:25 it will be forecasted later
        re = R[:, j]
        SSres = sum(re .^ 2)
        mediaobs = mean(Yobs[1:52, j])
        SStot = sum((Yobs[1:52, j] .- mediaobs) .^ 2)
        σ[j] = √(SSres / (n - nv - 1))
        R2 = 1 - SSres/SStot
        R2aj[j] = R2 - (1 - R2)*nv/(n-nv-1) # adjusted R-quared coefficient
        Z = Normal(0, σ[j])
        q025[j] = quantile(Z, 0.025)
        q975[j] = quantile(Z, 0.975)
    end
    # polynomial parameters forecast for years 2020:2022 for weeks 1:52
    años = collect(1998:2019)
    for k ∈ 1:5
        p = Pest[k, 1:22]
        r = reglin(años, p) # simple linear regression
        Pest[k, 23] = r[1] + r[2]*2020
        Pest[k, 24] = r[1] + r[2]*2021
        Pest[k, 25] = r[1] + r[2]*2022
    end
    # std deviation forecast for years 2020:2022 for weeks 1:52
    a, b = reglin(años, σ[1:22])
    σ[23] = a + b*2020
    σ[24] = a + b*2021
    σ[25] = a + b*2022
    X2020 = Normal(0, σ[23])
    X2021 = Normal(0, σ[24])
    X2022 = Normal(0, σ[25])
    q025[23] = quantile(X2020, 0.025)
    q025[24] = quantile(X2021, 0.025)
    q025[25] = quantile(X2022, 0.025)
    q975[23] = quantile(X2020, 0.975)
    q975[24] = quantile(X2021, 0.975)
    q975[25] = quantile(X2022, 0.975)
    # expected mortality for years 2020:2022
    fy(t, p) = p ⋅ t.^[0,1,2,3,4]
    for s ∈ 1:52
        Yest[s, 23] = fy(s, Pest[:, 23])
        Yest[s, 24] = fy(s, Pest[:, 24])
        Yest[s, 25] = fy(s, Pest[:, 25])
    end
    Yest[53, 23] = fy(53, Pest[:, 23]) * (2/7) * factor53[2]  # 2/7 because 2020 is leap year
    Yest[53, 24] = fy(53, Pest[:, 24]) * (1/7) * factor53[2]  # 1/7 because 2021 is not leap year
    Yest[53, 25] = fy(53, Pest[:, 25]) * (1/7) * factor53[2]  # 1/7 because 2022 is not leap year
    # excess of mortality
    exmort_abs = Yobs[:, 23:25] - Yest[:, 23:25]
    exmort_prc = @. 100 * (Yobs[:, 23:25] / Yest[:, 23:25] - 1)
    nombretupla = nombredatos * "_modelo"
    resultado = (obs = Yobs, est = Yest, param = Pest, fs53 = factor53, res = R, desv = σ,
                 q025 = q025, q975 = q975, R2 = R2aj, exceso = (abs = exmort_abs, prc = exmort_prc)
    )
    ev(nombretupla * " = $resultado")
    println(nombretupla)
    if nombretupla ∉ datos_extraidos
        push!(datos_extraidos, nombretupla)
        sort!(datos_extraidos)
    end
    return nothing
end

function plot_año(año::Int, g::Int, e::Int, título::String; th = false)
    # año ∈ {1998, 1999, ..., 2022}
    # g = `grupo` number
    # e = `edad` number
    # if `th` true then death count in thousands
    j = año - 1997
    sem = collect(1:52) # just for plotting: 1 day (or 2) of week 53 ignored
    nombremodelo = grupo[g] * edad[e] * "_modelo"
    ev("m = $nombremodelo")
    yobs = m.obs[1:52, j]
    yest = m.est[1:52, j]
    yinf = zeros(52)
    ysup = zeros(52)
    yinf = yest .+ m.q025[j]
    ysup = yest .+ m.q975[j]
    yth = ""
    if th == true
        yobs /= 1_000; yest /= 1_000; yinf /= 1_000; ysup /= 1_000
        yth = " (thousands)"
    end
    plot(sem, yest, lw = 3, color = :green, label = "expected with 95% conf interval")
    title!(título * " ($año)")
    xaxis!("Week"); yaxis!("Death count" * yth)
    plot!(sem, yinf, lw = 1.5, color = :green, label = "")
    plot!(sem, ysup, lw = 1.5, color = :green, label = "")
    plot!(sem, yobs, lw = 3, color = :red, label = "observed")
end

function plot_año_bis(año::Int, g::Int, e::Int; th = false, yax = false)
    # año ∈ {1998, 1999, ..., 2022}
    # g = `grupo` number
    # e = `edad` number
    # if `th` true then death count in thousands
    j = año - 1997
    sem = collect(1:52) # just for plotting: 1 day (or 2) of week 53 ignored
    nombremodelo = grupo[g] * edad[e] * "_modelo"
    ev("m = $nombremodelo")
    yobs = m.obs[1:52, j]
    yest = m.est[1:52, j]
    yinf = zeros(52)
    ysup = zeros(52)
    yinf = yest .+ m.q025[j]
    ysup = yest .+ m.q975[j]
    yth = ""
    if th == true
        yobs /= 1_000; yest /= 1_000; yinf /= 1_000; ysup /= 1_000
        yth = " (thousands)"
    end
    plot(sem, yest, lw = 1.4, color = :green, legend = false)
    title!(string(año)); xaxis!("Week")
    if yax == true
        yaxis!("Death count" * yth)
    end
    plot!(sem, yinf, lw = 0.7, color = :green, label = "")
    plot!(sem, ysup, lw = 0.7, color = :green, label = "")
    plot!(sem, yobs, lw = 2.1, color = :red, label = "")
end

function exceso_total(g::Int, e::Int) # ****** 2022 data update pending *********
    # g = `grupo` number
    # e = `edad` number
    nombremodelo = grupo[g] * edad[e] * "_modelo"
    ev("m = $nombremodelo")
    tabla = DataFrame(año = ["2020", "2021", "2022", "2020-2022", "2020-2021"], abs = zeros(Int, 5), prc = zeros(5))
    # 2020
    tabla.abs[1] = Int(round(sum(m.exceso.abs[:, 1])))
    tabla.prc[1] = round(100 * tabla.abs[1] / sum(m.est[:, 23]), digits = 1)
    # 2021
    tabla.abs[2] = Int(round(sum(m.exceso.abs[:, 2])))
    tabla.prc[2] = round(100 * tabla.abs[2] / sum(m.est[:, 24]), digits = 1)
    # 2022 (incomplete info, just up to week 49)  ************************************
    tabla.abs[3] = Int(round(sum(m.exceso.abs[1:49, 3])))
    tabla.prc[3] = round(100 * tabla.abs[3] / sum(m.est[:, 25]), digits = 1)
    # 2020-2022 (just up to week 49 of 2022)  ***************************************
    tabla.abs[4] = tabla.abs[1] + tabla.abs[2] + tabla.abs[3]
    tabla.prc[4] = round(100 * tabla.abs[4] / sum(m.est[:, 23:25]), digits = 1)
    # 2020-2021
    tabla.abs[5] = tabla.abs[1] + tabla.abs[2]
    tabla.prc[5] = round(100 * tabla.abs[5] / sum(m.est[:, 23:24]), digits = 1)
    println(nombremodelo)
    return tabla
end

function exceso_total_intervalo(g::Int, e::Int) # ****** 2022 data update pending *********
    # g = `grupo` number
    # e = `edad` number
    nombremodelo = grupo[g] * edad[e] * "_modelo"
    ev("m = $nombremodelo")
    tabla = DataFrame(año = ["2020", "2021", "2022", "2020-2022", "2020-2021"], 
                              inf = zeros(Int, 5), abs = zeros(Int, 5), sup = zeros(Int, 5),
                              pinf = zeros(5), pmid = zeros(5), psup = zeros(5)
    )
    ## 2020
    esperado2020 = sum(m.est[:, 23])
    tabla.abs[1] = Int(round(sum(m.exceso.abs[:, 1])))
    X = Normal(tabla.abs[1], m.desv[23]*√52.18) # 52 + 1/7 + 0.25/7
    tabla.inf[1] = Int(round(quantile(X, 0.025)))
    tabla.sup[1] = Int(round(quantile(X, 0.975)))
    tabla.pmid[1] = round(100 * tabla.abs[1] / esperado2020, digits = 1)
    tabla.pinf[1] = round(100 * tabla.inf[1] / esperado2020, digits = 1)
    tabla.psup[1] = round(100 * tabla.sup[1] / esperado2020, digits = 1)
    ## 2021
    esperado2021 = sum(m.est[:, 24])
    tabla.abs[2] = Int(round(sum(m.exceso.abs[:, 2])))
    X = Normal(tabla.abs[2], m.desv[24]*√52.18)
    tabla.inf[2] = Int(round(quantile(X, 0.025)))
    tabla.sup[2] = Int(round(quantile(X, 0.975)))
    tabla.pmid[2] = round(100 * tabla.abs[2] / esperado2021, digits = 1)
    tabla.pinf[2] = round(100 * tabla.inf[2] / esperado2021, digits = 1)
    tabla.psup[2] = round(100 * tabla.sup[2] / esperado2021, digits = 1)
    ## 2022 (incomplete info, just up to week 49)  ************************************
    esperado2022 = sum(m.est[:, 25])
    tabla.abs[3] = Int(round(sum(m.exceso.abs[1:49, 3])))
    X = Normal(tabla.abs[3], m.desv[25]*√52.18)
    tabla.inf[3] = Int(round(quantile(X, 0.025)))
    tabla.sup[3] = Int(round(quantile(X, 0.975)))
    tabla.pmid[3] = round(100 * tabla.abs[3] / esperado2022, digits = 1)
    tabla.pinf[3] = round(100 * tabla.inf[3] / esperado2022, digits = 1)
    tabla.psup[3] = round(100 * tabla.sup[3] / esperado2022, digits = 1)
    ## 2020-2022 (just up to week 49 of 2022)  ***************************************
    esperado202122 = sum(m.est[:, 23:25])
    tabla.abs[4] = tabla.abs[1] + tabla.abs[2] + tabla.abs[3]
    σtrianual = √(52.18*sum(m.desv[23:25] .^ 2))
    X = Normal(tabla.abs[4], σtrianual)
    tabla.inf[4] = Int(round(quantile(X, 0.025)))
    tabla.sup[4] = Int(round(quantile(X, 0.975)))
    tabla.pmid[4] = round(100 * tabla.abs[4] / esperado202122, digits = 1)
    tabla.pinf[4] = round(100 * tabla.inf[4] / esperado202122, digits = 1)
    tabla.psup[4] = round(100 * tabla.sup[4] / esperado202122, digits = 1)
    ## 2020-2021
    esperado20202021 = sum(m.est[:, 23:24])
    tabla.abs[5] = tabla.abs[1] + tabla.abs[2]
    σbianual = √(52.18*sum(m.desv[23:24] .^ 2))
    X = Normal(tabla.abs[5], σbianual)
    tabla.inf[5] = Int(round(quantile(X, 0.025)))
    tabla.sup[5] = Int(round(quantile(X, 0.975)))
    tabla.pmid[5] = round(100 * tabla.abs[5] / esperado20202021, digits = 1)
    tabla.pinf[5] = round(100 * tabla.inf[5] / esperado20202021, digits = 1)
    tabla.psup[5] = round(100 * tabla.sup[5] / esperado20202021, digits = 1)
    println(nombremodelo)
    return tabla
end
