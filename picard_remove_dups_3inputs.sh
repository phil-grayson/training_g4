#!/bin/bash
#SBATCH -J pic_rem_dups
#SBATCH -n 1                     # Use 1 cores for the job
#SBATCH -t 0-11:59                 # Runtime in D-HH:MM
#SBATCH --mem=40000               # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o pRd.%A.out  # File to which STDOUT will be written
#SBATCH -e pRd.%A.err  # File to which STDERR will be written
#SBATCH --account=def-coling_cpu

module load picard/2.20.6

java -Xmx4g -jar $EBROOTPICARD/picard.jar MarkDuplicates REMOVE_DUPLICATES=false VALIDATION_STRINGENCY=SILENT I=$1 I=$2 I=$3 O=no_dups_$1 M=remove_dup_metrics_$1 TAGGING_POLICY=All
