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
links <- as.matrix(tanzania_data[tanzania_data$willingness_link1 == 1, 1:2])
tanzania_graph <- graph_from_edgelist(links,
                                      directed = FALSE)
tanzania_graph <- simplify(tanzania_graph,
                           remove.multiple = TRUE,
                           remove.loops = TRUE)

flog.info("Getting some basic statistics")
length(V(tanzania_graph))

connectedness <- degree(tanzania_graph)
closeness_structure <- closeness(tanzania_graph)
betweenness_structure <- betweenness(tanzania_graph)

deg <- centr_degree(tanzania_graph)$centralization
clos <- centr_clo(tanzania_graph)$centralization
bet <- centr_betw(tanzania_graph)$centralization
eig <- centr_eigen(tanzania_graph)$centralization

# Print out the stats to screen
message("The Tanzanaia data has ",
        length(V(tanzania_graph)),
        " nodes and ",
        length(E(tanzania_graph)),
        " connections (edges) between these nodes")
message("The most connected household is (household ID) ",
        which.max(connectedness),
        " which has ", max(connectedness),
        " connections")
message("The household that is most frequently in the shortest path between two other households is household ",
        which.max(betweenness_structure))
message("The household that is adjacent to most other households is household ",
        which.max(closeness_structure))

message("
        Measures of graph centralization (normalized to theoretical maximum of a 115 node network)")

message("\tDegree Centralization: ", round(deg, 2))
message("\tCloseness Centralization: ", round(clos, 2))
message("\tBetweenness Centralization: ", round(bet), 2)
message("\tEigenvector Centralization: ", round(eig), 2)

message("Some measure of redunandancy:")

mst <- minimum.spanning.tree(tanzania_graph)

message("The minimum spanning tree for this graph has ", length(E(mst)),
        " edges (compared to the " , length(E(tanzania_graph)),
        " in the original graph).")


flog.info("Plotting the graph and histogram of degree")

plot(tanzania_graph, layout = layout_nicely)
hist(connectedness,
     main = "Histogram of degree distribution of the Tanzania Graph",
     xlab = "Degrees")
hist(closeness_structure,
     main = "Histogram of closeness (1/distance) of the Tanzania Graph",
     xlab = "Closeness")
hist(betweenness_structure,
     main = "Histogram of betweenness of the Tanzania Graph",
     xlab = "Betweenness")
