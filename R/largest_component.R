#' find the size of the giant component
#'
#' @param graph graph for which to return the giant component
#'
#' @return integer number of nodes in largest component of graph
#' @export
#'
largest_component <- function(graph) {
    length(cluster.distribution(graph)) - 1
}
