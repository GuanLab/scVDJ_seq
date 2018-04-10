#!/bin/bash
DATEstart=$(date)
echo "### $0 ###"                                                          >> ./analysis.log.txt
echo "### $DATEstart ------------------------------ ### START ### $0 ###"  >> ./analysis.log.txt
echo "### $DATEstart ------------------------------ ### START ### $0 ###"  
# usage:   bash 28_stats.sh

CCS=$(cat all.fa | grep ">" | wc -l )
BARCODED=$(cat ./fa_ROW.COL/*.fa | grep ">" | wc -l )
F1=$(echo " 100 * ${BARCODED} / ${CCS} " | bc )
CLUSTER=$(find ./fa_consensus/*_consensus.fa | wc -l )
rmJn=$(find ./fa_consensus_rmJn/*_consensus.rmJn.fa | wc -l )
DV1=$(find ./fa_consensus/*_consensus.fa | grep  "DV1_cluster" | wc -l )
DV2=$(find ./fa_consensus/*_consensus.fa | grep  "DV2_cluster" | wc -l )

echo "### ${CCS}  CCSs found in all.fa"                                                  >> ./analysis.log.txt
echo "### ${BARCODED}  CCSs have barcode-AF and barcode-AR3 primers flanking each end of the CCS "  >> ./analysis.log.txt
echo "###             ${F1}% of total CCSs"                                              >> ./analysis.log.txt
echo "### ${CLUSTER}  total   clusters generated in ./fa_consensus"                      >> ./analysis.log.txt
echo "### ${rmJn} clusters are with V  nested primer sequence in ./fa_consensus_rmJn"    >> ./analysis.log.txt
echo "### ${DV1}  clusters are with D1 nested primer seque nce in ./fa_consensus"        >> ./analysis.log.txt
echo "### ${DV2}  clusters are with D2 nested primer sequence in ./fa_consensus"         >> ./analysis.log.txt

echo "total_CCSs,CCSs_ROW_COL,clusters,V,D1,D2" > ./table28_stats.csv
echo "${CCS},${BARCODED},${CLUSTER},${rmJn},${DV1},${DV2}" >> ./table28_stats.csv

# BASH DONE
DATEend=$(date)
echo "### $DATEstart - $DATEend ### DONE  ### $0 ###"
echo "### $DATEstart - $DATEend ### DONE  ### $0 ###"  >> ./analysis.log.txt
echo " "                                               >> ./analysis.log.txt
