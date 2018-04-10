#!/bin/bash
echo "### $0 ###"                        >> ./analysis.log.txt
echo "### $0 ###" 
# usage:   bash 45a_sampleID_CDR3.sh

OUTdir=./table_sampleID

for FILE in ${OUTdir}/cluster_consensus_tag_IMGT_*.csv
do
    echo "$FILE"
    sampleID=$(basename $FILE .csv | sed -e 's/cluster_consensus_tag_IMGT_//g' )
    
    OUTtxt=${OUTdir}/CDR3_${sampleID}.txt
    cat ./table43a_CDR3/CDR3.txt | head -n 1 > ${OUTtxt}
    
    bcfile="$FILE"
    i="1"
    while read -r line
    do
        barcode=$(echo "$line" | awk 'BEGIN {FS=","} {print $1}' | sed -e 's/"//g' )
        cat ./table43a_CDR3/CDR3.txt | grep "${barcode}" >> ${OUTtxt}
        
    let "i++"
    done < "$bcfile"    
    
    cat ${OUTtxt} | sort -k1n -k5 -k6 -k8 | awk 'BEGIN {OFS=","} {print $2,$3,$4,$5,$6,$7,$8,$9,$10}' | sed -e 's/zzz//g' > ${OUTdir}/CDR3_sorted_${sampleID}.csv
    
done


# BASH DONE