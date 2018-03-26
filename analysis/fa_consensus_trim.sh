#!/bin/bash
# from consensus, remove barcode-adapter
# usage:  bash fa_consensus_trim.sh
START=$(date)

mkdir -p fa_consensus_trim

for FILE in ./fa_consensus/*_consensus.fa
do
    OUT=./fa_consensus_trim/$(basename $FILE .fa).trim.fa

    # seq_ID
    echo ">$(basename $FILE .fa).trim" > $OUT
    # remove barcode-AF (32bp) and barcode-AR3       (CCTGTGTGAAATTGTTATCCGC = AR3 reverse complement)
    cat $FILE | grep -v '>' |  cut -c 33- | sed -e "s/CCTGTGTGAAATTGTTATCCGC.*//g" >> $OUT
done

# find AF or AR3 sequence in the middle (potential multiple PCR productes ligated)
DUP=PCR_multiple.fa
echo -n > $DUP

# find AF
cat ./fa_consensus_trim/*.fa | grep -B1 "TGTAAAACGACGGCCAGT" >> $DUP
# find AF reverse complement
cat ./fa_consensus_trim/*.fa | grep -B1 "ACTGGCCGTCGTTTTACA" >> $DUP
# find AR3 reverse complement
cat ./fa_consensus_trim/*.fa | grep -B1 "CCTGTGTGAAATTGTTATCCGC" >> $DUP
# find AR3
cat ./fa_consensus_trim/*.fa | grep -B1 "GCGGATAACAATTTCACACAGG" >> $DUP

# remove duplicate
cat $DUP | seqkit rmdup -w 0 -n -o $DUP.rmdup.fa

# DONE
END=$(date)
echo "***DONE"
echo "$START - $END"
