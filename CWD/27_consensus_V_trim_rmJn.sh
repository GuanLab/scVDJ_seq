#!/bin/bash
DATEstart=$(date)
echo "### $0 ###"                                                          >> ./analysis.log.txt
echo "### $DATEstart ------------------------------ ### START ### $0 ###"  >> ./analysis.log.txt
echo "### $DATEstart ------------------------------ ### START ### $0 ###"  
# usage:  bash 27_consensus_V_trim_rmJn.sh

# remove barcode-adapter and extra J region sequence

# remove barcode-AF and barcode-AR3
mkdir -p fa_consensus_trim

for FILE in ./fa_consensus/*_consensus.fa
do
    OUT=./fa_consensus_trim/$(basename $FILE .fa).trim.fa

    # seq_ID
    echo ">$(basename $FILE .fa).trim" > $OUT
    # remove barcode-AF (32bp) and barcode-AR3       (CCTGTGTGAAATTGTTATCCGC = AR3 reverse complement)
    cat $FILE | grep -v '>' |  cut -c 33- | sed -e "s/CCTGTGTGAAATTGTTATCCGC.*//g" >> $OUT
done

# remove extra Jn genomic DNA
# V primers (DV3 through DV34)

mkdir -p ./fa_consensus_rmJn

for i in `seq 3 34`
do
    echo DV${i}
    mkdir -p ./fa_consensus_rmJn

    for FILE in ./fa_consensus_trim/ROW*.DV${i}_cluster*.fa
    do
        echo -n > temp.fa
        echo ">$(basename $FILE .trim.fa).J1-7rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/TAAGACAGAATCCTTAGGTATAAGGTAAGA.*//g" >> temp.fa
        echo ">$(basename $FILE .trim.fa).J1-6rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/GTATGGGGGCTCCATTTCTGACTGGAGGGG.*//g" >> temp.fa
        echo ">$(basename $FILE .trim.fa).J1-5rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/GTAAACTATGGGACCAAACTGGTGGGACCA.*//g" >> temp.fa
        echo ">$(basename $FILE .trim.fa).J1-4rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/GTATGTAAAAGATTTCTTTCTCGGGAGGGT.*//g" >> temp.fa
        echo ">$(basename $FILE .trim.fa).J1-3rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/GTAAGTTAGGGCCAAATGGCTGGGTACTGG.*//g" >> temp.fa
        echo ">$(basename $FILE .trim.fa).J1-2rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/GTAAGGCCTGAGGGTCTTTGGGTGTGGGAT.*//g" >> temp.fa
        echo ">$(basename $FILE .trim.fa).J1-1rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/GTAAGATATCTTTCAGGTAAATTTCCAGGT.*//g" >> temp.fa

        echo ">$(basename $FILE .trim.fa).J2-7rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/GTAAGATTCACATCTCTCGCTTCCACCCAA.*//g" >> temp.fa
        echo ">$(basename $FILE .trim.fa).J2-6rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/CTTCTTGGCAACTGCAGCGGGGAGTTCTGG.*//g" >> temp.fa
        echo ">$(basename $FILE .trim.fa).J2-5rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/GTGAGCTGGGGCCCCACGTGCGCGTTCTCA.*//g" >> temp.fa
        echo ">$(basename $FILE .trim.fa).J2-4rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/GTAAGCTGGGGTATAGTTTTTGTGTTGGGT.*//g" >> temp.fa
        echo ">$(basename $FILE .trim.fa).J2-3rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/GTAAGTTGGGAGCTAGTAATGAAGGGGAGG.*//g" >> temp.fa
        echo ">$(basename $FILE .trim.fa).J2-2rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/GTAAGCAGGCAGCTGGGGGTACCATGGGAG.*//g" >> temp.fa
        echo ">$(basename $FILE .trim.fa).J2-1rm" >> temp.fa
        cat $FILE | grep -v '>' | sed -e "s/GTAAGAAGGCAGAGGCCATACAGGTGGGAG.*//g" >> temp.fa

        cat temp.fa | seqkit sort -w 0 -l -2 | head -n 2 > ./fa_consensus_rmJn/$(basename $FILE .trim.fa).rmJn.fa

    done
done

rm temp.fa

# move empty fa_consensus_rmJn
mkdir -p ./fa_consensus_rmJn_empty

for EMPTY in ./fa_consensus_rmJn/*.fa.rmJn.fa
do 
	mv $EMPTY ./fa_consensus_rmJn_empty/$(basename $EMPTY) 
done

# combine .rmJn.fa for IMGT 
cat ./fa_consensus_rmJn/*.fa > IMGT.fa

# check number of sequence 
# if L2 and L3 are different, possible error in the FASTA file for IMGT, re-run this script
L1=$(find ./fa_consensus/*_consensus.fa | wc -l )
L2=$(find ./fa_consensus_rmJn/*.rmJn.fa | wc -l )
L3=$(cat ./IMGT.fa | grep ">" | wc -l)

echo "### count    all clusters= $L1" >> ./analysis.log.txt
echo "### count    VDJ clusters= $L2" >> ./analysis.log.txt
echo "### count    > in IMGT.fa= $L3" >> ./analysis.log.txt

echo "### count    all clusters= $L1" 
echo "### count    VDJ clusters= $L2" 
echo "### count    > in IMGT.fa= $L3" 

if [ $L2 = $L3 ]; then
    echo "### IMGT.fa is ready for IMGT/HighV-QUEST analysis" >> ./analysis.log.txt
    echo "### IMGT.fa is ready for IMGT/HighV-QUEST analysis"
else
    echo "### Maybe ERROR in IMGT.fa, re-run [ 27_fa_consensus_trim_rmJn.sh ]" >> ./analysis.log.txt
    echo "### Maybe ERROR in IMGT.fa, re-run [ 27_fa_consensus_trim_rmJn.sh ]"
fi

# BASH DONE
DATEend=$(date)
echo "### $DATEstart - $DATEend ### DONE  ### $0 ###"
echo "### $DATEstart - $DATEend ### DONE  ### $0 ###"  >> ./analysis.log.txt
echo " "                                               >> ./analysis.log.txt


# Trb       J region sequence                                       immediately 3' sequence

# Trbj1-7 = CCTGTGTTGGATGACCATGGTCTTGGAAAGGAACTTAGGTATAAGA          TAAGACAGAATCCTTAGGTATAAGGTAAGA
# Trbj1-6 = TTCCTATAATTCGCCCCTCTACTTTGCGGCAGGCACCCGGCTCACTGTGACAG   GTATGGGGGCTCCATTTCTGACTGGAGGGG
# Trbj1-5 = TAACAACCAGGCTCCGCTTTTTGGAGAGGGGACTCGACTCTCTGTTCTAG      GTAAACTATGGGACCAAACTGGTGGGACCA
# Trbj1-4 = TTTCCAACGAAAGATTATTTTTCGGTCATGGAACCAAGCTGTCTGTCCTGG     GTATGTAAAAGATTTCTTTCTCGGGAGGGT
# Trbj1-3 = TTCTGGAAATACGCTCTATTTTGGAGAAGGAAGCCGGCTCATTGTTGTAG      GTAAGTTAGGGCCAAATGGCTGGGTACTGG
# Trbj1-2 = CAAACTCCGACTACACCTTCGGCTCAGGGACCAGGCTTTTGGTAATAG        GTAAGGCCTGAGGGTCTTTGGGTGTGGGAT
# Trbj1-1 = CAAACACAGAAGTCTTCTTTGGTAAAGGAACCAGACTCACAGTTGTAG        GTAAGATATCTTTCAGGTAAATTTCCAGGT

# Trbj2-7 = CTCCTATGAACAGTACTTCGGTCCCGGCACCAGGCTCACGGTTTTAG         GTAAGATTCACATCTCTCGCTTCCACCCAA
# Trbj2-6 = CAGCCCTTGCCCTGACTGATTGGCAGCCGATTGAACAGCCTATGCGAG        CTTCTTGGCAACTGCAGCGGGGAGTTCTGG
# Trbj2-5 = AACCAAGACACCCAGTACTTTGGGCCAGGCACTCGGCTCCTCGTGTTAG       GTGAGCTGGGGCCCCACGTGCGCGTTCTCA
# Trbj2-4 = AGTCAAAACACCTTGTACTTTGGTGCGGGCACCCGACTATCGGTGCTAG       GTAAGCTGGGGTATAGTTTTTGTGTTGGGT
# Trbj2-3 = AGTGCAGAAACGCTGTATTTTGGCTCAGGAACCAGACTGACTGTTCTCG       GTAAGTTGGGAGCTAGTAATGAAGGGGAGG
# Trbj2-2 = CAAACACCGGGCAGCTCTACTTTGGTGAAGGCTCAAAGCTGACAGTGCTGG     GTAAGCAGGCAGCTGGGGGTACCATGGGAG
# Trbj2-1 = TAACTATGCTGAGCAGTTCTTCGGACCAGGGACACGACTCACCGTCCTAG      GTAAGAAGGCAGAGGCCATACAGGTGGGAG
