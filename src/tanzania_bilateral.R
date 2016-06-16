# name          : tanzania_bilateral.R
# description   : Exploration of Tanzania Data using bilateral links only
# maintainer    : Arnob L. Alam <aa2288a@student.american.edu>
# updated       : 2016-05-26
#
# Exploration of Tanzania Risk Sharing Netwrok Data

# Source in the utility file
source("src/utils.R")

flog.info("Reading in data")
tanzania_data <- read.csv("data/tanzania_data.csv", stringsAsFactors = FALSE)

flog.info("Converting to igraph structure")
# If either household says there is a link between them, we count it
links <- as.matrix(tanzania_data[tanzania_data$willingness_link1 == 1 |
                                     tanzania_data$willingness_link1 == 1
                                 , 1:2])

# Create an igraph undirected graph from the links
tanzania_graph <- graph_from_edgelist(links, directed = FALSE)
# Remove multiple and loops
tanzania_graph <- simplify(tanzania_graph,
                           remove.multiple = TRUE,
                           remove.loops = TRUE)

flog.info("Getting some basic statistics")
