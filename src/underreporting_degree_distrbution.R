# name          : underreporting_degree_distribution.R
# description   : Exploration of Tanzania Data using bilateral links only
# maintainer    : Arnob L. Alam <aa2288a@student.american.edu>
# updated       : 2016-08-02
#
# Exploration of the degree distribution of the underreporting model as well
# as theoretical fits to Kackson-Rogers and Erdos-Renyi models

# Source in the utility file
source("src/utils.R")

flog.info("Reading in data")
tanzania_data <- read.csv("data/tanzania_data.csv", stringsAsFactors = FALSE)

flog.info("Converting to igraph structure")
# If either household says there is a link between them, we count it
links <- as.matrix(tanzania_data[tanzania_data$willingness_link1 == 1 |tanzania_data$willingness_link2 == 1, 1:2])
# class(links) <- "character"
# Create an igraph undirected graph from the links
tanzania_graph <- graph_from_edgelist(links, directed = FALSE)
# Remove multiple and loops
tanzania_graph <- simplify(tanzania_graph,
                           remove.multiple = TRUE,
                           remove.loops = TRUE)

d <- degree.distribution(tanzania_graph, cumulative = TRUE)

freqs <- data.frame(degree = 0:(length(d) -1), freq = d)
x <- data.frame(vertex=1:length(V(tanzania_graph)), degree = degree(tanzania_graph)) %>%
    left_join(freqs)
x$d0 <- 0
x$m <- mean(degree(tanzania_graph))/2

my_model <- nls(freq ~ 1 - ((d0 + r*m)/(degree + r*m)) ^ (1 + r), data = x,
                start = list(r = 0.1))

r <- coef(my_model)

d0 <- 0
m <- mean(degree(tanzania_graph))/2

jackson_rogers <- 1 - ((d0 + r*m)/(0:max(degree(tanzania_graph)) + r*m)) ^ (1 + r)
poisson_ <- ppois(0:max(degree(tanzania_graph)),
                  lambda = mean(degree(tanzania_graph)))

plot(freq ~ degree, data = x, log = "xy")
lines(1 - jackson_rogers, col = "red")
lines(1 - poisson_, col = "blue")
legend("bottomleft", legend = c("actual", "Jackson-Rogers", "Poisson"),
       lty = c(NA, 1, 1))
