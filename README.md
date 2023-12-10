# A polynomial regression model for excess mortality in Mexico 2020-2022 due to the COVID-19 pandemic

> Authors: Andreu Comas-García & Arturo Erdely

> Preprint: arXiv 

### Instructions for reproducibility

1. Download and install the [Julia](https://julialang.org/downloads/) programming language.
2. Download and unzip the data from the following Google Drive [link](https://drive.google.com/file/d/19_1QOiKbkGlcN2Chr-xbh2pMxVxyKgwu/view?usp=drive_link) in a working directory of your election.
3. Open the `Julia` terminal and change to the working directory where you unzipped the files. You may do this by defining a string variable `path` with the path to the files directory and then execute in the terminal `cd(path)`. For example, in the operating system *Windows* it may look something like:
   ```julia
   path = "D:/MyFiles/rawdata2022mx"
   cd(path)
   readdir()
   ```
4. Download the code files clicking in the green button `<> Code` of this GitHub repository and `DownloadZIP`. Unzip the downloaded file and move the following files into the same working directory as the downloaded data in the previous step: `0auxfunctions.jl`, `1packages.jl`, `2deaths.jl`, `3population.jl`, `4figures.jl`, `5tables.jl`, and `6other.jl`
5. Install the required packages by executing the following command in the `Julia` terminal. This may take a while:
   ```julia
   include("1packages.jl")
   ```
6. Process deaths data. This will take several hours (4 approx) and will generate several new `.csv` data files:
   ```julia
   include("2deaths.jl")
   ```
7. Process population data. This is quite fast and will generate several new `.csv` data files:
   ```julia
   include("3population.jl")
   ```
8. Create 4 figures as `.png` image files:
   ```julia
   include("4figures.jl")
   ```
   - `Figure1.png`: % of non-illnes deaths & observed illness-related deaths 1998-2019
   - `Figure2.png`: illness-related excess mortality 2020 | 2021 | 2022
   - `Figure3.png`: % illness-related excess of mortality 2020-2022 males vs females
   - `Figure4.png`: illness-related excess mortality 2020-2022 by sex and age groups
9. Create 6 tables in `.csv` file format: 
   ```julia
   include("5tables.jl")
   ```
   - `Table1.csv`: Excess mortality in Mexico 2020
   - `Table2.csv`: Excess mortality in Mexico 2021
   - `Table3.csv`: Excess mortality in Mexico 2022
   - `Table4.csv`: Excess mortality in Mexico 2020-2022
   - `Table5.csv`: Excess mortality in Mexico 2020-2022 (males)
   - `Table6.csv`: Excess mortality in Mexico 2020-2022 (females)
10. Generate supplementary figures and calculations:
    ```julia
    include("6other.jl")
    ```
    - `FigureExtra1.png`: illness-related deaths evolution of fitted parameters
    - `FigureExtra2.png`: adjusted R-squared and Anderson-Darling test for normality of residuals
    - `FigureExtra3.png`: some examples of the fitted model
