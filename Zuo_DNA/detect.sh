#!/bin/sh
#A program to detect variants related to tumor, using Mutect
#Author: Jiajin Li(lijj36@mail2.sysu.edu.cn) till July, 2016
#History:
#	Jan 11 2016: First Release

normalID=$1
tumorID=$2
mutectPath=/data/home/zuoxy/apps/mutect/1.1.7
refPath=/data/home/chenjr/reference
normalPath=/data/home/chenjr/data/zuoxyProject/$normalID
tumorPath=/data/home/chenjr/data/zuoxyProject/$tumorID
resultPath=/data/home/chenjr/data/zuoxyProject/results

module load java/1.7.0_80

cd ${resultPath}
test -d ${normalID}.${tumorID} || mkdir ${normalID}.${tumorID}
cd ${normalID}.${tumorID}

java -Xmx2g -jar ${mutectPath}/mutect.jar\
 --analysis_type MuTect\
 --reference_sequence ${refPath}/ucsc.hg19.fasta\
 --dbsnp ${refPath}/dbsnp_138.hg19.vcf\
 --cosmic ${refPath}/CosmicCodingMuts.sorted.vcf\
 --intervals ${refPath}/Captured-regions_Agilent_HG19_AllExonV5_UTR_flank_100bp.bed\
 --input_file:normal ${normalPath}/${normalID}.bwa.clean.realign.BQSR.bam\
 --input_file:tumor ${tumorPath}/${tumorID}.bwa.clean.realign.BQSR.bam\
 --out ${normalID}.${tumorID}.call_stats.txt\
 --coverage_file ${normalID}.${tumorID}.coverage.wig.txt #optional output created by muTect
