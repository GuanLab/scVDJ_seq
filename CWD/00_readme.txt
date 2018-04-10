Brief instruction

########################################################
## Files required (tree view) ##########################
.
├── CWD
│   ├── 00_readme.txt
│   ├── 20_consensus.sh
│   ├── 21_fa_ROW.COL.DV.sh
│   ├── 22_count_ROW.COL.sh
│   ├── 23_muscle.sh
│   ├── 24_find_consensus_recursive.r
│   ├── 25_combine_identical_consensus.r
│   ├── 26_create_consensus_table.r
│   ├── 27_consensus_V_trim_rmJn.sh
│   ├── 28_stats.sh
│   ├── 40_table.sh
│   ├── 41_check_IDcell.sh
│   ├── 42_consensus_code_IMGT.r
│   ├── 43_tag.sh
│   ├── 44_list_maybe_error.sh
│   ├── 45_sampleID.r
│   ├── 46_genotype.sh
│   ├── 47_count.sh
│   ├── 48_summary.sh
│   ├── all.fa
│   └── IMGT.txz (after step 3)
├── barcode
│   ├── DV_seq.txt
│   ├── bc_col_rc.txt
│   ├── bc_row.txt
│   ├── bc_row_rc.txt
│   ├── genotype_tag.csv
│   └── germ_seq.txt
└── barcode_sampleID
    ├── IDcell_sampleA.txt
    ├── IDcell_sampleB.txt
    └── IDcell_sampleC.txt



## working directory ###################################
# cd CWD   # your preferred name

## Tools required  #####################################
# samtools     (http://www.htslib.org/)
# seqkit       (http://bioinf.shenwei.me/seqkit/)
# muscle       (http://www.drive5.com/muscle)


## 1. convert bam to fasta & concatenate ###############
 samtools fasta -0 OUT.fa IN.bam  # PacBio CCS bam file

## 2. demultiplex and cluster ##########################
# usage:   bash 20_consensus.sh

## 3. IMGT #############################################
# IMGT/HighV-QUEST
# http://www.imgt.org/

## 4. create customized tables #########################
# usage:   bash 40_table.sh

## 5. (optional) remove clusters for Tg ################



