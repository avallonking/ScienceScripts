#Program: statistics -- CountBases & DepthOfCoverage
#   Data: bam file after BQSR from sentieon
#Author: Jiajin Li(lijj36@mail2.sysu.edu.cn)
#History:
#   Sat 16 April 2016 First_Release

#Variables
sample=$1
depth=$2
num=$3
#Constants
workdir="/data/home/lijiaj/data/guoymProject/analysis"
regions_human="/data/home/lijiaj/reference/wholegenomeregions_human.bed"
regions_EBV="/data/home/lijiaj/reference/wholegenomeregions_EBV.bed"
refseq="/data/home/lijiaj/reference/combined_ucsc-hg19_EBV.fa"
gatkPath="/data/home/lijiaj/software/GenomeAnalysisTK-3.4-46"
#Main
module load java/1.8.0_60
cd $workdir/$depth\X/$sample/$num
#countbases
#java -jar $gatkPath/GenomeAnalysisTK.jar -T CountBases -R $refseq -I $sample.$num.realigned.bam 1> $sample.$num.countbases.log 2>&1
#java -jar $gatkPath/GenomeAnalysisTK.jar -T CountBases -R $refseq -I $sample.$num.realigned.bam -L $regions_human 1> $sample.$num.countbases.human.log 2>&1
#java -jar $gatkPath/GenomeAnalysisTK.jar -T CountBases -R $refseq -I $sample.$num.realigned.bam -L $regions_EBV 1> $sample.$num.countbases.EBV.log 2>&1
#depth of coverage
java -jar $gatkPath/GenomeAnalysisTK.jar -T DepthOfCoverage -R $refseq -I $sample.$num.realigned.bam -L $regions_human -o $sample.$num.depthOfCoverage.human -ct 1 -ct 5 -ct 10 -ct 20 -ct 30 -ct 40 -ct 50
java -jar $gatkPath/GenomeAnalysisTK.jar -T DepthOfCoverage -R $refseq -I $sample.$num.realigned.bam -L $regions_EBV -o $sample.$num.depthOfCoverage.EBV -ct 1 -ct 5 -ct 10 -ct 20 -ct 30 -ct 40 -ct 50
