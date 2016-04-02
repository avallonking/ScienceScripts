
cd YOUR/PATH
mkdir -p  YOUR/PATH/ID480_A007/tmp
cd YOUR/PATH/ID480_A007
# 1. cut adaptor and fastqc
/data/home/zuoxy/apps/trim_galore/0.3.7/trim_galore --phred33 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -a2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT --length 60 -q 20 --paired --fastqc --stringency 3 -o ./ YOUR/PATH/Project_DefaultProject/Sample_ID480_A007/ID480_A007_ATCACG_L008_R1_001.fastq.gz YOUR/PATH/Project_DefaultProject/Sample_ID480_A007/ID480_A007_ATCACG_L008_R2_001.fastq.gz
# 2. mapping to reference
/data/home/zuoxy/apps/bwa/0.7.12/bwa mem -M -t 16 -R @RG\tID:ID480\tLB:ID480_A007\tPL:ILLUMINA\tSM:ID480_A007 /data/home/zuoxy/resource/DNASeq/hg19/ucsc_hg19 ID480_A007_ATCACG_L008_R1_001_val_1.fq.gz ID480_A007_ATCACG_L008_R2_001_val_2.fq.gz | /data/home/zuoxy/apps/samtools/1.2/bin/samtools view -bS - > ID480_A007.bam
# 3. sort mapped reads
java -jar /data/home/zuoxy/apps/picard/1.127.11/dist/picard.jar  SortSam   I=ID480_A007.bam  O=ID480_A007.sort.bam  SORT_ORDER=coordinate TMP_DIR=./tmp/ VALIDATION_STRINGENCY=LENIENT
# 4. mark duplicates and remove
java -jar /data/home/zuoxy/apps/picard/1.127.11/dist/picard.jar MarkDuplicates  I=ID480_A007.sort.bam  OUTPUT=ID480_A007.bwa.clean.bam  METRICS_FILE=ID480_A007_metric.txt  ASSUME_SORTED=true  REMOVE_DUPLICATES=true  VALIDATION_STRINGENCY=SILENT  TMP_DIR=./tmp/
# 5. index bam file, required by GATK
/data/home/zuoxy/apps/samtools/1.2/bin/samtools index ID480_A007.bwa.clean.bam 
# 6. (1) realignment of indels to reduce false positives
java  -jar /data/home/zuoxy/apps/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar -R /data/home/zuoxy/resource/DNASeq/hg19/ucsc_hg19.fa -T RealignerTargetCreator -I ID480_A007.bwa.clean.bam -o ID480_A007.intervals -known /data/home/zuoxy/resource/DNASeq/hg19/1000G_phase1.indels.hg19.vcf -known /data/home/zuoxy/resource/DNASeq/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf -nt 16 
# 6. (2) apply realignment adjustment
java  -jar /data/home/zuoxy/apps/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar -R /data/home/zuoxy/resource/DNASeq/hg19/ucsc_hg19.fa -T IndelRealigner -I ID480_A007.bwa.clean.bam -o ID480_A007.bwa.clean.realign.bam -known /data/home/zuoxy/resource/DNASeq/hg19/1000G_phase1.indels.hg19.vcf -known /data/home/zuoxy/resource/DNASeq/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf --targetIntervals ID480_A007.intervals 
# 7. (1) base quality score recalibration
java  -jar /data/home/zuoxy/apps/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar -T BaseRecalibrator -R /data/home/zuoxy/resource/DNASeq/hg19/ucsc_hg19.fa -I ID480_A007.bwa.clean.realign.bam  -knownSites /data/home/zuoxy/resource/DNASeq/hg19/1000G_phase1.indels.hg19.vcf -knownSites /data/home/zuoxy/resource/DNASeq/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf -knownSites /data/home/zuoxy/resource/DNASeq/hg19/dbsnp_138.hg19.vcf -o ID480_A007.table -nct 16 
# 7. (2) apply recalibration and print reads
java  -jar /data/home/zuoxy/apps/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar -T PrintReads -R /data/home/zuoxy/resource/DNASeq/hg19/ucsc_hg19.fa -I ID480_A007.bwa.clean.realign.bam -BQSR ID480_A007.table -o ID480_A007.bwa.clean.realign.BQSR.bam -nct 16 
# 8. haplotypecaller to call SNV and INDEL, formatted in GVCF.
java -jar /data/home/zuoxy/apps/GenomeAnalysisTK/3.3.0/GenomeAnalysisTK.jar -T HaplotypeCaller -R /data/home/zuoxy/resource/DNASeq/hg19/ucsc_hg19.fa -I ID480_A007.bwa.clean.realign.BQSR.bam -o ID480_A007_HC_raw_g.vcf --genotyping_mode DISCOVERY --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 -stand_call_conf 30 -stand_emit_conf 10 -out_mode EMIT_ALL_SITES -pcrModel AGGRESSIVE --min_base_quality_score 10 --bamWriterType CALLED_HAPLOTYPES --dbsnp /data/home/zuoxy/resource/DNASeq/hg19/dbsnp_138.hg19.vcf -L /data/home/zuoxy/resource/DNASeq/hg19/Captured-regions_Agilent_HG19_AllExonV5_UTR.bed -nct 16 
