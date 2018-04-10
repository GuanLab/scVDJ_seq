#!/bin/bash
DATEstart=$(date)
PWD=$(pwd)
echo "*** $PWD/$0 ***"                                                     >> ./analysis.log.txt
echo "*** $DATEstart ------------------------------ *** START *** $0 ***"  >> ./analysis.log.txt
echo "*** $DATEstart ------------------------------ *** START *** $0 ***"  

######################################################################
## 1. convert bam to fasta & concatenate ###############

######################################################################
## 2. demultiplex and cluster ###############

# need  ./all.fa
if [ -e ./all.fa  ]; then 
    N=$(cat ./all.fa | grep ">" | wc -l )
    echo "*** $N CCSs found in ./all.fa"
    echo "*** $N CCSs found in ./all.fa" >> ./analysis.log.txt
else
    echo "*** ERROR   No ./all.fa   file is found"
    echo "*** exit  $0 "
    exit
fi

bash 21_fa_ROW.COL.DV.sh   # gather sequences based on ROW-COL barcodes & DV sequences
bash 22_count_ROW.COL.sh   # a brief summary table
bash 23_muscle.sh          # muscle is required; this step may take several hours

date >> ./analysis.log.txt
echo "*** 24_find_consensus_recursive.r  20 200 3000 *** START Rscript ***" >> ./analysis.log.txt
Rscript 24_find_consensus_recursive.r  20 200 3000 
   # 20 is the length difference cutoff for the initial hierarchical clustering to identify small clusters
   # 200 & 3000 are the cutoffs of the sequence length; <200 or >3000 are excluded

date >> ./analysis.log.txt
echo "*** 25_combine_identical_consensus.r *** START Rscript ***" >> ./analysis.log.txt
Rscript 25_combine_identical_consensus.r   # merge identical sequences from different clusters

date >> ./analysis.log.txt
echo "*** 26_create_consensus_table.r *** START Rscript*** " >> ./analysis.log.txt
Rscript 26_create_consensus_table.r        # calculate deletion/insertion/substitution of each raw CCS

bash 27_consensus_V_trim_rmJn.sh           # remove adapter and extra J region
bash 28_stats.sh                           # stats

######################################################################
## 3. IMGT ###########

# IMGT/HighV-QUEST
# http://www.imgt.org/

######################################################################
## 4. create customized tables ##############

######################################################################
## 5. (optional) remove clusters for Tg ##############

######################################################################

# BASH DONE
DATEend=$(date)
echo "*** $DATEstart - $DATEend *** DONE  *** $0 ***"
echo "*** $DATEstart - $DATEend *** DONE  *** $0 ***"  >> ./analysis.log.txt
echo " "                                               >> ./analysis.log.txt
