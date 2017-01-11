## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----datamunging---------------------------------------------------------
baseLoc <- system.file(package="riskSharing") 
extPath <- file.path(baseLoc, "extdata") 

## ----nyakatoke_data, eval=FALSE------------------------------------------
#  nyakatoke <- read.csv(file.path(extPath, file.path("tanzania_data.csv")))
#  save(nyakatoke, file = "../data/nyakatoke.RData", compress = "xz")

## ----loadData------------------------------------------------------------
library(riskSharing)
data("nyakatoke")

## ----create_graph--------------------------------------------------------
library(igraph)
g <- graph_from_data_frame(nyakatoke[nyakatoke$willingness_link1 == 1 |
                                nyakatoke$willingness_link2,], directed = FALSE)
g <- simplify(g)

## ----base_stats----------------------------------------------------------
library(xtable)
g.order <- length(igraph::V(g))
g.size <- length(igraph::E(g))
g.mean.degree <- mean(degree(g))
g.min.degree <- min(degree(g))
g.max.degree <- max(degree(g))
g.distances <- distance_table(g)$res
names(g.distances) <- 1:length(g.distances)
summary.stats <- data.frame("graph order" = g.order,
                            "graph size" = g.size)
print(xtable(summary.stats), type="html")

