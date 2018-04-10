#!/bin/bash
echo "### $0 ###"                        >> ./analysis.log.txt
echo "### $0 ###" 
# usage:   bash 48_summary.sh

OUTdir=./table_summary
mkdir -p ${OUTdir}

outTAG=${OUTdir}/count_tag.csv
    echo "sampleID,D1_germ_J1,D2_germ_J2,D1_x_J1/g,D1_x_J2,D2_x_J2,D2_x_J1,uV_x_J1, uV_x_J2,uV31_x_J1,uV31_x_J2,pV_x_J1,pV_x_J2,pV31_x_J1,pV31_x_J2" > ${outTAG}
outGEN=${OUTdir}/count_genotype.csv
    echo "sampleID,GL/GL,DJ/GL,DJ/DJ,uVDJ/GL,pVDJ/GL,uVDJ/DJ,pVDJ/DJ,uVDJ/uVDJ,pVDJ/uVDJ,pVDJ/pVDJ,ID12,ID13,ID14,ID15" > ${outGEN}
outV=${OUTdir}/count_V_in_VDJ.csv
    echo "sampleID,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12-1,V12-2,V12-3,V13-1,V13-2,V13-3,V14,V15,V16,V17,V18,V19,V20,V21,V22,V23,V24,V25,V26,V27,V28,V29,V30,V31" > ${outV}
outJ=${OUTdir}/count_J_in_VDJ.csv
    echo "sampleID,J1-1,J1-2,J1-3,J1-4,J1-5,J1-6,J1-7,J2-1,J2-2,J2-3,J2-4,J2-5,J2-6,J2-7" > ${outJ}


for FILE in ../barcode_sampleID/IDcell_*.txt
do
    sampleID=$(basename $FILE .txt | sed -e 's/IDcell_//g')
    echo "${sampleID}"
    
    cat ./table_sampleID/count_tag_${sampleID}.csv | tail -n 1 >> ${outTAG}
    cat ./table_sampleID/count_genotype_${sampleID}.csv | tail -n 1 >> ${outGEN}
    cat ./table_sampleID/count_V_in_VDJ_${sampleID}.csv | tail -n 1 >> ${outV}
    cat ./table_sampleID/count_J_in_VDJ_${sampleID}.csv | tail -n 1 >> ${outJ}
done

# BASH DONE
