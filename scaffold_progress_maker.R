library(tidyverse)
setwd("~/Google Drive/Postdoc/Lamprey_short_read/")
scaf <- read_delim("GCF_010993605.1_kPetMar1.pri_genomic.fna.fai",delim="\t",col_names = F) %>% select(X1,X2) %>% 
  mutate(total=sum(X2)) %>% mutate(proportion = X2/total) %>% mutate(progress = cumsum(proportion)) %>% select(X1,X2,progress)

write_delim(scaf,"scaffold_progress_VGP.txt",delim = "\t",col_names = F)
