#!/bin/bash
DATEstart=$(date)
PWD=$(pwd)
echo "### $PWD/$0 ###"                                                     >> ./analysis.log.txt
echo "### $DATEstart ------------------------------ ### START ### $0 ###"  >> ./analysis.log.txt
echo "### $DATEstart ------------------------------ ### START ### $0 ###"  

######################################################################
## 1. convert bam to fasta & concatenate ###############

######################################################################
## 2. demultiplex and cluster ###############

######################################################################
## 3. IMGT ###########

######################################################################
## 4. create customized tables ##############

# need       ./*.txz (IMGT outout)  in the working directory (same with IMGT.fa)
COUNT=$(find ./*.txz | wc -l ) 
if [ $COUNT -eq 1 ]; then
    mkdir -p ./IMGT
    cd IMGT
    tar -xf ../*.txz
    cd ..
else
    echo "0 or 2 *.txz file exist (IMGT outout), place only 1"
    echo "### exit  $0 "
    exit
fi

# need  ../barcode_sampleID/IDcell_*.txt   (list of barcode ROW.COL.)
N=$(cat ../barcode_sampleID/IDcell_*.txt | wc -l )
if [ $N -gt 0  ]; then 
    bash 41_check_input_files.sh
else
    echo "### ERROR   No ../barcode_sampleID/cell_*.txt  file is found"
    echo "### exit  $0 "
    exit
fi


echo "### Rscript 42_create_consensus_IMGT_tbl.r"                         >> ./analysis.log.txt
echo "### Rscript 42_create_consensus_IMGT_tbl.r"
Rscript 42_consensus_code_IMGT.r      # combine consensus and IMGT output

bash 43_tag.sh                        # convert code to tag
bash 43a_CDR3.sh                      # generate list of CDR3
bash 44_list_maybe_error.sh           # generate list of clusters maybe error

echo "### Rscript 45_sampleID.r ../barcode_sampleID/IDcell_*.txt"         >> ./analysis.log.txt
echo "### Rscript 45_sampleID.r ../barcode_sampleID/IDcell_*.txt"
Rscript 45_sampleID.r ../barcode_sampleID/IDcell_*.txt    # table_sampleID

bash 45a_sampleID_CDR3.sh                                 # table_sampleID
bash 46_genotype.sh                                       # table_sampleID
bash 47_count.sh                                          # table_sampleID
bash 48_summary.sh                                        # table_summary


######################################################################
## 5. (optional) remove clusters for Tg ##############

######################################################################

# BASH DONE
DATEend=$(date)
echo "### $DATEstart - $DATEend ### DONE  ### $0 ###"
echo "### $DATEstart - $DATEend ### DONE  ### $0 ###"  >> ./analysis.log.txt
echo " "                                               >> ./analysis.log.txt
