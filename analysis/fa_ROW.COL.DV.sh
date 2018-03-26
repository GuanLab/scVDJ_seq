#!/bin/bash

# This file is adapted from Tomo's code - fa_ROW.COL.DV.sh

START=$(date)

# starting with barcode-AF
mkdir -p fa_ROW
input=all.fa

bcfile="../barcode/bc_row.txt"
i="1"
while read -r line
do
    barcode="$line"
    echo "$barcode"
    cat $input | seqkit grep -w 0 -s -r -i -p "^${barcode}" > fa_ROW/ROW${i}.fa
    let "i++"
done < "$bcfile"

# ending with barcode-AF
bcfile="../barcode/bc_row_rc.txt"
i="1"
while read -r line
do
    barcode="$line"
    echo "$barcode"
    cat $input | seqkit grep -w 0 -s -r -i -p "${barcode}$" | seqkit seq -w 0 -rp | sed -e 's/>/>rc./g' >> fa_ROW/ROW${i}.fa
    let "i++"
done < "$bcfile"

# ending with barcode-AR3 in "./fa_ROW/ROW*.fa" 
mkdir -p fa_ROW.COL

bcfile="../barcode/bc_col_rc.txt"
i="1"
while read -r line
do
    barcode="$line"
    echo "$barcode"

    for FILE in ./fa_ROW/ROW*.fa
    do
    seqkit grep -w 0 -s -r -i -p "${barcode}$" $FILE > fa_ROW.COL/$(basename $FILE .fa).COL${i}.fa
    done
    let "i++"
done < "$bcfile"

# V or D primers
mkdir -p fa_ROW.COL.DV

bcfile="../barcode/DV_seq.txt"
i="1"
while read -r line
do
    barcode="$line"
    echo "$barcode"

    for FILE in fa_ROW.COL/*.fa
    do
    # barcode 14 bp, AF 18 bp, DV, 17-25 bp
    seqkit grep -w 0 -s -R 33:57 -r -i -p "$barcode" $FILE > fa_ROW.COL.DV/$(basename $FILE .fa).DV${i}.fa
    done

let "i++"
done < "$bcfile"

find ./fa_ROW.COL.DV -type f -empty -delete

# DONE
END=$(date)
echo "***DONE"
echo "$START - $END"
#Fri Jan 19 13:11:43 EST 2018 - Fri Jan 19 13:36:37 EST 2018




