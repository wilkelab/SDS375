n <- 100

t <- seq(from = 3.5*pi, to = 5*pi, length.out = n)

eps <- 10
r0 <- 1.5

x1 <- r0*t*t*sin(t) + eps*rnorm(n)
x2 <- r0*t*t*sin(t + 2*pi/3) + eps*rnorm(n)
x3 <- r0*t*t*sin(t + 4*pi/3) + eps*rnorm(n)
y1 <- r0*t*t*cos(t) + eps*rnorm(n)
y2 <- r0*t*t*cos(t + 2*pi/3) + eps*rnorm(n)
y3 <- r0*t*t*cos(t + 4*pi/3) + eps*rnorm(n)

group <- rep(c("A", "B", "C"), each = n)

spirals <- data.frame(x = c(x1, x2, x3), y = c(y1, y2, y3), group)

ggplot(spirals, aes(x, y, color = group)) + geom_point()


library(Rtsne)

## Run the t-SNE algorithm and store the results into an object called tsne_results
set.seed(1234)
tsne_results <- Rtsne(spirals[, 1:2], perplexity = 20, theta = 0.3, check_duplicates = FALSE)

out_tsne <- data.frame(as.data.frame(tsne_results$Y), group = spirals$group)

ggplot(out_tsne, aes(V1, V2, color = group)) + geom_point()


library(umap)

umap_results <- umap(spirals[, 1:2])
out_umap <- data.frame(as.data.frame(umap_results$layout), group = spirals$group)
ggplot(out_umap, aes(V1, V2, color = group)) + geom_point()

custom.config <- umap.defaults
custom.config$random_state <- 123# 123
custom.config$n_epochs <- 500 

umap_results <- umap(spirals[, 1:2], config = custom.config)
out_umap <- data.frame(as.data.frame(umap_results$layout), group = spirals$group)
ggplot(out_umap, aes(V1, V2, color = group)) + geom_point()


library(kernlab)

kpc <- kpca(
  ~., data = spirals[, 1:2], kernel="rbfdot",
  kpar = list(sigma = .001),
  features = 2
)

out_kpc <- data.frame(as.data.frame(pcv(kpc)), group = spirals$group)
ggplot(out_kpc, aes(V1, V2, color = group)) + geom_point(size = .4)

#print the principal component vectors
#pcv(kpc)
