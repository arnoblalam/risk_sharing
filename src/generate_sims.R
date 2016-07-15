# name          : generate_sims.R
# description   : Exploration of Tanzania Data using bilateral links only
# maintainer    : Arnob L. Alam <aa2288a@student.american.edu>
# updated       : 2016-07-15
#
# Generate all the simulations for all the models and save them

# Source in the utility file
source("src/utils.R")

# sim_size <- 100

flog.info("Reading in data")
tanzania_data <- read.csv("data/tanzania_data.csv", stringsAsFactors = FALSE)

flog.info("Making the observewd graphs")

# Bilateral model
# If either household says there is a link between them, we count it
bilateral_links <- as.matrix(tanzania_data[tanzania_data$willingness_link1 == 1 | tanzania_data$willingness_link2 == 1, 1:2])
# class(links) <- "character"
# Create an igraph undirected graph from the links
bilateral_graph <- graph_from_edgelist(bilateral_links, directed = FALSE)
# Remove multiple and loops
bilateral_graph <- simplify(bilateral_graph,
                           remove.multiple = TRUE,
                           remove.loops = TRUE)

# Unilateral model
# If both household says there is a link between them, we count it
unilateral_links <- as.matrix(tanzania_data[tanzania_data$willingness_link1 == 1 & tanzania_data$willingness_link2 == 1, 1:2])
# class(links) <- "character"
# Create an igraph undirected graph from the links
unilateral_graph <- graph_from_edgelist(unilateral_links, directed = FALSE)
# Remove multiple and loops
unilateral_graph <- simplify(unilateral_graph,
                           remove.multiple = TRUE,
                           remove.loops = TRUE)
# Households 115 thorugh 119 are isolated. Add them to the graph.
unilateral_graph <- unilateral_graph + 4

# Desire to link model
dtl_links <- as.matrix(tanzania_data[tanzania_data$willingness_link1 == 1, 1:2])
desire_to_link_graph <- simplify(graph_from_edgelist(dtl_links, directed = TRUE),
                           remove.multiple = FALSE,
                           remove.loops = TRUE)

degree_bilateral <- degree(bilateral_graph)
degree_unilateral <- degree(unilateral_graph)
degree_desire_to_link_in <- degree(desire_to_link_graph, mode = "in")
degree_desire_to_link_out <- degree(desire_to_link_graph, mode = "out")
order_bilateral <- length(V(bilateral_graph))
order_unilateral <- length(V(unilateral_graph))
order_desire_to_link <- length(V(desire_to_link_graph))
size_bilateral <- length(E(bilateral_graph))
size_unilateral <- length(E(unilateral_graph))
size_desire_to_link <- length(E(desire_to_link_graph))

flog.info("Generating %s graphs", sim_size)
er_bilateral <- replicate(
    sim_size,
    sample_gnm(order_bilateral, size_bilateral, directed = FALSE, loops = FALSE),
    simplify = FALSE)
er_unilateral <- replicate(
    sim_size,
    sample_gnm(order_unilateral, size_unilateral, directed = FALSE, loops = FALSE),
    simplify = FALSE)
er_desire_to_link <- replicate(
    sim_size,
    sample_gnm(order_desire_to_link, size_desire_to_link, directed = TRUE, loops = TRUE),
    simplify = FALSE
)

config_bilateral <- replicate(sim_size, degree.sequence.game(degree_bilateral, method = "vl"), simplify = FALSE)
config_unilateral <- replicate(sim_size, degree.sequence.game(degree_unilateral, method = "simple.no.multiple"), simplify = FALSE)
config_desire_to_link <- replicate(sim_size,
                                   degree.sequence.game(out.deg = degree_desire_to_link_in,
                                                        in.deg = degree_desire_to_link_out,
                                                        method = "simple.no.multiple"),
                                   simplify = FALSE)
