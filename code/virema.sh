#module load samtools/1.11

#FASTQ_FILE=/home/kmwangi/projects/virema_covid/test-analysis-code/trimmed-data/COVC23438_S14_con_R2_001.trimmed.fastq.gz
FASTQ_FILE=$1
OUTPUT_DIR=/var/scratch/kmwangi/sars-cov-2-data-reanalysis-virema-output-trimmed
INDEX=/home/kmwangi/projects/virema_covid/test-analysis-code/sars-cov-ref-genome/SARS-CoV-2.reference.fasta # bowtie reference

mkdir -p ${OUTPUT_DIR}

fastq=$(echo ${FASTQ_FILE} | sed 's/_001.trimmed.fastq.gz//')

fqname=$(basename "$fastq")

~/miniforge-pypy3/envs/nfcore2.9/bin/python /home/kmwangi/projects/virema_covid/ViReMa_0.29/ViReMa.py \
${INDEX} \
${fastq}_001.trimmed.fastq.gz \
${fqname}.sam \
--Seed 20 \
--MicroInDel_Length 5 \
--p 1 \
--Output_Tag ${fqname} \
-BED12 \
-BED \
-BAM \
--Pad 300 \
--Output_Dir ${OUTPUT_DIR}/${fqname} \
--Aligner bowtie \
--Aligner_Directory /home/kmwangi/projects/virema_covid/bowtie-1.3.1-linux-x86_64 \
-Overwrite



