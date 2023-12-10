### Generate figures 


## Load data and auxiliary functions

begin    
    include("auxfunctions.jl")
    println("*** Extracting data and estimating models...")
    leer_dfs(collect(1998:2022))
end



## Extract data

# non-illness deaths
begin
    datos(4, 1) # all ages both genders
    modelo(4, 1)
end;

# illness-realted deaths
begin  
    for i ∈ 1:3 # both, males, females
        for j ∈ 1:10 # age group
            datos(i, j)
            modelo(i, j)
        end
    end
end;



## Figures

println("*** Generating figures...")
#=
    Figure 1: % of non-illnes deaths & observed illness-related deaths 1998-2019
=#
let 
    enf = sum.(eachcol(Enftodos))
    noenf = sum.(eachcol(NoEnftodos))
    tot = enf + noenf
    prc = @. 100 * noenf / tot
    a, b = reglin(collect(1998:2019), prc[1:22])
    años = collect(1998:2022)
    plot(años, prc, lw = 4, label = "pre-pandemic", color = :red, yticks = 0:13)
    plot!(legend = (0.4, 0.5))
    plot!(años, a .+ b.*años, color = :gray, label = "pre-pandemic linear trend")
    plot!(2019:2022, prc[22:25], lw = 4, color = :orange, label = "covid-19 pandemic")
    title!("% of non-illness deaths (1998-2022)")
    hline!([0.0], lw = 0.1, color = :gray, label = "")
    p1 = current()
    #####
    sem =  1:52
    enf = Enftodos_modelo.obs[1:52, :]
    c(año) = año - 1997
    plot(sem, enf[:, c(2019)], label = "2016-2019", lw = 2, color = :blue, legend = :top)
    title!("illness deaths in Mexico")
    xaxis!("Week"); yaxis!("Death count")
    for año ∈ 2016:2018
        plot!(sem, enf[:, c(año)], label = "", lw = 2, color = :blue)
    end
    plot!(sem, enf[:, c(2015)], label = "2008-2015", lw = 1, color = :gray)
    for año ∈ 2008:2014
        plot!(sem, enf[:, c(año)], label = "", lw = 1, color = :gray)
    end
    plot!(sem, enf[:, c(2007)], label = "1998-2007", lw = 1, color = :pink)
    for año ∈ 1998:2006
        plot!(sem, enf[:, c(año)], label = "", lw = 1, color = :pink)
    end
    p2 = current()
    ######
    plot(p1, p2, layout = (2, 1), legend = false, size = (500, 600))
    a = "Figure1.png"
    savefig(a)
    println(a)
end


#=
    Figure 2: illness-related excess mortality 2020 | 2021 | 2022
=#
let 
    plot_año_bis(2020, 1, 1, th = true, yax = false)
    exceso2020 = Int(round(sum(Enftodos_modelo.exceso.abs[:, 1])))
    miles = exceso2020 ÷ 1_000
    unidades = exceso2020 - miles*1_000
    if unidades < 10
        unidades = "00" * string(unidades)
    elseif unidades < 100
        unidades = "0" * string(unidades)
    end
    exceso2020prc = round(100 * exceso2020 / sum(Enftodos_modelo.est[:, 23]), digits = 1)
    annotate!([(20, 28, ("Total excess = $miles,$unidades deaths ($exceso2020prc%)", 8, :left))])
    p1 = current()
    #####
    plot_año_bis(2021, 1, 1, th = true, yax = true)
    exceso2021 = Int(round(sum(Enftodos_modelo.exceso.abs[:, 2]))) 
    miles = exceso2021 ÷ 1_000
    unidades = exceso2021 - miles*1_000
    if unidades < 10
        unidades = "00" * string(unidades)
    elseif unidades < 100
        unidades = "0" * string(unidades)
    end
    exceso2021prc = round(100 * exceso2021 / sum(Enftodos_modelo.est[:, 24]), digits = 1)
    annotate!([(20, 36, ("Total excess = $miles,$unidades deaths ($exceso2021prc%)", 8, :left))])
    p2 = current()
    #####
    plot_año_bis(2022, 1, 1, th = true, yax = false)
    exceso2022 = Int(round(sum(Enftodos_modelo.exceso.abs[1:49, 3]))) # incomplete info !!!!!
    miles = exceso2022 ÷ 1_000
    unidades = exceso2022 - miles*1_000
    if unidades < 10
        unidades = "00" * string(unidades)
    elseif unidades < 100
        unidades = "0" * string(unidades)
    end
    exceso2022prc = round(100 * exceso2022 / sum(Enftodos_modelo.est[:, 25]), digits = 1)
    annotate!([(20, 22, ("Total excess = $miles,$unidades deaths ($exceso2022prc%)", 8, :left))])
    p3 = current()
    #####
    plot(p1, p2, p3, layout = (3,1), legend = false, size = (500,600))
    a = "Figure2.png"
    savefig(a)
    println(a)
end


#=
    Figure 3: % illness excess of mortality 2020-2022 males vs females
=#
let 
    h = EnfHomtodos_modelo 
    m = EnfMujtodos_modelo
    excesoHom = round(100 * (sum(h.exceso.abs[:, 1:2]) + sum(h.exceso.abs[1:49, 3])) / sum(h.est[:, 23:25]), digits = 1)
    excesoMuj = round(100 * (sum(m.exceso.abs[:, 1:2]) + sum(m.exceso.abs[1:49, 3])) / sum(m.est[:, 23:25]), digits = 1)
    sem = collect(1:156)
    ehom = reshape(h.exceso.prc[1:52, :], 156, 1)
    emuj = reshape(m.exceso.prc[1:52, :], 156, 1)
    plot(sem, ehom, lw = 3, color = :cyan3, label = "males $excesoHom%")
    title!("illness excess mortality 2020-2022")
    xaxis!("Week"); yaxis!("Excess in %")
    plot!(sem, emuj, lw = 3, color = :violet, label = "females $excesoMuj%")
    a = "Figure3.png"
    savefig(a)
    println(a)
end


#=
    Figure 4: illness.related xxcess mortality 2020-2022 by sex and age groups
=#
begin 
    e = ["0-5", "6-10", "11-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70+", "all"]
    tabla20abs = DataFrame(age = e, males = zeros(Int, 10), females = zeros(Int, 10), both = zeros(Int, 10))
    tabla21abs = DataFrame(age = e, males = zeros(Int, 10), females = zeros(Int, 10), both = zeros(Int, 10))
    tabla22abs = DataFrame(age = e, males = zeros(Int, 10), females = zeros(Int, 10), both = zeros(Int, 10))
    tabla202122abs = DataFrame(age = e, males = zeros(Int, 10), females = zeros(Int, 10), both = zeros(Int, 10))
    tabla2021abs = DataFrame(age = e, males = zeros(Int, 10), females = zeros(Int, 10), both = zeros(Int, 10))
    tabla20prc = DataFrame(age = e, males = zeros(10), females = zeros(10), both = zeros(10))
    tabla21prc = DataFrame(age = e, males = zeros(10), females = zeros(10), both = zeros(10))
    tabla22prc = DataFrame(age = e, males = zeros(10), females = zeros(10), both = zeros(10))
    tabla202122prc = DataFrame(age = e, males = zeros(10), females = zeros(10), both = zeros(10))
    tabla2021prc = DataFrame(age = e, males = zeros(10), females = zeros(10), both = zeros(10))
    dg = Dict([1,2,3] .=> [4,2,3])
    de = Dict(collect(1:10) .=> pushfirst!(collect(1:9), 10))
    for j ∈ 1:3 # sex (both, male, female)
        for i ∈ 1:10 # age group (all, 0-5, ..., 70+)
            df = exceso_total(j, i)
            tabla20abs[de[i], dg[j]] = df[1, 2] # absolute excess 2020
            tabla21abs[de[i], dg[j]] = df[2, 2] # absolute excess 2021
            tabla22abs[de[i], dg[j]] = df[3, 2] # absolute excess 2022 **
            tabla202122abs[de[i], dg[j]] = df[4, 2] # absolute excess 2020-2022 **
            tabla2021abs[de[i], dg[j]] = df[5, 2] # absolute excess 2020-2021
            tabla20prc[de[i], dg[j]] = df[1, 3] # % excess 2020
            tabla21prc[de[i], dg[j]] = df[2, 3] # % excess 2021
            tabla22prc[de[i], dg[j]] = df[3, 3] # % excess 2022 **
            tabla202122prc[de[i], dg[j]] = df[4, 3] # % excess 2020-2022 **
            tabla2021prc[de[i], dg[j]] = df[5, 3] # % excess 2020-2021
        end
    end
    tabla = (abs20 = tabla20abs, abs21 = tabla21abs, abs22 = tabla22abs, 
             abs202122 = tabla202122abs, abs2021 = tabla2021abs, prc20 = tabla20prc, 
             prc21 = tabla21prc, prc22 = tabla22prc, prc202122 = tabla202122prc, prc2021 = tabla2021prc
    )
end;
let 
    matriz = hcat(tabla.abs202122[1:9, 2], tabla.abs202122[1:9, 3]) / 1_000
    groupedbar(tabla.abs202122.age[1:9], matriz, bar_position = :dodge, bar_width = 0.7,
               label = ["male" "female"], color = [:cyan3 :violet], yticks = 0:20:200    
    )
    title!("Absolute excess mortality 2020-2022")
    xaxis!("Age group"); yaxis!("Death count (thousands)")
    p1 = current()
    #####
    matriz = hcat(tabla.prc202122[1:9, 2], tabla.prc202122[1:9, 3], tabla.prc202122[1:9, 4])
    groupedbar(tabla.prc202122.age[1:9], matriz, bar_position = :dodge, bar_width = 0.7,
               label = ["male" "female" "both"], color = [:cyan3 :violet :gray], yticks = -20:10:100    
    )
    title!("% excess mortality 2020-2022")
    xaxis!("Age group"); yaxis!("Excess in %")
    p2 = current()
    #####
    plot(p1, p2, layout = (2,1), legend = false, size = (500,600))
    a = "Figure4.png"
    savefig(a)
    println(a)
end

println("*** Finished creating figures.")
