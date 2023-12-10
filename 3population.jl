### Extract data from INEGI population census 2020
### and CONAPO population projections


println("*** Processing INEGI 2020 census data...")

using CSV, DataFrames


## Read data and create dataframe

begin
    d = DataFrame(CSV.File("conjunto_de_datos_iter_00CSV20.csv"))
    grupo = names(d)[10:110]
    e = ["e00", "e06", "e11", "e20", "e30", "e40", "e50", "e60", "e70", "todos"]
    tabs = DataFrame(edad = e, masc = zeros(Int, 10), fem = zeros(Int, 10), ambos = zeros(Int, 10))
    tprc = DataFrame(edad = e, masc = zeros(10), fem = zeros(10), ambos = zeros(10))
    f(x) = parse(Int, x)
end;

begin
# 0-5 years old
tabs.ambos[1] = f(d.P_0A2[1]) + f(d.P_3A5[1])
tabs.masc[1] = f(d.P_0A2_M[1]) + f(d.P_3A5_M[1])
tabs.fem[1] = f(d.P_0A2_F[1]) + f(d.P_3A5_F[1])
tabs.masc[1] + tabs.fem[1]
# 20-29 
tabs.ambos[4] = f(d.P_20A24[1]) + f(d.P_25A29[1])
tabs.masc[4] = f(d.P_20A24_M[1]) + f(d.P_25A29_M[1])
tabs.fem[4] = f(d.P_20A24_F[1]) + f(d.P_25A29_F[1])
tabs.masc[4] + tabs.fem[4]
# 30-39 
tabs.ambos[5] = f(d.P_30A34[1]) + f(d.P_35A39[1])
tabs.masc[5] = f(d.P_30A34_M[1]) + f(d.P_35A39_M[1])
tabs.fem[5] = f(d.P_30A34_F[1]) + f(d.P_35A39_F[1])
tabs.masc[5] + tabs.fem[5]
# 40-49 
tabs.ambos[6] = f(d.P_40A44[1]) + f(d.P_45A49[1])
tabs.masc[6] = f(d.P_40A44_M[1]) + f(d.P_45A49_M[1])
tabs.fem[6] = f(d.P_40A44_F[1]) + f(d.P_45A49_F[1])
tabs.masc[6] + tabs.fem[6]
# 50-59 
tabs.ambos[7] = f(d.P_50A54[1]) + f(d.P_55A59[1])
tabs.masc[7] = f(d.P_50A54_M[1]) + f(d.P_55A59_M[1])
tabs.fem[7] = f(d.P_50A54_F[1]) + f(d.P_55A59_F[1])
tabs.masc[7] + tabs.fem[7]
# 60-69 
tabs.ambos[8] = f(d.P_60A64[1]) + f(d.P_65A69[1])
tabs.masc[8] = f(d.P_60A64_M[1]) + f(d.P_65A69_M[1])
tabs.fem[8] = f(d.P_60A64_F[1]) + f(d.P_65A69_F[1])
tabs.masc[8] + tabs.fem[8]
# 70+ 
tabs.ambos[9] = f(d.P_70A74[1]) + f(d.P_75A79[1]) + f(d.P_80A84[1]) + f(d.P_85YMAS[1])
tabs.masc[9] = f(d.P_70A74_M[1]) + f(d.P_75A79_M[1]) + f(d.P_80A84_M[1]) + f(d.P_85YMAS_M[1])
tabs.fem[9] = f(d.P_70A74_F[1]) + f(d.P_75A79_F[1]) + f(d.P_80A84_F[1]) + f(d.P_85YMAS_F[1])
tabs.masc[9] + tabs.fem[9]
# all ages
tabs.ambos[10] = d.POBTOT[1]
tabs.masc[10] = f(d.POBMAS[1])
tabs.fem[10] = f(d.POBFEM[1])
tabs.masc[10] + tabs.fem[10]
end;

begin
## 6-10 
P_0A5 = tabs.ambos[1]
P_5 = P_0A5 - f(d.P_0A4[1])
P_6A9 = f(d.P_5A9[1]) - P_5
P_6A10 = (P_6A9, f(d.P_6A11[1]))

P_0A5_M = tabs.masc[1]
P_5_M = P_0A5_M - f(d.P_0A4_M[1])
P_6A9_M = f(d.P_5A9_M[1]) - P_5_M
P_6A10_M = (P_6A9_M, f(d.P_6A11_M[1]))
m2inf, m2sup = P_6A10_M

P_0A5_F = tabs.fem[1]
P_5_F = P_0A5_F - f(d.P_0A4_F[1])
P_6A9_F = f(d.P_5A9_F[1]) - P_5_F
P_6A10_F = (P_6A9_F, f(d.P_6A11_F[1]))
f2inf, f2sup = P_6A10_F
end;

begin
## 11-19
P_10A11 = f(d.P_6A11[1]) - P_6A9
P_10A19 = f(d.P_10A14[1]) + f(d.P_15A19[1])
P_12A19 = P_10A19 - P_10A11
P_11A19 = (P_12A19, P_10A19)

P_10A11_M = f(d.P_6A11_M[1]) - P_6A9_M
P_10A19_M = f(d.P_10A14_M[1]) + f(d.P_15A19_M[1])
P_12A19_M = P_10A19_M - P_10A11_M
P_11A19_M = (P_12A19_M, P_10A19_M)
m3inf, m3sup = P_11A19_M

P_10A11_F = f(d.P_6A11_F[1]) - P_6A9_F
P_10A19_F = f(d.P_10A14_F[1]) + f(d.P_15A19_F[1])
P_12A19_F = P_10A19_F - P_10A11_F
P_11A19_F = (P_12A19_F, P_10A19_F)
f3inf, f3sup = P_11A19_F
end


begin
## Estimation 6-10 and 11-19 
T = [P_6A10_M P_6A10_F; P_11A19_M P_11A19_F];
println("INEGI 2020 population census")
tabs
println("Intervals for {e06, e11} × {masc, fem}")
T
# CONAPO factors:
e06e11masc = tabs.masc[10] - sum(tabs.masc[1:9])
e11masc = Int(round(0.644578 * e06e11masc))
e06masc = e06e11masc - e11masc
e06e11fem = tabs.fem[10] - sum(tabs.fem[1:9])
e11fem = Int(round(0.647301 * e06e11fem))
e06fem = e06e11fem - e11fem
tabs.masc[2] = e06masc
tabs.masc[3] = e11masc
tabs.fem[2] = e06fem
tabs.fem[3] = e11fem
tabs
sum(tabs.masc[1:9]) == tabs.masc[10]
sum(tabs.fem[1:9]) == tabs.fem[10]
tabs.ambos[2] = tabs.masc[2] + tabs.fem[2]
tabs.ambos[3] = tabs.masc[3] + tabs.fem[3]
sum(tabs.ambos[1:9]) == tabs.ambos[10]
end

CSV.write("censo2020.csv", tabs)

println("created file: censo2020.csv")




println("*** Processing CONAPO projections data...")

begin
    dini = DataFrame(CSV.File("0_Pob_Inicio_1950_2070.csv"))
    dmit = DataFrame(CSV.File("0_Pob_Mitad_1950_2070.csv"))
end

begin
    e = ["e00", "e06", "e11", "e20", "e30", "e40", "e50", "e60", "e70", "todos"];
    ee = Int[]
    append!(ee, fill(1, 6)) # edades 0-5
    append!(ee, fill(2, 5)) # edades 6-10
    append!(ee, fill(3, 9)) # edades 11-19
    for k ∈ 4:8 # edades 10(k-2) a 10(k-2)+9
        append!(ee, fill(k, 10))
    end
    append!(ee, fill(9, length(70:150))) # edades 70 a 150
    d = Dict(collect(0:150) .=> ee)
end;

begin
    p2020abs = DataFrame(edad = e, hom = zeros(Int, 10), muj = zeros(Int, 10), ambos = zeros(Int, 10))
    p2020abs1 = DataFrame(edad = e, hom = zeros(Int, 10), muj = zeros(Int, 10), ambos = zeros(Int, 10))
    p2020abs2 = DataFrame(edad = e, hom = zeros(Int, 10), muj = zeros(Int, 10), ambos = zeros(Int, 10))
    p2020prc = DataFrame(edad = e, hom = zeros(10), muj = zeros(10), ambos = zeros(10))
    p2020prc1 = DataFrame(edad = e, hom = zeros(10), muj = zeros(10), ambos = zeros(10))
    p2020prc2 = DataFrame(edad = e, hom = zeros(10), muj = zeros(10), ambos = zeros(10))
    p2021abs = DataFrame(edad = e, hom = zeros(Int, 10), muj = zeros(Int, 10), ambos = zeros(Int, 10))
    p2021prc = DataFrame(edad = e, hom = zeros(10), muj = zeros(10), ambos = zeros(10))
    p2022abs = DataFrame(edad = e, hom = zeros(Int, 10), muj = zeros(Int, 10), ambos = zeros(Int, 10))
    p2022prc = DataFrame(edad = e, hom = zeros(10), muj = zeros(10), ambos = zeros(10))
    p2023abs = DataFrame(edad = e, hom = zeros(Int, 10), muj = zeros(Int, 10), ambos = zeros(Int, 10))
    p2023prc = DataFrame(edad = e, hom = zeros(10), muj = zeros(10), ambos = zeros(10))
end;

begin
    i2020hom = findall(dini.AÑO .== 2020) ∩ findall(dini.CVE_GEO .== 0) ∩ findall(dini.SEXO .== "Hombres")
    i2020muj = findall(dini.AÑO .== 2020) ∩ findall(dini.CVE_GEO .== 0) ∩ findall(dini.SEXO .== "Mujeres")
    i2020hom2 = findall(dmit.AÑO .== 2020) ∩ findall(dmit.CVE_GEO .== 0) ∩ findall(dmit.SEXO .== "Hombres")
    i2020muj2 = findall(dmit.AÑO .== 2020) ∩ findall(dmit.CVE_GEO .== 0) ∩ findall(dmit.SEXO .== "Mujeres")
    i2021hom = findall(dini.AÑO .== 2021) ∩ findall(dini.CVE_GEO .== 0) ∩ findall(dini.SEXO .== "Hombres")
    i2021muj = findall(dini.AÑO .== 2021) ∩ findall(dini.CVE_GEO .== 0) ∩ findall(dini.SEXO .== "Mujeres")
    i2022hom = findall(dini.AÑO .== 2022) ∩ findall(dini.CVE_GEO .== 0) ∩ findall(dini.SEXO .== "Hombres")
    i2022muj = findall(dini.AÑO .== 2022) ∩ findall(dini.CVE_GEO .== 0) ∩ findall(dini.SEXO .== "Mujeres")
    i2023hom = findall(dini.AÑO .== 2023) ∩ findall(dini.CVE_GEO .== 0) ∩ findall(dini.SEXO .== "Hombres")
    i2023muj = findall(dini.AÑO .== 2023) ∩ findall(dini.CVE_GEO .== 0) ∩ findall(dini.SEXO .== "Mujeres")
end;


## 2020

begin # beginning of the year
    dh = dini[i2020hom, :]
    for i ∈ 1:nrow(dh)
        p2020abs[d[dh.EDAD[i]], 2] += dh.POBLACION[i]
    end
    dm = dini[i2020muj, :]
    for i ∈ 1:nrow(dm)
        p2020abs[d[dm.EDAD[i]], 3] += dm.POBLACION[i]
    end
    p2020abs[10, 2] = sum(p2020abs.hom[1:9])
    p2020abs[10, 3] = sum(p2020abs.muj[1:9])
    for i ∈ 1:10
        p2020abs[i, 4] = p2020abs[i, 2] + p2020abs[i, 3]
    end
    for i ∈ 1:10
        for j ∈ 2:4
            p2020prc[i, j] = p2020abs[i, j] / p2020abs[10, 4]
        end
    end
end

begin # middle of the year
    dh = dmit[i2020hom2, :]
    for i ∈ 1:nrow(dh)
        p2020abs2[d[dh.EDAD[i]], 2] += dh.POBLACION[i]
    end
    dm = dmit[i2020muj2, :]
    for i ∈ 1:nrow(dm)
        p2020abs2[d[dm.EDAD[i]], 3] += dm.POBLACION[i]
    end
    p2020abs2[10, 2] = sum(p2020abs2.hom[1:9])
    p2020abs2[10, 3] = sum(p2020abs2.muj[1:9])
    for i ∈ 1:10
        p2020abs2[i, 4] = p2020abs2[i, 2] + p2020abs2[i, 3]
    end
    for i ∈ 1:10
        for j ∈ 2:4
            p2020prc2[i, j] = p2020abs2[i, j] / p2020abs2[10, 4]
        end
    end
end

begin # First quarter of the year (date of INEGI 2020 census)
    for i ∈ 1:9
        for j ∈ 2:3
            p2020abs1[i, j] = Int(round((p2020abs[i, j] + p2020abs2[i, j]) / 2))
        end
    end
    p2020abs1[10, 2] = sum(p2020abs1.hom[1:9])
    p2020abs1[10, 3] = sum(p2020abs1.muj[1:9])
    for i ∈ 1:10
        p2020abs1[i, 4] = p2020abs1[i, 2] + p2020abs1[i, 3]
    end
    for i ∈ 1:10
        for j ∈ 2:4
            p2020prc1[i, j] = p2020abs1[i, j] / p2020abs1[10, 4]
        end
    end
end

begin # weights to complete INEGI census 2020: {e06, e11} × {Hom, Muj}
    Hom = sum(p2020abs1.hom[2:3])
    e06Hom = p2020abs1.hom[2] / Hom
    e11Hom = p2020abs1.hom[3] / Hom
    Muj = sum(p2020abs1.muj[2:3])
    e06Muj = p2020abs1.muj[2] / Muj
    e11Muj = p2020abs1.muj[3] / Muj
    [e06Hom e06Muj; e11Hom e11Muj]
end


## 2021 

begin # beginning of the year
    dh = dini[i2021hom, :]
    for i ∈ 1:nrow(dh)
        p2021abs[d[dh.EDAD[i]], 2] += dh.POBLACION[i]
    end
    dm = dini[i2021muj, :]
    for i ∈ 1:nrow(dm)
        p2021abs[d[dm.EDAD[i]], 3] += dm.POBLACION[i]
    end
    p2021abs[10, 2] = sum(p2021abs.hom[1:9])
    p2021abs[10, 3] = sum(p2021abs.muj[1:9])
    for i ∈ 1:10
        p2021abs[i, 4] = p2021abs[i, 2] + p2021abs[i, 3]
    end
    for i ∈ 1:10
        for j ∈ 2:4
            p2021prc[i, j] = p2021abs[i, j] / p2021abs[10, 4]
        end
    end
end


## 2022

begin # beginning of the year
    dh = dini[i2022hom, :]
    for i ∈ 1:nrow(dh)
        p2022abs[d[dh.EDAD[i]], 2] += dh.POBLACION[i]
    end
    dm = dini[i2022muj, :]
    for i ∈ 1:nrow(dm)
        p2022abs[d[dm.EDAD[i]], 3] += dm.POBLACION[i]
    end
    p2022abs[10, 2] = sum(p2022abs.hom[1:9])
    p2022abs[10, 3] = sum(p2022abs.muj[1:9])
    for i ∈ 1:10
        p2022abs[i, 4] = p2022abs[i, 2] + p2022abs[i, 3]
    end
    for i ∈ 1:10
        for j ∈ 2:4
            p2022prc[i, j] = p2022abs[i, j] / p2022abs[10, 4]
        end
    end
end


## 2023

begin # beginning of the year
    dh = dini[i2023hom, :]
    for i ∈ 1:nrow(dh)
        p2023abs[d[dh.EDAD[i]], 2] += dh.POBLACION[i]
    end
    dm = dini[i2023muj, :]
    for i ∈ 1:nrow(dm)
        p2023abs[d[dm.EDAD[i]], 3] += dm.POBLACION[i]
    end
    p2023abs[10, 2] = sum(p2023abs.hom[1:9])
    p2023abs[10, 3] = sum(p2023abs.muj[1:9])
    for i ∈ 1:10
        p2023abs[i, 4] = p2023abs[i, 2] + p2023abs[i, 3]
    end
    for i ∈ 1:10
        for j ∈ 2:4
            p2023prc[i, j] = p2023abs[i, j] / p2023abs[10, 4]
        end
    end
end

## Generate files

begin
    CSV.write("conapo2020.csv", p2020abs)
    println("created file: conapo2020.csv")
    CSV.write("conapo2020trim1.csv", p2020abs1)
    println("created file: conapo2020trim1.csv")
    CSV.write("conapo2021.csv", p2021abs)
    println("created file: conapo2021.csv")
    CSV.write("conapo2022.csv", p2022abs)
    println("created file: conapo2022.csv")
    CSV.write("conapo2023.csv", p2023abs)
    println("created file: conapo2023.csv")
end

println("*** Population data processing finished.")
