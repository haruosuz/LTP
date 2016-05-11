cat("\n  This R script analyzes multiple FASTA format sequences.\n\n")

# Set Working Directory
#setwd("~/projects/ltp/")

# Loading seqinr package
library(seqinr)

# Reading sequence data into R
ld <- read.fasta(file = "data/LTPs123_SSU.compressed.fasta", seqtype = c("DNA"))
#ld <- read.fasta(file = "data/tmp.fasta", seqtype = c("DNA"))

#setwd("~/projects/vfdb/"); ld <- read.fasta(file = "data/VFDB_setA_nt.fas", seqtype = c("DNA"))

# Writing sequence data out as a FASTA file
write.fasta(sequences=ld, names=getName(ld), file.out="data/sequence.fna")



cat("# How many sequences\n")
length(ld)

cat("# Length of sequences\n")
len <- sapply(ld, length); summary(len)

cat("# GC Content\n")
gcc <- sapply(ld, GC); summary(gcc)

# Get sequence annotations (FASTA headers)
ann <- unlist(getAnnot(ld))

# Exporting Data
d.f <- data.frame(len, gcc, ann)
colnames(d.f) <- c("Length", "GC Content", "FASTA header")
write.csv(d.f, file="analysis/table.na.csv")

> write.csv(d.f, file="analysis/table.na.csv")
Error in file(file, ifelse(append, "a", "w")) : 
  cannot open the connection
In addition: Warning message:
In file(file, ifelse(append, "a", "w")) :
  cannot open file 'analysis/table.na.csv': No such file or directory




# Print R version and packages
sessionInfo()




