#convert gatk-called gvcf to vcf
#!/bin/sh

#Constant and Enviroment
refseq="/data/home/lijiaj/reference/combined_ucsc-hg19_EBV.fa"
sample_dir=/data/home/guoym/1-NPC_genomics_project/1-NPC_WGS_data/4-variant_calling
work_dir=/data/home/lijiaj/data/guoymProject/analysis/truth_gatk

#Main
module load java/1.8.0_60
cd /data/home/lijiaj/data/guoymProject/sample/1X
for i in *
do
  gvcf_EBV=HC_$i\_EBV_raw-snps-indels_g.vcf
  gvcf_human=HC_$i\_human_raw-snps-indels_g.vcf
  cd $work_dir
  java -jar ~/software/GenomeAnalysisTK-3.4-46/GenomeAnalysisTK.jar -T GenotypeGVCFs -R $refseq --variant $sample_dir/$gvcf_human -o $i.human.vcf
  java -jar ~/software/GenomeAnalysisTK-3.4-46/GenomeAnalysisTK.jar -T GenotypeGVCFs -R $refseq --variant $sample_dir/$gvcf_EBV -o $i.EBV.vcf
done
