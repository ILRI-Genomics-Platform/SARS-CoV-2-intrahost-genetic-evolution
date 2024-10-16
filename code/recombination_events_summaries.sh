
# inputs - example
#data_dir = sorted_monthly_coveragewise/virema_results_bed_files/virema_results_v0.25_may2021-july2021
#output_dir = /home/kmwangi/projects/virema_covid/recombination_events_summaries

covid_waves=("Phase_1 Phase_2 Phase_3 Phase_4 Phase_5 Phase_6 Phase_7 Phase_8 Phase_9")

for covid_wave in $covid_waves; do


data_dir=$1/${covid_wave}
sample_categories=$(basename $data_dir)

output_dir=$2/${sample_categories}
mkdir -p ${output_dir}

# For Read 1
for file in `ls ${data_dir}/*R1*.bed`; do

bed_file=$(basename $file)

sample_name=$(echo "${bed_file}" | awk -F '_' '{print $1}') 

sed '1d' $file | cut -f 4 | sort -n | uniq -c | sed 's/^\s*//' >  ${output_dir}/${sample_name}_R1.txt

done

# For Read 2
for file in `ls ${data_dir}/*R2*.bed`; do

bed_file=$(basename $file)

sample_name=$(echo "${bed_file}" | awk -F '_' '{print $1}') 

sed '1d' $file | cut -f 4 | sort -n | uniq -c | sed 's/^\s*//' >  ${output_dir}/${sample_name}_R2.txt

done



done
