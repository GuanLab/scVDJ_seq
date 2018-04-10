## name: 45_sampleID.r
## wrote by Hongyang
## editied by Tomo,  Mar 29, 2018

## Here I create summary tables
## input arguments: cell lists
## e.g. Rscript 45_sampleID.r ../barcode_sampleID/IDcell_*.txt

args <- commandArgs(trailingOnly = TRUE)

# create table
############### remove empty rows ################
tbl=as.matrix(read.csv("./table43_consensus_tag_IMGT.csv",check.names=F))
tbl=tbl[which(tbl[,1]!="0"),]
rownames(tbl)=tbl[,1]
tbl=tbl[,-1]
##################################################

# output directory
path1="./table_sampleID/"
system(paste0("mkdir ",path1))

############### remove_maybe_error ################
# remove clusters listed in   maybe_error.auto.txt
Multi=readLines("./table44_maybe_error/maybe_error.auto.txt")
# exclude the clusters (before) from tbl
tbl=tbl[!(rownames(tbl) %in% Multi),]
###################################################

for(filename in args){
    print(filename)
    id1=sub("IDcell_","",basename(filename))
    id2=sub(".txt","",id1)
    list_cell=readLines(filename)

    #1. xxx_cluster_consensus_tag_IMGT.csv
    ind=NULL
    for(i in list_cell){
        ind=c(ind,grep(paste0(i,"\\."),rownames(tbl)))
    }
    output=tbl[ind,]
    write.csv(output,file=paste0(path1,"cluster_consensus_tag_IMGT_",id2,".csv"),na="",row.names=F)

    #2. xxx_CELLcluster_consensus_tag_IMGT.csv
    output=matrix(NA,nrow=0,ncol=dim(tbl)[2])
    colnames(output)=colnames(tbl)
    for(i in list_cell){
        output=rbind(output,NA,NA)
        output[dim(output)[1]-1,1]="---"
        output[dim(output)[1],1]=i
        ind=grep(paste0(i,"\\."),rownames(tbl))
        if(length(ind)>1){
            tmp=tbl[ind,"TRBV"]
            tmp[is.na(tmp)]="zzzzzz"
            output=rbind(output,tbl[ind[order(tmp)],])
        }else if(length(ind)==1){
            output=rbind(output,tbl[ind,])
        }
    }
    write.csv(output,file=paste0(path1,"CELLcluster_consensus_tag_IMGT_",id2,".csv"),na="",row.names=F)
}

