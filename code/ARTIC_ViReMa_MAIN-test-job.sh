#!/usr/bin/bash -l
#SBATCH --partition batch
#SBATCH --job-name virema-CN
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --ntasks-per-core=1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=k.mwangi@cgiar.org

module load samtools/1.11
module load bowtie2/2.5.0

ls /home/kmwangi/projects/virema_covid/test-analysis-code/trimmed-data/test-data/*trimmed*.gz | sort | parallel -P $SLURM_NTASKS -N2 ./ARTIC_ViReMa_MAIN-test.sh -t 1 -p BMVN {1} {2}

#find /var/scratch/kmwangi/sars-cov-2-data-reanalysis-trimmed-all-data/*merged_R1_001.trimmed.fastq.gz  | xargs -n1 basename |  awk -F'[_]' '{print $1"_"$2"_"$3}' | \
#parallel -P $SLURM_NTASKS -N1 ./ARTIC_ViReMa_MAIN-test.sh -p N -t 1 -g {1}_pilon/{1}.fasta {1}_merge.fastq.gz

