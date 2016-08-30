Risk Sharing Network Project
============================

A project to analyze risk sharing netwroks in the Nyakatoke Village.


Structure of the project
-------------------------

This project uses both the R software and Mathematica.  There is a file called risk_sharing.Rproj
in the top level folder which can be opened using RStudio.  The R files can be used without using
RStudio.  Please set the the R working directory to the top level folder (risk_sharing) for ease
of use.

Several R packages are required.  They are listed below and should be installed.

The project is structured as follows:

	risk_sharing
	|---src
	|------create_graphs.R
	|------main.nb
	|------Tanzania.do
	|---data
	|------tanzania_data.csv
	|---output


Required Packages
-----------------

1. futile.logger
2. igraph
3. dplyr

Exploratory data analysis
--------------------------

1. Download the entire project as a zip file (or clone using Git or Github)

2. To get some preliminary exploration of the Tanzania data.

    If you are using Rstudio:
    
    1. Open the project risk_sharing.Rproj (using File -> Open Project)
    
    2. Open the file `src/tanzania_exploration.R` in the Rstudio Editor (File -> Open File)
    
    3. Source the file
        
    If you are using the command prompt:
    
    1. cd into the project directory 
        
    2. Run the file `src/tanzania_exploration.R`
     
    ```
    cd risk_sharing
    Rscript src/tanzania_exploration.R
    ```
