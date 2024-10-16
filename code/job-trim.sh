#!/usr/bin/bash -l
#SBATCH --partition batch
#SBATCH --job-name trim-data
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --ntasks-per-core=1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=k.mwangi@cgiar.org

module load fastp/0.22.0

#ls /home/kmwangi/projects/virema_covid/test-fastp/test-data/*R2*.gz | parallel -j 10 ./trim-fastq-data.sh {} 

ls /var/scratch/kmwangi/sars-cov-2-data-reanalysis/*con_R2*.gz | parallel -P $SLURM_NTASKS ./trim-fastq-data.sh {}

#ls /var/scratch/kmwangi/sars-cov-2-data-reanalysis-duplicated/*R2*.gz | parallel -P $SLURM_NTASKS ./trim-fastq-data-dups.sh {}
