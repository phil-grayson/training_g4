



#messy lamprey prelim

library(vcfR)
library(adegenet)
library(StAMPP)
library(poppr)
library(ape)
library(RColorBrewer)
library(parallel)
library(ggplot2)
library(reshape2)
library(ggrepel)
library(SNPRelate)
library(tidyverse)
library(bedr)


setwd("/home/cjg/lamprey")

snps <- read.vcfR("colin_subset_1_each_PASS.vcf.gz")
snps <- addID(snps, sep = "_")


# Three sections
# A VCF file can be thought of as having three sections: a meta region, a fix region and a gt region. The meta region is 
# at the top of the file. The information in the meta region defines the abbreviations used elsewhere in the file. It may
# also document software used to create the file as well as parameters used by this software. Below the meta region, the data 
# are tabular. The first eight columns of this table contain information about each variant. This data may be common over all
# variants, such as its chromosomal position, or a summary over all samples, such as quality metrics. These data are fixed, 
# or the same, over all samples. The fix region is required in a VCF file, subsequent columns are optional but are common in
# my experience. Beginning at column ten is a column for every sample. The values in these columns are information for each 
# sample and each variant. The organization of each cell containing a genotype and associated information is specified in 
# column nine. The location of these three regions within a file can be represented by the cartoon below.

# The meta region contains information about the file, its creation, as well as information to interpret abbreviations used 
# elsewhere in the file. Each line of the meta region begins with a double pound sign (‘##’). The example which comes with 
# vcfR is shown below. (Only the first seven lines are shown for brevity.)

strwrap(snps@meta[1:7])
queryMETA(snps)



# The first eight columns of the fixed region are titled CHROM, POS, ID, REF, ALT, QUAL, FILTER and INFO. This is per variant 
# information which is ‘fixed’, or the same, over all samples. The first two columns indicate the location of the variant by 
# chromosome and position within that chromosome. Here, the ID field has not been used, so it consists of missing data (NA). 
# The REF and ALT columns indicate the reference and alternate allelic states for a diploid sample. When multiple alternate 
# allelic states are present they are delimited with commas. The QUAL column attempts to summarize the quality of each variant 
# over all samples. The FILTER field is not used here but could contain information on whether a variant has passed some form 
# of quality assessment.

head(getFIX(snps))
head(snps)


# The gt (genotype) region contains information about each variant for each sample. The values for each variant and each sample
# are colon delimited. Multiple types of data for each genotype may be stored in this manner. The format of the data is 
# specified by the FORMAT column (column nine). Here we see that we have information for GT, AD, DP, GQ and PL. The definition
# of these acronyms can be referenced by querying the the meta region, as demonstrated previously. Every variant does not
# necessarily have the same information (e.g., SNPs and indels may be handled differently), so the rows are best treated 
# independently. Different variant callers may include different information in this region.

snps@gt[1:6, 1:4]



# Now we analyse the data! File formats galore. VCF is a good starting point b/c it speaks to other formats well
# You're all familiar with adegent so let's start there 


# genind vs genlight

gl <- vcfR2genlight(snps)

#snps1 <- read.vcf("lampreys_no_indels_maf05_thinned1K.vcf.gz")
#gi <- vcfR2genind(snps1)

# Bed
#lamprey_small <- vcf2bed(snps1)


# Samples in my data
# no_dups_trim_1_SC_21238_R1.fastq.gz anad_france
# no_dups_trim_25_CTR_1_R1.fastq.gz anad_MA
# no_dups_trim_114_Augres1_R1.fastq.gz huron
# no_dups_trim_81_BC1_R1.fastq.gz erie
# no_dups_trim_241_DF1_R1.fastq.gz ontario
# no_dups_trim_261_BR3_R1.fastq.gz superior
# no_dups_trim_206_MAN1_R1.fastq.gz michigan
# no_dups_trim_52_NY2_R1.fastq.gz chayuga
# no_dups_trim_72_CC1_R1.fastq.gz.bam seneca

gl@ind.names <- (c("anad_france", "anad_MA", "huron", "erie", "ontario", "superior", 
                           "michigan","chayuga", "seneca"))

gl@pop <- as.factor(c("anad_france", "anad_MA", "huron", "erie", "ontario", "superior", 
                      "michigan","chayuga", "seneca"))


# funny business due to cutting down data I suspect
toRemove <- is.na(glMean(gl, alleleAsUnit = FALSE)) # TRUE where NA
which(toRemove) # position of entirely non-typed loci
gl1 <- gl[, !toRemove]


# keep memory free 
rm(gl)
rm(snps)
rm(toRemove)

# analyses! Pop structure 

pca <- glPca(gl1, nf = 40, parallel = T, n.cores = 30)




# plot pca

cols <- rainbow(9)
pca.scores <- as.data.frame(pca$scores)
pca.scores$pop <- pop(gl1)

head(pca.scores)

p <- ggplot(pca.scores, aes(x=PC1, y=PC2, colour=pop))
p <- p + geom_point(size=4)
p <- p + geom_hline(yintercept = 0)
p <- p + geom_vline(xintercept = 0)
p <- p + theme_bw()
p

p1 <- ggplot(pca.scores, aes(x=PC1, y=PC3, colour=pop))
p1 <- p1 + geom_point(size=4)
p1 <- p1 + geom_hline(yintercept = 0)
p1 <- p1 + geom_vline(xintercept = 0)
p1 <- p1 + theme_bw()
p1

p2 <- ggplot(pca.scores, aes(x=PC2, y=PC3, colour=pop))
p2 <- p2 + geom_point(size=4)
p2 <- p2 + geom_hline(yintercept = 0)
p2 <- p2 + geom_vline(xintercept = 0)
p2 <- p2 + theme_bw()
p2


rm(pca)

# lots of other options. 
# https://github.com/gabraham/flashpca
# plink
# then bring PCs in here

# alternative with pruning
vcf.fn <- "colin_subset_1_each_PASS.vcf.gz"
snpgdsVCF2GDS(vcf.fn, "lampreys.gds", method="biallelic.only")
snpgdsSummary("lampreys.gds")

genofile <- snpgdsOpen("lampreys.gds")


pop_code <- as.factor(c("anad_france", "anad_MA", "huron", "erie", "ontario", "superior", 
                           "michigan","chayuga", "seneca"))


snpset <- snpgdsLDpruning(genofile, ld.threshold=0.2, autosome.only = F)

# another PCA  
pca1 <- snpgdsPCA(genofile, autosome.only = F)


# variance proportion (%)
pc.percent <- pca$varprop*100
pc.percent


head(round(pc.percent, 2))

tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  EV3 = pca$eigenvect[,3],
                  stringsAsFactors = FALSE)

head(tab)

plot(tab$EV3, tab$EV1, xlab="eigenvector 3", ylab="eigenvector 1")




tab <- data.frame(sample.id = pca$sample.id,
                  pop = factor(pop_code),
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  EV3 = pca$eigenvect[,3],
                  stringsAsFactors = FALSE)


plot(tab$EV2, tab$EV1, col=as.integer(tab$pop), xlab="eigenvector 2", ylab="eigenvector 1")
legend("bottomright", legend=levels(tab$pop), pch="o", col=1:nlevels(tab$pop))

# do it in ggplot

p3 <- ggplot(tab, aes(x=EV1, y=EV2, colour=pop))
p3 <- p3 + geom_point(size=4)
p3 <- p3 + geom_hline(yintercept = 0)
p3 <- p3 + geom_vline(xintercept = 0)
p3 <- p3 + theme_bw()
p3

p4 <- ggplot(tab, aes(x=EV2, y=EV3, colour=pop))
p4 <- p4 + geom_point(size=4)
p4 <- p4 + geom_hline(yintercept = 0)
p4 <- p4 + geom_vline(xintercept = 0)
p4 <- p4 + theme_bw()
p4



# distances
dist <- bitwise.dist(gl1)
dist

tree <- aboot(gl1, tree = "upgma", distance = bitwise.dist, sample = 1, 
              showtree = F, cutoff = 50, quiet = T)

plot.phylo(tree, cex = 0.8, font = 2, adj = 0, show.node.label = F, tip.color =  cols[pop(gl1)])

#legend('topright', legend = c("anad_france", "anad_MA", "huron", "erie", "ontario", "superior", 
#                              "michigan","chayuga", "seneca"), fill = cols, border = FALSE, bty = "n", cex = 0.6)
axis(side = 1)
title(xlab = "Genetic distance (proportion of loci that are different)")

# admixture

grp <- find.clusters(gl1, max.n.clust= 9, glPca = pca)
#error due to one obvs/cluster
grp <- find.clusters(gl1, max.n.clust= 8, glPca = pca)

dapc1 <- dapc(gl1, grp$grp )

compoplot(dapc1)

dapc.results <- as.data.frame(dapc1$posterior)
dapc.results$pop <- pop(gl1)
dapc.results$indNames <- rownames(dapc.results)

dapc.results <- melt(dapc.results)
colnames(dapc.results) <- c("Original_Pop","Sample","Assigned_Pop","Posterior_membership_probability")
p2 <- ggplot(dapc.results, aes(x=Sample, y=Posterior_membership_probability, fill=Assigned_Pop))
p2 <- p2 + geom_bar(stat='identity', width = 0.5)
p2 <- p2 + scale_fill_manual(values = cols)
p2 <- p2 + facet_grid(~Original_Pop, scales = "free")
p2 <- p2 + theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 8))
p2

# too long to show
# pwfst2 <- stamppFst(gl1, nboots=1, nclusters=30)


#filtered ledwell and D119 in VCFTOOLS    
# vcftools --remove-indv Ledwell_1_3  --vcf orca_newfound_filtered.vcf --recode --out filtered_snps_ledwell.vcf
# vcftools --remove-indv D119_3       --vcf filtered_snps_ledwell.vcf.recode.vcf --recode --out filtered_snps_ledwell_D119_3


# ./vcftools --vcf vcf_file1.vcf --weir-fst-pop individual_list_1.txt 
#  --weir-fst-pop individual_list_2.txt

# pop over to vcftools

#############

gd <- read.table("lampreys_pi.windowed.pi", header=T)
head(gd)
summary(gd$PI)



flag <- pop_code %in% c("anad_france", "anad_MA", "huron", "erie", "ontario", "superior", 
                        "michigan","chayuga", "seneca")
samp.sel <- sample.id[flag]
pop.sel <- pop_code[flag]

FSTs <- snpgdsFst(genofile, sample.id=samp.sel, population=as.factor(pop.sel),
          method="W&C84", autosome.only = F)

#kinship
sample.id <- read.gdsn(index.gdsn(genofile, "sample.id"))
snpset.id <- unlist(snpset)


ibd <- snpgdsIBDMoM(genofile, sample.id=sample.id, snp.id=snpset.id,
                    maf=0.05, missing.rate=0.05, num.thread=2, autosome.only = F)
ibd.coeff <- snpgdsIBDSelection(ibd)
head(ibd.coeff)
ibd.coeff

plot(ibd.coeff$k0, ibd.coeff$k1, xlim=c(0,1), ylim=c(0,1),xlab="k0", ylab="k1", main="YRI samples (MoM)")
lines(c(0,1), c(1,0), col="red", lty=2)

snp.id <- sample(snpset.id, 5000)# random 5000 SNPs
ibd <- snpgdsIBDMLE(genofile, sample.id=sample.id, snp.id=snp.id,maf=0.05, missing.rate=0.05, autosome.only = F)
ibd.coeff <- snpgdsIBDSelection(ibd)
ibd.coeff


## Smaller data        
snps1 <- read.vcfR("lampreys_no_indels_maf05_thinned1K.vcf.gz")
gl1 <- vcfR2genlight(snps1)

# funny business due to cutting down data I suspect
toRemove <- is.na(glMean(gl1, alleleAsUnit = FALSE)) # TRUE where NA
which(toRemove) # position of entirely non-typed loci
gl2 <- gl1[, !toRemove]      


glPca(gl2)                  
                  