# training_g4
## This repository contains scripts and protocols for Docker/Garroway Labs at the University of Manitoba as they trainees go from raw fastq files through to VCF

## The steps we will be following:
- Run a script to `cp` files from `projects` to `scratch`
- Run `fastqc` on raw reads
- Run `Multiqc` to view all records together
- Run `trimmomatic` to remove adapters
- Run `fastqc` and `multiqc` again
- Run `bowtie2` to map reads to the genome (generate bam files)
- Run `picard` to remove duplicate reads
- Run `platypus` to call SNPs (generate vcf file)
