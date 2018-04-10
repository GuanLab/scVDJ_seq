#!/bin/bash
DATEstart=$(date)
echo "*** $0 ***"                                                          >> ./analysis.log.txt
echo "*** $DATEstart ------------------------------ *** START *** $0 ***"  >> ./analysis.log.txt
echo "*** $DATEstart ------------------------------ *** START *** $0 ***"  
# usage:   23_muscle.sh

# muscle alignment
mkdir -p ./muscle_fastaout
mkdir -p ./muscle_htmlout
mkdir -p ./muscle_fastaout_nowrap

for FILE in ./fa_ROW.COL.DV/ROW*.fa
do
    muscle -in $FILE -fastaout ./muscle_fastaout/$(basename $FILE .fa).afa -htmlout ./muscle_htmlout/$(basename $FILE .fa).html
done

echo "nowrap.afa"
for FILE in ./muscle_fastaout/ROW*.afa
do
    cat $FILE | seqkit seq -w 0 > ./muscle_fastaout_nowrap/$(basename $FILE .afa).fa
done


# BASH DONE
DATEend=$(date)
echo "*** $DATEstart - $DATEend *** DONE  *** $0 ***"
echo "*** $DATEstart - $DATEend *** DONE  *** $0 ***"  >> ./analysis.log.txt
echo " "                                               >> ./analysis.log.txt
