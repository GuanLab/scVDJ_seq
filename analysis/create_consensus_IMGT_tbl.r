## name: create_consensus_IMGT_tbl.r
## date: 11/30/2017

## Here I combine two table:
## 1. consensus sequences
## 2. IMGT information for filtered sequences

tbl=as.matrix(read.delim("IMGT/4_IMGT-gapped-AA-sequences.txt",row.names=1,check.names=F))
ccs=as.matrix(read.csv("summary_of_consensus.csv"))

# D/J sequences
d1="GCTTATCTGGTGGTTTCTTCCAGC"
d2="GTAGGCACCTGTGGGGAAGAAACT"
j1="GGTATAAGGTAAGACAGAGTCGTCCCT"
j2="TTAGGGAATCTCCGGGAGGGAAA"
dv34="AGAGTCGGTGGTGCAACTGAACCT"
# DJ1/DJ2
fa=readLines("../barcode/DJ12.txt")
dj1=fa[2]
dj2=fa[4]

output=matrix(NA,nrow=dim(ccs)[1],ncol=18)
colnames(output)=c("barcode","num_seqs","con_len","min1","min2","min3","min4","min5",
	"D1","D2","J1","J2","DV34","germ_DJ1","germ_DJ2","functionality","TRBV","TRBJ")
# reorder ccs so that IMGT sequences go first
ids=sub("\\_consensus.*","",tbl[,1]) # HERE
ind=c(which(ccs[,1] %in% ids), which(!(ccs[,1] %in% ids)))
ccs=ccs[ind,]
rownames(output)=ccs[,1]
output[,1:8]=ccs[,1:8]

## IMGT information
for(i in which(ids %in% ccs[,1])){ # not all IMGT 1126 clusters are covered by 1130 clusters - I didn't set seed in 1126
	id=sub("\\_consensus.*","",tbl[i,1]) # HERE
	# functionality
	output[id,"functionality"]=tbl[i,"V-DOMAIN Functionality"]
	# TRBV
	output[id,"TRBV"]=tbl[i,"V-GENE and allele"]
	# TRBJ
	output[id,"TRBJ"]=tbl[i,"J-GENE and allele"]
}

## a small function to count the number of matches
count_grep <- function(pattern, query){
	tmp=unlist(gregexpr(pattern,query,fixed=T)) 
	if(any(tmp<0)){ # fixed=T; otherwise long pattern leads to error...omg R..
		output=0
	}else{
		output=length(tmp)
	}
	return(output)
}

## consensus information of all clusters
for(i in 1:dim(output)[1]){
	id=rownames(output)[i]
	# D1/D2/J1/J2/DV34/DJ1/DJ2
        id=paste0(id,"_consensus") # HERE
	fa=readLines(paste0("fa_consensus/",id,".fa"))[2]
	output[i,"D1"]=count_grep(d1,fa)
	output[i,"D2"]=count_grep(d2,fa)
	output[i,"J1"]=count_grep(j1,fa)
	output[i,"J2"]=count_grep(j2,fa)
	output[i,"DV34"]=count_grep(dv34,fa)
	output[i,"germ_DJ1"]=count_grep(dj1,fa)
	output[i,"germ_DJ2"]=count_grep(dj2,fa)
}

write.csv(output,file="summary_consensus_IMGT.csv")


