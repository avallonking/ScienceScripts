#################################################################
#################################################################
######################  [RNA-SEQ]Yisb Data
##############################################################################
##############################################################################
require("DESeq");
setwd("/data/home/yisib/temp2");
filenames = dir();
dataSet = lapply(filenames,read.table,header=T,stringsAsFactors=F);
names(dataSet) = gsub(".genes.results",'',filenames);
#tmp = do.call(cbind,lapply(dataSet,`[[`,'gene_id'));

countData1 = cbind(as.integer(round(dataSet$'P'[,"expected_count"])),
                   as.integer(round(dataSet$'V'[,"expected_count"])));
rownames(countData1) = dataSet$'P'[,"gene_id"];
colnames(countData1) = c("P","V");
cds1 = newCountDataSet(countData1, factor(c("P","V")));
cds1 = estimateSizeFactors( cds1 );
cds1 = estimateDispersions( cds1,method="blind",sharingMode="fit-only"); ##
res1a  = nbinomTest( cds1, "P", "V" );
colnames(res1a) = paste("P@V",colnames(res1a),sep=".");
dataset0 = cbind(dataSet$'P'[,4:7],dataSet$'V'[,4:7]);
names(dataset0) = paste(rep(c("P","V"),each=4),names(dataset0),sep=".");
dataset1 = cbind(dataSet$'P'[,1:3],dataset0,res1a);
#
#countData2 = cbind(as.integer(round(dataSet$'Group2-S18exo'[,"expected_count"])),
#                   as.integer(round(dataSet$'Group2-PBS'[,"expected_count"])));
#rownames(countData2) = dataSet$'Group1-Control'[,"gene_id"];
#colnames(countData2) = c("S18exo","PBS");
#cds2 = newCountDataSet(countData2, factor(c("S18exo","PBS")));
#cds2 = estimateSizeFactors( cds2 );
#cds2 = estimateDispersions( cds2,method="blind",sharingMode="fit-only"); ##,sharingMode="fit-only"
#res2a  = nbinomTest( cds2, "S18exo","PBS");
#colnames(res2a) = paste("S18@PBS",colnames(res2a),sep=".");
#dataset0 = cbind(dataSet$'Group2-S18exo'[,4:7],dataSet$'Group2-PBS'[,4:7]);
#names(dataset0) = paste(rep(c("S18","PBS"),each=4),names(dataset0),sep=".");
#dataset2 = cbind(dataSet$'Group2-S18exo'[,1:3],dataset0,res2a);
#
write.table(dataset1,file="res.txt",sep="\t",quote=F,row.names=F);
#write.table(dataset2,file="res.group02.txt",sep="\t",quote=F,row.names=F);

################################################################################
################################################################################
 library("org.Hs.eg.db");
 library("GSEABase");
 library("GOstats");
dataset = read.table("res.txt",header=T,as.is=T);
GB.id.list =  dataset[which(dataset$P.V.padj<0.05),"gene_id"];
mapping.res = toTable(org.Hs.egACCNUM);
entrezIDs   = unique(mapping.res[match(GB.id.list,mapping.res$accession),"gene_id"]); 
universe    = unique(mapping.res$gene_id);
##GO enrichment analysis
params <- new("GOHyperGParams",geneIds=entrezIDs, universeGeneIds=universe,
                 annotation="org.Hs.eg.db", 
                 ontology="BP",
                 pvalueCutoff=0.05,conditional=FALSE,
                 testDirection="over");
over <- hyperGTest(params);
glist <- geneIdsByCategory(over)
glist <- sapply(glist, function(.ids) {
 .sym <- mget(.ids, envir=org.Hs.egSYMBOL, ifnotfound=NA)
 .sym[is.na(.sym)] <- .ids[is.na(.sym)]
  paste(.sym, collapse=";")
  })
bp <- summary(over);
bp$Symbols <- glist[as.character(bp$GOBPID)]
write.table(bp,file="go_group02.txt",sep="\t",quote=F);                 
##KEGG enrichment analysis
params <- new("KEGGHyperGParams", geneIds=entrezIDs, universeGeneIds=universe,
                 annotation="org.Hs.eg.db", categoryName="KEGG", pvalueCutoff=0.05,
                 testDirection="over");
over <- hyperGTest(params);
kegg <- summary(over)
##library(Category)
glist <- geneIdsByCategory(over)
glist <- sapply(glist, function(.ids) {
 .sym <- mget(.ids, envir=org.Hs.egSYMBOL, ifnotfound=NA)
 .sym[is.na(.sym)] <- .ids[is.na(.sym)]
  paste(.sym, collapse=";")
  })
kegg$Symbols <- glist[as.character(kegg$KEGGID)]
#kegg   ##"data.frame"
write.table(kegg,file="kegg.txt",sep="\t",quote=F);

library("pathview")
gene.data <- rep(1, length(entrezIDs))
names(gene.data) <- entrezIDs
for(i in 1:nrow(kegg))
pv.out <- pathview(gene.data, pathway.id=as.character(kegg$KEGGID)[i], species="hsa", out.suffix="pathview", kegg.native=T);

