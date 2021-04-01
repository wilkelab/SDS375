library(tidyverse)
library(here)

set.seed(1237)
coords <- tibble(
  x = c(rnorm(100), rnorm(100, 2), rnorm(100, 4.3)),
  y = c(rnorm(100), rnorm(100, -4), rnorm(100, 1.5))
)

write_csv(coords, here("datasets", "gaussian_clusters.csv"))


## k-means analysis

update_clusters <- function(coords, centroids) {
  dmin <- sqrt((centroids$x[1]-coords$x)^2 + (centroids$y[1]-coords$y)^2)
  cluster <- rep(1, nrow(coords))
  
  for (i in 2:nrow(centroids)) {
    d <- sqrt((centroids$x[i]-coords$x)^2 + (centroids$y[i]-coords$y)^2)
    idx <- d < dmin
    dmin[idx] <- d[idx]
    cluster[idx] <- i
  }
  
  coords$cluster <- factor(cluster)
  coords
}

update_centroids <- function(coords) {
  coords %>%
    group_by(cluster) %>%
    summarize(x = mean(x), y = mean(y)) %>%
    arrange(cluster)
}

random_centroids <- function(coords, n) {
  x <- runif(n, min(coords$x), max(coords$x))
  y <- runif(n, min(coords$y), max(coords$y))
  tibble(x, y, cluster = factor(1:n))
}

make_kmeans_plot <- function(coords, centroids, voronoi_centr, color_points = TRUE) {
  xlim <- c(min(coords$x), max(coords$x))
  xrange <- diff(range(xlim))
  xlim <- xlim + c(-.1*xrange, .1*xrange)
  ylim <- c(min(coords$y), max(coords$y))
  yrange <- diff(range(ylim))
  ylim <- ylim + c(-.1*yrange, .1*yrange)
  
  if (isTRUE(color_points)) {
    p <- ggplot(coords, aes(x, y, color = cluster))
  } else {
    p <- ggplot(coords, aes(x, y))
  }
  
  p <- p +
    geom_voronoi_tile(
      data = voronoi_centr,
      aes(fill = cluster, group = 1L),
      alpha = 0.2,
      color = NA,
      bound = c(xlim, ylim)
    ) 
  
  if (isTRUE(color_points)) {
    p <- p + geom_point()
  } else {
    p <- p + geom_point(color = "black")
  }
  
  p + 
    geom_point(
      data = centroids,
      aes(fill = cluster),
      color = "black", size = 3, shape = 21
    ) +
    coord_cartesian(xlim = xlim, ylim = ylim, expand = FALSE) +
    theme_void() +
    theme(legend.position = "none")
}

# three centers

set.seed(1237)
coords <- tibble(
  x = c(rnorm(100), rnorm(100, 2), rnorm(100, 4.3)),
  y = c(rnorm(100), rnorm(100, -4), rnorm(100, 1.5))
)

centroids <- random_centroids(coords, n = 3)
coords <- update_clusters(coords, centroids)

make_kmeans_plot(coords, centroids, centroids, color_points = FALSE)
make_kmeans_plot(coords, centroids, centroids, color_points = TRUE)

centroids2 <- update_centroids(coords)
make_kmeans_plot(coords, centroids2, centroids, color_points = FALSE)

centroids <- centroids2
coords <- update_clusters(coords, centroids)
make_kmeans_plot(coords, centroids, centroids, color_points = FALSE)
make_kmeans_plot(coords, centroids, centroids, color_points = TRUE)

# three centers, 5 clusters

set.seed(3541)
centroids <- random_centroids(coords, n = 5)
coords <- update_clusters(coords, centroids)

make_kmeans_plot(coords, centroids, centroids, color_points = FALSE)
make_kmeans_plot(coords, centroids, centroids, color_points = TRUE)

centroids2 <- update_centroids(coords)
make_kmeans_plot(coords, centroids2, centroids, color_points = FALSE)

centroids <- centroids2
coords <- update_clusters(coords, centroids)
make_kmeans_plot(coords, centroids, centroids, color_points = FALSE)
make_kmeans_plot(coords, centroids, centroids, color_points = TRUE)


# spirals

spirals <- read_csv("https://wilkelab.org/SDS375/datasets/spirals.csv")

coords <- tibble(
  x = spirals$x,
  y = spirals$y
)

set.seed(1232)
centroids <- random_centroids(coords, n = 3)
coords <- update_clusters(coords, centroids)

make_kmeans_plot(coords, centroids, centroids, color_points = FALSE)
make_kmeans_plot(coords, centroids, centroids, color_points = TRUE)

centroids2 <- update_centroids(coords)
make_kmeans_plot(coords, centroids2, centroids, color_points = FALSE)

centroids <- centroids2
coords <- update_clusters(coords, centroids)
make_kmeans_plot(coords, centroids, centroids, color_points = FALSE)
make_kmeans_plot(coords, centroids, centroids, color_points = TRUE)

