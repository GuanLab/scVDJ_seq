#!/bin/bash

# muscle alignment

START=$(date)

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

# DONE
END=$(date)
echo "***DONE"
echo "$START - $END"

#Sat Jan 27 16:20:21 EST 2018 - Sat Jan 27 17:02:00 EST 2018
