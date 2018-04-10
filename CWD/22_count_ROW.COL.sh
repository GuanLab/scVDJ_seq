#!/bin/bash
DATEstart=$(date)
echo "*** $0 ***"                                                          >> ./analysis.log.txt
echo "*** $DATEstart ------------------------------ *** START *** $0 ***"  >> ./analysis.log.txt
echo "*** $DATEstart ------------------------------ *** START *** $0 ***"  
# usage:   bash 22_count_ROW.COL.sh

# number of CCS in each well (ROW.COL)
OUT=./table22_ROW.COL.full.txt
echo -n > $OUT

for i in `seq 1 200`
do
    for j in `seq 1 12`
    do
        barcode=ROW${i}.COL${j}
        N=$(cat ./fa_ROW.COL/ROW${i}.COL${j}.fa | wc -l)
        echo "$barcode $N" | awk 'BEGIN{OFS="\t"}{print $1,$2}' >> $OUT
    done
done

cat $OUT | awk 'BEGIN{OFS="\t"} $2 >0' > ./table22_ROW.COL.short.txt


# BASH DONE
DATEend=$(date)
echo "*** $DATEstart - $DATEend *** DONE  *** $0 ***"
echo "*** $DATEstart - $DATEend *** DONE  *** $0 ***"  >> ./analysis.log.txt
echo " "                                               >> ./analysis.log.txt