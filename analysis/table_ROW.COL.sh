#!/bin/bash
# number of CCS in each well (ROW.COL)
# usage:  bash table_ROW.COL.sh
START=$(date)

echo -n > table_ROW.COL.txt

for i in `seq 1 192`
do
    for j in `seq 1 12`
    do
        barcode=ROW${i}.COL${j}
        N=$(cat ./fa_ROW.COL/ROW${i}.COL${j}.fa | wc -l)
        echo "$barcode $N" | awk 'BEGIN{OFS="\t"}{print $1,$2}' >> table_ROW.COL.txt

    done
done

# DONE
END=$(date)
echo "***DONE"
echo "$START - $END"

