#!/bin/bash

module load bcftools/1.9

bcftools concat -f NC_046070_10way_cat.txt -o NC_046070.1.vcf
