#!/bin/bash
echo "### $0 ###"                        >> ./analysis.log.txt
echo "### $0 ###" 
# usage:   bash 41_check_input_files.sh

# check ../barcode_sampleID/IDcell_*.txt
echo "### Number of barcode ROW.COL"     >> ./analysis.log.txt
echo "### Number of barcode ROW.COL"
wc -l ../barcode_sampleID/IDcell_*.txt   >> ./analysis.log.txt
wc -l ../barcode_sampleID/IDcell_*.txt 

cat ../barcode_sampleID/IDcell_*.txt | sort | uniq -d > ../barcode_sampleID/barcode_duplicate.txt
Ndup=$(cat ../barcode_sampleID/barcode_duplicate.txt | wc -l )

if [ ${Ndup} -gt 0 ]; then 
    echo "### ${Ndup} duplicate found for barcodes in  ../barcode_sampleID/IDcell_*.txt" >> ./analysis.log.txt
    echo "### ${Ndup} duplicate found for barcodes in  ../barcode_sampleID/IDcell_*.txt"
    echo "### ${Ndup} duplicate list is            in  ../barcode_sampleID/barcode_duplicate.txt"
fi

# check IMGT output
OUTdir=./table41_IMGT
mkdir -p ${OUTdir}

cat ./fa_consensus_rmJn/*.rmJn.fa | grep "cluster" | cut -c 2-                            | sort > ${OUTdir}/cluster_rmJn_fasta.txt
cat ./IMGT/4_IMGT-gapped-AA-sequences.txt | awk 'BEGIN {FS="\t"} {print $2}' | tail -n +2 | sort > ${OUTdir}/cluster_rmJn_IMGTout.txt

echo "cluster_rmJn_all.txt                                            cluster_rmJn_IMGTout.txt"  > ${OUTdir}/sdiff.txt
echo "---"                                                                      >> ${OUTdir}/sdiff.txt
echo "---"                                                                      >> ${OUTdir}/sdiff.txt
sdiff ${OUTdir}/cluster_rmJn_fasta.txt ${OUTdir}/cluster_rmJn_IMGTout.txt | grep -2 "<" >> ${OUTdir}/sdiff.txt
echo "---"                                                                      >> ${OUTdir}/sdiff.txt
echo "---"                                                                      >> ${OUTdir}/sdiff.txt
sdiff ${OUTdir}/cluster_rmJn_fasta.txt ${OUTdir}/cluster_rmJn_IMGTout.txt | grep -2 ">" >> ${OUTdir}/sdiff.txt

Ndiff=$(cat ${OUTdir}/sdiff.txt | wc -l )
if [ ${Ndiff} == 5 ]; then 
    echo "### IMGT output looks OK"
    cat ./IMGT/4_IMGT-gapped-AA-sequences.txt | sed -e 's/ /_/g' | sed -e 's/*/x/g' | sed -e 's/,//g' > ${OUTdir}/4_AA.txt
    exit
else
    echo "### ERROR was found in IMGT output"
fi

# prepare for manual edit
cat ${OUTdir}/sdiff.txt | grep "<" | sed -e 's/<//g' > ${OUTdir}/error_missing.txt
cat ${OUTdir}/sdiff.txt | grep ">" | sed -e 's/>//g' | tr '\t' ' ' | sed -e 's/ //g' > ${OUTdir}/error_extra.txt

echo "### Here are ERROR missing VDJ clusters.  Details are in  ${OUTdir}/sdiff.txt "
SDIFF=${OUTdir}/sdiff.fa
echo -n > ${SDIFF}

list="${OUTdir}/error_missing.txt"
i="1"
while read -r line
do
    echo "  ${line}"
    cluster=$(echo "${line}" | sed -e 's/_consensus.*//g' )
    cat ./fa_consensus_rmJn/${cluster}_consensus.rmJn.fa >> ${SDIFF}
let "i++"
done < "$list"

echo "### Here are ERROR extra VDJ clusters.    Details are in  ${OUTdir}/sdiff.txt"
cat ./IMGT/4_IMGT-gapped-AA-sequences.txt > ${OUTdir}/temp1.txt
list="${OUTdir}/error_extra.txt"
i="1"
while read -r line
do
    echo "  ${line}"
    cluster=$(echo "${line}" | sed -e 's/_consensus.*//g')
    cat ./fa_consensus_rmJn/${cluster}_consensus.rmJn.fa >> ${SDIFF}
    cat ${OUTdir}/temp1.txt | grep -v "${cluster}" > ${OUTdir}/temp2.txt
    cat ${OUTdir}/temp2.txt > ${OUTdir}/temp1.txt
let "i++"
done < "$list"

cat ${OUTdir}/temp1.txt | sed -e 's/ /_/g' | sed -e 's/*/x/g' | sed -e 's/,//g' > ${OUTdir}/4_AA.txt
echo "### These ERROR extra VDJ clusters were removed."

EDITman=${OUTdir}/4_AA_add_manually.txt
echo "barcode_cluster,functionality,TRBV,TRBJ,CDR3_IMGT,copy_this_row_to_edit_###_avoid_space_###" >> ${EDITman}
echo "barcode_cluster,functionality,TRBV,TRBJ,CDR3_IMGT,copy_this_row_to_edit_###_avoid_space_###" >> ${EDITman}

echo " "
echo "### Here are VDJ clusters that IMGT data were manually edited, and will be re-added. "

cat ${EDITman} | grep -v "barcode_cluster" > ${OUTdir}/41_edited.csv

bcfile="${OUTdir}/41_edited.csv"
i="1"
while read -r line
do
    cluster=$(echo "$line"   | awk 'BEGIN {FS=","}{print $1}' | sed -e 's/"//g' | sed -e 's/ //g' )
    echo "${cluster}"
    function=$(echo "$line"  | awk 'BEGIN {FS=","}{print $2}' | sed -e 's/"//g' | sed -e 's/ //g' | tr [A-Z] [a-z] )
    trbv=$(echo "$line"      | awk 'BEGIN {FS=","}{print $3}' | sed -e 's/"//g' | sed -e 's/ //g')
    trbj=$(echo "$line"      | awk 'BEGIN {FS=","}{print $4}' | sed -e 's/"//g' | sed -e 's/ //g')
    cdr3=$(echo "$line"      | awk 'BEGIN {FS=","}{print $5}' | sed -e 's/"//g' | sed -e 's/ //g')
    echo "   functionality=   ${function}"
    echo "   TRBV=            ${trbv}"
    echo "   TRBJ=            ${trbj}"
    echo "   CDR3=            ${cdr3}"
let "i++"
done < "$bcfile"

echo "### If this is as expected, continue."
echo "### If this is NOT expected, re-edit or remove  ${EDITman}"
echo " "

# add edited IMGT to  ${OUTdir}/4_AA.txt
bcfile="${OUTdir}/41_edited.csv"
i="1"
while read -r line
do
    cluster=$(echo "$line"   | awk 'BEGIN {FS=","}{print $1}' | sed -e 's/"//g' | sed -e 's/ //g' )
    function=$(echo "$line"  | awk 'BEGIN {FS=","}{print $2}' | sed -e 's/"//g' | sed -e 's/ //g' | tr [A-Z] [a-z] )
    trbv=$(echo "$line"      | awk 'BEGIN {FS=","}{print $3}' | sed -e 's/"//g' | sed -e 's/ //g')
    trbj=$(echo "$line"      | awk 'BEGIN {FS=","}{print $4}' | sed -e 's/"//g' | sed -e 's/ //g')
    cdr3=$(echo "$line"      | awk 'BEGIN {FS=","}{print $5}' | sed -e 's/"//g' | sed -e 's/ //g')
    echo "manual,${cluster},${function},${trbv},${trbj},-,-,-,-,-,-,-,-,-,${cdr3},-,-,-"  | awk 'BEGIN {FS=",";OFS="\t"}{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}' >> ${OUTdir}/4_AA.txt

let "i++"
done < "$bcfile"




# BASH DONE
