### Generate tables (inmediately after executing 4figures.jl)

println("*** Generating tables...")


## Excess mortality dataframes 

# Absolute and % excess mortality
begin 
    e = ["0-5", "6-10", "11-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70+", "all"]
    tabla20abs = DataFrame(age = e, malesinf = zeros(Int, 10), malesabs = zeros(Int, 10), malessup = zeros(Int, 10),
                           femalesinf = zeros(Int, 10), femalesabs = zeros(Int, 10), femalessup = zeros(Int, 10),
                           bothinf = zeros(Int, 10), bothabs = zeros(Int, 10), bothsup = zeros(Int, 10)
    )
    tabla21abs = DataFrame(age = e, malesinf = zeros(Int, 10), malesabs = zeros(Int, 10), malessup = zeros(Int, 10),
                           femalesinf = zeros(Int, 10), femalesabs = zeros(Int, 10), femalessup = zeros(Int, 10),
                           bothinf = zeros(Int, 10), bothabs = zeros(Int, 10), bothsup = zeros(Int, 10)
    )
    tabla22abs = DataFrame(age = e, malesinf = zeros(Int, 10), malesabs = zeros(Int, 10), malessup = zeros(Int, 10),
                           femalesinf = zeros(Int, 10), femalesabs = zeros(Int, 10), femalessup = zeros(Int, 10),
                           bothinf = zeros(Int, 10), bothabs = zeros(Int, 10), bothsup = zeros(Int, 10)
    )
    tabla202122abs = DataFrame(age = e, malesinf = zeros(Int, 10), malesabs = zeros(Int, 10), malessup = zeros(Int, 10),
                               femalesinf = zeros(Int, 10), femalesabs = zeros(Int, 10), femalessup = zeros(Int, 10),
                               bothinf = zeros(Int, 10), bothabs = zeros(Int, 10), bothsup = zeros(Int, 10)
    )
    tabla20202021abs = DataFrame(age = e, malesinf = zeros(Int, 10), malesabs = zeros(Int, 10), malessup = zeros(Int, 10),
                                 femalesinf = zeros(Int, 10), femalesabs = zeros(Int, 10), femalessup = zeros(Int, 10),
                                 bothinf = zeros(Int, 10), bothabs = zeros(Int, 10), bothsup = zeros(Int, 10)
    )
    tabla20prc = DataFrame(age = e, malesinf = zeros(10), malesabs = zeros(10), malessup = zeros(10),
                           femalesinf = zeros(10), femalesabs = zeros(10), femalessup = zeros(10),
                           bothinf = zeros(10), bothabs = zeros(10), bothsup = zeros(10)
    )
    tabla21prc = DataFrame(age = e, malesinf = zeros(10), malesabs = zeros(10), malessup = zeros(10),
                           femalesinf = zeros(10), femalesabs = zeros(10), femalessup = zeros(10),
                           bothinf = zeros(10), bothabs = zeros(10), bothsup = zeros(10)
    )
    tabla22prc = DataFrame(age = e, malesinf = zeros(10), malesabs = zeros(10), malessup = zeros(10),
                           femalesinf = zeros(10), femalesabs = zeros(10), femalessup = zeros(10),
                           bothinf = zeros(10), bothabs = zeros(10), bothsup = zeros(10)
    )
    tabla202122prc = DataFrame(age = e, malesinf = zeros(10), malesabs = zeros(10), malessup = zeros(10),
                               femalesinf = zeros(10), femalesabs = zeros(10), femalessup = zeros(10),
                               bothinf = zeros(10), bothabs = zeros(10), bothsup = zeros(10)
    )
    tabla20202021prc = DataFrame(age = e, malesinf = zeros(10), malesabs = zeros(10), malessup = zeros(10),
                                 femalesinf = zeros(10), femalesabs = zeros(10), femalessup = zeros(10),
                                 bothinf = zeros(10), bothabs = zeros(10), bothsup = zeros(10)
    )
    dg = Dict([1,2,3] .=> [8,2,5])
    de = Dict(collect(1:10) .=> pushfirst!(collect(1:9), 10))
    for j ∈ 1:3 # sex (both, male, female)
        for i ∈ 1:10 # age group (all, 0-5, ..., 70+)
            df = exceso_total_intervalo(j, i)
            #
            tabla20abs[de[i], dg[j]] = df[1, 2] # lower estimate absolute excess 2020
            tabla20abs[de[i], dg[j]+1] = df[1, 3] # point estimate absolute excess 2020
            tabla20abs[de[i], dg[j]+2] = df[1, 4] # upper estimate absolute excess 2020
            tabla21abs[de[i], dg[j]] = df[2, 2] # lower estimate absolute excess 2021
            tabla21abs[de[i], dg[j]+1] = df[2, 3] # point estimate absolute excess 2021
            tabla21abs[de[i], dg[j]+2] = df[2, 4] # upper estimate absolute excess 2021
            tabla22abs[de[i], dg[j]] = df[3, 2] # lower estimate absolute excess 2022 **
            tabla22abs[de[i], dg[j]+1] = df[3, 3] # point estimate absolute excess 2022 **
            tabla22abs[de[i], dg[j]+2] = df[3, 4] # upper estimate absolute excess 2022 **
            tabla202122abs[de[i], dg[j]] = df[4, 2] # lower estimate absolute excess 2020-2022 **
            tabla202122abs[de[i], dg[j]+1] = df[4, 3] # point estimate absolute excess 2020-2022 **
            tabla202122abs[de[i], dg[j]+2] = df[4, 4] # upper estimate absolute excess 2020-2022 **
            tabla20202021abs[de[i], dg[j]] = df[5, 2] # lower estimate absolute excess 2020-2021
            tabla20202021abs[de[i], dg[j]+1] = df[5, 3] # point estimate absolute excess 2020-2021
            tabla20202021abs[de[i], dg[j]+2] = df[5, 4] # upper estimate absolute excess 2020-2021
            #
            tabla20prc[de[i], dg[j]] = df[1, 5] # lower estimate % excess 2020
            tabla20prc[de[i], dg[j]+1] = df[1, 6] # point estimate % excess 2020
            tabla20prc[de[i], dg[j]+2] = df[1, 7] # upper estimate % excess 2020
            tabla21prc[de[i], dg[j]] = df[2, 5] # lower estimate % excess 2021
            tabla21prc[de[i], dg[j]+1] = df[2, 6] # point estimate % excess 2021
            tabla21prc[de[i], dg[j]+2] = df[2, 7] # upper estimate % excess 2021
            tabla22prc[de[i], dg[j]] = df[3, 5] # lower estimate % excess 2022 **
            tabla22prc[de[i], dg[j]+1] = df[3, 6] # point estimate % excess 2022 **
            tabla22prc[de[i], dg[j]+2] = df[3, 7] # upper estimate % excess 2022 **
            tabla202122prc[de[i], dg[j]] = df[4, 5] # lower estimate % excess 2020-2022 **
            tabla202122prc[de[i], dg[j]+1] = df[4, 6] # point estimate % excess 2020-2022 **
            tabla202122prc[de[i], dg[j]+2] = df[4, 7] # upper estimate % excess 2020-2022 **
            tabla20202021prc[de[i], dg[j]] = df[5, 5] # lower estimate % excess 2020-2021
            tabla20202021prc[de[i], dg[j]+1] = df[5, 6] # point estimate % excess 2020-2021
            tabla20202021prc[de[i], dg[j]+2] = df[5, 7] # upper estimate % excess 2020-2021
        end
    end
    tabla = (abs20 = tabla20abs, abs21 = tabla21abs, abs22 = tabla22abs, abs202122 = tabla202122abs, abs20202021 = tabla20202021abs,
             prc20 = tabla20prc, prc21 = tabla21prc, prc22 = tabla22prc, prc202122 = tabla202122prc, prc20202021 = tabla20202021prc
    )
end;


# Extracting population data 
begin
    censo = DataFrame(CSV.File("censo2020.csv"))
    select!(censo, :edad => :age, :masc => :males, :fem => :females, :ambos => :both)
    conapo20 = DataFrame(CSV.File("conapo2020.csv"))
    select!(conapo20, :edad => :age, :hom => :males, :muj => :females, :ambos => :both)
    conapo20T1 = DataFrame(CSV.File("conapo2020trim1.csv"))
    select!(conapo20T1, :edad => :age, :hom => :males, :muj => :females, :ambos => :both)
    conapo21 = DataFrame(CSV.File("conapo2021.csv"))
    select!(conapo21, :edad => :age, :hom => :males, :muj => :females, :ambos => :both)
    conapo22 = DataFrame(CSV.File("conapo2022.csv"))
    select!(conapo22, :edad => :age, :hom => :males, :muj => :females, :ambos => :both)
    conapo23 = DataFrame(CSV.File("conapo2023.csv"))
    select!(conapo23, :edad => :age, :hom => :males, :muj => :females, :ambos => :both)
    # exceso20 = DataFrame(CSV.File("tabla_2020_conteo_intervalo.csv"))
    exceso20 = tabla.abs20
    # exceso21 = DataFrame(CSV.File("tabla_2021_conteo_intervalo.csv"))
    exceso21 = tabla.abs21
    # exceso22 = DataFrame(CSV.File("tabla_2022_conteo_intervalo.csv"))
    exceso22 = tabla.abs22 
    # excesotot = DataFrame(CSV.File("tabla_202122_conteo_intervalo.csv"))
    excesotot = tabla.abs202122
    # exceso20202021 = DataFrame(CSV.File("tabla_2020_2021_conteo_intervalo.csv"))
    exceso20202021 = tabla.abs20202021
end;


# Population estimation at the beginning of 2020
begin
    factor20 = DataFrame(edad = conapo20.age, males = zeros(10), females = zeros(10), both = zeros(10))
    factor20[1:9, 2:3] = conapo20[1:9, 2:3] ./ conapo20T1[1:9, 2:3]
    pob20 = DataFrame(age = conapo20.age, males = zeros(Int, 10), females = zeros(Int, 10), both = zeros(Int, 10))
    pob20[1:9, 2:3] = Int.(round.(hcat(factor20.males[1:9], factor20.females[1:9]) .* hcat(censo.males[1:9], censo.females[1:9])))
    pob20.males[10] = sum(pob20.males[1:9])
    pob20.females[10] = sum(pob20.females[1:9])
    for i ∈ 1:10
        pob20.both[i] = pob20.males[i] + pob20.females[i]
    end
end


# Excess mortality rate per 100,000 inhabitants: 2020
begin
    pob20bis = DataFrame(age = conapo20.age, malesinf = zeros(Int, 10), malesabs = zeros(Int, 10), malessup = zeros(Int, 10), 
                         femalesinf = zeros(Int, 10), femalesabs = zeros(Int, 10), femalessup = zeros(Int, 10),
                         bothinf = zeros(Int, 10), bothabs = zeros(Int, 10), bothsup = zeros(Int, 10),
    )
    pob20bis.malesinf = pob20.males
    pob20bis.malesabs = pob20.males
    pob20bis.malessup = pob20.males
    pob20bis.femalesinf = pob20.females
    pob20bis.femalesabs = pob20.females
    pob20bis.femalessup = pob20.females
    pob20bis.bothinf = pob20.both
    pob20bis.bothabs = pob20.both
    pob20bis.bothsup = pob20.both
    pob20bis
    tasa20 = DataFrame(age = conapo20.age, malesinf = zeros(Int, 10), malesabs = zeros(Int, 10), malessup = zeros(Int, 10), 
                       femalesinf = zeros(Int, 10), femalesabs = zeros(Int, 10), femalessup = zeros(Int, 10),
                       bothinf = zeros(Int, 10), bothabs = zeros(Int, 10), bothsup = zeros(Int, 10),
    )
    tasa20[1:10, 2:10] = Int.(round.(100_000 .* exceso20[1:10, 2:10] ./ pob20bis[1:10, 2:10]))
end;


# Population estimation at the beginning of 2021 (CONAPO already considers excess mortality)
begin
    pob21 = DataFrame(age = conapo20.age, males = zeros(Int, 10), females = zeros(Int, 10), both = zeros(Int, 10))
    fcrec21 = DataFrame(age = conapo20.age, males = zeros(10), females = zeros(10), both = zeros(10))
    fcrec21[1:10, 2:4] = conapo21[1:10, 2:4] ./ conapo20[1:10, 2:4]
    pob21[1:9, 2:3] = Int.(round.(fcrec21[1:9, 2:3] .* pob20[1:9, 2:3]))
    pob21.males[10] = sum(pob21.males[1:9])
    pob21.females[10] = sum(pob21.females[1:9])
    for i ∈ 1:10
        pob21.both[i] = pob21.males[i] + pob21.females[i]
    end
end;


# Excess mortality rate per 100,000 inhabitants: 2021
begin
    pob21bis = DataFrame(age = conapo20.age, malesinf = zeros(Int, 10), malesabs = zeros(Int, 10), malessup = zeros(Int, 10), 
                         femalesinf = zeros(Int, 10), femalesabs = zeros(Int, 10), femalessup = zeros(Int, 10),
                         bothinf = zeros(Int, 10), bothabs = zeros(Int, 10), bothsup = zeros(Int, 10),
    )
    pob21bis.malesinf = pob21.males
    pob21bis.malesabs = pob21.males
    pob21bis.malessup = pob21.males
    pob21bis.femalesinf = pob21.females
    pob21bis.femalesabs = pob21.females
    pob21bis.femalessup = pob21.females
    pob21bis.bothinf = pob21.both
    pob21bis.bothabs = pob21.both
    pob21bis.bothsup = pob21.both
    tasa21 = DataFrame(age = conapo20.age, malesinf = zeros(Int, 10), malesabs = zeros(Int, 10), malessup = zeros(Int, 10), 
                       femalesinf = zeros(Int, 10), femalesabs = zeros(Int, 10), femalessup = zeros(Int, 10),
                       bothinf = zeros(Int, 10), bothabs = zeros(Int, 10), bothsup = zeros(Int, 10),
    )
    tasa21[1:10, 2:10] = Int.(round.(100_000 .* exceso21[1:10, 2:10] ./ pob21bis[1:10, 2:10]))
end;


# Population estimation at the beginning of 2022
begin
    pob22 = DataFrame(age = conapo20.age, males = zeros(Int, 10), females = zeros(Int, 10), both = zeros(Int, 10))
    fcrec22 = DataFrame(age = conapo20.age, males = zeros(10), females = zeros(10), both = zeros(10))
    fcrec22[1:10, 2:4] = conapo22[1:10, 2:4] ./ conapo21[1:10, 2:4]
    pob22[1:9, 2:3] = Int.(round.(fcrec22[1:9, 2:3] .* pob21[1:9, 2:3]))
    pob22.males[10] = sum(pob22.males[1:9])
    pob22.females[10] = sum(pob22.females[1:9])
    for i ∈ 1:10
        pob22.both[i] = pob22.males[i] + pob22.females[i]
    end
end;


# Excess mortality rate per 100,000 inhabitants: 2022
begin
    pob22bis = DataFrame(age = conapo20.age, malesinf = zeros(Int, 10), malesabs = zeros(Int, 10), malessup = zeros(Int, 10), 
                         femalesinf = zeros(Int, 10), femalesabs = zeros(Int, 10), femalessup = zeros(Int, 10),
                         bothinf = zeros(Int, 10), bothabs = zeros(Int, 10), bothsup = zeros(Int, 10),
    )
    pob22bis.malesinf = pob22.males
    pob22bis.malesabs = pob22.males
    pob22bis.malessup = pob22.males
    pob22bis.femalesinf = pob22.females
    pob22bis.femalesabs = pob22.females
    pob22bis.femalessup = pob22.females
    pob22bis.bothinf = pob22.both
    pob22bis.bothabs = pob22.both
    pob22bis.bothsup = pob22.both
    tasa22 = DataFrame(age = conapo20.age, malesinf = zeros(Int, 10), malesabs = zeros(Int, 10), malessup = zeros(Int, 10), 
                       femalesinf = zeros(Int, 10), femalesabs = zeros(Int, 10), femalessup = zeros(Int, 10),
                       bothinf = zeros(Int, 10), bothabs = zeros(Int, 10), bothsup = zeros(Int, 10),
    )
    tasa22[1:10, 2:10] = Int.(round.(100_000 .* exceso22[1:10, 2:10] ./ pob22bis[1:10, 2:10]))
end;


# Excess mortality rate per 100,000 inhabitants: 2020-2022
begin
    tasatot = DataFrame(age = conapo20.age, malesinf = zeros(Int, 10), malesabs = zeros(Int, 10), malessup = zeros(Int, 10), 
                        femalesinf = zeros(Int, 10), femalesabs = zeros(Int, 10), femalessup = zeros(Int, 10),
                        bothinf = zeros(Int, 10), bothabs = zeros(Int, 10), bothsup = zeros(Int, 10),
    )
    tasatot[1:10, 2:10] = Int.(round.(100_000 .* excesotot[1:10, 2:10] ./ pob20bis[1:10, 2:10]))
end;


## Tables 

#=
    Table 1: Excess mortality in Mexico 2020
=#
begin
    em20 = DataFrame(age_group = tabla.abs20.age, 
                     abs_est = tabla.abs20.bothabs,
                     abs_lower = tabla.abs20.bothinf,
                     abs_upper = tabla.abs20.bothsup,
                     prc_est = tabla.prc20.bothabs,
                     prc_lower = tabla.prc20.bothinf,
                     prc_upper = tabla.prc20.bothsup,
                     rate_est = tasa20.bothabs,
                     rate_lower = tasa20.bothinf,
                     rate_upper = tasa20.bothsup,
    )
    a = "Table1.csv"
    println(a)
    CSV.write(a, em20)
end;


#=
    Table 2: Excess mortality in Mexico 2021
=#
begin
    em21 = DataFrame(age_group = tabla.abs21.age, 
                     abs_est = tabla.abs21.bothabs,
                     abs_lower = tabla.abs21.bothinf,
                     abs_upper = tabla.abs21.bothsup,
                     prc_est = tabla.prc21.bothabs,
                     prc_lower = tabla.prc21.bothinf,
                     prc_upper = tabla.prc21.bothsup,
                     rate_est = tasa21.bothabs,
                     rate_lower = tasa21.bothinf,
                     rate_upper = tasa21.bothsup,
    )
    a = "Table2.csv"
    println(a)
    CSV.write(a, em21)
end;


#=
    Table 3: Excess mortality in Mexico 2022
=#
begin
    em22 = DataFrame(age_group = tabla.abs22.age, 
                     abs_est = tabla.abs22.bothabs,
                     abs_lower = tabla.abs22.bothinf,
                     abs_upper = tabla.abs22.bothsup,
                     prc_est = tabla.prc22.bothabs,
                     prc_lower = tabla.prc22.bothinf,
                     prc_upper = tabla.prc22.bothsup,
                     rate_est = tasa22.bothabs,
                     rate_lower = tasa22.bothinf,
                     rate_upper = tasa22.bothsup,
    )
    a = "Table3.csv"
    println(a)
    CSV.write(a, em22)
end;


#=
    Table 4: Excess mortality in Mexico 2020-2022
=#
begin
    emtot = DataFrame(age_group = tabla.abs202122.age, 
                     abs_est = tabla.abs202122.bothabs,
                     abs_lower = tabla.abs202122.bothinf,
                     abs_upper = tabla.abs202122.bothsup,
                     prc_est = tabla.prc202122.bothabs,
                     prc_lower = tabla.prc202122.bothinf,
                     prc_upper = tabla.prc202122.bothsup,
                     rate_est = tasatot.bothabs,
                     rate_lower = tasatot.bothinf,
                     rate_upper = tasatot.bothsup,
    )
    a = "Table4.csv"
    println(a)
    CSV.write(a, emtot)
end;


#=
    Table 5: Excess mortality in Mexico 2020-2022 (males)
=#
begin
    emtotM = DataFrame(age_group = tabla.abs202122.age, 
                     abs_est = tabla.abs202122.malesabs,
                     abs_lower = tabla.abs202122.malesinf,
                     abs_upper = tabla.abs202122.malessup,
                     prc_est = tabla.prc202122.malesabs,
                     prc_lower = tabla.prc202122.malesinf,
                     prc_upper = tabla.prc202122.malessup,
                     rate_est = tasatot.malesabs,
                     rate_lower = tasatot.malesinf,
                     rate_upper = tasatot.malessup,
    )
    a = "Table5.csv"
    println(a)
    CSV.write(a, emtotM)
end;


#=
    Table 6: Excess mortality in Mexico 2020-2022 (females)
=#
begin
    emtotF = DataFrame(age_group = tabla.abs202122.age, 
                     abs_est = tabla.abs202122.femalesabs,
                     abs_lower = tabla.abs202122.femalesinf,
                     abs_upper = tabla.abs202122.femalessup,
                     prc_est = tabla.prc202122.femalesabs,
                     prc_lower = tabla.prc202122.femalesinf,
                     prc_upper = tabla.prc202122.femalessup,
                     rate_est = tasatot.femalesabs,
                     rate_lower = tasatot.femalesinf,
                     rate_upper = tasatot.femalessup,
    )
    a = "Table6.csv"
    println(a)
    CSV.write(a, emtotF)
end;


println("*** Finished creating tables.")
