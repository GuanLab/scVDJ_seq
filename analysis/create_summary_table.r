## name: create_summary_table.r
## date: 12/20/2017

## Here I create summary tables
## input arguments: cell lists
## e.g. Rscript create_summary_table.r barcode/cell_*.txt

args <- commandArgs(trailingOnly = TRUE)

# summary table
tbl=as.matrix(read.csv("summary_consensus_IMGT.csv",row.names=1,check.names=F))
# output directory
path1="table/"
system(paste0("mkdir ",path1))

for(filename in args){
    print(filename)
    list_cell=readLines(filename)

    #1. xxx_table_cluster.csv
    ind=NULL
    for(i in list_cell){
        ind=c(ind,grep(paste0(i,"\\."),rownames(tbl)))
    }
    output=tbl[ind,]
    write.csv(output,file=paste0(path1,sub("\\.txt","_",basename(filename)),"table_cluster.csv"),na="",row.names=F)

    #2. xxx_table_cluster2.csv
    output=matrix(NA,nrow=0,ncol=dim(tbl)[2])
    colnames(output)=colnames(tbl)
    for(i in list_cell){
        output=rbind(output,NA,NA)
        output[dim(output)[1]-1,1]="---"
        output[dim(output)[1],1]=i
        ind=grep(paste0(i,"\\."),rownames(tbl))
        if(length(ind)>1){
            tmp=tbl[ind,"functionality"]
            tmp[is.na(tmp)]="zzzzzz"
            output=rbind(output,tbl[ind[order(tmp)],])
        }else if(length(ind)==1){
            output=rbind(output,tbl[ind,])
        }
    }
    write.csv(output,file=paste0(path1,sub("\\.txt","_",basename(filename)),"table_cluster2.csv"),na="",row.names=F)

    #3. xxx_table_well.csv
    name=c("barcode","num_cluster","count_J1","count_J2","count_productive","count_unproductive","count_D1","count_D2","TRBV31")
    output=matrix(NA,nrow=length(list_cell),ncol=length(name))
    rownames(output)=list_cell
    colnames(output)=name
    name=colnames(tbl)
    for(i in list_cell){
        ind=grep(paste0(i,"\\."),rownames(tbl))
        mat=tbl[ind,]
        if(length(ind)==1){
            mat=matrix(mat,nrow=1)
        }
        output[i,"num_cluster"]=length(ind)
        output[i,"count_J1"]=sum(as.numeric(mat[,name=="J1"]))
        output[i,"count_J2"]=sum(as.numeric(mat[,name=="J2"]))
        output[i,"count_D1"]=sum(as.numeric(mat[,name=="D1"]))
        output[i,"count_D2"]=sum(as.numeric(mat[,name=="D2"]))
        output[i,"count_productive"]=length(grep("^productive",mat[,name=="functionality"]))
        output[i,"count_unproductive"]=length(grep("^unproductive",mat[,name=="functionality"]))
        output[i,"TRBV31"]=sum(as.numeric(mat[,name=="TRBV31"]))
    }
    output[,"barcode"]=list_cell
    write.csv(output,file=paste0(path1,sub("\\.txt","_",basename(filename)),"table_well.csv"),na="",row.names=F)

    #4. xxx_summary.csv
    ind=as.numeric(output[,"num_cluster"])>=2
    code=apply(output[ind,c("count_productive","count_unproductive","count_D1","count_D2")],1,function(x){
        paste0(x,collapse="")
    })
    vec_summary=c(
        sum(as.numeric(code)<=1012 & as.numeric(code)>=1010), #G3 - Gx is used in Tomo's original code table2.sh
        sum(as.numeric(code)<=2002 & as.numeric(code)>=2000), #G1
        sum(as.numeric(code)<=1102 & as.numeric(code)>=1100), #G2
        sum(as.numeric(code)<=0202 & as.numeric(code)>=0200), #G4
        sum(as.numeric(code)<=0112 & as.numeric(code)>=0110), #G5
        sum(as.numeric(code)<=0022 & as.numeric(code)>=0020) #G6
    )
    vec_summary=matrix(vec_summary,nrow=1)
    colnames(vec_summary)=c("VDJ+/DJ","VDJ+/VDJ+","VDJ-/VDJ+","VDJ-/VDJ-","VDJ-/DJ","DJ/DJ")
    write.csv(vec_summary,file=paste0(path1,sub("\\.txt","_",basename(filename)),"summary.csv"),quote=F,row.names=F)
}


