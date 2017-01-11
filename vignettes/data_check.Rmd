# name          : data_check.R
# description   : Check the data
# maintainer    : Arnob L. Alam <aa2288a@student.american.edu>
# updated       : 2016-05-26
#
# Check the raw data (exported from Stata) and the data provided
# by the author on the paper's website to see if we can recreate summary
# statistics provided in the other paper

# nyakatoke_raw_data.csv is the export of the STATA dta file
# provided to Heath by the author.  We read it into the data frame
# called raw_data
raw_data <- read.csv("data/nyakatoke_raw_data.csv")

# tanzania_data.csv is the data provided along with the paper
# on the  Wiley (publisher's) website.  We read it into the
# data frame paper_data
paper_data <- read.csv("data/tanzania_data.csv")

# According to th STATA variable labels direct_link_1 and direct_link_2
# specify whether hh1 is linked with hh2.  These columns are referred to as
# willingness_link1 and willingness_link2 in the paper_data. Below I show that
# these two colums are the same

# Check if direct_link_hh1 is equal to willingness_link1 for all rows of data
all(raw_data$direct_link_hh1 == paper_data$willingness_link1)
# perform same check for directness_link_2 and willingness_link2
all(raw_data$direct_link_hh2 == paper_data$willingness_link2)

# Let's see if we can recreate the results of DeWeerdt (2006)
library(igraph)
# First let's work with the paper_data and use the underreporting model
g1 <- graph_from_data_frame(paper_data[paper_data$willingness_link1 == 1 |
                                paper_data$willingness_link2,], directed = FALSE)
g1 <- simplify(g1)

g1_order <- length(V(g1))
g1_size <- length(E(g1))
g1_mean_degree <- mean(degree(g1))
g1_median_degree <- median(degree(g1))
g1_min_degree <- min(degree(g1))
g1_max_degree <- max(degree(g1))
g1_distances <- distance_table(g1)$res

# Now let's try the same thing with the raw_data
g2 <- graph_from_data_frame(raw_data[raw_data$direct_link_hh1 == 1 |
                                           raw_data$direct_link_hh2,],
                            directed = FALSE)
g2 <- simplify(g2)

g2_order <- length(V(g2))
g2_size <- length(E(g2))
g2_mean_degree <- mean(degree(g2))
g2_median_degree <- median(degree(g2))
g2_min_degree <- min(degree(g2))
g2_max_degree <- max(degree(g2))
g2_distances <- distance_table(g2)$res

# Check if the results are the same
g1_order == g2_order
g1_size == g2_size
g1_mean_degree == g2_mean_degree
g1_max_degree == g2_max_degree
g1_median_degree == g2_median_degree
g1_min_degree == g2_min_degree
all(g1_distances == g2_distances)

