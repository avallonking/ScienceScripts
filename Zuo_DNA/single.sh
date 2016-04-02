#!/bin/sh
ID=$1
INDEX=$2
LANE=$3
PROJECT_PATH=$4

PROGRAM_PATH=~/software
trimpath=$PROGRAM_PATH/trim_galore
sampath=$PROGRAM_PATH/samtool/bin
bwapath=$PROGRAM_PATH/bwa-0.7.12
gatkpath=$PROGRAM_PATH/GenomeAnalysisTK-3.4-46
refpath=~/reference
fqpath=~/data/zuoxyProject/Sample_$ID
picardpath=$PROGRAM_PATH/picard-tools-1.119
threads=16


cd $PROJECT_PATH
test -d $ID || mkdir $ID
test -d $ID/tmp || mkdir -p $ID/tmp
cd $ID

PL="ILLUMINA"
IFS="_" arr=($ID)
IFS=" "
RG_value="@RG\tID:${arr[0]}\tLB:${ID}\tPL:${PL}\tSM:${ID}"
read_1="${ID}_${INDEX}_L00${LANE}_R1_001_val_1.fq.gz"
read_2="${ID}_${INDEX}_L00${LANE}_R2_001_val_2.fq.gz"
echo `hostname` "<RUNINGTIME>" $ID " Start:    "  `date`
$trimpath/trim_galore --phred33 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -a2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT --length 60 -q 20 --paired --fastqc --stringency 3 -o ./ $fqpath/${ID}_${INDEX}_L00${LANE}_R1_001.fastq.gz $fqpath/${ID}_${INDEX}_L00${LANE}_R2_001.fastq.gz && \
$bwapath/bwa mem -M -t $threads -R $RG_value $refpath/ucsc.hg19 $read_1 $read_2 | $sampath/samtools view -bS - > $ID.bam && \
java -jar $picardpath/SortSam.jar   I=$ID.bam  O=$ID.sort.bam  SORT_ORDER=coordinate TMP_DIR=./tmp/ VALIDATION_STRINGENCY=LENIENT && \
java -jar $picardpath/MarkDuplicates.jar  I=$ID.sort.bam  OUTPUT=$ID.bwa.clean.bam  METRICS_FILE=${ID}_metric.txt  ASSUME_SORTED=true  REMOVE_DUPLICATES=true  VALIDATION_STRINGENCY=SILENT  TMP_DIR=./tmp/ && \
$sampath/samtools index $ID.bwa.clean.bam  && \
rm $ID.sort.bam && \
java  -jar $gatkpath/GenomeAnalysisTK.jar -R $refpath/ucsc.hg19.fasta -T RealignerTargetCreator -I $ID.bwa.clean.bam -o $ID.intervals -known $refpath/1000G_phase1.indels.hg19.sites.vcf -known $refpath/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf -nt $threads && \
java  -jar $gatkpath/GenomeAnalysisTK.jar -R $refpath/ucsc.hg19.fasta -T IndelRealigner -I $ID.bwa.clean.bam -o $ID.bwa.clean.realign.bam -known $refpath/1000G_phase1.indels.hg19.sites.vcf -known $refpath/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf --targetIntervals $ID.intervals && \
java  -jar $gatkpath/GenomeAnalysisTK.jar -T BaseRecalibrator -R $refpath/ucsc.hg19.fasta -I $ID.bwa.clean.realign.bam  -knownSites $refpath/1000G_phase1.indels.hg19.sites.vcf -knownSites $refpath/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf -knownSites $refpath/dbsnp_138.hg19.vcf -o $ID.table -nct $threads && \
java  -jar $gatkpath/GenomeAnalysisTK.jar -T PrintReads -R $refpath/ucsc.hg19.fasta -I $ID.bwa.clean.realign.bam -BQSR $ID.table -o $ID.bwa.clean.realign.BQSR.bam -nct $threads  && \
java -jar $gatkpath/GenomeAnalysisTK.jar -T HaplotypeCaller -R $refpath/ucsc.hg19.fasta -I $ID.bwa.clean.realign.BQSR.bam -o ${ID}_HC_raw_g.vcf --genotyping_mode DISCOVERY --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 -stand_call_conf 30 -stand_emit_conf 10 -out_mode EMIT_ALL_SITES -pcrModel AGGRESSIVE --min_base_quality_score 10 --bamWriterType CALLED_HAPLOTYPES --dbsnp $refpath/dbsnp_138.hg19.vcf -L $refpath/Captured-regions_Agilent_HG19_AllExonV5_UTR.bed -nct $threads && \
echo "<RUNINGTIME>"  $ID " done:    "  `date` || echo "ERROR OCCUR!!!"
