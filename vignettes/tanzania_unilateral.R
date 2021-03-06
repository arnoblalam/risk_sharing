# name          : tanzania_bilateral.R
# description   : Exploration of Tanzania Data using bilateral links only
# maintainer    : Arnob L. Alam <aa2288a@student.american.edu>
# updated       : 2016-05-26
#
# Exploration of Tanzania Risk Sharing Netwrok Data assuming the unilateral model
# (hh1 -- hh2 in the graph only if both hh1 --> hh2 and hh2 --> hh1 is observed)

# Source in the utility file
source("src/utils.R")

flog.info("Reading in data")
tanzania_data <- read.csv("data/tanzania_data.csv", stringsAsFactors = FALSE)

flog.info("Converting to igraph structure")
# If either household says there is a link between them, we count it
links <- as.matrix(tanzania_data[tanzania_data$willingness_link1 == 1 & tanzania_data$willingness_link2 == 1, 1:2])
# class(links) <- "character"
# Create an igraph undirected graph from the links
tanzania_graph <- graph_from_edgelist(links, directed = FALSE)
# Remove multiple and loops
tanzania_graph <- simplify(tanzania_graph,
                           remove.multiple = TRUE,
                           remove.loops = TRUE)
# Households 115 thorugh 119 are isolated. Add them to the graph.
tanzania_graph <- tanzania_graph + 4

flog.info("Getting some basic statistics")
size <- length(V(tanzania_graph))
order <- length(E(tanzania_graph))
diam <- diameter(tanzania_graph, directed = FALSE)
avg_degree <- mean(degree(tanzania_graph))
degree_sequence <- degree(tanzania_graph)
cc <- transitivity(tanzania_graph, type = "local")
apl <- average.path.length(tanzania_graph)
giant_component <- largest_component(tanzania_graph)

# Comparing to other models

## Erdos-Renyi
flog.info("Generating 100K Erdos-Renyi Graphs")
er_graphs <- replicate(sim_size, sample_gnm(size, order, directed = FALSE, loops = FALSE),
                       simplify = FALSE)
diams_er <- sapply(er_graphs, diameter)
apls_er <- sapply(er_graphs, average.path.length)
cc_er <- sapply(er_graphs, transitivity)
giant_comps_er <- sapply(er_graphs, largest_component)
avg_degrees_er <- sapply(er_graphs, function(graph) mean(degree(graph)))

## Configuration model
flog.info("Generating 100K configuration graphs")
config_graphs <- replicate(sim_size, sample_degseq(degree_sequence, method = "simple.no.multiple"),
                           simplify = FALSE)
diams_config <- sapply(config_graphs, diameter)
apls_config <- sapply(config_graphs, average.path.length)
cc_config <- sapply(config_graphs, transitivity)
giant_comps_config <- sapply(config_graphs, largest_component)
avg_degrees_cc <- sapply(config_graphs, function(graph) mean(degree(graph)))

