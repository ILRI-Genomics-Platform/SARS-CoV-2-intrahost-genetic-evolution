# Analyzing ViReMa Output in R
# https://jayeung12.github.io/rtutorial.html

library(ggplot2)
library(tidyverse)

# set.seed(2345)

# phases <- c("Phase_1", "Phase_2", "Phase_3", "Phase_4", "Phase_5", "Phase_6", "Phase_7", "Phase_8", "Phase_9")
skip_line <- 1
phases <- c("vaccinated_females", "nonvaccinated_females")
# phases <- c("Phase_9")

combined_data <- data.frame()

for (phase in phases){
#To load in multiple files all in the same directory, we can use the following:


  filenames = list.files(paste0("vaccination-status-grouping-cov99/",phase), pattern="*ViReMa_normalised.bed", full.names=TRUE)


filelist = list()
for(i in 1:length(filenames)){
  filelist[[i]] =   read.table(filenames[i],skip=skip_line, sep="\t",stringsAsFactors=FALSE, quote="")
}

#Combines all of the files, row by row
data = do.call(rbind, filelist)

data <- data %>%
  mutate(V5 = (V5 / sum(V5))*100*1000)
#Before plotting, we need to make a few more variables.
#V11 is the number of samples an event appears in
#V5 is updated to reflect the sum of the reads across samples
#Make sure to ungroup at the end - it may cause issues down the line
dataCombo = data%>% group_by(V2,V3,V4) %>% mutate(V11=n()) %>% mutate(V5=sum(V5 %>% as.numeric())) %>% ungroup()

dataCombo$category <- phase
combined_data <- rbind(combined_data, dataCombo)

# dataCombo_percent <- dataCombo %>%
#   mutate(freq = (V5 / sum(V5))*100*10000)

# dataCombo$V5 <- log(dataCombo$V5)*1000000

#Making the plot
#The size of the points are controlled by the number of reads - 'size = V5'
#The color is controlled by the number of isolates (aka .BED files) each event appears in - 'color = V11'
#Change the colors at 'scale_color_gradient'
# ggplot(dataCombo,aes(x = V3, y = V2, color = V11)) +
#   geom_point(aes(size = V5),alpha = 0.6) +
#   scale_size_continuous("Read Count",range = c(0.4, 10))+
#   coord_cartesian() +
#   ylab("Donor Site") +
#   xlab("Acceptor Site") +
#   theme_classic(base_size = 18) +
#   scale_color_gradient("# of Isolates",low = "#87f6ff", high = "#f786ff")
# ggsave(paste0("figures-covid-waves_vacc-status-reanalysis-cov70/phase_9_omicron_",phase,".png"))

}

linecolors <- c("#714C02", "#01587A", "#024E37")
fillcolors <- c("#9D6C06", "#077DAA", "#026D4E") #0096FF
# scale_color_manual(values = c("#00AFBB", "#E7B800"))

# combined_data$category <- as.character(combined_data$category)
# combined_data$category <- factor(combined_data$category, levels=c("vaccinated", "non-vaccinated"))

ggplot(combined_data,aes(x = V3, y = V2)) +
  geom_point(aes(size = V5, color = category),alpha = 0.5,
             position=position_jitter(h=0.1, w=0.1)) +
  scale_size("Read Count",range = c(1, 12))+
  coord_cartesian() +
  ylab("Donor Site") +
  xlab("Acceptor Site") +
  theme_classic(base_size = 18, ) +  scale_color_manual("Vaccination Status", values = c("#00ABF0","#E7B800"))
  #+
  # scale_color_gradient("# of Isolates",low = "#87f6ff", high = "#f786ff")
ggsave(paste0("figures-vaccination-status-grouping-cov99/vacc-nonvaccination_status_female.png"))
