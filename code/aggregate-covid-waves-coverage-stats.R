library(tidyverse)
library(openxlsx)

# phases <- c("Phase_1", "Phase_2", "Phase_3", "Phase_4", "Phase_5", "Phase_6", "Phase_7", "Phase_8", "Phase_9")
phases <- c("Phase_7", "Phase_8", "Phase_9")

column_names <- c("sample_id", "rname",	"startpos",	"endpos",	"numreads",	
                  "covbases",	"coverage",	"meandepth",	"meanbaseq",	
                  "meanmapq")


wb <- createWorkbook()

for (phase in phases){
  
  addWorksheet(wb, phase)
  
  phase_data <- data.frame(matrix(ncol = 10, nrow = 0))
  # colnames(phase_data) <- c("sample_id", "Deletion_Jfreq", "EndFus_Jfreq",
  #                           "Insertio_Jfreq", "sgmRNA_Jfreq", "uDel_Jfreq",
  #                           "uIns_Jfreq")
  
  colnames(phase_data) <- column_names
  
  # colnames(phase_data) <- c("sample_id", "Spike", "ORF3a", "E", "M", "ORF6",
  #                           "ORF7a", "ORF7b", "ORF8", "N", "N*", "NonCanonical")
  
  file_path <- paste0("covid-waves-grouping-cov70-coverage-stats-files/",phase)
  raw_report_data <- sort(list.files(file_path, pattern=".txt", full.names = TRUE))
  
  for (file in raw_report_data){
    
    report_data <- read.table(file, sep = "\t", header = FALSE)
    # report_data$V1 <- gsub(":", "", report_data$V1)
    
    sample_name <- basename(file)
    
    sample_id <- str_split_fixed(sample_name, pattern = "_", n = 4)[1]
    
    report_data$sample_id <- sample_id
    
    # report_data_wide <- spread(report_data, V1, V2)
    
    report_data_wide <- report_data %>% select(sample_id, everything())
    
    colnames(report_data_wide) <- column_names
    
    phase_data <- rbind(phase_data, report_data_wide)
    
  }
  writeData(wb, phase, phase_data)
  
}

# saveWorkbook(wb, "vaccination-status-grouping-cov99-aggregated-sgmRNA-alone-adj-age.xlsx", 
#              overwrite = TRUE)

saveWorkbook(wb, "covid-waves-grouping-cov70-aggregated-coverage-stats.xlsx",
             overwrite = TRUE)
