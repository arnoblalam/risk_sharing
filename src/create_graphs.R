# name          : create_graphs.R
# description   : Create graphs and store them as graphml files
# maintainer    : Arnob L. Alam <aa2288a@student.american.edu>
# updated       : 2016-08-19
#
# Reads the CSV data about household linkages and create three graphs.

# source the utility file
# source("src/utils.R")
# Read in the data about household connections
futile.logger::flog.info("Reading in data")
tanzania_data <- read.csv("data/tanzania_data.csv",
                          stringsAsFactors = FALSE)

## The Under-reporting Model
# The under-reporting model assumes that links between households are
# underreported.  If either household reports that their is a link
# between them, we say that two households share an edge.

futile.logger::flog.info(
"Reading in rows from link data where either household mentions there is a link")
under_reported_links <- as.matrix(tanzania_data[
    tanzania_data$willingness_link1 == 1 | tanzania_data$willingness_link2 == 1, 1:2])

futile.logger::flog.info(
    "Creating an undirected graph from the links")
graph_underreported <- igraph::graph_from_edgelist(under_reported_links,
                                                  directed = FALSE)

futile.logger::flog.info(
    "Simplifying the graph by removing loops and multiple edges")
igraph::simplify(graph_underreported,
                 remove.multiple = TRUE,
                 remove.loops = TRUE)

futile.logger::flog.info("Writing the results as a graphML file")
igraph::write.graph(graph = graph_underreported,
                    file = "data/underreporting_model.graphml",
                    format = "graphml")

## The Over-reporting Model
# The overreporting model assumes that household links are overreported.  We require
# both households to report a link with the other in order for them to share an edge.

futile.logger::flog.info("Reading in rows from link data where both households
          agree there is a link")
over_reported_links <- as.matrix(tanzania_data[
    tanzania_data$willingness_link1 == 1 & tanzania_data$willingness_link2 == 1, 1:2])

futile.logger::flog.info("Creating an undirected graph from the links")
graph_overreported <- igraph::graph_from_edgelist(over_reported_links,
                                                  directed = FALSE)

futile.logger::flog.info(
"Adding isolated households which have no connections with other households")
over_reported_links <- over_reported_links + 4

futile.logger::flog.info(
    "Simplifying the graph by removing loops and multiple edges")
igraph::simplify(graph_overreported,
         remove.multiple = TRUE,
         remove.loops = TRUE)

futile.logger::flog.info("Writing the results as a graphML file")
igraph::write.graph(graph = graph_overreported,
                    file = "data/underreporting_model.graphml",
                    format = "graphml")


## The Desire to link model
# The desire to link model assumes that when household a reports household b to
# be linked, they desire for such a link to exist (regardless of whether an
# actual link exists or not)


futile.logger::flog.info("Reading in rows from link data where either household
                         says there is a link")
desire_to_link <- as.matrix(tanzania_data[tanzania_data$willingness_link1 == 1, 1:2])

futile.logger::flog.info("Creating a directed graph")
graph_desire_to_link <- igraph::graph_from_edgelist(desire_to_link,
                                                    directed = TRUE)

futile.logger::flog.info("Writing the results as a graphML file")
graph_desire_to_link <- igraph::simplify(graph_desire_to_link,
                                         remove.multiple = FALSE,
                                         remove.loops = TRUE)
