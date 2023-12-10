# A polynomial regression model for excess mortality in Mexico 2020-2022 due to the COVID-19 pandemic

> Authors: Andreu Comas-García, Arturo Erdely

> Preprint: arXiv 

### Instructions for reproducibility

1. Download and install the [Julia](https://julialang.org/downloads/) programming language.
2. Download and unzip the data from the following Google Drive [link](https://drive.google.com/file/d/19_1QOiKbkGlcN2Chr-xbh2pMxVxyKgwu/view?usp=drive_link) in a working directory of your election.
3. Open the `Julia` terminal and change to the working directory where you unzipped the files. You may do this defining a string variable `path` with the path to the files directory and then execute in the terminal `cd(path)`. For example, in Windows it may look somthing like:
   ```julia
   path = "D:/MyFiles/rawdata2022mx"
   cd(path)
   ```
4. Download the code files and put them into the same working directory. All the files (data and code must be in the same folder).  
5. Install required packages by executing in the terminal: `include("")`
