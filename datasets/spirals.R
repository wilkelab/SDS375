library(tidyverse)
library(here)

set.seed(6425)

n <- 100

t <- seq(from = 3.5*pi, to = 5*pi, length.out = n)

eps <- 5
r0 <- 1.5

x1 <- r0*t*t*sin(t) + eps*rnorm(n)
x2 <- r0*t*t*sin(t + 2*pi/3) + eps*rnorm(n)
x3 <- r0*t*t*sin(t + 4*pi/3) + eps*rnorm(n)
y1 <- r0*t*t*cos(t) + eps*rnorm(n)
y2 <- r0*t*t*cos(t + 2*pi/3) + eps*rnorm(n)
y3 <- r0*t*t*cos(t + 4*pi/3) + eps*rnorm(n)

group <- rep(c("A", "B", "C"), each = n)

spirals <- data.frame(x = c(x1, x2, x3)/100, y = c(y1, y2, y3)/100, group)

ggplot(spirals, aes(x, y, color = group)) +
  geom_point()

write_csv(spirals, here("datasets", "spirals.csv"))


library(Rtsne)

## Run the t-SNE algorithm and store the results into an object called tsne_results
set.seed(1234)
tsne_fit <- spirals %>%
  select(where(is.numeric)) %>%
  Rtsne(perplexity = 5, theta = 0.3, check_duplicates = FALSE)

tsne_data <- tsne_fit$Y %>%
  as.data.frame() %>%
  mutate(group = spirals$group)

ggplot(out_tsne, aes(V1, V2, color = group)) + geom_point()


library(umap)

umap_results <- umap(spirals[, 1:2])
out_umap <- data.frame(as.data.frame(umap_results$layout), group = spirals$group)
ggplot(out_umap, aes(V1, V2, color = group)) + geom_point()

custom.config <- umap.defaults
custom.config$random_state <- 124# 123
custom.config$n_epochs <- 500 

umap_results <- umap(spirals[, 1:2], config = custom.config)
out_umap <- data.frame(as.data.frame(umap_results$layout), group = spirals$group)
ggplot(out_umap, aes(V1, V2, color = group)) + geom_point()


library(kernlab)

kpca_fit <- kpca(
  ~., data = spirals[, 1:2], kernel="rbfdot",
  kpar = list(sigma = 5),
  features = 2
)

kpca_data <- kpca_fit %>%
  pcv() %>% # extract principal component vectors
  as.data.frame() %>% # convert to data frame
  mutate(group = spirals$group) # add back group info

ggplot(kpca_data, aes(V1, V2, color = group)) + geom_point(size = .4)

#print the principal component vectors
#pcv(kpc)
