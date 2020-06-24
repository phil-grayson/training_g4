library(tidyverse)

over_rep <- read_delim("~/Desktop/final_over_rep.txt",delim="\t", col_names = c("sequence","count","percentage","hit"))

over_rep.unique <- over_rep %>% select(-count,-percentage) %>% unique()

write_delim(over_rep.unique %>% select(sequence), "Over_sequence.txt")
