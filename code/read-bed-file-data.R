library(tidyverse)
library(openxlsx)

data_dir_vaccinated <- "virema-reanalysis-bed-files-routh-code-for-mss-fig/Vaccinated/"
data_dir_nonvaccinated <- "virema-reanalysis-bed-files-routh-code-for-mss-fig/Non-Vaccinated/"

out_dir <- "recombination-along-genome/summarized-sorted-frequency"

if(!dir.exists(out_dir)){
  dir.create(out_dir)
}

###############################################################################
# FUNCTIONS
###############################################################################

read_data <- function(data_dir){
  
  #read in all .txt files but skip the first 8 rows
  recombination_data <- lapply(paste0(data_dir, list.files(path = data_dir, 
                                                           pattern = "\\.bed$")), 
                               read.csv, 
                               header=FALSE, 
                               skip=1,
                               sep = "\t")  
  
  #combines all of the tables by column into one 
  recombination_data <- do.call(rbind, recombination_data)
  return(recombination_data)
}

summarize_frequency <- function(frequency_data){
  
  frequency_data_summarized <- frequency_data %>% 
    group_by(genome_start, genome_end, recombination_type, vaccination_status) %>% 
    summarise(frequency = sum(frequency))
  return(frequency_data_summarized)
  
}

###############################################################################

samples_vaccinated <- read_data(data_dir_vaccinated)
samples_nonvaccinated <- read_data(data_dir_nonvaccinated)

# get columns of interest
samples_vaccinated <- samples_vaccinated %>% select(V2, V3, V4, V5)
samples_nonvaccinated <- samples_nonvaccinated %>% select(V2, V3, V4, V5)

colnames(samples_vaccinated) <- c("genome_start", "genome_end", "recombination_type", "frequency")
colnames(samples_nonvaccinated) <- c("genome_start", "genome_end", "recombination_type", "frequency")

samples_vaccinated$vaccination_status <- "vaccinated"
samples_nonvaccinated$vaccination_status <- "non-vaccinated"


# summarise
samples_vaccinated_summarized <- summarize_frequency(samples_vaccinated)
samples_nonvaccinated_summarized<- summarize_frequency(samples_nonvaccinated)


# sgmRNA_vaccinated <- samples_vaccinated_summarized[samples_vaccinated_summarized$recombination_type == "sgmRNA", ]
# sgmRNA_nonvaccinated <- samples_nonvaccinated_summarized[samples_nonvaccinated_summarized$recombination_type == "sgmRNA", ]

sgmRNA_vaccinated <- samples_vaccinated_summarized
sgmRNA_nonvaccinated <- samples_nonvaccinated_summarized
  
# sort sgmRNA descending order
sgmRNA_vaccinated <- sgmRNA_vaccinated[order(sgmRNA_vaccinated$frequency, decreasing = TRUE), ]
sgmRNA_nonvaccinated <- sgmRNA_nonvaccinated[order(sgmRNA_nonvaccinated$frequency, decreasing = TRUE), ]

# get similar intervals


write.xlsx(sgmRNA_vaccinated, paste0(out_dir, "/vaccinated_sorted_frequency.xlsx"))
write.xlsx(sgmRNA_nonvaccinated, paste0(out_dir, "/nonvaccinated_sorted_frequency.xlsx"))



#+JMJ+