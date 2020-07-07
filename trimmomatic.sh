#!/bin/bash

#SBATCH -n 4
#SBATCH -N 1
#SBATCH --mem 12000
#SBATCH -t 0-12:00
#SBATCH -J trimFastq
#SBATCH -o trim_%j.out
#SBATCH -e trim_%j.err
#SBATCH --account=def-coling

#only one variable is passed to this script, but it becomes $1 and $2 due to the fact that it contains an *

module load trimmomatic/0.36

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.36.jar PE -threads 4 $1 $2 trim_${1} unpaired_${1} trim_${2} unpaired_${2} ILLUMINACLIP:adapters.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:90
