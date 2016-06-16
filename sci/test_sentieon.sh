#!/bin/sh
# *******************************************
# Script to perform DNA seq variant calling
# using a single sample with fastq files
# named 1.fastq.gz and 2.fastq.gz
# *******************************************

# Update with the fullpath location of your sample fastq
fastq_folder="/data1/home/zuoxy/tmp/test_sentieon/0-fastq"
fastq_1="409_A011_CGATGT_L001_R1_001_val_1.fq.gz"
fastq_2="409_A011_CGATGT_L001_R2_001_val_2.fq.gz" #If using Illumina paired data
sample="409"
group=$sample
platform="ILLUMINA"

# Update with the location of the reference data files
regions="/data/home/zuoxy/resource/DNASeq/hg19/Captured-regions_Agilent_HG19_AllExonV5_UTR_flank_50bp.bed"
fasta="/data/home/zuoxy/resource/DNASeq/hg19/ucsc_hg19.fa"
fasta_bwa="/data/home/zuoxy/resource/DNASeq/hg19/ucsc_hg19"
dbsnp="/data/home/zuoxy/resource/DNASeq/hg19/dbsnp_138.hg19.vcf"
known_sites="/data/home/zuoxy/resource/DNASeq/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf"

#determine whether Variant Quality Score Recalibration will be run
#VQSR should only be run when there are sufficient variants called
run_vqsr="no"
# Update with the location of the resource files for VQSR
vqsr_Mills="/data/home/zuoxy/resource/DNASeq/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf"
vqsr_1000G_omni="/data/home/zuoxy/resource/DNASeq/hg19/1000G_omni2.5.hg19.sites.vcf"
vqsr_hapmap="/data/home/zuoxy/resource/DNASeq/hg19/hapmap_3.3.hg19.sites.vcf"
vqsr_1000G_phase1="/data/home/zuoxy/resource/DNASeq/hg19/1000G_phase1.snps.high_confidence.hg19.sites.vcf"
vqsr_1000G_phase1_indel="/data/home/zuoxy/resource/DNASeq/hg19/1000G_phase1.indels.hg19.vcf"
vqsr_dbsnp="/data/home/zuoxy/resource/DNASeq/hg19/dbsnp_138.hg19.vcf"

# Update with the location of the Sentieon software package and license file
release_dir=/share/apps/sentieon/201603/
export SENTIEON_LICENSE=login01.hpc.sysu:8990

# Other settings
nt=10 #number of threads to use in computation
workdir="/data1/home/zuoxy/tmp/test_sentieon/160328/sentieon_t10_rep2_$sample" #Determine where the output files will be stored
run_joint="no"

# ******************************************
# 0. Setup
# ******************************************
mkdir -p $workdir
logfile=$workdir/run.log
exec >$logfile 2>&1
cd $workdir

# ******************************************
# 1. Mapping reads with BWA-MEM, sorting
# ******************************************
#The results of this call are dependent on the number of threads used. To have number of threads independent results, add chunk size option -K 10000000 
$release_dir/bin/bwa mem -M -R "@RG\tID:$group\tSM:$sample\tPL:$platform" -t $nt $fasta_bwa $fastq_folder/$fastq_1 $fastq_folder/$fastq_2 | $release_dir/bin/sentieon util sort -o sorted.bam -t $nt --sam2bam -i -

# ******************************************
# 2. Metrics
# ******************************************
$release_dir/bin/sentieon driver -r $fasta -t $nt -i sorted.bam --algo MeanQualityByCycle mq_metrics.txt --algo QualDistribution qd_metrics.txt --algo GCBias --summary gc_summary.txt gc_metrics.txt --algo AlignmentStat aln_metrics.txt --algo InsertSizeMetricAlgo is_metrics.txt
$release_dir/bin/sentieon plot metrics -o metrics-report.pdf gc=gc_metrics.txt qd=qd_metrics.txt mq=mq_metrics.txt isize=is_metrics.txt

# ******************************************
# 3. Remove Duplicate Reads
# ******************************************
$release_dir/bin/sentieon driver -t $nt -i sorted.bam --algo LocusCollector --fun score_info score.txt
$release_dir/bin/sentieon driver -t $nt -i sorted.bam --algo Dedup --rmdup --score_info score.txt --metrics dedup_metrics.txt deduped.bam

# ******************************************
# 4. Indel realigner
# ******************************************
$release_dir/bin/sentieon driver -r $fasta -t $nt -i deduped.bam --algo Realigner -k $known_sites realigned.bam

# ******************************************
# 5. Base recalibration
# ******************************************
$release_dir/bin/sentieon driver -r $fasta -t $nt -i realigned.bam --algo QualCal -k $dbsnp -k $known_sites recal_data.table
$release_dir/bin/sentieon driver -r $fasta -t $nt -i realigned.bam -q recal_data.table --algo QualCal -k $dbsnp -k $known_sites recal_data.table.post
$release_dir/bin/sentieon driver -t $nt --algo QualCal --plot --before recal_data.table --after recal_data.table.post recal.csv
$release_dir/bin/sentieon plot bqsr -o recal_plots.pdf recal.csv

# ******************************************
# 5b. Apply recalibration without interval
# to prevent loss of reads
# ******************************************
$release_dir/bin/sentieon driver -r $fasta -t $nt -i realigned.bam -q recal_data.table --algo ReadWriter recaled.bam

# ******************************************
# 6b. HC Variant caller
# ******************************************
if [ $run_joint == "yes" ]; then
 gvcf_option="--emit_mode gvcf"
fi
$release_dir/bin/sentieon driver -r $fasta --interval $regions -t $nt -i realigned.bam -q recal_data.table --algo Haplotyper -d $dbsnp --emit_conf=10 --call_conf=30 $gvcf_option output-hc.vcf

