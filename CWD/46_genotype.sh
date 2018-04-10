#!/bin/bash
echo "### $0 ###"                        >> ./analysis.log.txt
echo "### $0 ###" 
# usage:  bash 46_pattern.sh

# genotype
OUTdir=./table_sampleID
mkdir -p ${OUTdir}

for FILE in ../barcode_sampleID/IDcell_*.txt
do 
    sampleID=$(basename $FILE .txt | sed -e 's/IDcell_//g')
    echo "$FILE"    
        
# tags and genotype for each cell
    TAGfile=${OUTdir}/cluster_consensus_tag_IMGT_${sampleID}.csv

    OUTcell=${OUTdir}/CELL_tags_pattern_${sampleID}.csv
        echo -n > $OUTcell
    
    bcfile="$FILE"
    i="1"
    while read -r line
    do
        barcode="$line"
        TAGs=$(cat ${TAGfile} | grep "${barcode}.DV" | awk 'BEGIN{FS=","}{print $9}' | sort | tr '\n' ',' )
        TAG4=$(echo "${TAGs},__,__,__,__" | sed -e 's/ //g' | sed -e 's/^,//g' | sed -e 's/,,/,/g' | awk 'BEGIN{FS=",";OFS=","}{print $1,$2,$3,$4}' | sed -e 's/"//g' )
        genotype=$(cat ../barcode/genotype_tag.csv | grep "${TAG4}" | awk 'BEGIN{FS=",";OFS=","}{print $5,$6,$7}' ) 
        
        echo "${barcode},${TAG4},${genotype}" >> $OUTcell

    let "i++"
    done < "$bcfile" 
    
# count_pattern
    OUTpat=${OUTdir}/pattern_full_${sampleID}.csv
    echo "tag,tag,tag,tag,pattern,genotype,ID,count_cell" > $OUTpat
    
    list="../barcode/genotype_tag.csv"
    i="1"
    while read -r line
    do
        genotype="$line"
        count=$(cat $OUTcell | grep "$genotype" | wc -l )
        echo "${genotype},${count}" >> $OUTpat
    
    let "i++"
    done < "$list"    
    
# short list for IDcell_*_genotype_full.csv
    cat $OUTpat | awk ' BEGIN{FS=","} $8 >=1 ' > ${OUTdir}/pattern_short_${sampleID}.csv
    
# count_genotype
    ID1=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==1 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID2=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==2 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID3=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==3 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID4=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==4 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID5=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==5 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID6=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==6 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID7=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==7 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID8=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==8 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID9=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==9 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID10=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==10 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID11=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==11 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID12=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==12 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID13=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==13 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID14=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==14 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    ID15=$(cat $OUTpat | awk ' BEGIN{FS=","} $7 ==15 ' | awk 'BEGIN{FS=","}{sum+=$8}END{print sum}' )
    pp=$(echo "$ID10 + $ID11" | bc  )
    
    OUTgen=${OUTdir}/count_genotype_${sampleID}.csv
    echo "sampleID,GL_GL,DJ_GL,DJ_DJ,uVDJ_GL,pVDJ_GL,uVDJ_DJ,pVDJ_DJ,uVDJ_uVDJ,uVDJ_pVDJ,pVDJ_pVDJ,ID12,ID13,ID14,ID15" > $OUTgen
    echo "${sampleID},$ID1,$ID2,$ID3,$ID4,$ID5,$ID6,$ID7,$ID8,$ID9,$pp,$ID12,$ID13,$ID14,$ID15" >> $OUTgen
    
done

# BASH DONE
