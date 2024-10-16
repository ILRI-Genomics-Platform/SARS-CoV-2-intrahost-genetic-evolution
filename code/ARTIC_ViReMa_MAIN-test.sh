#!/bin/bash
usage="ARTIC-Recombination Batch Script
        Written by Andrew Routh 2024

USAGE: ./batchscript [OPTIONS] FASTQfile

e.g. ./ARTIC_ViReMa_Main.sh /path/to/data/mydata_R1.fastq

Required Arguments:
File	Enter full path of R1 file. Expected to end in *_L00?* (i.e. the lane number)

Optional Arguments:
    -h show this help text

    -p Perform custom stages; select combination of P, M, R, C, D. No whitespace, e.g. 'PM'.
            (default = PM: Preprocess and map)
        B Perform bowtie2/pilon reconstruction
        M Merge R1 and R2 data
        V Do ViReMa mapping
	C Repeat ViReMa Compilation Steps - if SAM file already present (must ungzipped).
	N Normalize Recombination Rates

    -t set threads (default: 1)

    -g provide base genome
    "

GENOME='NC_045512.2.fasta'
STAGING='PMV'
THREADS=1
while getopts 'hp:t:g:' option; do
  case "$option" in
    h ) echo "$usage"
       exit
       ;;
    p ) STAGING=$OPTARG
       ;;
    t ) THREADS=$OPTARG
       ;;
    g ) GENOME=$OPTARG
       ;;

   \? ) printf "unrecognised option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND -1))

##REQUIRED INPUT
FileR1=$1
FileR2=$2
DirRoot=${FileR1%%_L00*}
Root=${DirRoot##*/}
WKDIR=$0
ScriptPath=${WKDIR%/*}'/Scripts/'
echo $File
echo $DirRoot
echo $Root


##Initial Mapping
if [[ "$STAGING" == *"B"* ]]; then
	bowtie2 -p 16 -x NC_045512.2.fasta -1 FileR1 -2 FileR2 | samtools view -buSh - | samtools sort -@ 16 - -o $Root'_bwt2.bam'
	samtools index $Root'_bwt2.bam' 
	pilon --fix bases --genome $GENOME --flank 1 --mindepth 10 --frags $Root'_bwt2.bam' --vcf --changes --output $Root --outdir $Root'_pilon'
	GENOME=$Root'_pilon/'$Root'.fasta'
	grep PASS $Root'_pilon/'$Root'.vcf' | awk '{OFS=""}{if($5 ~ /[A,T,G,C]/)print $4, $2, $5}' > $Root'.changes.txt'
fi

#ViReMa Merge Data
if [[ "$STAGING" == *"M"* ]]; then
	gunzip -dc $1 > $Root'_merge.fastq'
	gunzip -dc $2 >> $Root'_merge.fastq'
	sed -i 's/\ 1\:N\:/_1\:N\:/g' $Root'_merge.fastq'
	sed -i 's/\ 2\:N\:/_2\:N\:/g' $Root'_merge.fastq'
	gzip $Root'_merge.fastq'
fi

##Run ViReMa
if [[ "$STAGING" == *"V"* ]]; then
	Root=${1%%_merge*}
	python3 $ScriptPath'ViReMa_0.30/ViReMa.py' $GENOME $Root'_merge.fastq' $Root'_ViReMa.sam' --Output_Dir $Root'_ViReMa' -BED12 --N 2 --X 3 --MicroInDel_Length 5 --Defuzz 0 --p $THREADS --Output_Tag $Root --MaxIters 25 -Overwrite --Chunk 5000000 -Stranded
fi
	
##Run ViReMa Compilation (e.g. if ViReMa SAM already present, but new compiling issues
if [[ "$STAGING" == *"C"* ]]; then
	Root=${1%%_merge*}
        python3 $ScriptPath'ViReMa_0.30/ViReMa.py' $GENOME $Root'_merge.fastq' $Root'_ViReMa.sam' --Output_Dir $Root'_ViReMa' -BED12 --MicroInDel_Length 5 --Defuzz 0 --Output_Tag $Root -Overwrite -Only_Compile -Stranded
fi

##Make Normalized and coordinated BED files
if [[ "$STAGING" == *"N"* ]]; then
	Root=${1%%_merge*}
	grep PASS $Root'_pilon/'$Root'.vcf' | awk '{OFS=""}{if($5 ~ /[A,T,G,C]/)print $4, $2, $5}' > $Root'.changes.txt'
	~/miniforge-pypy3/envs/nfcore2.9/bin/python $ScriptPath'Combine_unstranded_annotations.py' $Root'_ViReMa/BED_Files/'$Root'_Virus_Recombination_Results.bed' $Root'_ViReMa/BED_Files/'$Root'_Virus_Recombination_Results_noDir.bed' -BED12 -Stranded
	~/miniforge-pypy3/envs/nfcore2.9/bin/python $ScriptPath'Transpose_to_WA1-Coords.py' $Root'.changes.txt' $Root'_ViReMa/BED_Files/'$Root'_Virus_Recombination_Results_noDir.bed' $Root'_ViReMa/BED_Files/'$Root'_Virus_Recombination_Results_noDir_WA1coords.bed'
	~/miniforge-pypy3/envs/nfcore2.9/bin/python $ScriptPath'Plot_CS_Freq.py' $Root'_ViReMa/'$Root'_ViReMa' $Root'_ViReMa/BED_Files/'$Root'_Virus_Recombination_Results_noDir_WA1coords.bed' $Root'_pilon/'$Root'.fasta' --MicroInDel_Length 25 -CoVData -Ends --MinCov 100 --MinCount 3
fi
