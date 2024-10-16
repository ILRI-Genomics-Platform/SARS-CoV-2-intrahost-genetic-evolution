
#phases <- c("Non-Vaccinated", "Vaccinated")
#phases <- c("Phase_1", "Phase_2", "Phase_3", "Phase_4", "Phase_5", "Phase_6", "Phase_7", "Phase_8", "Phase_9")
#phases <- c("Phase_7", "Phase_8", "Phase_9")
#phases <- c("vaccinated_males", "vaccinated_females", "nonvaccinated_females", "nonvaccinated_males", "vacc_1_30", "vacc_31_50", "vacc_above_51", "nonvacc_1_30",
#   "nonvacc_31_50", "nonvacc_above_51")
phases <- c("Vaccinated")

for (phase in phases){

#output_path <- paste0("/home/kmwangi/projects/virema_covid/virema_results_vacc-status-reanalysis-cov70/", phase,"/BED-files")
#list_of_files <- read.csv(paste0("/home/kmwangi/projects/virema_covid/covid_raw_data_all/covid_waves/",phase,"_cov70.txt"), sep = "", header = FALSE)
list_of_files <- read.csv(paste0("/home/kmwangi/projects/virema_covid/covid_raw_data_all/Vaccinated_cov99.txt"), sep = "", header = FALSE)

#fastq_dirs <- c("/home/kmwangi/projects/virema_covid/virema-reanalysis-bed-files-routh-code-v0.30/ViReMa-coverage-stats-files")
fastq_dirs <- paste0("/home/kmwangi/projects/virema_covid/virema-reanalysis-bed-files-routh-code-for-mss-fig")

output_path <- paste0("/home/kmwangi/projects/virema_covid/virema-reanalysis-bed-files-routh-code-for-mss-fig/", phase)
#output_path <- paste0("/home/kmwangi/projects/virema_covid/vaccination-status-grouping-cov99-report-files-sgmRNA-age-diff/", phase)
#list_of_files <- read.csv(paste0("/home/kmwangi/projects/virema_covid/covid_raw_data_all/covid_waves/",phase,".txt"), sep = "", header = FALSE)
#list_of_files <- read.csv(paste0("/home/kmwangi/projects/virema_covid/covid_raw_data_all/All_non_vaccinated_samples_cov70.txt"), sep = "", header = FALSE)

if (!dir.exists(output_path)){
  dir.create(output_path, recursive = TRUE)
}

#fastq_dirs <- c("/home/kmwangi/virema_covid/covid_raw_data_all/nonvaccinated",
#                "/home/kmwangi/virema_covid/covid_raw_data_all/nonvaccinated-2020")

# fastq_dirs <- c("/home/kmwangi/virema_covid/covid_raw_data_all/vaccinated")


if (!dir.exists(output_path)){
  dir.create(output_path, recursive = TRUE)
}

list_of_files <- as.vector(list_of_files$V1)

for (fastq_dir in fastq_dirs){
  
  for (file in list_of_files) {
    
    file_path <- paste0(fastq_dir, "/", file, "*")
    
    if (!length(Sys.glob(file_path)) == 0){
      
     #cp_args <- c( "-u", file_path, output_path)
      
      #system2("cp", args = cp_args)

      mv_args <- c(file_path, output_path)
      system2("mv", args = mv_args)
      
    }
  }
  
  system2("echo", paste("Finished copying from", fastq_dir))
}

}
