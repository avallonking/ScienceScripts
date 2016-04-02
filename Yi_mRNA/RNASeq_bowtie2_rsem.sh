#!/bin/sh
# bowtie2, samtools, fastqc, cutadapt, rsem
ID=$1 # sample ID
INDEX=$2 # index
RUNHOME=/data/home/chenjr/data # the project path
fq_raw_path=/data/home/chenjr/data/Sample_$ID
fastqc_path=/data/home/chenjr/software/FastQC
cutadapt_path=/data/home/chenjr/software/cutadapt-1.8.3/bin
samtools_path=/data/home/chenjr/software/samtool/bin
bowtie2_path=/data/home/chenjr/software/bowtie2-2.2.6
rsem_path=/data/home/chenjr/software/rsem-1.2.22
reference=/data/home/chenjr/reference/genome/bowtie-indexes/mrna_hg19
cd $RUNHOME
# mkdirs
path00=$RUNHOME/$ID/00-RAW_cat_fastq
path01=$RUNHOME/$ID/01-FastQC_before_triming
path02=$RUNHOME/$ID/02-Triming_3_adapter
path03=$RUNHOME/$ID/03-FastQC_after_triming
path04=$RUNHOME/$ID/04-rsem-expression
test -d $ID || mkdir -p $ID
# make path01-04
test -d $path00 || mkdir -p $path00
test -d $path01 || mkdir -p $path01
test -d $path02 || mkdir -p $path02
test -d $path03 || mkdir -p $path03
test -d $path04 || mkdir -p $path04
# 00-cat two lanes into one fastq file
zcat $fq_raw_path/${ID}_${INDEX}_L001_R1_001.fastq.gz $fq_raw_path/${ID}_${INDEX}_L002_R1_001.fastq.gz > $path00/$ID.fastq
# 01-fastqc before cut adaptor
fastqc -o $path01 $path00/$ID.fastq
# 02-cut 3' adaptor
cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -q 20 -m 25 $path00/$ID.fastq > $path02/$ID.cut.fastq
# 03-fastqc after cut adaptor
fastqc -o $path03 $path02/$ID.cut.fastq
# 04-integrated  analysis pipeline by rsem
# make index at very first run: /data/home/chenjr/software/rsem-1.2.22/rsem-prepare-reference /data/home/chenjr/reference/genome/mrna_hg19.fa /data/home/chenjr/reference/genome/bowtie-indexes/mrna_hg19
$rsem_path/rsem-calculate-expression --phred33-quals --bowtie2 --fragment-length-max 3000 -p 10 $path02/$ID.cut.fastq $reference $path04/$ID\_rsem
