#!/bin/bash
echo "### $0 ###"                        >> ./analysis.log.txt
echo "### $0 ###" 
# usage:   bash 43a_CDR3.sh

OUTdir=./table43a_CDR3
mkdir -p ${OUTdir}

OUTtxt=${OUTdir}/CDR3.txt
echo "DV Cluster Tag Functionality TRBV TRBJ rmJn CDR3-IMGT_amino_acid bp cluaster_consensus_rmJn_nucleotide_sequence" > ${OUTtxt}

IMGTaa=./table41_IMGT/4_AA.txt
CODEfile=./table42_consensus_code_IMGT.csv
TAGfile=./table43_consensus_tag_IMGT.csv

for FILE in ./fa_consensus_rmJn/ROW*_consensus.rmJn.fa
do
    cluster=$(basename $FILE _consensus.rmJn.fa)

    cdr3=$(         cat ${IMGTaa}  | grep "${cluster}" | awk 'BEGIN {FS="\t"} {print $15}' )
    tag=$(          cat ${TAGfile} | grep "${cluster}" | awk 'BEGIN {FS=","}  {print $10}' | sed -e 's/ //g' ) 
    functionality=$(cat ${TAGfile}| grep "${cluster}" | awk 'BEGIN {FS=","} {print $11}' | tr '\n' ' ' | sed -e 's/ //g')
    trbv=$(         cat ${TAGfile} | grep "${cluster}" | awk 'BEGIN {FS=","} {print $12}' | sed -e 's/x.*//g' | sed -e 's/Musmus//g' | sed -e 's/"//g' | sed -e 's/ //g' | sed -e 's/_//g') 
    trbj=$(         cat ${TAGfile} | grep "${cluster}" | awk 'BEGIN {FS=","} {print $13}' | sed -e 's/x.*//g' | sed -e 's/Musmus//g' | sed -e 's/"//g' | sed -e 's/ //g' | sed -e 's/_//g') 
    rmJn=$(         cat ${IMGTaa}  | grep "${cluster}" | awk 'BEGIN {FS="\t"} {print $2}' | rev | cut -c 1-6 | rev | uniq )
    seq=$(cat $FILE | tail -n 1  | tr [A-Z] [a-z] )
    length=$(echo "${seq}" | wc -c )
    bp=$(echo "${length} - 1" | bc )
    dv2=$(echo "${cluster}" | sed -e 's/DV/___________/g' | sed -e 's/cluster/__________cluster/g' | cut -c 19-30 | sed -e 's/_//g' )
    
    echo "${dv2} ${cluster} ${tag}zzz ${functionality}zzz ${trbv}zzz ${trbj}zzz ${rmJn} ...${cdr3}... ${bp} ${seq}" >> ${OUTtxt}
done

cat ${OUTtxt} | sort -k1n -k5 -k6 -k8 > ${OUTdir}/CDR3.sorted.txt
cat ${OUTdir}/CDR3.sorted.txt | awk 'BEGIN {OFS=","} {print $2,$3,$4,$5,$6,$7,$8,$9,$10}' | sed -e 's/zzz//g' > ${OUTdir}/CDR3.csv
cat ${OUTdir}/CDR3.sorted.txt | awk 'BEGIN {OFS=","} $9 >= 500 {print $2,$3,$4,$5,$6,$7,$8,$9,$10}' > ${OUTdir}/CDR3.long.csv


# BASH DONE