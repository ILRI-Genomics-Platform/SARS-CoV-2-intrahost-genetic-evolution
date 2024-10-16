
# Libraries
library(tidyverse)
library(hrbrthemes)
library(viridis)
library("ggsci")
library("ggplot2")
library("gridExtra")
library("data.table")

library(tidyverse) 
library(reshape2)

categories <- c("subg-vacc", "large-ins-vacc", "dvg-vacc", "micro-del-vacc", "micro-ins-vacc",
                "subg-age", "large-ins-age", "dvg-age", "micro-del-age", "micro-ins-age")

for (category in categories){
  
  data <- openxlsx::read.xlsx("vaccination-status-grouping-cov99-aggregated - recombinations-working-file.xlsx", 
                              sheet = category)
  data_long <- melt(data, variable.name = "recombination_type", value.name = "frequency")
  data_long <- na.omit(data_long)
  
  # Sub-genomic RNAs
  # Defective viral genomes
  # Large insertions
  # Micro-deletions
  # Micro-insertions
  
  # Plot
  p1 <- data_long %>%
    ggplot( aes(x=recombination_type, y=frequency, fill=recombination_type)) +
    geom_boxplot(lwd=1.2, fatten = 1) +
    scale_fill_viridis(discrete = TRUE, alpha=0.6) +
    geom_jitter(color="black", size=1.1, alpha=0.9) +
    theme_ipsum() +
    theme(
      legend.position="none",
      plot.title = element_text(size=11)
    ) +
    # ggtitle("Sub-genomic RNAs") +
    xlab("")+
    ylab("JFreq")
  
  p1_npg <- p1 + scale_color_npg() 
  p2_npg <- p1 + scale_fill_npg()
  grid.arrange(p1_npg, p2_npg, ncol = 2)
  plot(p1_npg)
  plot(p2_npg)
  ggsave(paste0("virema-boxplots/",category,".png"))
  
  
}


# Violin basic
# V1 <- data_long %>%
#   ggplot( aes(x=recombination_type , y=frequency, fill=recombination_type)) +
#   geom_violin() +
#   scale_fill_viridis(discrete = TRUE, alpha=0.6, option="A") +
#   theme_ipsum() +
#   theme(
#     legend.position="none",
#     plot.title = element_text(size=11)
#   ) +
#   ggtitle("Large Insertions during and between transmission waves") +
#   xlab("")
# 
# V1_npg <- V1 + scale_color_npg()
# plot(V1_npg)
