library(here)
library(tidyverse)

data(fgl, package = "MASS")

forensic_glass <- fgl

write_csv(forensic_glass, here("datasets", "forensic_glass.csv"))

cm <- cor(select(forensic_glass, -type, -RI, -Si))
df_wide <- as.data.frame(cm)
df_long <- stack(df_wide)
names(df_long) <- c("cor", "var1")
df_long <- cbind(df_long, var2 = rep(rownames(cm), length(rownames(cm))))
clust <- hclust(as.dist(1-cm), method="average") 
levels <- clust$labels[clust$order]
df_long$var1 <- factor(df_long$var1, levels = levels)
df_long$var2 <- factor(df_long$var2, levels = levels)
ggplot(filter(df_long, as.integer(var1) < as.integer(var2)),
       aes(var1, var2, fill=cor)) + 
  geom_tile(color = "white", size = 0.5) +
  scale_fill_gradient2() +
  coord_fixed()
