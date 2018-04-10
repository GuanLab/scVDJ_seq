#!/bin/bash
echo "### $0 ###"                        >> ./analysis.log.txt
echo "### $0 ###" 
# usage:  bash 43_tag.sh

# convert code to tag
# wrote by Tomo, Mar 31, 2018

OUTdir=./table43_tag
mkdir -p ${OUTdir}

# tag
cat table42_consensus_code_IMGT.csv |
		sed -e 's/"1","0","1","1","0","0","0",NA/ D1_germ_J1,_,_,_,_,_,_,NA/g' |
		sed -e 's/"0","1","0","0","1","1","0",NA/ D2_germ_J2,_,_,_,_,_,_,NA/g' |
		sed -e 's/"0","0","1","1","0","0","0",NA/ D1_x_J1,_,_,_,_,_,_,NA/g' |
		sed -e 's/"0","0","1","0","0","1","0",NA/ D1_x_J2,_,_,_,_,_,_,NA/g' |
		sed -e 's/"0","0","0","0","1","1","0",NA/ D2_x_J2,_,_,_,_,_,_,NA/g' |
		sed -e 's/"0","0","0","1","1","0","0",NA/ D2_x_J1,_,_,_,_,_,_,NA/g' |
		sed -e 's/"0","0","0","1","0","0","0","unproductive"/ uV_x_J1,_,_,_,_,_,_,unproductive/g' |
		sed -e 's/"0","0","0","0","0","1","0","unproductive"/ uV_x_J2,_,_,_,_,_,_,unproductive/g' |
		sed -e 's/"0","0","0","1","0","0","1","unproductive"/ uV31_x_J1,_,_,_,_,_,_,unproductive/g' |
		sed -e 's/"0","0","0","0","0","1","1","unproductive"/ uV31_x_J2,_,_,_,_,_,_,unproductive/g' |
		sed -e 's/"0","0","0","1","0","0","0","productive"/ pV_x_J1,_,_,_,_,_,_,productive/g' |
		sed -e 's/"0","0","0","0","0","1","0","productive"/ pV_x_J2,_,_,_,_,_,_,productive/g' |
		sed -e 's/"0","0","0","1","0","0","1","productive"/ pV31_x_J1,_,_,_,_,_,_,productive/g' |
		sed -e 's/"0","0","0","0","0","1","1","productive"/ pV31_x_J2,_,_,_,_,_,_,productive/g' |
        sed -e 's/"germ_DJ1","germ_DJ2","D1","J1","D2","J2","DV34","Functionality"/tag,b1,b2,b3,b4,b5,b6,Functionality/g' > ${OUTdir}/tag_initial.csv

CSVok=${OUTdir}/tag_converted.csv
CSVerror=${OUTdir}/tag_error.csv
    cat ${OUTdir}/tag_initial.csv | grep -v '"0"' > ${CSVok}
    cat ${OUTdir}/tag_initial.csv | grep '"0"' > ${CSVerror}

Nerror=$(cat ${CSVerror} | wc -l)
if [ ${Nerror} == 0 ]; then 
    echo "### tag converted successfully"
    cat ${CSVok} | awk 'BEGIN {FS=",";OFS=","}{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$17,$18,$19}' > ./table43_consensus_tag_IMGT.csv
    exit
else
    echo "### Error was found for the following clusters, and they were removed."
fi

# prepare for manual edit
TXTerror=${OUTdir}/tag_error.txt
    echo -n > ${TXTerror}

bcfile="${CSVerror}"
i="1"
while read -r line
do
    cluster=$(echo "$line" | awk 'BEGIN {FS=","}{print $1}' | sed -e 's/"//g')
        if [ -e ./fa_consensus_rmJn/${cluster}_consensus.rmJn.fa ]; then 
        cp ./fa_consensus_rmJn/${cluster}_consensus.rmJn.fa ${OUTdir}/${cluster}_consensus.rmJn.fa
        cat ${OUTdir}/${cluster}_consensus.rmJn.fa | head -n 1 >> ${TXTerror}
        cat ${OUTdir}/${cluster}_consensus.rmJn.fa | head -n 1
    else
        cp ./fa_consensus/${cluster}_consensus.fa ${OUTdir}/${cluster}_consensus.fa
        cat ${OUTdir}/${cluster}_consensus.fa | head -n 1 >> ${TXTerror}
        cat ${OUTdir}/${cluster}_consensus.fa | head -n 1
    fi
let "i++"
done < "$bcfile"

EDITman=${OUTdir}/tag_edit_manually.txt
echo "barcode_cluster,tag,Functionality,TRBV,TRBJ,copy_this_row_to_edit" | awk 'BEGIN{OFS="\t"} {print $1,$2,$3,$4,$5}' >> ${EDITman}
echo "barcode_cluster,tag,Functionality,TRBV,TRBJ,copy_this_row_to_edit" | awk 'BEGIN{OFS="\t"} {print $1,$2,$3,$4,$5}' >> ${EDITman}

echo "### fasta files for them are in  ${OUTdir}/"
echo "### manually edit  ${EDITman}"
echo "### And then, re-run 40_table.sh   (or 43_tag.sh first)"

echo " "
echo "### Here are VDJ clusters that tag/TRBV/TRBJ were manually edited, and will be re-added. "

cat ${EDITman} | grep -v "barcode_cluster" > ${OUTdir}/edited.csv

bcfile="${OUTdir}/edited.csv"
i="1"
while read -r line
do
    cluster=$(echo "$line" | awk 'BEGIN {FS=","}{print $1}' | sed -e 's/"//g' | sed -e 's/ //g' )
    echo "${cluster}"
    tag=$(echo "$line"  | awk 'BEGIN {FS=","}{print $2}' | sed -e 's/"//g' | sed -e 's/ //g' )
    function=$(echo "$line"  | awk 'BEGIN {FS=","}{print $3}' | sed -e 's/"//g' | sed -e 's/ //g' )
    trbv=$(echo "$line" | awk 'BEGIN {FS=","}{print $4}' | sed -e 's/"//g' | sed -e 's/ //g')
    trbj=$(echo "$line" | awk 'BEGIN {FS=","}{print $5}' | sed -e 's/"//g' | sed -e 's/ //g')
    echo "   tag=             ${tag}"
    echo "   Functionality=   ${function}"
    echo "   TRBV=            ${trbv}"
    echo "   TRBJ=            ${trbj}"
let "i++"
done < "$bcfile"

echo "### If this is as expected, continue."
echo "### If this is NOT expected, re-edit or remove  ${EDITman}"
echo " "

# add edited to   tag_converted.csv

bcfile="${OUTdir}/edited.csv"
i="1"
while read -r line
do
    cluster=$(echo "$line" | awk 'BEGIN {FS=","}{print $1}' | sed -e 's/"//g' | sed -e 's/ //g' )
    
    tag=$(echo "$line"  | awk 'BEGIN {FS=","}{print $2}' | sed -e 's/"//g' | sed -e 's/ //g' )
    function=$(echo "$line"  | awk 'BEGIN {FS=","}{print $3}' | sed -e 's/"//g' | sed -e 's/ //g' )
    trbv=$(echo "$line" | awk 'BEGIN {FS=","}{print $4}' | sed -e 's/"//g' | sed -e 's/ //g')
    trbj=$(echo "$line" | awk 'BEGIN {FS=","}{print $5}' | sed -e 's/"//g' | sed -e 's/ //g')
    consensus=$(cat ${CSVerror} | grep "${cluster}" | awk 'BEGIN {FS=",";OFS=","}{print $2,$3,$4,$5,$6,$7,$8,$9}' )
    
    echo "${cluster},${consensus},${tag},_,_,_,_,_,_,${function},${trbv},${trbj}" >> ${CSVok}
let "i++"
done < "$bcfile" 

cat ${CSVok} | awk 'BEGIN {FS=",";OFS=","}{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$17,$18,$19}' > table43_consensus_tag_IMGT.csv

# BASH DONE
