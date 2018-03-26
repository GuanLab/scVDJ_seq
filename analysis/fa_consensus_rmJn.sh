#!/bin/bash
# from consensus.trim remove extra J regions
# usage:  bash fa_consensus_rmJn.sh
START=$(date)

mkdir -p ./fa_consensus_rmJn

# V primers (DV3 through DV34)
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

cat ./fa_consensus_rmJn/*.fa > fa_consensus_rmJn_for_IMGT.fa
rm temp.fa

# DONE
END=$(date)
echo "***DONE"
echo "$START - $END"

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


