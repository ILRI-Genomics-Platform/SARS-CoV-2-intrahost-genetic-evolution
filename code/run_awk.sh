
# Set the input directory
input_dir="./missing_samples"


# Set the output directory
output_dir="./missing_samples_BED_files_above_10_reads"

# Make the output directory if it doesn't exist
mkdir -p "${output_dir}"

# Loop over all BED files in the input directory
for sample_dir in "${input_dir}"/*/; do

	sample_dir="${sample_dir%/}"

	#echo $sample_dir

	# Extract the sample name from the directory path
	sample=$(basename "${sample_dir}")

	#echo $sample

	# Make output directory for this sample if it doesn't exit
	mkdir -p "${output_dir}/${sample}"

	input_bed_dir="${input_dir}/${sample}"

	for bed_file in ${input_bed_dir}/*; do

		#echo $bed_file

		bed_file_name=$(basename ${bed_file})

		#echo $bed_file_name

		awk '$5 > 10' ${bed_file} > "${output_dir}/${sample}/${bed_file_name}"


	done

done

