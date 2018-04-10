#!/bin/bash
echo "### $0 ###"                        >> ./analysis.log.txt
echo "### $0 ###" 
# usage:  bash 47_count.sh

# count

OUTdir=./table_sampleID
mkdir -p ${OUTdir}

for FILE in ../barcode_sampleID/IDcell_*.txt
do 
    sampleID=$(basename $FILE .txt | sed -e 's/IDcell_//g')
    echo "$FILE"    
    
    TAGfile=${OUTdir}/cluster_consensus_tag_IMGT_${sampleID}.csv

# count_tag
    T1=$(cat ${TAGfile} | grep "D1_germ_J1" | wc -l )
    T2=$(cat ${TAGfile} | grep "D2_germ_J2" | wc -l )
    T3=$(cat ${TAGfile} | grep "D1_x_J1" | wc -l )
    T4=$(cat ${TAGfile} | grep "D1_x_J2" | wc -l )
    T5=$(cat ${TAGfile} | grep "D2_x_J2" | wc -l )
    T6=$(cat ${TAGfile} | grep "D2_x_J1" | wc -l )
    T7=$(cat ${TAGfile} | grep "uV_x_J1" | wc -l )
    T8=$(cat ${TAGfile} | grep "uV_x_J2" | wc -l )
    T9=$(cat ${TAGfile} | grep "uV31_x_J1" | wc -l )
    T10=$(cat ${TAGfile} | grep "uV31_x_J2" | wc -l )
    T11=$(cat ${TAGfile} | grep "pV_x_J1" | wc -l )
    T12=$(cat ${TAGfile} | grep "pV_x_J2" | wc -l )
    T13=$(cat ${TAGfile} | grep "pV31_x_J1" | wc -l )
    T14=$(cat ${TAGfile} | grep "pV31_x_J2" | wc -l )

    OUTtag=${OUTdir}/count_tag_${sampleID}.csv
    echo "sampleID,D1_germ_J1,D2_germ_J2,D1_x_J1,D1_x_J2,D2_x_J2,D2_x_J1,uV_x_J1, uV_x_J2,uV31_x_J1,uV31_x_J2,pV_x_J1,pV_x_J2,pV31_x_J1,pV31_x_J2" > $OUTtag
    echo "$sampleID,$T1,$T2,$T3,$T4,$T5,$T6,$T7,$T8,$T9,$T10,$T11,$T12,$T13,$T14" >> $OUTtag
    
# count_V
    V1=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV1x" | wc -l)
    V2=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV2x" | wc -l)
    V3=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV3x" | wc -l)
    V4=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV4x" | wc -l)
    V5=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV5x" | wc -l)
    V6=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV6x" | wc -l)
    V7=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV7x" | wc -l)
    V8=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV8x" | wc -l)
    V9=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV9x" | wc -l)
    V10=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV10x" | wc -l)
    V11=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV11x" | wc -l)
    V12a=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV12-1x" | wc -l)
    V12b=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV12-2x" | wc -l)
    V12c=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV12-3x" | wc -l)
    V13a=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV13-1x" | wc -l)
    V13b=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV13-2x" | wc -l)
    V13c=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV13-3x" | wc -l)
    V14=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV14x" | wc -l)
    V15=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV15x" | wc -l)
    V16=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV16x" | wc -l)
    V17=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV17x" | wc -l)
    V18=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV18x" | wc -l)
    V19=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV19x" | wc -l)
    V20=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV20x" | wc -l)
    V21=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV21x" | wc -l)
    V22=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV22x" | wc -l)
    V23=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV23x" | wc -l)
    V24=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV24x" | wc -l)
    V25=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV25x" | wc -l)
    V26=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV26x" | wc -l)
    V27=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV27x" | wc -l)
    V28=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV28x" | wc -l)
    V29=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV29x" | wc -l)
    V30=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV30x" | wc -l)
    V31=$(cat ${TAGfile} | sed -e 's/*/x/g' | grep "TRBV31x" | wc -l)
    
    OUTv=${OUTdir}/count_V_in_VDJ_${sampleID}.csv
    echo "sampleID,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12-1,V12-2,V12-3,V13-1,V13-2,V13-3,V14,V15,V16,V17,V18,V19,V20,V21,V22,V23,V24,V25,V26,V27,V28,V29,V30,V31" > ${OUTv}
    echo "$sampleID,$V1,$V2,$V3,$V4,$V5,$V6,$V7,$V8,$V9,$V10,$V11,$V12a,$V12b,$V12c,$V13a,$V13b,$V13c,$V14,$V15,$V16,$V17,$V18,$V19,$V20,$V21,$V22,$V23,$V24,$V25,$V26,$V27,$V28,$V29,$V30,$V31" >> ${OUTv}
    
# count_J
    J11=$(cat ${TAGfile} | grep "TRBJ1-1" | wc -l)
    J12=$(cat ${TAGfile} | grep "TRBJ1-2" | wc -l)
    J13=$(cat ${TAGfile} | grep "TRBJ1-3" | wc -l)
    J14=$(cat ${TAGfile} | grep "TRBJ1-4" | wc -l)
    J15=$(cat ${TAGfile} | grep "TRBJ1-5" | wc -l)
    J16=$(cat ${TAGfile} | grep "TRBJ1-6" | wc -l)
    J17=$(cat ${TAGfile} | grep "TRBJ1-7" | wc -l)
    J21=$(cat ${TAGfile} | grep "TRBJ2-1" | wc -l)
    J22=$(cat ${TAGfile} | grep "TRBJ2-2" | wc -l)
    J23=$(cat ${TAGfile} | grep "TRBJ2-3" | wc -l)
    J24=$(cat ${TAGfile} | grep "TRBJ2-4" | wc -l)
    J25=$(cat ${TAGfile} | grep "TRBJ2-5" | wc -l)
    J26=$(cat ${TAGfile} | grep "TRBJ2-6" | wc -l)
    J27=$(cat ${TAGfile} | grep "TRBJ2-7" | wc -l)

    OUTj=${OUTdir}/count_J_in_VDJ_${sampleID}.csv
    echo "sampleID,J1-1,J1-2,J1-3,J1-4,J1-5,J1-6,J1-7,J2-1,J2-2,J2-3,J2-4,J2-5,J2-6,J2-7" > ${OUTj}
    echo "$sampleID,$J11,$J12,$J13,$J14,$J15,$J16,$J17,$J21,$J22,$J23,$J24,$J25,$J26,$J27" >> ${OUTj}

done

# BASH DONE
