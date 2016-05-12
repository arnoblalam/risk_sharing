# name          : tanzania_exploration.R
# description   : Exploration of Tanzania Data
# maintainer    : Arnob L. Alam <aa2288a@student.american.edu>
# updated       : 2016-05-11
#
# Initial exploration of Tanzania Risk Sharing Netwrok Data

tanzania_data <- read.csv("data/tanzania_data.csv", stringsAsFactors = FALSE)

links <- tanzania_data[tanzania_data$willingness_link1 == 1,1:2]

tanzania_graph <- graph_from_edgelist(as.matrix(links))
length(V(tanzania_graph))

# Get some summary stats
connectedness <- degree(tanzania_graph)
closeness_structure <- closeness(tanzania_graph)
betweenness_structure <- betweenness(tanzania_graph)

deg <- centr_degree(tanzania_graph)$centralization
clos <- centr_clo(tanzania_graph)$centralization
bet <- centr_betw(tanzania_graph)$centalization
eig <- centr_eigen(tanzania_graph)$centralization

message("The Tanzanaia data has ",
        length(V(tanzania_graph)),
            " nodes and ",
        length(E(tanzania_graph)),
        " connections (edges) between these nodes")
message("The most connected household is household ID: " %+%
            which.max(connectedness) %+%
            " which has " %+% max(connectedness) %+%
            " connections (either one way or two way)")
