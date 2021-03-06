# name          : utils.R
# description   : Utility file (to load libraries etc)
# maintainer    : Arnob L. Alam <aa2288a@student.american.edu>
# updated       : 2016-05-11
#
# Utility file to load required libraries, helpful functions, etc.

message("Processing util files")

# Load the logging library
library(futile.logger)
flog.info("Loading required libraries")
library(igraph)
library(dplyr)

`%+%` <- function(a, b) paste0(a, b)

sim_size <- 100E3
flog.info("Simulation Size is " %+% sim_size)
