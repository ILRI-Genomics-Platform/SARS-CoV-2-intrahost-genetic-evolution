#!/usr/bin/bash -l
#SBATCH --partition batch
#SBATCH --job-name virema
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --ntasks-per-core=1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=k.mwangi@cgiar.org

module load samtools/1.11


ls /var/scratch/kmwangi/sars-cov-2-data-reanalysis-trimmed/*trimmed*.gz | parallel -P $SLURM_NTASKS ./virema.sh {}

#ls /var/scratch/kmwangi/sars-cov-2-data-reanalysis-trimmed-duplicates/*trimmed*.gz | parallel -P $SLURM_NTASKS ./virema.sh {}
