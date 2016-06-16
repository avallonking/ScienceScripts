#call variants for indel checking
#!/bin/sh
module load java/1.8.0_60
for i in *.mapped.bam
do
  name=`echo $i | cut -d . -f 2`
  #/data/home/lijiaj/software/samtools/bin/samtools index $i && \
  java -jar /data/home/lijiaj/software/GenomeAnalysisTK-3.4-46/GenomeAnalysisTK.jar -T BaseRecalibrator -R /data/home/lijiaj/reference/ucsc.hg19.fasta -I $i -knownSites /data/home/lijiaj/reference/1000G_phase1.indels.hg19.sites.vcf -knownSites /data/home/lijiaj/reference/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf -knownSites /data/home/lijiaj/reference/dbsnp_138.hg19.vcf -o $name.table && \
  java -jar /data/home/lijiaj/software/GenomeAnalysisTK-3.4-46/GenomeAnalysisTK.jar -T PrintReads -R /data/home/lijiaj/reference/ucsc.hg19.fasta -I $i -BQSR ./$name.table -o ./$name.BQSR.bam && \
  java -jar /data/home/lijiaj/software/GenomeAnalysisTK-3.4-46/GenomeAnalysisTK.jar -T HaplotypeCaller -R /data/home/lijiaj/reference/ucsc.hg19.fasta -I $name.BQSR.bam -o $name.vcf --genotyping_mode DISCOVERY --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 -stand_call_conf 30 -stand_emit_conf 10 -out_mode EMIT_ALL_SITES -pcrModel AGGRESSIVE --min_base_quality_score 10 --bamWriterType CALLED_HAPLOTYPES --dbsnp /data/home/lijiaj/reference/dbsnp_138.hg19.vcf -L /data/home/lijiaj/reference/Captured-regions_Nibergen_HG19_ExomeV3_UTR_flank_100bp.bed -nct 16 && \
  /data/home/lijiaj/software/vcfsorter/vcfsorter.pl /data/home/lijiaj/reference/ucsc.hg19.dict $name.vcf > $name.sorted.vcf
  bgzip $name.sorted.vcf > $name.sorted.vcf.gz
  tabix -p vcf $name.sorted.vcf.gz
done
#/data/home/lijiaj/software/bcftools/bin/bcftools merge -m all -O v -o merged.vcf
