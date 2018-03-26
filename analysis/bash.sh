#!/bin/bash

## 1. convert bam to fasta & concatenate ###############

cd ../data/ # the place to put PacBio CCS bam files
bash convert_bam_to_fasta.sh # samtools & seqtk are required

cd ../analysis/
cat ../data/*.fasta >> all.fa 

######################################################


## 2. demultiplex and cluster #######

bash fa_ROW.COL.DV.sh # gather sequences based on ROW-COL barcodes & DV sequences

bash table_ROW.COL.sh # a brief summary table

bash muscle.sh # muscle is required; this step may take several hours, which depends on the number of reads

Rscript find_consensus_recursive.r  20 200 3000 
# 20 is the length difference cutoff for the initial hierarchical clustering to identify small clusters
# 200 & 3000 are the cutoffs of the sequence length; <200 or >3000 are excluded

Rscript combine_identical_consensus.r # merge identical sequences from different clusters

Rscript create_consensus_table.r # calculate deletion/insertion/substitution of each raw CCS

bash fa_consensus_trim.sh 

bash fa_consensus_rmJn.sh

########################################################


## 3. create customized tables (search against IMGT) ##

# search against IMGT first, create & save results in the "IMGT" folder; then run the following steps
Rscript create_consensus_IMGT_tbl.r 

Rscript create_summary_table.r cell_barcode/cell*.txt # barcodes of different cells

# remove Tg sequence and create tables
cat ./fa_consensus/*_consensus.fa | seqkit grep  -w 0 -s -r -i -p GCATGGGCTGAGGCTGATCCATTATTCATATGGTGCTGGCAGCACTGAGAAAGGAGATATCCCTGATGGATACAAGGCCTCCAGACCAAGCCAAGAGAACTTCTCCCTCATTCTGGAGTTGGCTACCCCCTCTCAGACATCAGTGTACTTCTGTGCCAGCGGCTCCGGGACAACAAACACAGAAGTCTTCTTTGGTAAAGGAACCAGACTCACAGTTGTAG > fa_consensus_Tg.fa

Rscript create_summary_table_rmTg.r cell_barcode/cell*.txt

#######################################################
