#!/bin/bash

for FILE in *bam
do
    OUT1=$(basename $FILE .bam).fastq
    samtools bam2fq $FILE > $OUT1
    OUT2=$(basename $FILE .bam).fasta
    seqtk seq -a $OUT1 > $OUT2
done

#samtools bam2fq 1268_CCS_min10_passes2_accuracy90.bam > 1268_CCS_min10_passes2_accuracy90.fastq
#seqtk seq -a 1268_CCS_min10_passes2_accuracy90.fastq > 1268_CCS_min10_passes2_accuracy90.fasta


