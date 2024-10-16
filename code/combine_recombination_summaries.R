library(tidyverse)
library(data.table)

#base_dirs <- c("may2021-july2021", "nov2021-jan2022", "jan2021-feb2021")
#base_dirs <- c("Vac_99_percent", "Non_vac_99_percent")
#base_dirs <- c("blue", "brown","yellow","unclassified_bed_files")
base_dirs <- c("Phase_1", "Phase_2", "Phase_3", "Phase_4", "Phase_5", "Phase_6", "Phase_7", "Phase_8", "Phase_9")

#base_dir_data <- "/home/kmwangi/projects/virema_covid/recombination_events_summaries_covid_waves/nonvaccinated/"
base_dir_data <- "/home/kmwangi/projects/virema_covid/recombination_events_summaries_covid_waves_all/"

for (base_dir in base_dirs){
  
  base_dir <- paste0(base_dir_data ,base_dir)
  
  reads <- c("R1", "R2")
  
  for (read in reads){
    
    outputdir_base <- base_dir_data
    
    file_paths <- file.path(list.files(base_dir, full.names = TRUE, pattern = paste0("_",read,".txt")))
    
    #out_dir <- gsub("virema_results_v0.25_","", basename(base_dir))
    out_dir <- basename(base_dir)
    
    #output_path <- outputdir_base
    output_path <- paste0(outputdir_base, out_dir)
    
    if(!dir.exists(output_path)){
      dir.create(output_path, recursive = TRUE)
    }
    
    for (file in file_paths){
      
      if (isTRUE(file.size(file) > 0)) {
       test_file <- read.csv(file, header = FALSE, sep = " ")
      } else { 
	next 
      }
      
      if (nrow(test_file) == 0){
       next 
      } 
      #test_file <- read.csv(file, header = FALSE, sep = " ")
     
      sample_name <- gsub(paste0("_",read,".txt"),"", basename(file))
      
      test_file$sample_name <- sample_name
      
      test_file <- test_file %>% select(sample_name, V2, V1)
      
      colnames(test_file) <- c("sample_name", "recombination_event","recombination_event_count")
      
      write.csv(test_file, file = paste0(output_path, "/" ,sample_name, "_",read,".csv"), row.names = FALSE)
      
    }
    
    # combine the files  
    files <- list.files(path = output_path ,pattern = paste0("_",read,".csv"), full.names = TRUE)
    temp <- lapply(files, fread, sep=",")
    combined_data <- rbindlist( temp )
    
    unlink(paste0(output_path, "/*_",read,".csv"))
    unlink(paste0(output_path, "/*_",read,".txt"))
    
    write.csv(combined_data, paste0(output_path, "/",read,"_combined_data_",out_dir,".csv"), row.names = FALSE)
  }
}

