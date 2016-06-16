#Program: use sentieon to call variants
#   Data: Human peripheral blood WGS
#   Targets: Human and EBV
#Author: Jiajin Li(lijj36@mail2.sysu.edu.cn)
#History:
#  Sat 16 April 2016 First_Release

#Variables
sample=$1
depth=$2
num=$3
#Constants
#platform="ILLUMINA"
workdir="/data/home/lijiaj/data/guoymProject/analysis"
sampledir="/data/home/lijiaj/data1/guoymProject/sample/${depth}X/$sample"
#reference files
regions_human="/data/home/lijiaj/reference/wholegenomeregions_human.bed"
regions_EBV="/data/home/lijiaj/reference/wholegenomeregions_EBV.bed"
refseq="/data/home/lijiaj/reference/combined_ucsc-hg19_EBV.fa"
dbsnp="/data/home/lijiaj/reference/dbsnp_138.hg19.vcf"
Mills="/data/home/lijiaj/reference/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf"
G1000_p1_indel="/data/home/lijiaj/reference/1000G_phase1.indels.hg19.sites.vcf"
G1000_p1_snp="/data/home/lijiaj/reference/1000G_phase1.snps.high_confidence.hg19.sites.vcf"
G1000_p1_omni="/data/home/lijiaj/reference/1000G_omni2.5.hg19.sites.vcf"
hapmap="/data/home/lijiaj/reference/hapmap_3.3.hg19.sites.vcf"
#environment setting
export SENTIEON_LICENSE=login01.hpc.sysu:8990
alias sentieon=/share/apps/sentieon/201603/bin/sentieon
#Main
#setup
mkdir -p $workdir/$depth\X/$sample/$num
cd $workdir/$depth\X/$sample/$num
#sort bam
sentieon util sort -o $sample.$num.sorted.bam -t 10 -i $sampledir/$sample.$depth\X.sample.$num.bam
#remove duplicates
sentieon driver -t 10 -i $sample.$num.sorted.bam --algo LocusCollector --fun score_info score.txt
sentieon driver -t 10 -i $sample.$num.sorted.bam --algo Dedup --rmdup --score_info score.txt --metrics dedup.metrics $sample.$num.dedup.bam
#indel realign
sentieon driver -r $refseq -t 10 -i $sample.$num.dedup.bam --algo Realigner -k $Mills -k $G1000_p1_indel $sample.$num.realigned.bam
#BQSR
sentieon driver -r $refseq -t 10 -i $sample.$num.realigned.bam --algo QualCal -k $dbsnp -k $Mills -k $G1000_p1_indel recal.table
sentieon driver -r $refseq -t 10 -i $sample.$num.realigned.bam -q recal.table --algo QualCal -k $dbsnp -k $Mills -k $G1000_p1_indel post.recal.table
#sentieon driver -r $refseq -t 10 -i $sample.$num.realigned.bam -q recal.table --algo ReadWriter $sample.$num.recal.bam

#variant call
sentieon driver -r $refseq --interval $regions_human -t 10 -i $sample.$num.realigned.bam -q recal.table --algo Haplotyper -d $dbsnp --emit_conf=30 --call_conf=30 --emit_mode gvcf $sample.$num.human.vcf
sentieon driver -r $refseq --interval $regions_EBV -t 10 -i $sample.$num.realigned.bam -q recal.table --algo Haplotyper -d $dbsnp --emit_conf=30 --call_conf=30 --emit_mode gvcf $sample.$num.EBV.vcf
#turn GVCFs into vcf
sentieon driver -r $refseq -t 10 --algo GVCFtyper -v $sample.$num.human.vcf genotyped.$sample.$num.human.vcf
sentieon driver -r $refseq -t 10 --algo GVCFtyper -v $sample.$num.EBV.vcf genotyped.$sample.$num.EBV.vcf
#remove intermediate files
rm $sample.$num.sorted.bam $sample.$num.dedup.bam $sample.$num.sorted.bam.bai $sample.$num.dedup.bam.bai recal.table post.recal.table $sample.$num.human.vcf $sample.$num.EBV.vcf $sample.$num.human.vcf.idx $sample.$num.EBV.vcf.idx
