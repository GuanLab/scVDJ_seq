#!/bin/bash
echo "### $0 ###"                        >> ./analysis.log.txt
echo "### $0 ###" 
# usage:   bash 44_list_maybe_error.sh

# list clusters maybe error (simialr length of multiple clusters in a cell)
# wrote by Tomo,  Mar 29, 2018
    # list in maybe_error_remove.auto.txt
    # similar length (<10 bp) of multiple clusters in a cell
    # 12 out of 12 clusters were confirmed (1-6 bp deletion) in sample1230
    # @@@  Hongyang might have better idea  @@@ 

tagIMGT=./table43_consensus_tag_IMGT.csv
OUTdir=./table44_maybe_error
mkdir -p ${OUTdir}

C2=$(find ./fa_consensus/*cluster2_consensus.fa | wc -l ) 
if [ $C2 -gt 0 ]; then
    echo "*** $C2  ./fa_consensus/*cluster2_consensus.fa  exist"
else
    echo -n > ${OUTdir}/maybe_error.auto.txt
    echo "*** No cluster2_consensus.fa" >> ./analysis.log.txt
    echo "*** No cluster2_consensus.fa"
    echo "*** skip $0 "
    exit
fi

# generate list for barcode with 2 clusters
OUTmulti=${OUTdir}/multiple_cluster_ROW.COL.DV.txt
OUTstat=${OUTdir}/multiple_cluster_stats.txt
    echo -n > $OUTmulti
    echo "barcode  num_seqs  min_len  max_len  max-min" | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,$5,$6,$7}' > $OUTstat

for FILE in ./fa_consensus/*cluster2_consensus.fa
do
    RCDV=$(basename $FILE cluster2_consensus.fa)
    echo "${RCDV}" >> $OUTmulti
    STAT=$(cat ./fa_consensus/${RCDV}cluster*_consensus.fa | seqkit stats | tail -n 1 | sed -e 's/,//g' )
    echo "${RCDV} $STAT" | awk 'BEGIN{OFS="\t"}{print $1,$5,$7,$9,$9-$7}' >> $OUTstat
done

cat $OUTmulti | sed -e "s/DV.*//g" | sort | uniq > ${OUTdir}/multiple_cluster_ROW.COL.txt

# sorted.csv
(head -n +1 $OUTstat && tail -n +2 $OUTstat | sort -k 5n ) | awk 'BEGIN{OFS=","}{print $1,$2,$3,$4,$5}'　> ${OUTdir}/multiple_cluster_stats_sorted.csv

# maybe error 
    # simialr length (<10 bp) of multiple clusters in a cell
    # generate cluster_consensus FASTA files
    # copy related muscle_html
    # generate list of clusters to remove for now (lower num_seqs or shorter)

OUTerror1=${OUTdir}/maybe_error_ROW.COL.DV.txt
OUTerror2=${OUTdir}/maybe_error.auto.txt
    echo -n > $OUTerror1
    echo -n > $OUTerror2

cat $OUTstat | awk '$2 ==2' | awk '$5 <=10' | awk '{print $1}' > $OUTerror1
cat $OUTstat | sed -e 1d | awk '$2 >=3' | awk '{print $1}' >> $OUTerror1
cat $OUTerror1 | sed -e "s/DV.*//g" | sort | uniq > ${OUTdir}/maybe_error_ROW.COL.txt

bcfile="$OUTerror1"
i="1"
while read -r line
do
    barcode="$line"
    cat ./fa_consensus/${barcode}cluster*_consensus.fa > ${OUTdir}/${barcode}clusters_consensus.fa 
    
    MUSCLE=$(echo "$barcode" | sed -e 's/_/.html/g' )
    cp ./muscle_htmlout/$MUSCLE ${OUTdir}/$MUSCLE

    cat $tagIMGT | grep "${barcode}" | awk 'BEGIN {FS=","}{print $2,$3,$4}' | sed -e 's/"//g' | sort -k2nr -k3nr | sed -e 1d | awk '{print $1}' >> $OUTerror2
let "i++"
done < "$bcfile"

cp $OUTerror2 ${OUTdir}/maybe_error.manual.edit.txt

# CELLcluster for related 
CELLcluster1=${OUTdir}/CELLcluster.multiple.cluster.csv
CELLcluster2=${OUTdir}/CELLcluster.maybe.error.csv
    cat $tagIMGT | head -n 1 > $CELLcluster1
    cat $tagIMGT | head -n 1 > $CELLcluster2

bcfile="${OUTdir}/multiple_cluster_ROW.COL.txt"
i="1"
while read -r line
do
    barcode="$line"
    echo "---" >> $CELLcluster1
    echo "$barcode" >> $CELLcluster1
    cat $tagIMGT | grep "${barcode}DV" >> $CELLcluster1
let "i++"
done < "$bcfile"

bcfile="${OUTdir}/maybe_error_ROW.COL.txt"
i="1"
while read -r line
do
    barcode="$line"
    echo "---" >> $CELLcluster2
    echo "$barcode" >> $CELLcluster2
    cat $tagIMGT | grep "${barcode}DV" >> $CELLcluster2
let "i++"
done < "$bcfile"

# BASH DONE
