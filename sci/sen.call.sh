#call variants with sentieon
#!/bin/sh

#Constant and Enviroment
refseq="/data/home/lijiaj/reference/combined_ucsc-hg19_EBV.fa"
dbsnp="/data/home/lijiaj/reference/dbsnp_138.hg19.vcf"
regions_human="/data/home/lijiaj/reference/wholegenomeregions_human.bed"
regions_EBV="/data/home/lijiaj/reference/wholegenomeregions_EBV.bed"
sample_dir=/data/home/guoym/1-NPC_genomics_project/1-NPC_WGS_data/3-GATK
release_dir=/share/apps/sentieon/201603
work_dir=/data/home/lijiaj/data/guoymProject/analysis/truth_sentieon
gvcf_option="--emit_mode gvcf"
export SENTIEON_LICENSE=login01.hpc.sysu:8990

#Main
cd /data/home/lijiaj/data/guoymProject/sample/1X
for i in *
do
  #cd $work_dir
  #test -e $i.human.vcf && continue
  bamfile=$i\_sorted_PCRremoved_realigned_recal.bam
  #$release_dir/bin/sentieon driver -r $refseq --interval $regions_human -t 10 -i $sample_dir/$bamfile --algo Haplotyper -d $dbsnp $gvcf_option --emit_conf=30 --call_conf=30 $i.human.g.vcf
  $release_dir/bin/sentieon driver -r $refseq --interval $regions_EBV -t 10 -i $sample_dir/$bamfile --algo Haplotyper -d $dbsnp $gvcf_option --emit_conf=30 --call_conf=30 $i.EBV.g.vcf
  $release_dir/bin/sentieon driver -r $refseq --interval $regions_EBV -t 10 -i $sample_dir/$bamfile --algo Haplotyper -d $dbsnp --emit_conf=30 --call_conf=30 $i.EBV.vcf
  #$release_dir/bin/sentieon driver -r $refseq -t 10 --algo GVCFtyper -v $i.human.g.vcf -d $dbsnp $i.human.vcf
  $release_dir/bin/sentieon driver -r $refseq -t 10 --algo GVCFtyper -v $i.EBV.g.vcf -d $dbsnp $i.EBV.combine.vcf
  #rm $i.human.g.vcf $i.EBV.g.vcf
done
