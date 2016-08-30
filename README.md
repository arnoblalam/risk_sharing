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
	|------utils.R
	|------create_graphs.R
	|------main.nb
	|------tanzania_underreporting.R
	|------tanzania_overreporting.R
	|------tanzania_desire_to_link.R
	|------Tanzania.do
	|---data
	|------tanzania_data.csv
	|---output

The folder `src` contains source code for the project.  The folder `data` contains the underlying data 
that the source files depend on.  This is the result of the survey of the Nyakatoke village survey.

The script `src/create_graphs.R` reads in the graph from the Nyakatoke village survey and creates
three graphs, the so-called "under_reporting", "over_reporting" and "desire-to-link" models described
in our paper.  This script needs to be run in R first.

The file `src/main.nb` reads in the graphs created by create_graphs.R (it should be opened in Mathematica).
It depends on the graphs created by `src/create_graphs.R` script, so that script should be run first.
The Mathematica notebook reports some basic statistics about the three graphs.

The scripts `src/tanzania_underreporting.R`, `src/tanzania_overreporting.R` and `src/tanzania_desire_to_link.R`
generate simulations of random graphs of the same size and order as the underreporting, overreporting and 
desire to link model (simulations of so called Erdos-Renyi and Configuration graphs) and report some basic 
stats (clustering coefficient, average path lengths, etc.) from these simulations.


Required Packages
-----------------

1. futile.logger
2. igraph
3. dplyr
