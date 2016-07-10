# name          : tanzania_desire_to_link.R
# description   : Exploration of Tanzania Data assuming responses indicate desire to link
# maintainer    : Arnob L. Alam <aa2288a@student.american.edu>
# updated       : 2016-05-26
#
# Exploration of Tanzania Risk Sharing Netwrok Data assuming responses indicate desire to link

# Source in the utility file
source("src/utils.R")

flog.info("Reading in data")
tanzania_data <- read.csv("data/tanzania_data.csv", stringsAsFactors = FALSE)

flog.info("Converting to igraph structure")
links <- as.matrix(tanzania_data[tanzania_data$willingness_link1 == 1, 1:2])
tanzania_graph <- simplify(graph_from_edgelist(links, directed = TRUE),
                           remove.multiple = FALSE,
                           remove.loops = TRUE)

flog.info("Getting some basic statistics")
size <- length(V(tanzania_graph))
order <- length(E(tanzania_graph))
diam <- diameter(tanzania_graph, directed = FALSE)
avg_degree <- mean(degree(tanzania_graph))
degree_sequence <- degree(tanzania_graph)
cc <- transitivity(tanzania_graph)
apl <- average.path.length(tanzania_graph)
giant_component <- largest_component(tanzania_graph)

# Comparing to other models

## Erdos-Renyi
flog.info("Generating 100K Erdos-Renyi Graphs")
er_graphs <- replicate(1000, sample_gnm(size, order, directed = TRUE),
                       simplify = FALSE)
diams_er <- sapply(er_graphs, diameter, directed=TRUE)
apls_er <- sapply(er_graphs, average.path.length)
cc_er <- sapply(er_graphs, transitivity)
giant_comps_er <- sapply(er_graphs, largest_component)
avg_degrees_er_in <- sapply(er_graphs, function(graph) mean(degree(graph, mode = "in")))
avg_degrees_er_out <- sapply(er_graphs, function(graph) mean(degree(graph, mode = "out")))

## Configuration model
flog.info("Generating 100K configuration graphs")
config_graphs <- replicate(1000, degree.sequence.game(degree(tanzania_graph, mode = "out"),
                                                      degree(tanzania_graph, mode = "in"),
                                                      method = "simple"),
                           simplify = FALSE)
diams_config <- sapply(config_graphs, diameter)
apls_config <- sapply(config_graphs, average.path.length)
cc_config <- sapply(config_graphs, transitivity)
giant_comps_config <- sapply(config_graphs, largest_component)
avg_degrees_config <- sapply(config_graphs, function(graph) mean(degree(graph)))

