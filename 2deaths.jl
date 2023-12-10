### Process deaths raw data into clean data files

using DataFrames, CSV, Dates

function ev(x::String)
    return eval(Meta.parse(x))
end

function crear_dfs(a::Int)
    # a = year with 4 digits
    sufijo = string(a)
    prefijo = ["Enf", "EnfHom", "EnfMuj", "NoEnf", "NoEnfHom", "NoEnfMuj", "Covid", "CovidHom", "CovidMuj"]
    edad = ["todos", "e00", "e06", "e11"] ∪ "e".*string.(collect(20:10:70))
    tuplanom = "("
    for p in prefijo
        d = p * sufijo
        ev(d * " = DataFrame()")
        for e in edad
            ev(d * "." * e * " = zeros(Int, 53)") # week 53 has 1 day (or 2 if leap year)
        end
        tuplanom = tuplanom * "$d = $d,"
    end
    tuplanom = tuplanom *")"
    return ev(tuplanom) 
end

function fecha(día::Int, mes::Int, año::Int)
    d = dayofyear(Date(año, mes, día))
    if d ≤ 364
        semana = (d - 1)÷7 + 1
    else
        semana = 53 # last week of year = 1 day (or 2 if leap year)
    end
    return semana # week of year
end

function edad(e4::Int)
    # e4 = 4-digit age key
    e = digits(e4)
    if length(e) ≠ 4
        error("Age key must be 4 digits")
        return nothing
    end
    if e[4] < 4
        a = 0
    elseif e[4] == 4 
        a = 100*e[3] + 10*e[2] + e[1]
    else
        error("Unknown key")
        return nothing
    end
    # age column 
    if 0 ≤ a ≤ 5
        c = (1, 2) # 1 = total, 2 = e00
    elseif 6 ≤ a ≤ 10
        c = (1, 3) # 1 = total, 3 = e06, ... etc
    elseif 11 ≤ a ≤ 19
        c = (1, 4)
    elseif 20 ≤ a ≤ 69
        c = (1, a÷10 + 3)
    elseif a ≥ 70
        c = (1, 10) # 1 = total, 10 = e70
    else
        c = (1,) # age not specified or out of range
    end
    return c # columns in dataframe
end

function clasif(clave::AbstractString)
    # clave ≡ causa_def (cause of death)
    Enf = collect('A':'U') # deaths caused by illness
    Covid = ["U071", "U072", "U099", "U109"] # COVID-19 deaths
    NoEnf = collect('V':'Y') # non-illness deaths (accidents or violence)
    c1 = ""
    c2 = ""
    if clave[1] ∈ Enf
        c1 = "Enf"
        if clave ∈ Covid
            c2 = "Covid" 
        end
    elseif clave[1] ∈ NoEnf
        c1 = "NoEnf"
    end
    return (c1, c2)
end

function llenar_arreglos()
    años = collect(1998:2022) # <-- years to consider
    na = length(años)
    # create dataframes
    for año ∈ años
        ev("df" * string(año) * " = crear_dfs($año)")
    end
    # create 3D arrays
    arreglo = ["Enf", "EnfHom", "EnfMuj", "NoEnf", "NoEnfHom", "NoEnfMuj", "Covid", "CovidHom", "CovidMuj"]
    for arr ∈ arreglo
        ev(arr * " = zeros(Int, 53, 10, $na)")
    end
    # extract info from raw data files
    archivos = ["def1998.csv", "def1999.csv", "def2000.csv", "def2001.csv", "def2002.csv",
                "def2003.csv", "def2004.csv", "def2005.csv", "def2006.csv", "def2007.csv",
                "def2008.csv", "def2009.csv", "def2010.csv", "def2011.csv", "def2012.csv",
                "def2013.csv", "def2014.csv", "def2015.csv", "def2016.csv", "def2017.csv",
                "def2018.csv", "def2019.csv", "def2020.csv", "def2021.csv", "def2022.csv"
    ]
    for arch ∈ archivos
        df = DataFrame(CSV.File(arch))
        nr = nrow(df)
        for i ∈ 1:nr
            print("Processing file $arch row $i out of $nr\r")
            a = df.anio_ocur[i]          
            if a < años[1] || a > años[end]
                continue # do not count, continue to next iteration of `i`
            end
            m, d = df.mes_ocurr[i], df.dia_ocurr[i]
            if m < 1 || m > 12
                m = rand(1:12) # assign at random if missing or out of range
            end
            if d < 1 || d > 31
                d = rand(1:28) # assign at random if missing or out of range
            end
            try
                global x = fecha(d, m, a) # week of the year (1 to 52)
            catch
                continue # date is not valid, do not count, continue to next iteration of `i`
            end
            y = edad(df.edad[i]) # age columns (one or two)
            z = a - años[1] + 1 # year number 1,2,...
            c = clasif(df.causa_def[i]) # NoEnf, just Enf or (Enf,Covid)
            s = df.sexo[i] # 1 = male, 2 = female, 99 = missing
            for j ∈ y
                ev(c[1] * "[$x, $j, $z] += 1")
                if s == 1
                    ev(c[1] * "Hom[$x, $j, $z] += 1")
                elseif s == 2
                    ev(c[1] * "Muj[$x, $j, $z] += 1")
                end
                if c[2] ≠ ""
                    ev(c[2] * "[$x, $j, $z] += 1")
                    if s == 1
                        ev(c[2] * "Hom[$x, $j, $z] += 1")
                    elseif s == 2
                        ev(c[2] * "Muj[$x, $j, $z] += 1")
                    end
                end
            end            
        end
        println("")
    end
    println("Finished.")
    return nothing
end

function guardar_dfs()
    años = collect(1998:2022) # <-- years to consider
    grupo = ["Enf", "EnfHom", "EnfMuj", "NoEnf", "NoEnfHom", "NoEnfMuj", "Covid", "CovidHom", "CovidMuj"]
    a = string.(años)
    # save 3D arrays info into dataframes pero year:
    for g ∈ grupo
        for k ∈ 1:length(años)
            ev(g * a[k] * "[:, :] = " * g * "[:, :, $k]")
        end
    end
    # save dataframes in files
    for i ∈ 1:length(grupo)
        for año ∈ a 
            # carpeta = d * c[i]
            archivo = grupo[i] * año * ".csv"
            println(archivo)
            ev("CSV.write(\"" * archivo * "\", " * grupo[i] * año * ")")
        end
    end
    println("Dataframes saved in files.")
    return nothing
end

using Dates
println("*** This will take several hours (4 approx)")
println("Processing files: def1998.csv, def1999.csv, ..., def2022.csv")
println(now())
llenar_arreglos()
println(now())
guardar_dfs()
println("*** Death data processing finished.")
