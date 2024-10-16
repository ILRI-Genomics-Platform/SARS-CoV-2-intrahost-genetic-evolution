library(tidyverse)
library(openxlsx)

# phases <- c("Phase_1", "Phase_2", "Phase_3", "Phase_4", "Phase_5", "Phase_6", "Phase_7", "Phase_8", "Phase_9")
# phases <- c("vaccinated_males", "vaccinated_females", "nonvaccinated_females", "nonvaccinated_males",
#             "vacc_1_10", "vacc_11_30", "vacc_31_50", "vacc_51_60", "vacc_above_61", "nonvacc_1_10",
#             "nonvacc_11_30", "nonvacc_31_50", "nonvacc_51_60", "nonvacc_above_61")
phases <- c("vaccinated_males", "vaccinated_females", "nonvaccinated_females", "nonvaccinated_males",
            "vacc_1_30", "vacc_31_50", "vacc_above_51", "nonvacc_1_30","nonvacc_31_50","nonvacc_above_51")


wb <- createWorkbook()

for (phase in phases){
  
  addWorksheet(wb, phase)
  
  phase_data <- data.frame(matrix(ncol = 7, nrow = 0))
  colnames(phase_data) <- c("sample_id", "Deletion_Jfreq", "EndFus_Jfreq",
                            "Insertio_Jfreq", "sgmRNA_Jfreq", "uDel_Jfreq",
                            "uIns_Jfreq")
  
  # colnames(phase_data) <- c("sample_id", "Spike", "ORF3a", "E", "M", "ORF6",
  #                           "ORF7a", "ORF7b", "ORF8", "N", "N*", "NonCanonical")
  
  file_path <- paste0("vaccination-status-grouping-cov99-report-files-sgmRNA-age-diff/",phase)
  raw_report_data <- sort(list.files(file_path, pattern=".txt", full.names = TRUE))
  
  for (file in raw_report_data){
    
    report_data <- read.table(file, sep = "\t")
    report_data$V1 <- gsub(":", "", report_data$V1)
    
    sample_name <- basename(file)
    
    sample_id <- str_split_fixed(sample_name, pattern = "_", n = 4)[1]
    
    report_data$sample_id <- sample_id
    
    report_data_wide <- spread(report_data, V1, V2)
    
    report_data_wide <- report_data_wide %>% select(sample_id, everything(),-c(Spike, ORF3a, E, M, ORF6,
                                        ORF7a, ORF7b, ORF8, N, `N*`, NonCanonical))
    
    phase_data <- rbind(phase_data, report_data_wide)

  }
  writeData(wb, phase, phase_data)
  
}

# saveWorkbook(wb, "vaccination-status-grouping-cov99-aggregated-sgmRNA-alone-adj-age.xlsx", 
#              overwrite = TRUE)

saveWorkbook(wb, "vaccination-status-grouping-cov99-aggregated-adj-age.xlsx",
             overwrite = TRUE)
